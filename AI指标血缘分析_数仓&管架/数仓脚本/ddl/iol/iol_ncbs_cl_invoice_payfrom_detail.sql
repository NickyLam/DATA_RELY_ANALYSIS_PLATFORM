/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_invoice_payfrom_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_invoice_payfrom_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_invoice_payfrom_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_invoice_payfrom_detail(
    amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,invoice_tran_no varchar2(50) -- 通知单号
    ,pay_from_seq_no varchar2(50) -- 应还明细序号
    ,last_change_date date -- 最后修改日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,pay_from_amt number(17,2) -- 账户应还金额
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_internal_key number(15) -- 结算账户标志符
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
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
grant select on ${iol_schema}.ncbs_cl_invoice_payfrom_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_invoice_payfrom_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_invoice_payfrom_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_invoice_payfrom_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_invoice_payfrom_detail is '单据应还明细表';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.invoice_tran_no is '通知单号';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.pay_from_seq_no is '应还明细序号';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.pay_from_amt is '账户应还金额';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.settle_acct_internal_key is '结算账户标志符';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_invoice_payfrom_detail.etl_timestamp is 'ETL处理时间戳';
