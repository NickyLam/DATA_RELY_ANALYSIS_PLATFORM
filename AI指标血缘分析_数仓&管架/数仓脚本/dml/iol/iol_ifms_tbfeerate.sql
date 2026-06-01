/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbfeerate
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
create table ${iol_schema}.ifms_tbfeerate_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbfeerate;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbfeerate_op purge;
drop table ${iol_schema}.ifms_tbfeerate_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbfeerate_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbfeerate where 0=1;

create table ${iol_schema}.ifms_tbfeerate_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbfeerate where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbfeerate_cl(
            prd_code -- 
            ,share_class -- 
            ,busin_code -- 
            ,fee_type -- 
            ,client_type -- 
            ,seller_type -- 
            ,sub_mode -- 
            ,min_amt -- 
            ,max_amt -- 
            ,min_predays -- 
            ,max_predays -- 
            ,min_holddays -- 
            ,max_holddays -- 
            ,fee_rate -- 
            ,min_fee -- 
            ,max_fee -- 
            ,calculate_numeric -- 
            ,other_prd_code -- 
            ,targ_share_class -- 
            ,unit -- 
            ,unit_name -- 
            ,back_flag -- 
            ,fee_mode -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbfeerate_op(
            prd_code -- 
            ,share_class -- 
            ,busin_code -- 
            ,fee_type -- 
            ,client_type -- 
            ,seller_type -- 
            ,sub_mode -- 
            ,min_amt -- 
            ,max_amt -- 
            ,min_predays -- 
            ,max_predays -- 
            ,min_holddays -- 
            ,max_holddays -- 
            ,fee_rate -- 
            ,min_fee -- 
            ,max_fee -- 
            ,calculate_numeric -- 
            ,other_prd_code -- 
            ,targ_share_class -- 
            ,unit -- 
            ,unit_name -- 
            ,back_flag -- 
            ,fee_mode -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.share_class, o.share_class) as share_class -- 
    ,nvl(n.busin_code, o.busin_code) as busin_code -- 
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.seller_type, o.seller_type) as seller_type -- 
    ,nvl(n.sub_mode, o.sub_mode) as sub_mode -- 
    ,nvl(n.min_amt, o.min_amt) as min_amt -- 
    ,nvl(n.max_amt, o.max_amt) as max_amt -- 
    ,nvl(n.min_predays, o.min_predays) as min_predays -- 
    ,nvl(n.max_predays, o.max_predays) as max_predays -- 
    ,nvl(n.min_holddays, o.min_holddays) as min_holddays -- 
    ,nvl(n.max_holddays, o.max_holddays) as max_holddays -- 
    ,nvl(n.fee_rate, o.fee_rate) as fee_rate -- 
    ,nvl(n.min_fee, o.min_fee) as min_fee -- 
    ,nvl(n.max_fee, o.max_fee) as max_fee -- 
    ,nvl(n.calculate_numeric, o.calculate_numeric) as calculate_numeric -- 
    ,nvl(n.other_prd_code, o.other_prd_code) as other_prd_code -- 
    ,nvl(n.targ_share_class, o.targ_share_class) as targ_share_class -- 
    ,nvl(n.unit, o.unit) as unit -- 
    ,nvl(n.unit_name, o.unit_name) as unit_name -- 
    ,nvl(n.back_flag, o.back_flag) as back_flag -- 
    ,nvl(n.fee_mode, o.fee_mode) as fee_mode -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,case when
            n.prd_code is null
            and n.busin_code is null
            and n.fee_type is null
            and n.client_type is null
            and n.seller_type is null
            and n.sub_mode is null
            and n.min_amt is null
            and n.min_predays is null
            and n.min_holddays is null
            and n.other_prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
            and n.busin_code is null
            and n.fee_type is null
            and n.client_type is null
            and n.seller_type is null
            and n.sub_mode is null
            and n.min_amt is null
            and n.min_predays is null
            and n.min_holddays is null
            and n.other_prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
            and n.busin_code is null
            and n.fee_type is null
            and n.client_type is null
            and n.seller_type is null
            and n.sub_mode is null
            and n.min_amt is null
            and n.min_predays is null
            and n.min_holddays is null
            and n.other_prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbfeerate_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbfeerate where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
            and o.busin_code = n.busin_code
            and o.fee_type = n.fee_type
            and o.client_type = n.client_type
            and o.seller_type = n.seller_type
            and o.sub_mode = n.sub_mode
            and o.min_amt = n.min_amt
            and o.min_predays = n.min_predays
            and o.min_holddays = n.min_holddays
            and o.other_prd_code = n.other_prd_code
