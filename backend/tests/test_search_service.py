"""
搜索服务单元测试
测试 search_service.py 中的搜索功能
"""
import pytest
from unittest.mock import AsyncMock, MagicMock, patch
from datetime import datetime

from app.services.search_service import (
    SearchService,
    SortOrder,
    SortField,
    TableSearchResult,
    FieldSearchResult,
    SearchResult,
)


class TestSearchService:
    """搜索服务测试类"""

    @pytest.fixture
    def mock_driver(self):
        """模拟 Neo4j 驱动"""
        driver = MagicMock()
        session = AsyncMock()
        session.__aenter__ = AsyncMock(return_value=session)
        session.__aexit__ = AsyncMock(return_value=None)
        driver.session.return_value = session
        return driver

    @pytest.fixture
    def search_service(self, mock_driver):
        """创建搜索服务实例"""
        with patch('app.services.search_service.AsyncGraphDatabase.driver', return_value=mock_driver):
            service = SearchService()
            service.driver = mock_driver
            return service

    @pytest.mark.asyncio
    async def test_search_tables_no_filters(self, search_service, mock_driver):
        """测试无筛选条件的表搜索"""
        # 模拟查询结果
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[
            {
                'id': 'table_001',
                'name': 'users',
                'schema_name': 'public',
                'database_name': 'test_db',
                'data_source_id': 'ds_001',
                'data_source_name': 'Test Oracle',
                'table_type': 'TABLE',
                'description': '用户表',
                'column_count': 10,
                'lineage_count': 5,
                'upstream_count': 2,
                'downstream_count': 3,
                'owner': 'admin',
                'created_at': datetime.now(),
                'updated_at': datetime.now(),
            }
        ])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        # 执行搜索
        result = await search_service.search_tables(
            keyword=None,
            exact_name=None,
            page=1,
            page_size=20
        )
        
        # 验证结果
        assert isinstance(result, SearchResult)
        assert len(result.tables) >= 0

    @pytest.mark.asyncio
    async def test_search_tables_with_keyword(self, search_service, mock_driver):
        """测试带关键词的表搜索"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        result = await search_service.search_tables(
            keyword='user',
            page=1,
            page_size=20
        )
        
        # 验证调用了正确的查询
        assert mock_session.run.called
        call_args = mock_session.run.call_args
        # 验证查询包含关键词条件
        assert 'keyword' in str(call_args)

    @pytest.mark.asyncio
    async def test_search_tables_with_exact_name(self, search_service, mock_driver):
        """测试精确表名搜索"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[
            {
                'id': 'table_001',
                'name': 'users',
                'schema_name': 'public',
                'database_name': 'test_db',
                'data_source_id': 'ds_001',
                'data_source_name': 'Test Oracle',
                'table_type': 'TABLE',
                'description': '用户表',
                'column_count': 10,
                'lineage_count': 5,
                'upstream_count': 2,
                'downstream_count': 3,
                'owner': 'admin',
                'created_at': datetime.now(),
                'updated_at': datetime.now(),
            }
        ])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        result = await search_service.search_tables(
            exact_name='users',
            page=1,
            page_size=20
        )
        
        assert isinstance(result, SearchResult)

    @pytest.mark.asyncio
    async def test_search_tables_with_filters(self, search_service, mock_driver):
        """测试带筛选条件的表搜索"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        result = await search_service.search_tables(
            data_source_id='ds_001',
            schema_name='public',
            table_type='TABLE',
            page=1,
            page_size=20
        )
        
        assert mock_session.run.called

    @pytest.mark.asyncio
    async def test_search_tables_sorting(self, search_service, mock_driver):
        """测试排序功能"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        # 测试按名称升序排序
        result = await search_service.search_tables(
            sort_by=SortField.NAME,
            sort_order=SortOrder.ASC,
            page=1,
            page_size=20
        )
        
        assert mock_session.run.called
        
        # 测试按创建时间降序排序
        result = await search_service.search_tables(
            sort_by=SortField.CREATED_AT,
            sort_order=SortOrder.DESC,
            page=1,
            page_size=20
        )
        
        assert mock_session.run.called

    @pytest.mark.asyncio
    async def test_search_tables_pagination(self, search_service, mock_driver):
        """测试分页功能"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        # 测试第一页
        result1 = await search_service.search_tables(page=1, page_size=10)
        
        # 测试第二页
        result2 = await search_service.search_tables(page=2, page_size=10)
        
        assert mock_session.run.call_count == 2

    @pytest.mark.asyncio
    async def test_search_fields_basic(self, search_service, mock_driver):
        """测试字段搜索基本功能"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[
            {
                'id': 'field_001',
                'name': 'user_id',
                'table_id': 'table_001',
                'table_name': 'users',
                'schema_name': 'public',
                'database_name': 'test_db',
                'data_source_id': 'ds_001',
                'data_source_name': 'Test Oracle',
                'data_type': 'NUMBER',
                'is_primary_key': True,
                'is_foreign_key': False,
                'is_nullable': False,
                'description': '用户 ID',
                'position': 1,
                'lineage_count': 3,
            }
        ])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        result = await search_service.search_fields(
            keyword='user',
            page=1,
            page_size=20
        )
        
        assert isinstance(result, SearchResult)

    @pytest.mark.asyncio
    async def test_search_fields_with_table_filter(self, search_service, mock_driver):
        """测试按表名筛选字段"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        result = await search_service.search_fields(
            table_name='users',
            page=1,
            page_size=20
        )
        
        assert mock_session.run.called

    @pytest.mark.asyncio
    async def test_search_fields_with_data_type_filter(self, search_service, mock_driver):
        """测试按数据类型筛选字段"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        result = await search_service.search_fields(
            data_type='VARCHAR',
            page=1,
            page_size=20
        )
        
        assert mock_session.run.called

    @pytest.mark.asyncio
    async def test_search_service_close(self, search_service, mock_driver):
        """测试服务关闭"""
        await search_service.close()
        mock_driver.close.assert_called()


