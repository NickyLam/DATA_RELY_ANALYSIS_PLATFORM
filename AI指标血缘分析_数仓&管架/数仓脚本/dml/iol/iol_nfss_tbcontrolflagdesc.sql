/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbcontrolflagdesc
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
create table ${iol_schema}.nfss_tbcontrolflagdesc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbcontrolflagdesc;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbcontrolflagdesc_op purge;
drop table ${iol_schema}.nfss_tbcontrolflagdesc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbcontrolflagdesc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbcontrolflagdesc where 0=1;

create table ${iol_schema}.nfss_tbcontrolflagdesc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbcontrolflagdesc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbcontrolflagdesc_cl(
            table_name -- 表名称
            ,field_name -- 字段名称
            ,position -- 位置（第几位）
            ,table_label -- 显示名称
            ,default_value -- 默认值
            ,option_visible -- 是否显示
            ,input_type -- 控件类型
            ,table_index -- 顺序号
            ,table_value -- 值
            ,prompt -- 提示信息
            ,remark1 -- 备用1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbcontrolflagdesc_op(
            table_name -- 表名称
            ,field_name -- 字段名称
            ,position -- 位置（第几位）
            ,table_label -- 显示名称
            ,default_value -- 默认值
            ,option_visible -- 是否显示
            ,input_type -- 控件类型
            ,table_index -- 顺序号
            ,table_value -- 值
            ,prompt -- 提示信息
            ,remark1 -- 备用1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.table_name, o.table_name) as table_name -- 表名称
    ,nvl(n.field_name, o.field_name) as field_name -- 字段名称
    ,nvl(n.position, o.position) as position -- 位置（第几位）
    ,nvl(n.table_label, o.table_label) as table_label -- 显示名称
    ,nvl(n.default_value, o.default_value) as default_value -- 默认值
    ,nvl(n.option_visible, o.option_visible) as option_visible -- 是否显示
    ,nvl(n.input_type, o.input_type) as input_type -- 控件类型
    ,nvl(n.table_index, o.table_index) as table_index -- 顺序号
    ,nvl(n.table_value, o.table_value) as table_value -- 值
    ,nvl(n.prompt, o.prompt) as prompt -- 提示信息
    ,nvl(n.remark1, o.remark1) as remark1 -- 备用1
    ,case when
            n.table_name is null
            and n.field_name is null
            and n.position is null
            and n.table_index is null
            and n.remark1 is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.table_name is null
            and n.field_name is null
            and n.position is null
            and n.table_index is null
            and n.remark1 is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.table_name is null
            and n.field_name is null
            and n.position is null
            and n.table_index is null
            and n.remark1 is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbcontrolflagdesc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbcontrolflagdesc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.table_name = n.table_name
            and o.field_name = n.field_name
            and o.position = n.position
            and o.table_index = n.table_index
            and o.remark1 = n.remark1
where (
        o.table_name is null
        and o.field_name is null
        and o.position is null
        and o.table_index is null
        and o.remark1 is null
    )
    or (
        n.table_name is null
        and n.field_name is null
        and n.position is null
        and n.table_index is null
        and n.remark1 is null
    )
    or (
        o.table_label <> n.table_label
        or o.default_value <> n.default_value
        or o.option_visible <> n.option_visible
        or o.input_type <> n.input_type
        or o.table_value <> n.table_value
        or o.prompt <> n.prompt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbcontrolflagdesc_cl(
            table_name -- 表名称
            ,field_name -- 字段名称
            ,position -- 位置（第几位）
            ,table_label -- 显示名称
            ,default_value -- 默认值
            ,option_visible -- 是否显示
            ,input_type -- 控件类型
            ,table_index -- 顺序号
            ,table_value -- 值
            ,prompt -- 提示信息
            ,remark1 -- 备用1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbcontrolflagdesc_op(
            table_name -- 表名称
            ,field_name -- 字段名称
            ,position -- 位置（第几位）
            ,table_label -- 显示名称
            ,default_value -- 默认值
            ,option_visible -- 是否显示
            ,input_type -- 控件类型
            ,table_index -- 顺序号
            ,table_value -- 值
            ,prompt -- 提示信息
            ,remark1 -- 备用1
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.table_name -- 表名称
    ,o.field_name -- 字段名称
    ,o.position -- 位置（第几位）
    ,o.table_label -- 显示名称
    ,o.default_value -- 默认值
    ,o.option_visible -- 是否显示
    ,o.input_type -- 控件类型
    ,o.table_index -- 顺序号
    ,o.table_value -- 值
    ,o.prompt -- 提示信息
    ,o.remark1 -- 备用1
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbcontrolflagdesc_bk o
    left join ${iol_schema}.nfss_tbcontrolflagdesc_op n
        on
            o.table_name = n.table_name
            and o.field_name = n.field_name
            and o.position = n.position
            and o.table_index = n.table_index
            and o.remark1 = n.remark1
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbcontrolflagdesc_cl d
        on
            o.table_name = d.table_name
            and o.field_name = d.field_name
            and o.position = d.position
            and o.table_index = d.table_index
            and o.remark1 = d.remark1
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tbcontrolflagdesc;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbcontrolflagdesc exchange partition p_19000101 with table ${iol_schema}.nfss_tbcontrolflagdesc_cl;
alter table ${iol_schema}.nfss_tbcontrolflagdesc exchange partition p_20991231 with table ${iol_schema}.nfss_tbcontrolflagdesc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbcontrolflagdesc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbcontrolflagdesc_op purge;
drop table ${iol_schema}.nfss_tbcontrolflagdesc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbcontrolflagdesc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbcontrolflagdesc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
