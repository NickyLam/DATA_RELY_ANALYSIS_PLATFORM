/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_plan_run_info
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
create table ${iol_schema}.ncbs_cl_plan_run_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_plan_run_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_plan_run_info_op purge;
drop table ${iol_schema}.ncbs_cl_plan_run_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_plan_run_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_plan_run_info where 0=1;

create table ${iol_schema}.ncbs_cl_plan_run_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_plan_run_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_plan_run_info_cl(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,event_type -- 事件类型
            ,plan_no -- 执行计划编号
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,tran_status -- 冲补抹标志
            ,deal_date -- 处理日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_plan_run_info_op(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,event_type -- 事件类型
            ,plan_no -- 执行计划编号
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,tran_status -- 冲补抹标志
            ,deal_date -- 处理日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amount, o.amount) as amount -- 金额
    ,nvl(n.amt_type, o.amt_type) as amt_type -- 金额类型
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.error_code, o.error_code) as error_code -- 错误码
    ,nvl(n.error_msg, o.error_msg) as error_msg -- 错误代码
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.plan_no, o.plan_no) as plan_no -- 执行计划编号
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 预留字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 预留字段2
    ,nvl(n.tran_status, o.tran_status) as tran_status -- 冲补抹标志
    ,nvl(n.deal_date, o.deal_date) as deal_date -- 处理日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,case when
            n.plan_no is null
            and n.deal_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.plan_no is null
            and n.deal_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.plan_no is null
            and n.deal_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_plan_run_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_plan_run_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.plan_no = n.plan_no
            and o.deal_date = n.deal_date
where (
        o.plan_no is null
        and o.deal_date is null
    )
    or (
        n.plan_no is null
        and n.deal_date is null
    )
    or (
        o.amount <> n.amount
        or o.amt_type <> n.amt_type
        or o.client_no <> n.client_no
        or o.internal_key <> n.internal_key
        or o.company <> n.company
        or o.error_code <> n.error_code
        or o.error_msg <> n.error_msg
        or o.event_type <> n.event_type
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.tran_status <> n.tran_status
        or o.tran_timestamp <> n.tran_timestamp
        or o.loan_no <> n.loan_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_plan_run_info_cl(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,event_type -- 事件类型
            ,plan_no -- 执行计划编号
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,tran_status -- 冲补抹标志
            ,deal_date -- 处理日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_plan_run_info_op(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,error_code -- 错误码
            ,error_msg -- 错误代码
            ,event_type -- 事件类型
            ,plan_no -- 执行计划编号
            ,reserve1 -- 预留字段1
            ,reserve2 -- 预留字段2
            ,tran_status -- 冲补抹标志
            ,deal_date -- 处理日期
            ,tran_timestamp -- 交易时间戳
            ,loan_no -- 贷款号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amount -- 金额
    ,o.amt_type -- 金额类型
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.company -- 法人
    ,o.error_code -- 错误码
    ,o.error_msg -- 错误代码
    ,o.event_type -- 事件类型
    ,o.plan_no -- 执行计划编号
    ,o.reserve1 -- 预留字段1
    ,o.reserve2 -- 预留字段2
    ,o.tran_status -- 冲补抹标志
    ,o.deal_date -- 处理日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.loan_no -- 贷款号
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
from ${iol_schema}.ncbs_cl_plan_run_info_bk o
    left join ${iol_schema}.ncbs_cl_plan_run_info_op n
        on
            o.plan_no = n.plan_no
            and o.deal_date = n.deal_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_plan_run_info_cl d
        on
            o.plan_no = d.plan_no
            and o.deal_date = d.deal_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_plan_run_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_plan_run_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_plan_run_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_plan_run_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_plan_run_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_plan_run_info_cl;
alter table ${iol_schema}.ncbs_cl_plan_run_info exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_plan_run_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_plan_run_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_plan_run_info_op purge;
drop table ${iol_schema}.ncbs_cl_plan_run_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_plan_run_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_plan_run_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
