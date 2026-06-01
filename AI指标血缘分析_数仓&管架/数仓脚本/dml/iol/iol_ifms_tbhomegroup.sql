/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbhomegroup
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
create table ${iol_schema}.ifms_tbhomegroup_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbhomegroup;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbhomegroup_op purge;
drop table ${iol_schema}.ifms_tbhomegroup_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhomegroup_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbhomegroup where 0=1;

create table ${iol_schema}.ifms_tbhomegroup_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbhomegroup where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbhomegroup_cl(
            home_id -- 
            ,bank_acc -- 
            ,client_no -- 
            ,client_name -- 
            ,id_type -- 
            ,id_code -- 
            ,mobile -- 
            ,open_branch -- 
            ,status -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbhomegroup_op(
            home_id -- 
            ,bank_acc -- 
            ,client_no -- 
            ,client_name -- 
            ,id_type -- 
            ,id_code -- 
            ,mobile -- 
            ,open_branch -- 
            ,status -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.home_id, o.home_id) as home_id -- 
    ,nvl(n.bank_acc, o.bank_acc) as bank_acc -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.client_name, o.client_name) as client_name -- 
    ,nvl(n.id_type, o.id_type) as id_type -- 
    ,nvl(n.id_code, o.id_code) as id_code -- 
    ,nvl(n.mobile, o.mobile) as mobile -- 
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,case when
            n.home_id is null
            and n.bank_acc is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.home_id is null
            and n.bank_acc is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.home_id is null
            and n.bank_acc is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbhomegroup_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbhomegroup where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.home_id = n.home_id
            and o.bank_acc = n.bank_acc
where (
        o.home_id is null
        and o.bank_acc is null
    )
    or (
        n.home_id is null
        and n.bank_acc is null
    )
    or (
        o.client_no <> n.client_no
        or o.client_name <> n.client_name
        or o.id_type <> n.id_type
        or o.id_code <> n.id_code
        or o.mobile <> n.mobile
        or o.open_branch <> n.open_branch
        or o.status <> n.status
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbhomegroup_cl(
            home_id -- 
            ,bank_acc -- 
            ,client_no -- 
            ,client_name -- 
            ,id_type -- 
            ,id_code -- 
            ,mobile -- 
            ,open_branch -- 
            ,status -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbhomegroup_op(
            home_id -- 
            ,bank_acc -- 
            ,client_no -- 
            ,client_name -- 
            ,id_type -- 
            ,id_code -- 
            ,mobile -- 
            ,open_branch -- 
            ,status -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.home_id -- 
    ,o.bank_acc -- 
    ,o.client_no -- 
    ,o.client_name -- 
    ,o.id_type -- 
    ,o.id_code -- 
    ,o.mobile -- 
    ,o.open_branch -- 
    ,o.status -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbhomegroup_bk o
    left join ${iol_schema}.ifms_tbhomegroup_op n
        on
            o.home_id = n.home_id
            and o.bank_acc = n.bank_acc
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbhomegroup_cl d
        on
            o.home_id = d.home_id
            and o.bank_acc = d.bank_acc
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbhomegroup;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbhomegroup exchange partition p_19000101 with table ${iol_schema}.ifms_tbhomegroup_cl;
alter table ${iol_schema}.ifms_tbhomegroup exchange partition p_20991231 with table ${iol_schema}.ifms_tbhomegroup_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbhomegroup to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbhomegroup_op purge;
drop table ${iol_schema}.ifms_tbhomegroup_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbhomegroup_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbhomegroup',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
