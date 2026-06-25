from __future__ import annotations

import threading
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

from app.services.parser_service import ParserService
from core.layer_detector import detect_layer, detect_layer_str
from core.models import TableInfo
from core.procedure_parser import EnhancedProcedureParser


class TestParserServiceConcurrency:
    def test_executor_uses_configured_workers(self, tmp_path: Path):
        parser = ParserService(
            data_dir=str(tmp_path / "data"),
            schema_dirs=[],
            output_dir=str(tmp_path / "output"),
        )
        assert parser._executor is not None
        assert parser._executor._max_workers == parser._datasource_workers
        assert parser._datasource_workers == 6
        parser.shutdown()

    def test_executor_is_instance_variable(self, tmp_path: Path):
        parser_a = ParserService(
            data_dir=str(tmp_path / "data_a"),
            schema_dirs=[],
            output_dir=str(tmp_path / "output_a"),
        )
        parser_b = ParserService(
            data_dir=str(tmp_path / "data_b"),
            schema_dirs=[],
            output_dir=str(tmp_path / "output_b"),
        )
        assert parser_a._executor is not parser_b._executor
        parser_a.shutdown()
        parser_b.shutdown()

    def test_shutdown_closes_executor(self, tmp_path: Path):
        parser = ParserService(
            data_dir=str(tmp_path / "data"),
            schema_dirs=[],
            output_dir=str(tmp_path / "output"),
        )
        executor = parser._executor
        assert executor is not None

        parser.shutdown()

        assert parser._executor is None
        assert executor._shutdown

    def test_shutdown_idempotent(self, tmp_path: Path):
        parser = ParserService(
            data_dir=str(tmp_path / "data"),
            schema_dirs=[],
            output_dir=str(tmp_path / "output"),
        )
        parser.shutdown()
        parser.shutdown()
        assert parser._executor is None

    def test_no_shared_class_variable(self):
        assert not hasattr(ParserService, "_shared_executor")


# ---------------------------------------------------------------------------
# T01: procedure_parser cache thread safety
# ---------------------------------------------------------------------------
_PRC_TEMPLATE = """\
CREATE OR REPLACE PROCEDURE {schema}.{name}
-- 功能描述: test procedure {name}
IS
  V_STEP NUMBER := 0;
BEGIN
  V_STEP := 1;
  INSERT INTO {schema}.TGT_{name} (COL_A, COL_B)
  SELECT A.COL1, B.COL2
  FROM {schema}.SRC_{name}_A A
  JOIN {schema}.SRC_{name}_B B ON A.ID = B.ID;
  COMMIT;
END;
/"""


def _write_prc_files(tmp_path: Path, count: int) -> str:
    """Write *count* distinct .prc files and return the directory path."""
    prc_dir = tmp_path / "prc"
    prc_dir.mkdir(parents=True, exist_ok=True)
    for i in range(count):
        schema = "TEST_SCHEMA"
        name = f"PRC_{i:04d}"
        (prc_dir / f"{name}.prc").write_text(
            _PRC_TEMPLATE.format(schema=schema, name=name),
            encoding="utf-8",
        )
    return str(prc_dir)


