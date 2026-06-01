/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl idl_mcyy_bu_analysis_fe_diplay
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_bu_analysis_fe_diplay
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_bu_analysis_fe_diplay purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_bu_analysis_fe_diplay(
    etl_dt date -- 数据日期
    ,index_no varchar2(200) -- 指标编码
    ,index_name varchar2(600) -- 指标名称
    ,org_no varchar2(60) -- 机构编码
    ,org_name varchar2(200) -- 机构名称
    ,super_org_no varchar2(6) -- 上级机构编码
    ,org_sort varchar2(30) -- 机构分类
    ,employee varchar2(200) -- 员工
    ,bu_type varchar2(30) -- 业务品种
    ,oper_step varchar2(30) -- 操作阶段
    ,index_value number(38,8) -- 指标值
    ,accu_index_value_d number(38,8) -- 当日累计
    ,accu_index_value_m number(38,8) -- 当月累计
    ,accu_index_value_q number(38,8) -- 当季累计
    ,accu_index_value_y number(38,8) -- 当年累计
    ,rate_up_day number(38,8) -- 比上日
    ,rate_last_month number(38,8) -- 比上月
    ,rate_last_quater number(38,8) -- 比上季
    ,rate_last_year number(38,8) -- 比上年
    ,rate_last_period number(38,8) -- 同比
    ,rate_up_day_per number(38,8) -- 比上日百分比
    ,rate_last_month_per number(38,8) -- 比上月百分比
    ,rate_last_quater_per number(38,8) -- 比上季百分比
    ,rate_last_year_per number(38,8) -- 比上年百分比
    ,rate_last_period_per number(38,8) -- 同比百分比
    ,index_ranking number(10) -- 当前排名
    ,index_ranking_cha number(10) -- 排名变动
    ,index_value_avg number(38,8) -- 均值
    ,index_value_limit number(38,8) -- 阀值
    ,day_ratio_index number(38,8) -- 日占比
    ,mon_ratio_index number(38,8) -- 月占比
    ,quar_ratio_index number(38,8) -- 季占比
    ,year_ratio_index number(38,8) -- 年占比
    ,ratio_org number(38,8) -- 分行贡献度
    ,unit varchar2(6) -- 单位
    ,frequency varchar2(200) -- 频度
    ,measure_no varchar2(60) -- 度量编号
    ,index_measure varchar2(200) -- 度量名称
    ,source_sys  VARCHAR2(60)  ---来源系统
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
)

partition by list(index_no)(
    partition p_wd999999 values ('WD999999')
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_bu_analysis_fe_diplay to ${idl_schema};

-- comment
comment on table ${idl_schema}.mcyy_bu_analysis_fe_diplay is '业务分析指标前端展示表';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.etl_dt is '数据日期';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.index_no is '指标编码';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.index_name is '指标名称';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.org_no is '机构编码';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.org_name is '机构名称';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.super_org_no is '上级机构编码';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.org_sort is '机构分类';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.employee is '员工';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.bu_type is '业务品种';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.oper_step is '操作阶段';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.index_value is '指标值';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.accu_index_value_d is '当日累计';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.accu_index_value_m is '当月累计';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.accu_index_value_q is '当季累计';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.accu_index_value_y is '当年累计';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.rate_up_day is '比上日';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.rate_last_month is '比上月';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.rate_last_quater is '比上季';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.rate_last_year is '比上年';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.rate_last_period is '同比';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.rate_up_day_per is '比上日百分比';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.rate_last_month_per is '比上月百分比';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.rate_last_quater_per is '比上季百分比';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.rate_last_year_per is '比上年百分比';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.rate_last_period_per is '同比百分比';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.index_ranking is '当前排名';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.index_ranking_cha is '排名变动';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.index_value_avg is '均值';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.index_value_limit is '阀值';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.day_ratio_index is '日占比';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.mon_ratio_index is '月占比';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.quar_ratio_index is '季占比';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.year_ratio_index is '年占比';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.ratio_org is '分行贡献度';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.unit is '单位';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.frequency is '频度';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.measure_no is '度量编号';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.index_measure is '度量名称';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.source_sys is '来源系统';
comment on column ${idl_schema}.mcyy_bu_analysis_fe_diplay.etl_timestamp is 'ETL处理时间戳';