/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct_attach
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
create table ${iol_schema}.ncbs_cl_acct_attach_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_acct_attach
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_attach_op purge;
drop table ${iol_schema}.ncbs_cl_acct_attach_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_attach_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_attach where 0=1;

create table ${iol_schema}.ncbs_cl_acct_attach_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct_attach where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_attach_cl(
            internal_key -- 账户内部键值
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,pri_due_days -- 本金逾期天数（考虑宽限期）
            ,int_due_days -- 利息逾期天数（考虑宽限期）
            ,pri_first_date -- 本金最早逾期日期
            ,int_first_date -- 利息最早逾期日期
            ,last_change_date -- 最后修改日期
            ,due_days -- 
            ,act_tran_amt -- 
            ,reference -- 
            ,remark -- 
            ,loan_type -- 
            ,hide_sched_flag -- 
            ,is_counter_fyj_flag -- 
            ,old_five_category -- 
            ,fyj_reason -- 
            ,change_reason -- 
            ,past_due_last_stage -- 
            ,past_due_stage_count -- 
            ,first_overdue_date -- 
            ,comp_flag -- 
            ,receipt_type -- 
            ,rec_amt_ctrl -- 
            ,inp_eod_flag -- 
            ,comp_rule -- 
            ,comp_highest -- 
            ,comp_effect_flag -- 
            ,open_tran_timestamp -- 开户时间戳
            ,close_tran_timestamp -- 销户时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_attach_op(
            internal_key -- 账户内部键值
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,pri_due_days -- 本金逾期天数（考虑宽限期）
            ,int_due_days -- 利息逾期天数（考虑宽限期）
            ,pri_first_date -- 本金最早逾期日期
            ,int_first_date -- 利息最早逾期日期
            ,last_change_date -- 最后修改日期
            ,due_days -- 
            ,act_tran_amt -- 
            ,reference -- 
            ,remark -- 
            ,loan_type -- 
            ,hide_sched_flag -- 
            ,is_counter_fyj_flag -- 
            ,old_five_category -- 
            ,fyj_reason -- 
            ,change_reason -- 
            ,past_due_last_stage -- 
            ,past_due_stage_count -- 
            ,first_overdue_date -- 
            ,comp_flag -- 
            ,receipt_type -- 
            ,rec_amt_ctrl -- 
            ,inp_eod_flag -- 
            ,comp_rule -- 
            ,comp_highest -- 
            ,comp_effect_flag -- 
            ,open_tran_timestamp -- 开户时间戳
            ,close_tran_timestamp -- 销户时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.pri_due_days, o.pri_due_days) as pri_due_days -- 本金逾期天数（考虑宽限期）
    ,nvl(n.int_due_days, o.int_due_days) as int_due_days -- 利息逾期天数（考虑宽限期）
    ,nvl(n.pri_first_date, o.pri_first_date) as pri_first_date -- 本金最早逾期日期
    ,nvl(n.int_first_date, o.int_first_date) as int_first_date -- 利息最早逾期日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.due_days, o.due_days) as due_days -- 
    ,nvl(n.act_tran_amt, o.act_tran_amt) as act_tran_amt -- 
    ,nvl(n.reference, o.reference) as reference -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.loan_type, o.loan_type) as loan_type -- 
    ,nvl(n.hide_sched_flag, o.hide_sched_flag) as hide_sched_flag -- 
    ,nvl(n.is_counter_fyj_flag, o.is_counter_fyj_flag) as is_counter_fyj_flag -- 
    ,nvl(n.old_five_category, o.old_five_category) as old_five_category -- 
    ,nvl(n.fyj_reason, o.fyj_reason) as fyj_reason -- 
    ,nvl(n.change_reason, o.change_reason) as change_reason -- 
    ,nvl(n.past_due_last_stage, o.past_due_last_stage) as past_due_last_stage -- 
    ,nvl(n.past_due_stage_count, o.past_due_stage_count) as past_due_stage_count -- 
    ,nvl(n.first_overdue_date, o.first_overdue_date) as first_overdue_date -- 
    ,nvl(n.comp_flag, o.comp_flag) as comp_flag -- 
    ,nvl(n.receipt_type, o.receipt_type) as receipt_type -- 
    ,nvl(n.rec_amt_ctrl, o.rec_amt_ctrl) as rec_amt_ctrl -- 
    ,nvl(n.inp_eod_flag, o.inp_eod_flag) as inp_eod_flag -- 
    ,nvl(n.comp_rule, o.comp_rule) as comp_rule -- 
    ,nvl(n.comp_highest, o.comp_highest) as comp_highest -- 
    ,nvl(n.comp_effect_flag, o.comp_effect_flag) as comp_effect_flag -- 
    ,nvl(n.open_tran_timestamp, o.open_tran_timestamp) as open_tran_timestamp -- 开户时间戳
    ,nvl(n.close_tran_timestamp, o.close_tran_timestamp) as close_tran_timestamp -- 销户时间戳
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_acct_attach_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_acct_attach where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.client_no <> n.client_no
        or o.tran_timestamp <> n.tran_timestamp
        or o.pri_due_days <> n.pri_due_days
        or o.int_due_days <> n.int_due_days
        or o.pri_first_date <> n.pri_first_date
        or o.int_first_date <> n.int_first_date
        or o.last_change_date <> n.last_change_date
        or o.due_days <> n.due_days
        or o.act_tran_amt <> n.act_tran_amt
        or o.reference <> n.reference
        or o.remark <> n.remark
        or o.loan_type <> n.loan_type
        or o.hide_sched_flag <> n.hide_sched_flag
        or o.is_counter_fyj_flag <> n.is_counter_fyj_flag
        or o.old_five_category <> n.old_five_category
        or o.fyj_reason <> n.fyj_reason
        or o.change_reason <> n.change_reason
        or o.past_due_last_stage <> n.past_due_last_stage
        or o.past_due_stage_count <> n.past_due_stage_count
        or o.first_overdue_date <> n.first_overdue_date
        or o.comp_flag <> n.comp_flag
        or o.receipt_type <> n.receipt_type
        or o.rec_amt_ctrl <> n.rec_amt_ctrl
        or o.inp_eod_flag <> n.inp_eod_flag
        or o.comp_rule <> n.comp_rule
        or o.comp_highest <> n.comp_highest
        or o.comp_effect_flag <> n.comp_effect_flag
        or o.open_tran_timestamp <> n.open_tran_timestamp
        or o.close_tran_timestamp <> n.close_tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_attach_cl(
            internal_key -- 账户内部键值
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,pri_due_days -- 本金逾期天数（考虑宽限期）
            ,int_due_days -- 利息逾期天数（考虑宽限期）
            ,pri_first_date -- 本金最早逾期日期
            ,int_first_date -- 利息最早逾期日期
            ,last_change_date -- 最后修改日期
            ,due_days -- 
            ,act_tran_amt -- 
            ,reference -- 
            ,remark -- 
            ,loan_type -- 
            ,hide_sched_flag -- 
            ,is_counter_fyj_flag -- 
            ,old_five_category -- 
            ,fyj_reason -- 
            ,change_reason -- 
            ,past_due_last_stage -- 
            ,past_due_stage_count -- 
            ,first_overdue_date -- 
            ,comp_flag -- 
            ,receipt_type -- 
            ,rec_amt_ctrl -- 
            ,inp_eod_flag -- 
            ,comp_rule -- 
            ,comp_highest -- 
            ,comp_effect_flag -- 
            ,open_tran_timestamp -- 开户时间戳
            ,close_tran_timestamp -- 销户时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_attach_op(
            internal_key -- 账户内部键值
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,pri_due_days -- 本金逾期天数（考虑宽限期）
            ,int_due_days -- 利息逾期天数（考虑宽限期）
            ,pri_first_date -- 本金最早逾期日期
            ,int_first_date -- 利息最早逾期日期
            ,last_change_date -- 最后修改日期
            ,due_days -- 
            ,act_tran_amt -- 
            ,reference -- 
            ,remark -- 
            ,loan_type -- 
            ,hide_sched_flag -- 
            ,is_counter_fyj_flag -- 
            ,old_five_category -- 
            ,fyj_reason -- 
            ,change_reason -- 
            ,past_due_last_stage -- 
            ,past_due_stage_count -- 
            ,first_overdue_date -- 
            ,comp_flag -- 
            ,receipt_type -- 
            ,rec_amt_ctrl -- 
            ,inp_eod_flag -- 
            ,comp_rule -- 
            ,comp_highest -- 
            ,comp_effect_flag -- 
            ,open_tran_timestamp -- 开户时间戳
            ,close_tran_timestamp -- 销户时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.internal_key -- 账户内部键值
    ,o.client_no -- 客户编号
    ,o.tran_timestamp -- 交易时间戳
    ,o.pri_due_days -- 本金逾期天数（考虑宽限期）
    ,o.int_due_days -- 利息逾期天数（考虑宽限期）
    ,o.pri_first_date -- 本金最早逾期日期
    ,o.int_first_date -- 利息最早逾期日期
    ,o.last_change_date -- 最后修改日期
    ,o.due_days -- 
    ,o.act_tran_amt -- 
    ,o.reference -- 
    ,o.remark -- 
    ,o.loan_type -- 
    ,o.hide_sched_flag -- 
    ,o.is_counter_fyj_flag -- 
    ,o.old_five_category -- 
    ,o.fyj_reason -- 
    ,o.change_reason -- 
    ,o.past_due_last_stage -- 
    ,o.past_due_stage_count -- 
    ,o.first_overdue_date -- 
    ,o.comp_flag -- 
    ,o.receipt_type -- 
    ,o.rec_amt_ctrl -- 
    ,o.inp_eod_flag -- 
    ,o.comp_rule -- 
    ,o.comp_highest -- 
    ,o.comp_effect_flag -- 
    ,o.open_tran_timestamp -- 开户时间戳
    ,o.close_tran_timestamp -- 销户时间戳
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
from ${iol_schema}.ncbs_cl_acct_attach_bk o
    left join ${iol_schema}.ncbs_cl_acct_attach_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_acct_attach_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_acct_attach;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_acct_attach') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_acct_attach drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_acct_attach add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_acct_attach exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_acct_attach_cl;
alter table ${iol_schema}.ncbs_cl_acct_attach exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_acct_attach_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_acct_attach to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_attach_op purge;
drop table ${iol_schema}.ncbs_cl_acct_attach_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_acct_attach_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_acct_attach',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
