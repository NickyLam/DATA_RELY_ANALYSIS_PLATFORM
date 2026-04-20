"""
压力测试脚本
使用 Locust 进行 API 性能压力测试
"""

import json
import logging
import random
import time
from pathlib import Path

import gevent
from locust import HttpUser, task, between, events

logger = logging.getLogger(__name__)


class LineagePlatformUser(HttpUser):
    """
    数据血缘分析平台用户模拟
    """

    wait_time = between(1, 3)  # 用户操作间隔 1-3 秒

    # 模拟表 ID 列表（从配置中读取）
    table_ids = [
        "oracle:finance:account_balance",
        "oracle:finance:transaction_log",
        "oracle:finance:daily_report",
        "oracle:crm:customer_info",
        "oracle:crm:order_detail",
        "oracle:hr:employee_info",
        "oracle:inventory:product_info",
        "tdh:datalake:raw_transaction",
        "tdh:datalake:cleaned_transaction",
        "oceanbase:report:daily_metrics",
        "gbase:analytics:user_behavior",
        "yashan:archive:transaction_archive",
    ]

    # 搜索关键词列表
    search_keywords = [
        "account",
        "transaction",
        "customer",
        "order",
        "employee",
        "product",
        "report",
        "metrics",
        "balance",
        "daily",
    ]

    def on_start(self):
        """
        用户开始时执行（模拟登录）
        """
        self.login()

    def login(self):
        """
        模拟登录
        """
        response = self.client.post(
            "/api/v1/auth/login",
            json={"username": "test_user", "password": "test_password"},
            catch_response=True,
        )

        if response.status_code == 200 or response.status_code == 401:
            # 200 = 登录成功, 401 = 测试环境可能不需要登录
            response.success()
        else:
            response.failure(f"登录失败: {response.status_code}")

    @task(10)
    def search_assets(self):
        """
        资产搜索（高频操作）
        """
        keyword = random.choice(self.search_keywords)
        page = random.randint(1, 5)

        response = self.client.get(
            f"/api/v1/search",
            params={"keyword": keyword, "page": page, "page_size": 20},
            name="/api/v1/search",
            catch_response=True,
        )

        if response.status_code == 200:
            response.success()
        else:
            response.failure(f"搜索失败: {response.status_code}")

    @task(5)
    def get_table_lineage(self):
        """
        获取表级血缘（中等频率）
        """
        table_id = random.choice(self.table_ids)
        depth = random.randint(3, 5)
        direction = random.choice(["upstream", "downstream", "both"])

        response = self.client.get(
            f"/api/v1/lineage/table/{table_id}",
            params={"depth": depth, "direction": direction},
            name="/api/v1/lineage/table",
            catch_response=True,
        )

        if response.status_code == 200:
            # 检查响应时间
            if response.elapsed.total_seconds() > 3:
                response.failure(f"响应时间过长: {response.elapsed.total_seconds()}s")
            else:
                response.success()
        elif response.status_code == 404:
            response.success()  # 表不存在也算正常
        else:
            response.failure(f"血缘查询失败: {response.status_code}")

    @task(3)
    def get_field_lineage(self):
        """
        获取字段级血缘（较低频率）
        """
        table_id = random.choice(self.table_ids)
        # 模拟字段 ID
        field_name = random.choice(["col_1", "col_2", "col_3", "col_4", "col_5"])
        field_id = f"{table_id}.{field_name}"

        response = self.client.get(
            f"/api/v1/lineage/field/{field_id}",
            name="/api/v1/lineage/field",
            catch_response=True,
        )

        if response.status_code == 200:
            if response.elapsed.total_seconds() > 5:
                response.failure(f"字段血缘响应时间过长: {response.elapsed.total_seconds()}s")
            else:
                response.success()
        elif response.status_code == 404:
            response.success()
        else:
            response.failure(f"字段血缘查询失败: {response.status_code}")

    @task(5)
    def get_table_details(self):
        """
        获取表详情（中等频率）
        """
        table_id = random.choice(self.table_ids)

        response = self.client.get(
            f"/api/v1/assets/table/{table_id}",
            name="/api/v1/assets/table",
            catch_response=True,
        )

        if response.status_code == 200:
            response.success()
        elif response.status_code == 404:
            response.success()
        else:
            response.failure(f"获取表详情失败: {response.status_code}")

    @task(2)
    def get_impact_analysis(self):
        """
        影响分析（较低频率）
        """
        table_id = random.choice(self.table_ids)
        depth = random.randint(3, 5)

        response = self.client.get(
            f"/api/v1/impact/table/{table_id}",
            params={"depth": depth},
            name="/api/v1/impact/table",
            catch_response=True,
        )

        if response.status_code == 200:
            if response.elapsed.total_seconds() > 3:
                response.failure(f"影响分析响应时间过长: {response.elapsed.total_seconds()}s")
            else:
                response.success()
        elif response.status_code == 404:
            response.success()
        else:
            response.failure(f"影响分析失败: {response.status_code}")

    @task(1)
    def get_filter_options(self):
        """
        获取筛选器选项（低频率）
        """
        response = self.client.get(
            "/api/v1/search/filter-options",
            name="/api/v1/search/filter-options",
            catch_response=True,
        )

        if response.status_code == 200:
            response.success()
        else:
            response.failure(f"获取筛选器选项失败: {response.status_code}")

    @task(1)
    def troubleshoot(self):
        """
        问题排查（低频率）
        """
        table_id = random.choice(self.table_ids)

        response = self.client.get(
            f"/api/v1/troubleshoot/table/{table_id}",
            name="/api/v1/troubleshoot/table",
            catch_response=True,
        )

        if response.status_code == 200:
            response.success()
        elif response.status_code == 404:
            response.success()
        else:
            response.failure(f"问题排查失败: {response.status_code}")


