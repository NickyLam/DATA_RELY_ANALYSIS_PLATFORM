/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_bu_analysis_realtime
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_bu_analysis_realtime
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_bu_analysis_realtime purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_bu_analysis_realtime(
    etl_dt date -- 数据日期
    ,index_no varchar2(30) -- 指标编码
    ,index_name varchar2(200) -- 指标名称
    ,org_no varchar2(60) -- 机构编码
    ,org_name varchar2(80) -- 机构名称
    ,super_org_no varchar2(6) -- 上级机构编码
    ,org_sort varchar2(30) -- 机构分类
    ,employee varchar2(30) -- 员工
    ,bu_type varchar2(30) -- 业务品种
    ,oper_step varchar2(30) -- 操作阶段
    ,sum_time date -- 统计时点
    ,index_value number(38,8) -- 指标时点值
    ,accu_index_value_d number(38,8) -- 当日累计
    ,index_ranking number(10) -- 当前排名
    ,index_ranking_cha number(10) -- 排名变动
    ,index_value_avg number(38,8) -- 均值
    ,index_value_limit number(38,8) -- 阀值
    ,ratio_index number(38,8) -- 结构占比
    ,ratio_org number(38,8) -- 分行贡献度
    ,unit varchar2(6) -- 单位
    ,frequency varchar2(4) -- 频度
    ,measure_no varchar2(60) -- 度量编号
    ,index_measure varchar2(200) -- 度量名称
    ,hours_total  number(38,8) -- 小时合计
    ,etl_timestamp timestamp(6) -- ETL处理时间戳
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_bu_analysis_realtime to ${iel_schema};

-- comment
comment on table ${idl_schema}.mcyy_bu_analysis_realtime is '业务分析表';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.etl_dt is '数据日期';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.index_no is '指标编码';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.index_name is '指标名称';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.org_no is '机构编码';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.org_name is '机构名称';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.super_org_no is '上级机构编码';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.org_sort is '机构分类';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.employee is '员工';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.bu_type is '业务品种';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.oper_step is '操作阶段';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.sum_time is '统计时点';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.index_value is '指标时点值';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.accu_index_value_d is '当日累计';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.index_ranking is '当前排名';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.index_ranking_cha is '排名变动';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.index_value_avg is '均值';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.index_value_limit is '阀值';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.ratio_index is '结构占比';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.ratio_org is '分行贡献度';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.unit is '单位';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.frequency is '频度';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.measure_no is '度量编号';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.index_measure is '度量名称';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.hours_total is '小时合计';
comment on column ${idl_schema}.mcyy_bu_analysis_realtime.etl_timestamp is 'ETL处理时间戳';