where (
        o.prd_code is null
        and o.busin_code is null
        and o.fee_type is null
        and o.client_type is null
        and o.seller_type is null
        and o.sub_mode is null
        and o.min_amt is null
        and o.min_predays is null
        and o.min_holddays is null
        and o.other_prd_code is null
    )
    or (
        n.prd_code is null
        and n.busin_code is null
        and n.fee_type is null
        and n.client_type is null
        and n.seller_type is null
        and n.sub_mode is null
        and n.min_amt is null
        and n.min_predays is null
        and n.min_holddays is null
        and n.other_prd_code is null
    )
    or (
        o.share_class <> n.share_class
        or o.max_amt <> n.max_amt
        or o.max_predays <> n.max_predays
        or o.max_holddays <> n.max_holddays
        or o.fee_rate <> n.fee_rate
        or o.min_fee <> n.min_fee
        or o.max_fee <> n.max_fee
        or o.calculate_numeric <> n.calculate_numeric
        or o.targ_share_class <> n.targ_share_class
        or o.unit <> n.unit
        or o.unit_name <> n.unit_name
        or o.back_flag <> n.back_flag
        or o.fee_mode <> n.fee_mode
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
        into ${iol_schema}.ifms_tbfeerate_cl(
            prd_code -- 
            ,share_class -- 
            ,busin_code -- 
            ,fee_type -- 
            ,client_type -- 
            ,seller_type -- 
            ,sub_mode -- 
            ,min_amt -- 
            ,max_amt -- 
            ,min_predays -- 
            ,max_predays -- 
            ,min_holddays -- 
            ,max_holddays -- 
            ,fee_rate -- 
            ,min_fee -- 
            ,max_fee -- 
            ,calculate_numeric -- 
            ,other_prd_code -- 
            ,targ_share_class -- 
            ,unit -- 
            ,unit_name -- 
            ,back_flag -- 
            ,fee_mode -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbfeerate_op(
            prd_code -- 
            ,share_class -- 
            ,busin_code -- 
            ,fee_type -- 
            ,client_type -- 
            ,seller_type -- 
            ,sub_mode -- 
            ,min_amt -- 
            ,max_amt -- 
            ,min_predays -- 
            ,max_predays -- 
            ,min_holddays -- 
            ,max_holddays -- 
            ,fee_rate -- 
            ,min_fee -- 
            ,max_fee -- 
            ,calculate_numeric -- 
            ,other_prd_code -- 
            ,targ_share_class -- 
            ,unit -- 
            ,unit_name -- 
            ,back_flag -- 
            ,fee_mode -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_code -- 
    ,o.share_class -- 
    ,o.busin_code -- 
    ,o.fee_type -- 
    ,o.client_type -- 
    ,o.seller_type -- 
    ,o.sub_mode -- 
    ,o.min_amt -- 
    ,o.max_amt -- 
    ,o.min_predays -- 
    ,o.max_predays -- 
    ,o.min_holddays -- 
    ,o.max_holddays -- 
    ,o.fee_rate -- 
    ,o.min_fee -- 
    ,o.max_fee -- 
    ,o.calculate_numeric -- 
    ,o.other_prd_code -- 
    ,o.targ_share_class -- 
    ,o.unit -- 
    ,o.unit_name -- 
    ,o.back_flag -- 
    ,o.fee_mode -- 
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
from ${iol_schema}.ifms_tbfeerate_bk o
    left join ${iol_schema}.ifms_tbfeerate_op n
        on
            o.prd_code = n.prd_code
            and o.busin_code = n.busin_code
            and o.fee_type = n.fee_type
            and o.client_type = n.client_type
            and o.seller_type = n.seller_type
            and o.sub_mode = n.sub_mode
            and o.min_amt = n.min_amt
            and o.min_predays = n.min_predays
            and o.min_holddays = n.min_holddays
            and o.other_prd_code = n.other_prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbfeerate_cl d
        on
            o.prd_code = d.prd_code
            and o.busin_code = d.busin_code
            and o.fee_type = d.fee_type
            and o.client_type = d.client_type
            and o.seller_type = d.seller_type
            and o.sub_mode = d.sub_mode
            and o.min_amt = d.min_amt
            and o.min_predays = d.min_predays
            and o.min_holddays = d.min_holddays
            and o.other_prd_code = d.other_prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbfeerate;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbfeerate exchange partition p_19000101 with table ${iol_schema}.ifms_tbfeerate_cl;
alter table ${iol_schema}.ifms_tbfeerate exchange partition p_20991231 with table ${iol_schema}.ifms_tbfeerate_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbfeerate to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbfeerate_op purge;
drop table ${iol_schema}.ifms_tbfeerate_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbfeerate_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbfeerate',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
