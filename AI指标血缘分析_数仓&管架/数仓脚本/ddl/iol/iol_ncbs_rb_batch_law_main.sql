/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_law_main
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_law_main
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_law_main purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_law_main(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,prod_type varchar2(12) -- 产品编号
    ,batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,acct_open_date date -- 账户开户日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,iss_country varchar2(3) -- 发证国家
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,actual_bal number(17,2) -- 实际余额
    ,total_amount number(17,2) -- 汇总金额
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
grant select on ${iol_schema}.ncbs_rb_batch_law_main to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_main to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_main to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_law_main to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_law_main is '批量司法查询结果汇总表';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.iss_country is '发证国家';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.actual_bal is '实际余额';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.total_amount is '汇总金额';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_law_main.etl_timestamp is 'ETL处理时间戳';
