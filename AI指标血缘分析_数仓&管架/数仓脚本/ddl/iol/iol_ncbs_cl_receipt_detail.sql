/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_receipt_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_receipt_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_receipt_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_receipt_detail(
    amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,invoice_tran_no varchar2(50) -- 通知单号
    ,rec_xrate_id varchar2(1) -- 回收汇兑方式
    ,receipt_no varchar2(50) -- 回收号
    ,stage_no number(5) -- 期次
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,rec_amt number(17,2) -- 回收金额(指回收的本金)
    ,rec_ccy varchar2(3) -- 回收币种
    ,rec_xrate number(15,8) -- 回收对人民币汇率
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
grant select on ${iol_schema}.ncbs_cl_receipt_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_receipt_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_receipt_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_receipt_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_receipt_detail is '回收明细表';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.invoice_tran_no is '通知单号';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.rec_xrate_id is '回收汇兑方式';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.receipt_no is '回收号';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.stage_no is '期次';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.rec_amt is '回收金额(指回收的本金)';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.rec_ccy is '回收币种';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.rec_xrate is '回收对人民币汇率';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_receipt_detail.etl_timestamp is 'ETL处理时间戳';
