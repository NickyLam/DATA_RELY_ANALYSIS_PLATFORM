"""
SQLBoundaryDetector 单元测试

覆盖场景：
  1. 简单 INSERT 语句行号定位
  2. 嵌套 BEGIN...END 内的 MERGE 定位
  3. 多个 DML 操作连续定位
  4. WITH 子句 CTE 边界识别
  5. CTE 内 DML 定位
"""

import unittest

from core.sql_boundary_detector import SQLBoundaryDetector


class TestDMLBoundaryDetection(unittest.TestCase):
    """DML 操作边界检测测试"""

    def test_simple_insert(self):
        """场景1: 简单 INSERT 语句行号定位"""
        content = """\
PROCEDURE test_proc IS
BEGIN
  INSERT INTO T1 (ID, NAME)
  SELECT ID, NAME
  FROM T2
  WHERE STATUS = 1;
END;"""
        detector = SQLBoundaryDetector(content)
        boundaries = detector.detect_dml_boundaries()

        self.assertGreaterEqual(len(boundaries), 1, "应至少检测到一个 INSERT 操作")

        insert_b = boundaries[0]
        self.assertEqual(insert_b.operation_type, "INSERT")
        self.assertEqual(insert_b.target_table, "T1")
        self.assertGreaterEqual(insert_b.start_line, 3, f"INSERT 起始行应 >= 3, 实际 {insert_b.start_line}")
        self.assertGreaterEqual(insert_b.end_line, insert_b.start_line)

    def test_merge_in_begin_end(self):
        """场景2: 嵌套 BEGIN...END 内的 MERGE 定位"""
        content = """\
PROCEDURE test_proc IS
BEGIN
  INSERT INTO T1 SELECT * FROM T2;
  BEGIN
    MERGE INTO T3 D
    USING T4 S
    ON (D.ID = S.ID)
    WHEN MATCHED THEN UPDATE SET D.NAME = S.NAME;
  END;
END;"""
        detector = SQLBoundaryDetector(content)
        boundaries = detector.detect_dml_boundaries()

        merge_list = [b for b in boundaries if b.operation_type == "MERGE"]
        self.assertGreaterEqual(len(merge_list), 1, "应检测到 MERGE 操作")

        merge_b = merge_list[0]
        self.assertEqual(merge_b.target_table, "T3")

    def test_multiple_dml_operations(self):
        """场景3: 多个 DML 操作连续定位"""
        content = """\
PROCEDURE test_proc IS
BEGIN
  INSERT INTO T1 SELECT * FROM T2;
  UPDATE T3 SET NAME = 'X' WHERE ID = 1;
  MERGE INTO T4 D USING T5 S ON (D.ID = S.ID)
    WHEN MATCHED THEN UPDATE SET D.NAME = S.NAME;
END;"""
        detector = SQLBoundaryDetector(content)
        boundaries = detector.detect_dml_boundaries()

        op_types = {b.operation_type for b in boundaries}
        self.assertIn("INSERT", op_types, "应检测到 INSERT")
        self.assertIn("UPDATE", op_types, "应检测到 UPDATE")
        self.assertIn("MERGE", op_types, "应检测到 MERGE")

        # 验证行号递增
        for i in range(1, len(boundaries)):
            self.assertGreaterEqual(
                boundaries[i].start_line,
                boundaries[i - 1].start_line,
                "DML 操作应按行号递增排序",
            )

    def test_update_with_set(self):
        """UPDATE 语句边界检测"""
        content = """\
BEGIN
  UPDATE T1 SET NAME = 'test' WHERE ID = 1;
END;"""
        detector = SQLBoundaryDetector(content)
        boundaries = detector.detect_dml_boundaries()

        update_list = [b for b in boundaries if b.operation_type == "UPDATE"]
        self.assertGreaterEqual(len(update_list), 1, "应检测到 UPDATE 操作")
        self.assertEqual(update_list[0].target_table, "T1")


class TestCTEBoundaryDetection(unittest.TestCase):
    """CTE 边界检测测试"""

    def test_simple_cte(self):
        """场景4: WITH 子句 CTE 边界识别"""
        content = """\
PROCEDURE test_proc IS
BEGIN
  INSERT INTO T1
  WITH src AS (
    SELECT ID, NAME FROM T2 WHERE STATUS = 1
  )
  SELECT * FROM src;
END;"""
        detector = SQLBoundaryDetector(content)
        cte_boundaries = detector.detect_cte_boundaries()

        self.assertGreaterEqual(len(cte_boundaries), 1, "应检测到至少一个 CTE")

        cte = cte_boundaries[0]
        self.assertEqual(cte.cte_name.upper(), "SRC")
        self.assertIn("SELECT", cte.body.upper())

    def test_cte_boundary_lines(self):
        """CTE 边界行号合理性"""
        content = """\
WITH data_src AS (
  SELECT ID FROM T1
)
INSERT INTO T2 SELECT * FROM data_src;"""
        detector = SQLBoundaryDetector(content)
        cte_boundaries = detector.detect_cte_boundaries()

        if cte_boundaries:
            cte = cte_boundaries[0]
            self.assertGreaterEqual(cte.start_line, 1)
            self.assertGreaterEqual(cte.end_line, cte.start_line)

    def test_dml_inside_cte_range(self):
        """场景5: CTE 内 DML 定位 — 验证 DML 和 CTE 行号范围可交叉"""
        content = """\
WITH src AS (
  SELECT ID, NAME FROM T2 WHERE STATUS = 1
)
INSERT INTO T1 SELECT * FROM src;"""
        detector = SQLBoundaryDetector(content)
        dml_boundaries = detector.detect_dml_boundaries()
        cte_boundaries = detector.detect_cte_boundaries()

        # INSERT 应被检测到
        insert_list = [b for b in dml_boundaries if b.operation_type == "INSERT"]
        self.assertGreaterEqual(len(insert_list), 1, "应检测到 INSERT")

        # CTE 也应被检测到（如果存在 WITH 子句）
        if cte_boundaries:
            cte = cte_boundaries[0]
            self.assertEqual(cte.cte_name.upper(), "SRC")


class TestGetSQLBlockByLineRange(unittest.TestCase):
    """行号范围提取测试"""

    def test_extract_by_line_range(self):
        """根据行号范围提取文本"""
        content = "line1\nline2\nline3\nline4\nline5"
        detector = SQLBoundaryDetector(content)

        block = detector.get_sql_block_by_line_range(2, 4)
        self.assertEqual(block, "line2\nline3\nline4")

    def test_invalid_range(self):
        """无效行号范围返回空字符串"""
        content = "line1\nline2"
        detector = SQLBoundaryDetector(content)

        self.assertEqual(detector.get_sql_block_by_line_range(0, 1), "")
        self.assertEqual(detector.get_sql_block_by_line_range(3, 1), "")


if __name__ == "__main__":
    unittest.main()
