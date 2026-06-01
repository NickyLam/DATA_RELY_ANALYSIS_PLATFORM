/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_tran_scene_mapping
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
create table ${iol_schema}.ncbs_rb_tran_scene_mapping_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_tran_scene_mapping
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_tran_scene_mapping_op purge;
drop table ${iol_schema}.ncbs_rb_tran_scene_mapping_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tran_scene_mapping_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_tran_scene_mapping where 0=1;

create table ${iol_schema}.ncbs_rb_tran_scene_mapping_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_tran_scene_mapping where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_tran_scene_mapping_cl(
            attr_type -- 参数数据类型
            ,attr_value -- 属性值
            ,company -- 法人
            ,key_value -- 参数键值对
            ,status -- 状态
            ,tran_scene -- 交易场景
            ,tran_scene_desc -- 交易场景描述
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,scene_class -- 场景分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_tran_scene_mapping_op(
            attr_type -- 参数数据类型
            ,attr_value -- 属性值
            ,company -- 法人
            ,key_value -- 参数键值对
            ,status -- 状态
            ,tran_scene -- 交易场景
            ,tran_scene_desc -- 交易场景描述
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,scene_class -- 场景分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.attr_type, o.attr_type) as attr_type -- 参数数据类型
    ,nvl(n.attr_value, o.attr_value) as attr_value -- 属性值
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.key_value, o.key_value) as key_value -- 参数键值对
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.tran_scene, o.tran_scene) as tran_scene -- 交易场景
    ,nvl(n.tran_scene_desc, o.tran_scene_desc) as tran_scene_desc -- 交易场景描述
    ,nvl(n.libra_op_time, o.libra_op_time) as libra_op_time -- libra执行次数
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.scene_class, o.scene_class) as scene_class -- 场景分类
    ,case when
            n.tran_scene is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tran_scene is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tran_scene is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_tran_scene_mapping_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_tran_scene_mapping where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tran_scene = n.tran_scene
where (
        o.tran_scene is null
    )
    or (
        n.tran_scene is null
    )
    or (
        o.attr_type <> n.attr_type
        or o.attr_value <> n.attr_value
        or o.company <> n.company
        or o.key_value <> n.key_value
        or o.status <> n.status
        or o.tran_scene_desc <> n.tran_scene_desc
        or o.libra_op_time <> n.libra_op_time
        or o.tran_timestamp <> n.tran_timestamp
        or o.scene_class <> n.scene_class
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_tran_scene_mapping_cl(
            attr_type -- 参数数据类型
            ,attr_value -- 属性值
            ,company -- 法人
            ,key_value -- 参数键值对
            ,status -- 状态
            ,tran_scene -- 交易场景
            ,tran_scene_desc -- 交易场景描述
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,scene_class -- 场景分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_tran_scene_mapping_op(
            attr_type -- 参数数据类型
            ,attr_value -- 属性值
            ,company -- 法人
            ,key_value -- 参数键值对
            ,status -- 状态
            ,tran_scene -- 交易场景
            ,tran_scene_desc -- 交易场景描述
            ,libra_op_time -- libra执行次数
            ,tran_timestamp -- 交易时间戳
            ,scene_class -- 场景分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.attr_type -- 参数数据类型
    ,o.attr_value -- 属性值
    ,o.company -- 法人
    ,o.key_value -- 参数键值对
    ,o.status -- 状态
    ,o.tran_scene -- 交易场景
    ,o.tran_scene_desc -- 交易场景描述
    ,o.libra_op_time -- libra执行次数
    ,o.tran_timestamp -- 交易时间戳
    ,o.scene_class -- 场景分类
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
from ${iol_schema}.ncbs_rb_tran_scene_mapping_bk o
    left join ${iol_schema}.ncbs_rb_tran_scene_mapping_op n
        on
            o.tran_scene = n.tran_scene
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_tran_scene_mapping_cl d
        on
            o.tran_scene = d.tran_scene
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_tran_scene_mapping;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_tran_scene_mapping') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_tran_scene_mapping drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_tran_scene_mapping add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_tran_scene_mapping exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_tran_scene_mapping_cl;
alter table ${iol_schema}.ncbs_rb_tran_scene_mapping exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_tran_scene_mapping_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_tran_scene_mapping to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_tran_scene_mapping_op purge;
drop table ${iol_schema}.ncbs_rb_tran_scene_mapping_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_tran_scene_mapping_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_tran_scene_mapping',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
