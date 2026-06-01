/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_account_apply_info
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
create table ${iol_schema}.bdps_account_apply_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_account_apply_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_account_apply_info_op purge;
drop table ${iol_schema}.bdps_account_apply_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_account_apply_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_account_apply_info where 0=1;

create table ${iol_schema}.bdps_account_apply_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_account_apply_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_account_apply_info_cl(
            id -- 
            ,account_id -- 
            ,account_no -- 
            ,sub_account_no -- 
            ,txn_type -- 
            ,old_account_no -- 
            ,old_sub_account_no -- 
            ,apply_date -- 
            ,appno -- 
            ,traceno -- 
            ,las_upd_id -- 
            ,last_upd_time -- 
            ,misc -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_account_apply_info_op(
            id -- 
            ,account_id -- 
            ,account_no -- 
            ,sub_account_no -- 
            ,txn_type -- 
            ,old_account_no -- 
            ,old_sub_account_no -- 
            ,apply_date -- 
            ,appno -- 
            ,traceno -- 
            ,las_upd_id -- 
            ,last_upd_time -- 
            ,misc -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.account_id, o.account_id) as account_id -- 
    ,nvl(n.account_no, o.account_no) as account_no -- 
    ,nvl(n.sub_account_no, o.sub_account_no) as sub_account_no -- 
    ,nvl(n.txn_type, o.txn_type) as txn_type -- 
    ,nvl(n.old_account_no, o.old_account_no) as old_account_no -- 
    ,nvl(n.old_sub_account_no, o.old_sub_account_no) as old_sub_account_no -- 
    ,nvl(n.apply_date, o.apply_date) as apply_date -- 
    ,nvl(n.appno, o.appno) as appno -- 
    ,nvl(n.traceno, o.traceno) as traceno -- 
    ,nvl(n.las_upd_id, o.las_upd_id) as las_upd_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.misc, o.misc) as misc -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdps_account_apply_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_account_apply_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.account_id <> n.account_id
        or o.account_no <> n.account_no
        or o.sub_account_no <> n.sub_account_no
        or o.txn_type <> n.txn_type
        or o.old_account_no <> n.old_account_no
        or o.old_sub_account_no <> n.old_sub_account_no
        or o.apply_date <> n.apply_date
        or o.appno <> n.appno
        or o.traceno <> n.traceno
        or o.las_upd_id <> n.las_upd_id
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_account_apply_info_cl(
            id -- 
            ,account_id -- 
            ,account_no -- 
            ,sub_account_no -- 
            ,txn_type -- 
            ,old_account_no -- 
            ,old_sub_account_no -- 
            ,apply_date -- 
            ,appno -- 
            ,traceno -- 
            ,las_upd_id -- 
            ,last_upd_time -- 
            ,misc -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_account_apply_info_op(
            id -- 
            ,account_id -- 
            ,account_no -- 
            ,sub_account_no -- 
            ,txn_type -- 
            ,old_account_no -- 
            ,old_sub_account_no -- 
            ,apply_date -- 
            ,appno -- 
            ,traceno -- 
            ,las_upd_id -- 
            ,last_upd_time -- 
            ,misc -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.account_id -- 
    ,o.account_no -- 
    ,o.sub_account_no -- 
    ,o.txn_type -- 
    ,o.old_account_no -- 
    ,o.old_sub_account_no -- 
    ,o.apply_date -- 
    ,o.appno -- 
    ,o.traceno -- 
    ,o.las_upd_id -- 
    ,o.last_upd_time -- 
    ,o.misc -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_account_apply_info_bk o
    left join ${iol_schema}.bdps_account_apply_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_account_apply_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.bdps_account_apply_info;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_account_apply_info exchange partition p_19000101 with table ${iol_schema}.bdps_account_apply_info_cl;
alter table ${iol_schema}.bdps_account_apply_info exchange partition p_20991231 with table ${iol_schema}.bdps_account_apply_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_account_apply_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_account_apply_info_op purge;
drop table ${iol_schema}.bdps_account_apply_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_account_apply_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_account_apply_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
