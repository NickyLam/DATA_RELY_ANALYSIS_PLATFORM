/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_human_risk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_human_risk
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_human_risk purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_human_risk(
    etl_dt date -- 数据日期
    ,index_no varchar2(30) -- 指标编码
    ,index_name varchar2(200) -- 指标名称
    ,org_no varchar2(60) -- 机构编码
    ,org_name varchar2(80) -- 机构名称
    ,super_org_no varchar2(6) -- 上级机构编码
    ,org_sort varchar2(30) -- 机构分类
    ,employee varchar2(30) -- 员工
    ,emp_stru varchar2(30) -- 人员结构
    ,cop_type varchar2(30) -- 产能类型
    ,bu_type varchar2(30) -- 业务品种
    ,cus_type varchar2(30) -- 客户类型
    ,ques_level varchar2(30) -- 问题单等级
    ,ques_type varchar2(30) -- 问题单种类
    ,index_value number(38,8)  -- 指标值
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
partition by list(etl_dt)
subpartition by list(source_sys)
(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
    (
        subpartition p_19000101_d values ('NCTS')
    )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_human_risk to ${iel_schema};

-- comment
comment on table ${idl_schema}.mcyy_human_risk is '人员及风险分析表';
comment on column ${idl_schema}.mcyy_human_risk.etl_dt is '数据日期';
comment on column ${idl_schema}.mcyy_human_risk.index_no is '指标编码';
comment on column ${idl_schema}.mcyy_human_risk.index_name is '指标名称';
comment on column ${idl_schema}.mcyy_human_risk.org_no is '机构编码';
comment on column ${idl_schema}.mcyy_human_risk.org_name is '机构名称';
comment on column ${idl_schema}.mcyy_human_risk.super_org_no is '上级机构编码';
comment on column ${idl_schema}.mcyy_human_risk.org_sort is '机构分类';
comment on column ${idl_schema}.mcyy_human_risk.employee is '员工';
comment on column ${idl_schema}.mcyy_human_risk.emp_stru is '人员结构';
comment on column ${idl_schema}.mcyy_human_risk.cop_type is '产能类型';
comment on column ${idl_schema}.mcyy_human_risk.bu_type is '业务品种';
comment on column ${idl_schema}.mcyy_human_risk.cus_type is '客户类型';
comment on column ${idl_schema}.mcyy_human_risk.ques_level is '问题单等级';
comment on column ${idl_schema}.mcyy_human_risk.ques_type is '问题单种类';
comment on column ${idl_schema}.mcyy_human_risk.index_value is '指标值';
comment on column ${idl_schema}.mcyy_human_risk.accu_index_value_d is '当日累计';
comment on column ${idl_schema}.mcyy_human_risk.accu_index_value_m is '当月累计';
comment on column ${idl_schema}.mcyy_human_risk.accu_index_value_q is '当季累计';
comment on column ${idl_schema}.mcyy_human_risk.accu_index_value_y is '当年累计';
comment on column ${idl_schema}.mcyy_human_risk.rate_up_day is '比上日';
comment on column ${idl_schema}.mcyy_human_risk.rate_last_month is '比上月';
comment on column ${idl_schema}.mcyy_human_risk.rate_last_quater is '比上季';
comment on column ${idl_schema}.mcyy_human_risk.rate_last_year is '比上年';
comment on column ${idl_schema}.mcyy_human_risk.rate_last_period is '同比';
comment on column ${idl_schema}.mcyy_human_risk.rate_up_day_per is '比上日百分比';
comment on column ${idl_schema}.mcyy_human_risk.rate_last_month_per is '比上月百分比';
comment on column ${idl_schema}.mcyy_human_risk.rate_last_quater_per is '比上季百分比';
comment on column ${idl_schema}.mcyy_human_risk.rate_last_year_per is '比上年百分比';
comment on column ${idl_schema}.mcyy_human_risk.rate_last_period_per is '同比百分比';
comment on column ${idl_schema}.mcyy_human_risk.index_ranking is '当前排名';
comment on column ${idl_schema}.mcyy_human_risk.index_ranking_cha is '排名变动';
comment on column ${idl_schema}.mcyy_human_risk.index_value_avg is '均值';
comment on column ${idl_schema}.mcyy_human_risk.index_value_limit is '阀值';
comment on column ${idl_schema}.mcyy_human_risk.day_ratio_index is '日占比';
comment on column ${idl_schema}.mcyy_human_risk.mon_ratio_index is '月占比';
comment on column ${idl_schema}.mcyy_human_risk.quar_ratio_index is '季占比';
comment on column ${idl_schema}.mcyy_human_risk.year_ratio_index is '年占比';
comment on column ${idl_schema}.mcyy_human_risk.ratio_org is '分行贡献度';
comment on column ${idl_schema}.mcyy_human_risk.unit is '单位';
comment on column ${idl_schema}.mcyy_human_risk.frequency is '频度';
comment on column ${idl_schema}.mcyy_human_risk.measure_no is '度量编号';
comment on column ${idl_schema}.mcyy_human_risk.index_measure is '度量名称';
comment on column ${idl_schema}.mcyy_human_risk.source_sys is '来源系统';
comment on column ${idl_schema}.mcyy_human_risk.etl_timestamp is 'ETL处理时间戳';