/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_realtime_run_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_realtime_run_log
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_realtime_run_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_realtime_run_log(
    etl_dt date -- 数据日期
    ,log_id varchar2(30) -- 日志编号
    ,cfg_id varchar2(30) -- 配置编号
    ,cfg_desc varchar2(200) -- 配置描述
    ,index_no varchar2(30) -- 指标编码
    ,index_name varchar2(200) -- 指标名称
    ,sum_frequency number(4,0) -- 统计频率
    ,sum_start_time varchar2(60) -- 统计开始时点
    ,sum_end_time varchar2(60) -- 统计结束时点
    ,sum_count number(30,0) -- 当前统计数量
    ,run_sts number(1,0) -- 运行状态
    ,start_time timestamp(6) -- 开始时间
    ,end_time timestamp(6) -- 结束时间
    ,remark varchar2(1000) -- 备注
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_realtime_run_log to ${iel_schema};

-- comment
comment on table ${idl_schema}.mcyy_realtime_run_log is '准实时跑数计划日志表';
comment on column ${idl_schema}.mcyy_realtime_run_log.etl_dt is '数据日期';
comment on column ${idl_schema}.mcyy_realtime_run_log.log_id is '日志编号';
comment on column ${idl_schema}.mcyy_realtime_run_log.cfg_id is '配置编号';
comment on column ${idl_schema}.mcyy_realtime_run_log.cfg_desc is '配置描述';
comment on column ${idl_schema}.mcyy_realtime_run_log.index_no is '指标编码';
comment on column ${idl_schema}.mcyy_realtime_run_log.index_name is '指标名称';
comment on column ${idl_schema}.mcyy_realtime_run_log.sum_frequency is '统计频率';
comment on column ${idl_schema}.mcyy_realtime_run_log.sum_start_time is '统计开始时点';
comment on column ${idl_schema}.mcyy_realtime_run_log.sum_end_time is '统计结束时点';
comment on column ${idl_schema}.mcyy_realtime_run_log.sum_count is '当前统计数量';
comment on column ${idl_schema}.mcyy_realtime_run_log.run_sts is '运行状态';
comment on column ${idl_schema}.mcyy_realtime_run_log.start_time is '开始时间';
comment on column ${idl_schema}.mcyy_realtime_run_log.end_time is '结束时间';
comment on column ${idl_schema}.mcyy_realtime_run_log.remark is '备注';