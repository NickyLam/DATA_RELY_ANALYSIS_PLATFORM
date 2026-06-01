/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_dbe
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_dbe
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_dbe purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_dbe(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- Internal Unique ID
    ,tmpref varchar2(16) -- 临时申报流水号
    ,ownextkey varchar2(8) -- Initial Entity Code
    ,ver varchar2(4) -- Version
    ,actiontype varchar2(1) -- 操作类型
    ,actiondesc varchar2(132) -- 修改/删除原因
    ,rptno varchar2(22) -- 申报号码
    ,custype varchar2(1) -- 汇款人类型
    ,idcode varchar2(32) -- 个人身份证件号码
    ,custcod varchar2(18) -- 组织机构
    ,custnm varchar2(130) -- 汇款人名称
    ,oppuser varchar2(130) -- 收款人名称
    ,txccy varchar2(3) -- 汇款币种
    ,txamt number(22) -- 汇款金额
    ,exrate number(13,8) -- 汇汇率
    ,lcyamt number(22) -- 汇金额
    ,lcyacc varchar2(32) -- 人民币帐号/银行卡号
    ,fcyamt number(22) -- 现汇金额
    ,fcyacc varchar2(32) -- 外汇帐号/银行卡号
    ,othamt number(22) -- 其它金额
    ,othacc varchar2(32) -- 其它帐号/银行卡号
    ,methods varchar2(1) -- 结算方式
    ,buscode varchar2(22) -- 银行业务编号
    ,oppacc varchar2(32) -- 收款人帐号
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
grant select on ${idl_schema}.aml_isbs_dbe to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_dbe is '境内汇款申请书-基础信息';
comment on column ${idl_schema}.aml_isbs_dbe.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_dbe.inr is 'Internal Unique ID';
comment on column ${idl_schema}.aml_isbs_dbe.tmpref is '临时申报流水号';
comment on column ${idl_schema}.aml_isbs_dbe.ownextkey is 'Initial Entity Code';
comment on column ${idl_schema}.aml_isbs_dbe.ver is 'Version';
comment on column ${idl_schema}.aml_isbs_dbe.actiontype is '操作类型';
comment on column ${idl_schema}.aml_isbs_dbe.actiondesc is '修改/删除原因';
comment on column ${idl_schema}.aml_isbs_dbe.rptno is '申报号码';
comment on column ${idl_schema}.aml_isbs_dbe.custype is '汇款人类型';
comment on column ${idl_schema}.aml_isbs_dbe.idcode is '个人身份证件号码';
comment on column ${idl_schema}.aml_isbs_dbe.custcod is '组织机构';
comment on column ${idl_schema}.aml_isbs_dbe.custnm is '汇款人名称';
comment on column ${idl_schema}.aml_isbs_dbe.oppuser is '收款人名称';
comment on column ${idl_schema}.aml_isbs_dbe.txccy is '汇款币种';
comment on column ${idl_schema}.aml_isbs_dbe.txamt is '汇款金额';
comment on column ${idl_schema}.aml_isbs_dbe.exrate is '汇汇率';
comment on column ${idl_schema}.aml_isbs_dbe.lcyamt is '汇金额';
comment on column ${idl_schema}.aml_isbs_dbe.lcyacc is '人民币帐号/银行卡号';
comment on column ${idl_schema}.aml_isbs_dbe.fcyamt is '现汇金额';
comment on column ${idl_schema}.aml_isbs_dbe.fcyacc is '外汇帐号/银行卡号';
comment on column ${idl_schema}.aml_isbs_dbe.othamt is '其它金额';
comment on column ${idl_schema}.aml_isbs_dbe.othacc is '其它帐号/银行卡号';
comment on column ${idl_schema}.aml_isbs_dbe.methods is '结算方式';
comment on column ${idl_schema}.aml_isbs_dbe.buscode is '银行业务编号';
comment on column ${idl_schema}.aml_isbs_dbe.oppacc is '收款人帐号';
comment on column ${idl_schema}.aml_isbs_dbe.etl_timestamp is '数据处理时间';
