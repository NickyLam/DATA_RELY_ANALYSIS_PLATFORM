/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_cfck_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_cfck_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_cfck_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_cfck_info(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,reference varchar2(50) -- 交易参考号
    ,bank_flag varchar2(1) -- 是否为银行
    ,company varchar2(20) -- 法人
    ,imp_seq_no varchar2(50) -- 强制扣划序列号
    ,int_flag varchar2(1) -- 是否扣划利息标志
    ,law_no varchar2(150) -- 法律文书号
    ,narrative varchar2(400) -- 摘要
    ,remain_amt_status varchar2(1) -- 剩余金额处理状态
    ,source_type varchar2(6) -- 渠道编号
    ,imp_date date -- 扣划日期
    ,imp_time varchar2(26) -- 扣划时间
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,actual_amt number(17,2) -- 实际金额
    ,cr_acct_name varchar2(200) -- 贷方户名
    ,cr_acct_type varchar2(1) -- 收款账户类型（行内账户）
    ,cr_bank_code varchar2(20) -- 行号（他行账户）
    ,cr_bank_name varchar2(100) -- 行名（他行账户）
    ,cr_base_acct_no varchar2(50) -- 贷方账号
    ,imp_acct_no varchar2(50) -- 扣划账号
    ,imp_acct_type varchar2(1) -- 扣划账户类型
    ,imp_ccy varchar2(3) -- 扣划币种
    ,imp_int number(17,2) -- 扣划金额的提前支取利息(预留)
    ,imp_internal_key number(15) -- 扣划账户主键
    ,imp_rate number(15,8) -- 扣划金额的提前支取利率(预留)
    ,impound_amt number(17,2) -- 扣划金额
    ,int_amt number(17,2) -- 利息金额
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_internal_key number(15) -- 客户活期结算账户主键
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
grant select on ${iol_schema}.ncbs_rb_cfck_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_cfck_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_cfck_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_cfck_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_cfck_info is '司法查控强制扣划剩余本金及利息表';
comment on column ${iol_schema}.ncbs_rb_cfck_info.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_cfck_info.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_cfck_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_cfck_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_cfck_info.bank_flag is '是否为银行';
comment on column ${iol_schema}.ncbs_rb_cfck_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_cfck_info.imp_seq_no is '强制扣划序列号';
comment on column ${iol_schema}.ncbs_rb_cfck_info.int_flag is '是否扣划利息标志';
comment on column ${iol_schema}.ncbs_rb_cfck_info.law_no is '法律文书号';
comment on column ${iol_schema}.ncbs_rb_cfck_info.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_cfck_info.remain_amt_status is '剩余金额处理状态';
comment on column ${iol_schema}.ncbs_rb_cfck_info.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_cfck_info.imp_date is '扣划日期';
comment on column ${iol_schema}.ncbs_rb_cfck_info.imp_time is '扣划时间';
comment on column ${iol_schema}.ncbs_rb_cfck_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_cfck_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_cfck_info.actual_amt is '实际金额';
comment on column ${iol_schema}.ncbs_rb_cfck_info.cr_acct_name is '贷方户名';
comment on column ${iol_schema}.ncbs_rb_cfck_info.cr_acct_type is '收款账户类型（行内账户）';
comment on column ${iol_schema}.ncbs_rb_cfck_info.cr_bank_code is '行号（他行账户）';
comment on column ${iol_schema}.ncbs_rb_cfck_info.cr_bank_name is '行名（他行账户）';
comment on column ${iol_schema}.ncbs_rb_cfck_info.cr_base_acct_no is '贷方账号';
comment on column ${iol_schema}.ncbs_rb_cfck_info.imp_acct_no is '扣划账号';
comment on column ${iol_schema}.ncbs_rb_cfck_info.imp_acct_type is '扣划账户类型';
comment on column ${iol_schema}.ncbs_rb_cfck_info.imp_ccy is '扣划币种';
comment on column ${iol_schema}.ncbs_rb_cfck_info.imp_int is '扣划金额的提前支取利息(预留)';
comment on column ${iol_schema}.ncbs_rb_cfck_info.imp_internal_key is '扣划账户主键';
comment on column ${iol_schema}.ncbs_rb_cfck_info.imp_rate is '扣划金额的提前支取利率(预留)';
comment on column ${iol_schema}.ncbs_rb_cfck_info.impound_amt is '扣划金额';
comment on column ${iol_schema}.ncbs_rb_cfck_info.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_cfck_info.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_cfck_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_cfck_info.tran_internal_key is '客户活期结算账户主键';
comment on column ${iol_schema}.ncbs_rb_cfck_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_cfck_info.etl_timestamp is 'ETL处理时间戳';
