/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rrps_rpt_report_result_archive_icms
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rrps_rpt_report_result_archive_icms
whenever sqlerror continue none;
drop table ${iol_schema}.rrps_rpt_report_result_archive_icms purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rrps_rpt_report_result_archive_icms(
    archive_type varchar2(20) -- 数据类型(01-归档数据/02-回灌数据)
    ,index_no varchar2(64) -- 指标号
    ,data_date varchar2(32) -- 数据日期
    ,org_no varchar2(64) -- 机构号
    ,currency varchar2(64) -- 币种
    ,index_val number(30,6) -- 指标值
    ,template_id varchar2(64) -- 模板ID
    ,sys_time varchar2(64) -- 操作日期
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
grant select on ${iol_schema}.rrps_rpt_report_result_archive_icms to ${iml_schema};
grant select on ${iol_schema}.rrps_rpt_report_result_archive_icms to ${icl_schema};
grant select on ${iol_schema}.rrps_rpt_report_result_archive_icms to ${idl_schema};
grant select on ${iol_schema}.rrps_rpt_report_result_archive_icms to ${iel_schema};

-- comment
comment on table ${iol_schema}.rrps_rpt_report_result_archive_icms is '监管供信贷结果表';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_icms.archive_type is '数据类型(01-归档数据/02-回灌数据)';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_icms.index_no is '指标号';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_icms.data_date is '数据日期';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_icms.org_no is '机构号';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_icms.currency is '币种';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_icms.index_val is '指标值';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_icms.template_id is '模板ID';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_icms.sys_time is '操作日期';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_icms.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_icms.etl_timestamp is 'ETL处理时间戳';
