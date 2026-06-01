/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_dbq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_dbq
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_dbq purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_dbq(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- Internal Unique ID
    ,tmpref varchar2(16) -- 临时申报流水号
    ,ownextkey varchar2(8) -- Initial Entity Code
    ,ver varchar2(4) -- Version
    ,actiontype varchar2(1) -- 操作类型
    ,actiondesc varchar2(132) -- 修改/删除原因
    ,rptno varchar2(22) -- 申报号码
    ,country varchar2(3) -- 收款人常驻国家/地区编码
    ,isref varchar2(1) -- 是否保税货物项下付款
    ,paytype varchar2(1) -- 付款类型
    ,payattr varchar2(1) -- 付汇性质
    ,txcode varchar2(6) -- 交易编码1
    ,tc1amt number(22) -- 相应金额1
    ,txcode2 varchar2(6) -- 交易编码2
    ,tc2amt number(22) -- 相应金额2
    ,impdate date -- 最迟装运日期
    ,contrno varchar2(260) -- 合同号
    ,invoino varchar2(260) -- 发票号
    ,regno varchar2(20) -- 外汇局批件号/备案表号/业务编号
    ,cusmno varchar2(12) -- 报关单经营单位代码
    ,customs varchar2(4000) -- 报关单信息
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
grant select on ${idl_schema}.aml_isbs_dbq to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_dbq is '境内汇款申请书－核销专用信息';
comment on column ${idl_schema}.aml_isbs_dbq.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_dbq.inr is 'Internal Unique ID';
comment on column ${idl_schema}.aml_isbs_dbq.tmpref is '临时申报流水号';
comment on column ${idl_schema}.aml_isbs_dbq.ownextkey is 'Initial Entity Code';
comment on column ${idl_schema}.aml_isbs_dbq.ver is 'Version';
comment on column ${idl_schema}.aml_isbs_dbq.actiontype is '操作类型';
comment on column ${idl_schema}.aml_isbs_dbq.actiondesc is '修改/删除原因';
comment on column ${idl_schema}.aml_isbs_dbq.rptno is '申报号码';
comment on column ${idl_schema}.aml_isbs_dbq.country is '收款人常驻国家/地区编码';
comment on column ${idl_schema}.aml_isbs_dbq.isref is '是否保税货物项下付款';
comment on column ${idl_schema}.aml_isbs_dbq.paytype is '付款类型';
comment on column ${idl_schema}.aml_isbs_dbq.payattr is '付汇性质';
comment on column ${idl_schema}.aml_isbs_dbq.txcode is '交易编码1';
comment on column ${idl_schema}.aml_isbs_dbq.tc1amt is '相应金额1';
comment on column ${idl_schema}.aml_isbs_dbq.txcode2 is '交易编码2';
comment on column ${idl_schema}.aml_isbs_dbq.tc2amt is '相应金额2';
comment on column ${idl_schema}.aml_isbs_dbq.impdate is '最迟装运日期';
comment on column ${idl_schema}.aml_isbs_dbq.contrno is '合同号';
comment on column ${idl_schema}.aml_isbs_dbq.invoino is '发票号';
comment on column ${idl_schema}.aml_isbs_dbq.regno is '外汇局批件号/备案表号/业务编号';
comment on column ${idl_schema}.aml_isbs_dbq.cusmno is '报关单经营单位代码';
comment on column ${idl_schema}.aml_isbs_dbq.customs is '报关单信息';
comment on column ${idl_schema}.aml_isbs_dbq.crtuser is '填报人';
comment on column ${idl_schema}.aml_isbs_dbq.inptelc is '填报人电话';
comment on column ${idl_schema}.aml_isbs_dbq.rptdate is '申报日期';
comment on column ${idl_schema}.aml_isbs_dbq.etl_timestamp is '数据处理时间';
