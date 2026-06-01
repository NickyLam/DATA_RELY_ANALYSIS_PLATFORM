/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_safe_list
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
drop table ${iol_schema}.ncbs_rb_safe_list_ex purge;
alter table ${iol_schema}.ncbs_rb_safe_list add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_safe_list;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_safe_list_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_safe_list where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_safe_list_ex(
    acct_status -- 账户状态
    ,base_acct_no -- 交易账号/卡号
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,asyn_id -- 异步编号
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,black_desc -- 黑名单描述
    ,black_no -- 黑名单编号
    ,company -- 法人
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,examine_flag -- 可疑账户核实标志
    ,examine_teller -- 检查柜面
    ,job_run_id -- 批处理任务id
    ,list_operate_type -- 名单操作类型
    ,list_source -- 名单来源
    ,our_bank_flag -- 黑名单客户标志
    ,ret_msg -- 服务状态描述
    ,uncounter_desc -- 入表原因
    ,asyn_date -- 同步日期
    ,black_check_time -- 黑名单检查时间
    ,effect_date -- 产品生效日期
    ,expire_date -- 失效日期
    ,tran_timestamp -- 交易时间戳
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_status -- 账户状态
    ,base_acct_no -- 交易账号/卡号
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,asyn_id -- 异步编号
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,black_desc -- 黑名单描述
    ,black_no -- 黑名单编号
    ,company -- 法人
    ,error_code -- 错误码
    ,error_desc -- 错误描述
    ,examine_flag -- 可疑账户核实标志
    ,examine_teller -- 检查柜面
    ,job_run_id -- 批处理任务id
    ,list_operate_type -- 名单操作类型
    ,list_source -- 名单来源
    ,our_bank_flag -- 黑名单客户标志
    ,ret_msg -- 服务状态描述
    ,uncounter_desc -- 入表原因
    ,asyn_date -- 同步日期
    ,black_check_time -- 黑名单检查时间
    ,effect_date -- 产品生效日期
    ,expire_date -- 失效日期
    ,tran_timestamp -- 交易时间戳
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_safe_list
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_safe_list exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_safe_list_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_safe_list to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_safe_list_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_safe_list',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);