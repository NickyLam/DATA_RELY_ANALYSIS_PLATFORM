/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_payment_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_payment_account
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_payment_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_payment_account(
    assetid varchar2(64) -- 资产号
    ,capitalloanno varchar2(64) -- 借据号
    ,stageno varchar2(20) -- 期数
    ,porintreceipttime varchar2(20) -- 本息回收时间
    ,settlementtradeno varchar2(200) -- 清算交易编号
    ,repaymentacctype varchar2(60) -- 还款账户类型
    ,repayacctno varchar2(200) -- 还款账户编号
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_lx_payment_account to ${iml_schema};
grant select on ${iol_schema}.icms_lx_payment_account to ${icl_schema};
grant select on ${iol_schema}.icms_lx_payment_account to ${idl_schema};
grant select on ${iol_schema}.icms_lx_payment_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_payment_account is '乐信还款监管表';
comment on column ${iol_schema}.icms_lx_payment_account.assetid is '资产号';
comment on column ${iol_schema}.icms_lx_payment_account.capitalloanno is '借据号';
comment on column ${iol_schema}.icms_lx_payment_account.stageno is '期数';
comment on column ${iol_schema}.icms_lx_payment_account.porintreceipttime is '本息回收时间';
comment on column ${iol_schema}.icms_lx_payment_account.settlementtradeno is '清算交易编号';
comment on column ${iol_schema}.icms_lx_payment_account.repaymentacctype is '还款账户类型';
comment on column ${iol_schema}.icms_lx_payment_account.repayacctno is '还款账户编号';
comment on column ${iol_schema}.icms_lx_payment_account.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_payment_account.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_payment_account.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lx_payment_account.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_payment_account.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_payment_account.updatedate is '更新日期';
comment on column ${iol_schema}.icms_lx_payment_account.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lx_payment_account.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lx_payment_account.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lx_payment_account.etl_timestamp is 'ETL处理时间戳';
