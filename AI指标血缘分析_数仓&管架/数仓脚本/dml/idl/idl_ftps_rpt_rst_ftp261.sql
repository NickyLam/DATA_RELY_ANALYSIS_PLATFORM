/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ftps_rpt_rst_ftp261
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.ftps_rpt_rst_ftp261 drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ftps_rpt_rst_ftp261 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ftps_rpt_rst_ftp261 partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,acct_no  -- 账号
    ,s_acct_no  -- 拆分前账号
    ,t_acct_no  -- 源账号
    ,data_dt  -- 数据日期
    ,share_percent  -- 分成比例
    ,price_unit_cd  -- 定价单元
    ,prod_cd  -- 产品代码
    ,core_prod_cd  -- 核心系统产品码
    ,credit_prod_cd  -- 信贷系统产品码
    ,industry_cd  -- 行业代码
    ,subject_cd  -- 科目代码
    ,currency_cd  -- 币种代码
    ,acct_org_cd  -- 核算机构
    ,assess_org_cd  -- 考核机构代码
    ,bond_categ_cd  -- 债券种类代码
    ,al_flag  -- 资产负债标志
    ,biz_flag  -- 对公对私业务标识
    ,biz_line_cd  -- 业务条线代码
    ,data_src  -- 数据来源
    ,channel_cd  -- 渠道代码
    ,interest_adjust_type_cd  -- 利率调整方式代码
    ,cust_id  -- 客户号
    ,cust_name  -- 客户名称
    ,mgr_id  -- 客户经理号
    ,mgr_name  -- 客户经理名称
    ,cust_size_cd  -- 客户规模
    ,cust_type_cd  -- 客户类型代码
    ,accrual_basis_cd  -- 计息方式代码
    ,original_term  -- 原始期限
    ,original_term_mult  -- 原始期限单位
    ,start_dt  -- 起息日
    ,maturity_dt  -- 到期日
    ,open_dt  -- 开户日
    ,close_dt  -- 销户日
    ,last_payment_dt  -- 上次还款日
    ,next_payment_dt  -- 下次还款日
    ,payment_type_cd  -- 还款方式代码
    ,payment_freq  -- 还款频率
    ,payment_freq_mult  -- 还款频率单位
    ,last_repricing_dt  -- 上次重定价日
    ,next_repricing_dt  -- 下次重定价日
    ,repricing_freq  -- 重定价频率
    ,repricing_freq_mult  -- 重定价频率单位
    ,overdue_flag  -- 逾期标志
    ,position_inc_dt  -- 业务新增日期
    ,agmt_deposit_flag  -- 是否协定存款标志
    ,excess_reserce_flag  -- 是否超额准备金标志
    ,iflock_flag  -- 是否锁定利差标志
    ,loan_class_cd  -- 贷款质量分类
    ,cur_bal  -- 当前余额
    ,accbal_month  -- 月累计余额
    ,accbal_quar  -- 季累计余额
    ,accbal_year  -- 年累计余额
    ,exercise_interest_rate  -- 执行利率
    ,base_ftp_rate  -- 原始ftp利率
    ,mid_ftp_rate  -- 内生性调节后ftp利率
    ,final_ftp_rate  -- 最终ftp利率
    ,lock_spread  -- 锁定利差值
    ,base_unlock_ftp_rate  -- 原始非锁定ftp利率
    ,mid_unlock_ftp_rate  -- 内生性调节后非锁定ftp利率
    ,final_unlock_ftp_rate  -- 最终非锁定ftp利率
    ,accint_day  -- 利息收支日累计
    ,accint_month  -- 利息收支月累计
    ,accint_quar  -- 利息收支季累计
    ,accint_year  -- 利息收支年累计
    ,base_ftp_accint_day  -- 原始ftp利息日累计
    ,base_ftp_accint_month  -- 原始ftp利息月累计
    ,base_ftp_accint_quar  -- 原始ftp利息季累计
    ,base_ftp_accint_year  -- 原始ftp利息年累计
    ,mid_ftp_accint_day  -- 内生性调节后ftp利息日累计
    ,mid_ftp_accint_month  -- 内生性调节后ftp利息月累计
    ,mid_ftp_accint_quar  -- 内生性调节后ftp利息季累计
    ,mid_ftp_accint_year  -- 内生性调节后ftp利息年累计
    ,final_ftp_accint_day  -- 最终ftp利息日累计
    ,final_ftp_accint_month  -- 最终ftp利息月累计
    ,final_ftp_accint_quar  -- 最终ftp利息季累计
    ,final_ftp_accint_year  -- 最终ftp利息年累计
    ,base_unlock_ftp_accint_day  -- 原始非锁定ftp利息日累计
    ,base_unlock_ftp_accint_month  -- 原始非锁定ftp利息月累计
    ,base_unlock_ftp_accint_quar  -- 原始非锁定ftp利息季累计
    ,base_unlock_ftp_accint_year  -- 原始非锁定ftp利息年累计
    ,mid_unlock_ftp_accint_day  -- 内生性调节后非锁定ftp利息日累计
    ,mid_unlock_ftp_accint_month  -- 内生性调节后非锁定ftp利息月累计
    ,mid_unlock_ftp_accint_quar  -- 内生性调节后非锁定ftp利息季累计
    ,mid_unlock_ftp_accint_year  -- 内生性调节后非锁定ftp利息年累计
    ,final_unlock_ftp_accint_day  -- 最终非锁定ftp利息日累计
    ,final_unlock_ftp_accint_month  -- 最终非锁定ftp利息月累计
    ,final_unlock_ftp_accint_quar  -- 最终非锁定ftp利息季累计
    ,final_unlock_ftp_accint_year  -- 最终非锁定ftp利息年累计
    ,adjust_01_rate  -- 调节项1点差
    ,adjust_01_accint_day  -- 调节项1金额日累计
    ,adjust_01_accint_month  -- 调节项1金额月累计
    ,adjust_01_accint_quar  -- 调节项1金额季累计
    ,adjust_01_accint_year  -- 调节项1金额年累计
    ,adjust_02_rate  -- 调节项2点差
    ,adjust_02_accint_day  -- 调节项2金额日累计
    ,adjust_02_accint_month  -- 调节项2金额月累计
    ,adjust_02_accint_quar  -- 调节项2金额季累计
    ,adjust_02_accint_year  -- 调节项2金额年累计
    ,adjust_03_rate  -- 调节项3点差
    ,adjust_03_accint_day  -- 调节项3金额日累计
    ,adjust_03_accint_month  -- 调节项3金额月累计
    ,adjust_03_accint_quar  -- 调节项3金额季累计
    ,adjust_03_accint_year  -- 调节项3金额年累计
    ,adjust_04_rate  -- 调节项4点差
    ,adjust_04_accint_day  -- 调节项4金额日累计
    ,adjust_04_accint_month  -- 调节项4金额月累计
    ,adjust_04_accint_quar  -- 调节项4金额季累计
    ,adjust_04_accint_year  -- 调节项4金额年累计
    ,adjust_05_rate  -- 调节项5点差
    ,adjust_05_accint_day  -- 调节项5金额日累计
    ,adjust_05_accint_month  -- 调节项5金额月累计
    ,adjust_05_accint_quar  -- 调节项5金额季累计
    ,adjust_05_accint_year  -- 调节项5金额年累计
    ,adjust_06_rate  -- 调节项6点差
    ,adjust_06_accint_day  -- 调节项6金额日累计
    ,adjust_06_accint_month  -- 调节项6金额月累计
    ,adjust_06_accint_quar  -- 调节项6金额季累计
    ,adjust_06_accint_year  -- 调节项6金额年累计
    ,adjust_07_rate  -- 调节项7点差
    ,adjust_07_accint_day  -- 调节项7金额日累计
    ,adjust_07_accint_month  -- 调节项7金额月累计
    ,adjust_07_accint_quar  -- 调节项7金额季累计
    ,adjust_07_accint_year  -- 调节项7金额年累计
    ,adjust_08_rate  -- 调节项8点差
    ,adjust_08_accint_day  -- 调节项8金额日累计
    ,adjust_08_accint_month  -- 调节项8金额月累计
    ,adjust_08_accint_quar  -- 调节项8金额季累计
    ,adjust_08_accint_year  -- 调节项8金额年累计
    ,adjust_09_rate  -- 调节项9点差
    ,adjust_09_accint_day  -- 调节项9金额日累计
    ,adjust_09_accint_month  -- 调节项9金额月累计
    ,adjust_09_accint_quar  -- 调节项9金额季累计
    ,adjust_09_accint_year  -- 调节项9金额年累计
    ,adjust_10_rate  -- 调节项10点差
    ,adjust_10_accint_day  -- 调节项10金额日累计
    ,adjust_10_accint_month  -- 调节项10金额月累计
    ,adjust_10_accint_quar  -- 调节项10金额季累计
    ,adjust_10_accint_year  -- 调节项10金额年累计
    ,adjust_11_rate  -- 调节项11点差
    ,adjust_11_accint_day  -- 调节项11金额日累计
    ,adjust_11_accint_month  -- 调节项11金额月累计
    ,adjust_11_accint_quar  -- 调节项11金额季累计
    ,adjust_11_accint_year  -- 调节项11金额年累计
    ,adjust_12_rate  -- 调节项12点差
    ,adjust_12_accint_day  -- 调节项12金额日累计
    ,adjust_12_accint_month  -- 调节项12金额月累计
    ,adjust_12_accint_quar  -- 调节项12金额季累计
    ,adjust_12_accint_year  -- 调节项12金额年累计
    ,adjust_13_rate  -- 调节项13点差
    ,adjust_13_accint_day  -- 调节项13金额日累计
    ,adjust_13_accint_month  -- 调节项13金额月累计
    ,adjust_13_accint_quar  -- 调节项13金额季累计
    ,adjust_13_accint_year  -- 调节项13金额年累计
    ,adjust_14_rate  -- 调节项14点差
    ,adjust_14_accint_day  -- 调节项14金额日累计
    ,adjust_14_accint_month  -- 调节项14金额月累计
    ,adjust_14_accint_quar  -- 调节项14金额季累计
    ,adjust_14_accint_year  -- 调节项14金额年累计
    ,adjust_15_rate  -- 调节项15点差
    ,adjust_15_accint_day  -- 调节项15金额日累计
    ,adjust_15_accint_month  -- 调节项15金额月累计
    ,adjust_15_accint_quar  -- 调节项15金额季累计
    ,adjust_15_accint_year  -- 调节项15金额年累计
    ,adjust_16_rate  -- 调节项16点差
    ,adjust_16_accint_day  -- 调节项16金额日累计
    ,adjust_16_accint_month  -- 调节项16金额月累计
    ,adjust_16_accint_quar  -- 调节项16金额季累计
    ,adjust_16_accint_year  -- 调节项16金额年累计
    ,adjust_17_rate  -- 调节项17点差
    ,adjust_17_accint_day  -- 调节项17金额日累计
    ,adjust_17_accint_month  -- 调节项17金额月累计
    ,adjust_17_accint_quar  -- 调节项17金额季累计
    ,adjust_17_accint_year  -- 调节项17金额年累计
    ,adjust_18_rate  -- 调节项18点差
    ,adjust_18_accint_day  -- 调节项18金额日累计
    ,adjust_18_accint_month  -- 调节项18金额月累计
    ,adjust_18_accint_quar  -- 调节项18金额季累计
    ,adjust_18_accint_year  -- 调节项18金额年累计
    ,adjust_19_rate  -- 调节项19点差
    ,adjust_19_accint_day  -- 调节项19金额日累计
    ,adjust_19_accint_month  -- 调节项19金额月累计
    ,adjust_19_accint_quar  -- 调节项19金额季累计
    ,adjust_19_accint_year  -- 调节项19金额年累计
    ,adjust_20_rate  -- 调节项20点差
    ,adjust_20_accint_day  -- 调节项20金额日累计
    ,adjust_20_accint_month  -- 调节项20金额月累计
    ,adjust_20_accint_quar  -- 调节项20金额季累计
    ,adjust_20_accint_year  -- 调节项20金额年累计
    ,inc_spred_accint_day  -- 价差收益日累计
    ,inc_spred_accint_month  -- 价差收益月累计
    ,inc_spred_accint_quar  -- 价差收益季累计
    ,inc_spred_accint_year  -- 价差收益年累计
    ,exchange_to_cny_rate  -- 折人民币汇率
    ,exchange_to_usd_rate  -- 折美元汇率
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t.acct_no,chr(13),''),chr(10),'') as acct_no  -- 账号
    ,replace(replace(t.s_acct_no,chr(13),''),chr(10),'') as s_acct_no  -- 拆分前账号
    ,replace(replace(t.t_acct_no,chr(13),''),chr(10),'') as t_acct_no  -- 源账号
    ,t.data_dt as data_dt  -- 数据日期
    ,t.share_percent as share_percent  -- 分成比例
    ,replace(replace(t.price_unit_cd,chr(13),''),chr(10),'') as price_unit_cd  -- 定价单元
    ,replace(replace(t.prod_cd,chr(13),''),chr(10),'') as prod_cd  -- 产品代码
    ,replace(replace(t.core_prod_cd,chr(13),''),chr(10),'') as core_prod_cd  -- 核心系统产品码
    ,replace(replace(t.credit_prod_cd,chr(13),''),chr(10),'') as credit_prod_cd  -- 信贷系统产品码
    ,replace(replace(t.industry_cd,chr(13),''),chr(10),'') as industry_cd  -- 行业代码
    ,replace(replace(t.subject_cd,chr(13),''),chr(10),'') as subject_cd  -- 科目代码
    ,replace(replace(t.currency_cd,chr(13),''),chr(10),'') as currency_cd  -- 币种代码
    ,replace(replace(t.acct_org_cd,chr(13),''),chr(10),'') as acct_org_cd  -- 核算机构
    ,replace(replace(t.assess_org_cd,chr(13),''),chr(10),'') as assess_org_cd  -- 考核机构代码
    ,replace(replace(t.bond_categ_cd,chr(13),''),chr(10),'') as bond_categ_cd  -- 债券种类代码
    ,replace(replace(t.al_flag,chr(13),''),chr(10),'') as al_flag  -- 资产负债标志
    ,replace(replace(t.biz_flag,chr(13),''),chr(10),'') as biz_flag  -- 对公对私业务标识
    ,replace(replace(t.biz_line_cd,chr(13),''),chr(10),'') as biz_line_cd  -- 业务条线代码
    ,replace(replace(t.data_src,chr(13),''),chr(10),'') as data_src  -- 数据来源
    ,replace(replace(t.channel_cd,chr(13),''),chr(10),'') as channel_cd  -- 渠道代码
    ,replace(replace(t.interest_adjust_type_cd,chr(13),''),chr(10),'') as interest_adjust_type_cd  -- 利率调整方式代码
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户号
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name  -- 客户名称
    ,replace(replace(t.mgr_id,chr(13),''),chr(10),'') as mgr_id  -- 客户经理号
    ,replace(replace(t.mgr_name,chr(13),''),chr(10),'') as mgr_name  -- 客户经理名称
    ,replace(replace(t.cust_size_cd,chr(13),''),chr(10),'') as cust_size_cd  -- 客户规模
    ,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd  -- 客户类型代码
    ,replace(replace(t.accrual_basis_cd,chr(13),''),chr(10),'') as accrual_basis_cd  -- 计息方式代码
    ,t.original_term as original_term  -- 原始期限
    ,replace(replace(t.original_term_mult,chr(13),''),chr(10),'') as original_term_mult  -- 原始期限单位
    ,t.start_dt as start_dt  -- 起息日
    ,t.maturity_dt as maturity_dt  -- 到期日
    ,t.open_dt as open_dt  -- 开户日
    ,t.close_dt as close_dt  -- 销户日
    ,t.last_payment_dt as last_payment_dt  -- 上次还款日
    ,t.next_payment_dt as next_payment_dt  -- 下次还款日
    ,replace(replace(t.payment_type_cd,chr(13),''),chr(10),'') as payment_type_cd  -- 还款方式代码
    ,t.payment_freq as payment_freq  -- 还款频率
    ,replace(replace(t.payment_freq_mult,chr(13),''),chr(10),'') as payment_freq_mult  -- 还款频率单位
    ,t.last_repricing_dt as last_repricing_dt  -- 上次重定价日
    ,t.next_repricing_dt as next_repricing_dt  -- 下次重定价日
    ,t.repricing_freq as repricing_freq  -- 重定价频率
    ,replace(replace(t.repricing_freq_mult,chr(13),''),chr(10),'') as repricing_freq_mult  -- 重定价频率单位
    ,replace(replace(t.overdue_flag,chr(13),''),chr(10),'') as overdue_flag  -- 逾期标志
    ,t.position_inc_dt as position_inc_dt  -- 业务新增日期
    ,replace(replace(t.agmt_deposit_flag,chr(13),''),chr(10),'') as agmt_deposit_flag  -- 是否协定存款标志
    ,replace(replace(t.excess_reserce_flag,chr(13),''),chr(10),'') as excess_reserce_flag  -- 是否超额准备金标志
    ,replace(replace(t.iflock_flag,chr(13),''),chr(10),'') as iflock_flag  -- 是否锁定利差标志
    ,replace(replace(t.loan_class_cd,chr(13),''),chr(10),'') as loan_class_cd  -- 贷款质量分类
    ,t.cur_bal as cur_bal  -- 当前余额
    ,t.accbal_month as accbal_month  -- 月累计余额
    ,t.accbal_quar as accbal_quar  -- 季累计余额
    ,t.accbal_year as accbal_year  -- 年累计余额
    ,t.exercise_interest_rate as exercise_interest_rate  -- 执行利率
    ,t.base_ftp_rate as base_ftp_rate  -- 原始ftp利率
    ,t.mid_ftp_rate as mid_ftp_rate  -- 内生性调节后ftp利率
    ,t.final_ftp_rate as final_ftp_rate  -- 最终ftp利率
    ,t.lock_spread as lock_spread  -- 锁定利差值
    ,t.base_unlock_ftp_rate as base_unlock_ftp_rate  -- 原始非锁定ftp利率
    ,t.mid_unlock_ftp_rate as mid_unlock_ftp_rate  -- 内生性调节后非锁定ftp利率
    ,t.final_unlock_ftp_rate as final_unlock_ftp_rate  -- 最终非锁定ftp利率
    ,t.accint_day as accint_day  -- 利息收支日累计
    ,t.accint_month as accint_month  -- 利息收支月累计
    ,t.accint_quar as accint_quar  -- 利息收支季累计
    ,t.accint_year as accint_year  -- 利息收支年累计
    ,t.base_ftp_accint_day as base_ftp_accint_day  -- 原始ftp利息日累计
    ,t.base_ftp_accint_month as base_ftp_accint_month  -- 原始ftp利息月累计
    ,t.base_ftp_accint_quar as base_ftp_accint_quar  -- 原始ftp利息季累计
    ,t.base_ftp_accint_year as base_ftp_accint_year  -- 原始ftp利息年累计
    ,t.mid_ftp_accint_day as mid_ftp_accint_day  -- 内生性调节后ftp利息日累计
    ,t.mid_ftp_accint_month as mid_ftp_accint_month  -- 内生性调节后ftp利息月累计
    ,t.mid_ftp_accint_quar as mid_ftp_accint_quar  -- 内生性调节后ftp利息季累计
    ,t.mid_ftp_accint_year as mid_ftp_accint_year  -- 内生性调节后ftp利息年累计
    ,t.final_ftp_accint_day as final_ftp_accint_day  -- 最终ftp利息日累计
    ,t.final_ftp_accint_month as final_ftp_accint_month  -- 最终ftp利息月累计
    ,t.final_ftp_accint_quar as final_ftp_accint_quar  -- 最终ftp利息季累计
    ,t.final_ftp_accint_year as final_ftp_accint_year  -- 最终ftp利息年累计
    ,t.base_unlock_ftp_accint_day as base_unlock_ftp_accint_day  -- 原始非锁定ftp利息日累计
    ,t.base_unlock_ftp_accint_month as base_unlock_ftp_accint_month  -- 原始非锁定ftp利息月累计
    ,t.base_unlock_ftp_accint_quar as base_unlock_ftp_accint_quar  -- 原始非锁定ftp利息季累计
    ,t.base_unlock_ftp_accint_year as base_unlock_ftp_accint_year  -- 原始非锁定ftp利息年累计
    ,t.mid_unlock_ftp_accint_day as mid_unlock_ftp_accint_day  -- 内生性调节后非锁定ftp利息日累计
    ,t.mid_unlock_ftp_accint_month as mid_unlock_ftp_accint_month  -- 内生性调节后非锁定ftp利息月累计
    ,t.mid_unlock_ftp_accint_quar as mid_unlock_ftp_accint_quar  -- 内生性调节后非锁定ftp利息季累计
    ,t.mid_unlock_ftp_accint_year as mid_unlock_ftp_accint_year  -- 内生性调节后非锁定ftp利息年累计
    ,t.final_unlock_ftp_accint_day as final_unlock_ftp_accint_day  -- 最终非锁定ftp利息日累计
    ,t.final_unlock_ftp_accint_month as final_unlock_ftp_accint_month  -- 最终非锁定ftp利息月累计
    ,t.final_unlock_ftp_accint_quar as final_unlock_ftp_accint_quar  -- 最终非锁定ftp利息季累计
    ,t.final_unlock_ftp_accint_year as final_unlock_ftp_accint_year  -- 最终非锁定ftp利息年累计
    ,t.adjust_01_rate as adjust_01_rate  -- 调节项1点差
    ,t.adjust_01_accint_day as adjust_01_accint_day  -- 调节项1金额日累计
    ,t.adjust_01_accint_month as adjust_01_accint_month  -- 调节项1金额月累计
    ,t.adjust_01_accint_quar as adjust_01_accint_quar  -- 调节项1金额季累计
    ,t.adjust_01_accint_year as adjust_01_accint_year  -- 调节项1金额年累计
    ,t.adjust_02_rate as adjust_02_rate  -- 调节项2点差
    ,t.adjust_02_accint_day as adjust_02_accint_day  -- 调节项2金额日累计
    ,t.adjust_02_accint_month as adjust_02_accint_month  -- 调节项2金额月累计
    ,t.adjust_02_accint_quar as adjust_02_accint_quar  -- 调节项2金额季累计
    ,t.adjust_02_accint_year as adjust_02_accint_year  -- 调节项2金额年累计
    ,t.adjust_03_rate as adjust_03_rate  -- 调节项3点差
    ,t.adjust_03_accint_day as adjust_03_accint_day  -- 调节项3金额日累计
    ,t.adjust_03_accint_month as adjust_03_accint_month  -- 调节项3金额月累计
    ,t.adjust_03_accint_quar as adjust_03_accint_quar  -- 调节项3金额季累计
    ,t.adjust_03_accint_year as adjust_03_accint_year  -- 调节项3金额年累计
    ,t.adjust_04_rate as adjust_04_rate  -- 调节项4点差
    ,t.adjust_04_accint_day as adjust_04_accint_day  -- 调节项4金额日累计
    ,t.adjust_04_accint_month as adjust_04_accint_month  -- 调节项4金额月累计
    ,t.adjust_04_accint_quar as adjust_04_accint_quar  -- 调节项4金额季累计
    ,t.adjust_04_accint_year as adjust_04_accint_year  -- 调节项4金额年累计
    ,t.adjust_05_rate as adjust_05_rate  -- 调节项5点差
    ,t.adjust_05_accint_day as adjust_05_accint_day  -- 调节项5金额日累计
    ,t.adjust_05_accint_month as adjust_05_accint_month  -- 调节项5金额月累计
    ,t.adjust_05_accint_quar as adjust_05_accint_quar  -- 调节项5金额季累计
    ,t.adjust_05_accint_year as adjust_05_accint_year  -- 调节项5金额年累计
    ,t.adjust_06_rate as adjust_06_rate  -- 调节项6点差
    ,t.adjust_06_accint_day as adjust_06_accint_day  -- 调节项6金额日累计
    ,t.adjust_06_accint_month as adjust_06_accint_month  -- 调节项6金额月累计
    ,t.adjust_06_accint_quar as adjust_06_accint_quar  -- 调节项6金额季累计
    ,t.adjust_06_accint_year as adjust_06_accint_year  -- 调节项6金额年累计
    ,t.adjust_07_rate as adjust_07_rate  -- 调节项7点差
    ,t.adjust_07_accint_day as adjust_07_accint_day  -- 调节项7金额日累计
    ,t.adjust_07_accint_month as adjust_07_accint_month  -- 调节项7金额月累计
    ,t.adjust_07_accint_quar as adjust_07_accint_quar  -- 调节项7金额季累计
    ,t.adjust_07_accint_year as adjust_07_accint_year  -- 调节项7金额年累计
    ,t.adjust_08_rate as adjust_08_rate  -- 调节项8点差
    ,t.adjust_08_accint_day as adjust_08_accint_day  -- 调节项8金额日累计
    ,t.adjust_08_accint_month as adjust_08_accint_month  -- 调节项8金额月累计
    ,t.adjust_08_accint_quar as adjust_08_accint_quar  -- 调节项8金额季累计
    ,t.adjust_08_accint_year as adjust_08_accint_year  -- 调节项8金额年累计
    ,t.adjust_09_rate as adjust_09_rate  -- 调节项9点差
    ,t.adjust_09_accint_day as adjust_09_accint_day  -- 调节项9金额日累计
    ,t.adjust_09_accint_month as adjust_09_accint_month  -- 调节项9金额月累计
    ,t.adjust_09_accint_quar as adjust_09_accint_quar  -- 调节项9金额季累计
    ,t.adjust_09_accint_year as adjust_09_accint_year  -- 调节项9金额年累计
    ,t.adjust_10_rate as adjust_10_rate  -- 调节项10点差
    ,t.adjust_10_accint_day as adjust_10_accint_day  -- 调节项10金额日累计
    ,t.adjust_10_accint_month as adjust_10_accint_month  -- 调节项10金额月累计
    ,t.adjust_10_accint_quar as adjust_10_accint_quar  -- 调节项10金额季累计
    ,t.adjust_10_accint_year as adjust_10_accint_year  -- 调节项10金额年累计
    ,t.adjust_11_rate as adjust_11_rate  -- 调节项11点差
    ,t.adjust_11_accint_day as adjust_11_accint_day  -- 调节项11金额日累计
    ,t.adjust_11_accint_month as adjust_11_accint_month  -- 调节项11金额月累计
    ,t.adjust_11_accint_quar as adjust_11_accint_quar  -- 调节项11金额季累计
    ,t.adjust_11_accint_year as adjust_11_accint_year  -- 调节项11金额年累计
    ,t.adjust_12_rate as adjust_12_rate  -- 调节项12点差
    ,t.adjust_12_accint_day as adjust_12_accint_day  -- 调节项12金额日累计
    ,t.adjust_12_accint_month as adjust_12_accint_month  -- 调节项12金额月累计
    ,t.adjust_12_accint_quar as adjust_12_accint_quar  -- 调节项12金额季累计
    ,t.adjust_12_accint_year as adjust_12_accint_year  -- 调节项12金额年累计
    ,t.adjust_13_rate as adjust_13_rate  -- 调节项13点差
    ,t.adjust_13_accint_day as adjust_13_accint_day  -- 调节项13金额日累计
    ,t.adjust_13_accint_month as adjust_13_accint_month  -- 调节项13金额月累计
    ,t.adjust_13_accint_quar as adjust_13_accint_quar  -- 调节项13金额季累计
    ,t.adjust_13_accint_year as adjust_13_accint_year  -- 调节项13金额年累计
    ,t.adjust_14_rate as adjust_14_rate  -- 调节项14点差
    ,t.adjust_14_accint_day as adjust_14_accint_day  -- 调节项14金额日累计
    ,t.adjust_14_accint_month as adjust_14_accint_month  -- 调节项14金额月累计
    ,t.adjust_14_accint_quar as adjust_14_accint_quar  -- 调节项14金额季累计
    ,t.adjust_14_accint_year as adjust_14_accint_year  -- 调节项14金额年累计
    ,t.adjust_15_rate as adjust_15_rate  -- 调节项15点差
    ,t.adjust_15_accint_day as adjust_15_accint_day  -- 调节项15金额日累计
    ,t.adjust_15_accint_month as adjust_15_accint_month  -- 调节项15金额月累计
    ,t.adjust_15_accint_quar as adjust_15_accint_quar  -- 调节项15金额季累计
    ,t.adjust_15_accint_year as adjust_15_accint_year  -- 调节项15金额年累计
    ,t.adjust_16_rate as adjust_16_rate  -- 调节项16点差
    ,t.adjust_16_accint_day as adjust_16_accint_day  -- 调节项16金额日累计
    ,t.adjust_16_accint_month as adjust_16_accint_month  -- 调节项16金额月累计
    ,t.adjust_16_accint_quar as adjust_16_accint_quar  -- 调节项16金额季累计
    ,t.adjust_16_accint_year as adjust_16_accint_year  -- 调节项16金额年累计
    ,t.adjust_17_rate as adjust_17_rate  -- 调节项17点差
    ,t.adjust_17_accint_day as adjust_17_accint_day  -- 调节项17金额日累计
    ,t.adjust_17_accint_month as adjust_17_accint_month  -- 调节项17金额月累计
    ,t.adjust_17_accint_quar as adjust_17_accint_quar  -- 调节项17金额季累计
    ,t.adjust_17_accint_year as adjust_17_accint_year  -- 调节项17金额年累计
    ,t.adjust_18_rate as adjust_18_rate  -- 调节项18点差
    ,t.adjust_18_accint_day as adjust_18_accint_day  -- 调节项18金额日累计
    ,t.adjust_18_accint_month as adjust_18_accint_month  -- 调节项18金额月累计
    ,t.adjust_18_accint_quar as adjust_18_accint_quar  -- 调节项18金额季累计
    ,t.adjust_18_accint_year as adjust_18_accint_year  -- 调节项18金额年累计
    ,t.adjust_19_rate as adjust_19_rate  -- 调节项19点差
    ,t.adjust_19_accint_day as adjust_19_accint_day  -- 调节项19金额日累计
    ,t.adjust_19_accint_month as adjust_19_accint_month  -- 调节项19金额月累计
    ,t.adjust_19_accint_quar as adjust_19_accint_quar  -- 调节项19金额季累计
    ,t.adjust_19_accint_year as adjust_19_accint_year  -- 调节项19金额年累计
    ,t.adjust_20_rate as adjust_20_rate  -- 调节项20点差
    ,t.adjust_20_accint_day as adjust_20_accint_day  -- 调节项20金额日累计
    ,t.adjust_20_accint_month as adjust_20_accint_month  -- 调节项20金额月累计
    ,t.adjust_20_accint_quar as adjust_20_accint_quar  -- 调节项20金额季累计
    ,t.adjust_20_accint_year as adjust_20_accint_year  -- 调节项20金额年累计
    ,t.inc_spred_accint_day as inc_spred_accint_day  -- 价差收益日累计
    ,t.inc_spred_accint_month as inc_spred_accint_month  -- 价差收益月累计
    ,t.inc_spred_accint_quar as inc_spred_accint_quar  -- 价差收益季累计
    ,t.inc_spred_accint_year as inc_spred_accint_year  -- 价差收益年累计
    ,t.exchange_to_cny_rate as exchange_to_cny_rate  -- 折人民币汇率
    ,t.exchange_to_usd_rate as exchange_to_usd_rate  -- 折美元汇率
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 时间戳
 from ${iol_schema}.ftps_rpt_rst_ftp261 t--ftp初级报表账户明细结果集
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.ftps_rpt_rst_ftp261 to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ftps_rpt_rst_ftp261',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);