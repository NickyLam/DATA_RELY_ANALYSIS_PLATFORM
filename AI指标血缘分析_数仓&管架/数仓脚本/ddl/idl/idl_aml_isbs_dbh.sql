/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_dbh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_dbh
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_dbh purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_dbh(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- Internal Unique ID
    ,tmpref varchar2(16) -- 临时申报流水号
    ,ownextkey varchar2(8) -- Initial Entity Code
    ,ver varchar2(4) -- Version
    ,actiontype varchar2(1) -- 操作类型
    ,actiondesc varchar2(132) -- 修改/删除原因
    ,rptno varchar2(22) -- 申报号码
    ,country varchar2(3) -- 收款人常驻国家/地区编码
    ,paytype varchar2(1) -- 付款类型
    ,txcode varchar2(6) -- 交易编码1
    ,tc1amt number(22) -- 相应金额1
    ,txrem varchar2(264) -- 交易附言1
    ,txcode2 varchar2(6) -- 交易编码2
    ,tc2amt number(22) -- 相应金额2
    ,tx2rem varchar2(264) -- 交易附言2
    ,isref varchar2(1) -- 是否保税货物项下收入
    ,crtuser varchar2(20) -- 申请人
    ,inptelc varchar2(20) -- 申请人电话
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
grant select on ${idl_schema}.aml_isbs_dbh to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_dbh is '境外汇款申请书-申报信息';
comment on column ${idl_schema}.aml_isbs_dbh.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_dbh.inr is 'Internal Unique ID';
comment on column ${idl_schema}.aml_isbs_dbh.tmpref is '临时申报流水号';
comment on column ${idl_schema}.aml_isbs_dbh.ownextkey is 'Initial Entity Code';
comment on column ${idl_schema}.aml_isbs_dbh.ver is 'Version';
comment on column ${idl_schema}.aml_isbs_dbh.actiontype is '操作类型';
comment on column ${idl_schema}.aml_isbs_dbh.actiondesc is '修改/删除原因';
comment on column ${idl_schema}.aml_isbs_dbh.rptno is '申报号码';
comment on column ${idl_schema}.aml_isbs_dbh.country is '收款人常驻国家/地区编码';
comment on column ${idl_schema}.aml_isbs_dbh.paytype is '付款类型';
comment on column ${idl_schema}.aml_isbs_dbh.txcode is '交易编码1';
comment on column ${idl_schema}.aml_isbs_dbh.tc1amt is '相应金额1';
comment on column ${idl_schema}.aml_isbs_dbh.txrem is '交易附言1';
comment on column ${idl_schema}.aml_isbs_dbh.txcode2 is '交易编码2';
comment on column ${idl_schema}.aml_isbs_dbh.tc2amt is '相应金额2';
comment on column ${idl_schema}.aml_isbs_dbh.tx2rem is '交易附言2';
comment on column ${idl_schema}.aml_isbs_dbh.isref is '是否保税货物项下收入';
comment on column ${idl_schema}.aml_isbs_dbh.crtuser is '申请人';
comment on column ${idl_schema}.aml_isbs_dbh.inptelc is '申请人电话';
comment on column ${idl_schema}.aml_isbs_dbh.rptdate is '申报日期';
comment on column ${idl_schema}.aml_isbs_dbh.regno is '外汇局批件号/备案表号/业务编号';
comment on column ${idl_schema}.aml_isbs_dbh.etl_timestamp is '数据处理时间';
