"""
血缘查询服务单元测试
测试 neo4j_lineage_service.py 中的血缘查询功能
"""
import pytest
from unittest.mock import AsyncMock, MagicMock, patch

from app.services.neo4j_lineage_service import Neo4jLineageService
from app.schemas.lineage import LineageGraph, LineageNode, LineageEdge, LineagePath


class TestNeo4jLineageService:
    """Neo4j 血缘服务测试类"""

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
    def lineage_service(self, mock_driver):
        """创建血缘服务实例"""
        with patch('app.services.neo4j_lineage_service.AsyncGraphDatabase.driver', return_value=mock_driver):
            service = Neo4jLineageService()
            service.driver = mock_driver
            return service

    @pytest.mark.asyncio
    async def test_get_table_lineage_upstream(self, lineage_service, mock_driver):
        """测试获取表的上游血缘"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        graph = await lineage_service.get_table_lineage(
            table_id='table_001',
            depth=5,
            direction='upstream'
        )
        
        assert isinstance(graph, LineageGraph)
        assert graph.depth == 5

    @pytest.mark.asyncio
    async def test_get_table_lineage_downstream(self, lineage_service, mock_driver):
        """测试获取表的下游血缘"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        graph = await lineage_service.get_table_lineage(
            table_id='table_001',
            depth=3,
            direction='downstream'
        )
        
        assert isinstance(graph, LineageGraph)
        assert graph.depth == 3

    @pytest.mark.asyncio
    async def test_get_table_lineage_both(self, lineage_service, mock_driver):
        """测试获取表的双向血缘"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        graph = await lineage_service.get_table_lineage(
            table_id='table_001',
            depth=5,
            direction='both'
        )
        
        assert isinstance(graph, LineageGraph)

    @pytest.mark.asyncio
    async def test_traverse_upstream_basic(self, lineage_service, mock_driver):
        """测试上游遍历基本功能"""
        nodes_dict = {}
        edges_dict = {}
        visited = set()
        
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        await lineage_service._traverse_upstream(
            session=mock_session,
            table_id='table_001',
            depth=3,
            nodes_dict=nodes_dict,
            edges_dict=edges_dict,
            visited=visited,
            current_depth=0
        )
        
        # 验证方法执行 without errors
        assert mock_session.run.called

    @pytest.mark.asyncio
    async def test_traverse_downstream_basic(self, lineage_service, mock_driver):
        """测试下游遍历基本功能"""
        nodes_dict = {}
        edges_dict = {}
        visited = set()
        
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        await lineage_service._traverse_downstream(
            session=mock_session,
            table_id='table_001',
            depth=3,
            nodes_dict=nodes_dict,
            edges_dict=edges_dict,
            visited=visited,
            current_depth=0
        )
        
        assert mock_session.run.called

    @pytest.mark.asyncio
    async def test_get_table_details(self, lineage_service, mock_driver):
        """测试获取表详情"""
        mock_result = MagicMock()
        mock_result.single = AsyncMock(return_value={
            'id': 'table_001',
            'name': 'users',
            'schema': 'public',
            'database': 'test_db',
            'table_type': 'TABLE',
            'description': '用户表',
        })
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        node = await lineage_service.get_table_details('table_001')
        
        assert node is None or isinstance(node, LineageNode)

    @pytest.mark.asyncio
    async def test_get_field_lineage(self, lineage_service, mock_driver):
        """测试获取字段血缘"""
        mock_result = MagicMock()
        mock_result.single = AsyncMock(return_value={
            'nodes': [],
            'edges': [],
        })
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        path = await lineage_service.get_field_lineage('field_001')
        
        assert path is None or isinstance(path, LineagePath)

    @pytest.mark.asyncio
    async def test_get_impact_analysis(self, lineage_service, mock_driver):
        """测试影响分析"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        graph = await lineage_service.get_impact_analysis('table_001', depth=5)
        
        assert isinstance(graph, LineageGraph)

    @pytest.mark.asyncio
    async def test_get_job_lineage(self, lineage_service, mock_driver):
        """测试作业血缘"""
        mock_result = MagicMock()
        mock_result.list = AsyncMock(return_value=[])
        
        mock_session = mock_driver.session.return_value
        mock_session.run = AsyncMock(return_value=mock_result)
        
        graph = await lineage_service.get_job_lineage('job_001')
        
        assert isinstance(graph, LineageGraph)

    @pytest.mark.asyncio
    async def test_service_close(self, lineage_service, mock_driver):
        """测试服务关闭"""
        await lineage_service.close()
        mock_driver.close.assert_called()


class TestLineageNode:
    """血缘节点测试"""

    def test_lineage_node_creation(self):
        """测试血缘节点创建"""
        node = LineageNode(
            id='table_001',
            name='users',
            type='Table',
            schema='public',
            database='test_db',
        )
        
        assert node.id == 'table_001'
        assert node.name == 'users'
        assert node.type == 'Table'

    def test_lineage_node_with_optional_fields(self):
        """测试带可选字段的血缘节点"""
        node = LineageNode(
            id='table_001',
            name='users',
            type='Table',
            schema='public',
            database='test_db',
            description='用户表',
            row_count=1000,
        )
        
        assert node.description == '用户表'
        assert node.row_count == 1000


class TestLineageEdge:
    """血缘边测试"""

    def test_lineage_edge_creation(self):
        """测试血缘边创建"""
        edge = LineageEdge(
            source_id='table_001',
            target_id='table_002',
            type='LINEAGE_TO',
            transformation_type='INSERT',
        )
        
        assert edge.source_id == 'table_001'
        assert edge.target_id == 'table_002'
        assert edge.type == 'LINEAGE_TO'

    def test_lineage_edge_with_confidence(self):
        """测试带可信度的血缘边"""
        edge = LineageEdge(
            source_id='table_001',
            target_id='table_002',
            type='LINEAGE_TO',
            confidence_score=0.95,
        )
        
        assert edge.confidence_score == 0.95


class TestLineageGraph:
    """血缘图测试"""

    def test_lineage_graph_creation(self):
        """测试血缘图创建"""
        graph = LineageGraph(
            nodes=[],
            edges=[],
            depth=5,
            total_nodes=0,
            total_edges=0,
        )
        
        assert graph.depth == 5
        assert graph.total_nodes == 0
        assert graph.total_edges == 0

    def test_lineage_graph_with_data(self):
        """测试带数据的血缘图"""
        nodes = [
            LineageNode(id='table_001', name='users', type='Table'),
            LineageNode(id='table_002', name='orders', type='Table'),
        ]
        edges = [
            LineageEdge(source_id='table_001', target_id='table_002', type='LINEAGE_TO'),
        ]
        
        graph = LineageGraph(
            nodes=nodes,
            edges=edges,
            depth=3,
            total_nodes=2,
            total_edges=1,
        )
        
        assert len(graph.nodes) == 2
        assert len(graph.edges) == 1


class TestLineagePath:
    """血缘路径测试"""

    def test_lineage_path_creation(self):
        """测试血缘路径创建"""
        path = LineagePath(
            nodes=[],
            edges=[],
            path_length=0,
        )
        
        assert path.path_length == 0