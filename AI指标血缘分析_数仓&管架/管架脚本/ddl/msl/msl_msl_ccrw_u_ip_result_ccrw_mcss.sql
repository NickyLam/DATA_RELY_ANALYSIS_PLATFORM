/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_ccrw_u_ip_result_ccrw_mcss
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss
whenever sqlerror continue none;
drop table ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss(
    result_id varchar(120)
    ,index_mx_id varchar(32)
    ,org_or_user_id varchar(32)
    ,fit_obj varchar(8)
    ,gh_type varchar(2)
    ,ccy_type varchar(2)
    ,index_cycle_value varchar(10)
    ,index_cycle varchar(2)
    ,bk_index_id varchar(32)
    ,run_batch_date varchar(10)
    ,index_from varchar(32)
    ,value number(36,8)
    ,last_day number(36,8)
    ,last_week number(36,8)
    ,last_month number(36,8)
    ,last_season number(36,8)
    ,last_year number(36,8)
    ,last_year_same number(36,8)
    ,d_sub_zf number(36,8)
    ,w_sub_zf number(36,8)
    ,m_sub_zf number(36,8)
    ,q_sub_zf number(36,8)
    ,y_sub_zf number(36,8)
    ,yoy_sub_zf number(36,8)
    ,unit varchar(2)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss is '公司指标汇总表(管理驾驶舱)';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.result_id is '指标结果ID';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.index_mx_id is '实际指标ID';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.org_or_user_id is '机构或员工ID';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.fit_obj is '适用对象';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.gh_type is '管户类型';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.ccy_type is '币别类型';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.index_cycle_value is '指标周期值';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.index_cycle is '指标周期';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.bk_index_id is '集市指标ID';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.run_batch_date is '跑批日期';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.index_from is '指标来源';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.value is '结果值';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.last_day is '比上日';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.last_week is '比上周';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.last_month is '比上月末';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.last_season is '比上季末';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.last_year is '比上年末';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.last_year_same is '比上年同期末';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.d_sub_zf is '比上日增幅';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.w_sub_zf is '比上周增幅';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.m_sub_zf is '比上月末增幅';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.q_sub_zf is '比上季末增幅';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.y_sub_zf is '比上年末增幅';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.yoy_sub_zf is '比去年同期增幅';
comment on column ${msl_schema}.msl_ccrw_u_ip_result_ccrw_mcss.unit is '指标单位 1-元 2-户 3-笔';
