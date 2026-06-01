/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_bab_settle
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_bab_settle
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_bab_settle purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_bab_settle(
    acct_seq_no varchar2(5) -- 账户子账号
    ,acct_type varchar2(1) -- 账户类型
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,bab_seq_no varchar2(50) -- 备款序号
    ,bab_status varchar2(1) -- 备款账户状态
    ,company varchar2(20) -- 法人
    ,settle_class varchar2(5) -- 绑定账户类型
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,accept_contract_no varchar2(30) -- 银承合同编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,settle_branch varchar2(12) -- 清算机构
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
grant select on ${iol_schema}.ncbs_rb_bab_settle to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_bab_settle to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_bab_settle to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_bab_settle to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_bab_settle is '银行承兑汇票备款账户表';
comment on column ${iol_schema}.ncbs_rb_bab_settle.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_bab_settle.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_bab_settle.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_bab_settle.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_bab_settle.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_bab_settle.bab_seq_no is '备款序号';
comment on column ${iol_schema}.ncbs_rb_bab_settle.bab_status is '备款账户状态';
comment on column ${iol_schema}.ncbs_rb_bab_settle.company is '法人';
comment on column ${iol_schema}.ncbs_rb_bab_settle.settle_class is '绑定账户类型';
comment on column ${iol_schema}.ncbs_rb_bab_settle.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_bab_settle.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_bab_settle.accept_contract_no is '银承合同编号';
comment on column ${iol_schema}.ncbs_rb_bab_settle.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_bab_settle.settle_branch is '清算机构';
comment on column ${iol_schema}.ncbs_rb_bab_settle.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_bab_settle.etl_timestamp is 'ETL处理时间戳';