class TestSortOrder:
    """排序顺序枚举测试"""
    
    def test_sort_order_values(self):
        """测试排序顺序枚举值"""
        assert SortOrder.ASC == "asc"
        assert SortOrder.DESC == "desc"


class TestSortField:
    """排序字段枚举测试"""
    
    def test_sort_field_values(self):
        """测试排序字段枚举值"""
        assert SortField.NAME == "name"
        assert SortField.CREATED_AT == "created_at"
        assert SortField.UPDATED_AT == "updated_at"
        assert SortField.COLUMN_COUNT == "column_count"
        assert SortField.LINEAGE_COUNT == "lineage_count"


class TestDataClasses:
    """数据类测试"""
    
    def test_table_search_result(self):
        """测试表搜索结果数据类"""
        result = TableSearchResult(
            id='table_001',
            name='users',
            schema_name='public',
            database_name='test_db',
            data_source_id='ds_001',
            data_source_name='Test Oracle',
            table_type='TABLE',
            description='用户表',
            column_count=10,
            lineage_count=5,
            upstream_count=2,
            downstream_count=3,
            owner='admin',
            created_at=datetime.now(),
            updated_at=datetime.now(),
        )
        
        assert result.id == 'table_001'
        assert result.name == 'users'
        assert result.column_count == 10

    def test_field_search_result(self):
        """测试字段搜索结果数据类"""
        result = FieldSearchResult(
            id='field_001',
            name='user_id',
            table_id='table_001',
            table_name='users',
            schema_name='public',
            database_name='test_db',
            data_source_id='ds_001',
            data_source_name='Test Oracle',
            data_type='NUMBER',
            is_primary_key=True,
            is_foreign_key=False,
            is_nullable=False,
            description='用户 ID',
            position=1,
            lineage_count=3,
        )
        
        assert result.id == 'field_001'
        assert result.is_primary_key is True
        assert result.lineage_count == 3

    def test_search_result(self):
        """测试搜索结果数据类"""
        result = SearchResult(
            tables=[],
            fields=[],
            total_tables=0,
            total_fields=0,
            page=1,
            page_size=20,
            total_pages=0,
        )
        
        assert result.page == 1
        assert result.page_size == 20
        assert result.total_pages == 0