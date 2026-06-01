/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alms_rp_dim_rep_line_liquidity
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
create table ${iol_schema}.alms_rp_dim_rep_line_liquidity_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.alms_rp_dim_rep_line_liquidity
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alms_rp_dim_rep_line_liquidity_op purge;
drop table ${iol_schema}.alms_rp_dim_rep_line_liquidity_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alms_rp_dim_rep_line_liquidity_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alms_rp_dim_rep_line_liquidity where 0=1;

create table ${iol_schema}.alms_rp_dim_rep_line_liquidity_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alms_rp_dim_rep_line_liquidity where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.alms_rp_dim_rep_line_liquidity_cl(
            v_rep_cd -- 报表ID
            ,v_rep_line_order -- 序号
            ,n_rep_line_cd -- 报表条目编号
            ,v_rep_line_name -- 报表条目名称(即指标名称)
            ,v_rep_line_display_order -- 报表条目展示顺序号
            ,n_bold_ind -- 粗体展示标识:0：正常；1：粗体
            ,n_indent_level -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
            ,v_regulatory_level -- 监控级别
            ,v_index_class -- 指标分类
            ,v_supervision_require -- 监管要求
            ,v_limit_value -- 限额值
            ,v_prewarning_value -- 预警值
            ,v_index_type -- 指标类型
            ,v_statistical_frequency -- 统计频率
            ,v_monitor_frequency -- 监测频率
            ,v_read_lvl -- 审阅层级
            ,v_department_type -- 指标部门
            ,d_created_dt -- 创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.alms_rp_dim_rep_line_liquidity_op(
            v_rep_cd -- 报表ID
            ,v_rep_line_order -- 序号
            ,n_rep_line_cd -- 报表条目编号
            ,v_rep_line_name -- 报表条目名称(即指标名称)
            ,v_rep_line_display_order -- 报表条目展示顺序号
            ,n_bold_ind -- 粗体展示标识:0：正常；1：粗体
            ,n_indent_level -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
            ,v_regulatory_level -- 监控级别
            ,v_index_class -- 指标分类
            ,v_supervision_require -- 监管要求
            ,v_limit_value -- 限额值
            ,v_prewarning_value -- 预警值
            ,v_index_type -- 指标类型
            ,v_statistical_frequency -- 统计频率
            ,v_monitor_frequency -- 监测频率
            ,v_read_lvl -- 审阅层级
            ,v_department_type -- 指标部门
            ,d_created_dt -- 创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.v_rep_cd, o.v_rep_cd) as v_rep_cd -- 报表ID
    ,nvl(n.v_rep_line_order, o.v_rep_line_order) as v_rep_line_order -- 序号
    ,nvl(n.n_rep_line_cd, o.n_rep_line_cd) as n_rep_line_cd -- 报表条目编号
    ,nvl(n.v_rep_line_name, o.v_rep_line_name) as v_rep_line_name -- 报表条目名称(即指标名称)
    ,nvl(n.v_rep_line_display_order, o.v_rep_line_display_order) as v_rep_line_display_order -- 报表条目展示顺序号
    ,nvl(n.n_bold_ind, o.n_bold_ind) as n_bold_ind -- 粗体展示标识:0：正常；1：粗体
    ,nvl(n.n_indent_level, o.n_indent_level) as n_indent_level -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
    ,nvl(n.v_regulatory_level, o.v_regulatory_level) as v_regulatory_level -- 监控级别
    ,nvl(n.v_index_class, o.v_index_class) as v_index_class -- 指标分类
    ,nvl(n.v_supervision_require, o.v_supervision_require) as v_supervision_require -- 监管要求
    ,nvl(n.v_limit_value, o.v_limit_value) as v_limit_value -- 限额值
    ,nvl(n.v_prewarning_value, o.v_prewarning_value) as v_prewarning_value -- 预警值
    ,nvl(n.v_index_type, o.v_index_type) as v_index_type -- 指标类型
    ,nvl(n.v_statistical_frequency, o.v_statistical_frequency) as v_statistical_frequency -- 统计频率
    ,nvl(n.v_monitor_frequency, o.v_monitor_frequency) as v_monitor_frequency -- 监测频率
    ,nvl(n.v_read_lvl, o.v_read_lvl) as v_read_lvl -- 审阅层级
    ,nvl(n.v_department_type, o.v_department_type) as v_department_type -- 指标部门
    ,nvl(n.d_created_dt, o.d_created_dt) as d_created_dt -- 创建日期
    ,case when
            n.v_rep_cd is null
            and n.n_rep_line_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.v_rep_cd is null
            and n.n_rep_line_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.v_rep_cd is null
            and n.n_rep_line_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.alms_rp_dim_rep_line_liquidity_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.alms_rp_dim_rep_line_liquidity where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.v_rep_cd = n.v_rep_cd
            and o.n_rep_line_cd = n.n_rep_line_cd
where (
        o.v_rep_cd is null
        and o.n_rep_line_cd is null
    )
    or (
        n.v_rep_cd is null
        and n.n_rep_line_cd is null
    )
    or (
        o.v_rep_line_order <> n.v_rep_line_order
        or o.v_rep_line_name <> n.v_rep_line_name
        or o.v_rep_line_display_order <> n.v_rep_line_display_order
        or o.n_bold_ind <> n.n_bold_ind
        or o.n_indent_level <> n.n_indent_level
        or o.v_regulatory_level <> n.v_regulatory_level
        or o.v_index_class <> n.v_index_class
        or o.v_supervision_require <> n.v_supervision_require
        or o.v_limit_value <> n.v_limit_value
        or o.v_prewarning_value <> n.v_prewarning_value
        or o.v_index_type <> n.v_index_type
        or o.v_statistical_frequency <> n.v_statistical_frequency
        or o.v_monitor_frequency <> n.v_monitor_frequency
        or o.v_read_lvl <> n.v_read_lvl
        or o.v_department_type <> n.v_department_type
        or o.d_created_dt <> n.d_created_dt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.alms_rp_dim_rep_line_liquidity_cl(
            v_rep_cd -- 报表ID
            ,v_rep_line_order -- 序号
            ,n_rep_line_cd -- 报表条目编号
            ,v_rep_line_name -- 报表条目名称(即指标名称)
            ,v_rep_line_display_order -- 报表条目展示顺序号
            ,n_bold_ind -- 粗体展示标识:0：正常；1：粗体
            ,n_indent_level -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
            ,v_regulatory_level -- 监控级别
            ,v_index_class -- 指标分类
            ,v_supervision_require -- 监管要求
            ,v_limit_value -- 限额值
            ,v_prewarning_value -- 预警值
            ,v_index_type -- 指标类型
            ,v_statistical_frequency -- 统计频率
            ,v_monitor_frequency -- 监测频率
            ,v_read_lvl -- 审阅层级
            ,v_department_type -- 指标部门
            ,d_created_dt -- 创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.alms_rp_dim_rep_line_liquidity_op(
            v_rep_cd -- 报表ID
            ,v_rep_line_order -- 序号
            ,n_rep_line_cd -- 报表条目编号
            ,v_rep_line_name -- 报表条目名称(即指标名称)
            ,v_rep_line_display_order -- 报表条目展示顺序号
            ,n_bold_ind -- 粗体展示标识:0：正常；1：粗体
            ,n_indent_level -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
            ,v_regulatory_level -- 监控级别
            ,v_index_class -- 指标分类
            ,v_supervision_require -- 监管要求
            ,v_limit_value -- 限额值
            ,v_prewarning_value -- 预警值
            ,v_index_type -- 指标类型
            ,v_statistical_frequency -- 统计频率
            ,v_monitor_frequency -- 监测频率
            ,v_read_lvl -- 审阅层级
            ,v_department_type -- 指标部门
            ,d_created_dt -- 创建日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.v_rep_cd -- 报表ID
    ,o.v_rep_line_order -- 序号
    ,o.n_rep_line_cd -- 报表条目编号
    ,o.v_rep_line_name -- 报表条目名称(即指标名称)
    ,o.v_rep_line_display_order -- 报表条目展示顺序号
    ,o.n_bold_ind -- 粗体展示标识:0：正常；1：粗体
    ,o.n_indent_level -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
    ,o.v_regulatory_level -- 监控级别
    ,o.v_index_class -- 指标分类
    ,o.v_supervision_require -- 监管要求
    ,o.v_limit_value -- 限额值
    ,o.v_prewarning_value -- 预警值
    ,o.v_index_type -- 指标类型
    ,o.v_statistical_frequency -- 统计频率
    ,o.v_monitor_frequency -- 监测频率
    ,o.v_read_lvl -- 审阅层级
    ,o.v_department_type -- 指标部门
    ,o.d_created_dt -- 创建日期
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
from ${iol_schema}.alms_rp_dim_rep_line_liquidity_bk o
    left join ${iol_schema}.alms_rp_dim_rep_line_liquidity_op n
        on
            o.v_rep_cd = n.v_rep_cd
            and o.n_rep_line_cd = n.n_rep_line_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.alms_rp_dim_rep_line_liquidity_cl d
        on
            o.v_rep_cd = d.v_rep_cd
            and o.n_rep_line_cd = d.n_rep_line_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.alms_rp_dim_rep_line_liquidity;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('alms_rp_dim_rep_line_liquidity') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.alms_rp_dim_rep_line_liquidity drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.alms_rp_dim_rep_line_liquidity add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.alms_rp_dim_rep_line_liquidity exchange partition p_${batch_date} with table ${iol_schema}.alms_rp_dim_rep_line_liquidity_cl;
alter table ${iol_schema}.alms_rp_dim_rep_line_liquidity exchange partition p_20991231 with table ${iol_schema}.alms_rp_dim_rep_line_liquidity_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alms_rp_dim_rep_line_liquidity to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alms_rp_dim_rep_line_liquidity_op purge;
drop table ${iol_schema}.alms_rp_dim_rep_line_liquidity_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.alms_rp_dim_rep_line_liquidity_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alms_rp_dim_rep_line_liquidity',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
