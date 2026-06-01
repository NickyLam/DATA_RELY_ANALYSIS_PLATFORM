/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct(
    od_grace_end_date date -- 免息截止日期
    ,acct_name varchar2(200) -- 账户名称
    ,acct_status varchar2(1) -- 账户状态
    ,acct_type varchar2(1) -- 账户类型
    ,branch varchar2(12) -- 机构编号
    ,business_unit varchar2(10) -- 账套
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,dd_no number(5) -- 发放号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reason_code varchar2(10) -- 账户用途
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,acct_desc varchar2(200) -- 账户描述
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,acct_status_prev varchar2(1) -- 账户上一状态
    ,alloc_seq_fee varchar2(1) -- 贷款费用还款顺序
    ,alloc_seq_int varchar2(1) -- 贷款利息还款顺序
    ,alloc_seq_odi varchar2(1) -- 贷款复利还款顺序
    ,alloc_seq_odp varchar2(1) -- 贷款罚息还款顺序
    ,alloc_seq_pri varchar2(1) -- 贷款本金还款顺序
    ,alloc_seq_type varchar2(1) -- 贷款自动还款类型
    ,appr_flag varchar2(1) -- 复核标志
    ,auto_settle_flag varchar2(1) -- 自动结清标志
    ,bal_type varchar2(2) -- 余额类型
    ,calc_times number(5) -- 气球贷计算期次
    ,cmisloan_no varchar2(64) -- 客户借据编号
    ,company varchar2(20) -- 法人
    ,cur_stage_no number(4) -- 当前期数
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,five_category varchar2(2) -- 贷款五级分类
    ,fta_acct_flag varchar2(1) -- 是否自贸区账户标识
    ,fta_code varchar2(10) -- 自贸区代码
    ,int_ind_flag varchar2(1) -- 是否计息
    ,is_individual varchar2(1) -- 个体客户标志
    ,lender varchar2(100) -- 贷款人
    ,manual_change_schedule_flag varchar2(1) -- 是否需要手工录入还款计划
    ,marketing_prod_desc varchar2(500) -- 营销产品名称
    ,mid_period varchar2(5) -- 累进间隔期数
    ,old_dd_no number(5) -- 原发放号
    ,old_loan_no varchar2(50) -- 原贷款号
    ,osa_flag varchar2(1) -- 离岸标记
    ,other_consumption varchar2(50) -- 其他消费
    ,pay_off_type varchar2(10) -- 贷款销户类型
    ,pre_repay_deal varchar2(1) -- 还款计划变更方式
    ,purpose_id varchar2(50) -- 用途编号
    ,recover_flag varchar2(1) -- 实时追缴标志字段
    ,regen_schedule_flag varchar2(1) -- 重新生成还款计划标志
    ,region_flag varchar2(1) -- 区内区外标记
    ,sched_mode varchar2(2) -- 还款方式
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,sub_project_no varchar2(50) -- 子项目号
    ,sub_sched_mode varchar2(3) -- 当前子计划方式
    ,terminal_id varchar2(50) -- 交易终端编号
    ,accounting_status varchar2(3) -- 核算状态
    ,accounting_status_prev varchar2(3) -- 上次核算状态
    ,accounting_status_upd_date date -- 核算状态变更日期
    ,acct_open_date date -- 账户开户日期
    ,acct_status_upd_date date -- 账户状态变更日期
    ,approval_date date -- 复核日期
    ,closed_date date -- 关闭日期
    ,contraction_date date -- 变期不变额最后变化日期
    ,effect_date date -- 产品生效日期
    ,first_overdue_date date -- 最早逾期日期
    ,last_change_date date -- 最后修改日期
    ,last_tran_date date -- 最后交易日期
    ,maturity_date date -- 到期日期
    ,open_tran_date date -- 开户后首次交易日期
    ,ori_maturity_date date -- 账户原始到期日期
    ,orig_acct_open_date date -- 账户原始开立日期
    ,ssi_end_date date -- 贴息截止日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_close_reason varchar2(300) -- 关闭原因
    ,acct_close_user_id varchar2(8) -- 账户销户操作柜员
    ,add_ratio number(11,7) -- 累进比例
    ,alt_acct_name varchar2(200) -- 备用账户名称
    ,appr_user_id varchar2(8) -- 复核柜员
    ,contributive_ratio number(11,7) -- 出资比例
    ,fir_period varchar2(5) -- 首段期数
    ,formula_amt number(17,2) -- 每期计划还款额
    ,home_branch varchar2(12) -- 客户管理行
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,loan_no varchar2(50) -- 贷款号
    ,marketing_prod varchar2(12) -- 营销产品
    ,old_prod_type varchar2(12) -- 原产品类型
    ,pay_off_reason varchar2(200) -- 贷款销户原因
    ,add_amt number(17,2) -- 累进金额
    ,apply_branch varchar2(12) -- 申请机构
    ,auto_transfer_flag varchar2(1) -- 是否核销后自动转款
    ,sched_assemble_flag varchar2(1) -- 自动组合还款标识
    ,reaccount_cd varchar2(20) -- 对账代码
    ,ext_trade_no varchar2(50) -- 原业务编号
    ,hour_int_rate number(15,8) -- 按小时利率
    ,client_econ_type varchar2(3) -- 客户经济类型
    ,gear_by_hour_flag varchar2(1) -- 按小时靠档标志
    ,abs_flag varchar2(1) -- 资产证券化标志
    ,auto_reversal_flag varchar2(1) -- 自动冲正标志|自动冲正标志|Y-自动冲正,N-业务冲正
    ,anytime_rec_flag varchar2(1) -- 随借随还标志|随借随还标志 Y-是,N-否
    ,gear_prod_flag varchar2(1) -- 是否靠档计息标志|是否靠档计息标志
    ,document_id varchar2(60) -- 证件号码|证件号码
    ,document_type varchar2(4) -- 客户证件类型|客户证件类型
    ,accounting_status_yesterday varchar2(3) -- 上日核算状态|ZHC-正常,YUQ-逾期,FYJ-非应计,FY-手工转非应计,DZA-呆账,DZI-呆滞,WRN-核销,TER-终止
    ,is_trf_flag varchar2(1) -- 资产转让标志
    ,acct_status_yesterday varchar2(1) -- 上一日账户状态
    ,last_merge_flag varchar2(1) -- 末期合并
    ,renew_fact_flg varchar2(1) -- 是否再保理标志
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
grant select on ${iol_schema}.ncbs_cl_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct is '账户基本信息表';
comment on column ${iol_schema}.ncbs_cl_acct.od_grace_end_date is '免息截止日期';
comment on column ${iol_schema}.ncbs_cl_acct.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_cl_acct.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_cl_acct.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_cl_acct.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_acct.business_unit is '账套';
comment on column ${iol_schema}.ncbs_cl_acct.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_acct.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_cl_acct.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_acct.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_acct.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_cl_acct.reason_code is '账户用途';
comment on column ${iol_schema}.ncbs_cl_acct.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_acct.term is '存期';
comment on column ${iol_schema}.ncbs_cl_acct.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_cl_acct.acct_desc is '账户描述';
comment on column ${iol_schema}.ncbs_cl_acct.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_cl_acct.acct_status_prev is '账户上一状态';
comment on column ${iol_schema}.ncbs_cl_acct.alloc_seq_fee is '贷款费用还款顺序';
comment on column ${iol_schema}.ncbs_cl_acct.alloc_seq_int is '贷款利息还款顺序';
comment on column ${iol_schema}.ncbs_cl_acct.alloc_seq_odi is '贷款复利还款顺序';
comment on column ${iol_schema}.ncbs_cl_acct.alloc_seq_odp is '贷款罚息还款顺序';
comment on column ${iol_schema}.ncbs_cl_acct.alloc_seq_pri is '贷款本金还款顺序';
comment on column ${iol_schema}.ncbs_cl_acct.alloc_seq_type is '贷款自动还款类型';
comment on column ${iol_schema}.ncbs_cl_acct.appr_flag is '复核标志';
comment on column ${iol_schema}.ncbs_cl_acct.auto_settle_flag is '自动结清标志';
comment on column ${iol_schema}.ncbs_cl_acct.bal_type is '余额类型';
comment on column ${iol_schema}.ncbs_cl_acct.calc_times is '气球贷计算期次';
comment on column ${iol_schema}.ncbs_cl_acct.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_cl_acct.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct.cur_stage_no is '当前期数';
comment on column ${iol_schema}.ncbs_cl_acct.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_cl_acct.five_category is '贷款五级分类';
comment on column ${iol_schema}.ncbs_cl_acct.fta_acct_flag is '是否自贸区账户标识';
comment on column ${iol_schema}.ncbs_cl_acct.fta_code is '自贸区代码';
comment on column ${iol_schema}.ncbs_cl_acct.int_ind_flag is '是否计息';
comment on column ${iol_schema}.ncbs_cl_acct.is_individual is '个体客户标志';
comment on column ${iol_schema}.ncbs_cl_acct.lender is '贷款人';
comment on column ${iol_schema}.ncbs_cl_acct.manual_change_schedule_flag is '是否需要手工录入还款计划';
comment on column ${iol_schema}.ncbs_cl_acct.marketing_prod_desc is '营销产品名称';
comment on column ${iol_schema}.ncbs_cl_acct.mid_period is '累进间隔期数';
comment on column ${iol_schema}.ncbs_cl_acct.old_dd_no is '原发放号';
comment on column ${iol_schema}.ncbs_cl_acct.old_loan_no is '原贷款号';
comment on column ${iol_schema}.ncbs_cl_acct.osa_flag is '离岸标记';
comment on column ${iol_schema}.ncbs_cl_acct.other_consumption is '其他消费';
comment on column ${iol_schema}.ncbs_cl_acct.pay_off_type is '贷款销户类型';
comment on column ${iol_schema}.ncbs_cl_acct.pre_repay_deal is '还款计划变更方式';
comment on column ${iol_schema}.ncbs_cl_acct.purpose_id is '用途编号';
comment on column ${iol_schema}.ncbs_cl_acct.recover_flag is '实时追缴标志字段';
comment on column ${iol_schema}.ncbs_cl_acct.regen_schedule_flag is '重新生成还款计划标志';
comment on column ${iol_schema}.ncbs_cl_acct.region_flag is '区内区外标记';
comment on column ${iol_schema}.ncbs_cl_acct.sched_mode is '还款方式';
comment on column ${iol_schema}.ncbs_cl_acct.source_module is '源模块';
comment on column ${iol_schema}.ncbs_cl_acct.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cl_acct.sub_project_no is '子项目号';
comment on column ${iol_schema}.ncbs_cl_acct.sub_sched_mode is '当前子计划方式';
comment on column ${iol_schema}.ncbs_cl_acct.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_cl_acct.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_acct.accounting_status_prev is '上次核算状态';
comment on column ${iol_schema}.ncbs_cl_acct.accounting_status_upd_date is '核算状态变更日期';
comment on column ${iol_schema}.ncbs_cl_acct.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_cl_acct.acct_status_upd_date is '账户状态变更日期';
comment on column ${iol_schema}.ncbs_cl_acct.approval_date is '复核日期';
comment on column ${iol_schema}.ncbs_cl_acct.closed_date is '关闭日期';
comment on column ${iol_schema}.ncbs_cl_acct.contraction_date is '变期不变额最后变化日期';
comment on column ${iol_schema}.ncbs_cl_acct.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_cl_acct.first_overdue_date is '最早逾期日期';
comment on column ${iol_schema}.ncbs_cl_acct.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_acct.last_tran_date is '最后交易日期';
comment on column ${iol_schema}.ncbs_cl_acct.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_cl_acct.open_tran_date is '开户后首次交易日期';
comment on column ${iol_schema}.ncbs_cl_acct.ori_maturity_date is '账户原始到期日期';
comment on column ${iol_schema}.ncbs_cl_acct.orig_acct_open_date is '账户原始开立日期';
comment on column ${iol_schema}.ncbs_cl_acct.ssi_end_date is '贴息截止日期';
comment on column ${iol_schema}.ncbs_cl_acct.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct.acct_close_reason is '关闭原因';
comment on column ${iol_schema}.ncbs_cl_acct.acct_close_user_id is '账户销户操作柜员';
comment on column ${iol_schema}.ncbs_cl_acct.add_ratio is '累进比例';
comment on column ${iol_schema}.ncbs_cl_acct.alt_acct_name is '备用账户名称';
comment on column ${iol_schema}.ncbs_cl_acct.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_cl_acct.contributive_ratio is '出资比例';
comment on column ${iol_schema}.ncbs_cl_acct.fir_period is '首段期数';
comment on column ${iol_schema}.ncbs_cl_acct.formula_amt is '每期计划还款额';
comment on column ${iol_schema}.ncbs_cl_acct.home_branch is '客户管理行';
comment on column ${iol_schema}.ncbs_cl_acct.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_acct.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_acct.marketing_prod is '营销产品';
comment on column ${iol_schema}.ncbs_cl_acct.old_prod_type is '原产品类型';
comment on column ${iol_schema}.ncbs_cl_acct.pay_off_reason is '贷款销户原因';
comment on column ${iol_schema}.ncbs_cl_acct.add_amt is '累进金额';
comment on column ${iol_schema}.ncbs_cl_acct.apply_branch is '申请机构';
comment on column ${iol_schema}.ncbs_cl_acct.auto_transfer_flag is '是否核销后自动转款';
comment on column ${iol_schema}.ncbs_cl_acct.sched_assemble_flag is '自动组合还款标识';
comment on column ${iol_schema}.ncbs_cl_acct.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_cl_acct.ext_trade_no is '原业务编号';
comment on column ${iol_schema}.ncbs_cl_acct.hour_int_rate is '按小时利率';
comment on column ${iol_schema}.ncbs_cl_acct.client_econ_type is '客户经济类型';
comment on column ${iol_schema}.ncbs_cl_acct.gear_by_hour_flag is '按小时靠档标志';
comment on column ${iol_schema}.ncbs_cl_acct.abs_flag is '资产证券化标志';
comment on column ${iol_schema}.ncbs_cl_acct.auto_reversal_flag is '自动冲正标志|自动冲正标志|Y-自动冲正,N-业务冲正';
comment on column ${iol_schema}.ncbs_cl_acct.anytime_rec_flag is '随借随还标志|随借随还标志 Y-是,N-否';
comment on column ${iol_schema}.ncbs_cl_acct.gear_prod_flag is '是否靠档计息标志|是否靠档计息标志';
comment on column ${iol_schema}.ncbs_cl_acct.document_id is '证件号码|证件号码';
comment on column ${iol_schema}.ncbs_cl_acct.document_type is '客户证件类型|客户证件类型';
comment on column ${iol_schema}.ncbs_cl_acct.accounting_status_yesterday is '上日核算状态|ZHC-正常,YUQ-逾期,FYJ-非应计,FY-手工转非应计,DZA-呆账,DZI-呆滞,WRN-核销,TER-终止';
comment on column ${iol_schema}.ncbs_cl_acct.is_trf_flag is '资产转让标志';
comment on column ${iol_schema}.ncbs_cl_acct.acct_status_yesterday is '上一日账户状态';
comment on column ${iol_schema}.ncbs_cl_acct.last_merge_flag is '末期合并';
comment on column ${iol_schema}.ncbs_cl_acct.renew_fact_flg is '是否再保理标志';
comment on column ${iol_schema}.ncbs_cl_acct.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct.etl_timestamp is 'ETL处理时间戳';
