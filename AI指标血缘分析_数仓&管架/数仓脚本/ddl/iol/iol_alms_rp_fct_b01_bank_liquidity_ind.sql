/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alms_rp_fct_b01_bank_liquidity_ind
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind
whenever sqlerror continue none;
drop table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind(
    as_of_date date -- 
    ,n_as_of_date_skey number(10) -- 报表键值
    ,n_run_skey number(3) -- 运行键值
    ,n_entity_skey number(10) -- 法人键值
    ,n_business_unit_skey number(10) -- 业务条线编码
    ,n_org_unit_skey number(10) -- 一级分行代码(即填报机构号)
    ,n_forecast_point_skey number(10) -- 
    ,n_report_scenario_skey number(10) -- 业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景
    ,n_rep_line_cd number(10) -- 报表项编码
    ,v_currency_type varchar2(10) -- 
    ,n_rep_line_value number(35,8) -- 当前值
    ,d_created_dt date -- 
    ,n_previous_day_variation number(37,8) -- 
    ,n_previous_month_variation number(37,8) -- 
    ,n_previous_year_variation number(37,8) -- 
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind to ${iml_schema};
grant select on ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind to ${icl_schema};
grant select on ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind to ${idl_schema};
grant select on ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind to ${iel_schema};

-- comment
comment on table ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind is '全行流动性指标限额表';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.as_of_date is '';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_as_of_date_skey is '报表键值';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_run_skey is '运行键值';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_entity_skey is '法人键值';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_business_unit_skey is '业务条线编码';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_org_unit_skey is '一级分行代码(即填报机构号)';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_forecast_point_skey is '';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_report_scenario_skey is '业务情景键值：1：无预算情景假设；2：业务量不变情景；3：月度预算业务情景；4：年度预算业务情景';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_rep_line_cd is '报表项编码';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.v_currency_type is '';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_rep_line_value is '当前值';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.d_created_dt is '';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_previous_day_variation is '';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_previous_month_variation is '';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.n_previous_year_variation is '';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alms_rp_fct_b01_bank_liquidity_ind.etl_timestamp is 'ETL处理时间戳';
