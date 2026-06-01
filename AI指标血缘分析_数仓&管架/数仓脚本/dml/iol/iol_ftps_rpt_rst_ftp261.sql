/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ftps_rpt_rst_ftp261
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
drop table ${iol_schema}.ftps_rpt_rst_ftp261_ex purge;
alter table ${iol_schema}.ftps_rpt_rst_ftp261 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ftps_rpt_rst_ftp261 truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ftps_rpt_rst_ftp261_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ftps_rpt_rst_ftp261 where 0=1;

insert /*+ append */ into ${iol_schema}.ftps_rpt_rst_ftp261_ex(
    acct_no -- 账号
    ,s_acct_no -- 拆分前账号
    ,t_acct_no -- 源账号
    ,data_dt -- 数据日期
    ,share_percent -- 分成比例
    ,price_unit_cd -- 定价单元
    ,prod_cd -- 产品代码
    ,core_prod_cd -- 核心系统产品码
    ,credit_prod_cd -- 信贷系统产品码
    ,industry_cd -- 行业代码
    ,subject_cd -- 科目代码
    ,currency_cd -- 币种代码
    ,acct_org_cd -- 核算机构
    ,assess_org_cd -- 考核机构代码
    ,bond_categ_cd -- 债券种类代码
    ,al_flag -- 资产负债标志
    ,biz_flag -- 对公对私业务标识
    ,biz_line_cd -- 业务条线代码
    ,data_src -- 数据来源
    ,channel_cd -- 渠道代码
    ,interest_adjust_type_cd -- 利率调整方式代码
    ,cust_id -- 客户号
    ,cust_name -- 客户名称
    ,mgr_id -- 客户经理号
    ,mgr_name -- 客户经理名称
    ,cust_size_cd -- 客户规模
    ,cust_type_cd -- 客户类型代码
    ,accrual_basis_cd -- 计息方式代码
    ,original_term -- 原始期限
    ,original_term_mult -- 原始期限单位
    ,start_dt -- 起息日
    ,maturity_dt -- 到期日
    ,open_dt -- 开户日
    ,close_dt -- 销户日
    ,last_payment_dt -- 上次还款日
    ,next_payment_dt -- 下次还款日
    ,payment_type_cd -- 还款方式代码
    ,payment_freq -- 还款频率
    ,payment_freq_mult -- 还款频率单位
    ,last_repricing_dt -- 上次重定价日
    ,next_repricing_dt -- 下次重定价日
    ,repricing_freq -- 重定价频率
    ,repricing_freq_mult -- 重定价频率单位
    ,overdue_flag -- 逾期标志
    ,position_inc_dt -- 业务新增日期
    ,agmt_deposit_flag -- 是否协定存款标志
    ,excess_reserce_flag -- 是否超额准备金标志
    ,iflock_flag -- 是否锁定利差标志
    ,loan_class_cd -- 贷款质量分类
    ,cur_bal -- 当前余额
    ,accbal_month -- 月累计余额
    ,accbal_quar -- 季累计余额
    ,accbal_year -- 年累计余额
    ,exercise_interest_rate -- 执行利率
    ,base_ftp_rate -- 原始ftp利率
    ,mid_ftp_rate -- 内生性调节后ftp利率
    ,final_ftp_rate -- 最终ftp利率
    ,lock_spread -- 锁定利差值
    ,base_unlock_ftp_rate -- 原始非锁定ftp利率
    ,mid_unlock_ftp_rate -- 内生性调节后非锁定ftp利率
    ,final_unlock_ftp_rate -- 最终非锁定ftp利率
    ,accint_day -- 利息收支日累计
    ,accint_month -- 利息收支月累计
    ,accint_quar -- 利息收支季累计
    ,accint_year -- 利息收支年累计
    ,base_ftp_accint_day -- 原始ftp利息日累计
    ,base_ftp_accint_month -- 原始ftp利息月累计
    ,base_ftp_accint_quar -- 原始ftp利息季累计
    ,base_ftp_accint_year -- 原始ftp利息年累计
    ,mid_ftp_accint_day -- 内生性调节后ftp利息日累计
    ,mid_ftp_accint_month -- 内生性调节后ftp利息月累计
    ,mid_ftp_accint_quar -- 内生性调节后ftp利息季累计
    ,mid_ftp_accint_year -- 内生性调节后ftp利息年累计
    ,final_ftp_accint_day -- 最终ftp利息日累计
    ,final_ftp_accint_month -- 最终ftp利息月累计
    ,final_ftp_accint_quar -- 最终ftp利息季累计
    ,final_ftp_accint_year -- 最终ftp利息年累计
    ,base_unlock_ftp_accint_day -- 原始非锁定ftp利息日累计
    ,base_unlock_ftp_accint_month -- 原始非锁定ftp利息月累计
    ,base_unlock_ftp_accint_quar -- 原始非锁定ftp利息季累计
    ,base_unlock_ftp_accint_year -- 原始非锁定ftp利息年累计
    ,mid_unlock_ftp_accint_day -- 内生性调节后非锁定ftp利息日累计
    ,mid_unlock_ftp_accint_month -- 内生性调节后非锁定ftp利息月累计
    ,mid_unlock_ftp_accint_quar -- 内生性调节后非锁定ftp利息季累计
    ,mid_unlock_ftp_accint_year -- 内生性调节后非锁定ftp利息年累计
    ,final_unlock_ftp_accint_day -- 最终非锁定ftp利息日累计
    ,final_unlock_ftp_accint_month -- 最终非锁定ftp利息月累计
    ,final_unlock_ftp_accint_quar -- 最终非锁定ftp利息季累计
    ,final_unlock_ftp_accint_year -- 最终非锁定ftp利息年累计
    ,adjust_01_rate -- 调节项1点差
    ,adjust_01_accint_day -- 调节项1金额日累计
    ,adjust_01_accint_month -- 调节项1金额月累计
    ,adjust_01_accint_quar -- 调节项1金额季累计
    ,adjust_01_accint_year -- 调节项1金额年累计
    ,adjust_02_rate -- 调节项2点差
    ,adjust_02_accint_day -- 调节项2金额日累计
    ,adjust_02_accint_month -- 调节项2金额月累计
    ,adjust_02_accint_quar -- 调节项2金额季累计
    ,adjust_02_accint_year -- 调节项2金额年累计
    ,adjust_03_rate -- 调节项3点差
    ,adjust_03_accint_day -- 调节项3金额日累计
    ,adjust_03_accint_month -- 调节项3金额月累计
    ,adjust_03_accint_quar -- 调节项3金额季累计
    ,adjust_03_accint_year -- 调节项3金额年累计
    ,adjust_04_rate -- 调节项4点差
    ,adjust_04_accint_day -- 调节项4金额日累计
    ,adjust_04_accint_month -- 调节项4金额月累计
    ,adjust_04_accint_quar -- 调节项4金额季累计
    ,adjust_04_accint_year -- 调节项4金额年累计
    ,adjust_05_rate -- 调节项5点差
    ,adjust_05_accint_day -- 调节项5金额日累计
    ,adjust_05_accint_month -- 调节项5金额月累计
    ,adjust_05_accint_quar -- 调节项5金额季累计
    ,adjust_05_accint_year -- 调节项5金额年累计
    ,adjust_06_rate -- 调节项6点差
    ,adjust_06_accint_day -- 调节项6金额日累计
    ,adjust_06_accint_month -- 调节项6金额月累计
    ,adjust_06_accint_quar -- 调节项6金额季累计
    ,adjust_06_accint_year -- 调节项6金额年累计
    ,adjust_07_rate -- 调节项7点差
    ,adjust_07_accint_day -- 调节项7金额日累计
    ,adjust_07_accint_month -- 调节项7金额月累计
    ,adjust_07_accint_quar -- 调节项7金额季累计
    ,adjust_07_accint_year -- 调节项7金额年累计
    ,adjust_08_rate -- 调节项8点差
    ,adjust_08_accint_day -- 调节项8金额日累计
    ,adjust_08_accint_month -- 调节项8金额月累计
    ,adjust_08_accint_quar -- 调节项8金额季累计
    ,adjust_08_accint_year -- 调节项8金额年累计
    ,adjust_09_rate -- 调节项9点差
    ,adjust_09_accint_day -- 调节项9金额日累计
    ,adjust_09_accint_month -- 调节项9金额月累计
    ,adjust_09_accint_quar -- 调节项9金额季累计
    ,adjust_09_accint_year -- 调节项9金额年累计
    ,adjust_10_rate -- 调节项10点差
    ,adjust_10_accint_day -- 调节项10金额日累计
    ,adjust_10_accint_month -- 调节项10金额月累计
    ,adjust_10_accint_quar -- 调节项10金额季累计
    ,adjust_10_accint_year -- 调节项10金额年累计
    ,adjust_11_rate -- 调节项11点差
    ,adjust_11_accint_day -- 调节项11金额日累计
    ,adjust_11_accint_month -- 调节项11金额月累计
    ,adjust_11_accint_quar -- 调节项11金额季累计
    ,adjust_11_accint_year -- 调节项11金额年累计
    ,adjust_12_rate -- 调节项12点差
    ,adjust_12_accint_day -- 调节项12金额日累计
    ,adjust_12_accint_month -- 调节项12金额月累计
    ,adjust_12_accint_quar -- 调节项12金额季累计
    ,adjust_12_accint_year -- 调节项12金额年累计
    ,adjust_13_rate -- 调节项13点差
    ,adjust_13_accint_day -- 调节项13金额日累计
    ,adjust_13_accint_month -- 调节项13金额月累计
    ,adjust_13_accint_quar -- 调节项13金额季累计
    ,adjust_13_accint_year -- 调节项13金额年累计
    ,adjust_14_rate -- 调节项14点差
    ,adjust_14_accint_day -- 调节项14金额日累计
    ,adjust_14_accint_month -- 调节项14金额月累计
    ,adjust_14_accint_quar -- 调节项14金额季累计
    ,adjust_14_accint_year -- 调节项14金额年累计
    ,adjust_15_rate -- 调节项15点差
    ,adjust_15_accint_day -- 调节项15金额日累计
    ,adjust_15_accint_month -- 调节项15金额月累计
    ,adjust_15_accint_quar -- 调节项15金额季累计
    ,adjust_15_accint_year -- 调节项15金额年累计
    ,adjust_16_rate -- 调节项16点差
    ,adjust_16_accint_day -- 调节项16金额日累计
    ,adjust_16_accint_month -- 调节项16金额月累计
    ,adjust_16_accint_quar -- 调节项16金额季累计
    ,adjust_16_accint_year -- 调节项16金额年累计
    ,adjust_17_rate -- 调节项17点差
    ,adjust_17_accint_day -- 调节项17金额日累计
    ,adjust_17_accint_month -- 调节项17金额月累计
    ,adjust_17_accint_quar -- 调节项17金额季累计
    ,adjust_17_accint_year -- 调节项17金额年累计
    ,adjust_18_rate -- 调节项18点差
    ,adjust_18_accint_day -- 调节项18金额日累计
    ,adjust_18_accint_month -- 调节项18金额月累计
    ,adjust_18_accint_quar -- 调节项18金额季累计
    ,adjust_18_accint_year -- 调节项18金额年累计
    ,adjust_19_rate -- 调节项19点差
    ,adjust_19_accint_day -- 调节项19金额日累计
    ,adjust_19_accint_month -- 调节项19金额月累计
    ,adjust_19_accint_quar -- 调节项19金额季累计
    ,adjust_19_accint_year -- 调节项19金额年累计
    ,adjust_20_rate -- 调节项20点差
    ,adjust_20_accint_day -- 调节项20金额日累计
    ,adjust_20_accint_month -- 调节项20金额月累计
    ,adjust_20_accint_quar -- 调节项20金额季累计
    ,adjust_20_accint_year -- 调节项20金额年累计
    ,inc_spred_accint_day -- 价差收益日累计
    ,inc_spred_accint_month -- 价差收益月累计
    ,inc_spred_accint_quar -- 价差收益季累计
    ,inc_spred_accint_year -- 价差收益年累计
    ,exchange_to_cny_rate -- 折人民币汇率
    ,exchange_to_usd_rate -- 折美元汇率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_no -- 账号
    ,s_acct_no -- 拆分前账号
    ,t_acct_no -- 源账号
    ,data_dt -- 数据日期
    ,share_percent -- 分成比例
    ,price_unit_cd -- 定价单元
    ,prod_cd -- 产品代码
    ,core_prod_cd -- 核心系统产品码
    ,credit_prod_cd -- 信贷系统产品码
    ,industry_cd -- 行业代码
    ,subject_cd -- 科目代码
    ,currency_cd -- 币种代码
    ,acct_org_cd -- 核算机构
    ,assess_org_cd -- 考核机构代码
    ,bond_categ_cd -- 债券种类代码
    ,al_flag -- 资产负债标志
    ,biz_flag -- 对公对私业务标识
    ,biz_line_cd -- 业务条线代码
    ,data_src -- 数据来源
    ,channel_cd -- 渠道代码
    ,interest_adjust_type_cd -- 利率调整方式代码
    ,cust_id -- 客户号
    ,cust_name -- 客户名称
    ,mgr_id -- 客户经理号
    ,mgr_name -- 客户经理名称
    ,cust_size_cd -- 客户规模
    ,cust_type_cd -- 客户类型代码
    ,accrual_basis_cd -- 计息方式代码
    ,original_term -- 原始期限
    ,original_term_mult -- 原始期限单位
    ,start_dt -- 起息日
    ,maturity_dt -- 到期日
    ,open_dt -- 开户日
    ,close_dt -- 销户日
    ,last_payment_dt -- 上次还款日
    ,next_payment_dt -- 下次还款日
    ,payment_type_cd -- 还款方式代码
    ,payment_freq -- 还款频率
    ,payment_freq_mult -- 还款频率单位
    ,last_repricing_dt -- 上次重定价日
    ,next_repricing_dt -- 下次重定价日
    ,repricing_freq -- 重定价频率
    ,repricing_freq_mult -- 重定价频率单位
    ,overdue_flag -- 逾期标志
    ,position_inc_dt -- 业务新增日期
    ,agmt_deposit_flag -- 是否协定存款标志
    ,excess_reserce_flag -- 是否超额准备金标志
    ,iflock_flag -- 是否锁定利差标志
    ,loan_class_cd -- 贷款质量分类
    ,cur_bal -- 当前余额
    ,accbal_month -- 月累计余额
    ,accbal_quar -- 季累计余额
    ,accbal_year -- 年累计余额
    ,exercise_interest_rate -- 执行利率
    ,base_ftp_rate -- 原始ftp利率
    ,mid_ftp_rate -- 内生性调节后ftp利率
    ,final_ftp_rate -- 最终ftp利率
    ,lock_spread -- 锁定利差值
    ,base_unlock_ftp_rate -- 原始非锁定ftp利率
    ,mid_unlock_ftp_rate -- 内生性调节后非锁定ftp利率
    ,final_unlock_ftp_rate -- 最终非锁定ftp利率
    ,accint_day -- 利息收支日累计
    ,accint_month -- 利息收支月累计
    ,accint_quar -- 利息收支季累计
    ,accint_year -- 利息收支年累计
    ,base_ftp_accint_day -- 原始ftp利息日累计
    ,base_ftp_accint_month -- 原始ftp利息月累计
    ,base_ftp_accint_quar -- 原始ftp利息季累计
    ,base_ftp_accint_year -- 原始ftp利息年累计
    ,mid_ftp_accint_day -- 内生性调节后ftp利息日累计
    ,mid_ftp_accint_month -- 内生性调节后ftp利息月累计
    ,mid_ftp_accint_quar -- 内生性调节后ftp利息季累计
    ,mid_ftp_accint_year -- 内生性调节后ftp利息年累计
    ,final_ftp_accint_day -- 最终ftp利息日累计
    ,final_ftp_accint_month -- 最终ftp利息月累计
    ,final_ftp_accint_quar -- 最终ftp利息季累计
    ,final_ftp_accint_year -- 最终ftp利息年累计
    ,base_unlock_ftp_accint_day -- 原始非锁定ftp利息日累计
    ,base_unlock_ftp_accint_month -- 原始非锁定ftp利息月累计
    ,base_unlock_ftp_accint_quar -- 原始非锁定ftp利息季累计
    ,base_unlock_ftp_accint_year -- 原始非锁定ftp利息年累计
    ,mid_unlock_ftp_accint_day -- 内生性调节后非锁定ftp利息日累计
    ,mid_unlock_ftp_accint_month -- 内生性调节后非锁定ftp利息月累计
    ,mid_unlock_ftp_accint_quar -- 内生性调节后非锁定ftp利息季累计
    ,mid_unlock_ftp_accint_year -- 内生性调节后非锁定ftp利息年累计
    ,final_unlock_ftp_accint_day -- 最终非锁定ftp利息日累计
    ,final_unlock_ftp_accint_month -- 最终非锁定ftp利息月累计
    ,final_unlock_ftp_accint_quar -- 最终非锁定ftp利息季累计
    ,final_unlock_ftp_accint_year -- 最终非锁定ftp利息年累计
    ,adjust_01_rate -- 调节项1点差
    ,adjust_01_accint_day -- 调节项1金额日累计
    ,adjust_01_accint_month -- 调节项1金额月累计
    ,adjust_01_accint_quar -- 调节项1金额季累计
    ,adjust_01_accint_year -- 调节项1金额年累计
    ,adjust_02_rate -- 调节项2点差
    ,adjust_02_accint_day -- 调节项2金额日累计
    ,adjust_02_accint_month -- 调节项2金额月累计
    ,adjust_02_accint_quar -- 调节项2金额季累计
    ,adjust_02_accint_year -- 调节项2金额年累计
    ,adjust_03_rate -- 调节项3点差
    ,adjust_03_accint_day -- 调节项3金额日累计
    ,adjust_03_accint_month -- 调节项3金额月累计
    ,adjust_03_accint_quar -- 调节项3金额季累计
    ,adjust_03_accint_year -- 调节项3金额年累计
    ,adjust_04_rate -- 调节项4点差
    ,adjust_04_accint_day -- 调节项4金额日累计
    ,adjust_04_accint_month -- 调节项4金额月累计
    ,adjust_04_accint_quar -- 调节项4金额季累计
    ,adjust_04_accint_year -- 调节项4金额年累计
    ,adjust_05_rate -- 调节项5点差
    ,adjust_05_accint_day -- 调节项5金额日累计
    ,adjust_05_accint_month -- 调节项5金额月累计
    ,adjust_05_accint_quar -- 调节项5金额季累计
    ,adjust_05_accint_year -- 调节项5金额年累计
    ,adjust_06_rate -- 调节项6点差
    ,adjust_06_accint_day -- 调节项6金额日累计
    ,adjust_06_accint_month -- 调节项6金额月累计
    ,adjust_06_accint_quar -- 调节项6金额季累计
    ,adjust_06_accint_year -- 调节项6金额年累计
    ,adjust_07_rate -- 调节项7点差
    ,adjust_07_accint_day -- 调节项7金额日累计
    ,adjust_07_accint_month -- 调节项7金额月累计
    ,adjust_07_accint_quar -- 调节项7金额季累计
    ,adjust_07_accint_year -- 调节项7金额年累计
    ,adjust_08_rate -- 调节项8点差
    ,adjust_08_accint_day -- 调节项8金额日累计
    ,adjust_08_accint_month -- 调节项8金额月累计
    ,adjust_08_accint_quar -- 调节项8金额季累计
    ,adjust_08_accint_year -- 调节项8金额年累计
    ,adjust_09_rate -- 调节项9点差
    ,adjust_09_accint_day -- 调节项9金额日累计
    ,adjust_09_accint_month -- 调节项9金额月累计
    ,adjust_09_accint_quar -- 调节项9金额季累计
    ,adjust_09_accint_year -- 调节项9金额年累计
    ,adjust_10_rate -- 调节项10点差
    ,adjust_10_accint_day -- 调节项10金额日累计
    ,adjust_10_accint_month -- 调节项10金额月累计
    ,adjust_10_accint_quar -- 调节项10金额季累计
    ,adjust_10_accint_year -- 调节项10金额年累计
    ,adjust_11_rate -- 调节项11点差
    ,adjust_11_accint_day -- 调节项11金额日累计
    ,adjust_11_accint_month -- 调节项11金额月累计
    ,adjust_11_accint_quar -- 调节项11金额季累计
    ,adjust_11_accint_year -- 调节项11金额年累计
    ,adjust_12_rate -- 调节项12点差
    ,adjust_12_accint_day -- 调节项12金额日累计
    ,adjust_12_accint_month -- 调节项12金额月累计
    ,adjust_12_accint_quar -- 调节项12金额季累计
    ,adjust_12_accint_year -- 调节项12金额年累计
    ,adjust_13_rate -- 调节项13点差
    ,adjust_13_accint_day -- 调节项13金额日累计
    ,adjust_13_accint_month -- 调节项13金额月累计
    ,adjust_13_accint_quar -- 调节项13金额季累计
    ,adjust_13_accint_year -- 调节项13金额年累计
    ,adjust_14_rate -- 调节项14点差
    ,adjust_14_accint_day -- 调节项14金额日累计
    ,adjust_14_accint_month -- 调节项14金额月累计
    ,adjust_14_accint_quar -- 调节项14金额季累计
    ,adjust_14_accint_year -- 调节项14金额年累计
    ,adjust_15_rate -- 调节项15点差
    ,adjust_15_accint_day -- 调节项15金额日累计
    ,adjust_15_accint_month -- 调节项15金额月累计
    ,adjust_15_accint_quar -- 调节项15金额季累计
    ,adjust_15_accint_year -- 调节项15金额年累计
    ,adjust_16_rate -- 调节项16点差
    ,adjust_16_accint_day -- 调节项16金额日累计
    ,adjust_16_accint_month -- 调节项16金额月累计
    ,adjust_16_accint_quar -- 调节项16金额季累计
    ,adjust_16_accint_year -- 调节项16金额年累计
    ,adjust_17_rate -- 调节项17点差
    ,adjust_17_accint_day -- 调节项17金额日累计
    ,adjust_17_accint_month -- 调节项17金额月累计
    ,adjust_17_accint_quar -- 调节项17金额季累计
    ,adjust_17_accint_year -- 调节项17金额年累计
    ,adjust_18_rate -- 调节项18点差
    ,adjust_18_accint_day -- 调节项18金额日累计
    ,adjust_18_accint_month -- 调节项18金额月累计
    ,adjust_18_accint_quar -- 调节项18金额季累计
    ,adjust_18_accint_year -- 调节项18金额年累计
    ,adjust_19_rate -- 调节项19点差
    ,adjust_19_accint_day -- 调节项19金额日累计
    ,adjust_19_accint_month -- 调节项19金额月累计
    ,adjust_19_accint_quar -- 调节项19金额季累计
    ,adjust_19_accint_year -- 调节项19金额年累计
    ,adjust_20_rate -- 调节项20点差
    ,adjust_20_accint_day -- 调节项20金额日累计
    ,adjust_20_accint_month -- 调节项20金额月累计
    ,adjust_20_accint_quar -- 调节项20金额季累计
    ,adjust_20_accint_year -- 调节项20金额年累计
    ,inc_spred_accint_day -- 价差收益日累计
    ,inc_spred_accint_month -- 价差收益月累计
    ,inc_spred_accint_quar -- 价差收益季累计
    ,inc_spred_accint_year -- 价差收益年累计
    ,exchange_to_cny_rate -- 折人民币汇率
    ,exchange_to_usd_rate -- 折美元汇率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ftps_rpt_rst_ftp261
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ftps_rpt_rst_ftp261 exchange partition p_${batch_date} with table ${iol_schema}.ftps_rpt_rst_ftp261_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ftps_rpt_rst_ftp261 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ftps_rpt_rst_ftp261_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ftps_rpt_rst_ftp261',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);