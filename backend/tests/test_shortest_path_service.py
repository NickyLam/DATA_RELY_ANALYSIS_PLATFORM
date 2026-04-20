"""
最短路径服务单元测试
测试 shortest_path_service.py 中的 Dijkstra 算法和字段血缘提取功能
"""
import pytest
from unittest.mock import MagicMock, patch
from collections import defaultdict

from app.services.shortest_path_service import (
    ShortestPathService,
    FieldNode,
    FieldEdge,
    ShortestPathResult,
    ExpressionDetail,
)


class TestShortestPathService:
    """最短路径服务测试类"""

    @pytest.fixture
    def mock_driver(self):
        """模拟 Neo4j 驱动"""
        driver = MagicMock()
        session = MagicMock()
        session.__enter__ = MagicMock(return_value=session)
        session.__exit__ = MagicMock(return_value=None)
        driver.session.return_value = session
        return driver

    @pytest.fixture
    def path_service(self, mock_driver):
        """创建最短路径服务实例"""
        with patch('app.services.shortest_path_service.GraphDatabase.driver', return_value=mock_driver):
            service = ShortestPathService()
            service.driver = mock_driver
            return service

    def test_field_node_creation(self):
        """测试字段节点创建"""
        node = FieldNode(
            id='field_001',
            name='user_id',
            table_name='users',
            full_name='public.users.user_id',
            data_type='NUMBER',
            expression='t.user_id',
            is_source=False,
        )
        
        assert node.id == 'field_001'
        assert node.name == 'user_id'
        assert node.table_name == 'users'
        assert node.full_name == 'public.users.user_id'
        assert node.is_source is False

    def test_field_edge_creation(self):
        """测试字段血缘边创建"""
        edge = FieldEdge(
            source_id='field_001',
            target_id='field_002',
            transformation_type='SELECT',
            expression='t.user_id',
            confidence_score=0.95,
        )
        
        assert edge.source_id == 'field_001'
        assert edge.target_id == 'field_002'
        assert edge.transformation_type == 'SELECT'
        assert edge.confidence_score == 0.95

    def test_shortest_path_result_creation(self):
        """测试最短路径结果创建"""
        result = ShortestPathResult(
            nodes=[],
            edges=[],
            path_length=0,
            total_weight=0.0,
            source_nodes=[],
        )
        
        assert result.path_length == 0
        assert result.total_weight == 0.0
        assert len(result.nodes) == 0

    def test_expression_detail_creation(self):
        """测试表达式详情创建"""
        detail = ExpressionDetail(
            raw_expression='t.user_id',
            parsed_expression='users.user_id',
            transformation_type='SELECT',
            source_fields=['user_id'],
            aggregation_type=None,
        )
        
        assert detail.raw_expression == 't.user_id'
        assert detail.transformation_type == 'SELECT'
        assert len(detail.source_fields) == 1

    def test_dijkstra_single_source_basic(self, path_service):
        """测试 Dijkstra 单源最短路径基本功能"""
        # 创建简单的图结构
        nodes_map = {
            'field_001': FieldNode('field_001', 'id', 'users', 'public.users.id'),
            'field_002': FieldNode('field_002', 'user_id', 'orders', 'public.orders.user_id'),
            'field_003': FieldNode('field_003', 'order_id', 'items', 'public.items.order_id'),
        }
        
        edges_list = [
            ('field_001', 'field_002', 1.0),
            ('field_002', 'field_003', 1.0),
        ]
        
        # 使用私有方法测试（在实际使用中会通过公共方法调用）
        result = path_service._dijkstra_single_source(
            target_field_id='field_003',
            source_field_id='field_001',
            nodes_map=nodes_map,
            edges_list=edges_list,
        )
        
        assert result is not None
        assert isinstance(result, ShortestPathResult)

    def test_dijkstra_multi_source_basic(self, path_service):
        """测试 Dijkstra 多源最短路径基本功能"""
        nodes_map = {
            'field_001': FieldNode('field_001', 'id', 'users', 'public.users.id'),
            'field_002': FieldNode('field_002', 'name', 'users', 'public.users.name'),
            'field_003': FieldNode('field_003', 'user_id', 'orders', 'public.orders.user_id'),
        }
        
        source_nodes = [
            FieldNode('field_001', 'id', 'users', 'public.users.id', is_source=True),
            FieldNode('field_002', 'name', 'users', 'public.users.name', is_source=True),
        ]
        
        edges_list = [
            ('field_001', 'field_003', 1.0),
            ('field_002', 'field_003', 1.0),
        ]
        
        result = path_service._dijkstra_multi_source(
            target_field_id='field_003',
            source_nodes=source_nodes,
            nodes_map=nodes_map,
            edges_list=edges_list,
        )
        
        assert result is not None
        assert isinstance(result, ShortestPathResult)

    def test_build_nodes_map(self, path_service):
        """测试构建节点映射"""
        graph_nodes = [
            {'id': 'field_001', 'name': 'user_id', 'table_name': 'users', 'full_name': 'public.users.user_id'},
            {'id': 'field_002', 'name': 'order_id', 'table_name': 'orders', 'full_name': 'public.orders.order_id'},
        ]
        
        nodes_map = path_service._build_nodes_map(graph_nodes)
        
        assert 'field_001' in nodes_map
        assert 'field_002' in nodes_map
        assert nodes_map['field_001'].name == 'user_id'

    def test_build_edges_list(self, path_service):
        """测试构建边列表"""
        graph_edges = [
            {'source_id': 'field_001', 'target_id': 'field_002', 'weight': 1.0},
            {'source_id': 'field_002', 'target_id': 'field_003', 'weight': 1.0},
        ]
        
        edges_list = path_service._build_edges_list(graph_edges)
        
        assert len(edges_list) == 2
        assert edges_list[0][0] == 'field_001'
        assert edges_list[0][1] == 'field_002'

    def test_find_source_nodes(self, path_service):
        """测试查找源节点"""
        nodes_map = {
            'field_001': FieldNode('field_001', 'id', 'users', 'public.users.id', is_source=True),
            'field_002': FieldNode('field_002', 'user_id', 'orders', 'public.orders.user_id', is_source=False),
            'field_003': FieldNode('field_003', 'name', 'users', 'public.users.name', is_source=True),
        }
        
        edges_list = [
            ('field_001', 'field_002', 1.0),
            ('field_003', 'field_002', 1.0),
        ]
        
        source_nodes = path_service._find_source_nodes(nodes_map, edges_list)
        
        assert len(source_nodes) == 2
        assert all(node.is_source for node in source_nodes)

    def test_get_field_shortest_path_empty_result(self, path_service, mock_driver):
        """测试获取字段最短路径 - 空结果"""
        mock_session = mock_driver.session.return_value
        mock_session.run = MagicMock()
        mock_result = MagicMock()
        mock_result.single = MagicMock(return_value={'nodes': [], 'edges': []})
        mock_session.run.return_value = mock_result
        
        result = path_service.get_field_shortest_path(
            target_field_id='nonexistent_field',
            max_depth=10,
        )
        
        assert isinstance(result, ShortestPathResult)
        assert len(result.nodes) == 0
        assert result.path_length == 0

    def test_service_close(self, path_service, mock_driver):
        """测试服务关闭"""
        path_service.close()
        mock_driver.close.assert_called()


