/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbassetacc
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
create table ${iol_schema}.ifms_tbassetacc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbassetacc;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbassetacc_op purge;
drop table ${iol_schema}.ifms_tbassetacc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbassetacc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbassetacc where 0=1;

create table ${iol_schema}.ifms_tbassetacc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbassetacc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbassetacc_cl(
            in_client_no -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,open_branch -- 
            ,ta_client -- 
            ,client_manager -- 
            ,open_flag -- 
            ,send_freq -- 
            ,send_mode -- 
            ,client_type -- 
            ,prd_type -- 
            ,status -- 
            ,open_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbassetacc_op(
            in_client_no -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,open_branch -- 
            ,ta_client -- 
            ,client_manager -- 
            ,open_flag -- 
            ,send_freq -- 
            ,send_mode -- 
            ,client_type -- 
            ,prd_type -- 
            ,status -- 
            ,open_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.ta_code, o.ta_code) as ta_code -- 
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 
    ,nvl(n.ta_client, o.ta_client) as ta_client -- 
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 
    ,nvl(n.open_flag, o.open_flag) as open_flag -- 
    ,nvl(n.send_freq, o.send_freq) as send_freq -- 
    ,nvl(n.send_mode, o.send_mode) as send_mode -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.open_date, o.open_date) as open_date -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,case when
            n.in_client_no is null
            and n.ta_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.in_client_no is null
            and n.ta_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.in_client_no is null
            and n.ta_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbassetacc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbassetacc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.in_client_no = n.in_client_no
            and o.ta_code = n.ta_code
where (
        o.in_client_no is null
        and o.ta_code is null
    )
    or (
        n.in_client_no is null
        and n.ta_code is null
    )
    or (
        o.asset_acc <> n.asset_acc
        or o.open_branch <> n.open_branch
        or o.ta_client <> n.ta_client
        or o.client_manager <> n.client_manager
        or o.open_flag <> n.open_flag
        or o.send_freq <> n.send_freq
        or o.send_mode <> n.send_mode
        or o.client_type <> n.client_type
        or o.prd_type <> n.prd_type
        or o.status <> n.status
        or o.open_date <> n.open_date
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbassetacc_cl(
            in_client_no -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,open_branch -- 
            ,ta_client -- 
            ,client_manager -- 
            ,open_flag -- 
            ,send_freq -- 
            ,send_mode -- 
            ,client_type -- 
            ,prd_type -- 
            ,status -- 
            ,open_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbassetacc_op(
            in_client_no -- 
            ,ta_code -- 
            ,asset_acc -- 
            ,open_branch -- 
            ,ta_client -- 
            ,client_manager -- 
            ,open_flag -- 
            ,send_freq -- 
            ,send_mode -- 
            ,client_type -- 
            ,prd_type -- 
            ,status -- 
            ,open_date -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 
    ,o.ta_code -- 
    ,o.asset_acc -- 
    ,o.open_branch -- 
    ,o.ta_client -- 
    ,o.client_manager -- 
    ,o.open_flag -- 
    ,o.send_freq -- 
    ,o.send_mode -- 
    ,o.client_type -- 
    ,o.prd_type -- 
    ,o.status -- 
    ,o.open_date -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbassetacc_bk o
    left join ${iol_schema}.ifms_tbassetacc_op n
        on
            o.in_client_no = n.in_client_no
            and o.ta_code = n.ta_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbassetacc_cl d
        on
            o.in_client_no = d.in_client_no
            and o.ta_code = d.ta_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbassetacc;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbassetacc exchange partition p_19000101 with table ${iol_schema}.ifms_tbassetacc_cl;
alter table ${iol_schema}.ifms_tbassetacc exchange partition p_20991231 with table ${iol_schema}.ifms_tbassetacc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbassetacc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbassetacc_op purge;
drop table ${iol_schema}.ifms_tbassetacc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbassetacc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbassetacc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
