/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_alms_rp_alm_rrs_liquidity_report_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result(
    etl_dt date
    ,v_rep_cd varchar2(20)
    ,v_rep_line_order number(3)
    ,n_rep_line_cd number
    ,v_rep_line_name varchar2(800)
    ,v_rep_line_display_order number(3)
    ,n_bold_ind number(3)
    ,n_indent_level number(3)
    ,v_regulatory_level varchar2(200)
    ,v_index_class varchar2(200)
    ,v_supervision_require varchar2(200)
    ,v_limit_value varchar2(200)
    ,v_prewarning_value varchar2(200)
    ,v_index_type varchar2(200)
    ,v_statistical_frequency varchar2(200)
    ,v_monitor_frequency varchar2(200)
    ,v_read_lvl varchar2(200)
    ,v_department_type varchar2(200)
    ,d_created_dt date
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result is '限额指标属性导出表';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_rep_cd is '报表id';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_rep_line_order is '序号';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.n_rep_line_cd is '报表条目编号';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_rep_line_name is '报表条目名称(即指标名称)';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_rep_line_display_order is '报表条目展示顺序号';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.n_bold_ind is '粗体展示标识:0：正常；1：粗体';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.n_indent_level is '缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_regulatory_level is '监控级别';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_index_class is '指标分类';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_supervision_require is '监管要求';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_limit_value is '限额值';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_prewarning_value is '预警值';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_index_type is '指标类型';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_statistical_frequency is '统计频率';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_monitor_frequency is '监测频率';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_read_lvl is '审阅层级';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.v_department_type is '指标部门';
comment on column ${msl_schema}.msl_edw_alms_rp_alm_rrs_liquidity_report_result.d_created_dt is '创建日期';
