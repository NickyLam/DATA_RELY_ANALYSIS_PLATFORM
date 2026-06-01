/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_loan
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
create table ${iol_schema}.ncbs_cl_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_loan_op purge;
drop table ${iol_schema}.ncbs_cl_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_loan where 0=1;

create table ${iol_schema}.ncbs_cl_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_loan_cl(
            grace_term_type -- 宽限期次类型
            ,acct_name -- 账户名称
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_short -- 客户简称
            ,contract_no -- 合同编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acct_status_prev -- 账户上一状态
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,analysis1 -- 统计标志1
            ,analysis2 -- 统计标志2
            ,analysis3 -- 统计标志3
            ,anytime_rec_flag -- 随借随还标志
            ,arr_bank -- 银团贷款安排行
            ,auto_loan_classify_flag -- 自动更改状态标记
            ,auto_settle_flag -- 自动结清标志
            ,buy_bank -- 买入银行
            ,calc_times -- 气球贷计算期次
            ,company -- 法人
            ,credit_no -- 贷款项目号
            ,dd_inc_ind -- 增量发放标志
            ,entrust_settle_flag -- 委托贷款结算标志
            ,five_category -- 贷款五级分类
            ,force_grace_flag -- 宽限期遇节假日是否顺延
            ,grace_charge_int_flag -- 到期本金在宽限期是否收息
            ,grace_type -- 宽限期类型
            ,guaranty_style -- 担保方式
            ,int_penalty -- 是否收取复利
            ,lender -- 贷款人
            ,loan_class -- 贷款类别
            ,manager_bank -- 银团贷款管理行
            ,marketing_prod_desc -- 营销产品名称
            ,max_extend_times -- 最大展期次数
            ,od_int_penalty_flag -- 是否收取复利的复利
            ,od_pri_penalty_flag -- 是否收取罚息的复利
            ,old_loan_no -- 原贷款号
            ,pause_int_ind -- 贷款停息标志
            ,pre_rate_type -- 提前还款费用类型
            ,pre_repay_deal -- 还款计划变更方式
            ,pri_penalty_flag -- 是否收取罚息
            ,purpose -- 贷款用途
            ,recourse_ind -- 追索标记
            ,related_loan_no -- 关联贷款号
            ,sched_mode -- 还款方式
            ,sof_state -- 资金来源省
            ,sold_ind -- 卖出标记
            ,stamp_tax_flag -- 贷款印花税
            ,syn_dd_times -- 银团贷款发放次数
            ,sync_final_billing_flag -- 是否利随本清标志
            ,taxable_ind -- 收税标志
            ,tf_loan_type -- tf贷款类型
            ,tf_ref_no -- 国结参考号
            ,trade_ref_no -- 贸易参考号
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,loan_status -- 贷款账户状态
            ,hunting_status -- 持续扣款标志
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,closed_date -- 关闭日期
            ,dd_end_date -- 发放截止日期
            ,last_change_date -- 最后修改日期
            ,maturity_date -- 到期日期
            ,sign_date -- 签约日期
            ,special_sign_date -- 特色产品签约日期
            ,ssi_end_date -- 贴息截止日期
            ,tran_timestamp -- 交易时间戳
            ,sof_country -- 资金来源国家
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,close_reason -- 注销原因
            ,commit_amt -- 承诺额
            ,contribute_amt -- 参与行出资金额
            ,grace_period -- 宽限期的天数
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,od_grace_period_days -- 免息期天数
            ,orig_loan_amt -- 贷款签约合同金额
            ,pr_min_amt -- 提前还款最低补偿金
            ,pre_pay_rate -- 提前还本的补偿金率
            ,ui_min_amt -- 折扣贷款提前还款最低罚金
            ,ui_prepayment -- 折扣贷款提前还款罚率
            ,grace_int_flag -- 是否宽限利息
            ,grace_pri_flag -- 是否宽限本金
            ,auto_settle_sod_int_flag -- 是否日起自动结算利息
            ,auto_settle_sod_pri_flag -- 是否日起自动结算本金
            ,before_income_flag -- 是否前收息标志
            ,grace_charge_odi_flag -- 到期利息在宽限期是否收复利
            ,compensate_ratio -- 理赔比例
            ,cross_period_flag -- 跨月/季标志
            ,due_compensate_period -- 逾期理赔天数
            ,receive_anytime_flag -- 是否随还标志
            ,corp_size -- 企业规模
            ,gear_prod_flag -- 是否靠档计息标志
            ,econ_department_type -- 国民经济部门类型
            ,is_individual_busi -- 是否个体工商户
            ,amount_nature -- 资金性质|法人透支使用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_loan_op(
            grace_term_type -- 宽限期次类型
            ,acct_name -- 账户名称
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_short -- 客户简称
            ,contract_no -- 合同编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acct_status_prev -- 账户上一状态
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,analysis1 -- 统计标志1
            ,analysis2 -- 统计标志2
            ,analysis3 -- 统计标志3
            ,anytime_rec_flag -- 随借随还标志
            ,arr_bank -- 银团贷款安排行
            ,auto_loan_classify_flag -- 自动更改状态标记
            ,auto_settle_flag -- 自动结清标志
            ,buy_bank -- 买入银行
            ,calc_times -- 气球贷计算期次
            ,company -- 法人
            ,credit_no -- 贷款项目号
            ,dd_inc_ind -- 增量发放标志
            ,entrust_settle_flag -- 委托贷款结算标志
            ,five_category -- 贷款五级分类
            ,force_grace_flag -- 宽限期遇节假日是否顺延
            ,grace_charge_int_flag -- 到期本金在宽限期是否收息
            ,grace_type -- 宽限期类型
            ,guaranty_style -- 担保方式
            ,int_penalty -- 是否收取复利
            ,lender -- 贷款人
            ,loan_class -- 贷款类别
            ,manager_bank -- 银团贷款管理行
            ,marketing_prod_desc -- 营销产品名称
            ,max_extend_times -- 最大展期次数
            ,od_int_penalty_flag -- 是否收取复利的复利
            ,od_pri_penalty_flag -- 是否收取罚息的复利
            ,old_loan_no -- 原贷款号
            ,pause_int_ind -- 贷款停息标志
            ,pre_rate_type -- 提前还款费用类型
            ,pre_repay_deal -- 还款计划变更方式
            ,pri_penalty_flag -- 是否收取罚息
            ,purpose -- 贷款用途
            ,recourse_ind -- 追索标记
            ,related_loan_no -- 关联贷款号
            ,sched_mode -- 还款方式
            ,sof_state -- 资金来源省
            ,sold_ind -- 卖出标记
            ,stamp_tax_flag -- 贷款印花税
            ,syn_dd_times -- 银团贷款发放次数
            ,sync_final_billing_flag -- 是否利随本清标志
            ,taxable_ind -- 收税标志
            ,tf_loan_type -- tf贷款类型
            ,tf_ref_no -- 国结参考号
            ,trade_ref_no -- 贸易参考号
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,loan_status -- 贷款账户状态
            ,hunting_status -- 持续扣款标志
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,closed_date -- 关闭日期
            ,dd_end_date -- 发放截止日期
            ,last_change_date -- 最后修改日期
            ,maturity_date -- 到期日期
            ,sign_date -- 签约日期
            ,special_sign_date -- 特色产品签约日期
            ,ssi_end_date -- 贴息截止日期
            ,tran_timestamp -- 交易时间戳
            ,sof_country -- 资金来源国家
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,close_reason -- 注销原因
            ,commit_amt -- 承诺额
            ,contribute_amt -- 参与行出资金额
            ,grace_period -- 宽限期的天数
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,od_grace_period_days -- 免息期天数
            ,orig_loan_amt -- 贷款签约合同金额
            ,pr_min_amt -- 提前还款最低补偿金
            ,pre_pay_rate -- 提前还本的补偿金率
            ,ui_min_amt -- 折扣贷款提前还款最低罚金
            ,ui_prepayment -- 折扣贷款提前还款罚率
            ,grace_int_flag -- 是否宽限利息
            ,grace_pri_flag -- 是否宽限本金
            ,auto_settle_sod_int_flag -- 是否日起自动结算利息
            ,auto_settle_sod_pri_flag -- 是否日起自动结算本金
            ,before_income_flag -- 是否前收息标志
            ,grace_charge_odi_flag -- 到期利息在宽限期是否收复利
            ,compensate_ratio -- 理赔比例
            ,cross_period_flag -- 跨月/季标志
            ,due_compensate_period -- 逾期理赔天数
            ,receive_anytime_flag -- 是否随还标志
            ,corp_size -- 企业规模
            ,gear_prod_flag -- 是否靠档计息标志
            ,econ_department_type -- 国民经济部门类型
            ,is_individual_busi -- 是否个体工商户
            ,amount_nature -- 资金性质|法人透支使用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grace_term_type, o.grace_term_type) as grace_term_type -- 宽限期次类型
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_short, o.client_short) as client_short -- 客户简称
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.acct_status_prev, o.acct_status_prev) as acct_status_prev -- 账户上一状态
    ,nvl(n.alloc_seq_fee, o.alloc_seq_fee) as alloc_seq_fee -- 贷款费用还款顺序
    ,nvl(n.alloc_seq_int, o.alloc_seq_int) as alloc_seq_int -- 贷款利息还款顺序
    ,nvl(n.alloc_seq_odi, o.alloc_seq_odi) as alloc_seq_odi -- 贷款复利还款顺序
    ,nvl(n.alloc_seq_odp, o.alloc_seq_odp) as alloc_seq_odp -- 贷款罚息还款顺序
    ,nvl(n.alloc_seq_pri, o.alloc_seq_pri) as alloc_seq_pri -- 贷款本金还款顺序
    ,nvl(n.alloc_seq_type, o.alloc_seq_type) as alloc_seq_type -- 贷款自动还款类型
    ,nvl(n.analysis1, o.analysis1) as analysis1 -- 统计标志1
    ,nvl(n.analysis2, o.analysis2) as analysis2 -- 统计标志2
    ,nvl(n.analysis3, o.analysis3) as analysis3 -- 统计标志3
    ,nvl(n.anytime_rec_flag, o.anytime_rec_flag) as anytime_rec_flag -- 随借随还标志
    ,nvl(n.arr_bank, o.arr_bank) as arr_bank -- 银团贷款安排行
    ,nvl(n.auto_loan_classify_flag, o.auto_loan_classify_flag) as auto_loan_classify_flag -- 自动更改状态标记
    ,nvl(n.auto_settle_flag, o.auto_settle_flag) as auto_settle_flag -- 自动结清标志
    ,nvl(n.buy_bank, o.buy_bank) as buy_bank -- 买入银行
    ,nvl(n.calc_times, o.calc_times) as calc_times -- 气球贷计算期次
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.credit_no, o.credit_no) as credit_no -- 贷款项目号
    ,nvl(n.dd_inc_ind, o.dd_inc_ind) as dd_inc_ind -- 增量发放标志
    ,nvl(n.entrust_settle_flag, o.entrust_settle_flag) as entrust_settle_flag -- 委托贷款结算标志
    ,nvl(n.five_category, o.five_category) as five_category -- 贷款五级分类
    ,nvl(n.force_grace_flag, o.force_grace_flag) as force_grace_flag -- 宽限期遇节假日是否顺延
    ,nvl(n.grace_charge_int_flag, o.grace_charge_int_flag) as grace_charge_int_flag -- 到期本金在宽限期是否收息
    ,nvl(n.grace_type, o.grace_type) as grace_type -- 宽限期类型
    ,nvl(n.guaranty_style, o.guaranty_style) as guaranty_style -- 担保方式
    ,nvl(n.int_penalty, o.int_penalty) as int_penalty -- 是否收取复利
    ,nvl(n.lender, o.lender) as lender -- 贷款人
    ,nvl(n.loan_class, o.loan_class) as loan_class -- 贷款类别
    ,nvl(n.manager_bank, o.manager_bank) as manager_bank -- 银团贷款管理行
    ,nvl(n.marketing_prod_desc, o.marketing_prod_desc) as marketing_prod_desc -- 营销产品名称
    ,nvl(n.max_extend_times, o.max_extend_times) as max_extend_times -- 最大展期次数
    ,nvl(n.od_int_penalty_flag, o.od_int_penalty_flag) as od_int_penalty_flag -- 是否收取复利的复利
    ,nvl(n.od_pri_penalty_flag, o.od_pri_penalty_flag) as od_pri_penalty_flag -- 是否收取罚息的复利
    ,nvl(n.old_loan_no, o.old_loan_no) as old_loan_no -- 原贷款号
    ,nvl(n.pause_int_ind, o.pause_int_ind) as pause_int_ind -- 贷款停息标志
    ,nvl(n.pre_rate_type, o.pre_rate_type) as pre_rate_type -- 提前还款费用类型
    ,nvl(n.pre_repay_deal, o.pre_repay_deal) as pre_repay_deal -- 还款计划变更方式
    ,nvl(n.pri_penalty_flag, o.pri_penalty_flag) as pri_penalty_flag -- 是否收取罚息
    ,nvl(n.purpose, o.purpose) as purpose -- 贷款用途
    ,nvl(n.recourse_ind, o.recourse_ind) as recourse_ind -- 追索标记
    ,nvl(n.related_loan_no, o.related_loan_no) as related_loan_no -- 关联贷款号
    ,nvl(n.sched_mode, o.sched_mode) as sched_mode -- 还款方式
    ,nvl(n.sof_state, o.sof_state) as sof_state -- 资金来源省
    ,nvl(n.sold_ind, o.sold_ind) as sold_ind -- 卖出标记
    ,nvl(n.stamp_tax_flag, o.stamp_tax_flag) as stamp_tax_flag -- 贷款印花税
    ,nvl(n.syn_dd_times, o.syn_dd_times) as syn_dd_times -- 银团贷款发放次数
    ,nvl(n.sync_final_billing_flag, o.sync_final_billing_flag) as sync_final_billing_flag -- 是否利随本清标志
    ,nvl(n.taxable_ind, o.taxable_ind) as taxable_ind -- 收税标志
    ,nvl(n.tf_loan_type, o.tf_loan_type) as tf_loan_type -- tf贷款类型
    ,nvl(n.tf_ref_no, o.tf_ref_no) as tf_ref_no -- 国结参考号
    ,nvl(n.trade_ref_no, o.trade_ref_no) as trade_ref_no -- 贸易参考号
    ,nvl(n.accounting_status, o.accounting_status) as accounting_status -- 核算状态
    ,nvl(n.accounting_status_prev, o.accounting_status_prev) as accounting_status_prev -- 上次核算状态
    ,nvl(n.loan_status, o.loan_status) as loan_status -- 贷款账户状态
    ,nvl(n.hunting_status, o.hunting_status) as hunting_status -- 持续扣款标志
    ,nvl(n.accounting_status_upd_date, o.accounting_status_upd_date) as accounting_status_upd_date -- 核算状态变更日期
    ,nvl(n.acct_status_upd_date, o.acct_status_upd_date) as acct_status_upd_date -- 账户状态变更日期
    ,nvl(n.closed_date, o.closed_date) as closed_date -- 关闭日期
    ,nvl(n.dd_end_date, o.dd_end_date) as dd_end_date -- 发放截止日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日期
    ,nvl(n.sign_date, o.sign_date) as sign_date -- 签约日期
    ,nvl(n.special_sign_date, o.special_sign_date) as special_sign_date -- 特色产品签约日期
    ,nvl(n.ssi_end_date, o.ssi_end_date) as ssi_end_date -- 贴息截止日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.sof_country, o.sof_country) as sof_country -- 资金来源国家
    ,nvl(n.acct_close_reason, o.acct_close_reason) as acct_close_reason -- 关闭原因
    ,nvl(n.acct_close_user_id, o.acct_close_user_id) as acct_close_user_id -- 账户销户操作柜员
    ,nvl(n.close_reason, o.close_reason) as close_reason -- 注销原因
    ,nvl(n.commit_amt, o.commit_amt) as commit_amt -- 承诺额
    ,nvl(n.contribute_amt, o.contribute_amt) as contribute_amt -- 参与行出资金额
    ,nvl(n.grace_period, o.grace_period) as grace_period -- 宽限期的天数
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 贷款号
    ,nvl(n.marketing_prod, o.marketing_prod) as marketing_prod -- 营销产品
    ,nvl(n.od_grace_period_days, o.od_grace_period_days) as od_grace_period_days -- 免息期天数
    ,nvl(n.orig_loan_amt, o.orig_loan_amt) as orig_loan_amt -- 贷款签约合同金额
    ,nvl(n.pr_min_amt, o.pr_min_amt) as pr_min_amt -- 提前还款最低补偿金
    ,nvl(n.pre_pay_rate, o.pre_pay_rate) as pre_pay_rate -- 提前还本的补偿金率
    ,nvl(n.ui_min_amt, o.ui_min_amt) as ui_min_amt -- 折扣贷款提前还款最低罚金
    ,nvl(n.ui_prepayment, o.ui_prepayment) as ui_prepayment -- 折扣贷款提前还款罚率
    ,nvl(n.grace_int_flag, o.grace_int_flag) as grace_int_flag -- 是否宽限利息
    ,nvl(n.grace_pri_flag, o.grace_pri_flag) as grace_pri_flag -- 是否宽限本金
    ,nvl(n.auto_settle_sod_int_flag, o.auto_settle_sod_int_flag) as auto_settle_sod_int_flag -- 是否日起自动结算利息
    ,nvl(n.auto_settle_sod_pri_flag, o.auto_settle_sod_pri_flag) as auto_settle_sod_pri_flag -- 是否日起自动结算本金
    ,nvl(n.before_income_flag, o.before_income_flag) as before_income_flag -- 是否前收息标志
    ,nvl(n.grace_charge_odi_flag, o.grace_charge_odi_flag) as grace_charge_odi_flag -- 到期利息在宽限期是否收复利
    ,nvl(n.compensate_ratio, o.compensate_ratio) as compensate_ratio -- 理赔比例
    ,nvl(n.cross_period_flag, o.cross_period_flag) as cross_period_flag -- 跨月/季标志
    ,nvl(n.due_compensate_period, o.due_compensate_period) as due_compensate_period -- 逾期理赔天数
    ,nvl(n.receive_anytime_flag, o.receive_anytime_flag) as receive_anytime_flag -- 是否随还标志
    ,nvl(n.corp_size, o.corp_size) as corp_size -- 企业规模
    ,nvl(n.gear_prod_flag, o.gear_prod_flag) as gear_prod_flag -- 是否靠档计息标志
    ,nvl(n.econ_department_type, o.econ_department_type) as econ_department_type -- 国民经济部门类型
    ,nvl(n.is_individual_busi, o.is_individual_busi) as is_individual_busi -- 是否个体工商户
    ,nvl(n.amount_nature, o.amount_nature) as amount_nature -- 资金性质|法人透支使用
    ,case when
            n.loan_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.loan_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.loan_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.loan_no = n.loan_no
