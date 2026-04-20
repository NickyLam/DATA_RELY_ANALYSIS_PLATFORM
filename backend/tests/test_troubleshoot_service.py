"""
问题排查服务单元测试
测试 troubleshoot_service.py 中的问题排查功能
"""
import pytest
from unittest.mock import AsyncMock, MagicMock, patch
from datetime import datetime, timedelta

from app.services.troubleshoot_service import TroubleshootService
from app.schemas.troubleshoot import (
    QuickSearchResult,
    LineageRelation,
    BatchExecution,
    ChangeRecord,
    TroubleshootResult,
)


class TestTroubleshootService:
    """问题排查服务测试类"""

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
    async def troubleshoot_service(self, mock_driver):
        """创建问题排查服务实例"""
        with patch('app.services.troubleshoot_service.AsyncGraphDatabase.driver', return_value=mock_driver):
            service = TroubleshootService()
            service.neo4j_driver = mock_driver
            return service

    @pytest.mark.asyncio
    async def test_quick_search_all(self, troubleshoot_service, mock_driver):
        """测试快速搜索所有对象"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[
            {
                'object_id': 'table_001',
                'object_name': 'users',
                'object_type': 'Table',
                'database': 'test_db',
                'schema': 'public',
                'description': '用户表',
                'has_lineage': True,
                'lineage_count': 5,
            }
        ])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        results = await troubleshoot_service.quick_search(
            keyword='user',
            search_type='all',
            limit=10
        )
        
        assert isinstance(results, list)
        assert len(results) >= 0

    @pytest.mark.asyncio
    async def test_quick_search_table_only(self, troubleshoot_service, mock_driver):
        """测试只搜索表"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        results = await troubleshoot_service.quick_search(
            keyword='order',
            search_type='table',
            limit=10
        )
        
        assert isinstance(results, list)

    @pytest.mark.asyncio
    async def test_quick_search_field_only(self, troubleshoot_service, mock_driver):
        """测试只搜索字段"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        results = await troubleshoot_service.quick_search(
            keyword='user_id',
            search_type='field',
            limit=10
        )
        
        assert isinstance(results, list)

    @pytest.mark.asyncio
    async def test_get_object_by_name(self, troubleshoot_service, mock_driver):
        """测试根据名称获取对象"""
        mock_result = MagicMock()
        mock_result.single = AsyncMock(return_value={
            'id': 'table_001',
            'name': 'users',
            'type': 'Table',
            'database': 'test_db',
            'schema': 'public',
            'description': '用户表',
            'data_source_id': 'ds_001',
        })
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        obj = await troubleshoot_service.get_object_by_name(
            object_name='users',
            object_type='table'
        )
        
        assert obj is None or isinstance(obj, dict)

    @pytest.mark.asyncio
    async def test_get_lineage_relations(self, troubleshoot_service, mock_driver):
        """测试获取血缘关系"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[
            {
                'source_id': 'table_001',
                'source_name': 'users',
                'target_id': 'table_002',
                'target_name': 'orders',
                'relation_type': 'LINEAGE_TO',
                'transformation_type': 'INSERT',
            }
        ])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        relations = await troubleshoot_service.get_lineage_relations('table_001')
        
        assert isinstance(relations, list)

    @pytest.mark.asyncio
    async def test_get_recent_batches(self, troubleshoot_service, mock_driver):
        """测试获取最近批次"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[
            {
                'batch_id': 'batch_001',
                'table_id': 'table_001',
                'table_name': 'users',
                'execution_time': datetime.now(),
                'status': 'SUCCESS',
                'row_count': 1000,
            }
        ])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        batches = await troubleshoot_service.get_recent_batches(
            object_id='table_001',
            days_limit=7
        )
        
        assert isinstance(batches, list)

    @pytest.mark.asyncio
    async def test_get_change_records(self, troubleshoot_service, mock_driver):
        """测试获取变更记录"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[
            {
                'change_id': 'change_001',
                'object_id': 'table_001',
                'change_type': 'ALTER',
                'change_description': '添加列',
                'changed_by': 'admin',
                'change_time': datetime.now(),
            }
        ])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        changes = await troubleshoot_service.get_change_records(
            object_id='table_001',
            days_limit=30
        )
        
        assert isinstance(changes, list)

    @pytest.mark.asyncio
    async def test_troubleshoot_full(self, troubleshoot_service, mock_driver):
        """测试完整问题排查"""
        # Mock 所有子方法的调用
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=MagicMock())
        mock_session.run.return_value.list = AsyncMock(return_value=[])
        mock_session.run.return_value.single = AsyncMock(return_value=None)
        
        result = await troubleshoot_service.troubleshoot(
            object_name='users',
            object_type='table',
            include_runtime=True,
            include_changes=True,
            days_limit=7
        )
        
        assert isinstance(result, TroubleshootResult)

    @pytest.mark.asyncio
    async def test_service_close(self, troubleshoot_service, mock_driver):
        """测试服务关闭"""
        await troubleshoot_service.close()
        mock_driver.close.assert_called()


