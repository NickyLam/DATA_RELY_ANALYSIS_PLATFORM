/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ftps_rpt_rst_ftp261
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.ftps_rpt_rst_ftp261
whenever sqlerror continue none;
drop table ${idl_schema}.ftps_rpt_rst_ftp261 purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.ftps_rpt_rst_ftp261(
    etl_dt date -- ETL处理日期
    ,acct_no varchar2(60) -- 账号
    ,s_acct_no varchar2(60) -- 拆分前账号
    ,t_acct_no varchar2(60) -- 源账号
    ,data_dt date -- 数据日期
    ,share_percent number(24,6) -- 分成比例
    ,price_unit_cd varchar2(30) -- 定价单元
    ,prod_cd varchar2(20) -- 产品代码
    ,core_prod_cd varchar2(20) -- 核心系统产品码
    ,credit_prod_cd varchar2(20) -- 信贷系统产品码
    ,industry_cd varchar2(10) -- 行业代码
    ,subject_cd varchar2(20) -- 科目代码
    ,currency_cd varchar2(10) -- 币种代码
    ,acct_org_cd varchar2(20) -- 核算机构
    ,assess_org_cd varchar2(20) -- 考核机构代码
    ,bond_categ_cd varchar2(20) -- 债券种类代码
    ,al_flag varchar2(1) -- 资产负债标志
    ,biz_flag varchar2(1) -- 对公对私业务标识
    ,biz_line_cd varchar2(10) -- 业务条线代码
    ,data_src varchar2(20) -- 数据来源
    ,channel_cd varchar2(20) -- 渠道代码
    ,interest_adjust_type_cd varchar2(1) -- 利率调整方式代码
    ,cust_id varchar2(30) -- 客户号
    ,cust_name varchar2(100) -- 客户名称
    ,mgr_id varchar2(30) -- 客户经理号
    ,mgr_name varchar2(100) -- 客户经理名称
    ,cust_size_cd varchar2(20) -- 客户规模
    ,cust_type_cd varchar2(20) -- 客户类型代码
    ,accrual_basis_cd varchar2(2) -- 计息方式代码
    ,original_term number(5) -- 原始期限
    ,original_term_mult varchar2(2) -- 原始期限单位
    ,start_dt date -- 起息日
    ,maturity_dt date -- 到期日
    ,open_dt date -- 开户日
    ,close_dt date -- 销户日
    ,last_payment_dt date -- 上次还款日
    ,next_payment_dt date -- 下次还款日
    ,payment_type_cd varchar2(10) -- 还款方式代码
    ,payment_freq number(5) -- 还款频率
    ,payment_freq_mult varchar2(1) -- 还款频率单位
    ,last_repricing_dt date -- 上次重定价日
    ,next_repricing_dt date -- 下次重定价日
    ,repricing_freq number(5) -- 重定价频率
    ,repricing_freq_mult varchar2(1) -- 重定价频率单位
    ,overdue_flag varchar2(10) -- 逾期标志
    ,position_inc_dt date -- 业务新增日期
    ,agmt_deposit_flag varchar2(1) -- 是否协定存款标志
    ,excess_reserce_flag varchar2(1) -- 是否超额准备金标志
    ,iflock_flag varchar2(1) -- 是否锁定利差标志
    ,loan_class_cd varchar2(10) -- 贷款质量分类
    ,cur_bal number(24,6) -- 当前余额
    ,accbal_month number(24,6) -- 月累计余额
    ,accbal_quar number(24,6) -- 季累计余额
    ,accbal_year number(24,6) -- 年累计余额
    ,exercise_interest_rate number(10,6) -- 执行利率
    ,base_ftp_rate number(10,6) -- 原始ftp利率
    ,mid_ftp_rate number(10,6) -- 内生性调节后ftp利率
    ,final_ftp_rate number(10,6) -- 最终ftp利率
    ,lock_spread number(10,6) -- 锁定利差值
    ,base_unlock_ftp_rate number(10,6) -- 原始非锁定ftp利率
    ,mid_unlock_ftp_rate number(10,6) -- 内生性调节后非锁定ftp利率
    ,final_unlock_ftp_rate number(10,6) -- 最终非锁定ftp利率
    ,accint_day number(24,6) -- 利息收支日累计
    ,accint_month number(24,6) -- 利息收支月累计
    ,accint_quar number(24,6) -- 利息收支季累计
    ,accint_year number(24,6) -- 利息收支年累计
    ,base_ftp_accint_day number(24,6) -- 原始ftp利息日累计
    ,base_ftp_accint_month number(24,6) -- 原始ftp利息月累计
    ,base_ftp_accint_quar number(24,6) -- 原始ftp利息季累计
    ,base_ftp_accint_year number(24,6) -- 原始ftp利息年累计
    ,mid_ftp_accint_day number(24,6) -- 内生性调节后ftp利息日累计
    ,mid_ftp_accint_month number(24,6) -- 内生性调节后ftp利息月累计
    ,mid_ftp_accint_quar number(24,6) -- 内生性调节后ftp利息季累计
    ,mid_ftp_accint_year number(24,6) -- 内生性调节后ftp利息年累计
    ,final_ftp_accint_day number(24,6) -- 最终ftp利息日累计
    ,final_ftp_accint_month number(24,6) -- 最终ftp利息月累计
    ,final_ftp_accint_quar number(24,6) -- 最终ftp利息季累计
    ,final_ftp_accint_year number(24,6) -- 最终ftp利息年累计
    ,base_unlock_ftp_accint_day number(24,6) -- 原始非锁定ftp利息日累计
    ,base_unlock_ftp_accint_month number(24,6) -- 原始非锁定ftp利息月累计
    ,base_unlock_ftp_accint_quar number(24,6) -- 原始非锁定ftp利息季累计
    ,base_unlock_ftp_accint_year number(24,6) -- 原始非锁定ftp利息年累计
    ,mid_unlock_ftp_accint_day number(24,6) -- 内生性调节后非锁定ftp利息日累计
    ,mid_unlock_ftp_accint_month number(24,6) -- 内生性调节后非锁定ftp利息月累计
    ,mid_unlock_ftp_accint_quar number(24,6) -- 内生性调节后非锁定ftp利息季累计
    ,mid_unlock_ftp_accint_year number(24,6) -- 内生性调节后非锁定ftp利息年累计
    ,final_unlock_ftp_accint_day number(24,6) -- 最终非锁定ftp利息日累计
    ,final_unlock_ftp_accint_month number(24,6) -- 最终非锁定ftp利息月累计
    ,final_unlock_ftp_accint_quar number(24,6) -- 最终非锁定ftp利息季累计
    ,final_unlock_ftp_accint_year number(24,6) -- 最终非锁定ftp利息年累计
    ,adjust_01_rate number(10,6) -- 调节项1点差
    ,adjust_01_accint_day number(24,6) -- 调节项1金额日累计
    ,adjust_01_accint_month number(24,6) -- 调节项1金额月累计
    ,adjust_01_accint_quar number(24,6) -- 调节项1金额季累计
    ,adjust_01_accint_year number(24,6) -- 调节项1金额年累计
    ,adjust_02_rate number(10,6) -- 调节项2点差
    ,adjust_02_accint_day number(24,6) -- 调节项2金额日累计
    ,adjust_02_accint_month number(24,6) -- 调节项2金额月累计
    ,adjust_02_accint_quar number(24,6) -- 调节项2金额季累计
    ,adjust_02_accint_year number(24,6) -- 调节项2金额年累计
    ,adjust_03_rate number(10,6) -- 调节项3点差
    ,adjust_03_accint_day number(24,6) -- 调节项3金额日累计
    ,adjust_03_accint_month number(24,6) -- 调节项3金额月累计
    ,adjust_03_accint_quar number(24,6) -- 调节项3金额季累计
    ,adjust_03_accint_year number(24,6) -- 调节项3金额年累计
    ,adjust_04_rate number(10,6) -- 调节项4点差
    ,adjust_04_accint_day number(24,6) -- 调节项4金额日累计
    ,adjust_04_accint_month number(24,6) -- 调节项4金额月累计
    ,adjust_04_accint_quar number(24,6) -- 调节项4金额季累计
    ,adjust_04_accint_year number(24,6) -- 调节项4金额年累计
    ,adjust_05_rate number(10,6) -- 调节项5点差
    ,adjust_05_accint_day number(24,6) -- 调节项5金额日累计
    ,adjust_05_accint_month number(24,6) -- 调节项5金额月累计
    ,adjust_05_accint_quar number(24,6) -- 调节项5金额季累计
    ,adjust_05_accint_year number(24,6) -- 调节项5金额年累计
    ,adjust_06_rate number(10,6) -- 调节项6点差
    ,adjust_06_accint_day number(24,6) -- 调节项6金额日累计
    ,adjust_06_accint_month number(24,6) -- 调节项6金额月累计
    ,adjust_06_accint_quar number(24,6) -- 调节项6金额季累计
    ,adjust_06_accint_year number(24,6) -- 调节项6金额年累计
    ,adjust_07_rate number(10,6) -- 调节项7点差
    ,adjust_07_accint_day number(24,6) -- 调节项7金额日累计
    ,adjust_07_accint_month number(24,6) -- 调节项7金额月累计
    ,adjust_07_accint_quar number(24,6) -- 调节项7金额季累计
    ,adjust_07_accint_year number(24,6) -- 调节项7金额年累计
    ,adjust_08_rate number(10,6) -- 调节项8点差
    ,adjust_08_accint_day number(24,6) -- 调节项8金额日累计
    ,adjust_08_accint_month number(24,6) -- 调节项8金额月累计
    ,adjust_08_accint_quar number(24,6) -- 调节项8金额季累计
    ,adjust_08_accint_year number(24,6) -- 调节项8金额年累计
    ,adjust_09_rate number(10,6) -- 调节项9点差
    ,adjust_09_accint_day number(24,6) -- 调节项9金额日累计
    ,adjust_09_accint_month number(24,6) -- 调节项9金额月累计
    ,adjust_09_accint_quar number(24,6) -- 调节项9金额季累计
    ,adjust_09_accint_year number(24,6) -- 调节项9金额年累计
    ,adjust_10_rate number(10,6) -- 调节项10点差
    ,adjust_10_accint_day number(24,6) -- 调节项10金额日累计
    ,adjust_10_accint_month number(24,6) -- 调节项10金额月累计
    ,adjust_10_accint_quar number(24,6) -- 调节项10金额季累计
    ,adjust_10_accint_year number(24,6) -- 调节项10金额年累计
    ,adjust_11_rate number(10,6) -- 调节项11点差
    ,adjust_11_accint_day number(24,6) -- 调节项11金额日累计
    ,adjust_11_accint_month number(24,6) -- 调节项11金额月累计
    ,adjust_11_accint_quar number(24,6) -- 调节项11金额季累计
    ,adjust_11_accint_year number(24,6) -- 调节项11金额年累计
    ,adjust_12_rate number(10,6) -- 调节项12点差
    ,adjust_12_accint_day number(24,6) -- 调节项12金额日累计
    ,adjust_12_accint_month number(24,6) -- 调节项12金额月累计
    ,adjust_12_accint_quar number(24,6) -- 调节项12金额季累计
    ,adjust_12_accint_year number(24,6) -- 调节项12金额年累计
    ,adjust_13_rate number(10,6) -- 调节项13点差
    ,adjust_13_accint_day number(24,6) -- 调节项13金额日累计
    ,adjust_13_accint_month number(24,6) -- 调节项13金额月累计
    ,adjust_13_accint_quar number(24,6) -- 调节项13金额季累计
    ,adjust_13_accint_year number(24,6) -- 调节项13金额年累计
    ,adjust_14_rate number(10,6) -- 调节项14点差
    ,adjust_14_accint_day number(24,6) -- 调节项14金额日累计
    ,adjust_14_accint_month number(24,6) -- 调节项14金额月累计
    ,adjust_14_accint_quar number(24,6) -- 调节项14金额季累计
    ,adjust_14_accint_year number(24,6) -- 调节项14金额年累计
    ,adjust_15_rate number(10,6) -- 调节项15点差
    ,adjust_15_accint_day number(24,6) -- 调节项15金额日累计
    ,adjust_15_accint_month number(24,6) -- 调节项15金额月累计
    ,adjust_15_accint_quar number(24,6) -- 调节项15金额季累计
    ,adjust_15_accint_year number(24,6) -- 调节项15金额年累计
    ,adjust_16_rate number(10,6) -- 调节项16点差
    ,adjust_16_accint_day number(24,6) -- 调节项16金额日累计
    ,adjust_16_accint_month number(24,6) -- 调节项16金额月累计
    ,adjust_16_accint_quar number(24,6) -- 调节项16金额季累计
    ,adjust_16_accint_year number(24,6) -- 调节项16金额年累计
    ,adjust_17_rate number(10,6) -- 调节项17点差
    ,adjust_17_accint_day number(24,6) -- 调节项17金额日累计
    ,adjust_17_accint_month number(24,6) -- 调节项17金额月累计
    ,adjust_17_accint_quar number(24,6) -- 调节项17金额季累计
    ,adjust_17_accint_year number(24,6) -- 调节项17金额年累计
    ,adjust_18_rate number(10,6) -- 调节项18点差
    ,adjust_18_accint_day number(24,6) -- 调节项18金额日累计
    ,adjust_18_accint_month number(24,6) -- 调节项18金额月累计
    ,adjust_18_accint_quar number(24,6) -- 调节项18金额季累计
    ,adjust_18_accint_year number(24,6) -- 调节项18金额年累计
    ,adjust_19_rate number(10,6) -- 调节项19点差
    ,adjust_19_accint_day number(24,6) -- 调节项19金额日累计
    ,adjust_19_accint_month number(24,6) -- 调节项19金额月累计
    ,adjust_19_accint_quar number(24,6) -- 调节项19金额季累计
    ,adjust_19_accint_year number(24,6) -- 调节项19金额年累计
    ,adjust_20_rate number(10,6) -- 调节项20点差
    ,adjust_20_accint_day number(24,6) -- 调节项20金额日累计
    ,adjust_20_accint_month number(24,6) -- 调节项20金额月累计
    ,adjust_20_accint_quar number(24,6) -- 调节项20金额季累计
    ,adjust_20_accint_year number(24,6) -- 调节项20金额年累计
    ,inc_spred_accint_day number(24,6) -- 价差收益日累计
    ,inc_spred_accint_month number(24,6) -- 价差收益月累计
    ,inc_spred_accint_quar number(24,6) -- 价差收益季累计
    ,inc_spred_accint_year number(24,6) -- 价差收益年累计
    ,exchange_to_cny_rate number(10,6) -- 折人民币汇率
    ,exchange_to_usd_rate number(10,6) -- 折美元汇率
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ftps_rpt_rst_ftp261 to ${iel_schema};

-- comment
comment on table ${idl_schema}.ftps_rpt_rst_ftp261 is 'ftp初级报表账户明细结果集';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.acct_no is '账号';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.s_acct_no is '拆分前账号';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.t_acct_no is '源账号';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.data_dt is '数据日期';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.share_percent is '分成比例';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.price_unit_cd is '定价单元';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.prod_cd is '产品代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.core_prod_cd is '核心系统产品码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.credit_prod_cd is '信贷系统产品码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.industry_cd is '行业代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.subject_cd is '科目代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.currency_cd is '币种代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.acct_org_cd is '核算机构';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.assess_org_cd is '考核机构代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.bond_categ_cd is '债券种类代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.al_flag is '资产负债标志';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.biz_flag is '对公对私业务标识';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.biz_line_cd is '业务条线代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.data_src is '数据来源';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.channel_cd is '渠道代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.interest_adjust_type_cd is '利率调整方式代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.cust_id is '客户号';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.cust_name is '客户名称';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mgr_id is '客户经理号';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mgr_name is '客户经理名称';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.cust_size_cd is '客户规模';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.cust_type_cd is '客户类型代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.accrual_basis_cd is '计息方式代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.original_term is '原始期限';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.original_term_mult is '原始期限单位';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.start_dt is '起息日';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.maturity_dt is '到期日';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.open_dt is '开户日';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.close_dt is '销户日';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.last_payment_dt is '上次还款日';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.next_payment_dt is '下次还款日';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.payment_type_cd is '还款方式代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.payment_freq is '还款频率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.payment_freq_mult is '还款频率单位';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.last_repricing_dt is '上次重定价日';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.next_repricing_dt is '下次重定价日';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.repricing_freq is '重定价频率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.repricing_freq_mult is '重定价频率单位';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.overdue_flag is '逾期标志';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.position_inc_dt is '业务新增日期';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.agmt_deposit_flag is '是否协定存款标志';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.excess_reserce_flag is '是否超额准备金标志';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.iflock_flag is '是否锁定利差标志';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.loan_class_cd is '贷款质量分类';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.cur_bal is '当前余额';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.accbal_month is '月累计余额';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.accbal_quar is '季累计余额';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.accbal_year is '年累计余额';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.exercise_interest_rate is '执行利率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.base_ftp_rate is '原始ftp利率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mid_ftp_rate is '内生性调节后ftp利率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.final_ftp_rate is '最终ftp利率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.lock_spread is '锁定利差值';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.base_unlock_ftp_rate is '原始非锁定ftp利率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mid_unlock_ftp_rate is '内生性调节后非锁定ftp利率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.final_unlock_ftp_rate is '最终非锁定ftp利率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.accint_day is '利息收支日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.accint_month is '利息收支月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.accint_quar is '利息收支季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.accint_year is '利息收支年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.base_ftp_accint_day is '原始ftp利息日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.base_ftp_accint_month is '原始ftp利息月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.base_ftp_accint_quar is '原始ftp利息季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.base_ftp_accint_year is '原始ftp利息年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mid_ftp_accint_day is '内生性调节后ftp利息日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mid_ftp_accint_month is '内生性调节后ftp利息月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mid_ftp_accint_quar is '内生性调节后ftp利息季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mid_ftp_accint_year is '内生性调节后ftp利息年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.final_ftp_accint_day is '最终ftp利息日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.final_ftp_accint_month is '最终ftp利息月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.final_ftp_accint_quar is '最终ftp利息季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.final_ftp_accint_year is '最终ftp利息年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.base_unlock_ftp_accint_day is '原始非锁定ftp利息日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.base_unlock_ftp_accint_month is '原始非锁定ftp利息月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.base_unlock_ftp_accint_quar is '原始非锁定ftp利息季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.base_unlock_ftp_accint_year is '原始非锁定ftp利息年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mid_unlock_ftp_accint_day is '内生性调节后非锁定ftp利息日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mid_unlock_ftp_accint_month is '内生性调节后非锁定ftp利息月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mid_unlock_ftp_accint_quar is '内生性调节后非锁定ftp利息季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.mid_unlock_ftp_accint_year is '内生性调节后非锁定ftp利息年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.final_unlock_ftp_accint_day is '最终非锁定ftp利息日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.final_unlock_ftp_accint_month is '最终非锁定ftp利息月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.final_unlock_ftp_accint_quar is '最终非锁定ftp利息季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.final_unlock_ftp_accint_year is '最终非锁定ftp利息年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_01_rate is '调节项1点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_01_accint_day is '调节项1金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_01_accint_month is '调节项1金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_01_accint_quar is '调节项1金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_01_accint_year is '调节项1金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_02_rate is '调节项2点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_02_accint_day is '调节项2金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_02_accint_month is '调节项2金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_02_accint_quar is '调节项2金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_02_accint_year is '调节项2金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_03_rate is '调节项3点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_03_accint_day is '调节项3金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_03_accint_month is '调节项3金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_03_accint_quar is '调节项3金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_03_accint_year is '调节项3金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_04_rate is '调节项4点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_04_accint_day is '调节项4金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_04_accint_month is '调节项4金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_04_accint_quar is '调节项4金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_04_accint_year is '调节项4金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_05_rate is '调节项5点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_05_accint_day is '调节项5金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_05_accint_month is '调节项5金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_05_accint_quar is '调节项5金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_05_accint_year is '调节项5金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_06_rate is '调节项6点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_06_accint_day is '调节项6金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_06_accint_month is '调节项6金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_06_accint_quar is '调节项6金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_06_accint_year is '调节项6金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_07_rate is '调节项7点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_07_accint_day is '调节项7金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_07_accint_month is '调节项7金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_07_accint_quar is '调节项7金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_07_accint_year is '调节项7金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_08_rate is '调节项8点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_08_accint_day is '调节项8金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_08_accint_month is '调节项8金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_08_accint_quar is '调节项8金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_08_accint_year is '调节项8金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_09_rate is '调节项9点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_09_accint_day is '调节项9金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_09_accint_month is '调节项9金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_09_accint_quar is '调节项9金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_09_accint_year is '调节项9金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_10_rate is '调节项10点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_10_accint_day is '调节项10金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_10_accint_month is '调节项10金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_10_accint_quar is '调节项10金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_10_accint_year is '调节项10金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_11_rate is '调节项11点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_11_accint_day is '调节项11金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_11_accint_month is '调节项11金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_11_accint_quar is '调节项11金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_11_accint_year is '调节项11金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_12_rate is '调节项12点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_12_accint_day is '调节项12金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_12_accint_month is '调节项12金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_12_accint_quar is '调节项12金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_12_accint_year is '调节项12金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_13_rate is '调节项13点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_13_accint_day is '调节项13金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_13_accint_month is '调节项13金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_13_accint_quar is '调节项13金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_13_accint_year is '调节项13金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_14_rate is '调节项14点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_14_accint_day is '调节项14金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_14_accint_month is '调节项14金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_14_accint_quar is '调节项14金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_14_accint_year is '调节项14金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_15_rate is '调节项15点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_15_accint_day is '调节项15金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_15_accint_month is '调节项15金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_15_accint_quar is '调节项15金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_15_accint_year is '调节项15金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_16_rate is '调节项16点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_16_accint_day is '调节项16金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_16_accint_month is '调节项16金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_16_accint_quar is '调节项16金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_16_accint_year is '调节项16金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_17_rate is '调节项17点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_17_accint_day is '调节项17金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_17_accint_month is '调节项17金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_17_accint_quar is '调节项17金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_17_accint_year is '调节项17金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_18_rate is '调节项18点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_18_accint_day is '调节项18金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_18_accint_month is '调节项18金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_18_accint_quar is '调节项18金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_18_accint_year is '调节项18金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_19_rate is '调节项19点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_19_accint_day is '调节项19金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_19_accint_month is '调节项19金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_19_accint_quar is '调节项19金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_19_accint_year is '调节项19金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_20_rate is '调节项20点差';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_20_accint_day is '调节项20金额日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_20_accint_month is '调节项20金额月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_20_accint_quar is '调节项20金额季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.adjust_20_accint_year is '调节项20金额年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.inc_spred_accint_day is '价差收益日累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.inc_spred_accint_month is '价差收益月累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.inc_spred_accint_quar is '价差收益季累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.inc_spred_accint_year is '价差收益年累计';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.exchange_to_cny_rate is '折人民币汇率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.exchange_to_usd_rate is '折美元汇率';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.job_cd is '任务代码';
comment on column ${idl_schema}.ftps_rpt_rst_ftp261.etl_timestamp is 'ETL处理时间戳';