/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol escs_esc_indicator_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.escs_esc_indicator_data
whenever sqlerror continue none;
drop table ${iol_schema}.escs_esc_indicator_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.escs_esc_indicator_data(
    id varchar2(256) -- ESC指标id
    ,esc_transaction_total_day varchar2(128) -- ESC当日交易笔数
    ,transaction_succ_rate varchar2(128) -- ESC当日交易成功率
    ,max_tps varchar2(128) -- ESC当日最大TPS
    ,esc_transaction_total_month varchar2(128) -- ESC月交易笔数
    ,esc_transaction_total_year varchar2(128) -- ESC年交易笔数
    ,esc_transaction_total_year_avg varchar2(128) -- ESC年均交易笔数
    ,esc_single_service_max_concurrency varchar2(128) -- ESC单服务支持最大并发数
    ,esc_standalone_max_concurrency varchar2(128) -- ESC单机支持最大并发数
    ,esc_service_num varchar2(128) -- ESC服务治理接口数
    ,interface_stock_num varchar2(128) -- 存量迁移接口数
    ,access_esc_system_num varchar2(128) -- 接入ESC系统数
    ,trace_info_num varchar2(128) -- ESC服务治理接口数
    ,transaction_failure_alarm_num varchar2(128) -- 交易失败达到设置阀值发送邮件告警数
    ,intraday_interface_stock_active_num varchar2(128) -- 当日存量迁移接口活跃数
    ,intraday_esc_service_active_num varchar2(128) -- 当日服务治理接口活跃数
    ,softness_and_patent varchar2(1024) -- 软著和专利
    ,statistics_date varchar2(128) -- 统计日期
    ,update_time date -- 更新时间
    ,esc_call_total_day varchar2(128) -- ESC当日调用笔数
    ,statistics_start_date varchar2(128) -- 统计开始日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.escs_esc_indicator_data to ${iml_schema};
grant select on ${iol_schema}.escs_esc_indicator_data to ${icl_schema};
grant select on ${iol_schema}.escs_esc_indicator_data to ${idl_schema};
grant select on ${iol_schema}.escs_esc_indicator_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.escs_esc_indicator_data is 'ESC特色指标表';
comment on column ${iol_schema}.escs_esc_indicator_data.id is 'ESC指标id';
comment on column ${iol_schema}.escs_esc_indicator_data.esc_transaction_total_day is 'ESC当日交易笔数';
comment on column ${iol_schema}.escs_esc_indicator_data.transaction_succ_rate is 'ESC当日交易成功率';
comment on column ${iol_schema}.escs_esc_indicator_data.max_tps is 'ESC当日最大TPS';
comment on column ${iol_schema}.escs_esc_indicator_data.esc_transaction_total_month is 'ESC月交易笔数';
comment on column ${iol_schema}.escs_esc_indicator_data.esc_transaction_total_year is 'ESC年交易笔数';
comment on column ${iol_schema}.escs_esc_indicator_data.esc_transaction_total_year_avg is 'ESC年均交易笔数';
comment on column ${iol_schema}.escs_esc_indicator_data.esc_single_service_max_concurrency is 'ESC单服务支持最大并发数';
comment on column ${iol_schema}.escs_esc_indicator_data.esc_standalone_max_concurrency is 'ESC单机支持最大并发数';
comment on column ${iol_schema}.escs_esc_indicator_data.esc_service_num is 'ESC服务治理接口数';
comment on column ${iol_schema}.escs_esc_indicator_data.interface_stock_num is '存量迁移接口数';
comment on column ${iol_schema}.escs_esc_indicator_data.access_esc_system_num is '接入ESC系统数';
comment on column ${iol_schema}.escs_esc_indicator_data.trace_info_num is 'ESC服务治理接口数';
comment on column ${iol_schema}.escs_esc_indicator_data.transaction_failure_alarm_num is '交易失败达到设置阀值发送邮件告警数';
comment on column ${iol_schema}.escs_esc_indicator_data.intraday_interface_stock_active_num is '当日存量迁移接口活跃数';
comment on column ${iol_schema}.escs_esc_indicator_data.intraday_esc_service_active_num is '当日服务治理接口活跃数';
comment on column ${iol_schema}.escs_esc_indicator_data.softness_and_patent is '软著和专利';
comment on column ${iol_schema}.escs_esc_indicator_data.statistics_date is '统计日期';
comment on column ${iol_schema}.escs_esc_indicator_data.update_time is '更新时间';
comment on column ${iol_schema}.escs_esc_indicator_data.esc_call_total_day is 'ESC当日调用笔数';
comment on column ${iol_schema}.escs_esc_indicator_data.statistics_start_date is '统计开始日期';
comment on column ${iol_schema}.escs_esc_indicator_data.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.escs_esc_indicator_data.etl_timestamp is 'ETL处理时间戳';
