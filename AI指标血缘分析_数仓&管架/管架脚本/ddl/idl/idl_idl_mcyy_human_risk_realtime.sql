/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_human_risk_realtime
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_human_risk_realtime
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_human_risk_realtime purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_human_risk_realtime(
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
    ,index_value varchar2(30) -- 指标值
    ,sum_time date -- 统计时点
    ,index_time_value number(21,6) -- 指标时点值
     ,hours_total        NUMBER(38,8)
     ,rate_up_hour       NUMBER(38,8)
    ,accu_index_value_d number(21,6) -- 当日累计
    ,index_ranking number(4,0) -- 当前排名
    ,index_ranking_cha number(4,0) -- 排名变动
    ,index_value_avg number(4,0) -- 均值
    ,index_value_limit number(21,6) -- 阀值
    ,ratio_index number(8,4) -- 结构占比
    ,ratio_org number(8,4) -- 分行贡献度
    ,unit varchar2(6) -- 单位
    ,frequency varchar2(4) -- 频度
    ,measure_no varchar2(60) -- 度量编号
    ,index_measure varchar2(200) -- 度量名称
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_human_risk_realtime to ${iel_schema};

-- comment
comment on table ${idl_schema}.mcyy_human_risk_realtime is '人员及风险分析表';
comment on column ${idl_schema}.mcyy_human_risk_realtime.etl_dt is '数据日期';
comment on column ${idl_schema}.mcyy_human_risk_realtime.index_no is '指标编码';
comment on column ${idl_schema}.mcyy_human_risk_realtime.index_name is '指标名称';
comment on column ${idl_schema}.mcyy_human_risk_realtime.org_no is '机构编码';
comment on column ${idl_schema}.mcyy_human_risk_realtime.org_name is '机构名称';
comment on column ${idl_schema}.mcyy_human_risk_realtime.super_org_no is '上级机构编码';
comment on column ${idl_schema}.mcyy_human_risk_realtime.org_sort is '机构分类';
comment on column ${idl_schema}.mcyy_human_risk_realtime.employee is '员工';
comment on column ${idl_schema}.mcyy_human_risk_realtime.emp_stru is '人员结构';
comment on column ${idl_schema}.mcyy_human_risk_realtime.cop_type is '产能类型';
comment on column ${idl_schema}.mcyy_human_risk_realtime.bu_type is '业务品种';
comment on column ${idl_schema}.mcyy_human_risk_realtime.cus_type is '客户类型';
comment on column ${idl_schema}.mcyy_human_risk_realtime.ques_level is '问题单等级';
comment on column ${idl_schema}.mcyy_human_risk_realtime.ques_type is '问题单种类';
comment on column ${idl_schema}.mcyy_human_risk_realtime.index_value is '指标值';
comment on column ${idl_schema}.mcyy_human_risk_realtime.sum_time is '统计时点';
comment on column ${idl_schema}.mcyy_human_risk_realtime.index_value is '指标时点值';
comment on column ${idl_schema}.mcyy_human_risk_realtime.accu_index_value_d is '当日累计';
comment on column ${idl_schema}.mcyy_human_risk_realtime.index_ranking is '当前排名';
comment on column ${idl_schema}.mcyy_human_risk_realtime.index_ranking_cha is '排名变动';
comment on column ${idl_schema}.mcyy_human_risk_realtime.index_value_avg is '均值';
comment on column ${idl_schema}.mcyy_human_risk_realtime.index_value_limit is '阀值';
comment on column ${idl_schema}.mcyy_human_risk_realtime.ratio_index is '结构占比';
comment on column ${idl_schema}.mcyy_human_risk_realtime.ratio_org is '分行贡献度';
comment on column ${idl_schema}.mcyy_human_risk_realtime.unit is '单位';
comment on column ${idl_schema}.mcyy_human_risk_realtime.frequency is '频度';
comment on column ${idl_schema}.mcyy_human_risk_realtime.measure_no is '度量编号';
comment on column ${idl_schema}.mcyy_human_risk_realtime.index_measure is '度量名称';
comment on column ${idl_schema}.mcyy_human_risk_realtime.etl_timestamp is 'ETL处理时间戳';
comment on column MCYY_HUMAN_RISK_REALTIME.hours_total
  is '小时合计';
comment on column MCYY_HUMAN_RISK_REALTIME.rate_up_hour
  is '比上小时';