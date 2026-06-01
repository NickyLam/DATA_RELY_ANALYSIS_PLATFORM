/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_flow_entity_relation
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
create table ${iol_schema}.noas_oa_flow_entity_relation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_oa_flow_entity_relation
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_flow_entity_relation_op purge;
drop table ${iol_schema}.noas_oa_flow_entity_relation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_flow_entity_relation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_flow_entity_relation where 0=1;

create table ${iol_schema}.noas_oa_flow_entity_relation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_flow_entity_relation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_flow_entity_relation_cl(
            relation_id -- 
            ,flow_key -- 
            ,item_key -- 
            ,entity_name -- 
            ,entity_field -- 
            ,field_type -- 
            ,type -- 
            ,remark -- 
            ,choose_item_key -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_flow_entity_relation_op(
            relation_id -- 
            ,flow_key -- 
            ,item_key -- 
            ,entity_name -- 
            ,entity_field -- 
            ,field_type -- 
            ,type -- 
            ,remark -- 
            ,choose_item_key -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.relation_id, o.relation_id) as relation_id -- 
    ,nvl(n.flow_key, o.flow_key) as flow_key -- 
    ,nvl(n.item_key, o.item_key) as item_key -- 
    ,nvl(n.entity_name, o.entity_name) as entity_name -- 
    ,nvl(n.entity_field, o.entity_field) as entity_field -- 
    ,nvl(n.field_type, o.field_type) as field_type -- 
    ,nvl(n.type, o.type) as type -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.choose_item_key, o.choose_item_key) as choose_item_key -- 
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 
    ,case when
            n.relation_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.relation_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.relation_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_oa_flow_entity_relation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_oa_flow_entity_relation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.relation_id = n.relation_id
where (
        o.relation_id is null
    )
    or (
        n.relation_id is null
    )
    or (
        o.flow_key <> n.flow_key
        or o.item_key <> n.item_key
        or o.entity_name <> n.entity_name
        or o.entity_field <> n.entity_field
        or o.field_type <> n.field_type
        or o.type <> n.type
        or o.remark <> n.remark
        or o.choose_item_key <> n.choose_item_key
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_flow_entity_relation_cl(
            relation_id -- 
            ,flow_key -- 
            ,item_key -- 
            ,entity_name -- 
            ,entity_field -- 
            ,field_type -- 
            ,type -- 
            ,remark -- 
            ,choose_item_key -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_flow_entity_relation_op(
            relation_id -- 
            ,flow_key -- 
            ,item_key -- 
            ,entity_name -- 
            ,entity_field -- 
            ,field_type -- 
            ,type -- 
            ,remark -- 
            ,choose_item_key -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.relation_id -- 
    ,o.flow_key -- 
    ,o.item_key -- 
    ,o.entity_name -- 
    ,o.entity_field -- 
    ,o.field_type -- 
    ,o.type -- 
    ,o.remark -- 
    ,o.choose_item_key -- 
    ,o.last_updated_stamp -- 
    ,o.last_updated_tx_stamp -- 
    ,o.created_stamp -- 
    ,o.created_tx_stamp -- 
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
from ${iol_schema}.noas_oa_flow_entity_relation_bk o
    left join ${iol_schema}.noas_oa_flow_entity_relation_op n
        on
            o.relation_id = n.relation_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_oa_flow_entity_relation_cl d
        on
            o.relation_id = d.relation_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.noas_oa_flow_entity_relation;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('noas_oa_flow_entity_relation') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.noas_oa_flow_entity_relation drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.noas_oa_flow_entity_relation add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.noas_oa_flow_entity_relation exchange partition p_${batch_date} with table ${iol_schema}.noas_oa_flow_entity_relation_cl;
alter table ${iol_schema}.noas_oa_flow_entity_relation exchange partition p_20991231 with table ${iol_schema}.noas_oa_flow_entity_relation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_oa_flow_entity_relation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_flow_entity_relation_op purge;
drop table ${iol_schema}.noas_oa_flow_entity_relation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_oa_flow_entity_relation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_oa_flow_entity_relation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
