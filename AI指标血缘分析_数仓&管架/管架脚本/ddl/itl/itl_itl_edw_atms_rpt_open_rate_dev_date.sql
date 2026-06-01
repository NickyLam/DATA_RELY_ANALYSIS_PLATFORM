/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_atms_rpt_open_rate_dev_date
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date(
    dev_no varchar2(20) -- 设备号
    ,date_time varchar2(10) -- 日期 yyyyMMdd
    ,open_rate_year varchar2(4) -- 记录年份
    ,open_rate_month varchar2(2) -- 记录月份
    ,open_rate_day varchar2(2) -- 记录日期
    ,full_fun_time number(20,2) -- 全功能开机时间
    ,full_rate number(20,2) -- 全功能开机率
    ,half_fun_time number(20,2) -- 半功能开机时间
    ,half_rate number(20,2) -- 半功能开机率
    ,hard_fault_time number(20,2) -- 硬故障停机时间
    ,soft_fault_time number(20,2) -- 软故障停机时间
    ,maintenance_time number(20,2) -- 维护时间
    ,comm_failure_time number(20,2) -- P通讯中断时间
    ,close_time number(20,2) -- 关机时间
    ,other_reason_time number(20,2) -- 其他原因时间
    ,work_time number(20,2) -- 规定工作时间
    ,perfect_rate number(20,2) -- 设备完好率(未使用）
    ,service_rate number(20,2) -- 正常服务率（未使用）
    ,comm_rate number(20,2) -- 通讯完好率（未使用）
    ,stop_time number(20,2) -- 停机时间
    ,vcomm_failure_time number(20,2) -- V通讯故障时间
    ,suspected_crash_time number(20,2) -- 疑似死机时间
    ,is_from_dev varchar2(2) -- 是否通过客户端开机率报文计算。0：是；1：否
    ,short_paper_time number(20,2) -- 流水打印机缺纸停机时间
    ,cash_gate_time number(20,2) -- 出钞门故障时间
    ,movement_fail_time number(20,2) -- 机芯故障时间
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
grant select on ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date is '开机率日统计表';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.dev_no is '设备号';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.date_time is '日期 yyyyMMdd';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.open_rate_year is '记录年份';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.open_rate_month is '记录月份';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.open_rate_day is '记录日期';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.full_fun_time is '全功能开机时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.full_rate is '全功能开机率';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.half_fun_time is '半功能开机时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.half_rate is '半功能开机率';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.hard_fault_time is '硬故障停机时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.soft_fault_time is '软故障停机时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.maintenance_time is '维护时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.comm_failure_time is 'P通讯中断时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.close_time is '关机时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.other_reason_time is '其他原因时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.work_time is '规定工作时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.perfect_rate is '设备完好率(未使用）';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.service_rate is '正常服务率（未使用）';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.comm_rate is '通讯完好率（未使用）';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.stop_time is '停机时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.vcomm_failure_time is 'V通讯故障时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.suspected_crash_time is '疑似死机时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.is_from_dev is '是否通过客户端开机率报文计算。0：是；1：否';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.short_paper_time is '流水打印机缺纸停机时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.cash_gate_time is '出钞门故障时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.movement_fail_time is '机芯故障时间';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_atms_rpt_open_rate_dev_date.etl_timestamp is 'ETL处理时间戳';
