/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbautoinvest
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
create table ${iol_schema}.ifms_tbautoinvest_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbautoinvest;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbautoinvest_op purge;
drop table ${iol_schema}.ifms_tbautoinvest_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbautoinvest_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbautoinvest where 0=1;

create table ${iol_schema}.ifms_tbautoinvest_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbautoinvest where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbautoinvest_cl(
            serial_no -- 
            ,busin_flag -- 
            ,trans_date -- 
            ,in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,cash_flag -- 
            ,client_group -- 
            ,channel -- 
            ,branch_no -- 
            ,prd_code -- 
            ,asso_code -- 
            ,ta_code -- 
            ,amt -- 
            ,vol -- 
            ,larg_red_flag -- 
            ,min_amt -- 
            ,max_amt -- 
            ,hold_amt -- 
            ,agio -- 
            ,over_flag -- 
            ,invest_day -- 
            ,invest_times -- 
            ,remain_times -- 
            ,tot_times -- 
            ,fail_times -- 
            ,end_date -- 
            ,period -- 
            ,span -- 
            ,next_invest_date -- 
            ,last_invest_date -- 
            ,last_deal_date -- 
            ,last_msg -- 
            ,finish_flag -- 
            ,start_invest_date -- 
            ,client_manager -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbautoinvest_op(
            serial_no -- 
            ,busin_flag -- 
            ,trans_date -- 
            ,in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,cash_flag -- 
            ,client_group -- 
            ,channel -- 
            ,branch_no -- 
            ,prd_code -- 
            ,asso_code -- 
            ,ta_code -- 
            ,amt -- 
            ,vol -- 
            ,larg_red_flag -- 
            ,min_amt -- 
            ,max_amt -- 
            ,hold_amt -- 
            ,agio -- 
            ,over_flag -- 
            ,invest_day -- 
            ,invest_times -- 
            ,remain_times -- 
            ,tot_times -- 
            ,fail_times -- 
            ,end_date -- 
            ,period -- 
            ,span -- 
            ,next_invest_date -- 
            ,last_invest_date -- 
            ,last_deal_date -- 
            ,last_msg -- 
            ,finish_flag -- 
            ,start_invest_date -- 
            ,client_manager -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.busin_flag, o.busin_flag) as busin_flag -- 
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.cash_flag, o.cash_flag) as cash_flag -- 
    ,nvl(n.client_group, o.client_group) as client_group -- 
    ,nvl(n.channel, o.channel) as channel -- 
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.asso_code, o.asso_code) as asso_code -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.amt, o.amt) as amt -- 
    ,nvl(n.vol, o.vol) as vol -- 
    ,nvl(n.larg_red_flag, o.larg_red_flag) as larg_red_flag -- 
    ,nvl(n.min_amt, o.min_amt) as min_amt -- 
    ,nvl(n.max_amt, o.max_amt) as max_amt -- 
    ,nvl(n.hold_amt, o.hold_amt) as hold_amt -- 
    ,nvl(n.agio, o.agio) as agio -- 
    ,nvl(n.over_flag, o.over_flag) as over_flag -- 
    ,nvl(n.invest_day, o.invest_day) as invest_day -- 
    ,nvl(n.invest_times, o.invest_times) as invest_times -- 
    ,nvl(n.remain_times, o.remain_times) as remain_times -- 
    ,nvl(n.tot_times, o.tot_times) as tot_times -- 
    ,nvl(n.fail_times, o.fail_times) as fail_times -- 
    ,nvl(n.end_date, o.end_date) as end_date -- 
    ,nvl(n.period, o.period) as period -- 
    ,nvl(n.span, o.span) as span -- 
    ,nvl(n.next_invest_date, o.next_invest_date) as next_invest_date -- 
    ,nvl(n.last_invest_date, o.last_invest_date) as last_invest_date -- 
    ,nvl(n.last_deal_date, o.last_deal_date) as last_deal_date -- 
    ,nvl(n.last_msg, o.last_msg) as last_msg -- 
    ,nvl(n.finish_flag, o.finish_flag) as finish_flag -- 
    ,nvl(n.start_invest_date, o.start_invest_date) as start_invest_date -- 
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,case when
            n.serial_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serial_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serial_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbautoinvest_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbautoinvest where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serial_no = n.serial_no
