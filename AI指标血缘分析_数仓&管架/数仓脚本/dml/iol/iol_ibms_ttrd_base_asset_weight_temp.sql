/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_base_asset_weight_temp
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
create table ${iol_schema}.ibms_ttrd_base_asset_weight_temp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_base_asset_weight_temp
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_temp_op purge;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_temp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_base_asset_weight_temp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_base_asset_weight_temp where 0=1;

create table ${iol_schema}.ibms_ttrd_base_asset_weight_temp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_base_asset_weight_temp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_base_asset_weight_temp_cl(
            id -- 主键
            ,base_asset -- 基础资产
            ,weight -- 权重
            ,parent_id -- 父id
            ,style_level -- 1-父级 2-子级
            ,check_level -- 1-控制子节点小于父节点  2-控制子节点相加为100
            ,is_readonly_weight -- 权重是否只读
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_base_asset_weight_temp_op(
            id -- 主键
            ,base_asset -- 基础资产
            ,weight -- 权重
            ,parent_id -- 父id
            ,style_level -- 1-父级 2-子级
            ,check_level -- 1-控制子节点小于父节点  2-控制子节点相加为100
            ,is_readonly_weight -- 权重是否只读
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.base_asset, o.base_asset) as base_asset -- 基础资产
    ,nvl(n.weight, o.weight) as weight -- 权重
    ,nvl(n.parent_id, o.parent_id) as parent_id -- 父id
    ,nvl(n.style_level, o.style_level) as style_level -- 1-父级 2-子级
    ,nvl(n.check_level, o.check_level) as check_level -- 1-控制子节点小于父节点  2-控制子节点相加为100
    ,nvl(n.is_readonly_weight, o.is_readonly_weight) as is_readonly_weight -- 权重是否只读
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
from (select * from ${iol_schema}.ibms_ttrd_base_asset_weight_temp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_base_asset_weight_temp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.base_asset <> n.base_asset
        or o.weight <> n.weight
        or o.parent_id <> n.parent_id
        or o.style_level <> n.style_level
        or o.check_level <> n.check_level
        or o.is_readonly_weight <> n.is_readonly_weight
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_base_asset_weight_temp_cl(
            id -- 主键
            ,base_asset -- 基础资产
            ,weight -- 权重
            ,parent_id -- 父id
            ,style_level -- 1-父级 2-子级
            ,check_level -- 1-控制子节点小于父节点  2-控制子节点相加为100
            ,is_readonly_weight -- 权重是否只读
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_base_asset_weight_temp_op(
            id -- 主键
            ,base_asset -- 基础资产
            ,weight -- 权重
            ,parent_id -- 父id
            ,style_level -- 1-父级 2-子级
            ,check_level -- 1-控制子节点小于父节点  2-控制子节点相加为100
            ,is_readonly_weight -- 权重是否只读
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.base_asset -- 基础资产
    ,o.weight -- 权重
    ,o.parent_id -- 父id
    ,o.style_level -- 1-父级 2-子级
    ,o.check_level -- 1-控制子节点小于父节点  2-控制子节点相加为100
    ,o.is_readonly_weight -- 权重是否只读
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
from ${iol_schema}.ibms_ttrd_base_asset_weight_temp_bk o
    left join ${iol_schema}.ibms_ttrd_base_asset_weight_temp_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_base_asset_weight_temp_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_base_asset_weight_temp;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_base_asset_weight_temp') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_base_asset_weight_temp drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_base_asset_weight_temp add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_base_asset_weight_temp exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_base_asset_weight_temp_cl;
alter table ${iol_schema}.ibms_ttrd_base_asset_weight_temp exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_base_asset_weight_temp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_base_asset_weight_temp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_temp_op purge;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_temp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_base_asset_weight_temp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_base_asset_weight_temp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
