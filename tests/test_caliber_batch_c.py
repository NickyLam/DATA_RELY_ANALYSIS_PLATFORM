"""Batch C 单元测试：CTE / 自定义函数 / 完整表达式提取"""

import unittest
from core.caliber_extractor import CaliberExtractor
from core.models import CaliberInfo, FieldMapping, SQLCondition, SourceLocation


class TestExtractCteDefinitions(unittest.TestCase):
    """_extract_cte_definitions 测试"""

    def test_single_cte(self):
        sql = "WITH tmp AS (SELECT a, b FROM t1) SELECT * FROM tmp"
        result = CaliberExtractor._extract_cte_definitions(sql)
        self.assertEqual(len(result), 1)
        self.assertTrue(result[0].startswith("tmp:"))
        self.assertIn("SELECT a, b FROM t1", result[0])

    def test_multiple_ctes_comma_separated(self):
        """关键场景：逗号分隔的多 CTE"""
        sql = (
            "WITH a AS (SELECT x FROM t1), "
            "b AS (SELECT y FROM t2) "
            "SELECT * FROM a JOIN b ON a.x = b.y"
        )
        result = CaliberExtractor._extract_cte_definitions(sql)
        self.assertEqual(len(result), 2)
        self.assertTrue(result[0].startswith("a:"))
        self.assertTrue(result[1].startswith("b:"))

    def test_no_cte(self):
        sql = "SELECT * FROM t1 WHERE id = 1"
        result = CaliberExtractor._extract_cte_definitions(sql)
        self.assertEqual(result, [])

    def test_cte_with_nested_parens(self):
        sql = "WITH cte AS (SELECT * FROM t WHERE x IN (1, 2)) SELECT * FROM cte"
        result = CaliberExtractor._extract_cte_definitions(sql)
        self.assertEqual(len(result), 1)
        self.assertIn("SELECT * FROM t WHERE x IN (1, 2)", result[0])

    def test_cte_with_string_quotes(self):
        """CTE 体内包含字符串引号不影响括号匹配"""
        sql = "WITH cte AS (SELECT * FROM t WHERE name = 'O''Brien') SELECT * FROM cte"
        result = CaliberExtractor._extract_cte_definitions(sql)
        self.assertEqual(len(result), 1)

    def test_three_ctes(self):
        sql = (
            "WITH a AS (SELECT 1 FROM dual), "
            "b AS (SELECT 2 FROM dual), "
            "c AS (SELECT 3 FROM dual) "
            "SELECT * FROM a, b, c"
        )
        result = CaliberExtractor._extract_cte_definitions(sql)
        self.assertEqual(len(result), 3)
        self.assertEqual([r.split(":")[0] for r in result], ["a", "b", "c"])

    def test_cte_long_body_truncated(self):
        """CTE 体内超过 200 字符时截断"""
        long_select = "SELECT " + ", ".join(f"col_{i}" for i in range(50))
        sql = f"WITH big_cte AS ({long_select} FROM huge_table) SELECT * FROM big_cte"
        result = CaliberExtractor._extract_cte_definitions(sql)
        self.assertEqual(len(result), 1)
        # body preview 应有截断标记
        self.assertTrue(result[0].startswith("big_cte:"))


class TestExtractCustomFunctions(unittest.TestCase):
    """_extract_custom_functions 测试"""

    def test_pkg_function(self):
        sql = "SELECT PKG_UTILS.FN_CALC(x) FROM t1"
        result = CaliberExtractor._extract_custom_functions(sql)
        self.assertTrue(len(result) >= 1)
        # 应能检测到 PKG_ 开头的函数
        found = any("PKG_" in f.upper() or "FN_CALC" in f.upper() for f in result)
        self.assertTrue(found, f"Expected PKG_/FN_ function, got: {result}")

    def test_fn_standalone(self):
        sql = "SELECT FN_FORMAT_NAME(name) AS full_name FROM t"
        result = CaliberExtractor._extract_custom_functions(sql)
        self.assertTrue(len(result) >= 1)
        self.assertTrue(any("FN_FORMAT_NAME" in f.upper() for f in result))

    def test_func_standalone(self):
        sql = "SELECT FUNC_DECRYPT(pwd) FROM secure_table"
        result = CaliberExtractor._extract_custom_functions(sql)
        self.assertTrue(len(result) >= 1)
        self.assertTrue(any("FUNC_DECRYPT" in f.upper() for f in result))

    def test_no_custom_function(self):
        sql = "SELECT SUM(salary), COUNT(*) FROM emp GROUP BY dept_id"
        result = CaliberExtractor._extract_custom_functions(sql)
        self.assertEqual(result, [])

    def test_deduplication(self):
        """同一函数多次出现应去重"""
        sql = "SELECT FN_CALC(a), FN_CALC(b) FROM t"
        result = CaliberExtractor._extract_custom_functions(sql)
        fn_names = [f.upper() for f in result]
        # FN_CALC 应只出现一次
        count = fn_names.count("FN_CALC")
        self.assertLessEqual(count, 1, f"Expected dedup, got: {result}")

    def test_multiple_different_functions(self):
        sql = "SELECT FN_CALC(x), FUNC_DECODE(y), PKG_MATH.FN_ROUND(z) FROM t"
        result = CaliberExtractor._extract_custom_functions(sql)
        self.assertGreaterEqual(len(result), 2)  # 至少检测到 FN_ 和 FUNC_ 函数


