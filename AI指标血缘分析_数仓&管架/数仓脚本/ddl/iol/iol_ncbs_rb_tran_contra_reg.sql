/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_tran_contra_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_tran_contra_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_tran_contra_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tran_contra_reg(
    seq_no varchar2(100) -- 序号
    ,reference varchar2(100) -- 交易参考号
    ,channel_seq_no varchar2(66) -- 全局流水号
    ,sub_seq_no varchar2(200) -- 系统子流水号
    ,oth_real_base_acct_no varchar2(100) -- 真实交易对手账号
    ,oth_real_tran_name varchar2(400) -- 真实交易对手名称
    ,contra_bank_code varchar2(60) -- 交易对手行号
    ,tran_amt number(17,2) -- 交易金额
    ,oth_real_acct_seq_no varchar2(10) -- 真实交易对手账户序号
    ,register_seq_no number(5) -- 补录子序号
    ,tran_timestamp varchar2(52) -- 交易时间戳
    ,company varchar2(40) -- 法人
    ,source_module varchar2(6) -- 源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
    ,contra_bank_name varchar2(100) -- 真实对手行名
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
grant select on ${iol_schema}.ncbs_rb_tran_contra_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_tran_contra_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_contra_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_contra_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_tran_contra_reg is '真实交易对手登记簿';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.sub_seq_no is '系统子流水号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.oth_real_base_acct_no is '真实交易对手账号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.oth_real_tran_name is '真实交易对手名称';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.contra_bank_code is '交易对手行号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.oth_real_acct_seq_no is '真实交易对手账户序号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.register_seq_no is '补录子序号';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.company is '法人';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.source_module is '源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.contra_bank_name is '真实对手行名';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_tran_contra_reg.etl_timestamp is 'ETL处理时间戳';
