/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_delay_serv_change
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_delay_serv_change
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_delay_serv_change purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_delay_serv_change(
    client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,agreement_id varchar2(50) -- 协议编号
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,bo_ind varchar2(1) -- 日终/联机标志
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,charge_way varchar2(1) -- 收费方式
    ,company varchar2(20) -- 法人
    ,end_no varchar2(50) -- 终止号码数字串
    ,fee_type varchar2(20) -- 费率类型
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,osd_seq_no varchar2(50) -- 应收费用序号
    ,prefix varchar2(10) -- 前缀
    ,primary_tran_seq_no varchar2(50) -- 主交易序号
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,reversal_sc_seq_no varchar2(50) -- 转账服务费冲正序号
    ,sc_discount_type varchar2(10) -- 费用折扣类型
    ,sc_seq_no varchar2(50) -- 收费序号
    ,tax_type varchar2(2) -- 税种
    ,tran_seq_no varchar2(50) -- 交易序号
    ,voucher_sum number(5) -- 凭证合计数
    ,effect_date date -- 产品生效日期
    ,reversal_date date -- 冲正日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,charge_to_acct_seq_no varchar2(5) -- 收费账户序号
    ,charge_to_base_acct_no varchar2(50) -- 收费账号
    ,charge_to_ccy varchar2(3) -- 收费账户币种符
    ,charge_to_internal_key number(15) -- 收费账户标识符
    ,charge_to_prod_type varchar2(12) -- 收费账户产品类型
    ,disc_fee_amt number(17,2) -- 折扣金额
    ,fee_amt number(17,2) -- 费用金额
    ,fee_ccy varchar2(3) -- 收费币种
    ,orig_fee_amt number(17,2) -- 原始费用金额,即折扣前的费用金额
    ,reversal_auth_user_id varchar2(8) -- 冲正授权柜员
    ,reversal_branch varchar2(12) -- 冲正机构
    ,reversal_user_id varchar2(8) -- 冲正柜员
    ,sc_discount_rate number(11,7) -- 费用折扣率
    ,tax_amt number(17,2) -- 税金
    ,tax_rate number(15,8) -- 税率
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_fee_amt number(17,2) -- 原应收费用金额
    ,voucher_start_no varchar2(50) -- 凭证起始号码
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
grant select on ${iol_schema}.ncbs_rb_delay_serv_change to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_delay_serv_change to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_delay_serv_change to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_delay_serv_change to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_delay_serv_change is '24小时转账服务费表';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.bo_ind is '日终/联机标志';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.charge_way is '收费方式';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.company is '法人';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.end_no is '终止号码数字串';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.osd_seq_no is '应收费用序号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.primary_tran_seq_no is '主交易序号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.reversal_sc_seq_no is '转账服务费冲正序号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.sc_discount_type is '费用折扣类型';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.sc_seq_no is '收费序号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.tax_type is '税种';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.tran_seq_no is '交易序号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.voucher_sum is '凭证合计数';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.charge_to_acct_seq_no is '收费账户序号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.charge_to_base_acct_no is '收费账号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.charge_to_ccy is '收费账户币种符';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.charge_to_internal_key is '收费账户标识符';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.charge_to_prod_type is '收费账户产品类型';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.disc_fee_amt is '折扣金额';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.fee_amt is '费用金额';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.fee_ccy is '收费币种';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.orig_fee_amt is '原始费用金额,即折扣前的费用金额';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.reversal_auth_user_id is '冲正授权柜员';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.reversal_branch is '冲正机构';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.reversal_user_id is '冲正柜员';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.sc_discount_rate is '费用折扣率';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.tran_fee_amt is '原应收费用金额';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_delay_serv_change.etl_timestamp is 'ETL处理时间戳';