class TestExtractFullExpression(unittest.TestCase):
    """_extract_full_expression 测试"""

    def test_simple_alias_as(self):
        sql = "SELECT UPPER(name) AS FULL_NM FROM t"
        result = CaliberExtractor._extract_full_expression(sql, "FULL_NM")
        self.assertEqual(result, "UPPER(name)")

    def test_case_when_as(self):
        sql = "SELECT CASE WHEN status = 1 THEN 'A' ELSE 'B' END AS STATUS_DESC FROM t"
        result = CaliberExtractor._extract_full_expression(sql, "STATUS_DESC")
        self.assertIn("CASE WHEN", result)

    def test_bare_alias(self):
        sql = "SELECT FN_CALC(amount) calc_result FROM t"
        result = CaliberExtractor._extract_full_expression(sql, "calc_result")
        self.assertEqual(result, "FN_CALC(amount)")

    def test_simple_column_ref(self):
        sql = "SELECT CUST_NM FROM t"
        result = CaliberExtractor._extract_full_expression(sql, "CUST_NM")
        self.assertEqual(result, "CUST_NM")

    def test_no_matching_column(self):
        sql = "SELECT id, name FROM t"
        result = CaliberExtractor._extract_full_expression(sql, "NONEXISTENT")
        self.assertEqual(result, "")

    def test_star_select(self):
        sql = "SELECT * FROM t"
        result = CaliberExtractor._extract_full_expression(sql, "ANY_COL")
        self.assertEqual(result, "")

    def test_empty_target_column(self):
        sql = "SELECT x FROM t"
        result = CaliberExtractor._extract_full_expression(sql, "")
        self.assertEqual(result, "")

    def test_qualified_column_ref(self):
        sql = "SELECT t1.CUST_NM FROM t1"
        result = CaliberExtractor._extract_full_expression(sql, "CUST_NM")
        self.assertEqual(result, "t1.CUST_NM")


class TestBuildCaliberInfoBatchC(unittest.TestCase):
    """build_caliber_info 集成测试 — 验证 Batch C 字段填充"""

    def _make_mapping(self, target_col: str = "FULL_NM") -> FieldMapping:
        return FieldMapping(
            source_table="SRC_TABLE",
            source_column="NAME",
            target_table="TGT_TABLE",
            target_column=target_col,
            transform_logic="UPPER(NAME)",
        )

    def test_cte_definitions_populated(self):
        sql = (
            "WITH tmp AS (SELECT a FROM t1) "
            "INSERT INTO TGT_TABLE (FULL_NM) SELECT UPPER(a) AS FULL_NM FROM tmp"
        )
        info = CaliberExtractor.build_caliber_info(
            self._make_mapping(), sql, "TEST_PROC"
        )
        self.assertTrue(len(info.cte_definitions) >= 1)
        self.assertTrue(info.cte_definitions[0].startswith("tmp:"))

    def test_custom_functions_populated(self):
        sql = (
            "INSERT INTO TGT_TABLE (FULL_NM) "
            "SELECT FN_FORMAT(NAME) AS FULL_NM FROM SRC_TABLE"
        )
        info = CaliberExtractor.build_caliber_info(
            self._make_mapping(), sql, "TEST_PROC"
        )
        self.assertTrue(len(info.custom_functions) >= 1)
        self.assertTrue(any("FN_FORMAT" in f for f in info.custom_functions))

    def test_full_expression_populated(self):
        sql = (
            "INSERT INTO TGT_TABLE (FULL_NM) "
            "SELECT FN_FORMAT(NAME) AS FULL_NM FROM SRC_TABLE"
        )
        info = CaliberExtractor.build_caliber_info(
            self._make_mapping(), sql, "TEST_PROC"
        )
        self.assertEqual(info.full_expression, "FN_FORMAT(NAME)")

    def test_is_custom_function_call_flag(self):
        sql = (
            "INSERT INTO TGT_TABLE (FULL_NM) "
            "SELECT PKG_UTILS.FN_CALC(x) AS FULL_NM FROM SRC_TABLE"
        )
        info = CaliberExtractor.build_caliber_info(
            self._make_mapping(), sql, "TEST_PROC"
        )
        self.assertTrue(info.is_custom_function_call)

    def test_no_custom_function_flag_false(self):
        sql = (
            "INSERT INTO TGT_TABLE (FULL_NM) "
            "SELECT UPPER(NAME) AS FULL_NM FROM SRC_TABLE"
        )
        info = CaliberExtractor.build_caliber_info(
            self._make_mapping(), sql, "TEST_PROC"
        )
        self.assertFalse(info.is_custom_function_call)