# 自定义性能指标收集
@events.request.add_listener
def on_request(request_type, name, response_time, response_length, exception, **kwargs):
    """
    记录每个请求的性能指标
    """
    if exception:
        logger.warning(f"请求失败: {name}, 错误: {exception}")
    else:
        logger.debug(f"请求成功: {name}, 响应时间: {response_time}ms")


@events.test_start.add_listener
def on_test_start(environment, **kwargs):
    """
    测试开始时记录
    """
    logger.info("=" * 60)
    logger.info("压力测试开始")
    logger.info("=" * 60)


@events.test_stop.add_listener
def on_test_stop(environment, **kwargs):
    """
    测试结束时记录
    """
    logger.info("=" * 60)
    logger.info("压力测试结束")
    logger.info("=" * 60)

    # 生成测试报告
    stats = environment.stats
    total_requests = stats.total.num_requests
    total_failures = stats.total.num_failures
    avg_response_time = stats.total.avg_response_time
    max_response_time = stats.total.max_response_time
    min_response_time = stats.total.min_response_time
    median_response_time = stats.total.median_response_time

    failure_rate = total_failures / total_requests if total_requests > 0 else 0

    logger.info(f"总请求数: {total_requests}")
    logger.info(f"总失败数: {total_failures}")
    logger.info(f"失败率: {failure_rate:.2%}")
    logger.info(f"平均响应时间: {avg_response_time:.2f}ms")
    logger.info(f"最大响应时间: {max_response_time:.2f}ms")
    logger.info(f"最小响应时间: {min_response_time:.2f}ms")
    logger.info(f"P50 响应时间: {median_response_time:.2f}ms")
    logger.info("=" * 60)


# 运行命令示例
# locust -f stress_test.py --host=http://localhost:8000 --users=50 --spawn-rate=10 --run-time=5m


