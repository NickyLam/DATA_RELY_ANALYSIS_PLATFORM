/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_rwas_pb_report_approve
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_rwas_pb_report_approve
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_rwas_pb_report_approve purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_rwas_pb_report_approve(
    etl_dt date
    ,item_cd varchar2(90)
    ,item_name varchar2(150)
    ,data_date varchar2(30)
    ,solo_no varchar2(60)
    ,org_cd varchar2(60)
    ,ccy_cd varchar2(60)
    ,version varchar2(150)
    ,version_status number(22)
    ,operate_dt varchar2(75)
    ,operate_id varchar2(75)
    ,operate_name varchar2(383)
    ,flow_starter_id varchar2(75)
    ,flow_starter_name varchar2(383)
    ,approve_remark varchar2(750)
    ,catalog_id varchar2(75)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_rwas_pb_report_approve to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_rwas_pb_report_approve is '报表管理-报表版本及流程状态表';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.item_cd is '报表编码';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.item_name is '报表名称';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.data_date is '数据日期';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.solo_no is '法人编码';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.org_cd is '机构编码';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.ccy_cd is '币种编码';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.version is '版本';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.version_status is '版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.operate_dt is '操作时间';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.operate_id is '操作人id';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.operate_name is '操作人姓名';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.flow_starter_id is '流程发起人id';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.flow_starter_name is '流程发起人姓名';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.approve_remark is '审批意见';
comment on column ${msl_schema}.msl_edw_rwas_pb_report_approve.catalog_id is '附件目录编号';
