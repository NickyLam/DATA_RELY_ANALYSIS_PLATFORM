/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_tk_management_info
CreateDate: 20241105
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_tk_management_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_tk_management_info(
serialno varchar2(32) --流水号
,batchdate varchar2(8) --批次日期
,userid varchar2(2000) --推送用户编号
,userdomainid varchar2(2000) --推送用户域账号
,customerid varchar2(32) --客户号
,customername varchar2(200) --客户名称
,inputdate date --登记日期
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
grant select on ${idl_schema}.icms_tk_management_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_tk_management_info is '经营平台推送消息主表';
comment on column ${idl_schema}.icms_tk_management_info.serialno is '流水号';
comment on column ${idl_schema}.icms_tk_management_info.batchdate is '批次日期';
comment on column ${idl_schema}.icms_tk_management_info.userid is '推送用户编号';
comment on column ${idl_schema}.icms_tk_management_info.userdomainid is '推送用户域账号';
comment on column ${idl_schema}.icms_tk_management_info.customerid is '客户号';
comment on column ${idl_schema}.icms_tk_management_info.customername is '客户名称';
comment on column ${idl_schema}.icms_tk_management_info.inputdate is '登记日期';
comment on column ${idl_schema}.icms_tk_management_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.icms_tk_management_info.etl_timestamp is 'ETL处理时间戳';
