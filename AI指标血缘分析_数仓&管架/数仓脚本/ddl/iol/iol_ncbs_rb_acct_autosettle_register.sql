/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_autosettle_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_autosettle_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_autosettle_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_autosettle_register(
    acct_seq_no varchar2(5) -- 账户子账号
    ,acct_type varchar2(1) -- 账户类型
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,auto_settle_result varchar2(1) -- 结清结果
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,settle_date date -- 结算日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,ch_client_name varchar2(200) -- 客户中文名称
    ,failure_reason varchar2(200) -- 失败原因
    ,int_amt number(17,2) -- 利息金额
    ,pri_amt number(17,2) -- 本金金额
    ,settle_acct_no varchar2(50) -- 人行清算账户
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_amt number(17,2) -- 结算金额
    ,settle_ccy varchar2(3) -- 结算币种
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
grant select on ${iol_schema}.ncbs_rb_acct_autosettle_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_autosettle_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_autosettle_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_autosettle_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_autosettle_register is '到期自动结清登记簿';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.auto_settle_result is '结清结果';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.settle_date is '结算日期';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.ch_client_name is '客户中文名称';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.failure_reason is '失败原因';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.pri_amt is '本金金额';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.settle_acct_no is '人行清算账户';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.settle_amt is '结算金额';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.settle_ccy is '结算币种';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_autosettle_register.etl_timestamp is 'ETL处理时间戳';
