/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_ccrw_u_ip_result_icrw_mcss
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss
whenever sqlerror continue none;
drop table ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss(
    result_id varchar2(120) -- 指标结果ID
    ,index_mx_id varchar2(32) -- 实际指标ID
    ,org_or_user_id varchar2(32) -- 机构或员工ID
    ,fit_obj varchar2(8) -- 适用对象
    ,gh_type varchar2(2) -- 管户类型
    ,ccy_type varchar2(2) -- 币别类型
    ,index_cycle_value varchar2(10) -- 指标周期值
    ,index_cycle varchar2(2) -- 指标周期
    ,bk_index_id varchar2(32) -- 集市指标ID
    ,run_batch_date varchar2(10) -- 跑批日期
    ,index_from varchar2(32) -- 指标来源
    ,value number(36,8) -- 结果值
    ,last_day number(36,8) -- 比上日
    ,last_week number(36,8) -- 比上周
    ,last_month number(36,8) -- 比上月末
    ,last_season number(36,8) -- 比上季末
    ,last_year number(36,8) -- 比上年末
    ,last_year_same number(36,8) -- 比上年同期末
    ,d_sub_zf number(36,8) -- 比上日增幅
    ,w_sub_zf number(36,8) -- 比上周增幅
    ,m_sub_zf number(36,8) -- 比上月末增幅
    ,q_sub_zf number(36,8) -- 比上季末增幅
    ,y_sub_zf number(36,8) -- 比上年末增幅
    ,yoy_sub_zf number(36,8) -- 比去年同期增幅
    ,unit varchar2(2) -- 指标单位 1-元 2-户 3-笔
    ,tw_sub_bal number(36,8) -- 比上两周
    ,tw_sub_zf number(36,8) -- 比上两周增幅
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss is '同业指标汇总表(管理驾驶舱)';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.result_id is '指标结果ID';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.index_mx_id is '实际指标ID';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.org_or_user_id is '机构或员工ID';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.fit_obj is '适用对象';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.gh_type is '管户类型';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.ccy_type is '币别类型';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.index_cycle_value is '指标周期值';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.index_cycle is '指标周期';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.bk_index_id is '集市指标ID';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.run_batch_date is '跑批日期';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.index_from is '指标来源';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.value is '结果值';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.last_day is '比上日';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.last_week is '比上周';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.last_month is '比上月末';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.last_season is '比上季末';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.last_year is '比上年末';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.last_year_same is '比上年同期末';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.d_sub_zf is '比上日增幅';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.w_sub_zf is '比上周增幅';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.m_sub_zf is '比上月末增幅';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.q_sub_zf is '比上季末增幅';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.y_sub_zf is '比上年末增幅';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.yoy_sub_zf is '比去年同期增幅';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.unit is '指标单位 1-元 2-户 3-笔';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.tw_sub_bal is '比上两周';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.tw_sub_zf is '比上两周增幅';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_ccrw_u_ip_result_icrw_mcss.etl_timestamp is 'ETL处理时间戳';