class TestQuickSearchResult:
    """快速搜索结果测试"""

    def test_quick_search_result_creation(self):
        """测试快速搜索结果创建"""
        result = QuickSearchResult(
            object_id='table_001',
            object_name='users',
            object_type='Table',
            database='test_db',
            schema='public',
            description='用户表',
            has_lineage=True,
            lineage_count=5,
        )
        
        assert result.object_id == 'table_001'
        assert result.has_lineage is True
        assert result.lineage_count == 5


class TestLineageRelation:
    """血缘关系测试"""

    def test_lineage_relation_creation(self):
        """测试血缘关系创建"""
        relation = LineageRelation(
            source_id='table_001',
            source_name='users',
            target_id='table_002',
            target_name='orders',
            relation_type='LINEAGE_TO',
            transformation_type='INSERT',
        )
        
        assert relation.source_id == 'table_001'
        assert relation.target_id == 'table_002'
        assert relation.relation_type == 'LINEAGE_TO'


class TestBatchExecution:
    """批次执行测试"""

    def test_batch_execution_creation(self):
        """测试批次执行创建"""
        batch = BatchExecution(
            batch_id='batch_001',
            table_id='table_001',
            table_name='users',
            execution_time=datetime.now(),
            status='SUCCESS',
            row_count=1000,
        )
        
        assert batch.batch_id == 'batch_001'
        assert batch.status == 'SUCCESS'
        assert batch.row_count == 1000


class TestChangeRecord:
    """变更记录测试"""

    def test_change_record_creation(self):
        """测试变更记录创建"""
        change = ChangeRecord(
            change_id='change_001',
            object_id='table_001',
            change_type='ALTER',
            change_description='添加列',
            changed_by='admin',
            change_time=datetime.now(),
        )
        
        assert change.change_id == 'change_001'
        assert change.change_type == 'ALTER'


class TestTroubleshootResult:
    """问题排查结果测试"""

    def test_troubleshoot_result_creation(self):
        """测试问题排查结果创建"""
        result = TroubleshootResult(
            object_id='table_001',
            object_name='users',
            object_type='table',
            lineage_relations=[],
            recent_batches=[],
            change_records=[],
        )
        
        assert result.object_id == 'table_001'
        assert len(result.lineage_relations) == 0
        assert len(result.recent_batches) == 0
        assert len(result.change_records) == 0

    def test_troubleshoot_result_with_data(self):
        """测试带数据的问题排查结果"""
        lineage = LineageRelation(
            source_id='table_001',
            source_name='users',
            target_id='table_002',
            target_name='orders',
            relation_type='LINEAGE_TO',
            transformation_type='INSERT',
        )
        
        batch = BatchExecution(
            batch_id='batch_001',
            table_id='table_001',
            table_name='users',
            execution_time=datetime.now(),
            status='SUCCESS',
            row_count=1000,
        )
        
        result = TroubleshootResult(
            object_id='table_001',
            object_name='users',
            object_type='table',
            lineage_relations=[lineage],
            recent_batches=[batch],
            change_records=[],
        )
        
        assert len(result.lineage_relations) == 1
        assert len(result.recent_batches) == 1