/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_wrn_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_wrn_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_wrn_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_wrn_details(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,contract_no varchar2(30) -- 合同编号
    ,prod_type varchar2(12) -- 产品编号
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,company varchar2(20) -- 法人
    ,error_desc varchar2(3000) -- 错误描述
    ,seq_no varchar2(50) -- 序号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_close_reason varchar2(300) -- 关闭原因
    ,loan_amt number(17,2) -- 贷款余额
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_batch_wrn_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_wrn_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_wrn_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_wrn_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_wrn_details is '批量核销明细表';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.acct_close_reason is '关闭原因';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.loan_amt is '贷款余额';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_batch_wrn_details.etl_timestamp is 'ETL处理时间戳';