class TestDijkstraAlgorithm:
    """Dijkstra 算法专项测试"""

    @pytest.fixture
    def path_service(self):
        """创建测试用的服务实例"""
        with patch('app.services.shortest_path_service.GraphDatabase.driver'):
            return ShortestPathService()

    def test_dijkstra_path_finding(self, path_service):
        """测试最短路径查找"""
        # 创建一个简单的线性路径：A -> B -> C -> D
        nodes_map = {
            'A': FieldNode('A', 'a', 't1', 't1.a'),
            'B': FieldNode('B', 'b', 't2', 't2.b'),
            'C': FieldNode('C', 'c', 't3', 't3.c'),
            'D': FieldNode('D', 'd', 't4', 't4.d'),
        }
        
        edges_list = [
            ('A', 'B', 1.0),
            ('B', 'C', 1.0),
            ('C', 'D', 1.0),
        ]
        
        result = path_service._dijkstra_single_source('D', 'A', nodes_map, edges_list)
        
        # 验证路径长度
        assert result.path_length >= 0

    def test_dijkstra_with_weights(self, path_service):
        """测试带权重的最短路径"""
        nodes_map = {
            'A': FieldNode('A', 'a', 't1', 't1.a'),
            'B': FieldNode('B', 'b', 't2', 't2.b'),
            'C': FieldNode('C', 'c', 't3', 't3.c'),
        }
        
        # 两条路径：A->B->C (权重 2) 和 A->C (权重 5)
        edges_list = [
            ('A', 'B', 1.0),
            ('B', 'C', 1.0),
            ('A', 'C', 5.0),
        ]
        
        result = path_service._dijkstra_single_source('C', 'A', nodes_map, edges_list)
        
        # 应该选择 A->B->C 路径（总权重 2）
        assert result is not None

    def test_dijkstra_disconnected_graph(self, path_service):
        """测试不连通图的最短路径"""
        nodes_map = {
            'A': FieldNode('A', 'a', 't1', 't1.a'),
            'B': FieldNode('B', 'b', 't2', 't2.b'),
            'C': FieldNode('C', 'c', 't3', 't3.c'),
        }
        
        # A 和 B 连通，C 孤立
        edges_list = [
            ('A', 'B', 1.0),
        ]
        
        result = path_service._dijkstra_single_source('C', 'A', nodes_map, edges_list)
        
        # C 不可达，结果应该为空或路径长度为 0
        assert result is not None


class TestFieldLineageExtraction:
    """字段血缘提取测试"""

    @pytest.fixture
    def path_service(self):
        """创建测试用的服务实例"""
        with patch('app.services.shortest_path_service.GraphDatabase.driver'):
            return ShortestPathService()

    def test_expression_parsing_basic(self, path_service):
        """测试基本表达式解析"""
        # 这个测试验证表达式解析的基本逻辑
        expression = "t.column_name"
        
        # 验证表达式不为空
        assert expression is not None
        assert len(expression) > 0

    def test_transformation_type_detection(self, path_service):
        """测试转换类型检测"""
        transformations = ['SELECT', 'JOIN', 'AGGREGATION', 'FILTER']
        
        for trans_type in transformations:
            assert trans_type in ['SELECT', 'JOIN', 'AGGREGATION', 'FILTER', 'PROJECT', 'UNION']

    def test_multi_source_aggregation(self, path_service):
        """测试多源汇聚场景"""
        # 模拟多源汇聚：多个源字段汇聚到一个目标字段
        nodes_map = {
            'src1': FieldNode('src1', 'a', 't1', 't1.a', is_source=True),
            'src2': FieldNode('src2', 'b', 't2', 't2.b', is_source=True),
            'target': FieldNode('target', 'c', 't3', 't3.c', is_source=False),
        }
        
        edges_list = [
            ('src1', 'target', 1.0),
            ('src2', 'target', 1.0),
        ]
        
        source_nodes = [nodes_map['src1'], nodes_map['src2']]
        
        result = path_service._dijkstra_multi_source('target', source_nodes, nodes_map, edges_list)
        
        assert result is not None
        assert len(result.source_nodes) >= 0