class TestProcedureParserCacheConcurrency:
    """Verify EnhancedProcedureParser cache is safe under concurrent parsing."""

    def test_concurrent_parse_directory_no_data_corruption(self, tmp_path: Path):
        """parse_directory uses a thread pool; each proc_info must carry its own data."""
        prc_dir = _write_prc_files(tmp_path, 8)
        parser = EnhancedProcedureParser(tables={})
        results = parser.parse_directory(prc_dir)

        assert len(results) == 8
        for full_name, proc_info in results.items():
            # Each proc_info should have its own _parsed_content
            assert hasattr(proc_info, '_parsed_content'), (
                f"{full_name} missing _parsed_content"
            )
            assert hasattr(proc_info, '_parsed_operations'), (
                f"{full_name} missing _parsed_operations"
            )
            # The content must belong to this proc, not another
            assert proc_info.proc_name in proc_info._parsed_content

    def test_extract_caliber_uses_proc_private_data(self, tmp_path: Path):
        """extract_caliber_from_proc should prefer proc_info private data over shared cache."""
        prc_dir = _write_prc_files(tmp_path, 1)
        parser = EnhancedProcedureParser(tables={})
        results = parser.parse_directory(prc_dir)
        proc_info = next(iter(results.values()))

        # Even if we clear the shared cache, extract_caliber_from_proc should
        # still work because it uses proc_info._parsed_content/_parsed_operations.
        parser._last_parse_cache.clear()
        calibers = parser.extract_caliber_from_proc(proc_info)
        # Should not raise, and returns a list (possibly empty if no mappings)
        assert isinstance(calibers, list)

    def test_concurrent_parse_prc_file_isolation(self, tmp_path: Path):
        """Multiple threads calling parse_prc_file must not corrupt each other's cache."""
        prc_dir = _write_prc_files(tmp_path, 4)
        parser = EnhancedProcedureParser(tables={})
        prc_files = sorted(Path(prc_dir).rglob("*.prc"))
        collected: dict[str, object] = {}
        errors: list[Exception] = []

        def _parse(fp):
            return parser.parse_prc_file(str(fp))

        with ThreadPoolExecutor(max_workers=4) as executor:
            futures = {executor.submit(_parse, fp): fp for fp in prc_files}
            for future in as_completed(futures):
                try:
                    proc_info = future.result()
                    if proc_info is not None:
                        collected[proc_info.full_name] = proc_info
                except Exception as e:
                    errors.append(e)

        assert not errors, f"Unexpected errors: {errors}"
        assert len(collected) == 4
        # Verify each proc_info has isolated data
        for name, pi in collected.items():
            assert hasattr(pi, '_parsed_content')
            assert pi.proc_name in pi._parsed_content


# ---------------------------------------------------------------------------
# T02: layer_detector singleton thread safety
# ---------------------------------------------------------------------------
class TestLayerDetectorConcurrency:
    """Verify detect_layer() is safe under concurrent calls."""

    def test_concurrent_detect_layer_consistent(self):
        """Multiple threads calling detect_layer() must all get consistent results."""
        test_tables = [
            "RRP_MDL.M_CUST_IND",
            "RRP_ODS.ODS_ACCT",
            "RRP_EAST.EAST5_201_GRJCXXB",
            "RRP_BASE.BASE_LOAN",
        ]
        # Warm up the singleton so all threads use the same instance
        _ = detect_layer(test_tables[0])

        results: dict[str, list[str]] = {t: [] for t in test_tables}
        lock = threading.Lock()
        errors: list[Exception] = []

        def _detect(table):
            try:
                layer = detect_layer(table)
                with lock:
                    results[table].append(layer.value)
            except Exception as e:
                with lock:
                    errors.append(e)

        with ThreadPoolExecutor(max_workers=8) as executor:
            futures = []
            for _ in range(20):
                for t in test_tables:
                    futures.append(executor.submit(_detect, t))
            for f in as_completed(futures):
                f.result()  # propagate unexpected exceptions

        assert not errors, f"Unexpected errors: {errors}"
        # All calls for the same table must return the same layer
        for table, layers in results.items():
            assert len(set(layers)) == 1, (
                f"Inconsistent layers for {table}: {set(layers)}"
            )

    def test_concurrent_detect_layer_str_no_crash(self):
        """detect_layer_str() must not crash under concurrent calls."""
        errors: list[Exception] = []

        def _call():
            try:
                detect_layer_str("RRP_MDL.M_TEST_TABLE")
            except Exception as e:
                errors.append(e)

        threads = [threading.Thread(target=_call) for _ in range(16)]
        for t in threads:
            t.start()
        for t in threads:
            t.join()

        assert not errors, f"Unexpected errors: {errors}"
