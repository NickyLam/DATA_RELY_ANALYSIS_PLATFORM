/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_riskacct_list
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_rb_riskacct_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_riskacct_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_riskacct_list_op purge;
drop table ${iol_schema}.ncbs_rb_riskacct_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_riskacct_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_riskacct_list where 0=1;

create table ${iol_schema}.ncbs_rb_riskacct_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_riskacct_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_riskacct_list_cl(
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
            ,uncounter_desc -- 入表原因
            ,asyn_date -- 同步日期
            ,black_check_time -- 黑名单检查时间
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,acct_branch -- 开户机构编号
            ,input_branch -- 录入机构
            ,oper_user_id -- 操作柜员
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_riskacct_list_op(
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
            ,uncounter_desc -- 入表原因
            ,asyn_date -- 同步日期
            ,black_check_time -- 黑名单检查时间
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,acct_branch -- 开户机构编号
            ,input_branch -- 录入机构
            ,oper_user_id -- 操作柜员
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.asyn_id, o.asyn_id) as asyn_id -- 异步编号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.batch_status, o.batch_status) as batch_status -- 批次处理状态
    ,nvl(n.black_desc, o.black_desc) as black_desc -- 黑名单描述
    ,nvl(n.black_no, o.black_no) as black_no -- 黑名单编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.error_code, o.error_code) as error_code -- 错误码
    ,nvl(n.error_desc, o.error_desc) as error_desc -- 错误描述
    ,nvl(n.examine_flag, o.examine_flag) as examine_flag -- 可疑账户核实标志
    ,nvl(n.examine_teller, o.examine_teller) as examine_teller -- 检查柜面
    ,nvl(n.job_run_id, o.job_run_id) as job_run_id -- 批处理任务id
    ,nvl(n.list_operate_type, o.list_operate_type) as list_operate_type -- 名单操作类型
    ,nvl(n.list_source, o.list_source) as list_source -- 名单来源
    ,nvl(n.our_bank_flag, o.our_bank_flag) as our_bank_flag -- 黑名单客户标志
    ,nvl(n.uncounter_desc, o.uncounter_desc) as uncounter_desc -- 入表原因
    ,nvl(n.asyn_date, o.asyn_date) as asyn_date -- 同步日期
    ,nvl(n.black_check_time, o.black_check_time) as black_check_time -- 黑名单检查时间
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 失效日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_branch, o.acct_branch) as acct_branch -- 开户机构编号
    ,nvl(n.input_branch, o.input_branch) as input_branch -- 录入机构
    ,nvl(n.oper_user_id, o.oper_user_id) as oper_user_id -- 操作柜员
    ,nvl(n.remark1, o.remark1) as remark1 -- 备注1
    ,nvl(n.remark2, o.remark2) as remark2 -- 备注2
    ,nvl(n.remark3, o.remark3) as remark3 -- 备注3
    ,case when
            n.batch_no is null
            and n.black_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_no is null
            and n.black_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_no is null
            and n.black_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_riskacct_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_riskacct_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batch_no = n.batch_no
            and o.black_no = n.black_no
where (
        o.batch_no is null
        and o.black_no is null
    )
    or (
        n.batch_no is null
        and n.black_no is null
    )
    or (
        o.acct_status <> n.acct_status
        or o.base_acct_no <> n.base_acct_no
        or o.client_name <> n.client_name
        or o.client_no <> n.client_no
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.asyn_id <> n.asyn_id
        or o.batch_status <> n.batch_status
        or o.black_desc <> n.black_desc
        or o.company <> n.company
        or o.error_code <> n.error_code
        or o.error_desc <> n.error_desc
        or o.examine_flag <> n.examine_flag
        or o.examine_teller <> n.examine_teller
        or o.job_run_id <> n.job_run_id
        or o.list_operate_type <> n.list_operate_type
        or o.list_source <> n.list_source
        or o.our_bank_flag <> n.our_bank_flag
        or o.uncounter_desc <> n.uncounter_desc
        or o.asyn_date <> n.asyn_date
        or o.black_check_time <> n.black_check_time
        or o.effect_date <> n.effect_date
        or o.expire_date <> n.expire_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_branch <> n.acct_branch
        or o.input_branch <> n.input_branch
        or o.oper_user_id <> n.oper_user_id
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_riskacct_list_cl(
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
            ,uncounter_desc -- 入表原因
            ,asyn_date -- 同步日期
            ,black_check_time -- 黑名单检查时间
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,acct_branch -- 开户机构编号
            ,input_branch -- 录入机构
            ,oper_user_id -- 操作柜员
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_riskacct_list_op(
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
            ,uncounter_desc -- 入表原因
            ,asyn_date -- 同步日期
            ,black_check_time -- 黑名单检查时间
            ,effect_date -- 产品生效日期
            ,expire_date -- 失效日期
            ,tran_timestamp -- 交易时间戳
            ,acct_branch -- 开户机构编号
            ,input_branch -- 录入机构
            ,oper_user_id -- 操作柜员
            ,remark1 -- 备注1
            ,remark2 -- 备注2
            ,remark3 -- 备注3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_status -- 账户状态
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_name -- 客户名称
    ,o.client_no -- 客户编号
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.asyn_id -- 异步编号
    ,o.batch_no -- 批次号
    ,o.batch_status -- 批次处理状态
    ,o.black_desc -- 黑名单描述
    ,o.black_no -- 黑名单编号
    ,o.company -- 法人
    ,o.error_code -- 错误码
    ,o.error_desc -- 错误描述
    ,o.examine_flag -- 可疑账户核实标志
    ,o.examine_teller -- 检查柜面
    ,o.job_run_id -- 批处理任务id
    ,o.list_operate_type -- 名单操作类型
    ,o.list_source -- 名单来源
    ,o.our_bank_flag -- 黑名单客户标志
    ,o.uncounter_desc -- 入表原因
    ,o.asyn_date -- 同步日期
    ,o.black_check_time -- 黑名单检查时间
    ,o.effect_date -- 产品生效日期
    ,o.expire_date -- 失效日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_branch -- 开户机构编号
    ,o.input_branch -- 录入机构
    ,o.oper_user_id -- 操作柜员
    ,o.remark1 -- 备注1
    ,o.remark2 -- 备注2
    ,o.remark3 -- 备注3
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_riskacct_list_bk o
    left join ${iol_schema}.ncbs_rb_riskacct_list_op n
        on
            o.batch_no = n.batch_no
            and o.black_no = n.black_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_riskacct_list_cl d
        on
            o.batch_no = d.batch_no
            and o.black_no = d.black_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_riskacct_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_riskacct_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_riskacct_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_riskacct_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_riskacct_list exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_riskacct_list_cl;
alter table ${iol_schema}.ncbs_rb_riskacct_list exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_riskacct_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_riskacct_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_riskacct_list_op purge;
drop table ${iol_schema}.ncbs_rb_riskacct_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_riskacct_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_riskacct_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
