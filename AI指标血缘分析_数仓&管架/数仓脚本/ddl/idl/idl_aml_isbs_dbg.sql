/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_dbg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_dbg
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_dbg purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_dbg(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- Internal Unique ID
    ,tmpref varchar2(16) -- 临时申报流水号
    ,ownextkey varchar2(8) -- Initial Entity Code
    ,ver varchar2(4) -- Version
    ,actiontype varchar2(1) -- 操作类型
    ,actiondesc varchar2(132) -- 修改/删除原因
    ,rptno varchar2(22) -- 申报号码
    ,country varchar2(3) -- 付款人常驻国家/地区编码
    ,paytype varchar2(1) -- 收款性质
    ,txcode varchar2(6) -- 交易编码1
    ,tc1amt number(22) -- 相应金额1
    ,txrem varchar2(264) -- 交易附言1
    ,txcode2 varchar2(6) -- 交易编码2
    ,tc2amt number(22) -- 相应金额2
    ,tx2rem varchar2(264) -- 交易附言2
    ,isref varchar2(1) -- 是否保税货物项下收入
    ,billno varchar2(50) -- 外汇局批件号/备案表号/业务编号
    ,crtuser varchar2(20) -- 填报人
    ,inptelc varchar2(20) -- 填报人电话
    ,rptdate date -- 申报日期
    ,payattr varchar2(1) -- 收入类型
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
grant select on ${idl_schema}.aml_isbs_dbg to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_dbg is '涉外收入申报单-申报信息';
comment on column ${idl_schema}.aml_isbs_dbg.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_dbg.inr is 'Internal Unique ID';
comment on column ${idl_schema}.aml_isbs_dbg.tmpref is '临时申报流水号';
comment on column ${idl_schema}.aml_isbs_dbg.ownextkey is 'Initial Entity Code';
comment on column ${idl_schema}.aml_isbs_dbg.ver is 'Version';
comment on column ${idl_schema}.aml_isbs_dbg.actiontype is '操作类型';
comment on column ${idl_schema}.aml_isbs_dbg.actiondesc is '修改/删除原因';
comment on column ${idl_schema}.aml_isbs_dbg.rptno is '申报号码';
comment on column ${idl_schema}.aml_isbs_dbg.country is '付款人常驻国家/地区编码';
comment on column ${idl_schema}.aml_isbs_dbg.paytype is '收款性质';
comment on column ${idl_schema}.aml_isbs_dbg.txcode is '交易编码1';
comment on column ${idl_schema}.aml_isbs_dbg.tc1amt is '相应金额1';
comment on column ${idl_schema}.aml_isbs_dbg.txrem is '交易附言1';
comment on column ${idl_schema}.aml_isbs_dbg.txcode2 is '交易编码2';
comment on column ${idl_schema}.aml_isbs_dbg.tc2amt is '相应金额2';
comment on column ${idl_schema}.aml_isbs_dbg.tx2rem is '交易附言2';
comment on column ${idl_schema}.aml_isbs_dbg.isref is '是否保税货物项下收入';
comment on column ${idl_schema}.aml_isbs_dbg.billno is '外汇局批件号/备案表号/业务编号';
comment on column ${idl_schema}.aml_isbs_dbg.crtuser is '填报人';
comment on column ${idl_schema}.aml_isbs_dbg.inptelc is '填报人电话';
comment on column ${idl_schema}.aml_isbs_dbg.rptdate is '申报日期';
comment on column ${idl_schema}.aml_isbs_dbg.payattr is '收入类型';
comment on column ${idl_schema}.aml_isbs_dbg.etl_timestamp is '数据处理时间';