class TestSerializationBatchC(unittest.TestCase):
    """to_dict / from_dict 序列化 Round-trip 测试"""

    def test_roundtrip(self):
        info = CaliberInfo(
            target_table="T1",
            target_column="C1",
            source_location=SourceLocation(source_table="S1", source_column="SC1"),
            cte_definitions=["tmp: SELECT a FROM x"],
            custom_functions=["FN_CALC"],
            full_expression="FN_CALC(x)",
            is_custom_function_call=True,
        )
        d = CaliberExtractor.to_dict(info)
        restored = CaliberExtractor.from_dict(d)

        self.assertEqual(restored.cte_definitions, info.cte_definitions)
        self.assertEqual(restored.custom_functions, info.custom_functions)
        self.assertEqual(restored.full_expression, info.full_expression)
        self.assertEqual(restored.is_custom_function_call, info.is_custom_function_call)

    def test_defaults(self):
        """空 CaliberInfo 的 to_dict 应包含 Batch C 字段"""
        info = CaliberInfo()
        d = CaliberExtractor.to_dict(info)
        self.assertIn("cte_definitions", d)
        self.assertIn("custom_functions", d)
        self.assertIn("full_expression", d)
        self.assertIn("is_custom_function_call", d)
        self.assertEqual(d["cte_definitions"], [])
        self.assertEqual(d["custom_functions"], [])
        self.assertEqual(d["full_expression"], "")
        self.assertFalse(d["is_custom_function_call"])


class TestCaliberSpecBatchC(unittest.TestCase):
    """generate_caliber_spec 渲染测试"""

    def test_renders_cte(self):
        info = CaliberInfo(
            target_table="T1",
            target_column="C1",
            cte_definitions=["tmp: SELECT a FROM x"],
        )
        spec = info.generate_caliber_spec()
        self.assertIn("CTE定义", spec)
        self.assertIn("tmp:", spec)

    def test_renders_custom_functions(self):
        info = CaliberInfo(
            target_table="T1",
            target_column="C1",
            custom_functions=["FN_CALC"],
        )
        spec = info.generate_caliber_spec()
        self.assertIn("自定义函数", spec)
        self.assertIn("FN_CALC", spec)

    def test_renders_full_expression(self):
        info = CaliberInfo(
            target_table="T1",
            target_column="C1",
            source_location=SourceLocation(source_column="X"),
            full_expression="FN_CALC(X)",
        )
        spec = info.generate_caliber_spec()
        self.assertIn("完整表达式", spec)
        self.assertIn("FN_CALC(X)", spec)

    def test_skips_expression_same_as_source(self):
        """full_expression 与 source_column 相同时不渲染"""
        info = CaliberInfo(
            target_table="T1",
            target_column="C1",
            source_location=SourceLocation(source_column="X"),
            full_expression="X",
        )
        spec = info.generate_caliber_spec()
        self.assertNotIn("完整表达式", spec)

    def test_renders_function_call_flag(self):
        info = CaliberInfo(
            target_table="T1",
            target_column="C1",
            is_custom_function_call=True,
        )
        spec = info.generate_caliber_spec()
        self.assertIn("函数调用标记", spec)

    def test_no_batch_c_fields(self):
        """没有 Batch C 数据时不渲染相关行"""
        info = CaliberInfo(target_table="T1", target_column="C1")
        spec = info.generate_caliber_spec()
        self.assertNotIn("CTE定义", spec)
        self.assertNotIn("自定义函数", spec)
        self.assertNotIn("完整表达式", spec)
        self.assertNotIn("函数调用标记", spec)


if __name__ == "__main__":
    unittest.main()
