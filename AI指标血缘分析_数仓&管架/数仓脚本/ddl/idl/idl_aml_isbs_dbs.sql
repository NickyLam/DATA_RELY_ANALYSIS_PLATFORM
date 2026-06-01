/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_dbs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_dbs
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_dbs purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_dbs(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- Internal Unique ID
    ,tmpref varchar2(16) -- 临时申报流水号
    ,ownextkey varchar2(8) -- Initial Entity Code
    ,ver varchar2(4) -- Version
    ,actiontype varchar2(1) -- 操作类型
    ,actiondesc varchar2(132) -- 修改/删除原因
    ,rptno varchar2(22) -- 申报号码
    ,country varchar2(3) -- 收款人常驻国家/地区编码
    ,isref varchar2(1) -- 是否保税'物项下付款
    ,paytype varchar2(1) -- 付款类型
    ,payattr varchar2(1) -- 付汇性质
    ,txcode varchar2(6) -- 交易编码1
    ,tc1amt number(22) -- 相应金额1
    ,txcode2 varchar2(6) -- 交易编码2
    ,tc2amt number(22) -- 相应金额2
    ,impdate date -- 最迟装运日期
    ,contrno varchar2(260) -- 合同号
    ,invoino varchar2(260) -- 发票号
    ,billno varchar2(260) -- 提运单号
    ,contamt number(22) -- 合同金额
    ,regno varchar2(20) -- 外汇局批件号/备案表号/业务编号
    ,crtuser varchar2(20) -- 填报人
    ,inptelc varchar2(20) -- 填报人电话
    ,rptdate date -- 申报日期
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
grant select on ${idl_schema}.aml_isbs_dbs to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_dbs is '境内付款/承兑通知书-核销专用信';
comment on column ${idl_schema}.aml_isbs_dbs.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_dbs.inr is 'Internal Unique ID';
comment on column ${idl_schema}.aml_isbs_dbs.tmpref is '临时申报流水号';
comment on column ${idl_schema}.aml_isbs_dbs.ownextkey is 'Initial Entity Code';
comment on column ${idl_schema}.aml_isbs_dbs.ver is 'Version';
comment on column ${idl_schema}.aml_isbs_dbs.actiontype is '操作类型';
comment on column ${idl_schema}.aml_isbs_dbs.actiondesc is '修改/删除原因';
comment on column ${idl_schema}.aml_isbs_dbs.rptno is '申报号码';
comment on column ${idl_schema}.aml_isbs_dbs.country is '收款人常驻国家/地区编码';
comment on column ${idl_schema}.aml_isbs_dbs.isref is '是否保税物项下付款';
comment on column ${idl_schema}.aml_isbs_dbs.paytype is '付款类型';
comment on column ${idl_schema}.aml_isbs_dbs.payattr is '付汇性质';
comment on column ${idl_schema}.aml_isbs_dbs.txcode is '交易编码1';
comment on column ${idl_schema}.aml_isbs_dbs.tc1amt is '相应金额1';
comment on column ${idl_schema}.aml_isbs_dbs.txcode2 is '交易编码2';
comment on column ${idl_schema}.aml_isbs_dbs.tc2amt is '相应金额2';
comment on column ${idl_schema}.aml_isbs_dbs.impdate is '最迟装运日期';
comment on column ${idl_schema}.aml_isbs_dbs.contrno is '合同号';
comment on column ${idl_schema}.aml_isbs_dbs.invoino is '发票号';
comment on column ${idl_schema}.aml_isbs_dbs.billno is '提运单号';
comment on column ${idl_schema}.aml_isbs_dbs.contamt is '合同金额';
comment on column ${idl_schema}.aml_isbs_dbs.regno is '外汇局批件号/备案表号/业务编号';
comment on column ${idl_schema}.aml_isbs_dbs.crtuser is '填报人';
comment on column ${idl_schema}.aml_isbs_dbs.inptelc is '填报人电话';
comment on column ${idl_schema}.aml_isbs_dbs.rptdate is '申报日期';
comment on column ${idl_schema}.aml_isbs_dbs.etl_timestamp is '数据处理时间';
