/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_tk_management_message
CreateDate: 20250724
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_tk_management_message purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_tk_management_message(
serialno varchar2(32) --流水号
,objectno varchar2(64) --对象流水
,asstaskno varchar2(64) --关联任务流水号
,objecttype varchar2(64) --消息大类(crwal：客户风险贷后预警;alc：投贷后检查任务)
,messagetype varchar2(64) --消息小类
,subject varchar2(4000) --消息主题
,content varchar2(4000) --消息主体内容
,inputdate date --登记日期
,datacount number(18) --明细数据行数(对应tk_management_data_detail关联行数)
,etl_dt date --ETL处理日期 
,etl_timestamp timestamp(6) --ETL处理时间戳 

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_tk_management_message to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_tk_management_message is '经营平台推送消息明细表';
comment on column ${idl_schema}.icms_tk_management_message.serialno is '流水号';
comment on column ${idl_schema}.icms_tk_management_message.objectno is '对象流水';
comment on column ${idl_schema}.icms_tk_management_message.asstaskno is '关联任务流水号';
comment on column ${idl_schema}.icms_tk_management_message.objecttype is '消息大类(crwal：客户风险贷后预警;alc：投贷后检查任务)';
comment on column ${idl_schema}.icms_tk_management_message.messagetype is '消息小类';
comment on column ${idl_schema}.icms_tk_management_message.subject is '消息主题';
comment on column ${idl_schema}.icms_tk_management_message.content is '消息主体内容';
comment on column ${idl_schema}.icms_tk_management_message.inputdate is '登记日期';
comment on column ${idl_schema}.icms_tk_management_message.datacount is '明细数据行数(对应tk_management_data_detail关联行数)';
comment on column ${idl_schema}.icms_tk_management_message.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.icms_tk_management_message.etl_timestamp is 'ETL处理时间戳';

