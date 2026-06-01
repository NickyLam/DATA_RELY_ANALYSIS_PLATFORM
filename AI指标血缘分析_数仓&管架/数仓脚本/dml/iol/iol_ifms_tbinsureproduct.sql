/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbinsureproduct
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
create table ${iol_schema}.ifms_tbinsureproduct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbinsureproduct;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsureproduct_op purge;
drop table ${iol_schema}.ifms_tbinsureproduct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbinsureproduct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsureproduct where 0=1;

create table ${iol_schema}.ifms_tbinsureproduct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbinsureproduct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsureproduct_cl(
            prd_code -- 
            ,ta_code -- 
            ,prd_name -- 
            ,prd_name2 -- 
            ,prd_type -- 
            ,prd_sub_type -- 
            ,prd_busin_flag -- 
            ,prd_limit_flag -- 
            ,curr_type -- 
            ,online_flag -- 
            ,begin_date -- 
            ,end_date -- 
            ,prd_add_flag -- 
            ,targ_prd_code -- 
            ,waver_days -- 
            ,master_agiorate -- 
            ,check_type -- 
            ,control_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,pmin_amt -- 
            ,omin_amt -- 
            ,pmax_amt -- 
            ,omax_amt -- 
            ,punit_amt -- 
            ,ounit_amt -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsureproduct_op(
            prd_code -- 
            ,ta_code -- 
            ,prd_name -- 
            ,prd_name2 -- 
            ,prd_type -- 
            ,prd_sub_type -- 
            ,prd_busin_flag -- 
            ,prd_limit_flag -- 
            ,curr_type -- 
            ,online_flag -- 
            ,begin_date -- 
            ,end_date -- 
            ,prd_add_flag -- 
            ,targ_prd_code -- 
            ,waver_days -- 
            ,master_agiorate -- 
            ,check_type -- 
            ,control_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,pmin_amt -- 
            ,omin_amt -- 
            ,pmax_amt -- 
            ,omax_amt -- 
            ,punit_amt -- 
            ,ounit_amt -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 
    ,nvl(n.prd_name2, o.prd_name2) as prd_name2 -- 
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 
    ,nvl(n.prd_sub_type, o.prd_sub_type) as prd_sub_type -- 
    ,nvl(n.prd_busin_flag, o.prd_busin_flag) as prd_busin_flag -- 
    ,nvl(n.prd_limit_flag, o.prd_limit_flag) as prd_limit_flag -- 
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 
    ,nvl(n.online_flag, o.online_flag) as online_flag -- 
    ,nvl(n.begin_date, o.begin_date) as begin_date -- 
    ,nvl(n.end_date, o.end_date) as end_date -- 
    ,nvl(n.prd_add_flag, o.prd_add_flag) as prd_add_flag -- 
    ,nvl(n.targ_prd_code, o.targ_prd_code) as targ_prd_code -- 
    ,nvl(n.waver_days, o.waver_days) as waver_days -- 
    ,nvl(n.master_agiorate, o.master_agiorate) as master_agiorate -- 
    ,nvl(n.check_type, o.check_type) as check_type -- 
    ,nvl(n.control_flag, o.control_flag) as control_flag -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,nvl(n.pmin_amt, o.pmin_amt) as pmin_amt -- 
    ,nvl(n.omin_amt, o.omin_amt) as omin_amt -- 
    ,nvl(n.pmax_amt, o.pmax_amt) as pmax_amt -- 
    ,nvl(n.omax_amt, o.omax_amt) as omax_amt -- 
    ,nvl(n.punit_amt, o.punit_amt) as punit_amt -- 
    ,nvl(n.ounit_amt, o.ounit_amt) as ounit_amt -- 
    ,nvl(n.amt1, o.amt1) as amt1 -- 
    ,nvl(n.amt2, o.amt2) as amt2 -- 
    ,nvl(n.amt3, o.amt3) as amt3 -- 
    ,case when
            n.prd_code is null
            and n.ta_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
            and n.ta_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
            and n.ta_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbinsureproduct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbinsureproduct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
            and o.ta_code = n.ta_code
where (
        o.prd_code is null
        and o.ta_code is null
    )
    or (
        n.prd_code is null
        and n.ta_code is null
    )
    or (
        o.prd_name <> n.prd_name
        or o.prd_name2 <> n.prd_name2
        or o.prd_type <> n.prd_type
        or o.prd_sub_type <> n.prd_sub_type
        or o.prd_busin_flag <> n.prd_busin_flag
        or o.prd_limit_flag <> n.prd_limit_flag
        or o.curr_type <> n.curr_type
        or o.online_flag <> n.online_flag
        or o.begin_date <> n.begin_date
        or o.end_date <> n.end_date
        or o.prd_add_flag <> n.prd_add_flag
        or o.targ_prd_code <> n.targ_prd_code
        or o.waver_days <> n.waver_days
        or o.master_agiorate <> n.master_agiorate
        or o.check_type <> n.check_type
        or o.control_flag <> n.control_flag
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.pmin_amt <> n.pmin_amt
        or o.omin_amt <> n.omin_amt
        or o.pmax_amt <> n.pmax_amt
        or o.omax_amt <> n.omax_amt
        or o.punit_amt <> n.punit_amt
        or o.ounit_amt <> n.ounit_amt
        or o.amt1 <> n.amt1
        or o.amt2 <> n.amt2
        or o.amt3 <> n.amt3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbinsureproduct_cl(
            prd_code -- 
            ,ta_code -- 
            ,prd_name -- 
            ,prd_name2 -- 
            ,prd_type -- 
            ,prd_sub_type -- 
            ,prd_busin_flag -- 
            ,prd_limit_flag -- 
            ,curr_type -- 
            ,online_flag -- 
            ,begin_date -- 
            ,end_date -- 
            ,prd_add_flag -- 
            ,targ_prd_code -- 
            ,waver_days -- 
            ,master_agiorate -- 
            ,check_type -- 
            ,control_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,pmin_amt -- 
            ,omin_amt -- 
            ,pmax_amt -- 
            ,omax_amt -- 
            ,punit_amt -- 
            ,ounit_amt -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbinsureproduct_op(
            prd_code -- 
            ,ta_code -- 
            ,prd_name -- 
            ,prd_name2 -- 
            ,prd_type -- 
            ,prd_sub_type -- 
            ,prd_busin_flag -- 
            ,prd_limit_flag -- 
            ,curr_type -- 
            ,online_flag -- 
            ,begin_date -- 
            ,end_date -- 
            ,prd_add_flag -- 
            ,targ_prd_code -- 
            ,waver_days -- 
            ,master_agiorate -- 
            ,check_type -- 
            ,control_flag -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,pmin_amt -- 
            ,omin_amt -- 
            ,pmax_amt -- 
            ,omax_amt -- 
            ,punit_amt -- 
            ,ounit_amt -- 
            ,amt1 -- 
            ,amt2 -- 
            ,amt3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_code -- 
    ,o.ta_code -- 
    ,o.prd_name -- 
    ,o.prd_name2 -- 
    ,o.prd_type -- 
    ,o.prd_sub_type -- 
    ,o.prd_busin_flag -- 
    ,o.prd_limit_flag -- 
    ,o.curr_type -- 
    ,o.online_flag -- 
    ,o.begin_date -- 
    ,o.end_date -- 
    ,o.prd_add_flag -- 
    ,o.targ_prd_code -- 
    ,o.waver_days -- 
    ,o.master_agiorate -- 
    ,o.check_type -- 
    ,o.control_flag -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.reserve4 -- 
    ,o.pmin_amt -- 
    ,o.omin_amt -- 
    ,o.pmax_amt -- 
    ,o.omax_amt -- 
    ,o.punit_amt -- 
    ,o.ounit_amt -- 
    ,o.amt1 -- 
    ,o.amt2 -- 
    ,o.amt3 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbinsureproduct_bk o
    left join ${iol_schema}.ifms_tbinsureproduct_op n
        on
            o.prd_code = n.prd_code
            and o.ta_code = n.ta_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbinsureproduct_cl d
        on
            o.prd_code = d.prd_code
            and o.ta_code = d.ta_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbinsureproduct;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbinsureproduct exchange partition p_19000101 with table ${iol_schema}.ifms_tbinsureproduct_cl;
alter table ${iol_schema}.ifms_tbinsureproduct exchange partition p_20991231 with table ${iol_schema}.ifms_tbinsureproduct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbinsureproduct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbinsureproduct_op purge;
drop table ${iol_schema}.ifms_tbinsureproduct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbinsureproduct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbinsureproduct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
