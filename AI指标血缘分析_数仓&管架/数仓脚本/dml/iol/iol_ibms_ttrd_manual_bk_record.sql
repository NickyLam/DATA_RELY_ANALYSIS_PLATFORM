/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_manual_bk_record
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
drop table ${iol_schema}.ibms_ttrd_manual_bk_record_ex purge;
alter table ${iol_schema}.ibms_ttrd_manual_bk_record add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ibms_ttrd_manual_bk_record truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_manual_bk_record_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_manual_bk_record where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_manual_bk_record_ex(
    record_id -- 记录id
    ,account_date -- 记账日期
    ,bkkpg_org_id -- 记账机构号
    ,flow_id -- 分录流水号
    ,hostflow_no -- 核心流水号
    ,create_user -- 录入柜员id
    ,create_user_name -- 录入柜员名称
    ,acct_user -- 记账柜员id
    ,acct_user_name -- 记账柜员名称
    ,erase_user -- 抹账授权柜员id
    ,erase_user_name -- 抹账授权柜员名称
    ,create_time -- 录入时间
    ,account_time -- 记账时间
    ,erase_time -- 抹账时间
    ,state -- 状态:0,新建 1,未记账 2,已记账
    ,remark -- 备注
    ,inst_id -- 券/资金指令号
    ,acct_review_user -- 记账复核人
    ,acct_review_user_name -- 记账复核人名称
    ,eraseuser -- 抹账人
    ,eraseuser_name -- 抹账人名称
    ,acct_type -- 状态:0,仅核心记账  1,核心、资金系统记账
    ,trade_id -- 
    ,bk_flag -- 记账标识，0：内部户，1：科目
    ,obj_id -- 核算余额id
    ,party_id -- 当事人编号
    ,party_name -- 当事人编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    record_id -- 记录id
    ,account_date -- 记账日期
    ,bkkpg_org_id -- 记账机构号
    ,flow_id -- 分录流水号
    ,hostflow_no -- 核心流水号
    ,create_user -- 录入柜员id
    ,create_user_name -- 录入柜员名称
    ,acct_user -- 记账柜员id
    ,acct_user_name -- 记账柜员名称
    ,erase_user -- 抹账授权柜员id
    ,erase_user_name -- 抹账授权柜员名称
    ,create_time -- 录入时间
    ,account_time -- 记账时间
    ,erase_time -- 抹账时间
    ,state -- 状态:0,新建 1,未记账 2,已记账
    ,remark -- 备注
    ,inst_id -- 券/资金指令号
    ,acct_review_user -- 记账复核人
    ,acct_review_user_name -- 记账复核人名称
    ,eraseuser -- 抹账人
    ,eraseuser_name -- 抹账人名称
    ,acct_type -- 状态:0,仅核心记账  1,核心、资金系统记账
    ,trade_id -- 
    ,bk_flag -- 记账标识，0：内部户，1：科目
    ,obj_id -- 核算余额id
    ,party_id -- 当事人编号
    ,party_name -- 当事人编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_manual_bk_record
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_manual_bk_record exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_manual_bk_record_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_manual_bk_record to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_manual_bk_record_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_manual_bk_record',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);