/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_schedule
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
create table ${iol_schema}.ncbs_rb_acct_schedule_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_acct_schedule
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_schedule_op purge;
drop table ${iol_schema}.ncbs_rb_acct_schedule_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_schedule_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_schedule where 0=1;

create table ${iol_schema}.ncbs_rb_acct_schedule_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_acct_schedule where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_schedule_cl(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,event_type -- 事件类型
            ,grace_end_month -- 是否宽限到月末
            ,mid_period -- 累进间隔期数
            ,sched_mode -- 还款方式
            ,sched_no -- 计划编号
            ,schedule_status -- 计划执行状态
            ,total_times -- 扣划总次数
            ,end_date -- 结束日期
            ,grace_date -- 宽限日
            ,last_deal_date -- 上一处理日
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,cur_basic_day -- 当前回收日
            ,deal_day -- 处理日
            ,fir_period -- 首段期数
            ,formula_amt -- 每期计划还款额
            ,grace_period -- 宽限期的天数
            ,second_rec_day -- 第二回收日
            ,total_amt -- 总金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_schedule_op(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,event_type -- 事件类型
            ,grace_end_month -- 是否宽限到月末
            ,mid_period -- 累进间隔期数
            ,sched_mode -- 还款方式
            ,sched_no -- 计划编号
            ,schedule_status -- 计划执行状态
            ,total_times -- 扣划总次数
            ,end_date -- 结束日期
            ,grace_date -- 宽限日
            ,last_deal_date -- 上一处理日
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,cur_basic_day -- 当前回收日
            ,deal_day -- 处理日
            ,fir_period -- 首段期数
            ,formula_amt -- 每期计划还款额
            ,grace_period -- 宽限期的天数
            ,second_rec_day -- 第二回收日
            ,total_amt -- 总金额
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
    ,nvl(n.period_freq, o.period_freq) as period_freq -- 频率id
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.dac_value, o.dac_value) as dac_value -- dac值防篡改加密
    ,nvl(n.event_type, o.event_type) as event_type -- 事件类型
    ,nvl(n.grace_end_month, o.grace_end_month) as grace_end_month -- 是否宽限到月末
    ,nvl(n.mid_period, o.mid_period) as mid_period -- 累进间隔期数
    ,nvl(n.sched_mode, o.sched_mode) as sched_mode -- 还款方式
    ,nvl(n.sched_no, o.sched_no) as sched_no -- 计划编号
    ,nvl(n.schedule_status, o.schedule_status) as schedule_status -- 计划执行状态
    ,nvl(n.total_times, o.total_times) as total_times -- 扣划总次数
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.grace_date, o.grace_date) as grace_date -- 宽限日
    ,nvl(n.last_deal_date, o.last_deal_date) as last_deal_date -- 上一处理日
    ,nvl(n.next_deal_date, o.next_deal_date) as next_deal_date -- 下一处理日
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.cur_basic_day, o.cur_basic_day) as cur_basic_day -- 当前回收日
    ,nvl(n.deal_day, o.deal_day) as deal_day -- 处理日
    ,nvl(n.fir_period, o.fir_period) as fir_period -- 首段期数
    ,nvl(n.formula_amt, o.formula_amt) as formula_amt -- 每期计划还款额
    ,nvl(n.grace_period, o.grace_period) as grace_period -- 宽限期的天数
    ,nvl(n.second_rec_day, o.second_rec_day) as second_rec_day -- 第二回收日
    ,nvl(n.total_amt, o.total_amt) as total_amt -- 总金额
    ,case when
            n.internal_key is null
            and n.sched_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.sched_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.sched_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_acct_schedule_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_acct_schedule where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.sched_no = n.sched_no
