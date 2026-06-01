from __future__ import annotations

from pathlib import Path

from app.services.parser_service import ParserService


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
