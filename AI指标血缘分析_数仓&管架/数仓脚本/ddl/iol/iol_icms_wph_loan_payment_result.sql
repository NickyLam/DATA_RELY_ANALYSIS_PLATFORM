/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_loan_payment_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_loan_payment_result
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_loan_payment_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_loan_payment_result(
    reference varchar2(50) -- 交易参考号
    ,internalkey varchar2(50) -- 借据号
    ,acctname varchar2(200) -- 银行账户的开户人名称
    ,bankname varchar2(200) -- 银行账户的开户行名称
    ,acctno varchar2(150) -- 银行账户账号
    ,paytime date -- 贷款到账时间
    ,payinstreqno varchar2(150) -- 清算交易编号
    ,inputdate date -- 登记日期
    ,bizdate varchar2(10) -- 流程日期
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
grant select on ${iol_schema}.icms_wph_loan_payment_result to ${iml_schema};
grant select on ${iol_schema}.icms_wph_loan_payment_result to ${icl_schema};
grant select on ${iol_schema}.icms_wph_loan_payment_result to ${idl_schema};
grant select on ${iol_schema}.icms_wph_loan_payment_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_loan_payment_result is '唯品消金放款支付结果表';
comment on column ${iol_schema}.icms_wph_loan_payment_result.reference is '交易参考号';
comment on column ${iol_schema}.icms_wph_loan_payment_result.internalkey is '借据号';
comment on column ${iol_schema}.icms_wph_loan_payment_result.acctname is '银行账户的开户人名称';
comment on column ${iol_schema}.icms_wph_loan_payment_result.bankname is '银行账户的开户行名称';
comment on column ${iol_schema}.icms_wph_loan_payment_result.acctno is '银行账户账号';
comment on column ${iol_schema}.icms_wph_loan_payment_result.paytime is '贷款到账时间';
comment on column ${iol_schema}.icms_wph_loan_payment_result.payinstreqno is '清算交易编号';
comment on column ${iol_schema}.icms_wph_loan_payment_result.inputdate is '登记日期';
comment on column ${iol_schema}.icms_wph_loan_payment_result.bizdate is '流程日期';
comment on column ${iol_schema}.icms_wph_loan_payment_result.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wph_loan_payment_result.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wph_loan_payment_result.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wph_loan_payment_result.etl_timestamp is 'ETL处理时间戳';
