/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_dcps_t_md_inst
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
create table ${iol_schema}.dcps_t_md_inst_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.dcps_t_md_inst
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.dcps_t_md_inst_op purge;
drop table ${iol_schema}.dcps_t_md_inst_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.dcps_t_md_inst_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.dcps_t_md_inst where 0=1;

create table ${iol_schema}.dcps_t_md_inst_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.dcps_t_md_inst where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.dcps_t_md_inst_cl(
            inst_id -- 实例ID
            ,inst_code -- 实例代码
            ,inst_name -- 实例名称
            ,class_id -- 类代码
            ,parent_id -- 父实例ID
            ,namespace_id -- 路径ID
            ,namespace_code -- 路径CODE
            ,ver_id -- 当前版本ID
            ,start_time -- 开始时间
            ,isroot -- 是否根节点
            ,app_type -- 元数据：MD数据标准：DS
            ,status -- 状态：01-已发布02-已废止
            ,page_view -- 用户访问量
            ,creater -- 创建者
            ,corp_id -- 多法人
            ,rsv_str_1 -- 字符1-保留字段
            ,rsv_str_2 -- 字符2-保留字段
            ,rsv_str_3 -- 字符3-保留字段
            ,rsv_str_4 -- 字符4-保留字段
            ,rsv_str_5 -- 字符5-保留字段
            ,rsv_str_6 -- 字符6-保留字段
            ,rsv_str_7 -- 字符7-保留字段
            ,rsv_str_8 -- 字符8-保留字段
            ,rsv_str_9 -- 字符9-保留字段
            ,rsv_str_10 -- 字符10-保留字段
            ,rsv_str_11 -- 字符11-保留字段
            ,rsv_str_12 -- 字符12-保留字段
            ,rsv_str_13 -- 字符13-保留字段
            ,rsv_str_14 -- 字符14-保留字段
            ,rsv_str_15 -- 字符15-保留字段
            ,rsv_str_16 -- 字符16-保留字段
            ,rsv_str_17 -- 字符17-保留字段
            ,rsv_str_18 -- 字符18-保留字段
            ,rsv_str_19 -- 字符19-保留字段
            ,rsv_str_20 -- 字符20-保留字段
            ,rsv_str_21 -- 字符21-保留字段
            ,rsv_str_22 -- 字符22-保留字段
            ,rsv_str_23 -- 字符23-保留字段
            ,rsv_str_24 -- 字符24-保留字段
            ,rsv_str_25 -- 字符25-保留字段
            ,rsv_str_26 -- 字符26-保留字段
            ,rsv_str_27 -- 字符27-保留字段
            ,rsv_str_28 -- 字符28-保留字段
            ,rsv_str_29 -- 字符29-保留字段
            ,rsv_str_30 -- 字符30-保留字段
            ,rsv_str_31 -- 字符31-保留字段
            ,rsv_str_32 -- 字符32-保留字段
            ,rsv_str_33 -- 字符33-保留字段
            ,rsv_str_34 -- 字符34-保留字段
            ,rsv_str_35 -- 字符35-保留字段
            ,rsv_str_36 -- 字符36-保留字段
            ,rsv_str_37 -- 字符37-保留字段
            ,rsv_str_38 -- 字符38-保留字段
            ,rsv_str_39 -- 字符39-保留字段
            ,rsv_str_40 -- 字符40-保留字段
            ,version_date -- 版本日期
            ,lucnec_falgdate -- 索引扫描日期
            ,db_name -- 
            ,db_code -- 
            ,sys_name -- 
            ,sys_code -- 
            ,sch_name -- 
            ,sch_code -- 
            ,tab_name -- 
            ,tab_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.dcps_t_md_inst_op(
            inst_id -- 实例ID
            ,inst_code -- 实例代码
            ,inst_name -- 实例名称
            ,class_id -- 类代码
            ,parent_id -- 父实例ID
            ,namespace_id -- 路径ID
            ,namespace_code -- 路径CODE
            ,ver_id -- 当前版本ID
            ,start_time -- 开始时间
            ,isroot -- 是否根节点
            ,app_type -- 元数据：MD数据标准：DS
            ,status -- 状态：01-已发布02-已废止
            ,page_view -- 用户访问量
            ,creater -- 创建者
            ,corp_id -- 多法人
            ,rsv_str_1 -- 字符1-保留字段
            ,rsv_str_2 -- 字符2-保留字段
            ,rsv_str_3 -- 字符3-保留字段
            ,rsv_str_4 -- 字符4-保留字段
            ,rsv_str_5 -- 字符5-保留字段
            ,rsv_str_6 -- 字符6-保留字段
            ,rsv_str_7 -- 字符7-保留字段
            ,rsv_str_8 -- 字符8-保留字段
            ,rsv_str_9 -- 字符9-保留字段
            ,rsv_str_10 -- 字符10-保留字段
            ,rsv_str_11 -- 字符11-保留字段
            ,rsv_str_12 -- 字符12-保留字段
            ,rsv_str_13 -- 字符13-保留字段
            ,rsv_str_14 -- 字符14-保留字段
            ,rsv_str_15 -- 字符15-保留字段
            ,rsv_str_16 -- 字符16-保留字段
            ,rsv_str_17 -- 字符17-保留字段
            ,rsv_str_18 -- 字符18-保留字段
            ,rsv_str_19 -- 字符19-保留字段
            ,rsv_str_20 -- 字符20-保留字段
            ,rsv_str_21 -- 字符21-保留字段
            ,rsv_str_22 -- 字符22-保留字段
            ,rsv_str_23 -- 字符23-保留字段
            ,rsv_str_24 -- 字符24-保留字段
            ,rsv_str_25 -- 字符25-保留字段
            ,rsv_str_26 -- 字符26-保留字段
            ,rsv_str_27 -- 字符27-保留字段
            ,rsv_str_28 -- 字符28-保留字段
            ,rsv_str_29 -- 字符29-保留字段
            ,rsv_str_30 -- 字符30-保留字段
            ,rsv_str_31 -- 字符31-保留字段
            ,rsv_str_32 -- 字符32-保留字段
            ,rsv_str_33 -- 字符33-保留字段
            ,rsv_str_34 -- 字符34-保留字段
            ,rsv_str_35 -- 字符35-保留字段
            ,rsv_str_36 -- 字符36-保留字段
            ,rsv_str_37 -- 字符37-保留字段
            ,rsv_str_38 -- 字符38-保留字段
            ,rsv_str_39 -- 字符39-保留字段
            ,rsv_str_40 -- 字符40-保留字段
            ,version_date -- 版本日期
            ,lucnec_falgdate -- 索引扫描日期
            ,db_name -- 
            ,db_code -- 
            ,sys_name -- 
            ,sys_code -- 
            ,sch_name -- 
            ,sch_code -- 
            ,tab_name -- 
            ,tab_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inst_id, o.inst_id) as inst_id -- 实例ID
    ,nvl(n.inst_code, o.inst_code) as inst_code -- 实例代码
    ,nvl(n.inst_name, o.inst_name) as inst_name -- 实例名称
    ,nvl(n.class_id, o.class_id) as class_id -- 类代码
    ,nvl(n.parent_id, o.parent_id) as parent_id -- 父实例ID
    ,nvl(n.namespace_id, o.namespace_id) as namespace_id -- 路径ID
    ,nvl(n.namespace_code, o.namespace_code) as namespace_code -- 路径CODE
    ,nvl(n.ver_id, o.ver_id) as ver_id -- 当前版本ID
    ,nvl(n.start_time, o.start_time) as start_time -- 开始时间
    ,nvl(n.isroot, o.isroot) as isroot -- 是否根节点
    ,nvl(n.app_type, o.app_type) as app_type -- 元数据：MD数据标准：DS
    ,nvl(n.status, o.status) as status -- 状态：01-已发布02-已废止
    ,nvl(n.page_view, o.page_view) as page_view -- 用户访问量
    ,nvl(n.creater, o.creater) as creater -- 创建者
    ,nvl(n.corp_id, o.corp_id) as corp_id -- 多法人
    ,nvl(n.rsv_str_1, o.rsv_str_1) as rsv_str_1 -- 字符1-保留字段
    ,nvl(n.rsv_str_2, o.rsv_str_2) as rsv_str_2 -- 字符2-保留字段
    ,nvl(n.rsv_str_3, o.rsv_str_3) as rsv_str_3 -- 字符3-保留字段
    ,nvl(n.rsv_str_4, o.rsv_str_4) as rsv_str_4 -- 字符4-保留字段
    ,nvl(n.rsv_str_5, o.rsv_str_5) as rsv_str_5 -- 字符5-保留字段
    ,nvl(n.rsv_str_6, o.rsv_str_6) as rsv_str_6 -- 字符6-保留字段
    ,nvl(n.rsv_str_7, o.rsv_str_7) as rsv_str_7 -- 字符7-保留字段
    ,nvl(n.rsv_str_8, o.rsv_str_8) as rsv_str_8 -- 字符8-保留字段
    ,nvl(n.rsv_str_9, o.rsv_str_9) as rsv_str_9 -- 字符9-保留字段
    ,nvl(n.rsv_str_10, o.rsv_str_10) as rsv_str_10 -- 字符10-保留字段
    ,nvl(n.rsv_str_11, o.rsv_str_11) as rsv_str_11 -- 字符11-保留字段
    ,nvl(n.rsv_str_12, o.rsv_str_12) as rsv_str_12 -- 字符12-保留字段
    ,nvl(n.rsv_str_13, o.rsv_str_13) as rsv_str_13 -- 字符13-保留字段
    ,nvl(n.rsv_str_14, o.rsv_str_14) as rsv_str_14 -- 字符14-保留字段
    ,nvl(n.rsv_str_15, o.rsv_str_15) as rsv_str_15 -- 字符15-保留字段
    ,nvl(n.rsv_str_16, o.rsv_str_16) as rsv_str_16 -- 字符16-保留字段
    ,nvl(n.rsv_str_17, o.rsv_str_17) as rsv_str_17 -- 字符17-保留字段
    ,nvl(n.rsv_str_18, o.rsv_str_18) as rsv_str_18 -- 字符18-保留字段
    ,nvl(n.rsv_str_19, o.rsv_str_19) as rsv_str_19 -- 字符19-保留字段
    ,nvl(n.rsv_str_20, o.rsv_str_20) as rsv_str_20 -- 字符20-保留字段
    ,nvl(n.rsv_str_21, o.rsv_str_21) as rsv_str_21 -- 字符21-保留字段
    ,nvl(n.rsv_str_22, o.rsv_str_22) as rsv_str_22 -- 字符22-保留字段
    ,nvl(n.rsv_str_23, o.rsv_str_23) as rsv_str_23 -- 字符23-保留字段
    ,nvl(n.rsv_str_24, o.rsv_str_24) as rsv_str_24 -- 字符24-保留字段
    ,nvl(n.rsv_str_25, o.rsv_str_25) as rsv_str_25 -- 字符25-保留字段
    ,nvl(n.rsv_str_26, o.rsv_str_26) as rsv_str_26 -- 字符26-保留字段
    ,nvl(n.rsv_str_27, o.rsv_str_27) as rsv_str_27 -- 字符27-保留字段
    ,nvl(n.rsv_str_28, o.rsv_str_28) as rsv_str_28 -- 字符28-保留字段
    ,nvl(n.rsv_str_29, o.rsv_str_29) as rsv_str_29 -- 字符29-保留字段
    ,nvl(n.rsv_str_30, o.rsv_str_30) as rsv_str_30 -- 字符30-保留字段
    ,nvl(n.rsv_str_31, o.rsv_str_31) as rsv_str_31 -- 字符31-保留字段
    ,nvl(n.rsv_str_32, o.rsv_str_32) as rsv_str_32 -- 字符32-保留字段
    ,nvl(n.rsv_str_33, o.rsv_str_33) as rsv_str_33 -- 字符33-保留字段
    ,nvl(n.rsv_str_34, o.rsv_str_34) as rsv_str_34 -- 字符34-保留字段
    ,nvl(n.rsv_str_35, o.rsv_str_35) as rsv_str_35 -- 字符35-保留字段
    ,nvl(n.rsv_str_36, o.rsv_str_36) as rsv_str_36 -- 字符36-保留字段
    ,nvl(n.rsv_str_37, o.rsv_str_37) as rsv_str_37 -- 字符37-保留字段
    ,nvl(n.rsv_str_38, o.rsv_str_38) as rsv_str_38 -- 字符38-保留字段
    ,nvl(n.rsv_str_39, o.rsv_str_39) as rsv_str_39 -- 字符39-保留字段
    ,nvl(n.rsv_str_40, o.rsv_str_40) as rsv_str_40 -- 字符40-保留字段
    ,nvl(n.version_date, o.version_date) as version_date -- 版本日期
    ,nvl(n.lucnec_falgdate, o.lucnec_falgdate) as lucnec_falgdate -- 索引扫描日期
    ,nvl(n.db_name, o.db_name) as db_name -- 
    ,nvl(n.db_code, o.db_code) as db_code -- 
    ,nvl(n.sys_name, o.sys_name) as sys_name -- 
    ,nvl(n.sys_code, o.sys_code) as sys_code -- 
    ,nvl(n.sch_name, o.sch_name) as sch_name -- 
    ,nvl(n.sch_code, o.sch_code) as sch_code -- 
    ,nvl(n.tab_name, o.tab_name) as tab_name -- 
    ,nvl(n.tab_code, o.tab_code) as tab_code -- 
    ,case when
            n.inst_id is null
            and n.app_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inst_id is null
            and n.app_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inst_id is null
            and n.app_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.dcps_t_md_inst_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.dcps_t_md_inst where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inst_id = n.inst_id
            and o.app_type = n.app_type
where (
        o.inst_id is null
        and o.app_type is null
    )
    or (
        n.inst_id is null
        and n.app_type is null
    )
    or (
        o.inst_code <> n.inst_code
        or o.inst_name <> n.inst_name
        or o.class_id <> n.class_id
        or o.parent_id <> n.parent_id
        or o.namespace_id <> n.namespace_id
        or o.namespace_code <> n.namespace_code
        or o.ver_id <> n.ver_id
        or o.start_time <> n.start_time
        or o.isroot <> n.isroot
        or o.status <> n.status
        or o.page_view <> n.page_view
        or o.creater <> n.creater
        or o.corp_id <> n.corp_id
        or o.rsv_str_1 <> n.rsv_str_1
        or o.rsv_str_2 <> n.rsv_str_2
        or o.rsv_str_3 <> n.rsv_str_3
        or o.rsv_str_4 <> n.rsv_str_4
        or o.rsv_str_5 <> n.rsv_str_5
        or o.rsv_str_6 <> n.rsv_str_6
        or o.rsv_str_7 <> n.rsv_str_7
        or o.rsv_str_8 <> n.rsv_str_8
        or o.rsv_str_9 <> n.rsv_str_9
        or o.rsv_str_10 <> n.rsv_str_10
        or o.rsv_str_11 <> n.rsv_str_11
        or o.rsv_str_12 <> n.rsv_str_12
        or o.rsv_str_13 <> n.rsv_str_13
        or o.rsv_str_14 <> n.rsv_str_14
        or o.rsv_str_15 <> n.rsv_str_15
        or o.rsv_str_16 <> n.rsv_str_16
        or o.rsv_str_17 <> n.rsv_str_17
        or o.rsv_str_18 <> n.rsv_str_18
        or o.rsv_str_19 <> n.rsv_str_19
        or o.rsv_str_20 <> n.rsv_str_20
        or o.rsv_str_21 <> n.rsv_str_21
        or o.rsv_str_22 <> n.rsv_str_22
        or o.rsv_str_23 <> n.rsv_str_23
        or o.rsv_str_24 <> n.rsv_str_24
        or o.rsv_str_25 <> n.rsv_str_25
        or o.rsv_str_26 <> n.rsv_str_26
        or o.rsv_str_27 <> n.rsv_str_27
        or o.rsv_str_28 <> n.rsv_str_28
        or o.rsv_str_29 <> n.rsv_str_29
        or o.rsv_str_30 <> n.rsv_str_30
        or o.rsv_str_31 <> n.rsv_str_31
        or o.rsv_str_32 <> n.rsv_str_32
        or o.rsv_str_33 <> n.rsv_str_33
        or o.rsv_str_34 <> n.rsv_str_34
        or o.rsv_str_35 <> n.rsv_str_35
        or o.rsv_str_36 <> n.rsv_str_36
        or o.rsv_str_37 <> n.rsv_str_37
        or o.rsv_str_38 <> n.rsv_str_38
        or o.rsv_str_39 <> n.rsv_str_39
        or o.rsv_str_40 <> n.rsv_str_40
        or o.version_date <> n.version_date
        or o.lucnec_falgdate <> n.lucnec_falgdate
        or o.db_name <> n.db_name
        or o.db_code <> n.db_code
        or o.sys_name <> n.sys_name
        or o.sys_code <> n.sys_code
        or o.sch_name <> n.sch_name
        or o.sch_code <> n.sch_code
        or o.tab_name <> n.tab_name
        or o.tab_code <> n.tab_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.dcps_t_md_inst_cl(
            inst_id -- 实例ID
            ,inst_code -- 实例代码
            ,inst_name -- 实例名称
            ,class_id -- 类代码
            ,parent_id -- 父实例ID
            ,namespace_id -- 路径ID
            ,namespace_code -- 路径CODE
            ,ver_id -- 当前版本ID
            ,start_time -- 开始时间
            ,isroot -- 是否根节点
            ,app_type -- 元数据：MD数据标准：DS
            ,status -- 状态：01-已发布02-已废止
            ,page_view -- 用户访问量
            ,creater -- 创建者
            ,corp_id -- 多法人
            ,rsv_str_1 -- 字符1-保留字段
            ,rsv_str_2 -- 字符2-保留字段
            ,rsv_str_3 -- 字符3-保留字段
            ,rsv_str_4 -- 字符4-保留字段
            ,rsv_str_5 -- 字符5-保留字段
            ,rsv_str_6 -- 字符6-保留字段
            ,rsv_str_7 -- 字符7-保留字段
            ,rsv_str_8 -- 字符8-保留字段
            ,rsv_str_9 -- 字符9-保留字段
            ,rsv_str_10 -- 字符10-保留字段
            ,rsv_str_11 -- 字符11-保留字段
            ,rsv_str_12 -- 字符12-保留字段
            ,rsv_str_13 -- 字符13-保留字段
            ,rsv_str_14 -- 字符14-保留字段
            ,rsv_str_15 -- 字符15-保留字段
            ,rsv_str_16 -- 字符16-保留字段
            ,rsv_str_17 -- 字符17-保留字段
            ,rsv_str_18 -- 字符18-保留字段
            ,rsv_str_19 -- 字符19-保留字段
            ,rsv_str_20 -- 字符20-保留字段
            ,rsv_str_21 -- 字符21-保留字段
            ,rsv_str_22 -- 字符22-保留字段
            ,rsv_str_23 -- 字符23-保留字段
            ,rsv_str_24 -- 字符24-保留字段
            ,rsv_str_25 -- 字符25-保留字段
            ,rsv_str_26 -- 字符26-保留字段
            ,rsv_str_27 -- 字符27-保留字段
            ,rsv_str_28 -- 字符28-保留字段
            ,rsv_str_29 -- 字符29-保留字段
            ,rsv_str_30 -- 字符30-保留字段
            ,rsv_str_31 -- 字符31-保留字段
            ,rsv_str_32 -- 字符32-保留字段
            ,rsv_str_33 -- 字符33-保留字段
            ,rsv_str_34 -- 字符34-保留字段
            ,rsv_str_35 -- 字符35-保留字段
            ,rsv_str_36 -- 字符36-保留字段
            ,rsv_str_37 -- 字符37-保留字段
            ,rsv_str_38 -- 字符38-保留字段
            ,rsv_str_39 -- 字符39-保留字段
            ,rsv_str_40 -- 字符40-保留字段
            ,version_date -- 版本日期
            ,lucnec_falgdate -- 索引扫描日期
            ,db_name -- 
            ,db_code -- 
            ,sys_name -- 
            ,sys_code -- 
            ,sch_name -- 
            ,sch_code -- 
            ,tab_name -- 
            ,tab_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.dcps_t_md_inst_op(
            inst_id -- 实例ID
            ,inst_code -- 实例代码
            ,inst_name -- 实例名称
            ,class_id -- 类代码
            ,parent_id -- 父实例ID
            ,namespace_id -- 路径ID
            ,namespace_code -- 路径CODE
            ,ver_id -- 当前版本ID
            ,start_time -- 开始时间
            ,isroot -- 是否根节点
            ,app_type -- 元数据：MD数据标准：DS
            ,status -- 状态：01-已发布02-已废止
            ,page_view -- 用户访问量
            ,creater -- 创建者
            ,corp_id -- 多法人
            ,rsv_str_1 -- 字符1-保留字段
            ,rsv_str_2 -- 字符2-保留字段
            ,rsv_str_3 -- 字符3-保留字段
            ,rsv_str_4 -- 字符4-保留字段
            ,rsv_str_5 -- 字符5-保留字段
            ,rsv_str_6 -- 字符6-保留字段
            ,rsv_str_7 -- 字符7-保留字段
            ,rsv_str_8 -- 字符8-保留字段
            ,rsv_str_9 -- 字符9-保留字段
            ,rsv_str_10 -- 字符10-保留字段
            ,rsv_str_11 -- 字符11-保留字段
            ,rsv_str_12 -- 字符12-保留字段
            ,rsv_str_13 -- 字符13-保留字段
            ,rsv_str_14 -- 字符14-保留字段
            ,rsv_str_15 -- 字符15-保留字段
            ,rsv_str_16 -- 字符16-保留字段
            ,rsv_str_17 -- 字符17-保留字段
            ,rsv_str_18 -- 字符18-保留字段
            ,rsv_str_19 -- 字符19-保留字段
            ,rsv_str_20 -- 字符20-保留字段
            ,rsv_str_21 -- 字符21-保留字段
            ,rsv_str_22 -- 字符22-保留字段
            ,rsv_str_23 -- 字符23-保留字段
            ,rsv_str_24 -- 字符24-保留字段
            ,rsv_str_25 -- 字符25-保留字段
            ,rsv_str_26 -- 字符26-保留字段
            ,rsv_str_27 -- 字符27-保留字段
            ,rsv_str_28 -- 字符28-保留字段
            ,rsv_str_29 -- 字符29-保留字段
            ,rsv_str_30 -- 字符30-保留字段
            ,rsv_str_31 -- 字符31-保留字段
            ,rsv_str_32 -- 字符32-保留字段
            ,rsv_str_33 -- 字符33-保留字段
            ,rsv_str_34 -- 字符34-保留字段
            ,rsv_str_35 -- 字符35-保留字段
            ,rsv_str_36 -- 字符36-保留字段
            ,rsv_str_37 -- 字符37-保留字段
            ,rsv_str_38 -- 字符38-保留字段
            ,rsv_str_39 -- 字符39-保留字段
            ,rsv_str_40 -- 字符40-保留字段
            ,version_date -- 版本日期
            ,lucnec_falgdate -- 索引扫描日期
            ,db_name -- 
            ,db_code -- 
            ,sys_name -- 
            ,sys_code -- 
            ,sch_name -- 
            ,sch_code -- 
            ,tab_name -- 
            ,tab_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inst_id -- 实例ID
    ,o.inst_code -- 实例代码
    ,o.inst_name -- 实例名称
    ,o.class_id -- 类代码
    ,o.parent_id -- 父实例ID
    ,o.namespace_id -- 路径ID
    ,o.namespace_code -- 路径CODE
    ,o.ver_id -- 当前版本ID
    ,o.start_time -- 开始时间
    ,o.isroot -- 是否根节点
    ,o.app_type -- 元数据：MD数据标准：DS
    ,o.status -- 状态：01-已发布02-已废止
    ,o.page_view -- 用户访问量
    ,o.creater -- 创建者
    ,o.corp_id -- 多法人
    ,o.rsv_str_1 -- 字符1-保留字段
    ,o.rsv_str_2 -- 字符2-保留字段
    ,o.rsv_str_3 -- 字符3-保留字段
    ,o.rsv_str_4 -- 字符4-保留字段
    ,o.rsv_str_5 -- 字符5-保留字段
    ,o.rsv_str_6 -- 字符6-保留字段
    ,o.rsv_str_7 -- 字符7-保留字段
    ,o.rsv_str_8 -- 字符8-保留字段
    ,o.rsv_str_9 -- 字符9-保留字段
    ,o.rsv_str_10 -- 字符10-保留字段
    ,o.rsv_str_11 -- 字符11-保留字段
    ,o.rsv_str_12 -- 字符12-保留字段
    ,o.rsv_str_13 -- 字符13-保留字段
    ,o.rsv_str_14 -- 字符14-保留字段
    ,o.rsv_str_15 -- 字符15-保留字段
    ,o.rsv_str_16 -- 字符16-保留字段
    ,o.rsv_str_17 -- 字符17-保留字段
    ,o.rsv_str_18 -- 字符18-保留字段
    ,o.rsv_str_19 -- 字符19-保留字段
    ,o.rsv_str_20 -- 字符20-保留字段
    ,o.rsv_str_21 -- 字符21-保留字段
    ,o.rsv_str_22 -- 字符22-保留字段
    ,o.rsv_str_23 -- 字符23-保留字段
    ,o.rsv_str_24 -- 字符24-保留字段
    ,o.rsv_str_25 -- 字符25-保留字段
    ,o.rsv_str_26 -- 字符26-保留字段
    ,o.rsv_str_27 -- 字符27-保留字段
    ,o.rsv_str_28 -- 字符28-保留字段
    ,o.rsv_str_29 -- 字符29-保留字段
    ,o.rsv_str_30 -- 字符30-保留字段
    ,o.rsv_str_31 -- 字符31-保留字段
    ,o.rsv_str_32 -- 字符32-保留字段
    ,o.rsv_str_33 -- 字符33-保留字段
    ,o.rsv_str_34 -- 字符34-保留字段
    ,o.rsv_str_35 -- 字符35-保留字段
    ,o.rsv_str_36 -- 字符36-保留字段
    ,o.rsv_str_37 -- 字符37-保留字段
    ,o.rsv_str_38 -- 字符38-保留字段
    ,o.rsv_str_39 -- 字符39-保留字段
    ,o.rsv_str_40 -- 字符40-保留字段
    ,o.version_date -- 版本日期
    ,o.lucnec_falgdate -- 索引扫描日期
    ,o.db_name -- 
    ,o.db_code -- 
    ,o.sys_name -- 
    ,o.sys_code -- 
    ,o.sch_name -- 
    ,o.sch_code -- 
    ,o.tab_name -- 
    ,o.tab_code -- 
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
from ${iol_schema}.dcps_t_md_inst_bk o
    left join ${iol_schema}.dcps_t_md_inst_op n
        on
            o.inst_id = n.inst_id
            and o.app_type = n.app_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.dcps_t_md_inst_cl d
        on
            o.inst_id = d.inst_id
            and o.app_type = d.app_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.dcps_t_md_inst;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('dcps_t_md_inst') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.dcps_t_md_inst drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.dcps_t_md_inst add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.dcps_t_md_inst exchange partition p_${batch_date} with table ${iol_schema}.dcps_t_md_inst_cl;
alter table ${iol_schema}.dcps_t_md_inst exchange partition p_20991231 with table ${iol_schema}.dcps_t_md_inst_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.dcps_t_md_inst to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.dcps_t_md_inst_op purge;
drop table ${iol_schema}.dcps_t_md_inst_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.dcps_t_md_inst_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'dcps_t_md_inst',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
