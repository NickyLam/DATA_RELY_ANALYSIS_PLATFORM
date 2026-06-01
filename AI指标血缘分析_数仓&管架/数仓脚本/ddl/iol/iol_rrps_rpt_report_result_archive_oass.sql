/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rrps_rpt_report_result_archive_oass
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rrps_rpt_report_result_archive_oass
whenever sqlerror continue none;
drop table ${iol_schema}.rrps_rpt_report_result_archive_oass purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rrps_rpt_report_result_archive_oass(
    archive_type varchar2(20) -- 数据类型(01-归档数据/02-回灌数据)
    ,index_no varchar2(64) -- 指标标识
    ,data_date varchar2(32) -- 数据日期
    ,org_no varchar2(64) -- 机构标识
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
grant select on ${iol_schema}.rrps_rpt_report_result_archive_oass to ${iml_schema};
grant select on ${iol_schema}.rrps_rpt_report_result_archive_oass to ${icl_schema};
grant select on ${iol_schema}.rrps_rpt_report_result_archive_oass to ${idl_schema};
grant select on ${iol_schema}.rrps_rpt_report_result_archive_oass to ${iel_schema};

-- comment
comment on table ${iol_schema}.rrps_rpt_report_result_archive_oass is '监管供非现场审计结果表';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_oass.archive_type is '数据类型(01-归档数据/02-回灌数据)';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_oass.index_no is '指标标识';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_oass.data_date is '数据日期';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_oass.org_no is '机构标识';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_oass.currency is '币种';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_oass.index_val is '指标值';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_oass.template_id is '模板ID';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_oass.sys_time is '操作日期';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_oass.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rrps_rpt_report_result_archive_oass.etl_timestamp is 'ETL处理时间戳';
