/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_flow_opinion_oass
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_flow_opinion_oass_ex purge;
alter table ${iol_schema}.icms_flow_opinion_oass add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_flow_opinion_oass;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_flow_opinion_oass_ex nologging
compress
as
select * from ${iol_schema}.icms_flow_opinion_oass where 0=1;

insert /*+ append */ into ${iol_schema}.icms_flow_opinion_oass_ex(
    serialno -- 流程节点编号
    ,opinionno -- 意见编号
    ,objecttype -- 流程对象任务类型
    ,objectno -- 流程对象编号
    ,customerid -- 客户编号
    ,customername -- 客户名称
    ,businesscurrency -- 业务币种
    ,businesssum -- 名义金额
    ,termyear -- 期限（年）
    ,termmonth -- 期限（月）
    ,termday -- 期限（日）
    ,baseratetype -- 基准利率类型
    ,ratefloattype -- 利率浮动方式
    ,ratefloat -- 利率浮动值
    ,bailcurrency -- 保证金币种
    ,businessrate -- 执行利率
    ,bailratio -- 保证金比率
    ,bailsum -- 保证金金额
    ,pdgratio -- 手续费比率
    ,pdgsum -- 手续费金额
    ,baserate -- 基准年)利率
    ,phaseopinion -- 节点意见详情
    ,phaseopinion1 -- 意见详情1
    ,phaseopinion2 -- 意见详情2
    ,phaseopinion3 -- 意见详情3
    ,exposuresum -- 敞口金额
    ,opiniontype -- 意见类型
    ,inputorg -- 登记机构
    ,inputuser -- 登记人
    ,updateorg -- 更新机构
    ,updateuser -- 更新人
    ,inputtime -- 登记时间
    ,updatetime -- 更新时间
    ,phasechoice -- 阶段意见
    ,warehousing -- 是否入库
    ,payreq -- 授信方案
    ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
    ,contractreq -- 需落实到合同、协议中的特殊要求
    ,loanmanagereq -- 贷后管理要求
    ,agreemachine -- 是否认可机器决策结果
    ,riskexposuresum -- 其中，一般风险敞口限额
    ,iscycle -- 是否循环(额度)是否循环
    ,isyeartocheck -- 是否需要年审
    ,isjoinlimits -- 是否纳入单一客户或集团的限额
    ,onlineamount -- 线上额度(元)
    ,repaytype -- 还款方式
    ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,balloonamortenddate -- 气球贷摊销到期日
    ,coopterm -- 合作期限(月)
    ,nominalsum -- 项目总额度(元)
    ,firstusesum -- 先期启用额度
    ,migtflag -- 迁移标志：crs rcr ilc upl
    ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serialno -- 流程节点编号
    ,opinionno -- 意见编号
    ,objecttype -- 流程对象任务类型
    ,objectno -- 流程对象编号
    ,customerid -- 客户编号
    ,customername -- 客户名称
    ,businesscurrency -- 业务币种
    ,businesssum -- 名义金额
    ,termyear -- 期限（年）
    ,termmonth -- 期限（月）
    ,termday -- 期限（日）
    ,baseratetype -- 基准利率类型
    ,ratefloattype -- 利率浮动方式
    ,ratefloat -- 利率浮动值
    ,bailcurrency -- 保证金币种
    ,businessrate -- 执行利率
    ,bailratio -- 保证金比率
    ,bailsum -- 保证金金额
    ,pdgratio -- 手续费比率
    ,pdgsum -- 手续费金额
    ,baserate -- 基准年)利率
    ,phaseopinion -- 节点意见详情
    ,phaseopinion1 -- 意见详情1
    ,phaseopinion2 -- 意见详情2
    ,phaseopinion3 -- 意见详情3
    ,exposuresum -- 敞口金额
    ,opiniontype -- 意见类型
    ,inputorg -- 登记机构
    ,inputuser -- 登记人
    ,updateorg -- 更新机构
    ,updateuser -- 更新人
    ,inputtime -- 登记时间
    ,updatetime -- 更新时间
    ,phasechoice -- 阶段意见
    ,warehousing -- 是否入库
    ,payreq -- 授信方案
    ,afterpayreq -- 发放与支付前须落实的特殊限制性条件
    ,contractreq -- 需落实到合同、协议中的特殊要求
    ,loanmanagereq -- 贷后管理要求
    ,agreemachine -- 是否认可机器决策结果
    ,riskexposuresum -- 其中，一般风险敞口限额
    ,iscycle -- 是否循环(额度)是否循环
    ,isyeartocheck -- 是否需要年审
    ,isjoinlimits -- 是否纳入单一客户或集团的限额
    ,onlineamount -- 线上额度(元)
    ,repaytype -- 还款方式
    ,repaycycle -- 还款周期还款周期(1月2季3一次4半年5年6双月)
    ,balloonamortenddate -- 气球贷摊销到期日
    ,coopterm -- 合作期限(月)
    ,nominalsum -- 项目总额度(元)
    ,firstusesum -- 先期启用额度
    ,migtflag -- 迁移标志：crs rcr ilc upl
    ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_flow_opinion_oass
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_flow_opinion_oass exchange partition p_${batch_date} with table ${iol_schema}.icms_flow_opinion_oass_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_flow_opinion_oass to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_flow_opinion_oass_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_flow_opinion_oass',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);