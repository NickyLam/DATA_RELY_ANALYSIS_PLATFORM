/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct
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
create table ${iol_schema}.ncbs_cl_acct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_acct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_op purge;
drop table ${iol_schema}.ncbs_cl_acct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct where 0=1;

create table ${iol_schema}.ncbs_cl_acct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_acct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_cl(
            od_grace_end_date -- 免息截止日期
            ,acct_name -- 账户名称
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,branch -- 机构编号
            ,business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_status_prev -- 账户上一状态
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,appr_flag -- 复核标志
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,calc_times -- 气球贷计算期次
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,five_category -- 贷款五级分类
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,int_ind_flag -- 是否计息
            ,is_individual -- 个体客户标志
            ,lender -- 贷款人
            ,manual_change_schedule_flag -- 是否需要手工录入还款计划
            ,marketing_prod_desc -- 营销产品名称
            ,mid_period -- 累进间隔期数
            ,old_dd_no -- 原发放号
            ,old_loan_no -- 原贷款号
            ,osa_flag -- 离岸标记
            ,other_consumption -- 其他消费
            ,pay_off_type -- 贷款销户类型
            ,pre_repay_deal -- 还款计划变更方式
            ,purpose_id -- 用途编号
            ,recover_flag -- 实时追缴标志字段
            ,regen_schedule_flag -- 重新生成还款计划标志
            ,region_flag -- 区内区外标记
            ,sched_mode -- 还款方式
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,sub_project_no -- 子项目号
            ,sub_sched_mode -- 当前子计划方式
            ,terminal_id -- 交易终端编号
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,closed_date -- 关闭日期
            ,contraction_date -- 变期不变额最后变化日期
            ,effect_date -- 产品生效日期
            ,first_overdue_date -- 最早逾期日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,ssi_end_date -- 贴息截止日期
            ,tran_timestamp -- 交易时间戳
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,add_ratio -- 累进比例
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,contributive_ratio -- 出资比例
            ,fir_period -- 首段期数
            ,formula_amt -- 每期计划还款额
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,old_prod_type -- 原产品类型
            ,pay_off_reason -- 贷款销户原因
            ,add_amt -- 累进金额
            ,apply_branch -- 申请机构
            ,auto_transfer_flag -- 是否核销后自动转款
            ,sched_assemble_flag -- 自动组合还款标识
            ,reaccount_cd -- 对账代码
            ,ext_trade_no -- 原业务编号
            ,hour_int_rate -- 按小时利率
            ,client_econ_type -- 客户经济类型
            ,gear_by_hour_flag -- 按小时靠档标志
            ,abs_flag -- 资产证券化标志
            ,auto_reversal_flag -- 自动冲正标志|自动冲正标志|Y-自动冲正,N-业务冲正
            ,anytime_rec_flag -- 随借随还标志|随借随还标志 Y-是,N-否
            ,gear_prod_flag -- 是否靠档计息标志|是否靠档计息标志
            ,document_id -- 证件号码|证件号码
            ,document_type -- 客户证件类型|客户证件类型
            ,accounting_status_yesterday -- 上日核算状态|ZHC-正常,YUQ-逾期,FYJ-非应计,FY-手工转非应计,DZA-呆账,DZI-呆滞,WRN-核销,TER-终止
            ,is_trf_flag -- 资产转让标志
            ,acct_status_yesterday -- 上一日账户状态
            ,last_merge_flag -- 
            ,renew_fact_flg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_op(
            od_grace_end_date -- 免息截止日期
            ,acct_name -- 账户名称
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,branch -- 机构编号
            ,business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_status_prev -- 账户上一状态
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,appr_flag -- 复核标志
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,calc_times -- 气球贷计算期次
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,five_category -- 贷款五级分类
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,int_ind_flag -- 是否计息
            ,is_individual -- 个体客户标志
            ,lender -- 贷款人
            ,manual_change_schedule_flag -- 是否需要手工录入还款计划
            ,marketing_prod_desc -- 营销产品名称
            ,mid_period -- 累进间隔期数
            ,old_dd_no -- 原发放号
            ,old_loan_no -- 原贷款号
            ,osa_flag -- 离岸标记
            ,other_consumption -- 其他消费
            ,pay_off_type -- 贷款销户类型
            ,pre_repay_deal -- 还款计划变更方式
            ,purpose_id -- 用途编号
            ,recover_flag -- 实时追缴标志字段
            ,regen_schedule_flag -- 重新生成还款计划标志
            ,region_flag -- 区内区外标记
            ,sched_mode -- 还款方式
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,sub_project_no -- 子项目号
            ,sub_sched_mode -- 当前子计划方式
            ,terminal_id -- 交易终端编号
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,closed_date -- 关闭日期
            ,contraction_date -- 变期不变额最后变化日期
            ,effect_date -- 产品生效日期
            ,first_overdue_date -- 最早逾期日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,ssi_end_date -- 贴息截止日期
            ,tran_timestamp -- 交易时间戳
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,add_ratio -- 累进比例
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,contributive_ratio -- 出资比例
            ,fir_period -- 首段期数
            ,formula_amt -- 每期计划还款额
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,old_prod_type -- 原产品类型
            ,pay_off_reason -- 贷款销户原因
            ,add_amt -- 累进金额
            ,apply_branch -- 申请机构
            ,auto_transfer_flag -- 是否核销后自动转款
            ,sched_assemble_flag -- 自动组合还款标识
            ,reaccount_cd -- 对账代码
            ,ext_trade_no -- 原业务编号
            ,hour_int_rate -- 按小时利率
            ,client_econ_type -- 客户经济类型
            ,gear_by_hour_flag -- 按小时靠档标志
            ,abs_flag -- 资产证券化标志
            ,auto_reversal_flag -- 自动冲正标志|自动冲正标志|Y-自动冲正,N-业务冲正
            ,anytime_rec_flag -- 随借随还标志|随借随还标志 Y-是,N-否
            ,gear_prod_flag -- 是否靠档计息标志|是否靠档计息标志
            ,document_id -- 证件号码|证件号码
            ,document_type -- 客户证件类型|客户证件类型
            ,accounting_status_yesterday -- 上日核算状态|ZHC-正常,YUQ-逾期,FYJ-非应计,FY-手工转非应计,DZA-呆账,DZI-呆滞,WRN-核销,TER-终止
            ,is_trf_flag -- 资产转让标志
            ,acct_status_yesterday -- 上一日账户状态
            ,last_merge_flag -- 
            ,renew_fact_flg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.od_grace_end_date, o.od_grace_end_date) as od_grace_end_date -- 免息截止日期
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.business_unit, o.business_unit) as business_unit -- 账套
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.dd_no, o.dd_no) as dd_no -- 发放号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.reason_code, o.reason_code) as reason_code -- 账户用途
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.acct_desc, o.acct_desc) as acct_desc -- 账户描述
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.acct_status_prev, o.acct_status_prev) as acct_status_prev -- 账户上一状态
    ,nvl(n.alloc_seq_fee, o.alloc_seq_fee) as alloc_seq_fee -- 贷款费用还款顺序
    ,nvl(n.alloc_seq_int, o.alloc_seq_int) as alloc_seq_int -- 贷款利息还款顺序
    ,nvl(n.alloc_seq_odi, o.alloc_seq_odi) as alloc_seq_odi -- 贷款复利还款顺序
    ,nvl(n.alloc_seq_odp, o.alloc_seq_odp) as alloc_seq_odp -- 贷款罚息还款顺序
    ,nvl(n.alloc_seq_pri, o.alloc_seq_pri) as alloc_seq_pri -- 贷款本金还款顺序
    ,nvl(n.alloc_seq_type, o.alloc_seq_type) as alloc_seq_type -- 贷款自动还款类型
    ,nvl(n.appr_flag, o.appr_flag) as appr_flag -- 复核标志
    ,nvl(n.auto_settle_flag, o.auto_settle_flag) as auto_settle_flag -- 自动结清标志
    ,nvl(n.bal_type, o.bal_type) as bal_type -- 余额类型
    ,nvl(n.calc_times, o.calc_times) as calc_times -- 气球贷计算期次
    ,nvl(n.cmisloan_no, o.cmisloan_no) as cmisloan_no -- 客户借据编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.cur_stage_no, o.cur_stage_no) as cur_stage_no -- 当前期数
    ,nvl(n.dac_value, o.dac_value) as dac_value -- dac值防篡改加密
    ,nvl(n.five_category, o.five_category) as five_category -- 贷款五级分类
    ,nvl(n.fta_acct_flag, o.fta_acct_flag) as fta_acct_flag -- 是否自贸区账户标识
    ,nvl(n.fta_code, o.fta_code) as fta_code -- 自贸区代码
    ,nvl(n.int_ind_flag, o.int_ind_flag) as int_ind_flag -- 是否计息
    ,nvl(n.is_individual, o.is_individual) as is_individual -- 个体客户标志
    ,nvl(n.lender, o.lender) as lender -- 贷款人
    ,nvl(n.manual_change_schedule_flag, o.manual_change_schedule_flag) as manual_change_schedule_flag -- 是否需要手工录入还款计划
    ,nvl(n.marketing_prod_desc, o.marketing_prod_desc) as marketing_prod_desc -- 营销产品名称
    ,nvl(n.mid_period, o.mid_period) as mid_period -- 累进间隔期数
    ,nvl(n.old_dd_no, o.old_dd_no) as old_dd_no -- 原发放号
    ,nvl(n.old_loan_no, o.old_loan_no) as old_loan_no -- 原贷款号
    ,nvl(n.osa_flag, o.osa_flag) as osa_flag -- 离岸标记
    ,nvl(n.other_consumption, o.other_consumption) as other_consumption -- 其他消费
    ,nvl(n.pay_off_type, o.pay_off_type) as pay_off_type -- 贷款销户类型
    ,nvl(n.pre_repay_deal, o.pre_repay_deal) as pre_repay_deal -- 还款计划变更方式
    ,nvl(n.purpose_id, o.purpose_id) as purpose_id -- 用途编号
    ,nvl(n.recover_flag, o.recover_flag) as recover_flag -- 实时追缴标志字段
    ,nvl(n.regen_schedule_flag, o.regen_schedule_flag) as regen_schedule_flag -- 重新生成还款计划标志
    ,nvl(n.region_flag, o.region_flag) as region_flag -- 区内区外标记
    ,nvl(n.sched_mode, o.sched_mode) as sched_mode -- 还款方式
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.sub_project_no, o.sub_project_no) as sub_project_no -- 子项目号
    ,nvl(n.sub_sched_mode, o.sub_sched_mode) as sub_sched_mode -- 当前子计划方式
    ,nvl(n.terminal_id, o.terminal_id) as terminal_id -- 交易终端编号
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.accounting_status_prev, o.accounting_status_prev) as accounting_status_prev -- 上次核算状态
    ,nvl(n.accounting_status_upd_date, o.accounting_status_upd_date) as accounting_status_upd_date -- 核算状态变更日期
    ,nvl(n.acct_open_date, o.acct_open_date) as acct_open_date -- 账户开户日期
    ,nvl(n.acct_status_upd_date, o.acct_status_upd_date) as acct_status_upd_date -- 账户状态变更日期
    ,nvl(n.approval_date, o.approval_date) as approval_date -- 复核日期
    ,nvl(n.closed_date, o.closed_date) as closed_date -- 关闭日期
    ,nvl(n.contraction_date, o.contraction_date) as contraction_date -- 变期不变额最后变化日期
    ,nvl(n.effect_date, o.effect_date) as effect_date -- 产品生效日期
    ,nvl(n.first_overdue_date, o.first_overdue_date) as first_overdue_date -- 最早逾期日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.last_tran_date, o.last_tran_date) as last_tran_date -- 最后交易日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.open_tran_date, o.open_tran_date) as open_tran_date -- 开户后首次交易日期
    ,nvl(n.ori_maturity_date, o.ori_maturity_date) as ori_maturity_date -- 账户原始到期日期
    ,nvl(n.orig_acct_open_date, o.orig_acct_open_date) as orig_acct_open_date -- 账户原始开立日期
    ,nvl(n.ssi_end_date, o.ssi_end_date) as ssi_end_date -- 贴息截止日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_close_reason, o.acct_close_reason) as acct_close_reason -- 关闭原因
    ,nvl(n.acct_close_user_id, o.acct_close_user_id) as acct_close_user_id -- 账户销户操作柜员
    ,nvl(n.add_ratio, o.add_ratio) as add_ratio -- 累进比例
    ,nvl(n.alt_acct_name, o.alt_acct_name) as alt_acct_name -- 备用账户名称
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.contributive_ratio, o.contributive_ratio) as contributive_ratio -- 出资比例
    ,nvl(n.fir_period, o.fir_period) as fir_period -- 首段期数
    ,nvl(n.formula_amt, o.formula_amt) as formula_amt -- 每期计划还款额
    ,nvl(n.home_branch, o.home_branch) as home_branch -- 客户管理行
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.marketing_prod, o.marketing_prod) as marketing_prod -- 营销产品
    ,nvl(n.old_prod_type, o.old_prod_type) as old_prod_type -- 原产品类型
    ,nvl(n.pay_off_reason, o.pay_off_reason) as pay_off_reason -- 贷款销户原因
    ,nvl(n.add_amt, o.add_amt) as add_amt -- 累进金额
    ,nvl(n.apply_branch, o.apply_branch) as apply_branch -- 申请机构
    ,nvl(n.auto_transfer_flag, o.auto_transfer_flag) as auto_transfer_flag -- 是否核销后自动转款
    ,nvl(n.sched_assemble_flag, o.sched_assemble_flag) as sched_assemble_flag -- 自动组合还款标识
    ,nvl(n.reaccount_cd, o.reaccount_cd) as reaccount_cd -- 对账代码
    ,nvl(n.ext_trade_no, o.ext_trade_no) as ext_trade_no -- 原业务编号
    ,nvl(n.hour_int_rate, o.hour_int_rate) as hour_int_rate -- 按小时利率
    ,nvl(n.client_econ_type, o.client_econ_type) as client_econ_type -- 客户经济类型
    ,nvl(n.gear_by_hour_flag, o.gear_by_hour_flag) as gear_by_hour_flag -- 按小时靠档标志
    ,nvl(n.abs_flag, o.abs_flag) as abs_flag -- 资产证券化标志
    ,nvl(n.auto_reversal_flag, o.auto_reversal_flag) as auto_reversal_flag -- 自动冲正标志|自动冲正标志|Y-自动冲正,N-业务冲正
    ,nvl(n.anytime_rec_flag, o.anytime_rec_flag) as anytime_rec_flag -- 随借随还标志|随借随还标志 Y-是,N-否
    ,nvl(n.gear_prod_flag, o.gear_prod_flag) as gear_prod_flag -- 是否靠档计息标志|是否靠档计息标志
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码|证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型|客户证件类型
    ,nvl(n.accounting_status_yesterday, o.accounting_status_yesterday) as accounting_status_yesterday -- 上日核算状态|ZHC-正常,YUQ-逾期,FYJ-非应计,FY-手工转非应计,DZA-呆账,DZI-呆滞,WRN-核销,TER-终止
    ,nvl(n.is_trf_flag, o.is_trf_flag) as is_trf_flag -- 资产转让标志
    ,nvl(n.acct_status_yesterday, o.acct_status_yesterday) as acct_status_yesterday -- 上一日账户状态
    ,nvl(n.last_merge_flag, o.last_merge_flag) as last_merge_flag -- 
    ,nvl(n.renew_fact_flg, o.renew_fact_flg) as renew_fact_flg -- 
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
from (select * from ${iol_schema}.ncbs_cl_acct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_acct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.od_grace_end_date <> n.od_grace_end_date
        or o.acct_name <> n.acct_name
        or o.acct_status <> n.acct_status
        or o.acct_type <> n.acct_type
        or o.branch <> n.branch
        or o.business_unit <> n.business_unit
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.client_type <> n.client_type
        or o.dd_no <> n.dd_no
        or o.prod_type <> n.prod_type
        or o.profit_center <> n.profit_center
        or o.reason_code <> n.reason_code
        or o.user_id <> n.user_id
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.acct_desc <> n.acct_desc
        or o.acct_exec <> n.acct_exec
        or o.acct_status_prev <> n.acct_status_prev
        or o.alloc_seq_fee <> n.alloc_seq_fee
        or o.alloc_seq_int <> n.alloc_seq_int
        or o.alloc_seq_odi <> n.alloc_seq_odi
        or o.alloc_seq_odp <> n.alloc_seq_odp
        or o.alloc_seq_pri <> n.alloc_seq_pri
        or o.alloc_seq_type <> n.alloc_seq_type
        or o.appr_flag <> n.appr_flag
        or o.auto_settle_flag <> n.auto_settle_flag
        or o.bal_type <> n.bal_type
        or o.calc_times <> n.calc_times
        or o.cmisloan_no <> n.cmisloan_no
        or o.company <> n.company
        or o.cur_stage_no <> n.cur_stage_no
        or o.dac_value <> n.dac_value
        or o.five_category <> n.five_category
        or o.fta_acct_flag <> n.fta_acct_flag
        or o.fta_code <> n.fta_code
        or o.int_ind_flag <> n.int_ind_flag
        or o.is_individual <> n.is_individual
        or o.lender <> n.lender
        or o.manual_change_schedule_flag <> n.manual_change_schedule_flag
        or o.marketing_prod_desc <> n.marketing_prod_desc
        or o.mid_period <> n.mid_period
        or o.old_dd_no <> n.old_dd_no
        or o.old_loan_no <> n.old_loan_no
        or o.osa_flag <> n.osa_flag
        or o.other_consumption <> n.other_consumption
        or o.pay_off_type <> n.pay_off_type
        or o.pre_repay_deal <> n.pre_repay_deal
        or o.purpose_id <> n.purpose_id
        or o.recover_flag <> n.recover_flag
        or o.regen_schedule_flag <> n.regen_schedule_flag
        or o.region_flag <> n.region_flag
        or o.sched_mode <> n.sched_mode
        or o.source_module <> n.source_module
        or o.source_type <> n.source_type
        or o.sub_project_no <> n.sub_project_no
        or o.sub_sched_mode <> n.sub_sched_mode
        or o.terminal_id <> n.terminal_id
        or o.accounting_status <> n.accounting_status
        or o.accounting_status_prev <> n.accounting_status_prev
        or o.accounting_status_upd_date <> n.accounting_status_upd_date
        or o.acct_open_date <> n.acct_open_date
        or o.acct_status_upd_date <> n.acct_status_upd_date
        or o.approval_date <> n.approval_date
        or o.closed_date <> n.closed_date
        or o.contraction_date <> n.contraction_date
        or o.effect_date <> n.effect_date
        or o.first_overdue_date <> n.first_overdue_date
        or o.last_change_date <> n.last_change_date
        or o.last_tran_date <> n.last_tran_date
        or o.maturity_date <> n.maturity_date
        or o.open_tran_date <> n.open_tran_date
        or o.ori_maturity_date <> n.ori_maturity_date
        or o.orig_acct_open_date <> n.orig_acct_open_date
        or o.ssi_end_date <> n.ssi_end_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_close_reason <> n.acct_close_reason
        or o.acct_close_user_id <> n.acct_close_user_id
        or o.add_ratio <> n.add_ratio
        or o.alt_acct_name <> n.alt_acct_name
        or o.appr_user_id <> n.appr_user_id
        or o.contributive_ratio <> n.contributive_ratio
        or o.fir_period <> n.fir_period
        or o.formula_amt <> n.formula_amt
        or o.home_branch <> n.home_branch
        or o.last_change_user_id <> n.last_change_user_id
        or o.loan_no <> n.loan_no
        or o.marketing_prod <> n.marketing_prod
        or o.old_prod_type <> n.old_prod_type
        or o.pay_off_reason <> n.pay_off_reason
        or o.add_amt <> n.add_amt
        or o.apply_branch <> n.apply_branch
        or o.auto_transfer_flag <> n.auto_transfer_flag
        or o.sched_assemble_flag <> n.sched_assemble_flag
        or o.reaccount_cd <> n.reaccount_cd
        or o.ext_trade_no <> n.ext_trade_no
        or o.hour_int_rate <> n.hour_int_rate
        or o.client_econ_type <> n.client_econ_type
        or o.gear_by_hour_flag <> n.gear_by_hour_flag
        or o.abs_flag <> n.abs_flag
        or o.auto_reversal_flag <> n.auto_reversal_flag
        or o.anytime_rec_flag <> n.anytime_rec_flag
        or o.gear_prod_flag <> n.gear_prod_flag
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.accounting_status_yesterday <> n.accounting_status_yesterday
        or o.is_trf_flag <> n.is_trf_flag
        or o.acct_status_yesterday <> n.acct_status_yesterday
        or o.last_merge_flag <> n.last_merge_flag
        or o.renew_fact_flg <> n.renew_fact_flg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_acct_cl(
            od_grace_end_date -- 免息截止日期
            ,acct_name -- 账户名称
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,branch -- 机构编号
            ,business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_status_prev -- 账户上一状态
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,appr_flag -- 复核标志
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,calc_times -- 气球贷计算期次
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,five_category -- 贷款五级分类
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,int_ind_flag -- 是否计息
            ,is_individual -- 个体客户标志
            ,lender -- 贷款人
            ,manual_change_schedule_flag -- 是否需要手工录入还款计划
            ,marketing_prod_desc -- 营销产品名称
            ,mid_period -- 累进间隔期数
            ,old_dd_no -- 原发放号
            ,old_loan_no -- 原贷款号
            ,osa_flag -- 离岸标记
            ,other_consumption -- 其他消费
            ,pay_off_type -- 贷款销户类型
            ,pre_repay_deal -- 还款计划变更方式
            ,purpose_id -- 用途编号
            ,recover_flag -- 实时追缴标志字段
            ,regen_schedule_flag -- 重新生成还款计划标志
            ,region_flag -- 区内区外标记
            ,sched_mode -- 还款方式
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,sub_project_no -- 子项目号
            ,sub_sched_mode -- 当前子计划方式
            ,terminal_id -- 交易终端编号
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,closed_date -- 关闭日期
            ,contraction_date -- 变期不变额最后变化日期
            ,effect_date -- 产品生效日期
            ,first_overdue_date -- 最早逾期日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,ssi_end_date -- 贴息截止日期
            ,tran_timestamp -- 交易时间戳
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,add_ratio -- 累进比例
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,contributive_ratio -- 出资比例
            ,fir_period -- 首段期数
            ,formula_amt -- 每期计划还款额
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,old_prod_type -- 原产品类型
            ,pay_off_reason -- 贷款销户原因
            ,add_amt -- 累进金额
            ,apply_branch -- 申请机构
            ,auto_transfer_flag -- 是否核销后自动转款
            ,sched_assemble_flag -- 自动组合还款标识
            ,reaccount_cd -- 对账代码
            ,ext_trade_no -- 原业务编号
            ,hour_int_rate -- 按小时利率
            ,client_econ_type -- 客户经济类型
            ,gear_by_hour_flag -- 按小时靠档标志
            ,abs_flag -- 资产证券化标志
            ,auto_reversal_flag -- 自动冲正标志|自动冲正标志|Y-自动冲正,N-业务冲正
            ,anytime_rec_flag -- 随借随还标志|随借随还标志 Y-是,N-否
            ,gear_prod_flag -- 是否靠档计息标志|是否靠档计息标志
            ,document_id -- 证件号码|证件号码
            ,document_type -- 客户证件类型|客户证件类型
            ,accounting_status_yesterday -- 上日核算状态|ZHC-正常,YUQ-逾期,FYJ-非应计,FY-手工转非应计,DZA-呆账,DZI-呆滞,WRN-核销,TER-终止
            ,is_trf_flag -- 资产转让标志
            ,acct_status_yesterday -- 上一日账户状态
            ,last_merge_flag -- 
            ,renew_fact_flg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_acct_op(
            od_grace_end_date -- 免息截止日期
            ,acct_name -- 账户名称
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,branch -- 机构编号
            ,business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_status_prev -- 账户上一状态
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,appr_flag -- 复核标志
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,calc_times -- 气球贷计算期次
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,five_category -- 贷款五级分类
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,int_ind_flag -- 是否计息
            ,is_individual -- 个体客户标志
            ,lender -- 贷款人
            ,manual_change_schedule_flag -- 是否需要手工录入还款计划
            ,marketing_prod_desc -- 营销产品名称
            ,mid_period -- 累进间隔期数
            ,old_dd_no -- 原发放号
            ,old_loan_no -- 原贷款号
            ,osa_flag -- 离岸标记
            ,other_consumption -- 其他消费
            ,pay_off_type -- 贷款销户类型
            ,pre_repay_deal -- 还款计划变更方式
            ,purpose_id -- 用途编号
            ,recover_flag -- 实时追缴标志字段
            ,regen_schedule_flag -- 重新生成还款计划标志
            ,region_flag -- 区内区外标记
            ,sched_mode -- 还款方式
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,sub_project_no -- 子项目号
            ,sub_sched_mode -- 当前子计划方式
            ,terminal_id -- 交易终端编号
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,closed_date -- 关闭日期
            ,contraction_date -- 变期不变额最后变化日期
            ,effect_date -- 产品生效日期
            ,first_overdue_date -- 最早逾期日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,ssi_end_date -- 贴息截止日期
            ,tran_timestamp -- 交易时间戳
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,add_ratio -- 累进比例
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,contributive_ratio -- 出资比例
            ,fir_period -- 首段期数
            ,formula_amt -- 每期计划还款额
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,old_prod_type -- 原产品类型
            ,pay_off_reason -- 贷款销户原因
            ,add_amt -- 累进金额
            ,apply_branch -- 申请机构
            ,auto_transfer_flag -- 是否核销后自动转款
            ,sched_assemble_flag -- 自动组合还款标识
            ,reaccount_cd -- 对账代码
            ,ext_trade_no -- 原业务编号
            ,hour_int_rate -- 按小时利率
            ,client_econ_type -- 客户经济类型
            ,gear_by_hour_flag -- 按小时靠档标志
            ,abs_flag -- 资产证券化标志
            ,auto_reversal_flag -- 自动冲正标志|自动冲正标志|Y-自动冲正,N-业务冲正
            ,anytime_rec_flag -- 随借随还标志|随借随还标志 Y-是,N-否
            ,gear_prod_flag -- 是否靠档计息标志|是否靠档计息标志
            ,document_id -- 证件号码|证件号码
            ,document_type -- 客户证件类型|客户证件类型
            ,accounting_status_yesterday -- 上日核算状态|ZHC-正常,YUQ-逾期,FYJ-非应计,FY-手工转非应计,DZA-呆账,DZI-呆滞,WRN-核销,TER-终止
            ,is_trf_flag -- 资产转让标志
            ,acct_status_yesterday -- 上一日账户状态
            ,last_merge_flag -- 
            ,renew_fact_flg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.od_grace_end_date -- 免息截止日期
    ,o.acct_name -- 账户名称
    ,o.acct_status -- 账户状态
    ,o.acct_type -- 账户类型
    ,o.branch -- 机构编号
    ,o.business_unit -- 账套
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.dd_no -- 发放号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.profit_center -- 利润中心
    ,o.reason_code -- 账户用途
    ,o.user_id -- 交易柜员编号
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.acct_desc -- 账户描述
    ,o.acct_exec -- 银行客户经理编号
    ,o.acct_status_prev -- 账户上一状态
    ,o.alloc_seq_fee -- 贷款费用还款顺序
    ,o.alloc_seq_int -- 贷款利息还款顺序
    ,o.alloc_seq_odi -- 贷款复利还款顺序
    ,o.alloc_seq_odp -- 贷款罚息还款顺序
    ,o.alloc_seq_pri -- 贷款本金还款顺序
    ,o.alloc_seq_type -- 贷款自动还款类型
    ,o.appr_flag -- 复核标志
    ,o.auto_settle_flag -- 自动结清标志
    ,o.bal_type -- 余额类型
    ,o.calc_times -- 气球贷计算期次
    ,o.cmisloan_no -- 客户借据编号
    ,o.company -- 法人
    ,o.cur_stage_no -- 当前期数
    ,o.dac_value -- dac值防篡改加密
    ,o.five_category -- 贷款五级分类
    ,o.fta_acct_flag -- 是否自贸区账户标识
    ,o.fta_code -- 自贸区代码
    ,o.int_ind_flag -- 是否计息
    ,o.is_individual -- 个体客户标志
    ,o.lender -- 贷款人
    ,o.manual_change_schedule_flag -- 是否需要手工录入还款计划
    ,o.marketing_prod_desc -- 营销产品名称
    ,o.mid_period -- 累进间隔期数
    ,o.old_dd_no -- 原发放号
    ,o.old_loan_no -- 原贷款号
    ,o.osa_flag -- 离岸标记
    ,o.other_consumption -- 其他消费
    ,o.pay_off_type -- 贷款销户类型
    ,o.pre_repay_deal -- 还款计划变更方式
    ,o.purpose_id -- 用途编号
    ,o.recover_flag -- 实时追缴标志字段
    ,o.regen_schedule_flag -- 重新生成还款计划标志
    ,o.region_flag -- 区内区外标记
    ,o.sched_mode -- 还款方式
    ,o.source_module -- 源模块
    ,o.source_type -- 渠道编号
    ,o.sub_project_no -- 子项目号
    ,o.sub_sched_mode -- 当前子计划方式
    ,o.terminal_id -- 交易终端编号
    ,o.accounting_status -- 核算状态
    ,o.accounting_status_prev -- 上次核算状态
    ,o.accounting_status_upd_date -- 核算状态变更日期
    ,o.acct_open_date -- 账户开户日期
    ,o.acct_status_upd_date -- 账户状态变更日期
    ,o.approval_date -- 复核日期
    ,o.closed_date -- 关闭日期
    ,o.contraction_date -- 变期不变额最后变化日期
    ,o.effect_date -- 产品生效日期
    ,o.first_overdue_date -- 最早逾期日期
    ,o.last_change_date -- 最后修改日期
    ,o.last_tran_date -- 最后交易日期
    ,o.maturity_date -- 到期日期
    ,o.open_tran_date -- 开户后首次交易日期
    ,o.ori_maturity_date -- 账户原始到期日期
    ,o.orig_acct_open_date -- 账户原始开立日期
    ,o.ssi_end_date -- 贴息截止日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_close_reason -- 关闭原因
    ,o.acct_close_user_id -- 账户销户操作柜员
    ,o.add_ratio -- 累进比例
    ,o.alt_acct_name -- 备用账户名称
    ,o.appr_user_id -- 复核柜员
    ,o.contributive_ratio -- 出资比例
    ,o.fir_period -- 首段期数
    ,o.formula_amt -- 每期计划还款额
    ,o.home_branch -- 客户管理行
    ,o.last_change_user_id -- 最后修改柜员
    ,o.loan_no -- 贷款号
    ,o.marketing_prod -- 营销产品
    ,o.old_prod_type -- 原产品类型
    ,o.pay_off_reason -- 贷款销户原因
    ,o.add_amt -- 累进金额
    ,o.apply_branch -- 申请机构
    ,o.auto_transfer_flag -- 是否核销后自动转款
    ,o.sched_assemble_flag -- 自动组合还款标识
    ,o.reaccount_cd -- 对账代码
    ,o.ext_trade_no -- 原业务编号
    ,o.hour_int_rate -- 按小时利率
    ,o.client_econ_type -- 客户经济类型
    ,o.gear_by_hour_flag -- 按小时靠档标志
    ,o.abs_flag -- 资产证券化标志
    ,o.auto_reversal_flag -- 自动冲正标志|自动冲正标志|Y-自动冲正,N-业务冲正
    ,o.anytime_rec_flag -- 随借随还标志|随借随还标志 Y-是,N-否
    ,o.gear_prod_flag -- 是否靠档计息标志|是否靠档计息标志
    ,o.document_id -- 证件号码|证件号码
    ,o.document_type -- 客户证件类型|客户证件类型
    ,o.accounting_status_yesterday -- 上日核算状态|ZHC-正常,YUQ-逾期,FYJ-非应计,FY-手工转非应计,DZA-呆账,DZI-呆滞,WRN-核销,TER-终止
    ,o.is_trf_flag -- 资产转让标志
    ,o.acct_status_yesterday -- 上一日账户状态
    ,o.last_merge_flag -- 
    ,o.renew_fact_flg -- 
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
from ${iol_schema}.ncbs_cl_acct_bk o
    left join ${iol_schema}.ncbs_cl_acct_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_acct_cl d
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
--truncate table ${iol_schema}.ncbs_cl_acct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_acct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_acct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_acct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_acct exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_acct_cl;
alter table ${iol_schema}.ncbs_cl_acct exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_acct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_acct_op purge;
drop table ${iol_schema}.ncbs_cl_acct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_acct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_acct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
