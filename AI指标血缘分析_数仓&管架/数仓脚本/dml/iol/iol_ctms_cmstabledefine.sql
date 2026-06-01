/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_cmstabledefine
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
create table ${iol_schema}.ctms_cmstabledefine_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_cmstabledefine
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_cmstabledefine_op purge;
drop table ${iol_schema}.ctms_cmstabledefine_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_cmstabledefine_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_cmstabledefine where 0=1;

create table ${iol_schema}.ctms_cmstabledefine_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_cmstabledefine where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_cmstabledefine_cl(
            cmstabledefine_id -- 
            ,aspclient_id -- 
            ,f_type -- 
            ,field_name -- 
            ,field_desc -- 
            ,field_parent -- 
            ,modify_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_cmstabledefine_op(
            cmstabledefine_id -- 
            ,aspclient_id -- 
            ,f_type -- 
            ,field_name -- 
            ,field_desc -- 
            ,field_parent -- 
            ,modify_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cmstabledefine_id, o.cmstabledefine_id) as cmstabledefine_id -- 
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 
    ,nvl(n.f_type, o.f_type) as f_type -- 
    ,nvl(n.field_name, o.field_name) as field_name -- 
    ,nvl(n.field_desc, o.field_desc) as field_desc -- 
    ,nvl(n.field_parent, o.field_parent) as field_parent -- 
    ,nvl(n.modify_time, o.modify_time) as modify_time -- 
    ,case when
            n.cmstabledefine_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cmstabledefine_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cmstabledefine_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_cmstabledefine_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_cmstabledefine where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cmstabledefine_id = n.cmstabledefine_id
where (
        o.cmstabledefine_id is null
    )
    or (
        n.cmstabledefine_id is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.f_type <> n.f_type
        or o.field_name <> n.field_name
        or o.field_desc <> n.field_desc
        or o.field_parent <> n.field_parent
        or o.modify_time <> n.modify_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_cmstabledefine_cl(
            cmstabledefine_id -- 
            ,aspclient_id -- 
            ,f_type -- 
            ,field_name -- 
            ,field_desc -- 
            ,field_parent -- 
            ,modify_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_cmstabledefine_op(
            cmstabledefine_id -- 
            ,aspclient_id -- 
            ,f_type -- 
            ,field_name -- 
            ,field_desc -- 
            ,field_parent -- 
            ,modify_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cmstabledefine_id -- 
    ,o.aspclient_id -- 
    ,o.f_type -- 
    ,o.field_name -- 
    ,o.field_desc -- 
    ,o.field_parent -- 
    ,o.modify_time -- 
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
from ${iol_schema}.ctms_cmstabledefine_bk o
    left join ${iol_schema}.ctms_cmstabledefine_op n
        on
            o.cmstabledefine_id = n.cmstabledefine_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_cmstabledefine_cl d
        on
            o.cmstabledefine_id = d.cmstabledefine_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_cmstabledefine;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_cmstabledefine') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_cmstabledefine drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_cmstabledefine add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_cmstabledefine exchange partition p_${batch_date} with table ${iol_schema}.ctms_cmstabledefine_cl;
alter table ${iol_schema}.ctms_cmstabledefine exchange partition p_20991231 with table ${iol_schema}.ctms_cmstabledefine_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_cmstabledefine to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_cmstabledefine_op purge;
drop table ${iol_schema}.ctms_cmstabledefine_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_cmstabledefine_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_cmstabledefine',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
