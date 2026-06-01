/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bd_data_dictionary
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
create table ${iol_schema}.bdms_bd_data_dictionary_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bd_data_dictionary
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bd_data_dictionary_op purge;
drop table ${iol_schema}.bdms_bd_data_dictionary_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bd_data_dictionary_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bd_data_dictionary where 0=1;

create table ${iol_schema}.bdms_bd_data_dictionary_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bd_data_dictionary where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bd_data_dictionary_cl(
            id -- 主键
            ,sys_code -- 系统编码
            ,sys_name -- 系统名称
            ,team_code -- 预留字段
            ,team_name -- 预留字段
            ,dict_code -- 字典编号
            ,dict_name -- 编号名称
            ,data_val -- 值
            ,data_trs_val -- 英文值
            ,description -- 描述
            ,orderby -- 排序
            ,version_num -- 版本号
            ,is_del -- 是否已删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bd_data_dictionary_op(
            id -- 主键
            ,sys_code -- 系统编码
            ,sys_name -- 系统名称
            ,team_code -- 预留字段
            ,team_name -- 预留字段
            ,dict_code -- 字典编号
            ,dict_name -- 编号名称
            ,data_val -- 值
            ,data_trs_val -- 英文值
            ,description -- 描述
            ,orderby -- 排序
            ,version_num -- 版本号
            ,is_del -- 是否已删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.sys_code, o.sys_code) as sys_code -- 系统编码
    ,nvl(n.sys_name, o.sys_name) as sys_name -- 系统名称
    ,nvl(n.team_code, o.team_code) as team_code -- 预留字段
    ,nvl(n.team_name, o.team_name) as team_name -- 预留字段
    ,nvl(n.dict_code, o.dict_code) as dict_code -- 字典编号
    ,nvl(n.dict_name, o.dict_name) as dict_name -- 编号名称
    ,nvl(n.data_val, o.data_val) as data_val -- 值
    ,nvl(n.data_trs_val, o.data_trs_val) as data_trs_val -- 英文值
    ,nvl(n.description, o.description) as description -- 描述
    ,nvl(n.orderby, o.orderby) as orderby -- 排序
    ,nvl(n.version_num, o.version_num) as version_num -- 版本号
    ,nvl(n.is_del, o.is_del) as is_del -- 是否已删除
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
from (select * from ${iol_schema}.bdms_bd_data_dictionary_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bd_data_dictionary where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.sys_code <> n.sys_code
        or o.sys_name <> n.sys_name
        or o.team_code <> n.team_code
        or o.team_name <> n.team_name
        or o.dict_code <> n.dict_code
        or o.dict_name <> n.dict_name
        or o.data_val <> n.data_val
        or o.data_trs_val <> n.data_trs_val
        or o.description <> n.description
        or o.orderby <> n.orderby
        or o.version_num <> n.version_num
        or o.is_del <> n.is_del
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bd_data_dictionary_cl(
            id -- 主键
            ,sys_code -- 系统编码
            ,sys_name -- 系统名称
            ,team_code -- 预留字段
            ,team_name -- 预留字段
            ,dict_code -- 字典编号
            ,dict_name -- 编号名称
            ,data_val -- 值
            ,data_trs_val -- 英文值
            ,description -- 描述
            ,orderby -- 排序
            ,version_num -- 版本号
            ,is_del -- 是否已删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bd_data_dictionary_op(
            id -- 主键
            ,sys_code -- 系统编码
            ,sys_name -- 系统名称
            ,team_code -- 预留字段
            ,team_name -- 预留字段
            ,dict_code -- 字典编号
            ,dict_name -- 编号名称
            ,data_val -- 值
            ,data_trs_val -- 英文值
            ,description -- 描述
            ,orderby -- 排序
            ,version_num -- 版本号
            ,is_del -- 是否已删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.sys_code -- 系统编码
    ,o.sys_name -- 系统名称
    ,o.team_code -- 预留字段
    ,o.team_name -- 预留字段
    ,o.dict_code -- 字典编号
    ,o.dict_name -- 编号名称
    ,o.data_val -- 值
    ,o.data_trs_val -- 英文值
    ,o.description -- 描述
    ,o.orderby -- 排序
    ,o.version_num -- 版本号
    ,o.is_del -- 是否已删除
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
from ${iol_schema}.bdms_bd_data_dictionary_bk o
    left join ${iol_schema}.bdms_bd_data_dictionary_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bd_data_dictionary_cl d
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
--truncate table ${iol_schema}.bdms_bd_data_dictionary;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bd_data_dictionary') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bd_data_dictionary drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bd_data_dictionary add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bd_data_dictionary exchange partition p_${batch_date} with table ${iol_schema}.bdms_bd_data_dictionary_cl;
alter table ${iol_schema}.bdms_bd_data_dictionary exchange partition p_20991231 with table ${iol_schema}.bdms_bd_data_dictionary_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bd_data_dictionary to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bd_data_dictionary_op purge;
drop table ${iol_schema}.bdms_bd_data_dictionary_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bd_data_dictionary_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bd_data_dictionary',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
