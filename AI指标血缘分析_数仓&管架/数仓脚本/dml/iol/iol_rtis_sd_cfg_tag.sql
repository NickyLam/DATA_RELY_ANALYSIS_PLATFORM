/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rtis_sd_cfg_tag
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
create table ${iol_schema}.rtis_sd_cfg_tag_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rtis_sd_cfg_tag
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_sd_cfg_tag_op purge;
drop table ${iol_schema}.rtis_sd_cfg_tag_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_sd_cfg_tag_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_sd_cfg_tag where 0=1;

create table ${iol_schema}.rtis_sd_cfg_tag_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rtis_sd_cfg_tag where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_sd_cfg_tag_cl(
            id_ -- 主键
            ,code_ -- 标签CODE
            ,name_ -- 标签名称
            ,comment_ -- 类型说明
            ,group_id_ -- 所属标签组
            ,oper_scene_id -- 操作省
            ,create_by -- 创建人
            ,update_by -- 更新人
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_sd_cfg_tag_op(
            id_ -- 主键
            ,code_ -- 标签CODE
            ,name_ -- 标签名称
            ,comment_ -- 类型说明
            ,group_id_ -- 所属标签组
            ,oper_scene_id -- 操作省
            ,create_by -- 创建人
            ,update_by -- 更新人
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id_, o.id_) as id_ -- 主键
    ,nvl(n.code_, o.code_) as code_ -- 标签CODE
    ,nvl(n.name_, o.name_) as name_ -- 标签名称
    ,nvl(n.comment_, o.comment_) as comment_ -- 类型说明
    ,nvl(n.group_id_, o.group_id_) as group_id_ -- 所属标签组
    ,nvl(n.oper_scene_id, o.oper_scene_id) as oper_scene_id -- 操作省
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
    ,nvl(n.update_by, o.update_by) as update_by -- 更新人
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.id_ is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id_ is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id_ is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rtis_sd_cfg_tag_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rtis_sd_cfg_tag where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id_ = n.id_
where (
        o.id_ is null
    )
    or (
        n.id_ is null
    )
    or (
        o.code_ <> n.code_
        or o.name_ <> n.name_
        or o.comment_ <> n.comment_
        or o.group_id_ <> n.group_id_
        or o.oper_scene_id <> n.oper_scene_id
        or o.create_by <> n.create_by
        or o.update_by <> n.update_by
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rtis_sd_cfg_tag_cl(
            id_ -- 主键
            ,code_ -- 标签CODE
            ,name_ -- 标签名称
            ,comment_ -- 类型说明
            ,group_id_ -- 所属标签组
            ,oper_scene_id -- 操作省
            ,create_by -- 创建人
            ,update_by -- 更新人
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rtis_sd_cfg_tag_op(
            id_ -- 主键
            ,code_ -- 标签CODE
            ,name_ -- 标签名称
            ,comment_ -- 类型说明
            ,group_id_ -- 所属标签组
            ,oper_scene_id -- 操作省
            ,create_by -- 创建人
            ,update_by -- 更新人
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id_ -- 主键
    ,o.code_ -- 标签CODE
    ,o.name_ -- 标签名称
    ,o.comment_ -- 类型说明
    ,o.group_id_ -- 所属标签组
    ,o.oper_scene_id -- 操作省
    ,o.create_by -- 创建人
    ,o.update_by -- 更新人
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
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
from ${iol_schema}.rtis_sd_cfg_tag_bk o
    left join ${iol_schema}.rtis_sd_cfg_tag_op n
        on
            o.id_ = n.id_
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rtis_sd_cfg_tag_cl d
        on
            o.id_ = d.id_
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rtis_sd_cfg_tag;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rtis_sd_cfg_tag') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rtis_sd_cfg_tag drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rtis_sd_cfg_tag add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rtis_sd_cfg_tag exchange partition p_${batch_date} with table ${iol_schema}.rtis_sd_cfg_tag_cl;
alter table ${iol_schema}.rtis_sd_cfg_tag exchange partition p_20991231 with table ${iol_schema}.rtis_sd_cfg_tag_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rtis_sd_cfg_tag to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rtis_sd_cfg_tag_op purge;
drop table ${iol_schema}.rtis_sd_cfg_tag_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rtis_sd_cfg_tag_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rtis_sd_cfg_tag',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
