/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_atms_rpt_date_open_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_atms_rpt_date_open_rate
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_atms_rpt_date_open_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_atms_rpt_date_open_rate(
    etl_dt date
    ,logic_id varchar2(36)
    ,dev_no varchar2(20)
    ,date_time varchar2(10)
    ,full_fun_time number(20,2)
    ,full_rate number(20,2)
    ,half_fun_time number(20,2)
    ,half_rate number(20,2)
    ,hard_fault_time number(20,2)
    ,soft_fault_time number(20,2)
    ,maintenance_time number(20,2)
    ,comm_failure_time number(20,2)
    ,close_time number(20,2)
    ,other_reason_time number(20,2)
    ,work_time number(20,2)
    ,perfect_rate number(20,2)
    ,service_rate number(20,2)
    ,comm_rate number(20,2)
    ,stop_time number(20,2)
    ,vcomm_failure_time number(20,2)
    ,short_paper_time number(20,2)
    ,cash_gate_time number(20,2)
    ,movement_fail_time number(20,2)
    ,start_dt date
    ,end_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_atms_rpt_date_open_rate to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_atms_rpt_date_open_rate is '开机率日统计表';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.logic_id is '编号';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.dev_no is '设备号';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.date_time is '日期';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.full_fun_time is '全功能开机时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.full_rate is '全功能开机率';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.half_fun_time is '半功能开机时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.half_rate is '半功能开机率';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.hard_fault_time is '硬故障停机时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.soft_fault_time is '软故障停机时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.maintenance_time is '维护时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.comm_failure_time is 'P通讯中断时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.close_time is '关机时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.other_reason_time is '其他原因时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.work_time is '规定工作时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.perfect_rate is '设备完好率（未使用）';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.service_rate is '正常服务率（未使用）';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.comm_rate is '通讯完好率（未使用）';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.stop_time is '停机时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.vcomm_failure_time is 'V通讯中断时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.short_paper_time is '流水打印机缺纸停机时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.cash_gate_time is '出钞门故障时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.movement_fail_time is '机芯故障时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.start_dt is '开始时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.end_dt is '结束时间';
comment on column ${msl_schema}.msl_edw_atms_rpt_date_open_rate.id_mark is '增删标志';
