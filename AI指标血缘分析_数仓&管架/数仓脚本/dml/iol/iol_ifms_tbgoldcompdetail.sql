/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbgoldcompdetail
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
create table ${iol_schema}.ifms_tbgoldcompdetail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbgoldcompdetail;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbgoldcompdetail_op purge;
drop table ${iol_schema}.ifms_tbgoldcompdetail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbgoldcompdetail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbgoldcompdetail where 0=1;

create table ${iol_schema}.ifms_tbgoldcompdetail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbgoldcompdetail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbgoldcompdetail_cl(
            serial_no -- 
            ,bank_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,gold_amt -- 
            ,amt -- 
            ,gold_bank_acc -- 
            ,bank_acc -- 
            ,gold_client_no -- 
            ,b_gold_client_no -- 
            ,gold_transfer_type -- 
            ,transfer_type -- 
            ,gold_curr_type -- 
            ,curr_type -- 
            ,status -- 
            ,unequa_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbgoldcompdetail_op(
            serial_no -- 
            ,bank_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,gold_amt -- 
            ,amt -- 
            ,gold_bank_acc -- 
            ,bank_acc -- 
            ,gold_client_no -- 
            ,b_gold_client_no -- 
            ,gold_transfer_type -- 
            ,transfer_type -- 
            ,gold_curr_type -- 
            ,curr_type -- 
            ,status -- 
            ,unequa_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serial_no, o.serial_no) as serial_no -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 
    ,nvl(n.gold_amt, o.gold_amt) as gold_amt -- 
    ,nvl(n.amt, o.amt) as amt -- 
    ,nvl(n.gold_bank_acc, o.gold_bank_acc) as gold_bank_acc -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.gold_client_no, o.gold_client_no) as gold_client_no -- 
    ,nvl(n.b_gold_client_no, o.b_gold_client_no) as b_gold_client_no -- 
    ,nvl(n.gold_transfer_type, o.gold_transfer_type) as gold_transfer_type -- 
    ,nvl(n.transfer_type, o.transfer_type) as transfer_type -- 
    ,nvl(n.gold_curr_type, o.gold_curr_type) as gold_curr_type -- 
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.unequa_flag, o.unequa_flag) as unequa_flag -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
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
from (select * from ${iol_schema}.ifms_tbgoldcompdetail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbgoldcompdetail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serial_no = n.serial_no
where (
        o.serial_no is null
    )
    or (
        n.serial_no is null
    )
    or (
        o.bank_no <> n.bank_no
        or o.trans_date <> n.trans_date
        or o.trans_time <> n.trans_time
        or o.gold_amt <> n.gold_amt
        or o.amt <> n.amt
        or o.gold_bank_acc <> n.gold_bank_acc
        or o.bank_acc <> n.bank_acc
        or o.gold_client_no <> n.gold_client_no
        or o.b_gold_client_no <> n.b_gold_client_no
        or o.gold_transfer_type <> n.gold_transfer_type
        or o.transfer_type <> n.transfer_type
        or o.gold_curr_type <> n.gold_curr_type
        or o.curr_type <> n.curr_type
        or o.status <> n.status
        or o.unequa_flag <> n.unequa_flag
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbgoldcompdetail_cl(
            serial_no -- 
            ,bank_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,gold_amt -- 
            ,amt -- 
            ,gold_bank_acc -- 
            ,bank_acc -- 
            ,gold_client_no -- 
            ,b_gold_client_no -- 
            ,gold_transfer_type -- 
            ,transfer_type -- 
            ,gold_curr_type -- 
            ,curr_type -- 
            ,status -- 
            ,unequa_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbgoldcompdetail_op(
            serial_no -- 
            ,bank_no -- 
            ,trans_date -- 
            ,trans_time -- 
            ,gold_amt -- 
            ,amt -- 
            ,gold_bank_acc -- 
            ,bank_acc -- 
            ,gold_client_no -- 
            ,b_gold_client_no -- 
            ,gold_transfer_type -- 
            ,transfer_type -- 
            ,gold_curr_type -- 
            ,curr_type -- 
            ,status -- 
            ,unequa_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serial_no -- 
    ,o.bank_no -- 
    ,o.trans_date -- 
    ,o.trans_time -- 
    ,o.gold_amt -- 
    ,o.amt -- 
    ,o.gold_bank_acc -- 
    ,o.bank_acc -- 
    ,o.gold_client_no -- 
    ,o.b_gold_client_no -- 
    ,o.gold_transfer_type -- 
    ,o.transfer_type -- 
    ,o.gold_curr_type -- 
    ,o.curr_type -- 
    ,o.status -- 
    ,o.unequa_flag -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbgoldcompdetail_bk o
    left join ${iol_schema}.ifms_tbgoldcompdetail_op n
        on
            o.serial_no = n.serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbgoldcompdetail_cl d
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
-- truncate table ${iol_schema}.ifms_tbgoldcompdetail;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbgoldcompdetail exchange partition p_19000101 with table ${iol_schema}.ifms_tbgoldcompdetail_cl;
alter table ${iol_schema}.ifms_tbgoldcompdetail exchange partition p_20991231 with table ${iol_schema}.ifms_tbgoldcompdetail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbgoldcompdetail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbgoldcompdetail_op purge;
drop table ${iol_schema}.ifms_tbgoldcompdetail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbgoldcompdetail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbgoldcompdetail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
