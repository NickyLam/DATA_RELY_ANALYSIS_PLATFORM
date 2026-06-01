/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_loan
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_loan(
    grace_term_type varchar2(1) -- 宽限期次类型
    ,acct_name varchar2(200) -- 账户名称
    ,branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,client_short varchar2(150) -- 客户简称
    ,contract_no varchar2(30) -- 合同编号
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_status_prev varchar2(1) -- 账户上一状态
    ,alloc_seq_fee varchar2(1) -- 贷款费用还款顺序
    ,alloc_seq_int varchar2(1) -- 贷款利息还款顺序
    ,alloc_seq_odi varchar2(1) -- 贷款复利还款顺序
    ,alloc_seq_odp varchar2(1) -- 贷款罚息还款顺序
    ,alloc_seq_pri varchar2(1) -- 贷款本金还款顺序
    ,alloc_seq_type varchar2(1) -- 贷款自动还款类型
    ,analysis1 varchar2(10) -- 统计标志1
    ,analysis2 varchar2(10) -- 统计标志2
    ,analysis3 varchar2(10) -- 统计标志3
    ,anytime_rec_flag varchar2(1) -- 随借随还标志
    ,arr_bank varchar2(20) -- 银团贷款安排行
    ,auto_loan_classify_flag varchar2(1) -- 自动更改状态标记
    ,auto_settle_flag varchar2(1) -- 自动结清标志
    ,buy_bank varchar2(20) -- 买入银行
    ,calc_times number(5) -- 气球贷计算期次
    ,company varchar2(20) -- 法人
    ,credit_no varchar2(50) -- 贷款项目号
    ,dd_inc_ind varchar2(1) -- 增量发放标志
    ,entrust_settle_flag varchar2(2) -- 委托贷款结算标志
    ,five_category varchar2(2) -- 贷款五级分类
    ,force_grace_flag varchar2(1) -- 宽限期遇节假日是否顺延
    ,grace_charge_int_flag varchar2(1) -- 到期本金在宽限期是否收息
    ,grace_type varchar2(3) -- 宽限期类型
    ,guaranty_style varchar2(5) -- 担保方式
    ,int_penalty varchar2(1) -- 是否收取复利
    ,lender varchar2(100) -- 贷款人
    ,loan_class varchar2(20) -- 贷款类别
    ,manager_bank varchar2(20) -- 银团贷款管理行
    ,marketing_prod_desc varchar2(500) -- 营销产品名称
    ,max_extend_times number(5) -- 最大展期次数
    ,od_int_penalty_flag varchar2(1) -- 是否收取复利的复利
    ,od_pri_penalty_flag varchar2(1) -- 是否收取罚息的复利
    ,old_loan_no varchar2(50) -- 原贷款号
    ,pause_int_ind varchar2(1) -- 贷款停息标志
    ,pre_rate_type varchar2(3) -- 提前还款费用类型
    ,pre_repay_deal varchar2(1) -- 还款计划变更方式
    ,pri_penalty_flag varchar2(1) -- 是否收取罚息
    ,purpose varchar2(6) -- 贷款用途
    ,recourse_ind varchar2(1) -- 追索标记
    ,related_loan_no varchar2(50) -- 关联贷款号
    ,sched_mode varchar2(2) -- 还款方式
    ,sof_state varchar2(200) -- 资金来源省
    ,sold_ind varchar2(1) -- 卖出标记
    ,stamp_tax_flag varchar2(1) -- 贷款印花税
    ,syn_dd_times number(5) -- 银团贷款发放次数
    ,sync_final_billing_flag varchar2(1) -- 是否利随本清标志
    ,taxable_ind varchar2(1) -- 收税标志
    ,tf_loan_type varchar2(50) -- tf贷款类型
    ,tf_ref_no varchar2(50) -- 国结参考号
    ,trade_ref_no varchar2(50) -- 贸易参考号
    ,accounting_status varchar2(3) -- 核算状态
    ,accounting_status_prev varchar2(3) -- 上次核算状态
    ,loan_status varchar2(1) -- 贷款账户状态
    ,hunting_status varchar2(1) -- 持续扣款标志
    ,accounting_status_upd_date date -- 核算状态变更日期
    ,acct_status_upd_date date -- 账户状态变更日期
    ,closed_date date -- 关闭日期
    ,dd_end_date date -- 发放截止日期
    ,last_change_date date -- 最后修改日期
    ,maturity_date date -- 到期日期
    ,sign_date date -- 签约日期
    ,special_sign_date date -- 特色产品签约日期
    ,ssi_end_date date -- 贴息截止日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,sof_country varchar2(3) -- 资金来源国家
    ,acct_close_reason varchar2(300) -- 关闭原因
    ,acct_close_user_id varchar2(8) -- 账户销户操作柜员
    ,close_reason varchar2(200) -- 注销原因
    ,commit_amt number(17,2) -- 承诺额
    ,contribute_amt number(17,2) -- 参与行出资金额
    ,grace_period number(5) -- 宽限期的天数
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,loan_no varchar2(50) -- 贷款号
    ,marketing_prod varchar2(12) -- 营销产品
    ,od_grace_period_days number(5) -- 免息期天数
    ,orig_loan_amt number(17,2) -- 贷款签约合同金额
    ,pr_min_amt number(17,2) -- 提前还款最低补偿金
    ,pre_pay_rate number(15,8) -- 提前还本的补偿金率
    ,ui_min_amt number(17,2) -- 折扣贷款提前还款最低罚金
    ,ui_prepayment number(15,8) -- 折扣贷款提前还款罚率
    ,grace_int_flag varchar2(1) -- 是否宽限利息
    ,grace_pri_flag varchar2(1) -- 是否宽限本金
    ,auto_settle_sod_int_flag varchar2(1) -- 是否日起自动结算利息
    ,auto_settle_sod_pri_flag varchar2(1) -- 是否日起自动结算本金
    ,before_income_flag varchar2(1) -- 是否前收息标志
    ,grace_charge_odi_flag varchar2(1) -- 到期利息在宽限期是否收复利
    ,compensate_ratio number(5,2) -- 理赔比例
    ,cross_period_flag varchar2(1) -- 跨月/季标志
    ,due_compensate_period number(5) -- 逾期理赔天数
    ,receive_anytime_flag varchar2(1) -- 是否随还标志
    ,corp_size varchar2(5) -- 企业规模
    ,gear_prod_flag varchar2(1) -- 是否靠档计息标志
    ,econ_department_type varchar2(200) -- 国民经济部门类型
    ,is_individual_busi varchar2(5) -- 是否个体工商户
    ,amount_nature varchar2(10) -- 资金性质|法人透支使用
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_cl_loan to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_loan to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_loan to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_loan is '贷款合同表';
comment on column ${iol_schema}.ncbs_cl_loan.grace_term_type is '宽限期次类型';
comment on column ${iol_schema}.ncbs_cl_loan.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_cl_loan.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_loan.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_loan.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_loan.client_short is '客户简称';
comment on column ${iol_schema}.ncbs_cl_loan.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_cl_loan.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_loan.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_loan.acct_status_prev is '账户上一状态';
comment on column ${iol_schema}.ncbs_cl_loan.alloc_seq_fee is '贷款费用还款顺序';
comment on column ${iol_schema}.ncbs_cl_loan.alloc_seq_int is '贷款利息还款顺序';
comment on column ${iol_schema}.ncbs_cl_loan.alloc_seq_odi is '贷款复利还款顺序';
comment on column ${iol_schema}.ncbs_cl_loan.alloc_seq_odp is '贷款罚息还款顺序';
comment on column ${iol_schema}.ncbs_cl_loan.alloc_seq_pri is '贷款本金还款顺序';
comment on column ${iol_schema}.ncbs_cl_loan.alloc_seq_type is '贷款自动还款类型';
comment on column ${iol_schema}.ncbs_cl_loan.analysis1 is '统计标志1';
comment on column ${iol_schema}.ncbs_cl_loan.analysis2 is '统计标志2';
comment on column ${iol_schema}.ncbs_cl_loan.analysis3 is '统计标志3';
comment on column ${iol_schema}.ncbs_cl_loan.anytime_rec_flag is '随借随还标志';
comment on column ${iol_schema}.ncbs_cl_loan.arr_bank is '银团贷款安排行';
comment on column ${iol_schema}.ncbs_cl_loan.auto_loan_classify_flag is '自动更改状态标记';
comment on column ${iol_schema}.ncbs_cl_loan.auto_settle_flag is '自动结清标志';
comment on column ${iol_schema}.ncbs_cl_loan.buy_bank is '买入银行';
comment on column ${iol_schema}.ncbs_cl_loan.calc_times is '气球贷计算期次';
comment on column ${iol_schema}.ncbs_cl_loan.company is '法人';
comment on column ${iol_schema}.ncbs_cl_loan.credit_no is '贷款项目号';
comment on column ${iol_schema}.ncbs_cl_loan.dd_inc_ind is '增量发放标志';
comment on column ${iol_schema}.ncbs_cl_loan.entrust_settle_flag is '委托贷款结算标志';
comment on column ${iol_schema}.ncbs_cl_loan.five_category is '贷款五级分类';
comment on column ${iol_schema}.ncbs_cl_loan.force_grace_flag is '宽限期遇节假日是否顺延';
comment on column ${iol_schema}.ncbs_cl_loan.grace_charge_int_flag is '到期本金在宽限期是否收息';
comment on column ${iol_schema}.ncbs_cl_loan.grace_type is '宽限期类型';
comment on column ${iol_schema}.ncbs_cl_loan.guaranty_style is '担保方式';
comment on column ${iol_schema}.ncbs_cl_loan.int_penalty is '是否收取复利';
comment on column ${iol_schema}.ncbs_cl_loan.lender is '贷款人';
comment on column ${iol_schema}.ncbs_cl_loan.loan_class is '贷款类别';
comment on column ${iol_schema}.ncbs_cl_loan.manager_bank is '银团贷款管理行';
comment on column ${iol_schema}.ncbs_cl_loan.marketing_prod_desc is '营销产品名称';
comment on column ${iol_schema}.ncbs_cl_loan.max_extend_times is '最大展期次数';
comment on column ${iol_schema}.ncbs_cl_loan.od_int_penalty_flag is '是否收取复利的复利';
comment on column ${iol_schema}.ncbs_cl_loan.od_pri_penalty_flag is '是否收取罚息的复利';
comment on column ${iol_schema}.ncbs_cl_loan.old_loan_no is '原贷款号';
comment on column ${iol_schema}.ncbs_cl_loan.pause_int_ind is '贷款停息标志';
comment on column ${iol_schema}.ncbs_cl_loan.pre_rate_type is '提前还款费用类型';
comment on column ${iol_schema}.ncbs_cl_loan.pre_repay_deal is '还款计划变更方式';
comment on column ${iol_schema}.ncbs_cl_loan.pri_penalty_flag is '是否收取罚息';
comment on column ${iol_schema}.ncbs_cl_loan.purpose is '贷款用途';
comment on column ${iol_schema}.ncbs_cl_loan.recourse_ind is '追索标记';
comment on column ${iol_schema}.ncbs_cl_loan.related_loan_no is '关联贷款号';
comment on column ${iol_schema}.ncbs_cl_loan.sched_mode is '还款方式';
comment on column ${iol_schema}.ncbs_cl_loan.sof_state is '资金来源省';
comment on column ${iol_schema}.ncbs_cl_loan.sold_ind is '卖出标记';
comment on column ${iol_schema}.ncbs_cl_loan.stamp_tax_flag is '贷款印花税';
comment on column ${iol_schema}.ncbs_cl_loan.syn_dd_times is '银团贷款发放次数';
comment on column ${iol_schema}.ncbs_cl_loan.sync_final_billing_flag is '是否利随本清标志';
comment on column ${iol_schema}.ncbs_cl_loan.taxable_ind is '收税标志';
comment on column ${iol_schema}.ncbs_cl_loan.tf_loan_type is 'tf贷款类型';
comment on column ${iol_schema}.ncbs_cl_loan.tf_ref_no is '国结参考号';
comment on column ${iol_schema}.ncbs_cl_loan.trade_ref_no is '贸易参考号';
comment on column ${iol_schema}.ncbs_cl_loan.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_loan.accounting_status_prev is '上次核算状态';
comment on column ${iol_schema}.ncbs_cl_loan.loan_status is '贷款账户状态';
comment on column ${iol_schema}.ncbs_cl_loan.hunting_status is '持续扣款标志';
comment on column ${iol_schema}.ncbs_cl_loan.accounting_status_upd_date is '核算状态变更日期';
comment on column ${iol_schema}.ncbs_cl_loan.acct_status_upd_date is '账户状态变更日期';
comment on column ${iol_schema}.ncbs_cl_loan.closed_date is '关闭日期';
comment on column ${iol_schema}.ncbs_cl_loan.dd_end_date is '发放截止日期';
comment on column ${iol_schema}.ncbs_cl_loan.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_loan.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_cl_loan.sign_date is '签约日期';
comment on column ${iol_schema}.ncbs_cl_loan.special_sign_date is '特色产品签约日期';
comment on column ${iol_schema}.ncbs_cl_loan.ssi_end_date is '贴息截止日期';
comment on column ${iol_schema}.ncbs_cl_loan.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_loan.sof_country is '资金来源国家';
comment on column ${iol_schema}.ncbs_cl_loan.acct_close_reason is '关闭原因';
comment on column ${iol_schema}.ncbs_cl_loan.acct_close_user_id is '账户销户操作柜员';
comment on column ${iol_schema}.ncbs_cl_loan.close_reason is '注销原因';
comment on column ${iol_schema}.ncbs_cl_loan.commit_amt is '承诺额';
comment on column ${iol_schema}.ncbs_cl_loan.contribute_amt is '参与行出资金额';
comment on column ${iol_schema}.ncbs_cl_loan.grace_period is '宽限期的天数';
comment on column ${iol_schema}.ncbs_cl_loan.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_loan.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_loan.marketing_prod is '营销产品';
comment on column ${iol_schema}.ncbs_cl_loan.od_grace_period_days is '免息期天数';
comment on column ${iol_schema}.ncbs_cl_loan.orig_loan_amt is '贷款签约合同金额';
comment on column ${iol_schema}.ncbs_cl_loan.pr_min_amt is '提前还款最低补偿金';
comment on column ${iol_schema}.ncbs_cl_loan.pre_pay_rate is '提前还本的补偿金率';
comment on column ${iol_schema}.ncbs_cl_loan.ui_min_amt is '折扣贷款提前还款最低罚金';
comment on column ${iol_schema}.ncbs_cl_loan.ui_prepayment is '折扣贷款提前还款罚率';
comment on column ${iol_schema}.ncbs_cl_loan.grace_int_flag is '是否宽限利息';
comment on column ${iol_schema}.ncbs_cl_loan.grace_pri_flag is '是否宽限本金';
comment on column ${iol_schema}.ncbs_cl_loan.auto_settle_sod_int_flag is '是否日起自动结算利息';
comment on column ${iol_schema}.ncbs_cl_loan.auto_settle_sod_pri_flag is '是否日起自动结算本金';
comment on column ${iol_schema}.ncbs_cl_loan.before_income_flag is '是否前收息标志';
comment on column ${iol_schema}.ncbs_cl_loan.grace_charge_odi_flag is '到期利息在宽限期是否收复利';
comment on column ${iol_schema}.ncbs_cl_loan.compensate_ratio is '理赔比例';
comment on column ${iol_schema}.ncbs_cl_loan.cross_period_flag is '跨月/季标志';
comment on column ${iol_schema}.ncbs_cl_loan.due_compensate_period is '逾期理赔天数';
comment on column ${iol_schema}.ncbs_cl_loan.receive_anytime_flag is '是否随还标志';
comment on column ${iol_schema}.ncbs_cl_loan.corp_size is '企业规模';
comment on column ${iol_schema}.ncbs_cl_loan.gear_prod_flag is '是否靠档计息标志';
comment on column ${iol_schema}.ncbs_cl_loan.econ_department_type is '国民经济部门类型';
comment on column ${iol_schema}.ncbs_cl_loan.is_individual_busi is '是否个体工商户';
comment on column ${iol_schema}.ncbs_cl_loan.amount_nature is '资金性质|法人透支使用';
comment on column ${iol_schema}.ncbs_cl_loan.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_loan.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_loan.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_loan.etl_timestamp is 'ETL处理时间戳';
