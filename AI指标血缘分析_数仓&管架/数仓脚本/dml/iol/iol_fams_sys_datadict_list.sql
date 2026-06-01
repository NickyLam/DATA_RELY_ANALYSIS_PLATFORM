/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_sys_datadict_list
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
create table ${iol_schema}.fams_sys_datadict_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_sys_datadict_list;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_sys_datadict_list_op purge;
drop table ${iol_schema}.fams_sys_datadict_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_sys_datadict_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_sys_datadict_list where 0=1;

create table ${iol_schema}.fams_sys_datadict_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_sys_datadict_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_sys_datadict_list_cl(
            dict_code -- 字典代码
            ,item_code -- 数据代码
            ,item_value -- 参数值
            ,order_no -- 排列顺序
            ,default_value -- 默认值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_sys_datadict_list_op(
            dict_code -- 字典代码
            ,item_code -- 数据代码
            ,item_value -- 参数值
            ,order_no -- 排列顺序
            ,default_value -- 默认值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dict_code, o.dict_code) as dict_code -- 字典代码
    ,nvl(n.item_code, o.item_code) as item_code -- 数据代码
    ,nvl(n.item_value, o.item_value) as item_value -- 参数值
    ,nvl(n.order_no, o.order_no) as order_no -- 排列顺序
    ,nvl(n.default_value, o.default_value) as default_value -- 默认值
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.dict_code is null
            and n.item_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.dict_code is null
            and n.item_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.dict_code is null
            and n.item_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_sys_datadict_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_sys_datadict_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.dict_code = n.dict_code
            and o.item_code = n.item_code
where (
        o.dict_code is null
        and o.item_code is null
    )
    or (
        n.dict_code is null
        and n.item_code is null
    )
    or (
        o.item_value <> n.item_value
        or o.order_no <> n.order_no
        or o.default_value <> n.default_value
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_sys_datadict_list_cl(
            dict_code -- 字典代码
            ,item_code -- 数据代码
            ,item_value -- 参数值
            ,order_no -- 排列顺序
            ,default_value -- 默认值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_sys_datadict_list_op(
            dict_code -- 字典代码
            ,item_code -- 数据代码
            ,item_value -- 参数值
            ,order_no -- 排列顺序
            ,default_value -- 默认值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dict_code -- 字典代码
    ,o.item_code -- 数据代码
    ,o.item_value -- 参数值
    ,o.order_no -- 排列顺序
    ,o.default_value -- 默认值
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_sys_datadict_list_bk o
    left join ${iol_schema}.fams_sys_datadict_list_op n
        on
            o.dict_code = n.dict_code
            and o.item_code = n.item_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_sys_datadict_list_cl d
        on
            o.dict_code = d.dict_code
            and o.item_code = d.item_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_sys_datadict_list;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_sys_datadict_list exchange partition p_19000101 with table ${iol_schema}.fams_sys_datadict_list_cl;
alter table ${iol_schema}.fams_sys_datadict_list exchange partition p_20991231 with table ${iol_schema}.fams_sys_datadict_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_sys_datadict_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_sys_datadict_list_op purge;
drop table ${iol_schema}.fams_sys_datadict_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_sys_datadict_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_sys_datadict_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
