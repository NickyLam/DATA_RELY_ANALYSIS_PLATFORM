/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_payment_transaction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_payment_transaction
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_payment_transaction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_payment_transaction(
    trandate varchar2(10) -- 交易日期
    ,receiptno varchar2(50) -- 回收号
    ,reference varchar2(50) -- 交易参考号
    ,internalkey varchar2(50) -- 借据号
    ,prodtype varchar2(50) -- 产品类型
    ,receipttype varchar2(10) -- 回收类型
    ,receiptgencode varchar2(4) -- 回收产生方式
    ,ccy varchar2(3) -- 币种
    ,recamt number(17,2) -- 回收金额
    ,actrepaydate varchar2(10) -- 实际还款日期
    ,feeamt number(17,2) -- 服务费金额
    ,inputdate date -- 登记日期
    ,bizdate varchar2(10) -- 流程日期
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
grant select on ${iol_schema}.icms_wph_payment_transaction to ${iml_schema};
grant select on ${iol_schema}.icms_wph_payment_transaction to ${icl_schema};
grant select on ${iol_schema}.icms_wph_payment_transaction to ${idl_schema};
grant select on ${iol_schema}.icms_wph_payment_transaction to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_payment_transaction is '唯品消金还款流水表';
comment on column ${iol_schema}.icms_wph_payment_transaction.trandate is '交易日期';
comment on column ${iol_schema}.icms_wph_payment_transaction.receiptno is '回收号';
comment on column ${iol_schema}.icms_wph_payment_transaction.reference is '交易参考号';
comment on column ${iol_schema}.icms_wph_payment_transaction.internalkey is '借据号';
comment on column ${iol_schema}.icms_wph_payment_transaction.prodtype is '产品类型';
comment on column ${iol_schema}.icms_wph_payment_transaction.receipttype is '回收类型';
comment on column ${iol_schema}.icms_wph_payment_transaction.receiptgencode is '回收产生方式';
comment on column ${iol_schema}.icms_wph_payment_transaction.ccy is '币种';
comment on column ${iol_schema}.icms_wph_payment_transaction.recamt is '回收金额';
comment on column ${iol_schema}.icms_wph_payment_transaction.actrepaydate is '实际还款日期';
comment on column ${iol_schema}.icms_wph_payment_transaction.feeamt is '服务费金额';
comment on column ${iol_schema}.icms_wph_payment_transaction.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_payment_transaction.bizdate is '流程日期';
comment on column ${iol_schema}.icms_wph_payment_transaction.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wph_payment_transaction.etl_timestamp is 'ETL处理时间戳';
