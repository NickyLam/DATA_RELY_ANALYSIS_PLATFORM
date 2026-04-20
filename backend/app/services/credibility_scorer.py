"""
可信度评分服务
计算血缘关系的可信度评分
"""
import logging
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from enum import Enum
from typing import Any, Dict, List, Optional, Tuple

from pydantic import BaseModel, Field

logger = logging.getLogger(__name__)


class CredibilityLevel(Enum):
    """可信度等级"""
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"
    UNVERIFIED = "unverified"


class EvidenceType(Enum):
    """证据类型"""
    STATIC_ANALYSIS = "static_analysis"
    AUDIT_LOG = "audit_log"
    VSQL_EXECUTION = "vsql_execution"
    MANUAL_VERIFICATION = "manual_verification"
    CROSS_REFERENCE = "cross_reference"
    SCHEMA_MATCH = "schema_match"
    DATA_SAMPLE = "data_sample"


class Evidence(BaseModel):
    """证据模型"""
    evidence_type: EvidenceType = Field(..., description="证据类型")
    weight: float = Field(0.5, ge=0.0, le=1.0, description="权重")
    score: float = Field(0.5, ge=0.0, le=1.0, description="评分")
    timestamp: datetime = Field(default_factory=datetime.now, description="时间戳")
    details: Dict[str, Any] = Field(default_factory=dict, description="详细信息")
    source: Optional[str] = Field(None, description="来源")


class CredibilityScore(BaseModel):
    """可信度评分"""
    lineage_id: str = Field(..., description="血缘 ID")
    overall_score: float = Field(0.0, ge=0.0, le=1.0, description="总体评分")
    level: CredibilityLevel = Field(CredibilityLevel.UNVERIFIED, description="可信度等级")
    evidences: List[Evidence] = Field(default_factory=list, description="证据列表")
    factors: Dict[str, float] = Field(default_factory=dict, description="评分因子")
    confidence_interval: Tuple[float, float] = Field((0.0, 1.0), description="置信区间")
    last_updated: datetime = Field(default_factory=datetime.now, description="最后更新时间")
    recommendation: Optional[str] = Field(None, description="建议")


@dataclass
class ScorerConfig:
    """评分器配置"""
    evidence_weights: Dict[EvidenceType, float] = field(default_factory=lambda: {
        EvidenceType.STATIC_ANALYSIS: 0.25,
        EvidenceType.AUDIT_LOG: 0.20,
        EvidenceType.VSQL_EXECUTION: 0.15,
        EvidenceType.MANUAL_VERIFICATION: 0.30,
        EvidenceType.CROSS_REFERENCE: 0.10,
        EvidenceType.SCHEMA_MATCH: 0.05,
        EvidenceType.DATA_SAMPLE: 0.05,
    })
    high_threshold: float = 0.75
    medium_threshold: float = 0.50
    low_threshold: float = 0.25
    execution_count_boost_factor: float = 0.01
    max_execution_boost: float = 0.20
    time_decay_factor: float = 0.95
    time_decay_days: int = 30
    multi_source_boost: float = 0.15
    conflict_penalty: float = 0.10
    min_evidence_count: int = 1


