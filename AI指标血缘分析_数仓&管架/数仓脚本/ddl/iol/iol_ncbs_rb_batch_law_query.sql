/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_law_query
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_law_query
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_law_query purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_law_query(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,job_run_id varchar2(50) -- 批处理任务id
    ,law_query_status varchar2(1) -- 司法查询状态
    ,query_type varchar2(10) -- 查询类型
    ,ret_msg varchar2(3000) -- 服务状态描述
    ,seq_no varchar2(50) -- 序号
    ,status varchar2(1) -- 状态
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,iss_country varchar2(3) -- 发证国家
    ,details_seq_no varchar2(50) -- 明细序号
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
grant select on ${iol_schema}.ncbs_rb_batch_law_query to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_query to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_query to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_query to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_law_query is '批量司法查询明细表';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.law_query_status is '司法查询状态';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.query_type is '查询类型';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.status is '状态';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.iss_country is '发证国家';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.details_seq_no is '明细序号';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_law_query.etl_timestamp is 'ETL处理时间戳';
