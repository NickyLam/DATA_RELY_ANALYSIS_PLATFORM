"""Tests for core/pam/pam_dml_parser.py.

Covers T06 (INSERT field mapping enhancement) and T07 (DELETE handling):
  - simple column INSERT
  - multi-source JOIN INSERT (alias → source table resolution)
  - aliased SELECT column (expr AS alias)
  - function expression INSERT (NVL/COALESCE wrapper)
  - DELETE + INSERT same target table
"""

from __future__ import annotations

from core.pam.pam_dml_parser import PamDMLParser


def _mappings(parser: PamDMLParser, sql: str, proc: str = "PAM.SP_TEST"):
    """Return field mappings produced by _parse_dml_from_sql."""
    _lineages, mappings = parser._parse_dml_from_sql(sql, proc)
    return mappings


def _lineages(parser: PamDMLParser, sql: str, proc: str = "PAM.SP_TEST"):
    """Return table lineages produced by _parse_dml_from_sql."""
    lineages, _mappings = parser._parse_dml_from_sql(sql, proc)
    return lineages


class TestPamDMLParserInsertFieldMapping:
    """T06: INSERT field mapping must resolve source tables by alias."""

    def setup_method(self):
        self.parser = PamDMLParser(default_schema="pam")

    def test_simple_column_single_source(self):
        """Simple bare column maps to the only source table."""
        sql = (
            "insert into pam.tgt (c1, c2) "
            "select col_a, col_b from pam.src"
        )
        mappings = _mappings(self.parser, sql)

        assert len(mappings) == 2
        by_target = {m["target_column"]: m for m in mappings}
        assert by_target["C1"]["source_table"] == "PAM.SRC"
        assert by_target["C1"]["source_column"] == "COL_A"
        assert by_target["C2"]["source_table"] == "PAM.SRC"
        assert by_target["C2"]["source_column"] == "COL_B"

    def test_multi_source_join_alias_resolution(self):
        """Columns qualified by alias must map to the correct source table."""
        sql = (
            "insert into pam.tgt (c1, c2) "
            "select a.col_a, b.col_b "
            "from pam.src_a a "
            "join pam.src_b b on a.id = b.id"
        )
        mappings = _mappings(self.parser, sql)

        assert len(mappings) == 2
        by_target = {m["target_column"]: m for m in mappings}
        # a.col_a → PAM.SRC_A
        assert by_target["C1"]["source_table"] == "PAM.SRC_A"
        assert by_target["C1"]["source_column"] == "COL_A"
        # b.col_b → PAM.SRC_B
        assert by_target["C2"]["source_table"] == "PAM.SRC_B"
        assert by_target["C2"]["source_column"] == "COL_B"

    def test_aliased_select_column(self):
        """SELECT expr AS alias must still resolve the underlying column."""
        sql = (
            "insert into pam.tgt (c1) "
            "select a.col_a as c1 from pam.src_a a"
        )
        mappings = _mappings(self.parser, sql)

        assert len(mappings) == 1
        assert mappings[0]["source_table"] == "PAM.SRC_A"
        assert mappings[0]["source_column"] == "COL_A"
        assert mappings[0]["target_column"] == "C1"

    def test_function_expression_nvl(self):
        """NVL(a.col, 0) must resolve to the inner column on the aliased table."""
        sql = (
            "insert into pam.tgt (c1) "
            "select nvl(a.col_a, 0) from pam.src_a a"
        )
        mappings = _mappings(self.parser, sql)

        assert len(mappings) == 1
        assert mappings[0]["source_table"] == "PAM.SRC_A"
        assert mappings[0]["source_column"] == "COL_A"
        assert mappings[0]["target_column"] == "C1"

    def test_function_expression_coalesce_multi_source(self):
        """COALESCE(a.x, b.y) — first resolvable column wins for the mapping."""
        sql = (
            "insert into pam.tgt (c1) "
            "select coalesce(a.col_a, b.col_b) "
            "from pam.src_a a join pam.src_b b on a.id = b.id"
        )
        mappings = _mappings(self.parser, sql)

        assert len(mappings) == 1
        assert mappings[0]["source_table"] == "PAM.SRC_A"
        assert mappings[0]["source_column"] == "COL_A"

    def test_case_when_not_mapped_but_recorded(self):
        """CASE WHEN expressions have no single source column; no field mapping."""
        sql = (
            "insert into pam.tgt (c1) "
            "select case when a.flag = 1 then a.val else 0 end "
            "from pam.src_a a"
        )
        mappings = _mappings(self.parser, sql)
        # CASE WHEN cannot be resolved to a single column → no mapping
        assert mappings == []

    def test_table_level_lineage_still_extracted(self):
        """Table-level lineage must still list all source tables."""
        sql = (
            "insert into pam.tgt (c1, c2) "
            "select a.col_a, b.col_b "
            "from pam.src_a a join pam.src_b b on a.id = b.id"
        )
        lineages = _lineages(self.parser, sql)
        sources = {lg["source_table"] for lg in lineages}
        assert "PAM.SRC_A" in sources
        assert "PAM.SRC_B" in sources
        assert all(lg["target_table"] == "PAM.TGT" for lg in lineages)

    def test_column_count_mismatch_no_mapping(self):
        """When target and select column counts differ, no field mapping."""
        sql = (
            "insert into pam.tgt (c1, c2, c3) "
            "select a.col_a, a.col_b from pam.src_a a"
        )
        mappings = _mappings(self.parser, sql)
        assert mappings == []


class TestPamDMLParserDeleteHandling:
    """T07: DELETE FROM must be observable, not silently dropped."""

    def setup_method(self):
        self.parser = PamDMLParser(default_schema="pam")

    def test_delete_only_produces_no_lineage(self):
        """A standalone DELETE produces no source→target lineage."""
        sql = "delete from pam.tgt where dt = 20200101"
        lineages = _lineages(self.parser, sql)
        assert lineages == []

    def test_delete_then_insert_same_target(self):
        """DELETE + INSERT on the same target must keep INSERT lineage/mappings."""
        delete_sql = "delete from pam.tgt where dt = 20200101"
        insert_sql = (
            "insert into pam.tgt (c1) "
            "select a.col_a from pam.src_a a"
        )

        # DELETE alone: no lineage
        assert _lineages(self.parser, delete_sql) == []

        # INSERT after DELETE: lineage and mappings intact
        insert_lineages = _lineages(self.parser, insert_sql)
        assert len(insert_lineages) == 1
        assert insert_lineages[0]["source_table"] == "PAM.SRC_A"
        assert insert_lineages[0]["target_table"] == "PAM.TGT"

        insert_mappings = _mappings(self.parser, insert_sql)
        assert len(insert_mappings) == 1
        assert insert_mappings[0]["source_column"] == "COL_A"