class CredibilityScorer:
    """
    可信度评分服务
    
    根据多种证据计算血缘关系的可信度评分
    """
    
    def __init__(
        self,
        config: Optional[ScorerConfig] = None,
    ):
        """
        初始化可信度评分器
        
        Args:
            config: 评分器配置
        """
        self.config = config or ScorerConfig()
        self._score_cache: Dict[str, CredibilityScore] = {}
    
    def calculate_score(
        self,
        lineage_id: str,
        evidences: List[Evidence],
        execution_count: int = 0,
        first_seen: Optional[datetime] = None,
        last_seen: Optional[datetime] = None,
        has_static_source: bool = False,
        has_runtime_source: bool = False,
    ) -> CredibilityScore:
        """
        计算可信度评分
        
        Args:
            lineage_id: 血缘 ID
            evidences: 证据列表
            execution_count: 执行次数
            first_seen: 首次发现时间
            last_seen: 最后发现时间
            has_static_source: 是否有静态来源
            has_runtime_source: 是否有运行态来源
        
        Returns:
            CredibilityScore: 可信度评分
        """
        if not evidences:
            return CredibilityScore(
                lineage_id=lineage_id,
                overall_score=0.0,
                level=CredibilityLevel.UNVERIFIED,
                recommendation="需要添加证据来验证血缘关系",
            )
        
        factors: Dict[str, float] = {}
        
        base_score = self._calculate_base_score(evidences)
        factors["base_score"] = base_score
        
        execution_boost = self._calculate_execution_boost(execution_count)
        factors["execution_boost"] = execution_boost
        
        time_decay = self._calculate_time_decay(last_seen)
        factors["time_decay"] = time_decay
        
        multi_source_boost = self._calculate_multi_source_boost(
            has_static_source,
            has_runtime_source,
            len(evidences),
        )
        factors["multi_source_boost"] = multi_source_boost
        
        conflict_penalty = self._detect_conflicts(evidences)
        factors["conflict_penalty"] = conflict_penalty
        
        overall_score = base_score + execution_boost + multi_source_boost - conflict_penalty
        overall_score = overall_score * time_decay
        overall_score = max(0.0, min(1.0, overall_score))
        
        level = self._determine_level(overall_score)
        
        confidence_interval = self._calculate_confidence_interval(
            overall_score,
            len(evidences),
        )
        
        recommendation = self._generate_recommendation(
            level,
            factors,
            evidences,
        )
        
        score = CredibilityScore(
            lineage_id=lineage_id,
            overall_score=overall_score,
            level=level,
            evidences=evidences,
            factors=factors,
            confidence_interval=confidence_interval,
            recommendation=recommendation,
        )
        
        self._score_cache[lineage_id] = score
        
        return score
    
    def _calculate_base_score(self, evidences: List[Evidence]) -> float:
        """
        计算基础评分
        
        Args:
            evidences: 证据列表
        
        Returns:
            float: 基础评分
        """
        total_weight = 0.0
        weighted_sum = 0.0
        
        for evidence in evidences:
            evidence_weight = self.config.evidence_weights.get(
                evidence.evidence_type,
                0.1,
            )
            effective_weight = evidence_weight * evidence.weight
            total_weight += effective_weight
            weighted_sum += effective_weight * evidence.score
        
        if total_weight > 0:
            return weighted_sum / total_weight
        return 0.5
    
    def _calculate_execution_boost(self, execution_count: int) -> float:
        """
        计算执行次数增强
        
        Args:
            execution_count: 执行次数
        
        Returns:
            float: 增强值
        """
        boost = execution_count * self.config.execution_count_boost_factor
        return min(boost, self.config.max_execution_boost)
    
    def _calculate_time_decay(self, last_seen: Optional[datetime]) -> float:
        """
        计算时间衰减
        
        Args:
            last_seen: 最后发现时间
        
        Returns:
            float: 衰减因子
        """
        if last_seen is None:
            return 1.0
        
        now = datetime.now()
        days_passed = (now - last_seen).days
        
        if days_passed <= 0:
            return 1.0
        
        decay_periods = days_passed / self.config.time_decay_days
        decay = self.config.time_decay_factor ** decay_periods
        
        return max(0.5, decay)
    
    def _calculate_multi_source_boost(
        self,
        has_static_source: bool,
        has_runtime_source: bool,
        evidence_count: int,
    ) -> float:
        """
        计算多源增强
        
        Args:
            has_static_source: 是否有静态来源
            has_runtime_source: 是否有运行态来源
            evidence_count: 证据数量
        
        Returns:
            float: 增强值
        """
        boost = 0.0
        
        if has_static_source and has_runtime_source:
            boost += self.config.multi_source_boost
        
        if evidence_count >= 3:
            boost += 0.05
        if evidence_count >= 5:
            boost += 0.05
        
        return boost
    
    def _detect_conflicts(self, evidences: List[Evidence]) -> float:
        """
        检测证据冲突
        
        Args:
            evidences: 证据列表
        
        Returns:
            float: 冲突惩罚值
        """
        if len(evidences) < 2:
            return 0.0
        
        scores = [e.score for e in evidences]
        
        max_score = max(scores)
        min_score = min(scores)
        
        score_range = max_score - min_score
        
        if score_range > 0.5:
            return self.config.conflict_penalty * 2
        elif score_range > 0.3:
            return self.config.conflict_penalty
        
        return 0.0
    
    def _determine_level(self, score: float) -> CredibilityLevel:
        """
        确定可信度等级
        
        Args:
            score: 评分
        
        Returns:
            CredibilityLevel: 可信度等级
        """
        if score >= self.config.high_threshold:
            return CredibilityLevel.HIGH
        elif score >= self.config.medium_threshold:
            return CredibilityLevel.MEDIUM
        elif score >= self.config.low_threshold:
            return CredibilityLevel.LOW
        else:
            return CredibilityLevel.UNVERIFIED
    
    def _calculate_confidence_interval(
        self,
        score: float,
        evidence_count: int,
    ) -> Tuple[float, float]:
        """
        计算置信区间
        
        Args:
            score: 评分
            evidence_count: 证据数量
        
        Returns:
            Tuple[float, float]: 置信区间
        """
        if evidence_count <= 1:
            margin = 0.3
        elif evidence_count <= 3:
            margin = 0.2
        elif evidence_count <= 5:
            margin = 0.1
        else:
            margin = 0.05
        
        lower = max(0.0, score - margin)
        upper = min(1.0, score + margin)
        
        return (lower, upper)
    
    def _generate_recommendation(
        self,
        level: CredibilityLevel,
        factors: Dict[str, float],
        evidences: List[Evidence],
    ) -> str:
        """
        生成建议
        
        Args:
            level: 可信度等级
            factors: 评分因子
            evidences: 证据列表
        
        Returns:
            str: 建议
        """
        if level == CredibilityLevel.HIGH:
            return "血缘关系可信度高，可用于生产决策"
        
        recommendations: List[str] = []
        
        if factors.get("base_score", 0) < 0.5:
            recommendations.append("建议增加更多证据来源")
        
        if factors.get("execution_boost", 0) < 0.1:
            recommendations.append("建议收集更多执行记录")
        
        if factors.get("time_decay", 1) < 0.8:
            recommendations.append("血缘数据较旧，建议重新验证")
        
        if factors.get("conflict_penalty", 0) > 0:
            recommendations.append("存在证据冲突，建议人工审核")
        
        has_manual = any(e.evidence_type == EvidenceType.MANUAL_VERIFICATION for e in evidences)
        if not has_manual and level == CredibilityLevel.MEDIUM:
            recommendations.append("建议进行人工验证以提高可信度")
        
        if recommendations:
            return "; ".join(recommendations)
        
        return "血缘关系基本可信，建议持续监控"
    
    def add_evidence(
        self,
        lineage_id: str,
        evidence_type: EvidenceType,
        score: float = 0.5,
        weight: float = 0.5,
        details: Optional[Dict[str, Any]] = None,
        source: Optional[str] = None,
    ) -> Evidence:
        """
        添加证据
        
        Args:
            lineage_id: 血缘 ID
            evidence_type: 证据类型
            score: 评分
            weight: 权重
            details: 详细信息
            source: 来源
        
        Returns:
            Evidence: 创建的证据
        """
        evidence = Evidence(
            evidence_type=evidence_type,
            weight=weight,
            score=score,
            details=details or {},
            source=source,
        )
        
        cached_score = self._score_cache.get(lineage_id)
        if cached_score:
            cached_score.evidences.append(evidence)
            cached_score.last_updated = datetime.now()
        
        return evidence
    
    def get_score(self, lineage_id: str) -> Optional[CredibilityScore]:
        """
        获取评分
        
        Args:
            lineage_id: 血缘 ID
        
        Returns:
            Optional[CredibilityScore]: 可信度评分
        """
        return self._score_cache.get(lineage_id)
    
    def update_score(
        self,
        lineage_id: str,
        new_evidence: Optional[Evidence] = None,
        execution_count_delta: int = 0,
    ) -> Optional[CredibilityScore]:
        """
        更新评分
        
        Args:
            lineage_id: 血缘 ID
            new_evidence: 新证据
            execution_count_delta: 执行次数增量
        
        Returns:
            Optional[CredibilityScore]: 更新后的评分
        """
        cached_score = self._score_cache.get(lineage_id)
        if not cached_score:
            return None
        
        if new_evidence:
            cached_score.evidences.append(new_evidence)
        
        factors = cached_score.factors
        
        if execution_count_delta > 0:
            current_boost = factors.get("execution_boost", 0)
            new_boost = current_boost + execution_count_delta * self.config.execution_count_boost_factor
            factors["execution_boost"] = min(new_boost, self.config.max_execution_boost)
        
        base_score = self._calculate_base_score(cached_score.evidences)
        factors["base_score"] = base_score
        
        conflict_penalty = self._detect_conflicts(cached_score.evidences)
        factors["conflict_penalty"] = conflict_penalty
        
        overall_score = (
            base_score
            + factors.get("execution_boost", 0)
            + factors.get("multi_source_boost", 0)
            - conflict_penalty
        )
        overall_score = overall_score * factors.get("time_decay", 1.0)
        overall_score = max(0.0, min(1.0, overall_score))
        
        cached_score.overall_score = overall_score
        cached_score.level = self._determine_level(overall_score)
        cached_score.confidence_interval = self._calculate_confidence_interval(
            overall_score,
            len(cached_score.evidences),
        )
        cached_score.last_updated = datetime.now()
        cached_score.recommendation = self._generate_recommendation(
            cached_score.level,
            factors,
            cached_score.evidences,
        )
        
        return cached_score
    
    def batch_calculate_scores(
        self,
        lineage_data: List[Dict[str, Any]],
    ) -> List[CredibilityScore]:
        """
        批量计算评分
        
        Args:
            lineage_data: 血缘数据列表
        
        Returns:
            List[CredibilityScore]: 评分列表
        """
        scores: List[CredibilityScore] = []
        
        for data in lineage_data:
            lineage_id = data.get("lineage_id", "")
            
            evidences_data = data.get("evidences", [])
            evidences: List[Evidence] = []
            
            for ev_data in evidences_data:
                try:
                    evidence_type = EvidenceType(ev_data.get("evidence_type", "static_analysis"))
                    evidences.append(Evidence(
                        evidence_type=evidence_type,
                        weight=ev_data.get("weight", 0.5),
                        score=ev_data.get("score", 0.5),
                        details=ev_data.get("details", {}),
                        source=ev_data.get("source"),
                    ))
                except Exception as e:
                    logger.warning(f"解析证据失败: {e}")
            
            score = self.calculate_score(
                lineage_id=lineage_id,
                evidences=evidences,
                execution_count=data.get("execution_count", 0),
                first_seen=data.get("first_seen"),
                last_seen=data.get("last_seen"),
                has_static_source=data.get("has_static_source", False),
                has_runtime_source=data.get("has_runtime_source", False),
            )
            scores.append(score)
        
        return scores
    
    def get_statistics(self) -> Dict[str, Any]:
        """
        获取评分统计
        
        Returns:
            Dict[str, Any]: 统计信息
        """
        total_scores = len(self._score_cache)
        
        by_level: Dict[str, int] = {
            "high": 0,
            "medium": 0,
            "low": 0,
            "unverified": 0,
        }
        
        by_evidence_type: Dict[str, int] = {}
        
        average_score = 0.0
        
        for score in self._score_cache.values():
            by_level[score.level.value] += 1
            average_score += score.overall_score
            
            for evidence in score.evidences:
                ev_type = evidence.evidence_type.value
                by_evidence_type[ev_type] = by_evidence_type.get(ev_type, 0) + 1
        
        if total_scores > 0:
            average_score /= total_scores
        
        return {
            "total_scores": total_scores,
            "by_level": by_level,
            "by_evidence_type": by_evidence_type,
            "average_score": average_score,
            "high_confidence_count": by_level["high"],
            "needs_verification_count": by_level["low"] + by_level["unverified"],
        }
    
    def filter_by_credibility(
        self,
        min_score: float = 0.5,
        min_level: Optional[CredibilityLevel] = None,
    ) -> List[CredibilityScore]:
        """
        按可信度过滤
        
        Args:
            min_score: 最小评分
            min_level: 最小等级
        
        Returns:
            List[CredibilityScore]: 过滤后的评分列表
        """
        results: List[CredibilityScore] = []
        
        level_order = {
            CredibilityLevel.HIGH: 4,
            CredibilityLevel.MEDIUM: 3,
            CredibilityLevel.LOW: 2,
            CredibilityLevel.UNVERIFIED: 1,
        }
        
        min_level_value = level_order.get(min_level, 0) if min_level else 0
        
        for score in self._score_cache.values():
            if score.overall_score >= min_score:
                if min_level and level_order.get(score.level, 0) >= min_level_value:
                    results.append(score)
                elif not min_level:
                    results.append(score)
        
        return results
    
    def get_low_credibility_lineages(self) -> List[CredibilityScore]:
        """
        获取低可信度血缘
        
        Returns:
            List[CredibilityScore]: 低可信度评分列表
        """
        return [
            score for score in self._score_cache.values()
            if score.level in (CredibilityLevel.LOW, CredibilityLevel.UNVERIFIED)
        ]
    
    def decay_old_scores(self, days_threshold: int = 30) -> int:
        """
        衰减旧评分
        
        Args:
            days_threshold: 天数阈值
        
        Returns:
            int: 衰减的数量
        """
        decayed_count = 0
        
        now = datetime.now()
        threshold_date = now - timedelta(days=days_threshold)
        
        for score in self._score_cache.values():
            if score.last_updated < threshold_date:
                factors = score.factors
                
                current_decay = factors.get("time_decay", 1.0)
                new_decay = current_decay * self.config.time_decay_factor
                factors["time_decay"] = max(0.5, new_decay)
                
                overall_score = score.overall_score * new_decay
                score.overall_score = max(0.0, min(1.0, overall_score))
                score.level = self._determine_level(score.overall_score)
                
                decayed_count += 1
        
        logger.info(f"衰减了 {decayed_count} 个旧评分")
        return decayed_count
    
    def clear_cache(self) -> None:
        """清空缓存"""
        self._score_cache.clear()
        logger.info("可信度评分缓存已清空")
    
    def export_scores(self) -> List[Dict[str, Any]]:
        """
        导出评分数据
        
        Returns:
            List[Dict[str, Any]]: 评分数据列表
        """
        return [score.model_dump() for score in self._score_cache.values()]
    
    def import_scores(
        self,
        scores_data: List[Dict[str, Any]],
    ) -> int:
        """
        导入评分数据
        
        Args:
            scores_data: 评分数据列表
        
        Returns:
            int: 导入数量
        """
        imported_count = 0
        
        for data in scores_data:
            try:
                evidences: List[Evidence] = []
                for ev_data in data.get("evidences", []):
                    evidence_type = EvidenceType(ev_data.get("evidence_type", "static_analysis"))
                    evidences.append(Evidence(
                        evidence_type=evidence_type,
                        weight=ev_data.get("weight", 0.5),
                        score=ev_data.get("score", 0.5),
                        timestamp=datetime.fromisoformat(ev_data.get("timestamp", datetime.now().isoformat())),
                        details=ev_data.get("details", {}),
                        source=ev_data.get("source"),
                    ))
                
                score = CredibilityScore(
                    lineage_id=data["lineage_id"],
                    overall_score=data.get("overall_score", 0.0),
                    level=CredibilityLevel(data.get("level", "unverified")),
                    evidences=evidences,
                    factors=data.get("factors", {}),
                    confidence_interval=tuple(data.get("confidence_interval", (0.0, 1.0))),
                    last_updated=datetime.fromisoformat(data.get("last_updated", datetime.now().isoformat())),
                    recommendation=data.get("recommendation"),
                )
                
                self._score_cache[score.lineage_id] = score
                imported_count += 1
                
            except Exception as e:
                logger.warning(f"导入评分数据失败: {e}")
        
        logger.info(f"导入 {imported_count} 条评分数据")
        return imported_count