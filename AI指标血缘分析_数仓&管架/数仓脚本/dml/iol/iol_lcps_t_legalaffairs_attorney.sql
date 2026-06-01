/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_lcps_t_legalaffairs_attorney
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
drop table ${iol_schema}.lcps_t_legalaffairs_attorney_ex purge;
alter table ${iol_schema}.lcps_t_legalaffairs_attorney add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.lcps_t_legalaffairs_attorney;

-- 2.3 insert data to ex table
create table ${iol_schema}.lcps_t_legalaffairs_attorney_ex nologging
compress
as
select * from ${iol_schema}.lcps_t_legalaffairs_attorney where 0=1;

insert /*+ append */ into ${iol_schema}.lcps_t_legalaffairs_attorney_ex(
    id -- 序号
    ,office_code -- 经办单位
    ,agency -- 经办机构
    ,matters -- 委托事项
    ,firm_name -- 受托律师事务所
    ,lawyer_name -- 代理律师
    ,attorney_code -- 委托律师审批编号
    ,case_code -- 案件编号
    ,case_name -- 案件名称
    ,signing_date -- 签约日期
    ,start_time -- 委托开始日期
    ,end_time -- 委托结束日期
    ,authorization_range -- 是否授权范围内（0否 1是）
    ,litigation_amount -- 诉讼仲裁标的金额
    ,entrusted_amount -- 委托费用条款
    ,risk_agency -- 是否风险代理（0否 1是）
    ,legal_service -- 诉讼仲裁事项专项（非诉讼）法律服务
    ,asset_claim -- 是否是不良资产清收（0否 1是）
    ,progress -- 委托事项办理进展情况
    ,agency_results -- 代理结果
    ,actual_payment_amount -- 费用实际支付情况
    ,end_delegation -- 是否结束委托（0否 1是）
    ,status -- 状态（0正常 1删除 2停用）
    ,create_by -- 创建者
    ,create_date -- 创建时间
    ,update_by -- 更新者
    ,update_date -- 更新时间
    ,remarks -- 备注信息
    ,corp_code -- 租户代码
    ,corp_name -- 租户名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 序号
    ,office_code -- 经办单位
    ,agency -- 经办机构
    ,matters -- 委托事项
    ,firm_name -- 受托律师事务所
    ,lawyer_name -- 代理律师
    ,attorney_code -- 委托律师审批编号
    ,case_code -- 案件编号
    ,case_name -- 案件名称
    ,signing_date -- 签约日期
    ,start_time -- 委托开始日期
    ,end_time -- 委托结束日期
    ,authorization_range -- 是否授权范围内（0否 1是）
    ,litigation_amount -- 诉讼仲裁标的金额
    ,entrusted_amount -- 委托费用条款
    ,risk_agency -- 是否风险代理（0否 1是）
    ,legal_service -- 诉讼仲裁事项专项（非诉讼）法律服务
    ,asset_claim -- 是否是不良资产清收（0否 1是）
    ,progress -- 委托事项办理进展情况
    ,agency_results -- 代理结果
    ,actual_payment_amount -- 费用实际支付情况
    ,end_delegation -- 是否结束委托（0否 1是）
    ,status -- 状态（0正常 1删除 2停用）
    ,create_by -- 创建者
    ,create_date -- 创建时间
    ,update_by -- 更新者
    ,update_date -- 更新时间
    ,remarks -- 备注信息
    ,corp_code -- 租户代码
    ,corp_name -- 租户名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.lcps_t_legalaffairs_attorney
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.lcps_t_legalaffairs_attorney exchange partition p_${batch_date} with table ${iol_schema}.lcps_t_legalaffairs_attorney_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.lcps_t_legalaffairs_attorney to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.lcps_t_legalaffairs_attorney_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'lcps_t_legalaffairs_attorney',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);