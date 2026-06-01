/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_ul_acct
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_cl_ul_acct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_ul_acct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_ul_acct_op purge;
drop table ${iol_schema}.ncbs_cl_ul_acct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_ul_acct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_ul_acct where 0=1;

create table ${iol_schema}.ncbs_cl_ul_acct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_ul_acct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_ul_acct_cl(
            internal_key -- 账户内部键值
            ,cmisloan_no -- 客户借据编号
            ,loan_no -- 贷款号
            ,prod_type -- 产品编号
            ,ccy -- 币种
            ,contract_no -- 合同编号
            ,branch -- 交易机构编号
            ,in_balance_flag -- 应计标识
            ,amortize_flag -- 摊销标识
            ,extend_flag -- 展期标识
            ,asset_security_status -- 资产证券化状态
            ,asset_transfer_status -- 资产转让状态
            ,charge_int_flag -- 预收息标识
            ,acct_status -- 账户状态
            ,amortize_frequency -- 摊销频度
            ,calc_begin_date -- 利息计算起始日
            ,next_cycle_date -- 下一结息日
            ,int_ind_flag -- 计息标识
            ,client_no -- 客户编号
            ,client_name -- 客户名称
            ,five_category -- 贷款五级分类
            ,pre_loan_fee -- 贷前费用
            ,effect_date -- 产品生效日期
            ,actual_dd_amt -- 实际发放金额
            ,dd_amt -- 发放金额
            ,maturity_date -- 到期日期
            ,ori_maturity_date -- 账户原始到期日期
            ,due_days -- 贷款逾期天数（不考虑宽限期）
            ,int_due_days -- 利息逾期天数（考虑宽限期）
            ,pri_due_days -- 本金逾期天数（考虑宽限期）
            ,normal_rate -- 正常利率
            ,normal_rate_period -- 正常利率周期
            ,past_due_rate -- 逾期利率
            ,odp_rate_period -- 逾期利率周期
            ,odi_rate -- 贷款复利利率
            ,odi_rate_period -- 复利利率周期
            ,grace_rate -- 宽限期利率
            ,grace_rate_period -- 宽限期利率周期
            ,osl_amt -- 客户未到期本金
            ,prd_amt -- 逾期本金
            ,acct_int -- 账户利息
            ,odp_amt -- 罚息金额
            ,intp_amt -- 逾期利息
            ,odi_amt -- 复利金额
            ,odpp_amt -- 逾期罚息余额
            ,ododp_amt -- 罚息的复利
            ,odi_past_due -- 逾期复利
            ,before_income_amt -- 前收息金额
            ,amt_type_two -- 金额类型2
            ,amt_type_three -- 金额类型3
            ,amt_type_for -- 金额类型4
            ,amt_type_five -- 金额类型5
            ,amt_type_six -- 金额类型6
            ,contract_amt -- 合同金额
            ,attach_info_one -- 附属信息1
            ,attach_info_two -- 附属信息2
            ,attach_info_three -- 附属信息3
            ,loan_amt -- 贷款余额
            ,is_first_dd -- 是否首次发放
            ,revolve_flag -- 循环贷款标志
            ,econ_department_type -- 国民经济部门类型
            ,lg_amt -- 保函金额
            ,belong_abs_int_amt -- 归属券商利息
            ,belong_abs_odp_amt -- 归属券商罚息
            ,belong_abs_odi_amt -- 归属券商复利
            ,abs_int_amt -- 资产证券化利息
            ,abs_odp_amt -- 资产证券化罚息
            ,abs_odi_amt -- 资产证券化复利
            ,abs_intp_amt -- 资产证券化逾期利息
            ,abs_odpp_amt -- 资产证券化逾期罚息
            ,abs_odip_amt -- 资产证券化逾期复利
            ,inner_bank_transfer_premium -- 行内转让溢价
            ,inner_bank_transfer_discount -- 行内转让折价
            ,out_bank_transfer_premium -- 行外转让溢价
            ,out_bank_transfer_discount -- 行外转让折价
            ,balance -- 余额
            ,year_basis -- 年基准天数
            ,client_type -- 客户类型
            ,accounting_status -- 核算状态
            ,timestamp -- 时间戳
            ,last_update_date -- 上次更新日期
            ,reversal_date -- 冲正日期
            ,closed_date -- 关闭日期
            ,stage_no -- 期次
            ,dd_no -- 发放号
            ,reversal -- 是否冲正标志
            ,sell_clear_int_amt -- 已结转利息
            ,sell_clear_odp_amt -- 已结转罚息
            ,sell_clear_odi_amt -- 已结转复息
            ,busilicence_name -- 营业执照名称
            ,merchant_name -- 商户名称
            ,ododi_amt -- 复利的复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_ul_acct_op(
            internal_key -- 账户内部键值
            ,cmisloan_no -- 客户借据编号
            ,loan_no -- 贷款号
            ,prod_type -- 产品编号
            ,ccy -- 币种
            ,contract_no -- 合同编号
            ,branch -- 交易机构编号
            ,in_balance_flag -- 应计标识
            ,amortize_flag -- 摊销标识
            ,extend_flag -- 展期标识
            ,asset_security_status -- 资产证券化状态
            ,asset_transfer_status -- 资产转让状态
            ,charge_int_flag -- 预收息标识
            ,acct_status -- 账户状态
            ,amortize_frequency -- 摊销频度
            ,calc_begin_date -- 利息计算起始日
            ,next_cycle_date -- 下一结息日
            ,int_ind_flag -- 计息标识
            ,client_no -- 客户编号
            ,client_name -- 客户名称
            ,five_category -- 贷款五级分类
            ,pre_loan_fee -- 贷前费用
            ,effect_date -- 产品生效日期
            ,actual_dd_amt -- 实际发放金额
            ,dd_amt -- 发放金额
            ,maturity_date -- 到期日期
            ,ori_maturity_date -- 账户原始到期日期
            ,due_days -- 贷款逾期天数（不考虑宽限期）
            ,int_due_days -- 利息逾期天数（考虑宽限期）
            ,pri_due_days -- 本金逾期天数（考虑宽限期）
            ,normal_rate -- 正常利率
            ,normal_rate_period -- 正常利率周期
            ,past_due_rate -- 逾期利率
            ,odp_rate_period -- 逾期利率周期
            ,odi_rate -- 贷款复利利率
            ,odi_rate_period -- 复利利率周期
            ,grace_rate -- 宽限期利率
            ,grace_rate_period -- 宽限期利率周期
            ,osl_amt -- 客户未到期本金
            ,prd_amt -- 逾期本金
            ,acct_int -- 账户利息
            ,odp_amt -- 罚息金额
            ,intp_amt -- 逾期利息
            ,odi_amt -- 复利金额
            ,odpp_amt -- 逾期罚息余额
            ,ododp_amt -- 罚息的复利
            ,odi_past_due -- 逾期复利
            ,before_income_amt -- 前收息金额
            ,amt_type_two -- 金额类型2
            ,amt_type_three -- 金额类型3
            ,amt_type_for -- 金额类型4
            ,amt_type_five -- 金额类型5
            ,amt_type_six -- 金额类型6
            ,contract_amt -- 合同金额
            ,attach_info_one -- 附属信息1
            ,attach_info_two -- 附属信息2
            ,attach_info_three -- 附属信息3
            ,loan_amt -- 贷款余额
            ,is_first_dd -- 是否首次发放
            ,revolve_flag -- 循环贷款标志
            ,econ_department_type -- 国民经济部门类型
            ,lg_amt -- 保函金额
            ,belong_abs_int_amt -- 归属券商利息
            ,belong_abs_odp_amt -- 归属券商罚息
            ,belong_abs_odi_amt -- 归属券商复利
            ,abs_int_amt -- 资产证券化利息
            ,abs_odp_amt -- 资产证券化罚息
            ,abs_odi_amt -- 资产证券化复利
            ,abs_intp_amt -- 资产证券化逾期利息
            ,abs_odpp_amt -- 资产证券化逾期罚息
            ,abs_odip_amt -- 资产证券化逾期复利
            ,inner_bank_transfer_premium -- 行内转让溢价
            ,inner_bank_transfer_discount -- 行内转让折价
            ,out_bank_transfer_premium -- 行外转让溢价
            ,out_bank_transfer_discount -- 行外转让折价
            ,balance -- 余额
            ,year_basis -- 年基准天数
            ,client_type -- 客户类型
            ,accounting_status -- 核算状态
            ,timestamp -- 时间戳
            ,last_update_date -- 上次更新日期
            ,reversal_date -- 冲正日期
            ,closed_date -- 关闭日期
            ,stage_no -- 期次
            ,dd_no -- 发放号
            ,reversal -- 是否冲正标志
            ,sell_clear_int_amt -- 已结转利息
            ,sell_clear_odp_amt -- 已结转罚息
            ,sell_clear_odi_amt -- 已结转复息
            ,busilicence_name -- 营业执照名称
            ,merchant_name -- 商户名称
            ,ododi_amt -- 复利的复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.cmisloan_no, o.cmisloan_no) as cmisloan_no -- 客户借据编号
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.branch, o.branch) as branch -- 交易机构编号
    ,nvl(n.in_balance_flag, o.in_balance_flag) as in_balance_flag -- 应计标识
    ,nvl(n.amortize_flag, o.amortize_flag) as amortize_flag -- 摊销标识
    ,nvl(n.extend_flag, o.extend_flag) as extend_flag -- 展期标识
    ,nvl(n.asset_security_status, o.asset_security_status) as asset_security_status -- 资产证券化状态
    ,nvl(n.asset_transfer_status, o.asset_transfer_status) as asset_transfer_status -- 资产转让状态
    ,nvl(n.charge_int_flag, o.charge_int_flag) as charge_int_flag -- 预收息标识
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.amortize_frequency, o.amortize_frequency) as amortize_frequency -- 摊销频度
    ,nvl(n.calc_begin_date, o.calc_begin_date) as calc_begin_date -- 利息计算起始日
    ,nvl(n.next_cycle_date, o.next_cycle_date) as next_cycle_date -- 下一结息日
    ,nvl(n.int_ind_flag, o.int_ind_flag) as int_ind_flag -- 计息标识
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.five_category, o.five_category) as five_category -- 贷款五级分类
    ,nvl(n.pre_loan_fee, o.pre_loan_fee) as pre_loan_fee -- 贷前费用
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.actual_dd_amt, o.actual_dd_amt) as actual_dd_amt -- 实际发放金额
    ,nvl(n.dd_amt, o.dd_amt) as dd_amt -- 发放金额
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.ori_maturity_date, o.ori_maturity_date) as ori_maturity_date -- 账户原始到期日期
    ,nvl(n.due_days, o.due_days) as due_days -- 贷款逾期天数（不考虑宽限期）
    ,nvl(n.int_due_days, o.int_due_days) as int_due_days -- 利息逾期天数（考虑宽限期）
    ,nvl(n.pri_due_days, o.pri_due_days) as pri_due_days -- 本金逾期天数（考虑宽限期）
    ,nvl(n.normal_rate, o.normal_rate) as normal_rate -- 正常利率
    ,nvl(n.normal_rate_period, o.normal_rate_period) as normal_rate_period -- 正常利率周期
    ,nvl(n.past_due_rate, o.past_due_rate) as past_due_rate -- 逾期利率
    ,nvl(n.odp_rate_period, o.odp_rate_period) as odp_rate_period -- 逾期利率周期
    ,nvl(n.odi_rate, o.odi_rate) as odi_rate -- 贷款复利利率
    ,nvl(n.odi_rate_period, o.odi_rate_period) as odi_rate_period -- 复利利率周期
    ,nvl(n.grace_rate, o.grace_rate) as grace_rate -- 宽限期利率
    ,nvl(n.grace_rate_period, o.grace_rate_period) as grace_rate_period -- 宽限期利率周期
    ,nvl(n.osl_amt, o.osl_amt) as osl_amt -- 客户未到期本金
    ,nvl(n.prd_amt, o.prd_amt) as prd_amt -- 逾期本金
    ,nvl(n.acct_int, o.acct_int) as acct_int -- 账户利息
    ,nvl(n.odp_amt, o.odp_amt) as odp_amt -- 罚息金额
    ,nvl(n.intp_amt, o.intp_amt) as intp_amt -- 逾期利息
    ,nvl(n.odi_amt, o.odi_amt) as odi_amt -- 复利金额
    ,nvl(n.odpp_amt, o.odpp_amt) as odpp_amt -- 逾期罚息余额
    ,nvl(n.ododp_amt, o.ododp_amt) as ododp_amt -- 罚息的复利
    ,nvl(n.odi_past_due, o.odi_past_due) as odi_past_due -- 逾期复利
    ,nvl(n.before_income_amt, o.before_income_amt) as before_income_amt -- 前收息金额
    ,nvl(n.amt_type_two, o.amt_type_two) as amt_type_two -- 金额类型2
    ,nvl(n.amt_type_three, o.amt_type_three) as amt_type_three -- 金额类型3
    ,nvl(n.amt_type_for, o.amt_type_for) as amt_type_for -- 金额类型4
    ,nvl(n.amt_type_five, o.amt_type_five) as amt_type_five -- 金额类型5
    ,nvl(n.amt_type_six, o.amt_type_six) as amt_type_six -- 金额类型6
    ,nvl(n.contract_amt, o.contract_amt) as contract_amt -- 合同金额
    ,nvl(n.attach_info_one, o.attach_info_one) as attach_info_one -- 附属信息1
    ,nvl(n.attach_info_two, o.attach_info_two) as attach_info_two -- 附属信息2
    ,nvl(n.attach_info_three, o.attach_info_three) as attach_info_three -- 附属信息3
    ,nvl(n.loan_amt, o.loan_amt) as loan_amt -- 贷款余额
    ,nvl(n.is_first_dd, o.is_first_dd) as is_first_dd -- 是否首次发放
    ,nvl(n.revolve_flag, o.revolve_flag) as revolve_flag -- 循环贷款标志
    ,nvl(n.econ_department_type, o.econ_department_type) as econ_department_type -- 国民经济部门类型
    ,nvl(n.lg_amt, o.lg_amt) as lg_amt -- 保函金额
    ,nvl(n.belong_abs_int_amt, o.belong_abs_int_amt) as belong_abs_int_amt -- 归属券商利息
    ,nvl(n.belong_abs_odp_amt, o.belong_abs_odp_amt) as belong_abs_odp_amt -- 归属券商罚息
    ,nvl(n.belong_abs_odi_amt, o.belong_abs_odi_amt) as belong_abs_odi_amt -- 归属券商复利
    ,nvl(n.abs_int_amt, o.abs_int_amt) as abs_int_amt -- 资产证券化利息
    ,nvl(n.abs_odp_amt, o.abs_odp_amt) as abs_odp_amt -- 资产证券化罚息
    ,nvl(n.abs_odi_amt, o.abs_odi_amt) as abs_odi_amt -- 资产证券化复利
    ,nvl(n.abs_intp_amt, o.abs_intp_amt) as abs_intp_amt -- 资产证券化逾期利息
    ,nvl(n.abs_odpp_amt, o.abs_odpp_amt) as abs_odpp_amt -- 资产证券化逾期罚息
    ,nvl(n.abs_odip_amt, o.abs_odip_amt) as abs_odip_amt -- 资产证券化逾期复利
    ,nvl(n.inner_bank_transfer_premium, o.inner_bank_transfer_premium) as inner_bank_transfer_premium -- 行内转让溢价
    ,nvl(n.inner_bank_transfer_discount, o.inner_bank_transfer_discount) as inner_bank_transfer_discount -- 行内转让折价
    ,nvl(n.out_bank_transfer_premium, o.out_bank_transfer_premium) as out_bank_transfer_premium -- 行外转让溢价
    ,nvl(n.out_bank_transfer_discount, o.out_bank_transfer_discount) as out_bank_transfer_discount -- 行外转让折价
    ,nvl(n.balance, o.balance) as balance -- 余额
    ,nvl(n.year_basis, o.year_basis) as year_basis -- 年基准天数
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.timestamp, o.timestamp) as timestamp -- 时间戳
    ,nvl(n.last_update_date, o.last_update_date) as last_update_date -- 上次更新日期
    ,nvl(n.reversal_date, o.reversal_date) as reversal_date -- 冲正日期
    ,nvl(n.closed_date, o.closed_date) as closed_date -- 关闭日期
    ,nvl(n.stage_no, o.stage_no) as stage_no -- 期次
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.reversal, o.reversal) as reversal -- 是否冲正标志
    ,nvl(n.sell_clear_int_amt, o.sell_clear_int_amt) as sell_clear_int_amt -- 已结转利息
    ,nvl(n.sell_clear_odp_amt, o.sell_clear_odp_amt) as sell_clear_odp_amt -- 已结转罚息
    ,nvl(n.sell_clear_odi_amt, o.sell_clear_odi_amt) as sell_clear_odi_amt -- 已结转复息
    ,nvl(n.busilicence_name, o.busilicence_name) as busilicence_name -- 营业执照名称
    ,nvl(n.merchant_name, o.merchant_name) as merchant_name -- 商户名称
    ,nvl(n.ododi_amt, o.ododi_amt) as ododi_amt -- 复利的复利
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_ul_acct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_ul_acct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.cmisloan_no <> n.cmisloan_no
        or o.loan_no <> n.loan_no
        or o.prod_type <> n.prod_type
        or o.ccy <> n.ccy
        or o.contract_no <> n.contract_no
        or o.branch <> n.branch
        or o.in_balance_flag <> n.in_balance_flag
        or o.amortize_flag <> n.amortize_flag
        or o.extend_flag <> n.extend_flag
        or o.asset_security_status <> n.asset_security_status
        or o.asset_transfer_status <> n.asset_transfer_status
        or o.charge_int_flag <> n.charge_int_flag
        or o.acct_status <> n.acct_status
        or o.amortize_frequency <> n.amortize_frequency
        or o.calc_begin_date <> n.calc_begin_date
        or o.next_cycle_date <> n.next_cycle_date
        or o.int_ind_flag <> n.int_ind_flag
        or o.client_no <> n.client_no
        or o.client_name <> n.client_name
        or o.five_category <> n.five_category
        or o.pre_loan_fee <> n.pre_loan_fee
        or o.effect_date <> n.effect_date
        or o.actual_dd_amt <> n.actual_dd_amt
        or o.dd_amt <> n.dd_amt
        or o.maturity_date <> n.maturity_date
        or o.ori_maturity_date <> n.ori_maturity_date
        or o.due_days <> n.due_days
        or o.int_due_days <> n.int_due_days
        or o.pri_due_days <> n.pri_due_days
        or o.normal_rate <> n.normal_rate
        or o.normal_rate_period <> n.normal_rate_period
        or o.past_due_rate <> n.past_due_rate
        or o.odp_rate_period <> n.odp_rate_period
        or o.odi_rate <> n.odi_rate
        or o.odi_rate_period <> n.odi_rate_period
        or o.grace_rate <> n.grace_rate
        or o.grace_rate_period <> n.grace_rate_period
        or o.osl_amt <> n.osl_amt
        or o.prd_amt <> n.prd_amt
        or o.acct_int <> n.acct_int
        or o.odp_amt <> n.odp_amt
        or o.intp_amt <> n.intp_amt
        or o.odi_amt <> n.odi_amt
        or o.odpp_amt <> n.odpp_amt
        or o.ododp_amt <> n.ododp_amt
        or o.odi_past_due <> n.odi_past_due
        or o.before_income_amt <> n.before_income_amt
        or o.amt_type_two <> n.amt_type_two
        or o.amt_type_three <> n.amt_type_three
        or o.amt_type_for <> n.amt_type_for
        or o.amt_type_five <> n.amt_type_five
        or o.amt_type_six <> n.amt_type_six
        or o.contract_amt <> n.contract_amt
        or o.attach_info_one <> n.attach_info_one
        or o.attach_info_two <> n.attach_info_two
        or o.attach_info_three <> n.attach_info_three
        or o.loan_amt <> n.loan_amt
        or o.is_first_dd <> n.is_first_dd
        or o.revolve_flag <> n.revolve_flag
        or o.econ_department_type <> n.econ_department_type
        or o.lg_amt <> n.lg_amt
        or o.belong_abs_int_amt <> n.belong_abs_int_amt
        or o.belong_abs_odp_amt <> n.belong_abs_odp_amt
        or o.belong_abs_odi_amt <> n.belong_abs_odi_amt
        or o.abs_int_amt <> n.abs_int_amt
        or o.abs_odp_amt <> n.abs_odp_amt
        or o.abs_odi_amt <> n.abs_odi_amt
        or o.abs_intp_amt <> n.abs_intp_amt
        or o.abs_odpp_amt <> n.abs_odpp_amt
        or o.abs_odip_amt <> n.abs_odip_amt
        or o.inner_bank_transfer_premium <> n.inner_bank_transfer_premium
        or o.inner_bank_transfer_discount <> n.inner_bank_transfer_discount
        or o.out_bank_transfer_premium <> n.out_bank_transfer_premium
        or o.out_bank_transfer_discount <> n.out_bank_transfer_discount
        or o.balance <> n.balance
        or o.year_basis <> n.year_basis
        or o.client_type <> n.client_type
        or o.accounting_status <> n.accounting_status
        or o.timestamp <> n.timestamp
        or o.last_update_date <> n.last_update_date
        or o.reversal_date <> n.reversal_date
        or o.closed_date <> n.closed_date
        or o.stage_no <> n.stage_no
        or o.dd_no <> n.dd_no
        or o.reversal <> n.reversal
        or o.sell_clear_int_amt <> n.sell_clear_int_amt
        or o.sell_clear_odp_amt <> n.sell_clear_odp_amt
        or o.sell_clear_odi_amt <> n.sell_clear_odi_amt
        or o.busilicence_name <> n.busilicence_name
        or o.merchant_name <> n.merchant_name
        or o.ododi_amt <> n.ododi_amt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_ul_acct_cl(
            internal_key -- 账户内部键值
            ,cmisloan_no -- 客户借据编号
            ,loan_no -- 贷款号
            ,prod_type -- 产品编号
            ,ccy -- 币种
            ,contract_no -- 合同编号
            ,branch -- 交易机构编号
            ,in_balance_flag -- 应计标识
            ,amortize_flag -- 摊销标识
            ,extend_flag -- 展期标识
            ,asset_security_status -- 资产证券化状态
            ,asset_transfer_status -- 资产转让状态
            ,charge_int_flag -- 预收息标识
            ,acct_status -- 账户状态
            ,amortize_frequency -- 摊销频度
            ,calc_begin_date -- 利息计算起始日
            ,next_cycle_date -- 下一结息日
            ,int_ind_flag -- 计息标识
            ,client_no -- 客户编号
            ,client_name -- 客户名称
            ,five_category -- 贷款五级分类
            ,pre_loan_fee -- 贷前费用
            ,effect_date -- 产品生效日期
            ,actual_dd_amt -- 实际发放金额
            ,dd_amt -- 发放金额
            ,maturity_date -- 到期日期
            ,ori_maturity_date -- 账户原始到期日期
            ,due_days -- 贷款逾期天数（不考虑宽限期）
            ,int_due_days -- 利息逾期天数（考虑宽限期）
            ,pri_due_days -- 本金逾期天数（考虑宽限期）
            ,normal_rate -- 正常利率
            ,normal_rate_period -- 正常利率周期
            ,past_due_rate -- 逾期利率
            ,odp_rate_period -- 逾期利率周期
            ,odi_rate -- 贷款复利利率
            ,odi_rate_period -- 复利利率周期
            ,grace_rate -- 宽限期利率
            ,grace_rate_period -- 宽限期利率周期
            ,osl_amt -- 客户未到期本金
            ,prd_amt -- 逾期本金
            ,acct_int -- 账户利息
            ,odp_amt -- 罚息金额
            ,intp_amt -- 逾期利息
            ,odi_amt -- 复利金额
            ,odpp_amt -- 逾期罚息余额
            ,ododp_amt -- 罚息的复利
            ,odi_past_due -- 逾期复利
            ,before_income_amt -- 前收息金额
            ,amt_type_two -- 金额类型2
            ,amt_type_three -- 金额类型3
            ,amt_type_for -- 金额类型4
            ,amt_type_five -- 金额类型5
            ,amt_type_six -- 金额类型6
            ,contract_amt -- 合同金额
            ,attach_info_one -- 附属信息1
            ,attach_info_two -- 附属信息2
            ,attach_info_three -- 附属信息3
            ,loan_amt -- 贷款余额
            ,is_first_dd -- 是否首次发放
            ,revolve_flag -- 循环贷款标志
            ,econ_department_type -- 国民经济部门类型
            ,lg_amt -- 保函金额
            ,belong_abs_int_amt -- 归属券商利息
            ,belong_abs_odp_amt -- 归属券商罚息
            ,belong_abs_odi_amt -- 归属券商复利
            ,abs_int_amt -- 资产证券化利息
            ,abs_odp_amt -- 资产证券化罚息
            ,abs_odi_amt -- 资产证券化复利
            ,abs_intp_amt -- 资产证券化逾期利息
            ,abs_odpp_amt -- 资产证券化逾期罚息
            ,abs_odip_amt -- 资产证券化逾期复利
            ,inner_bank_transfer_premium -- 行内转让溢价
            ,inner_bank_transfer_discount -- 行内转让折价
            ,out_bank_transfer_premium -- 行外转让溢价
            ,out_bank_transfer_discount -- 行外转让折价
            ,balance -- 余额
            ,year_basis -- 年基准天数
            ,client_type -- 客户类型
            ,accounting_status -- 核算状态
            ,timestamp -- 时间戳
            ,last_update_date -- 上次更新日期
            ,reversal_date -- 冲正日期
            ,closed_date -- 关闭日期
            ,stage_no -- 期次
            ,dd_no -- 发放号
            ,reversal -- 是否冲正标志
            ,sell_clear_int_amt -- 已结转利息
            ,sell_clear_odp_amt -- 已结转罚息
            ,sell_clear_odi_amt -- 已结转复息
            ,busilicence_name -- 营业执照名称
            ,merchant_name -- 商户名称
            ,ododi_amt -- 复利的复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_ul_acct_op(
            internal_key -- 账户内部键值
            ,cmisloan_no -- 客户借据编号
            ,loan_no -- 贷款号
            ,prod_type -- 产品编号
            ,ccy -- 币种
            ,contract_no -- 合同编号
            ,branch -- 交易机构编号
            ,in_balance_flag -- 应计标识
            ,amortize_flag -- 摊销标识
            ,extend_flag -- 展期标识
            ,asset_security_status -- 资产证券化状态
            ,asset_transfer_status -- 资产转让状态
            ,charge_int_flag -- 预收息标识
            ,acct_status -- 账户状态
            ,amortize_frequency -- 摊销频度
            ,calc_begin_date -- 利息计算起始日
            ,next_cycle_date -- 下一结息日
            ,int_ind_flag -- 计息标识
            ,client_no -- 客户编号
            ,client_name -- 客户名称
            ,five_category -- 贷款五级分类
            ,pre_loan_fee -- 贷前费用
            ,effect_date -- 产品生效日期
            ,actual_dd_amt -- 实际发放金额
            ,dd_amt -- 发放金额
            ,maturity_date -- 到期日期
            ,ori_maturity_date -- 账户原始到期日期
            ,due_days -- 贷款逾期天数（不考虑宽限期）
            ,int_due_days -- 利息逾期天数（考虑宽限期）
            ,pri_due_days -- 本金逾期天数（考虑宽限期）
            ,normal_rate -- 正常利率
            ,normal_rate_period -- 正常利率周期
            ,past_due_rate -- 逾期利率
            ,odp_rate_period -- 逾期利率周期
            ,odi_rate -- 贷款复利利率
            ,odi_rate_period -- 复利利率周期
            ,grace_rate -- 宽限期利率
            ,grace_rate_period -- 宽限期利率周期
            ,osl_amt -- 客户未到期本金
            ,prd_amt -- 逾期本金
            ,acct_int -- 账户利息
            ,odp_amt -- 罚息金额
            ,intp_amt -- 逾期利息
            ,odi_amt -- 复利金额
            ,odpp_amt -- 逾期罚息余额
            ,ododp_amt -- 罚息的复利
            ,odi_past_due -- 逾期复利
            ,before_income_amt -- 前收息金额
            ,amt_type_two -- 金额类型2
            ,amt_type_three -- 金额类型3
            ,amt_type_for -- 金额类型4
            ,amt_type_five -- 金额类型5
            ,amt_type_six -- 金额类型6
            ,contract_amt -- 合同金额
            ,attach_info_one -- 附属信息1
            ,attach_info_two -- 附属信息2
            ,attach_info_three -- 附属信息3
            ,loan_amt -- 贷款余额
            ,is_first_dd -- 是否首次发放
            ,revolve_flag -- 循环贷款标志
            ,econ_department_type -- 国民经济部门类型
            ,lg_amt -- 保函金额
            ,belong_abs_int_amt -- 归属券商利息
            ,belong_abs_odp_amt -- 归属券商罚息
            ,belong_abs_odi_amt -- 归属券商复利
            ,abs_int_amt -- 资产证券化利息
            ,abs_odp_amt -- 资产证券化罚息
            ,abs_odi_amt -- 资产证券化复利
            ,abs_intp_amt -- 资产证券化逾期利息
            ,abs_odpp_amt -- 资产证券化逾期罚息
            ,abs_odip_amt -- 资产证券化逾期复利
            ,inner_bank_transfer_premium -- 行内转让溢价
            ,inner_bank_transfer_discount -- 行内转让折价
            ,out_bank_transfer_premium -- 行外转让溢价
            ,out_bank_transfer_discount -- 行外转让折价
            ,balance -- 余额
            ,year_basis -- 年基准天数
            ,client_type -- 客户类型
            ,accounting_status -- 核算状态
            ,timestamp -- 时间戳
            ,last_update_date -- 上次更新日期
            ,reversal_date -- 冲正日期
            ,closed_date -- 关闭日期
            ,stage_no -- 期次
            ,dd_no -- 发放号
            ,reversal -- 是否冲正标志
            ,sell_clear_int_amt -- 已结转利息
            ,sell_clear_odp_amt -- 已结转罚息
            ,sell_clear_odi_amt -- 已结转复息
            ,busilicence_name -- 营业执照名称
            ,merchant_name -- 商户名称
            ,ododi_amt -- 复利的复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.internal_key -- 账户内部键值
    ,o.cmisloan_no -- 客户借据编号
    ,o.loan_no -- 贷款号
    ,o.prod_type -- 产品编号
    ,o.ccy -- 币种
    ,o.contract_no -- 合同编号
    ,o.branch -- 交易机构编号
    ,o.in_balance_flag -- 应计标识
    ,o.amortize_flag -- 摊销标识
    ,o.extend_flag -- 展期标识
    ,o.asset_security_status -- 资产证券化状态
    ,o.asset_transfer_status -- 资产转让状态
    ,o.charge_int_flag -- 预收息标识
    ,o.acct_status -- 账户状态
    ,o.amortize_frequency -- 摊销频度
    ,o.calc_begin_date -- 利息计算起始日
    ,o.next_cycle_date -- 下一结息日
    ,o.int_ind_flag -- 计息标识
    ,o.client_no -- 客户编号
    ,o.client_name -- 客户名称
    ,o.five_category -- 贷款五级分类
    ,o.pre_loan_fee -- 贷前费用
    ,o.effect_date -- 产品生效日期
    ,o.actual_dd_amt -- 实际发放金额
    ,o.dd_amt -- 发放金额
    ,o.maturity_date -- 到期日期
    ,o.ori_maturity_date -- 账户原始到期日期
    ,o.due_days -- 贷款逾期天数（不考虑宽限期）
    ,o.int_due_days -- 利息逾期天数（考虑宽限期）
    ,o.pri_due_days -- 本金逾期天数（考虑宽限期）
    ,o.normal_rate -- 正常利率
    ,o.normal_rate_period -- 正常利率周期
    ,o.past_due_rate -- 逾期利率
    ,o.odp_rate_period -- 逾期利率周期
    ,o.odi_rate -- 贷款复利利率
    ,o.odi_rate_period -- 复利利率周期
    ,o.grace_rate -- 宽限期利率
    ,o.grace_rate_period -- 宽限期利率周期
    ,o.osl_amt -- 客户未到期本金
    ,o.prd_amt -- 逾期本金
    ,o.acct_int -- 账户利息
    ,o.odp_amt -- 罚息金额
    ,o.intp_amt -- 逾期利息
    ,o.odi_amt -- 复利金额
    ,o.odpp_amt -- 逾期罚息余额
    ,o.ododp_amt -- 罚息的复利
    ,o.odi_past_due -- 逾期复利
    ,o.before_income_amt -- 前收息金额
    ,o.amt_type_two -- 金额类型2
    ,o.amt_type_three -- 金额类型3
    ,o.amt_type_for -- 金额类型4
    ,o.amt_type_five -- 金额类型5
    ,o.amt_type_six -- 金额类型6
    ,o.contract_amt -- 合同金额
    ,o.attach_info_one -- 附属信息1
    ,o.attach_info_two -- 附属信息2
    ,o.attach_info_three -- 附属信息3
    ,o.loan_amt -- 贷款余额
    ,o.is_first_dd -- 是否首次发放
    ,o.revolve_flag -- 循环贷款标志
    ,o.econ_department_type -- 国民经济部门类型
    ,o.lg_amt -- 保函金额
    ,o.belong_abs_int_amt -- 归属券商利息
    ,o.belong_abs_odp_amt -- 归属券商罚息
    ,o.belong_abs_odi_amt -- 归属券商复利
    ,o.abs_int_amt -- 资产证券化利息
    ,o.abs_odp_amt -- 资产证券化罚息
    ,o.abs_odi_amt -- 资产证券化复利
    ,o.abs_intp_amt -- 资产证券化逾期利息
    ,o.abs_odpp_amt -- 资产证券化逾期罚息
    ,o.abs_odip_amt -- 资产证券化逾期复利
    ,o.inner_bank_transfer_premium -- 行内转让溢价
    ,o.inner_bank_transfer_discount -- 行内转让折价
    ,o.out_bank_transfer_premium -- 行外转让溢价
    ,o.out_bank_transfer_discount -- 行外转让折价
    ,o.balance -- 余额
    ,o.year_basis -- 年基准天数
    ,o.client_type -- 客户类型
    ,o.accounting_status -- 核算状态
    ,o.timestamp -- 时间戳
    ,o.last_update_date -- 上次更新日期
    ,o.reversal_date -- 冲正日期
    ,o.closed_date -- 关闭日期
    ,o.stage_no -- 期次
    ,o.dd_no -- 发放号
    ,o.reversal -- 是否冲正标志
    ,o.sell_clear_int_amt -- 已结转利息
    ,o.sell_clear_odp_amt -- 已结转罚息
    ,o.sell_clear_odi_amt -- 已结转复息
    ,o.busilicence_name -- 营业执照名称
    ,o.merchant_name -- 商户名称
    ,o.ododi_amt -- 复利的复利
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_cl_ul_acct_bk o
    left join ${iol_schema}.ncbs_cl_ul_acct_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_ul_acct_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_ul_acct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_ul_acct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_ul_acct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_ul_acct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_ul_acct exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_ul_acct_cl;
alter table ${iol_schema}.ncbs_cl_ul_acct exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_ul_acct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_ul_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_ul_acct_op purge;
drop table ${iol_schema}.ncbs_cl_ul_acct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_ul_acct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_ul_acct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
