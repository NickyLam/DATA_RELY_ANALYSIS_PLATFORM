/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alms_rp_alm_rrs_b01_report_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alms_rp_alm_rrs_b01_report_result
whenever sqlerror continue none;
drop table ${iol_schema}.alms_rp_alm_rrs_b01_report_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alms_rp_alm_rrs_b01_report_result(
    as_of_date date -- 数据日期
    ,n_as_of_date_skey number(10) -- 报表键值
    ,n_run_skey number(3) -- 运行键值
    ,n_entity_skey number(10) -- 法人键值
    ,n_business_unit_skey number(10) -- 业务条线编码
    ,n_org_unit_skey number(10) -- 一级分行代码(即 填报 机构 号 )
    ,n_forecast_point_skey number(10) -- 时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点
    ,n_report_scenario_skey number(10) -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
    ,n_rep_line_cd number(10) -- 报表项编码
    ,v_currency_type varchar2(10) -- 币种 1:人民币;2:外币折人民币;3:本外币合计
    ,n_rep_line_value number(35,8) -- 金额
    ,d_created_dt date -- 创建日期
    ,n_previous_day_variation number(37,8) -- 较上日变动
    ,n_previous_month_variation number(37,8) -- 较上月变动
    ,n_previous_year_variation number(37,8) -- 较上年变动
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.alms_rp_alm_rrs_b01_report_result to ${iml_schema};
grant select on ${iol_schema}.alms_rp_alm_rrs_b01_report_result to ${icl_schema};
grant select on ${iol_schema}.alms_rp_alm_rrs_b01_report_result to ${idl_schema};
grant select on ${iol_schema}.alms_rp_alm_rrs_b01_report_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.alms_rp_alm_rrs_b01_report_result is '指标数据导出表';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.as_of_date is '数据日期';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_as_of_date_skey is '报表键值';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_run_skey is '运行键值';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_entity_skey is '法人键值';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_business_unit_skey is '业务条线编码';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_org_unit_skey is '一级分行代码(即 填报 机构 号 )';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_forecast_point_skey is '时间窗口键值：0：当前时点；1：当月末时点；2：未来1月末时点；3：未来2月末时点；4：未来3月末时点；5：未来二季度末时点；6：未来三季度末时点;7 :未来四季度末时点';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_report_scenario_skey is '业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_rep_line_cd is '报表项编码';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.v_currency_type is '币种 1:人民币;2:外币折人民币;3:本外币合计';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_rep_line_value is '金额';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.d_created_dt is '创建日期';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_previous_day_variation is '较上日变动';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_previous_month_variation is '较上月变动';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.n_previous_year_variation is '较上年变动';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.start_dt is '开始时间';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.end_dt is '结束时间';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.id_mark is '增删标志';
comment on column ${iol_schema}.alms_rp_alm_rrs_b01_report_result.etl_timestamp is 'ETL处理时间戳';
