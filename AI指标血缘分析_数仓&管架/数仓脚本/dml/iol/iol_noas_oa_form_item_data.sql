/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_form_item_data
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
create table ${iol_schema}.noas_oa_form_item_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_oa_form_item_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_form_item_data_op purge;
drop table ${iol_schema}.noas_oa_form_item_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_form_item_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_form_item_data where 0=1;

create table ${iol_schema}.noas_oa_form_item_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_form_item_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_form_item_data_cl(
            form_item_data_id -- 主键
            ,process_ins_id -- 流程实体id
            ,item_key -- 表单key
            ,item_value -- 表单value
            ,form_def_id -- 表单定义id
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,process_status -- 1,审批中，2审批通过，3，已拒绝
            ,data_year -- 数据年份
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_form_item_data_op(
            form_item_data_id -- 主键
            ,process_ins_id -- 流程实体id
            ,item_key -- 表单key
            ,item_value -- 表单value
            ,form_def_id -- 表单定义id
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,process_status -- 1,审批中，2审批通过，3，已拒绝
            ,data_year -- 数据年份
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.form_item_data_id, o.form_item_data_id) as form_item_data_id -- 主键
    ,nvl(n.process_ins_id, o.process_ins_id) as process_ins_id -- 流程实体id
    ,nvl(n.item_key, o.item_key) as item_key -- 表单key
    ,nvl(n.item_value, o.item_value) as item_value -- 表单value
    ,nvl(n.form_def_id, o.form_def_id) as form_def_id -- 表单定义id
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 最后更新时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 最后更新事务时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 创建事务时间
    ,nvl(n.process_status, o.process_status) as process_status -- 1,审批中，2审批通过，3，已拒绝
    ,nvl(n.data_year, o.data_year) as data_year -- 数据年份
    ,case when
            n.form_item_data_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.form_item_data_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.form_item_data_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_oa_form_item_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_oa_form_item_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.form_item_data_id = n.form_item_data_id
where (
        o.form_item_data_id is null
    )
    or (
        n.form_item_data_id is null
    )
    or (
        o.process_ins_id <> n.process_ins_id
        or o.item_key <> n.item_key
        or o.item_value <> n.item_value
        or o.form_def_id <> n.form_def_id
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.process_status <> n.process_status
        or o.data_year <> n.data_year
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_form_item_data_cl(
            form_item_data_id -- 主键
            ,process_ins_id -- 流程实体id
            ,item_key -- 表单key
            ,item_value -- 表单value
            ,form_def_id -- 表单定义id
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,process_status -- 1,审批中，2审批通过，3，已拒绝
            ,data_year -- 数据年份
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_form_item_data_op(
            form_item_data_id -- 主键
            ,process_ins_id -- 流程实体id
            ,item_key -- 表单key
            ,item_value -- 表单value
            ,form_def_id -- 表单定义id
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,process_status -- 1,审批中，2审批通过，3，已拒绝
            ,data_year -- 数据年份
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.form_item_data_id -- 主键
    ,o.process_ins_id -- 流程实体id
    ,o.item_key -- 表单key
    ,o.item_value -- 表单value
    ,o.form_def_id -- 表单定义id
    ,o.last_updated_stamp -- 最后更新时间
    ,o.last_updated_tx_stamp -- 最后更新事务时间
    ,o.created_stamp -- 创建时间
    ,o.created_tx_stamp -- 创建事务时间
    ,o.process_status -- 1,审批中，2审批通过，3，已拒绝
    ,o.data_year -- 数据年份
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
from ${iol_schema}.noas_oa_form_item_data_bk o
    left join ${iol_schema}.noas_oa_form_item_data_op n
        on
            o.form_item_data_id = n.form_item_data_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_oa_form_item_data_cl d
        on
            o.form_item_data_id = d.form_item_data_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.noas_oa_form_item_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('noas_oa_form_item_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.noas_oa_form_item_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.noas_oa_form_item_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.noas_oa_form_item_data exchange partition p_${batch_date} with table ${iol_schema}.noas_oa_form_item_data_cl;
alter table ${iol_schema}.noas_oa_form_item_data exchange partition p_20991231 with table ${iol_schema}.noas_oa_form_item_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_oa_form_item_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_form_item_data_op purge;
drop table ${iol_schema}.noas_oa_form_item_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_oa_form_item_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_oa_form_item_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
