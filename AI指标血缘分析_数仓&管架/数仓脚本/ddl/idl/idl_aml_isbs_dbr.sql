/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_dbr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_dbr
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_dbr purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_dbr(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- Internal Unique ID
    ,tmpref varchar2(16) -- 临时申报流水号
    ,ownextkey varchar2(8) -- Initial Entity Code
    ,ver varchar2(4) -- Version
    ,actiontype varchar2(1) -- 操作类型
    ,actiondesc varchar2(132) -- 修改/删除原因
    ,rptno varchar2(22) -- 申报号码
    ,isref varchar2(1) -- 是否保税货物项下付款
    ,payattr varchar2(1) -- 收入类型
    ,paytype varchar2(1) -- 收款性质
    ,txcode varchar2(6) -- 交易编码1
    ,tc1amt number(22) -- 相应金额1
    ,txrem varchar2(264) -- 交易附言1
    ,txcode2 varchar2(6) -- 交易编码2
    ,tc2amt number(22) -- 相应金额2
    ,tx2rem varchar2(264) -- 交易附言2
    ,refnos varchar2(4000) -- 出口收汇核销单号码
    ,chkamt number(22) -- 收汇总金额中用于出口核销的金额
    ,crtuser varchar2(20) -- 填报人
    ,inptelc varchar2(20) -- 填报人电话
    ,rptdate date -- 申报日期
    ,regno varchar2(20) -- 外汇局批件号/备案表号/业务编号
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_isbs_dbr to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_dbr is '出口收汇核销专用联（境内收入）-核销专用信息';
comment on column ${idl_schema}.aml_isbs_dbr.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_dbr.inr is 'Internal Unique ID';
comment on column ${idl_schema}.aml_isbs_dbr.tmpref is '临时申报流水号';
comment on column ${idl_schema}.aml_isbs_dbr.ownextkey is 'Initial Entity Code';
comment on column ${idl_schema}.aml_isbs_dbr.ver is 'Version';
comment on column ${idl_schema}.aml_isbs_dbr.actiontype is '操作类型';
comment on column ${idl_schema}.aml_isbs_dbr.actiondesc is '修改/删除原因';
comment on column ${idl_schema}.aml_isbs_dbr.rptno is '申报号码';
comment on column ${idl_schema}.aml_isbs_dbr.isref is '是否保税货物项下付款';
comment on column ${idl_schema}.aml_isbs_dbr.payattr is '收入类型';
comment on column ${idl_schema}.aml_isbs_dbr.paytype is '收款性质';
comment on column ${idl_schema}.aml_isbs_dbr.txcode is '交易编码1';
comment on column ${idl_schema}.aml_isbs_dbr.tc1amt is '相应金额1';
comment on column ${idl_schema}.aml_isbs_dbr.txrem is '交易附言1';
comment on column ${idl_schema}.aml_isbs_dbr.txcode2 is '交易编码2';
comment on column ${idl_schema}.aml_isbs_dbr.tc2amt is '相应金额2';
comment on column ${idl_schema}.aml_isbs_dbr.tx2rem is '交易附言2';
comment on column ${idl_schema}.aml_isbs_dbr.refnos is '出口收汇核销单号码';
comment on column ${idl_schema}.aml_isbs_dbr.chkamt is '收汇总金额中用于出口核销的金额';
comment on column ${idl_schema}.aml_isbs_dbr.crtuser is '填报人';
comment on column ${idl_schema}.aml_isbs_dbr.inptelc is '填报人电话';
comment on column ${idl_schema}.aml_isbs_dbr.rptdate is '申报日期';
comment on column ${idl_schema}.aml_isbs_dbr.regno is '外汇局批件号/备案表号/业务编号';
comment on column ${idl_schema}.aml_isbs_dbr.etl_timestamp is '数据处理时间';
