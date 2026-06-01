/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_tran_contra_reg_sp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_tran_contra_reg_sp
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_tran_contra_reg_sp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tran_contra_reg_sp(
    seq_no varchar2(50) -- 序号
    ,reference varchar2(50) -- 交易参考号
    ,tran_date date -- 交易日期
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,sub_seq_no varchar2(100) -- 系统子流水号
    ,reg_seq_no number(10,0) -- 补录子序号
    ,oth_real_base_acct_no varchar2(50) -- 真实交易对手账号
    ,oth_real_tran_name varchar2(200) -- 真实交易对手名称
    ,contra_bank_code varchar2(30) -- 交易对手行号
    ,contra_bank_name varchar2(100) -- 对手行名
    ,oth_real_acct_seq_no varchar2(5) -- 真实交易对手账户序号
    ,oth_internal_key number(15,0) -- 对手账户内部键
    ,tran_amt number(17,2) -- 交易金额
    ,source_module varchar2(3) -- 源模块
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
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
grant select on ${iol_schema}.ncbs_rb_tran_contra_reg_sp to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_tran_contra_reg_sp to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_contra_reg_sp to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_contra_reg_sp to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_tran_contra_reg_sp is '新真实交易对手登记簿';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.sub_seq_no is '系统子流水号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.reg_seq_no is '补录子序号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.oth_real_base_acct_no is '真实交易对手账号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.oth_real_tran_name is '真实交易对手名称';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.contra_bank_code is '交易对手行号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.contra_bank_name is '对手行名';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.oth_real_acct_seq_no is '真实交易对手账户序号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.company is '法人';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg_sp.etl_timestamp is 'ETL处理时间戳';
