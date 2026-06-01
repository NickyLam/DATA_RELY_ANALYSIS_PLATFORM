/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_exchange_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_exchange_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_exchange_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_exchange_tran_hist(
    obunc_reference varchar2(50) -- 交易市场平盘流水号
    ,client_no varchar2(16) -- 客户编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,base_quote_type varchar2(1) -- 汇率报价方式代码
    ,base_rate_type varchar2(10) -- 基础汇率类型
    ,cash_seq_no varchar2(50) -- 现金交易序号
    ,change_base_quote_type varchar2(10) -- 找零基础报价方式
    ,change_base_rate_type varchar2(10) -- 找零基础利率类型
    ,change_quote_type varchar2(1) -- 找零报价方式
    ,change_rate_type varchar2(10) -- 找零利率类型
    ,company varchar2(20) -- 法人
    ,cross_rate_attr varchar2(10) -- 交叉汇率属性
    ,deposit_balance_type varchar2(2) -- 贷方余额类型
    ,deposit_seq_no varchar2(50) -- 贷方交易序号
    ,exchange_seq_no varchar2(50) -- 结售汇交易序号
    ,exchange_tran_status varchar2(1) -- 结售汇交易状态
    ,quote_type varchar2(1) -- 牌价类型
    ,rate_type varchar2(10) -- 汇率类型
    ,reversal_tran_type varchar2(10) -- 冲正交易类型
    ,sell_buy_ind varchar2(1) -- 买卖固定方
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,tae_sub_seq_no varchar2(200) -- tae子流水序号
    ,terminal_id varchar2(50) -- 交易终端编号
    ,trace_ref_code varchar2(200) -- 跟踪编码
    ,withdraw_balance_type varchar2(2) -- 借方余额类型
    ,withdraw_seq_no varchar2(50) -- 借方交易序号
    ,approval_date date -- 复核日期
    ,reversal_date date -- 冲正日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,value_date date -- 记账日期
    ,appr_auth_user_id varchar2(8) -- 复核授权柜员
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,base_equiv_amt number(17,2) -- 基础等值金额
    ,base_rate number(15,8) -- 基础汇率
    ,buy_amount number(17,2) -- 买入金额
    ,buy_ccy varchar2(3) -- 买入币种
    ,buy_rate number(15,8) -- 买方汇率
    ,change_base_equiv_amt number(17,2) -- 找零等值金额
    ,change_base_rate number(15,8) -- 找零基础利率
    ,change_cny_amount number(17,2) -- 找零金额
    ,change_rate number(15,8) -- 找零利率
    ,cr_acct_ccy varchar2(3) -- 贷方账户币种
    ,cross_rate number(15,8) -- 交叉汇率
    ,deposit_acct_seq_no varchar2(5) -- 贷方账户序列号
    ,deposit_base_acct_no varchar2(50) -- 贷方账户账号
    ,deposit_internal_key number(15) -- 贷方账户主键
    ,deposit_prod_type varchar2(12) -- 贷方账户产品类型
    ,exch_rate number(15,8) -- 执行汇率
    ,float_rate number(15,8) -- 浮动利率
    ,inner_rate number(15,8) -- 内部价
    ,reversal_auth_user_id varchar2(8) -- 冲正授权柜员
    ,reversal_user_id varchar2(8) -- 冲正柜员
    ,sell_amount number(17,2) -- 卖出金额
    ,sell_ccy varchar2(3) -- 卖出币种
    ,sell_rate number(15,8) -- 卖方汇率
    ,trace_ref_no varchar2(50) -- 跟踪参考号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,unc_cross_rate number(15,8) -- 平盘交叉汇率
    ,withdraw_acct_ccy varchar2(3) -- 借方方账户币种
    ,withdraw_acct_seq_no varchar2(5) -- 借方账户序列号
    ,withdraw_base_acct_no varchar2(50) -- 借方账户账号
    ,withdraw_internal_key number(15) -- 借方账户主键
    ,withdraw_prod_type varchar2(12) -- 方账户产品类型
    ,ibunc_reference varchar2(50) -- 系统内平盘流水号
    ,coupon_rate_type varchar2(1) -- 优惠汇率类型
    ,unc_status varchar2(10) -- 平盘状态
    ,fcy_ctrl_ibunc_amt number(17,2) -- 总行系统内平补金额（外币）
    ,min_amt_flag varchar2(1) -- 是否尾零处理
    ,float_point number(15,8) -- 浮动点差|浮动点差
    ,country_loc varchar2(3) -- 国籍|国籍
    ,effect_time varchar2(6) -- 汇率牌价生效时间
    ,effect_date date -- 产品生效日期
    ,sell_unc_rate number(15,8) -- 卖出平盘汇率
    ,buy_unc_rate number(15,8) -- 买入平盘汇率
    ,oversea_talent_proof varchar2(1) -- 海外人才证明
    ,oversea_talent_proof_type varchar2(100) -- 人才证明类型
    ,oversea_talent_remark varchar2(500) -- 海外人才备注
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
grant select on ${iol_schema}.ncbs_rb_exchange_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_exchange_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_exchange_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_exchange_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_exchange_tran_hist is '结售汇交易流水表';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.obunc_reference is '交易市场平盘流水号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.base_quote_type is '汇率报价方式代码';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.base_rate_type is '基础汇率类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.cash_seq_no is '现金交易序号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.change_base_quote_type is '找零基础报价方式';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.change_base_rate_type is '找零基础利率类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.change_quote_type is '找零报价方式';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.change_rate_type is '找零利率类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.cross_rate_attr is '交叉汇率属性';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.deposit_balance_type is '贷方余额类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.deposit_seq_no is '贷方交易序号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.exchange_seq_no is '结售汇交易序号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.exchange_tran_status is '结售汇交易状态';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.quote_type is '牌价类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.rate_type is '汇率类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.reversal_tran_type is '冲正交易类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.sell_buy_ind is '买卖固定方';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.tae_sub_seq_no is 'tae子流水序号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.trace_ref_code is '跟踪编码';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.withdraw_balance_type is '借方余额类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.withdraw_seq_no is '借方交易序号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.approval_date is '复核日期';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.value_date is '记账日期';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.appr_auth_user_id is '复核授权柜员';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.base_equiv_amt is '基础等值金额';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.base_rate is '基础汇率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.buy_amount is '买入金额';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.buy_ccy is '买入币种';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.buy_rate is '买方汇率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.change_base_equiv_amt is '找零等值金额';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.change_base_rate is '找零基础利率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.change_cny_amount is '找零金额';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.change_rate is '找零利率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.cr_acct_ccy is '贷方账户币种';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.cross_rate is '交叉汇率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.deposit_acct_seq_no is '贷方账户序列号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.deposit_base_acct_no is '贷方账户账号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.deposit_internal_key is '贷方账户主键';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.deposit_prod_type is '贷方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.exch_rate is '执行汇率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.inner_rate is '内部价';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.reversal_auth_user_id is '冲正授权柜员';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.reversal_user_id is '冲正柜员';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.sell_amount is '卖出金额';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.sell_ccy is '卖出币种';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.sell_rate is '卖方汇率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.trace_ref_no is '跟踪参考号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.unc_cross_rate is '平盘交叉汇率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.withdraw_acct_ccy is '借方方账户币种';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.withdraw_acct_seq_no is '借方账户序列号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.withdraw_base_acct_no is '借方账户账号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.withdraw_internal_key is '借方账户主键';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.withdraw_prod_type is '方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.ibunc_reference is '系统内平盘流水号';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.coupon_rate_type is '优惠汇率类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.unc_status is '平盘状态';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.fcy_ctrl_ibunc_amt is '总行系统内平补金额（外币）';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.min_amt_flag is '是否尾零处理';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.float_point is '浮动点差|浮动点差';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.country_loc is '国籍|国籍';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.effect_time is '汇率牌价生效时间';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.sell_unc_rate is '卖出平盘汇率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.buy_unc_rate is '买入平盘汇率';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.oversea_talent_proof is '海外人才证明';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.oversea_talent_proof_type is '人才证明类型';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.oversea_talent_remark is '海外人才备注';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_exchange_tran_hist.etl_timestamp is 'ETL处理时间戳';