class SimpleStressTest:
    """
    简单压力测试（不使用 Locust）
    适用于无法安装 Locust 的环境
    """

    def __init__(self, host: str = "http://localhost:8000"):
        self.host = host
        self.results = {
            "total_requests": 0,
            "total_failures": 0,
            "response_times": [],
            "errors": [],
        }

    async def run_single_request(self, endpoint: str, method: str = "GET", params: dict = None):
        """
        执行单个请求
        """
        import aiohttp

        url = f"{self.host}{endpoint}"
        start_time = time.time()

        try:
            async with aiohttp.ClientSession() as session:
                if method == "GET":
                    async with session.get(url, params=params) as response:
                        await response.read()
                        status = response.status
                else:
                    async with session.post(url, json=params) as response:
                        await response.read()
                        status = response.status

                end_time = time.time()
                response_time = (end_time - start_time) * 1000

                self.results["total_requests"] += 1
                self.results["response_times"].append(response_time)

                if status >= 400:
                    self.results["total_failures"] += 1
                    self.results["errors"].append(f"{endpoint}: {status}")

                return {"status": status, "response_time": response_time}

        except Exception as e:
            end_time = time.time()
            response_time = (end_time - start_time) * 1000

            self.results["total_requests"] += 1
            self.results["total_failures"] += 1
            self.results["response_times"].append(response_time)
            self.results["errors"].append(f"{endpoint}: {str(e)}")

            return {"error": str(e), "response_time": response_time}

    async def run_concurrent_requests(self, endpoint: str, num_requests: int):
        """
        并发执行多个请求
        """
        import asyncio

        tasks = [self.run_single_request(endpoint) for _ in range(num_requests)]
        return await asyncio.gather(*tasks)

    def get_stats(self) -> dict:
        """
        获取统计数据
        """
        response_times = self.results["response_times"]
        if not response_times:
            return self.results

        total_requests = self.results["total_requests"]
        total_failures = self.results["total_failures"]

        avg_response_time = sum(response_times) / len(response_times)
        max_response_time = max(response_times)
        min_response_time = min(response_times)
        sorted_times = sorted(response_times)
        p50 = sorted_times[int(len(sorted_times) * 0.5)]
        p90 = sorted_times[int(len(sorted_times) * 0.9)]
        p95 = sorted_times[int(len(sorted_times) * 0.95)]
        p99 = sorted_times[int(len(sorted_times) * 0.99)]

        return {
            "total_requests": total_requests,
            "total_failures": total_failures,
            "failure_rate": total_failures / total_requests if total_requests > 0 else 0,
            "avg_response_time": avg_response_time,
            "max_response_time": max_response_time,
            "min_response_time": min_response_time,
            "p50_response_time": p50,
            "p90_response_time": p90,
            "p95_response_time": p95,
            "p99_response_time": p99,
            "errors": self.results["errors"],
        }

    def print_report(self):
        """
        打印测试报告
        """
        stats = self.get_stats()

        logger.info("=" * 60)
        logger.info("压力测试报告")
        logger.info("=" * 60)
        logger.info(f"总请求数: {stats['total_requests']}")
        logger.info(f"总失败数: {stats['total_failures']}")
        logger.info(f"失败率: {stats['failure_rate']:.2%}")
        logger.info(f"平均响应时间: {stats['avg_response_time']:.2f}ms")
        logger.info(f"P50 响应时间: {stats['p50_response_time']:.2f}ms")
        logger.info(f"P90 响应时间: {stats['p90_response_time']:.2f}ms")
        logger.info(f"P95 响应时间: {stats['p95_response_time']:.2f}ms")
        logger.info(f"P99 响应时间: {stats['p99_response_time']:.2f}ms")
        logger.info(f"最大响应时间: {stats['max_response_time']:.2f}ms")
        logger.info(f"最小响应时间: {stats['min_response_time']:.2f}ms")

        if stats["errors"]:
            logger.info("-" * 60)
            logger.info(f"错误列表 ({len(stats['errors'])} 条):")
            for error in stats["errors"][:10]:
                logger.info(f"  - {error}")

        logger.info("=" * 60)


# 测试运行脚本
def run_stress_test():
    """
    运行压力测试
    """
    import asyncio

    test = SimpleStressTest()

    endpoints = [
        "/api/v1/search?keyword=account",
        "/api/v1/lineage/table/oracle:finance:account_balance?depth=3",
        "/api/v1/assets/table/oracle:finance:account_balance",
    ]

    # 模拟 50 个并发用户
    for endpoint in endpoints:
        asyncio.run(test.run_concurrent_requests(endpoint, 50))

    test.print_report()


if __name__ == "__main__":
    run_stress_test()