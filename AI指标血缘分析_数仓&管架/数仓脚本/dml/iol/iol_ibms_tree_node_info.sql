/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tree_node_info
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
create table ${iol_schema}.ibms_tree_node_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tree_node_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tree_node_info_op purge;
drop table ${iol_schema}.ibms_tree_node_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tree_node_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tree_node_info where 0=1;

create table ${iol_schema}.ibms_tree_node_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tree_node_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tree_node_info_cl(
            tree_code -- 
            ,node_id -- 
            ,parent_id -- 
            ,node_name -- 
            ,node_type -- 
            ,node_value -- 
            ,sort_id -- 
            ,py_code -- 
            ,update_time -- 
            ,seat_no -- 通道号
            ,seat_name -- 通道名称
            ,p_node_name -- 
            ,ext_info -- 扩展信息
            ,ext_description -- 扩展字段描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tree_node_info_op(
            tree_code -- 
            ,node_id -- 
            ,parent_id -- 
            ,node_name -- 
            ,node_type -- 
            ,node_value -- 
            ,sort_id -- 
            ,py_code -- 
            ,update_time -- 
            ,seat_no -- 通道号
            ,seat_name -- 通道名称
            ,p_node_name -- 
            ,ext_info -- 扩展信息
            ,ext_description -- 扩展字段描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tree_code, o.tree_code) as tree_code -- 
    ,nvl(n.node_id, o.node_id) as node_id -- 
    ,nvl(n.parent_id, o.parent_id) as parent_id -- 
    ,nvl(n.node_name, o.node_name) as node_name -- 
    ,nvl(n.node_type, o.node_type) as node_type -- 
    ,nvl(n.node_value, o.node_value) as node_value -- 
    ,nvl(n.sort_id, o.sort_id) as sort_id -- 
    ,nvl(n.py_code, o.py_code) as py_code -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.seat_no, o.seat_no) as seat_no -- 通道号
    ,nvl(n.seat_name, o.seat_name) as seat_name -- 通道名称
    ,nvl(n.p_node_name, o.p_node_name) as p_node_name -- 
    ,nvl(n.ext_info, o.ext_info) as ext_info -- 扩展信息
    ,nvl(n.ext_description, o.ext_description) as ext_description -- 扩展字段描述
    ,case when
            n.node_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.node_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.node_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_tree_node_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tree_node_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.node_id = n.node_id
where (
        o.node_id is null
    )
    or (
        n.node_id is null
    )
    or (
        o.tree_code <> n.tree_code
        or o.parent_id <> n.parent_id
        or o.node_name <> n.node_name
        or o.node_type <> n.node_type
        or o.node_value <> n.node_value
        or o.sort_id <> n.sort_id
        or o.py_code <> n.py_code
        or o.update_time <> n.update_time
        or o.seat_no <> n.seat_no
        or o.seat_name <> n.seat_name
        or o.p_node_name <> n.p_node_name
        or o.ext_info <> n.ext_info
        or o.ext_description <> n.ext_description
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tree_node_info_cl(
            tree_code -- 
            ,node_id -- 
            ,parent_id -- 
            ,node_name -- 
            ,node_type -- 
            ,node_value -- 
            ,sort_id -- 
            ,py_code -- 
            ,update_time -- 
            ,seat_no -- 通道号
            ,seat_name -- 通道名称
            ,p_node_name -- 
            ,ext_info -- 扩展信息
            ,ext_description -- 扩展字段描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tree_node_info_op(
            tree_code -- 
            ,node_id -- 
            ,parent_id -- 
            ,node_name -- 
            ,node_type -- 
            ,node_value -- 
            ,sort_id -- 
            ,py_code -- 
            ,update_time -- 
            ,seat_no -- 通道号
            ,seat_name -- 通道名称
            ,p_node_name -- 
            ,ext_info -- 扩展信息
            ,ext_description -- 扩展字段描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tree_code -- 
    ,o.node_id -- 
    ,o.parent_id -- 
    ,o.node_name -- 
    ,o.node_type -- 
    ,o.node_value -- 
    ,o.sort_id -- 
    ,o.py_code -- 
    ,o.update_time -- 
    ,o.seat_no -- 通道号
    ,o.seat_name -- 通道名称
    ,o.p_node_name -- 
    ,o.ext_info -- 扩展信息
    ,o.ext_description -- 扩展字段描述
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_tree_node_info_bk o
    left join ${iol_schema}.ibms_tree_node_info_op n
        on
            o.node_id = n.node_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tree_node_info_cl d
        on
            o.node_id = d.node_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_tree_node_info;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_tree_node_info exchange partition p_19000101 with table ${iol_schema}.ibms_tree_node_info_cl;
alter table ${iol_schema}.ibms_tree_node_info exchange partition p_20991231 with table ${iol_schema}.ibms_tree_node_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tree_node_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tree_node_info_op purge;
drop table ${iol_schema}.ibms_tree_node_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tree_node_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tree_node_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