where (
        o.loan_no is null
    )
    or (
        n.loan_no is null
    )
    or (
        o.grace_term_type <> n.grace_term_type
        or o.acct_name <> n.acct_name
        or o.branch <> n.branch
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.client_short <> n.client_short
        or o.contract_no <> n.contract_no
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.acct_status_prev <> n.acct_status_prev
        or o.alloc_seq_fee <> n.alloc_seq_fee
        or o.alloc_seq_int <> n.alloc_seq_int
        or o.alloc_seq_odi <> n.alloc_seq_odi
        or o.alloc_seq_odp <> n.alloc_seq_odp
        or o.alloc_seq_pri <> n.alloc_seq_pri
        or o.alloc_seq_type <> n.alloc_seq_type
        or o.analysis1 <> n.analysis1
        or o.analysis2 <> n.analysis2
        or o.analysis3 <> n.analysis3
        or o.anytime_rec_flag <> n.anytime_rec_flag
        or o.arr_bank <> n.arr_bank
        or o.auto_loan_classify_flag <> n.auto_loan_classify_flag
        or o.auto_settle_flag <> n.auto_settle_flag
        or o.buy_bank <> n.buy_bank
        or o.calc_times <> n.calc_times
        or o.company <> n.company
        or o.credit_no <> n.credit_no
        or o.dd_inc_ind <> n.dd_inc_ind
        or o.entrust_settle_flag <> n.entrust_settle_flag
        or o.five_category <> n.five_category
        or o.force_grace_flag <> n.force_grace_flag
        or o.grace_charge_int_flag <> n.grace_charge_int_flag
        or o.grace_type <> n.grace_type
        or o.guaranty_style <> n.guaranty_style
        or o.int_penalty <> n.int_penalty
        or o.lender <> n.lender
        or o.loan_class <> n.loan_class
        or o.manager_bank <> n.manager_bank
        or o.marketing_prod_desc <> n.marketing_prod_desc
        or o.max_extend_times <> n.max_extend_times
        or o.od_int_penalty_flag <> n.od_int_penalty_flag
        or o.od_pri_penalty_flag <> n.od_pri_penalty_flag
        or o.old_loan_no <> n.old_loan_no
        or o.pause_int_ind <> n.pause_int_ind
        or o.pre_rate_type <> n.pre_rate_type
        or o.pre_repay_deal <> n.pre_repay_deal
        or o.pri_penalty_flag <> n.pri_penalty_flag
        or o.purpose <> n.purpose
        or o.recourse_ind <> n.recourse_ind
        or o.related_loan_no <> n.related_loan_no
        or o.sched_mode <> n.sched_mode
        or o.sof_state <> n.sof_state
        or o.sold_ind <> n.sold_ind
        or o.stamp_tax_flag <> n.stamp_tax_flag
        or o.syn_dd_times <> n.syn_dd_times
        or o.sync_final_billing_flag <> n.sync_final_billing_flag
        or o.taxable_ind <> n.taxable_ind
        or o.tf_loan_type <> n.tf_loan_type
        or o.tf_ref_no <> n.tf_ref_no
        or o.trade_ref_no <> n.trade_ref_no
        or o.accounting_status <> n.accounting_status
        or o.accounting_status_prev <> n.accounting_status_prev
        or o.loan_status <> n.loan_status
        or o.hunting_status <> n.hunting_status
        or o.accounting_status_upd_date <> n.accounting_status_upd_date
        or o.acct_status_upd_date <> n.acct_status_upd_date
        or o.closed_date <> n.closed_date
        or o.dd_end_date <> n.dd_end_date
        or o.last_change_date <> n.last_change_date
        or o.maturity_date <> n.maturity_date
        or o.sign_date <> n.sign_date
        or o.special_sign_date <> n.special_sign_date
        or o.ssi_end_date <> n.ssi_end_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.sof_country <> n.sof_country
        or o.acct_close_reason <> n.acct_close_reason
        or o.acct_close_user_id <> n.acct_close_user_id
        or o.close_reason <> n.close_reason
        or o.commit_amt <> n.commit_amt
        or o.contribute_amt <> n.contribute_amt
        or o.grace_period <> n.grace_period
        or o.last_change_user_id <> n.last_change_user_id
        or o.marketing_prod <> n.marketing_prod
        or o.od_grace_period_days <> n.od_grace_period_days
        or o.orig_loan_amt <> n.orig_loan_amt
        or o.pr_min_amt <> n.pr_min_amt
        or o.pre_pay_rate <> n.pre_pay_rate
        or o.ui_min_amt <> n.ui_min_amt
        or o.ui_prepayment <> n.ui_prepayment
        or o.grace_int_flag <> n.grace_int_flag
        or o.grace_pri_flag <> n.grace_pri_flag
        or o.auto_settle_sod_int_flag <> n.auto_settle_sod_int_flag
        or o.auto_settle_sod_pri_flag <> n.auto_settle_sod_pri_flag
        or o.before_income_flag <> n.before_income_flag
        or o.grace_charge_odi_flag <> n.grace_charge_odi_flag
        or o.compensate_ratio <> n.compensate_ratio
        or o.cross_period_flag <> n.cross_period_flag
        or o.due_compensate_period <> n.due_compensate_period
        or o.receive_anytime_flag <> n.receive_anytime_flag
        or o.corp_size <> n.corp_size
        or o.gear_prod_flag <> n.gear_prod_flag
        or o.econ_department_type <> n.econ_department_type
        or o.is_individual_busi <> n.is_individual_busi
        or o.amount_nature <> n.amount_nature
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_loan_cl(
            grace_term_type -- 宽限期次类型
            ,acct_name -- 账户名称
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_short -- 客户简称
            ,contract_no -- 合同编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acct_status_prev -- 账户上一状态
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,analysis1 -- 统计标志1
            ,analysis2 -- 统计标志2
            ,analysis3 -- 统计标志3
            ,anytime_rec_flag -- 随借随还标志
            ,arr_bank -- 银团贷款安排行
            ,auto_loan_classify_flag -- 自动更改状态标记
            ,auto_settle_flag -- 自动结清标志
            ,buy_bank -- 买入银行
            ,calc_times -- 气球贷计算期次
            ,company -- 法人
            ,credit_no -- 贷款项目号
            ,dd_inc_ind -- 增量发放标志
            ,entrust_settle_flag -- 委托贷款结算标志
            ,five_category -- 贷款五级分类
            ,force_grace_flag -- 宽限期遇节假日是否顺延
            ,grace_charge_int_flag -- 到期本金在宽限期是否收息
            ,grace_type -- 宽限期类型
            ,guaranty_style -- 担保方式
            ,int_penalty -- 是否收取复利
            ,lender -- 贷款人
            ,loan_class -- 贷款类别
            ,manager_bank -- 银团贷款管理行
            ,marketing_prod_desc -- 营销产品名称
            ,max_extend_times -- 最大展期次数
            ,od_int_penalty_flag -- 是否收取复利的复利
            ,od_pri_penalty_flag -- 是否收取罚息的复利
            ,old_loan_no -- 原贷款号
            ,pause_int_ind -- 贷款停息标志
            ,pre_rate_type -- 提前还款费用类型
            ,pre_repay_deal -- 还款计划变更方式
            ,pri_penalty_flag -- 是否收取罚息
            ,purpose -- 贷款用途
            ,recourse_ind -- 追索标记
            ,related_loan_no -- 关联贷款号
            ,sched_mode -- 还款方式
            ,sof_state -- 资金来源省
            ,sold_ind -- 卖出标记
            ,stamp_tax_flag -- 贷款印花税
            ,syn_dd_times -- 银团贷款发放次数
            ,sync_final_billing_flag -- 是否利随本清标志
            ,taxable_ind -- 收税标志
            ,tf_loan_type -- tf贷款类型
            ,tf_ref_no -- 国结参考号
            ,trade_ref_no -- 贸易参考号
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,loan_status -- 贷款账户状态
            ,hunting_status -- 持续扣款标志
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,closed_date -- 关闭日期
            ,dd_end_date -- 发放截止日期
            ,last_change_date -- 最后修改日期
            ,maturity_date -- 到期日期
            ,sign_date -- 签约日期
            ,special_sign_date -- 特色产品签约日期
            ,ssi_end_date -- 贴息截止日期
            ,tran_timestamp -- 交易时间戳
            ,sof_country -- 资金来源国家
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,close_reason -- 注销原因
            ,commit_amt -- 承诺额
            ,contribute_amt -- 参与行出资金额
            ,grace_period -- 宽限期的天数
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,od_grace_period_days -- 免息期天数
            ,orig_loan_amt -- 贷款签约合同金额
            ,pr_min_amt -- 提前还款最低补偿金
            ,pre_pay_rate -- 提前还本的补偿金率
            ,ui_min_amt -- 折扣贷款提前还款最低罚金
            ,ui_prepayment -- 折扣贷款提前还款罚率
            ,grace_int_flag -- 是否宽限利息
            ,grace_pri_flag -- 是否宽限本金
            ,auto_settle_sod_int_flag -- 是否日起自动结算利息
            ,auto_settle_sod_pri_flag -- 是否日起自动结算本金
            ,before_income_flag -- 是否前收息标志
            ,grace_charge_odi_flag -- 到期利息在宽限期是否收复利
            ,compensate_ratio -- 理赔比例
            ,cross_period_flag -- 跨月/季标志
            ,due_compensate_period -- 逾期理赔天数
            ,receive_anytime_flag -- 是否随还标志
            ,corp_size -- 企业规模
            ,gear_prod_flag -- 是否靠档计息标志
            ,econ_department_type -- 国民经济部门类型
            ,is_individual_busi -- 是否个体工商户
            ,amount_nature -- 资金性质|法人透支使用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_loan_op(
            grace_term_type -- 宽限期次类型
            ,acct_name -- 账户名称
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_short -- 客户简称
            ,contract_no -- 合同编号
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,acct_status_prev -- 账户上一状态
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,analysis1 -- 统计标志1
            ,analysis2 -- 统计标志2
            ,analysis3 -- 统计标志3
            ,anytime_rec_flag -- 随借随还标志
            ,arr_bank -- 银团贷款安排行
            ,auto_loan_classify_flag -- 自动更改状态标记
            ,auto_settle_flag -- 自动结清标志
            ,buy_bank -- 买入银行
            ,calc_times -- 气球贷计算期次
            ,company -- 法人
            ,credit_no -- 贷款项目号
            ,dd_inc_ind -- 增量发放标志
            ,entrust_settle_flag -- 委托贷款结算标志
            ,five_category -- 贷款五级分类
            ,force_grace_flag -- 宽限期遇节假日是否顺延
            ,grace_charge_int_flag -- 到期本金在宽限期是否收息
            ,grace_type -- 宽限期类型
            ,guaranty_style -- 担保方式
            ,int_penalty -- 是否收取复利
            ,lender -- 贷款人
            ,loan_class -- 贷款类别
            ,manager_bank -- 银团贷款管理行
            ,marketing_prod_desc -- 营销产品名称
            ,max_extend_times -- 最大展期次数
            ,od_int_penalty_flag -- 是否收取复利的复利
            ,od_pri_penalty_flag -- 是否收取罚息的复利
            ,old_loan_no -- 原贷款号
            ,pause_int_ind -- 贷款停息标志
            ,pre_rate_type -- 提前还款费用类型
            ,pre_repay_deal -- 还款计划变更方式
            ,pri_penalty_flag -- 是否收取罚息
            ,purpose -- 贷款用途
            ,recourse_ind -- 追索标记
            ,related_loan_no -- 关联贷款号
            ,sched_mode -- 还款方式
            ,sof_state -- 资金来源省
            ,sold_ind -- 卖出标记
            ,stamp_tax_flag -- 贷款印花税
            ,syn_dd_times -- 银团贷款发放次数
            ,sync_final_billing_flag -- 是否利随本清标志
            ,taxable_ind -- 收税标志
            ,tf_loan_type -- tf贷款类型
            ,tf_ref_no -- 国结参考号
            ,trade_ref_no -- 贸易参考号
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,loan_status -- 贷款账户状态
            ,hunting_status -- 持续扣款标志
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,closed_date -- 关闭日期
            ,dd_end_date -- 发放截止日期
            ,last_change_date -- 最后修改日期
            ,maturity_date -- 到期日期
            ,sign_date -- 签约日期
            ,special_sign_date -- 特色产品签约日期
            ,ssi_end_date -- 贴息截止日期
            ,tran_timestamp -- 交易时间戳
            ,sof_country -- 资金来源国家
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,close_reason -- 注销原因
            ,commit_amt -- 承诺额
            ,contribute_amt -- 参与行出资金额
            ,grace_period -- 宽限期的天数
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,od_grace_period_days -- 免息期天数
            ,orig_loan_amt -- 贷款签约合同金额
            ,pr_min_amt -- 提前还款最低补偿金
            ,pre_pay_rate -- 提前还本的补偿金率
            ,ui_min_amt -- 折扣贷款提前还款最低罚金
            ,ui_prepayment -- 折扣贷款提前还款罚率
            ,grace_int_flag -- 是否宽限利息
            ,grace_pri_flag -- 是否宽限本金
            ,auto_settle_sod_int_flag -- 是否日起自动结算利息
            ,auto_settle_sod_pri_flag -- 是否日起自动结算本金
            ,before_income_flag -- 是否前收息标志
            ,grace_charge_odi_flag -- 到期利息在宽限期是否收复利
            ,compensate_ratio -- 理赔比例
            ,cross_period_flag -- 跨月/季标志
            ,due_compensate_period -- 逾期理赔天数
            ,receive_anytime_flag -- 是否随还标志
            ,corp_size -- 企业规模
            ,gear_prod_flag -- 是否靠档计息标志
            ,econ_department_type -- 国民经济部门类型
            ,is_individual_busi -- 是否个体工商户
            ,amount_nature -- 资金性质|法人透支使用
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grace_term_type -- 宽限期次类型
    ,o.acct_name -- 账户名称
    ,o.branch -- 机构编号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.client_short -- 客户简称
    ,o.contract_no -- 合同编号
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.acct_status_prev -- 账户上一状态
    ,o.alloc_seq_fee -- 贷款费用还款顺序
    ,o.alloc_seq_int -- 贷款利息还款顺序
    ,o.alloc_seq_odi -- 贷款复利还款顺序
    ,o.alloc_seq_odp -- 贷款罚息还款顺序
    ,o.alloc_seq_pri -- 贷款本金还款顺序
    ,o.alloc_seq_type -- 贷款自动还款类型
    ,o.analysis1 -- 统计标志1
    ,o.analysis2 -- 统计标志2
    ,o.analysis3 -- 统计标志3
    ,o.anytime_rec_flag -- 随借随还标志
    ,o.arr_bank -- 银团贷款安排行
    ,o.auto_loan_classify_flag -- 自动更改状态标记
    ,o.auto_settle_flag -- 自动结清标志
    ,o.buy_bank -- 买入银行
    ,o.calc_times -- 气球贷计算期次
    ,o.company -- 法人
    ,o.credit_no -- 贷款项目号
    ,o.dd_inc_ind -- 增量发放标志
    ,o.entrust_settle_flag -- 委托贷款结算标志
    ,o.five_category -- 贷款五级分类
    ,o.force_grace_flag -- 宽限期遇节假日是否顺延
    ,o.grace_charge_int_flag -- 到期本金在宽限期是否收息
    ,o.grace_type -- 宽限期类型
    ,o.guaranty_style -- 担保方式
    ,o.int_penalty -- 是否收取复利
    ,o.lender -- 贷款人
    ,o.loan_class -- 贷款类别
    ,o.manager_bank -- 银团贷款管理行
    ,o.marketing_prod_desc -- 营销产品名称
    ,o.max_extend_times -- 最大展期次数
    ,o.od_int_penalty_flag -- 是否收取复利的复利
    ,o.od_pri_penalty_flag -- 是否收取罚息的复利
    ,o.old_loan_no -- 原贷款号
    ,o.pause_int_ind -- 贷款停息标志
    ,o.pre_rate_type -- 提前还款费用类型
    ,o.pre_repay_deal -- 还款计划变更方式
    ,o.pri_penalty_flag -- 是否收取罚息
    ,o.purpose -- 贷款用途
    ,o.recourse_ind -- 追索标记
    ,o.related_loan_no -- 关联贷款号
    ,o.sched_mode -- 还款方式
    ,o.sof_state -- 资金来源省
    ,o.sold_ind -- 卖出标记
    ,o.stamp_tax_flag -- 贷款印花税
    ,o.syn_dd_times -- 银团贷款发放次数
    ,o.sync_final_billing_flag -- 是否利随本清标志
    ,o.taxable_ind -- 收税标志
    ,o.tf_loan_type -- tf贷款类型
    ,o.tf_ref_no -- 国结参考号
    ,o.trade_ref_no -- 贸易参考号
    ,o.accounting_status -- 核算状态
    ,o.accounting_status_prev -- 上次核算状态
    ,o.loan_status -- 贷款账户状态
    ,o.hunting_status -- 持续扣款标志
    ,o.accounting_status_upd_date -- 核算状态变更日期
    ,o.acct_status_upd_date -- 账户状态变更日期
    ,o.closed_date -- 关闭日期
    ,o.dd_end_date -- 发放截止日期
    ,o.last_change_date -- 最后修改日期
    ,o.maturity_date -- 到期日期
    ,o.sign_date -- 签约日期
    ,o.special_sign_date -- 特色产品签约日期
    ,o.ssi_end_date -- 贴息截止日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.sof_country -- 资金来源国家
    ,o.acct_close_reason -- 关闭原因
    ,o.acct_close_user_id -- 账户销户操作柜员
    ,o.close_reason -- 注销原因
    ,o.commit_amt -- 承诺额
    ,o.contribute_amt -- 参与行出资金额
    ,o.grace_period -- 宽限期的天数
    ,o.last_change_user_id -- 最后修改柜员
    ,o.loan_no -- 贷款号
    ,o.marketing_prod -- 营销产品
    ,o.od_grace_period_days -- 免息期天数
    ,o.orig_loan_amt -- 贷款签约合同金额
    ,o.pr_min_amt -- 提前还款最低补偿金
    ,o.pre_pay_rate -- 提前还本的补偿金率
    ,o.ui_min_amt -- 折扣贷款提前还款最低罚金
    ,o.ui_prepayment -- 折扣贷款提前还款罚率
    ,o.grace_int_flag -- 是否宽限利息
    ,o.grace_pri_flag -- 是否宽限本金
    ,o.auto_settle_sod_int_flag -- 是否日起自动结算利息
    ,o.auto_settle_sod_pri_flag -- 是否日起自动结算本金
    ,o.before_income_flag -- 是否前收息标志
    ,o.grace_charge_odi_flag -- 到期利息在宽限期是否收复利
    ,o.compensate_ratio -- 理赔比例
    ,o.cross_period_flag -- 跨月/季标志
    ,o.due_compensate_period -- 逾期理赔天数
    ,o.receive_anytime_flag -- 是否随还标志
    ,o.corp_size -- 企业规模
    ,o.gear_prod_flag -- 是否靠档计息标志
    ,o.econ_department_type -- 国民经济部门类型
    ,o.is_individual_busi -- 是否个体工商户
    ,o.amount_nature -- 资金性质|法人透支使用
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
from ${iol_schema}.ncbs_cl_loan_bk o
    left join ${iol_schema}.ncbs_cl_loan_op n
        on
            o.loan_no = n.loan_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_loan_cl d
        on
            o.loan_no = d.loan_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_loan exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_loan_cl;
alter table ${iol_schema}.ncbs_cl_loan exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_loan_op purge;
drop table ${iol_schema}.ncbs_cl_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
