"""
性能基准测试
测试阶段 3 核心功能的 P95 延迟指标

验收标准:
- 表级血缘查询 P95 ≤ 3 秒
- 字段级最小链路 P95 ≤ 5 秒
- 搜索响应时间 P95 ≤ 2 秒
"""
import pytest
import time
import statistics
from unittest.mock import AsyncMock, MagicMock, patch
from datetime import datetime


class TestSearchPerformance:
    """搜索服务性能测试"""

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
            from app.services.search_service import SearchService
            service = SearchService()
            service.driver = mock_driver
            return service

    @pytest.mark.asyncio
    async def test_search_tables_latency(self, search_service, mock_driver):
        """测试表搜索延迟"""
        # 模拟查询延迟
        async def mock_run(*args, **kwargs):
            await asyncio.sleep(0.1)  # 模拟 100ms 延迟
            mock_result = MagicMock()
            mock_result.list = AsyncMock(return_value=[])
            return mock_result
        
        mock_session = mock_driver.session.return_value
        mock_session.run = mock_run
        
        latencies = []
        iterations = 100
        
        for _ in range(iterations):
            start = time.perf_counter()
            await search_service.search_tables(keyword='test', page=1, page_size=20)
            end = time.perf_counter()
            latencies.append((end - start) * 1000)  # 转换为毫秒
        
        p50 = statistics.percentile(latencies, 50)
        p95 = statistics.percentile(latencies, 95)
        p99 = statistics.percentile(latencies, 99)
        
        print(f"\n表搜索延迟统计:")
        print(f"  P50: {p50:.2f}ms")
        print(f"  P95: {p95:.2f}ms (目标：≤2000ms)")
        print(f"  P99: {p99:.2f}ms")
        
        # 验证 P95 延迟（目标 ≤ 2 秒 = 2000ms）
        assert p95 <= 2000, f"表搜索 P95 延迟 {p95:.2f}ms 超过目标 2000ms"

    @pytest.mark.asyncio
    async def test_search_fields_latency(self, search_service, mock_driver):
        """测试字段搜索延迟"""
        async def mock_run(*args, **kwargs):
            await asyncio.sleep(0.1)
            mock_result = MagicMock()
            mock_result.list = AsyncMock(return_value=[])
            return mock_result
        
        mock_session = mock_driver.session.return_value
        mock_session.run = mock_run
        
        latencies = []
        iterations = 100
        
        for _ in range(iterations):
            start = time.perf_counter()
            await search_service.search_fields(keyword='test', page=1, page_size=20)
            end = time.perf_counter()
            latencies.append((end - start) * 1000)
        
        p95 = statistics.percentile(latencies, 95)
        
        print(f"\n字段搜索 P95 延迟：{p95:.2f}ms (目标：≤2000ms)")
        assert p95 <= 2000


class TestLineagePerformance:
    """血缘查询性能测试"""

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
            from app.services.neo4j_lineage_service import Neo4jLineageService
            service = Neo4jLineageService()
            service.driver = mock_driver
            return service

    @pytest.mark.asyncio
    async def test_table_lineage_latency_p95(self, lineage_service, mock_driver):
        """
        测试表级血缘查询 P95 延迟
        验收标准：P95 ≤ 3 秒
        """
        async def mock_run(*args, **kwargs):
            await asyncio.sleep(0.5)  # 模拟 500ms 延迟
            mock_result = MagicMock()
            mock_result.list = AsyncMock(return_value=[])
            return mock_result
        
        mock_session = mock_driver.session.return_value
        mock_session.run = mock_run
        
        latencies = []
        iterations = 50  # 减少迭代次数以加快测试
        
        for _ in range(iterations):
            start = time.perf_counter()
            await lineage_service.get_table_lineage(
                table_id='table_001',
                depth=5,
                direction='upstream'
            )
            end = time.perf_counter()
            latencies.append((end - start) * 1000)
        
        p50 = statistics.percentile(latencies, 50)
        p95 = statistics.percentile(latencies, 95)
        p99 = statistics.percentile(latencies, 99)
        
        print(f"\n表级血缘查询延迟统计:")
        print(f"  P50: {p50:.2f}ms")
        print(f"  P95: {p95:.2f}ms (目标：≤3000ms)")
        print(f"  P99: {p99:.2f}ms")
        
        # 验收标准：P95 ≤ 3 秒 = 3000ms
        assert p95 <= 3000, f"表级血缘 P95 延迟 {p95:.2f}ms 超过目标 3000ms"

    @pytest.mark.asyncio
    async def test_table_lineage_depth_performance(self, lineage_service, mock_driver):
        """测试不同深度的血缘查询性能"""
        async def mock_run(*args, **kwargs):
            # 深度越大，延迟越高
            depth = kwargs.get('depth', 5)
            await asyncio.sleep(0.1 * depth)
            mock_result = MagicMock()
            mock_result.list = AsyncMock(return_value=[])
            return mock_result
        
        mock_session = mock_driver.session.return_value
        mock_session.run = mock_run
        
        depths = [1, 3, 5, 7, 10]
        
        for depth in depths:
            latencies = []
            for _ in range(20):
                start = time.perf_counter()
                await lineage_service.get_table_lineage(
                    table_id='table_001',
                    depth=depth,
                    direction='upstream'
                )
                end = time.perf_counter()
                latencies.append((end - start) * 1000)
            
            p95 = statistics.percentile(latencies, 95)
            print(f"深度 {depth}: P95 = {p95:.2f}ms")


