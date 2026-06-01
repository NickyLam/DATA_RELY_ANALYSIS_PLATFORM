/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_serv_charge_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_serv_charge_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_serv_charge_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_serv_charge_hist(
    client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,doc_type varchar2(10) -- 凭证类型
    ,gl_code varchar2(20) -- 科目代码
    ,internal_key number(15) -- 账户内部键值
    ,reason varchar2(200) -- 原因
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,agreement_id varchar2(50) -- 协议编号
    ,amortize_month varchar2(2) -- 摊销月
    ,amortize_status varchar2(1) -- 摊销状态
    ,amortize_time_type varchar2(1) -- 摊销时间类型
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,bo_ind varchar2(1) -- 日终/联机标志
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,charge_way varchar2(1) -- 收费方式
    ,company varchar2(20) -- 法人
    ,end_no varchar2(50) -- 终止号码数字串
    ,fee_charge_method varchar2(1) -- 手续费收取方式
    ,fee_type varchar2(20) -- 费率类型
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,osd_seq_no varchar2(50) -- 应收费用序号
    ,oth_business_no varchar2(200) -- 对手业务编号
    ,prefix varchar2(10) -- 前缀
    ,profit_allot_flag varchar2(1) -- 是否需要分润
    ,profit_amortize_flag varchar2(1) -- 是否需要摊销
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,reversal_sc_seq_no varchar2(50) -- 转账服务费冲正序号
    ,sc_discount_type varchar2(10) -- 费用折扣类型
    ,sc_seq_no varchar2(50) -- 收费序号
    ,seq_no varchar2(50) -- 序号
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,tae_sub_seq_no varchar2(200) -- tae子流水序号
    ,tax_type varchar2(2) -- 税种
    ,tran_seq_no varchar2(50) -- 交易序号
    ,voucher_sum number(5) -- 凭证合计数
    ,effect_date date -- 产品生效日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,amortize_day varchar2(2) -- 摊销日
    ,amortize_period_type varchar2(1) -- 摊销期限类型
    ,charge_to_acct_seq_no varchar2(5) -- 收费账户序号
    ,charge_to_base_acct_no varchar2(50) -- 收费账号
    ,charge_to_ccy varchar2(3) -- 收费账户币种符
    ,charge_to_internal_key number(15) -- 收费账户标识符
    ,charge_to_prod_type varchar2(12) -- 收费账户产品类型
    ,disc_fee_amt number(17,2) -- 折扣金额
    ,fee_amt number(17,2) -- 费用金额
    ,fee_ccy varchar2(3) -- 收费币种
    ,loan_prod_type varchar2(12) -- 贷款产品类型
    ,open_branch_percent number(11,7) -- 账户行比例
    ,open_profit_amt number(17,2) -- 账户行分润金额
    ,orig_fee_amt number(17,2) -- 原始费用金额,即折扣前的费用金额
    ,oth_name varchar2(200) -- 对手名称
    ,reversal_auth_user_id varchar2(8) -- 冲正授权柜员
    ,reversal_branch varchar2(12) -- 冲正机构
    ,reversal_user_id varchar2(8) -- 冲正柜员
    ,sc_discount_rate number(11,7) -- 费用折扣率
    ,tax_amt number(17,2) -- 税金
    ,tax_rate number(15,8) -- 税率
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_branch_percent number(11,7) -- 交易行比例,记录百分数
    ,tran_fee_amt number(17,2) -- 原应收费用金额
    ,tran_profit_amt number(17,2) -- 交易行分润金额
    ,unit_price number(17,2) -- 单价
    ,voucher_start_no varchar2(50) -- 凭证起始号码
    ,reaccount_cd varchar2(20) -- 对账代码
    ,amort_end date -- 摊销截止日期
    ,bus_seq_no varchar2(33) -- 业务流水号
    ,charge_pay_flag varchar2(1) -- 收入支出标识
    ,amort_start date -- 摊销起始日期
    ,source_type varchar2(6) -- 渠道编号
    ,oth_client_name varchar2(200) -- 对手客户名称
    ,acct_exec_name varchar2(200) -- 客户经理姓名
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,oth_client_no varchar2(16) -- 对手客户号
    ,account_date date -- 入账日期
    ,oth_client_type varchar2(3) -- 对手客户类型
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
grant select on ${iol_schema}.ncbs_rb_serv_charge_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_serv_charge_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_serv_charge_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_serv_charge_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_serv_charge_hist is '收费历史表';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.reason is '原因';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.amortize_month is '摊销月';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.amortize_status is '摊销状态';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.amortize_time_type is '摊销时间类型';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.bo_ind is '日终/联机标志';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.charge_way is '收费方式';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.end_no is '终止号码数字串';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.fee_charge_method is '手续费收取方式';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.osd_seq_no is '应收费用序号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.oth_business_no is '对手业务编号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.profit_allot_flag is '是否需要分润';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.profit_amortize_flag is '是否需要摊销';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.reversal_sc_seq_no is '转账服务费冲正序号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.sc_discount_type is '费用折扣类型';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.sc_seq_no is '收费序号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tae_sub_seq_no is 'tae子流水序号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tax_type is '税种';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tran_seq_no is '交易序号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.voucher_sum is '凭证合计数';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.amortize_day is '摊销日';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.amortize_period_type is '摊销期限类型';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.charge_to_acct_seq_no is '收费账户序号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.charge_to_base_acct_no is '收费账号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.charge_to_ccy is '收费账户币种符';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.charge_to_internal_key is '收费账户标识符';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.charge_to_prod_type is '收费账户产品类型';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.disc_fee_amt is '折扣金额';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.fee_amt is '费用金额';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.fee_ccy is '收费币种';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.loan_prod_type is '贷款产品类型';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.open_branch_percent is '账户行比例';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.open_profit_amt is '账户行分润金额';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.orig_fee_amt is '原始费用金额,即折扣前的费用金额';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.oth_name is '对手名称';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.reversal_auth_user_id is '冲正授权柜员';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.reversal_branch is '冲正机构';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.reversal_user_id is '冲正柜员';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.sc_discount_rate is '费用折扣率';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tran_branch_percent is '交易行比例,记录百分数';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tran_fee_amt is '原应收费用金额';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.tran_profit_amt is '交易行分润金额';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.unit_price is '单价';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.amort_end is '摊销截止日期';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.charge_pay_flag is '收入支出标识';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.amort_start is '摊销起始日期';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.oth_client_name is '对手客户名称';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.acct_exec_name is '客户经理姓名';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.oth_client_no is '对手客户号';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.account_date is '入账日期';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.oth_client_type is '对手客户类型';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_serv_charge_hist.etl_timestamp is 'ETL处理时间戳';
