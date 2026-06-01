/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_bab_bill_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_bab_bill_dtl
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_bab_bill_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_bab_bill_dtl(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,advance_flag varchar2(1) -- 贷款垫款标志
    ,bab_flag varchar2(1) -- 备款信息标识
    ,company varchar2(20) -- 法人
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accept_contract_no varchar2(30) -- 银承合同编号
    ,advance_reference varchar2(50) -- 垫款交易流水
    ,available_amt number(17,2) -- 可用余额
    ,bill_total_amt number(17,2) -- 票面总金额
    ,impound_amt number(17,2) -- 扣划金额
    ,impound_total_amt number(17,2) -- 扣划总金额
    ,int_amt number(17,2) -- 利息金额
    ,preterm_amt number(17,2) -- 本金
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
grant select on ${iol_schema}.ncbs_rb_bab_bill_dtl to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_bab_bill_dtl to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_bab_bill_dtl to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_bab_bill_dtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_bab_bill_dtl is '银行承兑汇票票据备款信息表';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.advance_flag is '贷款垫款标志';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.bab_flag is '备款信息标识';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.company is '法人';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.accept_contract_no is '银承合同编号';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.advance_reference is '垫款交易流水';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.available_amt is '可用余额';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.bill_total_amt is '票面总金额';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.impound_amt is '扣划金额';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.impound_total_amt is '扣划总金额';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.preterm_amt is '本金';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_bab_bill_dtl.etl_timestamp is 'ETL处理时间戳';