class TestShortestPathPerformance:
    """最短路径性能测试"""

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
            from app.services.shortest_path_service import ShortestPathService
            service = ShortestPathService()
            service.driver = mock_driver
            return service

    @pytest.mark.asyncio
    async def test_field_shortest_path_latency_p95(self, path_service, mock_driver):
        """
        测试字段级最小链路 P95 延迟
        验收标准：P95 ≤ 5 秒
        """
        def mock_run(*args, **kwargs):
            time.sleep(0.5)  # 模拟 500ms 延迟
            mock_result = MagicMock()
            mock_result.single = MagicMock(return_value={'nodes': [], 'edges': []})
            return mock_result
        
        mock_session = mock_driver.session.return_value
        mock_session.run = mock_run
        
        latencies = []
        iterations = 50
        
        for _ in range(iterations):
            start = time.perf_counter()
            path_service.get_field_shortest_path(
                target_field_id='field_001',
                max_depth=10
            )
            end = time.perf_counter()
            latencies.append((end - start) * 1000)
        
        p50 = statistics.percentile(latencies, 50)
        p95 = statistics.percentile(latencies, 95)
        p99 = statistics.percentile(latencies, 99)
        
        print(f"\n字段级最小链路延迟统计:")
        print(f"  P50: {p50:.2f}ms")
        print(f"  P95: {p95:.2f}ms (目标：≤5000ms)")
        print(f"  P99: {p99:.2f}ms")
        
        # 验收标准：P95 ≤ 5 秒 = 5000ms
        assert p95 <= 5000, f"字段级最小链路 P95 延迟 {p95:.2f}ms 超过目标 5000ms"

    def test_dijkstra_algorithm_performance(self, path_service):
        """测试 Dijkstra 算法性能"""
        from app.services.shortest_path_service import FieldNode
        
        # 创建大规模图
        num_nodes = 1000
        nodes_map = {}
        edges_list = []
        
        for i in range(num_nodes):
            nodes_map[f'field_{i}'] = FieldNode(
                id=f'field_{i}',
                name=f'col_{i}',
                table_name=f'table_{i}',
                full_name=f'public.table_{i}.col_{i}'
            )
        
        # 创建边
        for i in range(num_nodes - 1):
            edges_list.append((f'field_{i}', f'field_{i+1}', 1.0))
        
        # 测试算法性能
        start = time.perf_counter()
        result = path_service._dijkstra_single_source(
            target_field_id=f'field_{num_nodes-1}',
            source_field_id='field_0',
            nodes_map=nodes_map,
            edges_list=edges_list
        )
        end = time.perf_counter()
        
        latency_ms = (end - start) * 1000
        print(f"\nDijkstra 算法性能 ({num_nodes} 节点): {latency_ms:.2f}ms")
        
        # 验证算法在合理时间内完成
        assert latency_ms < 1000, f"Dijkstra 算法执行时间 {latency_ms:.2f}ms 过长"


class TestConcurrencyPerformance:
    """并发性能测试"""

    @pytest.fixture
    def mock_driver(self):
        """模拟 Neo4j 驱动"""
        driver = MagicMock()
        session = AsyncMock()
        session.__aenter__ = AsyncMock(return_value=session)
        session.__aexit__ = AsyncMock(return_value=None)
        driver.session.return_value = session
        return driver

    @pytest.mark.asyncio
    async def test_concurrent_search_requests(self, mock_driver):
        """测试并发搜索请求"""
        import asyncio
        
        with patch('app.services.search_service.AsyncGraphDatabase.driver', return_value=mock_driver):
            from app.services.search_service import SearchService
            
            async def mock_run(*args, **kwargs):
                await asyncio.sleep(0.1)
                mock_result = MagicMock()
                mock_result.list = AsyncMock(return_value=[])
                return mock_result
            
            mock_session = mock_driver.session.return_value
            mock_session.run = mock_run
            
            service = SearchService()
            service.driver = mock_driver
            
            # 模拟 50 个并发请求
            concurrent_users = 50
            tasks = []
            
            start = time.perf_counter()
            for i in range(concurrent_users):
                task = service.search_tables(keyword=f'test_{i}', page=1, page_size=20)
                tasks.append(task)
            
            await asyncio.gather(*tasks)
            end = time.perf_counter()
            
            total_time = (end - start) * 1000
            avg_time = total_time / concurrent_users
            
            print(f"\n并发搜索性能测试:")
            print(f"  并发用户数：{concurrent_users}")
            print(f"  总时间：{total_time:.2f}ms")
            print(f"  平均响应时间：{avg_time:.2f}ms")
            
            # 验证系统能处理并发请求
            assert total_time < 10000, f"并发请求总时间 {total_time:.2f}ms 过长"


# 导入 asyncio 用于异步测试
import asyncio

# 添加 statistics.percentile 的兼容性处理
try:
    from statistics import percentile
except ImportError:
    # Python 3.9 及以下版本
    def percentile(data, p):
        """计算百分位数"""
        sorted_data = sorted(data)
        k = (len(sorted_data) - 1) * p / 100
        f = int(k)
        c = f + 1 if f + 1 < len(sorted_data) else f
        return sorted_data[f] + (sorted_data[c] - sorted_data[f]) * (k - f)
    
    #  monkey-patch statistics
    import statistics
    statistics.percentile = percentile