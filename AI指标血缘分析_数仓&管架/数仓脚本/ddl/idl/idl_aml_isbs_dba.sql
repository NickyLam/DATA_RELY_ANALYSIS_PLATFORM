/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_dba
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_dba
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_dba purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_dba(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- Internal Unique ID
    ,tmpref varchar2(16) -- 临时申报流水号
    ,ownextkey varchar2(8) -- Initial Entity Code
    ,ver varchar2(4) -- Version
    ,actiontype varchar2(1) -- 操作类型
    ,actiondesc varchar2(132) -- 修改/删除原因
    ,rptno varchar2(22) -- 申报号码
    ,custype varchar2(1) -- 收款人类型
    ,idcode varchar2(32) -- 个人身份证件号码
    ,custcod varchar2(18) -- 组织机构
    ,custnm varchar2(130) -- 收款人名称
    ,oppuser varchar2(130) -- 付款人名称
    ,txccy varchar2(3) -- 收入款币种
    ,txamt number(22) -- 收入款金额
    ,exrate number(13,8) -- 结汇汇率
    ,lcyamt number(22) -- 结汇金额
    ,lcyacc varchar2(32) -- 人民币帐号/银行卡号
    ,fcyamt number(22) -- 现汇金额
    ,fcyacc varchar2(32) -- 外汇帐号/银行卡号
    ,othamt number(22) -- 其它金额
    ,othacc varchar2(32) -- 其它帐号/银行卡号
    ,methods varchar2(1) -- 结算方式
    ,buscode varchar2(22) -- 银行业务编号
    ,inchargeccy varchar2(3) -- 国内银行扣费币种
    ,inchargeamt number(22) -- 国内银行扣费金额
    ,outchargeccy varchar2(3) -- 国外银行扣费币种
    ,outchargeamt number(22) -- 国外银行扣费金额
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
grant select on ${idl_schema}.aml_isbs_dba to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_dba is '涉外收入申报单-基础信息';
comment on column ${idl_schema}.aml_isbs_dba.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_dba.inr is 'Internal Unique ID';
comment on column ${idl_schema}.aml_isbs_dba.tmpref is '临时申报流水号';
comment on column ${idl_schema}.aml_isbs_dba.ownextkey is 'Initial Entity Code';
comment on column ${idl_schema}.aml_isbs_dba.ver is 'Version';
comment on column ${idl_schema}.aml_isbs_dba.actiontype is '操作类型';
comment on column ${idl_schema}.aml_isbs_dba.actiondesc is '修改/删除原因';
comment on column ${idl_schema}.aml_isbs_dba.rptno is '申报号码';
comment on column ${idl_schema}.aml_isbs_dba.custype is '收款人类型';
comment on column ${idl_schema}.aml_isbs_dba.idcode is '个人身份证件号码';
comment on column ${idl_schema}.aml_isbs_dba.custcod is '组织机构';
comment on column ${idl_schema}.aml_isbs_dba.custnm is '收款人名称';
comment on column ${idl_schema}.aml_isbs_dba.oppuser is '付款人名称';
comment on column ${idl_schema}.aml_isbs_dba.txccy is '收入款币种';
comment on column ${idl_schema}.aml_isbs_dba.txamt is '收入款金额';
comment on column ${idl_schema}.aml_isbs_dba.exrate is '结汇汇率';
comment on column ${idl_schema}.aml_isbs_dba.lcyamt is '结汇金额';
comment on column ${idl_schema}.aml_isbs_dba.lcyacc is '人民币帐号/银行卡号';
comment on column ${idl_schema}.aml_isbs_dba.fcyamt is '现汇金额';
comment on column ${idl_schema}.aml_isbs_dba.fcyacc is '外汇帐号/银行卡号';
comment on column ${idl_schema}.aml_isbs_dba.othamt is '其它金额';
comment on column ${idl_schema}.aml_isbs_dba.othacc is '其它帐号/银行卡号';
comment on column ${idl_schema}.aml_isbs_dba.methods is '结算方式';
comment on column ${idl_schema}.aml_isbs_dba.buscode is '银行业务编号';
comment on column ${idl_schema}.aml_isbs_dba.inchargeccy is '国内银行扣费币种';
comment on column ${idl_schema}.aml_isbs_dba.inchargeamt is '国内银行扣费金额';
comment on column ${idl_schema}.aml_isbs_dba.outchargeccy is '国外银行扣费币种';
comment on column ${idl_schema}.aml_isbs_dba.outchargeamt is '国外银行扣费金额';
comment on column ${idl_schema}.aml_isbs_dba.etl_timestamp is '数据处理时间';
