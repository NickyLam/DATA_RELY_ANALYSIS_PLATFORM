"""
测试配置和 Fixtures
"""

import sys
from pathlib import Path

import pytest

# 添加项目根目录到 Python 路径
sys.path.insert(0, str(Path(__file__).parent.parent))


@pytest.fixture
def sample_test_table():
    """测试用的表名"""
    return "RRP_MDL.ICL_CMM_XXX"


@pytest.fixture
def sample_test_field():
    """测试用的字段名"""
    return "XXX_ID"


@pytest.fixture
def sample_indicator_no():
    """测试用的指标编号"""
    return "FM0100011"


@pytest.fixture
def test_data_dir(tmp_path):
    """测试数据目录"""
    return tmp_path / "test_data"


@pytest.fixture
def sample_tab_content():
    """示例 .tab 文件内容"""
    return """-- TABLE STRUCTURE
CREATE TABLE TEST_TABLE (
    ID NUMBER(10) PRIMARY KEY,
    NAME VARCHAR2(100),
    CREATE_DATE DATE
);
"""


@pytest.fixture
def sample_prc_content():
    """示例 .prc 文件内容"""
    return """CREATE OR REPLACE PROCEDURE TEST_PROC AS
BEGIN
    INSERT INTO TARGET_TABLE (ID, NAME)
    SELECT ID, NAME FROM SOURCE_TABLE;
END;
"""
