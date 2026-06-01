/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_exchange_tran_hist
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_exchange_tran_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_exchange_tran_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_exchange_tran_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_exchange_tran_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_exchange_tran_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_exchange_tran_hist_ex(
    obunc_reference -- 交易市场平盘流水号
    ,client_no -- 客户编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,remark -- 备注
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,bank_seq_no -- 银行交易序号
    ,base_quote_type -- 汇率报价方式代码
    ,base_rate_type -- 基础汇率类型
    ,cash_seq_no -- 现金交易序号
    ,change_base_quote_type -- 找零基础报价方式
    ,change_base_rate_type -- 找零基础利率类型
    ,change_quote_type -- 找零报价方式
    ,change_rate_type -- 找零利率类型
    ,company -- 法人
    ,cross_rate_attr -- 交叉汇率属性
    ,deposit_balance_type -- 贷方余额类型
    ,deposit_seq_no -- 贷方交易序号
    ,exchange_seq_no -- 结售汇交易序号
    ,exchange_tran_status -- 结售汇交易状态
    ,quote_type -- 牌价类型
    ,rate_type -- 汇率类型
    ,reversal_tran_type -- 冲正交易类型
    ,sell_buy_ind -- 买卖固定方
    ,seq_no -- 序号
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,tae_sub_seq_no -- tae子流水序号
    ,terminal_id -- 交易终端编号
    ,trace_ref_code -- 跟踪编码
    ,withdraw_balance_type -- 借方余额类型
    ,withdraw_seq_no -- 借方交易序号
    ,approval_date -- 复核日期
    ,reversal_date -- 冲正日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,value_date -- 记账日期
    ,appr_auth_user_id -- 复核授权柜员
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,base_equiv_amt -- 基础等值金额
    ,base_rate -- 基础汇率
    ,buy_amount -- 买入金额
    ,buy_ccy -- 买入币种
    ,buy_rate -- 买方汇率
    ,change_base_equiv_amt -- 找零等值金额
    ,change_base_rate -- 找零基础利率
    ,change_cny_amount -- 找零金额
    ,change_rate -- 找零利率
    ,cr_acct_ccy -- 贷方账户币种
    ,cross_rate -- 交叉汇率
    ,deposit_acct_seq_no -- 贷方账户序列号
    ,deposit_base_acct_no -- 贷方账户账号
    ,deposit_internal_key -- 贷方账户主键
    ,deposit_prod_type -- 贷方账户产品类型
    ,exch_rate -- 执行汇率
    ,float_rate -- 浮动利率
    ,inner_rate -- 内部价
    ,reversal_auth_user_id -- 冲正授权柜员
    ,reversal_user_id -- 冲正柜员
    ,sell_amount -- 卖出金额
    ,sell_ccy -- 卖出币种
    ,sell_rate -- 卖方汇率
    ,trace_ref_no -- 跟踪参考号
    ,tran_branch -- 核心交易机构编号
    ,unc_cross_rate -- 平盘交叉汇率
    ,withdraw_acct_ccy -- 借方方账户币种
    ,withdraw_acct_seq_no -- 借方账户序列号
    ,withdraw_base_acct_no -- 借方账户账号
    ,withdraw_internal_key -- 借方账户主键
    ,withdraw_prod_type -- 方账户产品类型
    ,ibunc_reference -- 系统内平盘流水号
    ,coupon_rate_type -- 优惠汇率类型
    ,unc_status -- 平盘状态
    ,fcy_ctrl_ibunc_amt -- 总行系统内平补金额（外币）
    ,min_amt_flag -- 是否尾零处理
    ,float_point -- 浮动点差|浮动点差
    ,country_loc -- 国籍|国籍
    ,effect_time -- 汇率牌价生效时间
    ,effect_date -- 产品生效日期
    ,sell_unc_rate -- 卖出平盘汇率
    ,buy_unc_rate -- 买入平盘汇率
    ,oversea_talent_proof -- 海外人才证明
    ,oversea_talent_proof_type -- 人才证明类型
    ,oversea_talent_remark -- 海外人才备注
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    obunc_reference -- 交易市场平盘流水号
    ,client_no -- 客户编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,remark -- 备注
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,bank_seq_no -- 银行交易序号
    ,base_quote_type -- 汇率报价方式代码
    ,base_rate_type -- 基础汇率类型
    ,cash_seq_no -- 现金交易序号
    ,change_base_quote_type -- 找零基础报价方式
    ,change_base_rate_type -- 找零基础利率类型
    ,change_quote_type -- 找零报价方式
    ,change_rate_type -- 找零利率类型
    ,company -- 法人
    ,cross_rate_attr -- 交叉汇率属性
    ,deposit_balance_type -- 贷方余额类型
    ,deposit_seq_no -- 贷方交易序号
    ,exchange_seq_no -- 结售汇交易序号
    ,exchange_tran_status -- 结售汇交易状态
    ,quote_type -- 牌价类型
    ,rate_type -- 汇率类型
    ,reversal_tran_type -- 冲正交易类型
    ,sell_buy_ind -- 买卖固定方
    ,seq_no -- 序号
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,tae_sub_seq_no -- tae子流水序号
    ,terminal_id -- 交易终端编号
    ,trace_ref_code -- 跟踪编码
    ,withdraw_balance_type -- 借方余额类型
    ,withdraw_seq_no -- 借方交易序号
    ,approval_date -- 复核日期
    ,reversal_date -- 冲正日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,value_date -- 记账日期
    ,appr_auth_user_id -- 复核授权柜员
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,base_equiv_amt -- 基础等值金额
    ,base_rate -- 基础汇率
    ,buy_amount -- 买入金额
    ,buy_ccy -- 买入币种
    ,buy_rate -- 买方汇率
    ,change_base_equiv_amt -- 找零等值金额
    ,change_base_rate -- 找零基础利率
    ,change_cny_amount -- 找零金额
    ,change_rate -- 找零利率
    ,cr_acct_ccy -- 贷方账户币种
    ,cross_rate -- 交叉汇率
    ,deposit_acct_seq_no -- 贷方账户序列号
    ,deposit_base_acct_no -- 贷方账户账号
    ,deposit_internal_key -- 贷方账户主键
    ,deposit_prod_type -- 贷方账户产品类型
    ,exch_rate -- 执行汇率
    ,float_rate -- 浮动利率
    ,inner_rate -- 内部价
    ,reversal_auth_user_id -- 冲正授权柜员
    ,reversal_user_id -- 冲正柜员
    ,sell_amount -- 卖出金额
    ,sell_ccy -- 卖出币种
    ,sell_rate -- 卖方汇率
    ,trace_ref_no -- 跟踪参考号
    ,tran_branch -- 核心交易机构编号
    ,unc_cross_rate -- 平盘交叉汇率
    ,withdraw_acct_ccy -- 借方方账户币种
    ,withdraw_acct_seq_no -- 借方账户序列号
    ,withdraw_base_acct_no -- 借方账户账号
    ,withdraw_internal_key -- 借方账户主键
    ,withdraw_prod_type -- 方账户产品类型
    ,ibunc_reference -- 系统内平盘流水号
    ,coupon_rate_type -- 优惠汇率类型
    ,unc_status -- 平盘状态
    ,fcy_ctrl_ibunc_amt -- 总行系统内平补金额（外币）
    ,min_amt_flag -- 是否尾零处理
    ,float_point -- 浮动点差|浮动点差
    ,country_loc -- 国籍|国籍
    ,effect_time -- 汇率牌价生效时间
    ,effect_date -- 产品生效日期
    ,sell_unc_rate -- 卖出平盘汇率
    ,buy_unc_rate -- 买入平盘汇率
    ,oversea_talent_proof -- 海外人才证明
    ,oversea_talent_proof_type -- 人才证明类型
    ,oversea_talent_remark -- 海外人才备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_exchange_tran_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_exchange_tran_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_exchange_tran_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_exchange_tran_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_exchange_tran_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_exchange_tran_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);