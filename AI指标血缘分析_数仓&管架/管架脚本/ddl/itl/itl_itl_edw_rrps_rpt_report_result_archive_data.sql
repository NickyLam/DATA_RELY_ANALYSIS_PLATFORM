/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_rrps_rpt_report_result_archive_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data(
    archive_type varchar2(20) -- 数据类型(01-归档数据/02-回灌数据)
    ,index_no varchar2(64) -- 指标标识
    ,data_date varchar2(32) -- 数据日期
    ,org_no varchar2(64) -- 机构标识
    ,currency varchar2(64) -- 币种
    ,index_val number(30,6) -- 指标值
    ,template_id varchar2(64) -- 模板ID
    ,sys_time varchar2(64) -- 操作日期
    ,sys_ind varchar2(32) -- 系统标志
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
grant select on ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data is '报表结果供数表';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.archive_type is '数据类型(01-归档数据/02-回灌数据)';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.index_no is '指标标识';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.data_date is '数据日期';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.org_no is '机构标识';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.currency is '币种';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.index_val is '指标值';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.template_id is '模板ID';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.sys_time is '操作日期';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.sys_ind is '系统标志';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_rrps_rpt_report_result_archive_data.etl_timestamp is 'ETL处理时间戳';
