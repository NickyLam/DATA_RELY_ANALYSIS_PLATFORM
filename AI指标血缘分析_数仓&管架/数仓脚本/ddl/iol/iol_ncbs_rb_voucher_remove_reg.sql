/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_voucher_remove_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_voucher_remove_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_voucher_remove_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_voucher_remove_reg(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,company varchar2(20) -- 法人
    ,medium_remove_flag varchar2(1) -- 质押是否去介质
    ,prefix varchar2(10) -- 前缀
    ,reg_status varchar2(1) -- 去介质登记状态
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_voucher_remove_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_remove_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_remove_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_remove_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_voucher_remove_reg is '质押去介质预登记表';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.company is '法人';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.medium_remove_flag is '质押是否去介质';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.reg_status is '去介质登记状态';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_voucher_remove_reg.etl_timestamp is 'ETL处理时间戳';
