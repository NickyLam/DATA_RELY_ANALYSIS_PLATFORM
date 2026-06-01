/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_acctcredsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_acctcredsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_acctcredsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_acctcredsgmt(
    mcc varchar2(80) -- 授信协议标识码
    ,deptcode varchar2(14) -- 征信机构代码
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,acctcode varchar2(60) -- 账户标识码
    ,rptdate varchar2(19) -- 信息报告日期
    ,create_time varchar2(19) -- 入库时间
    ,cust_no varchar2(64) -- 客户号码
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
grant select on ${iol_schema}.icms_credit_acctcredsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_acctcredsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_acctcredsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_acctcredsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_acctcredsgmt is '个人借贷账户记录-授信额度信息段';
comment on column ${iol_schema}.icms_credit_acctcredsgmt.mcc is '授信协议标识码';
comment on column ${iol_schema}.icms_credit_acctcredsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_acctcredsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_acctcredsgmt.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_credit_acctcredsgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_acctcredsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_acctcredsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_acctcredsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_acctcredsgmt.etl_timestamp is 'ETL处理时间戳';
