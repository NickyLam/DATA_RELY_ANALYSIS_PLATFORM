/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_operation_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_operation_log
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_operation_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_operation_log(
    serialno varchar2(64) -- 流水号
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,action varchar2(64) -- 调整动作
    ,inputorgid varchar2(64) -- 登记机构
    ,creditno varchar2(64) -- 额度编号
    ,reason varchar2(1000) -- 调整原因
    ,updateuserid varchar2(64) -- 更新人
    ,inputuserid varchar2(64) -- 登记人
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
grant select on ${iol_schema}.icms_cl_operation_log to ${iml_schema};
grant select on ${iol_schema}.icms_cl_operation_log to ${icl_schema};
grant select on ${iol_schema}.icms_cl_operation_log to ${idl_schema};
grant select on ${iol_schema}.icms_cl_operation_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_operation_log is '额度调整记录表额度调整记录表';
comment on column ${iol_schema}.icms_cl_operation_log.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_operation_log.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_operation_log.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_cl_operation_log.updatedate is '更新日期';
comment on column ${iol_schema}.icms_cl_operation_log.action is '调整动作';
comment on column ${iol_schema}.icms_cl_operation_log.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_operation_log.creditno is '额度编号';
comment on column ${iol_schema}.icms_cl_operation_log.reason is '调整原因';
comment on column ${iol_schema}.icms_cl_operation_log.updateuserid is '更新人';
comment on column ${iol_schema}.icms_cl_operation_log.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_operation_log.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cl_operation_log.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cl_operation_log.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cl_operation_log.etl_timestamp is 'ETL处理时间戳';
