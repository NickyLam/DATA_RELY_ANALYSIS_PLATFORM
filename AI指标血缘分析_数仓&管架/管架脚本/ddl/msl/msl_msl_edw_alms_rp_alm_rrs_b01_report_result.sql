/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_alms_rp_alm_rrs_b01_report_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result(
    etl_dt date
    ,as_of_date date
    ,n_as_of_date_skey number(10)
    ,n_run_skey number(3)
    ,n_entity_skey number(10)
    ,n_business_unit_skey number(10)
    ,n_org_unit_skey number(10)
    ,n_forecast_point_skey number(10)
    ,n_report_scenario_skey number(10)
    ,n_rep_line_cd number(10)
    ,v_currency_type varchar2(10)
    ,n_rep_line_value number(35,8)
    ,d_created_dt date
    ,n_previous_day_variation number(37,8)
    ,n_previous_month_variation number(37,8)
    ,n_previous_year_variation number(37,8)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result is '指标数据导出表';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.as_of_date is '数据日期';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_as_of_date_skey is '报表键值';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_run_skey is '运行键值';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_entity_skey is '法人键值';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_business_unit_skey is '业务条线编码';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_org_unit_skey is '一级分行代码(即 填报 机构 号 )';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_forecast_point_skey is '时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_report_scenario_skey is '业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_rep_line_cd is '报表项编码';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.v_currency_type is '币种 1:人民币;2:外币折人民币;3:本外币合计';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_rep_line_value is '金额';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.d_created_dt is '创建日期';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_previous_day_variation is '较上日变动';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_previous_month_variation is '较上月变动';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_b01_report_result.n_previous_year_variation is '较上年变动';
