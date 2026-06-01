/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_charge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_charge
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_charge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_charge(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,batch_seq_no varchar2(50) -- 批次明细序号
    ,bo_ind varchar2(1) -- 日终/联机标志
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,disc_type varchar2(2) -- 折扣类型
    ,fee_type varchar2(20) -- 费率类型
    ,tax_type varchar2(2) -- 税种
    ,next_charge_date date -- 下一收费日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,charge_day varchar2(2) -- 收费日
    ,charge_period_freq varchar2(5) -- 收费频率
    ,disc_fee_amt number(17,2) -- 折扣金额
    ,disc_rate number(15,8) -- 利率折扣
    ,fee_amt number(17,2) -- 费用金额
    ,fee_ccy varchar2(3) -- 收费币种
    ,open_branch_percent number(11,7) -- 账户行比例
    ,open_profit_amt number(17,2) -- 账户行分润金额
    ,orig_fee_amt number(17,2) -- 原始费用金额,即折扣前的费用金额
    ,tax_amt number(17,2) -- 税金
    ,tax_rate number(15,8) -- 税率
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_branch_percent number(11,7) -- 交易行比例,记录百分数
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
grant select on ${iol_schema}.ncbs_rb_batch_charge to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_charge to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_charge to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_charge to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_charge is '批量费用登记表';
comment on column ${iol_schema}.ncbs_rb_batch_charge.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_batch_charge.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_batch_charge.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.bo_ind is '日终/联机标志';
comment on column ${iol_schema}.ncbs_rb_batch_charge.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_charge.disc_type is '折扣类型';
comment on column ${iol_schema}.ncbs_rb_batch_charge.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_batch_charge.tax_type is '税种';
comment on column ${iol_schema}.ncbs_rb_batch_charge.next_charge_date is '下一收费日期';
comment on column ${iol_schema}.ncbs_rb_batch_charge.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_batch_charge.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_charge.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_batch_charge.charge_day is '收费日';
comment on column ${iol_schema}.ncbs_rb_batch_charge.charge_period_freq is '收费频率';
comment on column ${iol_schema}.ncbs_rb_batch_charge.disc_fee_amt is '折扣金额';
comment on column ${iol_schema}.ncbs_rb_batch_charge.disc_rate is '利率折扣';
comment on column ${iol_schema}.ncbs_rb_batch_charge.fee_amt is '费用金额';
comment on column ${iol_schema}.ncbs_rb_batch_charge.fee_ccy is '收费币种';
comment on column ${iol_schema}.ncbs_rb_batch_charge.open_branch_percent is '账户行比例';
comment on column ${iol_schema}.ncbs_rb_batch_charge.open_profit_amt is '账户行分润金额';
comment on column ${iol_schema}.ncbs_rb_batch_charge.orig_fee_amt is '原始费用金额,即折扣前的费用金额';
comment on column ${iol_schema}.ncbs_rb_batch_charge.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_rb_batch_charge.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_rb_batch_charge.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_charge.tran_branch_percent is '交易行比例,记录百分数';
comment on column ${iol_schema}.ncbs_rb_batch_charge.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_charge.etl_timestamp is 'ETL处理时间戳';
