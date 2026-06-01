/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alms_rp_alm_rrs_b01_report_result
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
create table ${iol_schema}.alms_rp_alm_rrs_b01_report_result_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.alms_rp_alm_rrs_b01_report_result
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alms_rp_alm_rrs_b01_report_result_op purge;
drop table ${iol_schema}.alms_rp_alm_rrs_b01_report_result_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alms_rp_alm_rrs_b01_report_result_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alms_rp_alm_rrs_b01_report_result where 0=1;

create table ${iol_schema}.alms_rp_alm_rrs_b01_report_result_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alms_rp_alm_rrs_b01_report_result where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.alms_rp_alm_rrs_b01_report_result_cl(
            as_of_date -- 数据日期
            ,n_as_of_date_skey -- 报表键值
            ,n_run_skey -- 运行键值
            ,n_entity_skey -- 法人键值
            ,n_business_unit_skey -- 业务条线编码
            ,n_org_unit_skey -- 一级分行代码(即 填报 机构 号 )
            ,n_forecast_point_skey -- 时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点
            ,n_report_scenario_skey -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
            ,n_rep_line_cd -- 报表项编码
            ,v_currency_type -- 币种 1:人民币;2:外币折人民币;3:本外币合计
            ,n_rep_line_value -- 金额
            ,d_created_dt -- 创建日期
            ,n_previous_day_variation -- 较上日变动
            ,n_previous_month_variation -- 较上月变动
            ,n_previous_year_variation -- 较上年变动
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.alms_rp_alm_rrs_b01_report_result_op(
            as_of_date -- 数据日期
            ,n_as_of_date_skey -- 报表键值
            ,n_run_skey -- 运行键值
            ,n_entity_skey -- 法人键值
            ,n_business_unit_skey -- 业务条线编码
            ,n_org_unit_skey -- 一级分行代码(即 填报 机构 号 )
            ,n_forecast_point_skey -- 时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点
            ,n_report_scenario_skey -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
            ,n_rep_line_cd -- 报表项编码
            ,v_currency_type -- 币种 1:人民币;2:外币折人民币;3:本外币合计
            ,n_rep_line_value -- 金额
            ,d_created_dt -- 创建日期
            ,n_previous_day_variation -- 较上日变动
            ,n_previous_month_variation -- 较上月变动
            ,n_previous_year_variation -- 较上年变动
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.as_of_date, o.as_of_date) as as_of_date -- 数据日期
    ,nvl(n.n_as_of_date_skey, o.n_as_of_date_skey) as n_as_of_date_skey -- 报表键值
    ,nvl(n.n_run_skey, o.n_run_skey) as n_run_skey -- 运行键值
    ,nvl(n.n_entity_skey, o.n_entity_skey) as n_entity_skey -- 法人键值
    ,nvl(n.n_business_unit_skey, o.n_business_unit_skey) as n_business_unit_skey -- 业务条线编码
    ,nvl(n.n_org_unit_skey, o.n_org_unit_skey) as n_org_unit_skey -- 一级分行代码(即 填报 机构 号 )
    ,nvl(n.n_forecast_point_skey, o.n_forecast_point_skey) as n_forecast_point_skey -- 时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点
    ,nvl(n.n_report_scenario_skey, o.n_report_scenario_skey) as n_report_scenario_skey -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
    ,nvl(n.n_rep_line_cd, o.n_rep_line_cd) as n_rep_line_cd -- 报表项编码
    ,nvl(n.v_currency_type, o.v_currency_type) as v_currency_type -- 币种 1:人民币;2:外币折人民币;3:本外币合计
    ,nvl(n.n_rep_line_value, o.n_rep_line_value) as n_rep_line_value -- 金额
    ,nvl(n.d_created_dt, o.d_created_dt) as d_created_dt -- 创建日期
    ,nvl(n.n_previous_day_variation, o.n_previous_day_variation) as n_previous_day_variation -- 较上日变动
    ,nvl(n.n_previous_month_variation, o.n_previous_month_variation) as n_previous_month_variation -- 较上月变动
    ,nvl(n.n_previous_year_variation, o.n_previous_year_variation) as n_previous_year_variation -- 较上年变动
    ,case when
            n.as_of_date is null
            and n.n_business_unit_skey is null
            and n.n_rep_line_cd is null
            and n.v_currency_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.as_of_date is null
            and n.n_business_unit_skey is null
            and n.n_rep_line_cd is null
            and n.v_currency_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.as_of_date is null
            and n.n_business_unit_skey is null
            and n.n_rep_line_cd is null
            and n.v_currency_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.alms_rp_alm_rrs_b01_report_result_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.alms_rp_alm_rrs_b01_report_result where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.as_of_date = n.as_of_date
            and o.n_business_unit_skey = n.n_business_unit_skey
            and o.n_rep_line_cd = n.n_rep_line_cd
            and o.v_currency_type = n.v_currency_type
where (
        o.as_of_date is null
        and o.n_business_unit_skey is null
        and o.n_rep_line_cd is null
        and o.v_currency_type is null
    )
    or (
        n.as_of_date is null
        and n.n_business_unit_skey is null
        and n.n_rep_line_cd is null
        and n.v_currency_type is null
    )
    or (
        o.n_as_of_date_skey <> n.n_as_of_date_skey
        or o.n_run_skey <> n.n_run_skey
        or o.n_entity_skey <> n.n_entity_skey
        or o.n_org_unit_skey <> n.n_org_unit_skey
        or o.n_forecast_point_skey <> n.n_forecast_point_skey
        or o.n_report_scenario_skey <> n.n_report_scenario_skey
        or o.n_rep_line_value <> n.n_rep_line_value
        or o.d_created_dt <> n.d_created_dt
        or o.n_previous_day_variation <> n.n_previous_day_variation
        or o.n_previous_month_variation <> n.n_previous_month_variation
        or o.n_previous_year_variation <> n.n_previous_year_variation
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.alms_rp_alm_rrs_b01_report_result_cl(
            as_of_date -- 数据日期
            ,n_as_of_date_skey -- 报表键值
            ,n_run_skey -- 运行键值
            ,n_entity_skey -- 法人键值
            ,n_business_unit_skey -- 业务条线编码
            ,n_org_unit_skey -- 一级分行代码(即 填报 机构 号 )
            ,n_forecast_point_skey -- 时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点
            ,n_report_scenario_skey -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
            ,n_rep_line_cd -- 报表项编码
            ,v_currency_type -- 币种 1:人民币;2:外币折人民币;3:本外币合计
            ,n_rep_line_value -- 金额
            ,d_created_dt -- 创建日期
            ,n_previous_day_variation -- 较上日变动
            ,n_previous_month_variation -- 较上月变动
            ,n_previous_year_variation -- 较上年变动
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.alms_rp_alm_rrs_b01_report_result_op(
            as_of_date -- 数据日期
            ,n_as_of_date_skey -- 报表键值
            ,n_run_skey -- 运行键值
            ,n_entity_skey -- 法人键值
            ,n_business_unit_skey -- 业务条线编码
            ,n_org_unit_skey -- 一级分行代码(即 填报 机构 号 )
            ,n_forecast_point_skey -- 时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点
            ,n_report_scenario_skey -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
            ,n_rep_line_cd -- 报表项编码
            ,v_currency_type -- 币种 1:人民币;2:外币折人民币;3:本外币合计
            ,n_rep_line_value -- 金额
            ,d_created_dt -- 创建日期
            ,n_previous_day_variation -- 较上日变动
            ,n_previous_month_variation -- 较上月变动
            ,n_previous_year_variation -- 较上年变动
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.as_of_date -- 数据日期
    ,o.n_as_of_date_skey -- 报表键值
    ,o.n_run_skey -- 运行键值
    ,o.n_entity_skey -- 法人键值
    ,o.n_business_unit_skey -- 业务条线编码
    ,o.n_org_unit_skey -- 一级分行代码(即 填报 机构 号 )
    ,o.n_forecast_point_skey -- 时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点
    ,o.n_report_scenario_skey -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
    ,o.n_rep_line_cd -- 报表项编码
    ,o.v_currency_type -- 币种 1:人民币;2:外币折人民币;3:本外币合计
    ,o.n_rep_line_value -- 金额
    ,o.d_created_dt -- 创建日期
    ,o.n_previous_day_variation -- 较上日变动
    ,o.n_previous_month_variation -- 较上月变动
    ,o.n_previous_year_variation -- 较上年变动
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
from ${iol_schema}.alms_rp_alm_rrs_b01_report_result_bk o
    left join ${iol_schema}.alms_rp_alm_rrs_b01_report_result_op n
        on
            o.as_of_date = n.as_of_date
            and o.n_business_unit_skey = n.n_business_unit_skey
            and o.n_rep_line_cd = n.n_rep_line_cd
            and o.v_currency_type = n.v_currency_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.alms_rp_alm_rrs_b01_report_result_cl d
        on
            o.as_of_date = d.as_of_date
            and o.n_business_unit_skey = d.n_business_unit_skey
            and o.n_rep_line_cd = d.n_rep_line_cd
            and o.v_currency_type = d.v_currency_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.alms_rp_alm_rrs_b01_report_result;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('alms_rp_alm_rrs_b01_report_result') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.alms_rp_alm_rrs_b01_report_result drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.alms_rp_alm_rrs_b01_report_result add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.alms_rp_alm_rrs_b01_report_result exchange partition p_${batch_date} with table ${iol_schema}.alms_rp_alm_rrs_b01_report_result_cl;
alter table ${iol_schema}.alms_rp_alm_rrs_b01_report_result exchange partition p_20991231 with table ${iol_schema}.alms_rp_alm_rrs_b01_report_result_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alms_rp_alm_rrs_b01_report_result to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alms_rp_alm_rrs_b01_report_result_op purge;
drop table ${iol_schema}.alms_rp_alm_rrs_b01_report_result_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.alms_rp_alm_rrs_b01_report_result_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alms_rp_alm_rrs_b01_report_result',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