where (
        o.serial_no is null
    )
    or (
        n.serial_no is null
    )
    or (
        o.busin_flag <> n.busin_flag
        or o.trans_date <> n.trans_date
        or o.in_client_no <> n.in_client_no
        or o.bank_no <> n.bank_no
        or o.client_no <> n.client_no
        or o.bank_acc <> n.bank_acc
        or o.cash_flag <> n.cash_flag
        or o.client_group <> n.client_group
        or o.channel <> n.channel
        or o.branch_no <> n.branch_no
        or o.prd_code <> n.prd_code
        or o.asso_code <> n.asso_code
        or o.ta_code <> n.ta_code
        or o.amt <> n.amt
        or o.vol <> n.vol
        or o.larg_red_flag <> n.larg_red_flag
        or o.min_amt <> n.min_amt
        or o.max_amt <> n.max_amt
        or o.hold_amt <> n.hold_amt
        or o.agio <> n.agio
        or o.over_flag <> n.over_flag
        or o.invest_day <> n.invest_day
        or o.invest_times <> n.invest_times
        or o.remain_times <> n.remain_times
        or o.tot_times <> n.tot_times
        or o.fail_times <> n.fail_times
        or o.end_date <> n.end_date
        or o.period <> n.period
        or o.span <> n.span
        or o.next_invest_date <> n.next_invest_date
        or o.last_invest_date <> n.last_invest_date
        or o.last_deal_date <> n.last_deal_date
        or o.last_msg <> n.last_msg
        or o.finish_flag <> n.finish_flag
        or o.start_invest_date <> n.start_invest_date
        or o.client_manager <> n.client_manager
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbautoinvest_cl(
            serial_no -- 
            ,busin_flag -- 
            ,trans_date -- 
            ,in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,cash_flag -- 
            ,client_group -- 
            ,channel -- 
            ,branch_no -- 
            ,prd_code -- 
            ,asso_code -- 
            ,ta_code -- 
            ,amt -- 
            ,vol -- 
            ,larg_red_flag -- 
            ,min_amt -- 
            ,max_amt -- 
            ,hold_amt -- 
            ,agio -- 
            ,over_flag -- 
            ,invest_day -- 
            ,invest_times -- 
            ,remain_times -- 
            ,tot_times -- 
            ,fail_times -- 
            ,end_date -- 
            ,period -- 
            ,span -- 
            ,next_invest_date -- 
            ,last_invest_date -- 
            ,last_deal_date -- 
            ,last_msg -- 
            ,finish_flag -- 
            ,start_invest_date -- 
            ,client_manager -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbautoinvest_op(
            serial_no -- 
            ,busin_flag -- 
            ,trans_date -- 
            ,in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,bank_acc -- 
            ,cash_flag -- 
            ,client_group -- 
            ,channel -- 
            ,branch_no -- 
            ,prd_code -- 
            ,asso_code -- 
            ,ta_code -- 
            ,amt -- 
            ,vol -- 
            ,larg_red_flag -- 
            ,min_amt -- 
            ,max_amt -- 
            ,hold_amt -- 
            ,agio -- 
            ,over_flag -- 
            ,invest_day -- 
            ,invest_times -- 
            ,remain_times -- 
            ,tot_times -- 
            ,fail_times -- 
            ,end_date -- 
            ,period -- 
            ,span -- 
            ,next_invest_date -- 
            ,last_invest_date -- 
            ,last_deal_date -- 
            ,last_msg -- 
            ,finish_flag -- 
            ,start_invest_date -- 
            ,client_manager -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serial_no -- 
    ,o.busin_flag -- 
    ,o.trans_date -- 
    ,o.in_client_no -- 
    ,o.bank_no -- 
    ,o.client_no -- 
    ,o.bank_acc -- 
    ,o.cash_flag -- 
    ,o.client_group -- 
    ,o.channel -- 
    ,o.branch_no -- 
    ,o.prd_code -- 
    ,o.asso_code -- 
    ,o.ta_code -- 
    ,o.amt -- 
    ,o.vol -- 
    ,o.larg_red_flag -- 
    ,o.min_amt -- 
    ,o.max_amt -- 
    ,o.hold_amt -- 
    ,o.agio -- 
    ,o.over_flag -- 
    ,o.invest_day -- 
    ,o.invest_times -- 
    ,o.remain_times -- 
    ,o.tot_times -- 
    ,o.fail_times -- 
    ,o.end_date -- 
    ,o.period -- 
    ,o.span -- 
    ,o.next_invest_date -- 
    ,o.last_invest_date -- 
    ,o.last_deal_date -- 
    ,o.last_msg -- 
    ,o.finish_flag -- 
    ,o.start_invest_date -- 
    ,o.client_manager -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbautoinvest_bk o
    left join ${iol_schema}.ifms_tbautoinvest_op n
        on
            o.serial_no = n.serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbautoinvest_cl d
        on
            o.serial_no = d.serial_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbautoinvest;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbautoinvest exchange partition p_19000101 with table ${iol_schema}.ifms_tbautoinvest_cl;
alter table ${iol_schema}.ifms_tbautoinvest exchange partition p_20991231 with table ${iol_schema}.ifms_tbautoinvest_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbautoinvest to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbautoinvest_op purge;
drop table ${iol_schema}.ifms_tbautoinvest_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbautoinvest_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbautoinvest',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
