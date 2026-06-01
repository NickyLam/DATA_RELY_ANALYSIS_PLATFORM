/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_institution_contact
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
create table ${iol_schema}.ibms_ttrd_institution_contact_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_institution_contact;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_institution_contact_op purge;
drop table ${iol_schema}.ibms_ttrd_institution_contact_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_institution_contact_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_institution_contact where 0=1;

create table ${iol_schema}.ibms_ttrd_institution_contact_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_institution_contact where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_institution_contact_cl(
            i_id -- 
            ,c_id -- 
            ,c_prop -- 
            ,c_name -- 
            ,c_tel -- 
            ,c_cellphone -- 
            ,c_email -- 
            ,c_i_id -- 
            ,cfets_trader_id -- 交易员ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_institution_contact_op(
            i_id -- 
            ,c_id -- 
            ,c_prop -- 
            ,c_name -- 
            ,c_tel -- 
            ,c_cellphone -- 
            ,c_email -- 
            ,c_i_id -- 
            ,cfets_trader_id -- 交易员ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_id, o.i_id) as i_id -- 
    ,nvl(n.c_id, o.c_id) as c_id -- 
    ,nvl(n.c_prop, o.c_prop) as c_prop -- 
    ,nvl(n.c_name, o.c_name) as c_name -- 
    ,nvl(n.c_tel, o.c_tel) as c_tel -- 
    ,nvl(n.c_cellphone, o.c_cellphone) as c_cellphone -- 
    ,nvl(n.c_email, o.c_email) as c_email -- 
    ,nvl(n.c_i_id, o.c_i_id) as c_i_id -- 
    ,nvl(n.cfets_trader_id, o.cfets_trader_id) as cfets_trader_id -- 交易员ID
    ,case when
            n.c_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.c_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.c_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_institution_contact_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_institution_contact where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.c_id = n.c_id
where (
        o.c_id is null
    )
    or (
        n.c_id is null
    )
    or (
        o.i_id <> n.i_id
        or o.c_prop <> n.c_prop
        or o.c_name <> n.c_name
        or o.c_tel <> n.c_tel
        or o.c_cellphone <> n.c_cellphone
        or o.c_email <> n.c_email
        or o.c_i_id <> n.c_i_id
        or o.cfets_trader_id <> n.cfets_trader_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_institution_contact_cl(
            i_id -- 
            ,c_id -- 
            ,c_prop -- 
            ,c_name -- 
            ,c_tel -- 
            ,c_cellphone -- 
            ,c_email -- 
            ,c_i_id -- 
            ,cfets_trader_id -- 交易员ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_institution_contact_op(
            i_id -- 
            ,c_id -- 
            ,c_prop -- 
            ,c_name -- 
            ,c_tel -- 
            ,c_cellphone -- 
            ,c_email -- 
            ,c_i_id -- 
            ,cfets_trader_id -- 交易员ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_id -- 
    ,o.c_id -- 
    ,o.c_prop -- 
    ,o.c_name -- 
    ,o.c_tel -- 
    ,o.c_cellphone -- 
    ,o.c_email -- 
    ,o.c_i_id -- 
    ,o.cfets_trader_id -- 交易员ID
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_institution_contact_bk o
    left join ${iol_schema}.ibms_ttrd_institution_contact_op n
        on
            o.c_id = n.c_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_institution_contact_cl d
        on
            o.c_id = d.c_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_institution_contact;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_institution_contact exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_institution_contact_cl;
alter table ${iol_schema}.ibms_ttrd_institution_contact exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_institution_contact_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_institution_contact to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_institution_contact_op purge;
drop table ${iol_schema}.ibms_ttrd_institution_contact_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_institution_contact_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_institution_contact',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
