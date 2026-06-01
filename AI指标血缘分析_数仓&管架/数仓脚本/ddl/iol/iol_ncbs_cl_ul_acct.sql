/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_ul_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_ul_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_ul_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_ul_acct(
    internal_key number(15,0) -- 账户内部键值
    ,cmisloan_no varchar2(30) -- 客户借据编号
    ,loan_no varchar2(50) -- 贷款号
    ,prod_type varchar2(12) -- 产品编号
    ,ccy varchar2(3) -- 币种
    ,contract_no varchar2(30) -- 合同编号
    ,branch varchar2(12) -- 交易机构编号
    ,in_balance_flag varchar2(1) -- 应计标识
    ,amortize_flag varchar2(1) -- 摊销标识
    ,extend_flag varchar2(1) -- 展期标识
    ,asset_security_status varchar2(1) -- 资产证券化状态
    ,asset_transfer_status varchar2(1) -- 资产转让状态
    ,charge_int_flag varchar2(1) -- 预收息标识
    ,acct_status varchar2(1) -- 账户状态
    ,amortize_frequency varchar2(1) -- 摊销频度
    ,calc_begin_date date -- 利息计算起始日
    ,next_cycle_date date -- 下一结息日
    ,int_ind_flag varchar2(1) -- 计息标识
    ,client_no varchar2(16) -- 客户编号
    ,client_name varchar2(200) -- 客户名称
    ,five_category varchar2(2) -- 贷款五级分类
    ,pre_loan_fee number(17,2) -- 贷前费用
    ,effect_date date -- 产品生效日期
    ,actual_dd_amt number(17,2) -- 实际发放金额
    ,dd_amt number(17,2) -- 发放金额
    ,maturity_date date -- 到期日期
    ,ori_maturity_date date -- 账户原始到期日期
    ,due_days number(5,0) -- 贷款逾期天数（不考虑宽限期）
    ,int_due_days number(5,0) -- 利息逾期天数（考虑宽限期）
    ,pri_due_days number(5,0) -- 本金逾期天数（考虑宽限期）
    ,normal_rate number(15,8) -- 正常利率
    ,normal_rate_period varchar2(1) -- 正常利率周期
    ,past_due_rate number(15,8) -- 逾期利率
    ,odp_rate_period varchar2(1) -- 逾期利率周期
    ,odi_rate number(15,8) -- 贷款复利利率
    ,odi_rate_period varchar2(1) -- 复利利率周期
    ,grace_rate number(15,8) -- 宽限期利率
    ,grace_rate_period varchar2(1) -- 宽限期利率周期
    ,osl_amt number(17,2) -- 客户未到期本金
    ,prd_amt number(17,2) -- 逾期本金
    ,acct_int number(17,2) -- 账户利息
    ,odp_amt number(17,2) -- 罚息金额
    ,intp_amt number(17,2) -- 逾期利息
    ,odi_amt number(17,2) -- 复利金额
    ,odpp_amt number(17,2) -- 逾期罚息余额
    ,ododp_amt number(17,2) -- 罚息的复利
    ,odi_past_due number(17,2) -- 逾期复利
    ,before_income_amt number(17,2) -- 前收息金额
    ,amt_type_two varchar2(10) -- 金额类型2
    ,amt_type_three varchar2(10) -- 金额类型3
    ,amt_type_for varchar2(10) -- 金额类型4
    ,amt_type_five varchar2(10) -- 金额类型5
    ,amt_type_six varchar2(10) -- 金额类型6
    ,contract_amt number(17,2) -- 合同金额
    ,attach_info_one varchar2(200) -- 附属信息1
    ,attach_info_two varchar2(200) -- 附属信息2
    ,attach_info_three varchar2(200) -- 附属信息3
    ,loan_amt number(17,2) -- 贷款余额
    ,is_first_dd varchar2(1) -- 是否首次发放
    ,revolve_flag varchar2(1) -- 循环贷款标志
    ,econ_department_type varchar2(200) -- 国民经济部门类型
    ,lg_amt number(17,2) -- 保函金额
    ,belong_abs_int_amt number(17,2) -- 归属券商利息
    ,belong_abs_odp_amt number(17,2) -- 归属券商罚息
    ,belong_abs_odi_amt number(17,2) -- 归属券商复利
    ,abs_int_amt number(17,2) -- 资产证券化利息
    ,abs_odp_amt number(17,2) -- 资产证券化罚息
    ,abs_odi_amt number(17,2) -- 资产证券化复利
    ,abs_intp_amt number(17,2) -- 资产证券化逾期利息
    ,abs_odpp_amt number(17,2) -- 资产证券化逾期罚息
    ,abs_odip_amt number(17,2) -- 资产证券化逾期复利
    ,inner_bank_transfer_premium number(17,2) -- 行内转让溢价
    ,inner_bank_transfer_discount number(17,2) -- 行内转让折价
    ,out_bank_transfer_premium number(17,2) -- 行外转让溢价
    ,out_bank_transfer_discount varchar2(10) -- 行外转让折价
    ,balance number(17,2) -- 余额
    ,year_basis varchar2(3) -- 年基准天数
    ,client_type varchar2(3) -- 客户类型
    ,accounting_status varchar2(3) -- 核算状态
    ,timestamp varchar2(26) -- 时间戳
    ,last_update_date date -- 上次更新日期
    ,reversal_date date -- 冲正日期
    ,closed_date date -- 关闭日期
    ,stage_no number(5,0) -- 期次
    ,dd_no number(5,0) -- 发放号
    ,reversal varchar2(1) -- 是否冲正标志
    ,sell_clear_int_amt number(17,2) -- 已结转利息
    ,sell_clear_odp_amt number(17,2) -- 已结转罚息
    ,sell_clear_odi_amt number(17,2) -- 已结转复息
    ,busilicence_name varchar2(200) -- 营业执照名称
    ,merchant_name varchar2(200) -- 商户名称
    ,ododi_amt number(17,2) -- 复利的复利
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
grant select on ${iol_schema}.ncbs_cl_ul_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_ul_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_ul_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_ul_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_ul_acct is '联合贷账户基本信息表';
comment on column ${iol_schema}.ncbs_cl_ul_acct.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_ul_acct.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_cl_ul_acct.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_ul_acct.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_ul_acct.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_ul_acct.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_cl_ul_acct.branch is '交易机构编号';
comment on column ${iol_schema}.ncbs_cl_ul_acct.in_balance_flag is '应计标识';
comment on column ${iol_schema}.ncbs_cl_ul_acct.amortize_flag is '摊销标识';
comment on column ${iol_schema}.ncbs_cl_ul_acct.extend_flag is '展期标识';
comment on column ${iol_schema}.ncbs_cl_ul_acct.asset_security_status is '资产证券化状态';
comment on column ${iol_schema}.ncbs_cl_ul_acct.asset_transfer_status is '资产转让状态';
comment on column ${iol_schema}.ncbs_cl_ul_acct.charge_int_flag is '预收息标识';
comment on column ${iol_schema}.ncbs_cl_ul_acct.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_cl_ul_acct.amortize_frequency is '摊销频度';
comment on column ${iol_schema}.ncbs_cl_ul_acct.calc_begin_date is '利息计算起始日';
comment on column ${iol_schema}.ncbs_cl_ul_acct.next_cycle_date is '下一结息日';
comment on column ${iol_schema}.ncbs_cl_ul_acct.int_ind_flag is '计息标识';
comment on column ${iol_schema}.ncbs_cl_ul_acct.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_ul_acct.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_cl_ul_acct.five_category is '贷款五级分类';
comment on column ${iol_schema}.ncbs_cl_ul_acct.pre_loan_fee is '贷前费用';
comment on column ${iol_schema}.ncbs_cl_ul_acct.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_cl_ul_acct.actual_dd_amt is '实际发放金额';
comment on column ${iol_schema}.ncbs_cl_ul_acct.dd_amt is '发放金额';
comment on column ${iol_schema}.ncbs_cl_ul_acct.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_cl_ul_acct.ori_maturity_date is '账户原始到期日期';
comment on column ${iol_schema}.ncbs_cl_ul_acct.due_days is '贷款逾期天数（不考虑宽限期）';
comment on column ${iol_schema}.ncbs_cl_ul_acct.int_due_days is '利息逾期天数（考虑宽限期）';
comment on column ${iol_schema}.ncbs_cl_ul_acct.pri_due_days is '本金逾期天数（考虑宽限期）';
comment on column ${iol_schema}.ncbs_cl_ul_acct.normal_rate is '正常利率';
comment on column ${iol_schema}.ncbs_cl_ul_acct.normal_rate_period is '正常利率周期';
comment on column ${iol_schema}.ncbs_cl_ul_acct.past_due_rate is '逾期利率';
comment on column ${iol_schema}.ncbs_cl_ul_acct.odp_rate_period is '逾期利率周期';
comment on column ${iol_schema}.ncbs_cl_ul_acct.odi_rate is '贷款复利利率';
comment on column ${iol_schema}.ncbs_cl_ul_acct.odi_rate_period is '复利利率周期';
comment on column ${iol_schema}.ncbs_cl_ul_acct.grace_rate is '宽限期利率';
comment on column ${iol_schema}.ncbs_cl_ul_acct.grace_rate_period is '宽限期利率周期';
comment on column ${iol_schema}.ncbs_cl_ul_acct.osl_amt is '客户未到期本金';
comment on column ${iol_schema}.ncbs_cl_ul_acct.prd_amt is '逾期本金';
comment on column ${iol_schema}.ncbs_cl_ul_acct.acct_int is '账户利息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.odp_amt is '罚息金额';
comment on column ${iol_schema}.ncbs_cl_ul_acct.intp_amt is '逾期利息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.odi_amt is '复利金额';
comment on column ${iol_schema}.ncbs_cl_ul_acct.odpp_amt is '逾期罚息余额';
comment on column ${iol_schema}.ncbs_cl_ul_acct.ododp_amt is '罚息的复利';
comment on column ${iol_schema}.ncbs_cl_ul_acct.odi_past_due is '逾期复利';
comment on column ${iol_schema}.ncbs_cl_ul_acct.before_income_amt is '前收息金额';
comment on column ${iol_schema}.ncbs_cl_ul_acct.amt_type_two is '金额类型2';
comment on column ${iol_schema}.ncbs_cl_ul_acct.amt_type_three is '金额类型3';
comment on column ${iol_schema}.ncbs_cl_ul_acct.amt_type_for is '金额类型4';
comment on column ${iol_schema}.ncbs_cl_ul_acct.amt_type_five is '金额类型5';
comment on column ${iol_schema}.ncbs_cl_ul_acct.amt_type_six is '金额类型6';
comment on column ${iol_schema}.ncbs_cl_ul_acct.contract_amt is '合同金额';
comment on column ${iol_schema}.ncbs_cl_ul_acct.attach_info_one is '附属信息1';
comment on column ${iol_schema}.ncbs_cl_ul_acct.attach_info_two is '附属信息2';
comment on column ${iol_schema}.ncbs_cl_ul_acct.attach_info_three is '附属信息3';
comment on column ${iol_schema}.ncbs_cl_ul_acct.loan_amt is '贷款余额';
comment on column ${iol_schema}.ncbs_cl_ul_acct.is_first_dd is '是否首次发放';
comment on column ${iol_schema}.ncbs_cl_ul_acct.revolve_flag is '循环贷款标志';
comment on column ${iol_schema}.ncbs_cl_ul_acct.econ_department_type is '国民经济部门类型';
comment on column ${iol_schema}.ncbs_cl_ul_acct.lg_amt is '保函金额';
comment on column ${iol_schema}.ncbs_cl_ul_acct.belong_abs_int_amt is '归属券商利息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.belong_abs_odp_amt is '归属券商罚息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.belong_abs_odi_amt is '归属券商复利';
comment on column ${iol_schema}.ncbs_cl_ul_acct.abs_int_amt is '资产证券化利息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.abs_odp_amt is '资产证券化罚息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.abs_odi_amt is '资产证券化复利';
comment on column ${iol_schema}.ncbs_cl_ul_acct.abs_intp_amt is '资产证券化逾期利息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.abs_odpp_amt is '资产证券化逾期罚息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.abs_odip_amt is '资产证券化逾期复利';
comment on column ${iol_schema}.ncbs_cl_ul_acct.inner_bank_transfer_premium is '行内转让溢价';
comment on column ${iol_schema}.ncbs_cl_ul_acct.inner_bank_transfer_discount is '行内转让折价';
comment on column ${iol_schema}.ncbs_cl_ul_acct.out_bank_transfer_premium is '行外转让溢价';
comment on column ${iol_schema}.ncbs_cl_ul_acct.out_bank_transfer_discount is '行外转让折价';
comment on column ${iol_schema}.ncbs_cl_ul_acct.balance is '余额';
comment on column ${iol_schema}.ncbs_cl_ul_acct.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_cl_ul_acct.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_cl_ul_acct.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_ul_acct.timestamp is '时间戳';
comment on column ${iol_schema}.ncbs_cl_ul_acct.last_update_date is '上次更新日期';
comment on column ${iol_schema}.ncbs_cl_ul_acct.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_cl_ul_acct.closed_date is '关闭日期';
comment on column ${iol_schema}.ncbs_cl_ul_acct.stage_no is '期次';
comment on column ${iol_schema}.ncbs_cl_ul_acct.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_ul_acct.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_cl_ul_acct.sell_clear_int_amt is '已结转利息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.sell_clear_odp_amt is '已结转罚息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.sell_clear_odi_amt is '已结转复息';
comment on column ${iol_schema}.ncbs_cl_ul_acct.busilicence_name is '营业执照名称';
comment on column ${iol_schema}.ncbs_cl_ul_acct.merchant_name is '商户名称';
comment on column ${iol_schema}.ncbs_cl_ul_acct.ododi_amt is '复利的复利';
comment on column ${iol_schema}.ncbs_cl_ul_acct.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_ul_acct.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_ul_acct.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_ul_acct.etl_timestamp is 'ETL处理时间戳';
