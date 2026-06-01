/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_pb_report_approve
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_pb_report_approve
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_pb_report_approve purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_pb_report_approve(
    item_cd varchar2(90) -- 报表编码
    ,item_name varchar2(150) -- 报表名称
    ,data_date varchar2(30) -- 数据日期
    ,solo_no varchar2(60) -- 法人编码
    ,org_cd varchar2(60) -- 机构编码
    ,ccy_cd varchar2(60) -- 币种编码
    ,version varchar2(150) -- 版本
    ,version_status number(22) -- 版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本
    ,operate_dt varchar2(75) -- 操作时间
    ,operate_id varchar2(75) -- 操作人ID
    ,operate_name varchar2(383) -- 操作人姓名
    ,flow_starter_id varchar2(75) -- 流程发起人ID
    ,flow_starter_name varchar2(383) -- 流程发起人姓名
    ,approve_remark varchar2(750) -- 审批意见
    ,catalog_id varchar2(75) -- 附件目录编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rwas_pb_report_approve to ${iml_schema};
grant select on ${iol_schema}.rwas_pb_report_approve to ${icl_schema};
grant select on ${iol_schema}.rwas_pb_report_approve to ${idl_schema};
grant select on ${iol_schema}.rwas_pb_report_approve to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_pb_report_approve is '报表管理-报表版本及流程状态表';
comment on column ${iol_schema}.rwas_pb_report_approve.item_cd is '报表编码';
comment on column ${iol_schema}.rwas_pb_report_approve.item_name is '报表名称';
comment on column ${iol_schema}.rwas_pb_report_approve.data_date is '数据日期';
comment on column ${iol_schema}.rwas_pb_report_approve.solo_no is '法人编码';
comment on column ${iol_schema}.rwas_pb_report_approve.org_cd is '机构编码';
comment on column ${iol_schema}.rwas_pb_report_approve.ccy_cd is '币种编码';
comment on column ${iol_schema}.rwas_pb_report_approve.version is '版本';
comment on column ${iol_schema}.rwas_pb_report_approve.version_status is '版本状态，1-保存，2-审批中，3-归档版本， 4-历史版本';
comment on column ${iol_schema}.rwas_pb_report_approve.operate_dt is '操作时间';
comment on column ${iol_schema}.rwas_pb_report_approve.operate_id is '操作人ID';
comment on column ${iol_schema}.rwas_pb_report_approve.operate_name is '操作人姓名';
comment on column ${iol_schema}.rwas_pb_report_approve.flow_starter_id is '流程发起人ID';
comment on column ${iol_schema}.rwas_pb_report_approve.flow_starter_name is '流程发起人姓名';
comment on column ${iol_schema}.rwas_pb_report_approve.approve_remark is '审批意见';
comment on column ${iol_schema}.rwas_pb_report_approve.catalog_id is '附件目录编号';
comment on column ${iol_schema}.rwas_pb_report_approve.start_dt is '开始时间';
comment on column ${iol_schema}.rwas_pb_report_approve.end_dt is '结束时间';
comment on column ${iol_schema}.rwas_pb_report_approve.id_mark is '增删标志';
comment on column ${iol_schema}.rwas_pb_report_approve.etl_timestamp is 'ETL处理时间戳';
