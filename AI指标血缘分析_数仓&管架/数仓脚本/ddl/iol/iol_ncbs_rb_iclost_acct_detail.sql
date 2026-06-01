/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_iclost_acct_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_iclost_acct_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_iclost_acct_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_iclost_acct_detail(
    client_no varchar2(16) -- 客户编号
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,job_run_id varchar2(50) -- 批处理任务id
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,tran_file_result varchar2(1) -- 交易返回结果
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cret_base_acct_no varchar2(50) -- 贷方账户
    ,debt_base_acct_no varchar2(50) -- 借方账户
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_iclost_acct_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_iclost_acct_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_iclost_acct_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_iclost_acct_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_iclost_acct_detail is 'ic卡挂失销户到期处理登记簿';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.tran_file_result is '交易返回结果';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.cret_base_acct_no is '贷方账户';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.debt_base_acct_no is '借方账户';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_iclost_acct_detail.etl_timestamp is 'ETL处理时间戳';
