/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_transfer_receipt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_transfer_receipt
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_transfer_receipt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_receipt(
    amt_type varchar2(10) -- 金额类型
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,invoice_tran_no varchar2(50) -- 通知单号
    ,receipt_no varchar2(50) -- 回收号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,rec_amt number(17,2) -- 回收金额(指回收的本金)
    ,trust_rec_amt number(17,2) -- 信托实际回收金额
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
grant select on ${iol_schema}.ncbs_cl_transfer_receipt to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_receipt to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_receipt to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_receipt to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_transfer_receipt is '资产证券化回收信息表';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.company is '法人';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.invoice_tran_no is '通知单号';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.receipt_no is '回收号';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.rec_amt is '回收金额(指回收的本金)';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.trust_rec_amt is '信托实际回收金额';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_transfer_receipt.etl_timestamp is 'ETL处理时间戳';