where (
        o.internal_key is null
        and o.sched_no is null
    )
    or (
        n.internal_key is null
        and n.sched_no is null
    )
    or (
        o.amount <> n.amount
        or o.amt_type <> n.amt_type
        or o.client_no <> n.client_no
        or o.period_freq <> n.period_freq
        or o.company <> n.company
        or o.dac_value <> n.dac_value
        or o.event_type <> n.event_type
        or o.grace_end_month <> n.grace_end_month
        or o.mid_period <> n.mid_period
        or o.sched_mode <> n.sched_mode
        or o.schedule_status <> n.schedule_status
        or o.total_times <> n.total_times
        or o.end_date <> n.end_date
        or o.grace_date <> n.grace_date
        or o.last_deal_date <> n.last_deal_date
        or o.next_deal_date <> n.next_deal_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.cur_basic_day <> n.cur_basic_day
        or o.deal_day <> n.deal_day
        or o.fir_period <> n.fir_period
        or o.formula_amt <> n.formula_amt
        or o.grace_period <> n.grace_period
        or o.second_rec_day <> n.second_rec_day
        or o.total_amt <> n.total_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_acct_schedule_cl(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,event_type -- 事件类型
            ,grace_end_month -- 是否宽限到月末
            ,mid_period -- 累进间隔期数
            ,sched_mode -- 还款方式
            ,sched_no -- 计划编号
            ,schedule_status -- 计划执行状态
            ,total_times -- 扣划总次数
            ,end_date -- 结束日期
            ,grace_date -- 宽限日
            ,last_deal_date -- 上一处理日
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,cur_basic_day -- 当前回收日
            ,deal_day -- 处理日
            ,fir_period -- 首段期数
            ,formula_amt -- 每期计划还款额
            ,grace_period -- 宽限期的天数
            ,second_rec_day -- 第二回收日
            ,total_amt -- 总金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_acct_schedule_op(
            amount -- 金额
            ,amt_type -- 金额类型
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,company -- 法人
            ,dac_value -- dac值防篡改加密
            ,event_type -- 事件类型
            ,grace_end_month -- 是否宽限到月末
            ,mid_period -- 累进间隔期数
            ,sched_mode -- 还款方式
            ,sched_no -- 计划编号
            ,schedule_status -- 计划执行状态
            ,total_times -- 扣划总次数
            ,end_date -- 结束日期
            ,grace_date -- 宽限日
            ,last_deal_date -- 上一处理日
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,cur_basic_day -- 当前回收日
            ,deal_day -- 处理日
            ,fir_period -- 首段期数
            ,formula_amt -- 每期计划还款额
            ,grace_period -- 宽限期的天数
            ,second_rec_day -- 第二回收日
            ,total_amt -- 总金额
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
    ,o.period_freq -- 频率id
    ,o.company -- 法人
    ,o.dac_value -- dac值防篡改加密
    ,o.event_type -- 事件类型
    ,o.grace_end_month -- 是否宽限到月末
    ,o.mid_period -- 累进间隔期数
    ,o.sched_mode -- 还款方式
    ,o.sched_no -- 计划编号
    ,o.schedule_status -- 计划执行状态
    ,o.total_times -- 扣划总次数
    ,o.end_date -- 结束日期
    ,o.grace_date -- 宽限日
    ,o.last_deal_date -- 上一处理日
    ,o.next_deal_date -- 下一处理日
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.cur_basic_day -- 当前回收日
    ,o.deal_day -- 处理日
    ,o.fir_period -- 首段期数
    ,o.formula_amt -- 每期计划还款额
    ,o.grace_period -- 宽限期的天数
    ,o.second_rec_day -- 第二回收日
    ,o.total_amt -- 总金额
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
from ${iol_schema}.ncbs_rb_acct_schedule_bk o
    left join ${iol_schema}.ncbs_rb_acct_schedule_op n
        on
            o.internal_key = n.internal_key
            and o.sched_no = n.sched_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_acct_schedule_cl d
        on
            o.internal_key = d.internal_key
            and o.sched_no = d.sched_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_acct_schedule;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_acct_schedule') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_acct_schedule drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_acct_schedule add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_acct_schedule exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_acct_schedule_cl;
alter table ${iol_schema}.ncbs_rb_acct_schedule exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_acct_schedule_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_acct_schedule to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_acct_schedule_op purge;
drop table ${iol_schema}.ncbs_rb_acct_schedule_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_acct_schedule_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_acct_schedule',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
