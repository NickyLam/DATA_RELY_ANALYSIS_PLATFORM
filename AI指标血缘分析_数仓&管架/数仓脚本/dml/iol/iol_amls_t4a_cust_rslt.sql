/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t4a_cust_rslt
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
drop table ${iol_schema}.amls_t4a_cust_rslt_ex purge;
alter table ${iol_schema}.amls_t4a_cust_rslt add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.amls_t4a_cust_rslt;

-- 2.3 insert data to ex table
create table ${iol_schema}.amls_t4a_cust_rslt_ex nologging
compress
as
select * from ${iol_schema}.amls_t4a_cust_rslt where 0=1;

insert /*+ append */ into ${iol_schema}.amls_t4a_cust_rslt_ex(
    rslt_id -- 评级结果编码
    ,model_id -- 模板编码
    ,fomula_id -- 公式编号
    ,cust_id -- 客户号
    ,cust_name -- 客户名称
    ,first_lvl -- 初评等级  t1h_risk_lvl_map
    ,adjust_lvl -- 调整等级  t1h_risk_lvl_map
    ,curr_lvl -- 最终风险等级  t1h_risk_lvl_map
    ,last_lvl -- 上次评级结果
    ,stat_dt -- 评级日期
    ,cust_type -- 客户类型
    ,org_id -- 客户机构
    ,rslt_sts -- 评级结果状态[AML0132]
    ,model_type -- 评级模板类型AML0124
    ,model_freq -- 计算频度（参见[字典:T00026]）
    ,create_dt -- 建立日期
    ,post_id -- 当前岗位（参见[字典:AML0113]）
    ,flow_id -- 流程ID （参见[字典:AML0114]）
    ,modifier -- 调整人
    ,modify_tm -- 调整时间
    ,reason -- 调整原因
    ,model_catg -- 评级类别AML0122
    ,score -- 得分
    ,curr_score -- 调整后得分
    ,is_adjust_score -- 分值是否调整
    ,due_dt -- 处理时限
    ,next_stat_dt -- 下次评级日期
    ,assist_sts -- 协查状态
    ,rate_source -- 评级来源：1-系统评级；2-重新调整
    ,rate_type -- 重评发起方式：1-系统重评；2-人工调整
    ,re_adjust_dt -- 重评发起日期
    ,adjust_score_reason -- 分值调整原因
    ,cust_sts -- 客户状态(0:销户1:正常)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    rslt_id -- 评级结果编码
    ,model_id -- 模板编码
    ,fomula_id -- 公式编号
    ,cust_id -- 客户号
    ,cust_name -- 客户名称
    ,first_lvl -- 初评等级  t1h_risk_lvl_map
    ,adjust_lvl -- 调整等级  t1h_risk_lvl_map
    ,curr_lvl -- 最终风险等级  t1h_risk_lvl_map
    ,last_lvl -- 上次评级结果
    ,stat_dt -- 评级日期
    ,cust_type -- 客户类型
    ,org_id -- 客户机构
    ,rslt_sts -- 评级结果状态[AML0132]
    ,model_type -- 评级模板类型AML0124
    ,model_freq -- 计算频度（参见[字典:T00026]）
    ,create_dt -- 建立日期
    ,post_id -- 当前岗位（参见[字典:AML0113]）
    ,flow_id -- 流程ID （参见[字典:AML0114]）
    ,modifier -- 调整人
    ,modify_tm -- 调整时间
    ,reason -- 调整原因
    ,model_catg -- 评级类别AML0122
    ,score -- 得分
    ,curr_score -- 调整后得分
    ,is_adjust_score -- 分值是否调整
    ,due_dt -- 处理时限
    ,next_stat_dt -- 下次评级日期
    ,assist_sts -- 协查状态
    ,rate_source -- 评级来源：1-系统评级；2-重新调整
    ,rate_type -- 重评发起方式：1-系统重评；2-人工调整
    ,re_adjust_dt -- 重评发起日期
    ,adjust_score_reason -- 分值调整原因
    ,cust_sts -- 客户状态(0:销户1:正常)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.amls_t4a_cust_rslt
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.amls_t4a_cust_rslt exchange partition p_${batch_date} with table ${iol_schema}.amls_t4a_cust_rslt_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t4a_cust_rslt to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.amls_t4a_cust_rslt_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t4a_cust_rslt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);