/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_cpr_index_field_map
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
create table ${iol_schema}.rsts_cpr_index_field_map_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rsts_cpr_index_field_map
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_cpr_index_field_map_op purge;
drop table ${iol_schema}.rsts_cpr_index_field_map_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_index_field_map_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_cpr_index_field_map where 0=1;

create table ${iol_schema}.rsts_cpr_index_field_map_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_cpr_index_field_map where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rsts_cpr_index_field_map_cl(
            uuid -- UUID
            ,indexid -- 指标ID
            ,fieldcode -- 字段标识
            ,fieldname -- 字段名称
            ,source -- 数据来源
            ,filedvalue -- 字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rsts_cpr_index_field_map_op(
            uuid -- UUID
            ,indexid -- 指标ID
            ,fieldcode -- 字段标识
            ,fieldname -- 字段名称
            ,source -- 数据来源
            ,filedvalue -- 字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.uuid, o.uuid) as uuid -- UUID
    ,nvl(n.indexid, o.indexid) as indexid -- 指标ID
    ,nvl(n.fieldcode, o.fieldcode) as fieldcode -- 字段标识
    ,nvl(n.fieldname, o.fieldname) as fieldname -- 字段名称
    ,nvl(n.source, o.source) as source -- 数据来源
    ,nvl(n.filedvalue, o.filedvalue) as filedvalue -- 字段值
    ,case when
            n.uuid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.uuid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.uuid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rsts_cpr_index_field_map_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rsts_cpr_index_field_map where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.uuid = n.uuid
where (
        o.uuid is null
    )
    or (
        n.uuid is null
    )
    or (
        o.indexid <> n.indexid
        or o.fieldcode <> n.fieldcode
        or o.fieldname <> n.fieldname
        or o.source <> n.source
        or o.filedvalue <> n.filedvalue
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rsts_cpr_index_field_map_cl(
            uuid -- UUID
            ,indexid -- 指标ID
            ,fieldcode -- 字段标识
            ,fieldname -- 字段名称
            ,source -- 数据来源
            ,filedvalue -- 字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rsts_cpr_index_field_map_op(
            uuid -- UUID
            ,indexid -- 指标ID
            ,fieldcode -- 字段标识
            ,fieldname -- 字段名称
            ,source -- 数据来源
            ,filedvalue -- 字段值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.uuid -- UUID
    ,o.indexid -- 指标ID
    ,o.fieldcode -- 字段标识
    ,o.fieldname -- 字段名称
    ,o.source -- 数据来源
    ,o.filedvalue -- 字段值
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
from ${iol_schema}.rsts_cpr_index_field_map_bk o
    left join ${iol_schema}.rsts_cpr_index_field_map_op n
        on
            o.uuid = n.uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rsts_cpr_index_field_map_cl d
        on
            o.uuid = d.uuid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rsts_cpr_index_field_map;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rsts_cpr_index_field_map') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rsts_cpr_index_field_map drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rsts_cpr_index_field_map add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rsts_cpr_index_field_map exchange partition p_${batch_date} with table ${iol_schema}.rsts_cpr_index_field_map_cl;
alter table ${iol_schema}.rsts_cpr_index_field_map exchange partition p_20991231 with table ${iol_schema}.rsts_cpr_index_field_map_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_cpr_index_field_map to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_cpr_index_field_map_op purge;
drop table ${iol_schema}.rsts_cpr_index_field_map_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rsts_cpr_index_field_map_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_cpr_index_field_map',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
