/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_serv_charge_hist
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
drop table ${iol_schema}.ncbs_rb_serv_charge_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_serv_charge_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_serv_charge_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_serv_charge_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_serv_charge_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_serv_charge_hist_ex(
    client_no -- 客户编号
    ,client_type -- 客户类型
    ,doc_type -- 凭证类型
    ,gl_code -- 科目代码
    ,internal_key -- 账户内部键值
    ,reason -- 原因
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,agreement_id -- 协议编号
    ,amortize_month -- 摊销月
    ,amortize_status -- 摊销状态
    ,amortize_time_type -- 摊销时间类型
    ,bank_seq_no -- 银行交易序号
    ,bo_ind -- 日终/联机标志
    ,channel_seq_no -- 全局流水号
    ,charge_way -- 收费方式
    ,company -- 法人
    ,end_no -- 终止号码数字串
    ,fee_charge_method -- 手续费收取方式
    ,fee_type -- 费率类型
    ,gl_posted_flag -- 过账标记
    ,osd_seq_no -- 应收费用序号
    ,oth_business_no -- 对手业务编号
    ,prefix -- 前缀
    ,profit_allot_flag -- 是否需要分润
    ,profit_amortize_flag -- 是否需要摊销
    ,reversal_flag -- 交易是否已冲正
    ,reversal_sc_seq_no -- 转账服务费冲正序号
    ,sc_discount_type -- 费用折扣类型
    ,sc_seq_no -- 收费序号
    ,seq_no -- 序号
    ,sub_seq_no -- 系统流水号
    ,tae_sub_seq_no -- tae子流水序号
    ,tax_type -- 税种
    ,tran_seq_no -- 交易序号
    ,voucher_sum -- 凭证合计数
    ,effect_date -- 产品生效日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,amortize_day -- 摊销日
    ,amortize_period_type -- 摊销期限类型
    ,charge_to_acct_seq_no -- 收费账户序号
    ,charge_to_base_acct_no -- 收费账号
    ,charge_to_ccy -- 收费账户币种符
    ,charge_to_internal_key -- 收费账户标识符
    ,charge_to_prod_type -- 收费账户产品类型
    ,disc_fee_amt -- 折扣金额
    ,fee_amt -- 费用金额
    ,fee_ccy -- 收费币种
    ,loan_prod_type -- 贷款产品类型
    ,open_branch_percent -- 账户行比例
    ,open_profit_amt -- 账户行分润金额
    ,orig_fee_amt -- 原始费用金额,即折扣前的费用金额
    ,oth_name -- 对手名称
    ,reversal_auth_user_id -- 冲正授权柜员
    ,reversal_branch -- 冲正机构
    ,reversal_user_id -- 冲正柜员
    ,sc_discount_rate -- 费用折扣率
    ,tax_amt -- 税金
    ,tax_rate -- 税率
    ,tran_branch -- 核心交易机构编号
    ,tran_branch_percent -- 交易行比例,记录百分数
    ,tran_fee_amt -- 原应收费用金额
    ,tran_profit_amt -- 交易行分润金额
    ,unit_price -- 单价
    ,voucher_start_no -- 凭证起始号码
    ,reaccount_cd -- 对账代码
    ,amort_end -- 摊销截止日期
    ,bus_seq_no -- 业务流水号
    ,charge_pay_flag -- 收入支出标识
    ,amort_start -- 摊销起始日期
    ,source_type -- 渠道编号
    ,oth_client_name -- 对手客户名称
    ,acct_exec_name -- 客户经理姓名
    ,acct_exec -- 银行客户经理编号
    ,oth_client_no -- 对手客户号
    ,account_date -- 入账日期
    ,oth_client_type -- 对手客户类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    client_no -- 客户编号
    ,client_type -- 客户类型
    ,doc_type -- 凭证类型
    ,gl_code -- 科目代码
    ,internal_key -- 账户内部键值
    ,reason -- 原因
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,agreement_id -- 协议编号
    ,amortize_month -- 摊销月
    ,amortize_status -- 摊销状态
    ,amortize_time_type -- 摊销时间类型
    ,bank_seq_no -- 银行交易序号
    ,bo_ind -- 日终/联机标志
    ,channel_seq_no -- 全局流水号
    ,charge_way -- 收费方式
    ,company -- 法人
    ,end_no -- 终止号码数字串
    ,fee_charge_method -- 手续费收取方式
    ,fee_type -- 费率类型
    ,gl_posted_flag -- 过账标记
    ,osd_seq_no -- 应收费用序号
    ,oth_business_no -- 对手业务编号
    ,prefix -- 前缀
    ,profit_allot_flag -- 是否需要分润
    ,profit_amortize_flag -- 是否需要摊销
    ,reversal_flag -- 交易是否已冲正
    ,reversal_sc_seq_no -- 转账服务费冲正序号
    ,sc_discount_type -- 费用折扣类型
    ,sc_seq_no -- 收费序号
    ,seq_no -- 序号
    ,sub_seq_no -- 系统流水号
    ,tae_sub_seq_no -- tae子流水序号
    ,tax_type -- 税种
    ,tran_seq_no -- 交易序号
    ,voucher_sum -- 凭证合计数
    ,effect_date -- 产品生效日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,amortize_day -- 摊销日
    ,amortize_period_type -- 摊销期限类型
    ,charge_to_acct_seq_no -- 收费账户序号
    ,charge_to_base_acct_no -- 收费账号
    ,charge_to_ccy -- 收费账户币种符
    ,charge_to_internal_key -- 收费账户标识符
    ,charge_to_prod_type -- 收费账户产品类型
    ,disc_fee_amt -- 折扣金额
    ,fee_amt -- 费用金额
    ,fee_ccy -- 收费币种
    ,loan_prod_type -- 贷款产品类型
    ,open_branch_percent -- 账户行比例
    ,open_profit_amt -- 账户行分润金额
    ,orig_fee_amt -- 原始费用金额,即折扣前的费用金额
    ,oth_name -- 对手名称
    ,reversal_auth_user_id -- 冲正授权柜员
    ,reversal_branch -- 冲正机构
    ,reversal_user_id -- 冲正柜员
    ,sc_discount_rate -- 费用折扣率
    ,tax_amt -- 税金
    ,tax_rate -- 税率
    ,tran_branch -- 核心交易机构编号
    ,tran_branch_percent -- 交易行比例,记录百分数
    ,tran_fee_amt -- 原应收费用金额
    ,tran_profit_amt -- 交易行分润金额
    ,unit_price -- 单价
    ,voucher_start_no -- 凭证起始号码
    ,reaccount_cd -- 对账代码
    ,amort_end -- 摊销截止日期
    ,bus_seq_no -- 业务流水号
    ,charge_pay_flag -- 收入支出标识
    ,amort_start -- 摊销起始日期
    ,source_type -- 渠道编号
    ,oth_client_name -- 对手客户名称
    ,acct_exec_name -- 客户经理姓名
    ,acct_exec -- 银行客户经理编号
    ,oth_client_no -- 对手客户号
    ,account_date -- 入账日期
    ,oth_client_type -- 对手客户类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_serv_charge_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_serv_charge_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_serv_charge_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_serv_charge_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_serv_charge_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_serv_charge_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);