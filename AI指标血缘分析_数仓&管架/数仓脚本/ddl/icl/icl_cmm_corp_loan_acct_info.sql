/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_corp_loan_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_corp_loan_acct_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_corp_loan_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_corp_loan_acct_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_name varchar2(200) -- 账户名称
    ,cust_id varchar2(60) -- 客户编号
    ,cont_id varchar2(60) -- 合同编号
    ,dubil_num varchar2(60) -- 借据号
    ,core_dubil_num varchar2(60) -- 核心借据号
    ,loan_num varchar2(60) -- 贷款号
    ,loan_distr_acct_num varchar2(60) -- 贷款放款账号
    ,loan_repay_num varchar2(60) -- 贷款还款账号
    ,int_sub_ps_stl_acct_num varchar2(60) -- 贴息人结算账号
    ,entr_dep_acct_num varchar2(60) -- 委托存款账号
    ,csner_dep_acct_num varchar2(60) -- 委托人存款账号
    ,distr_flow_num varchar2(60) -- 放款流水号
    ,inpwn_acct_num_id varchar2(100) -- 质押账号ID
    ,out_acct_num varchar2(100) -- 出账号
    ,rela_bill_id varchar2(60) -- 关联票证编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,prod_id varchar2(60) -- 产品编号
    ,subj_id varchar2(60) -- 科目编号
    ,init_pric_subj_id varchar2(60) -- 原本金科目编号
    ,int_subj_id varchar2(60) -- 表内利息科目编号
    ,recvbl_uncol_int_subj_id varchar2(60) -- 应收未收利息科目编号
    ,recvbl_int_paybl_adj_subj_id varchar2(60) -- 应收应付利息调整科目编号
    ,off_bs_int_subj_id varchar2(60) -- 表外利息科目编号
    ,acru_aldy_impam_int_subj_id varchar2(60) -- 应计已减值利息科目编号
    ,int_income_subj_id varchar2(60) -- 利息收入科目编号
    ,int_income_adj_subj_id varchar2(60) -- 利息收入调整科目编号
    ,spd_pl_subj_id varchar2(100) -- 价差损益科目编号
    ,loan_modal_cd varchar2(30) -- 贷款形态代码
    ,loan_acct_status_cd varchar2(10) -- 贷款账户状态代码
    ,loan_tenor varchar2(10) -- 贷款期限
    ,loan_tenor_type_cd varchar2(10) -- 贷款期限类型代码
    ,loan_cate_cd varchar2(10) -- 贷款类别代码
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,belong_bus_strip_line_cd varchar2(10) -- 所属业务条线代码
    ,guar_way_cd varchar2(10) -- 担保方式代码
    ,loan_usage_descb varchar2(2000) -- 贷款用途描述
    ,acru_non_acru_cd varchar2(10) -- 应计非应计代码
    ,turn_non_acru_loan_dt date -- 转非应计贷款日期
    ,cust_mgr_id varchar2(60) -- 客户经理编号
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,mgmt_org_id varchar2(60) -- 管理机构编号
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,open_acct_dt date -- 开户日期
    ,open_acct_timestamp date -- 开户时间
    ,distr_dt date -- 放款日期
    ,value_dt date -- 起息日期
    ,stop_accr_int_dt date -- 停息日期
    ,exp_dt date -- 到期日期
    ,init_exp_dt date -- 原始到期日期
    ,clos_acct_dt date -- 销户日期
    ,clos_acct_timestamp date -- 销户时间
    ,int_sub_flg varchar2(10) -- 贴息标志
    ,int_sub_ratio number(18,6) -- 贴息比例
    ,int_sub_exp_day date -- 贴息到期日
    ,entr_loan_comm_fee_coll_way varchar2(10) -- 委托贷款手续费收取方式
    ,entr_loan_comm_fee_coll_ratio number(18,2) -- 委托贷款手续费收取比例
    ,entr_loan_comm_fee number(18,2) -- 委托贷款手续费
    ,int_accr_flg varchar2(10) -- 计息标志
    ,stop_accr_int_flg varchar2(10) -- 停息标志
    ,impam_flg varchar2(10) -- 减值标志
    ,crdt_distr_repay_plan_flg varchar2(10) -- 信贷发放还款计划标志
    ,finc_prod_flg varchar2(10) -- 理财产品标志
    ,prepay_int_amort_flg varchar2(10) -- 预付利息摊销标志
    ,pric_auto_deduct_flg varchar2(10) -- 本金自动扣收标志
    ,int_auto_deduct_flg varchar2(10) -- 利息自动扣收标志
    ,acpt_flg varchar2(10) -- 承兑标志
    ,gover_fin_plat_loan_flg varchar2(10) -- 政府融资平台贷款标志
    ,tax_flg varchar2(10) -- 扣税标志
    ,wrt_off_flg varchar2(10) -- 核销标志
    ,renew_flg varchar2(10) -- 展期标志
    ,renew_cnt number(10,0) -- 展期次数
    ,fir_renew_exp_dt date -- 首次展期到期日期
    ,renew_exp_day date -- 展期到期日期
    ,allow_adv_repay_flg varchar2(10) -- 允许提前还款标志
    ,repay_seq_no_cd varchar2(10) -- 还款次序代码
    ,adv_repay_way_cd varchar2(10) -- 提前还款方式代码
    ,margin_curr_cd varchar2(10) -- 保证金币种代码
    ,int_rat_base_type_cd varchar2(30) -- 利率基准类型代码
    ,int_rat_curve_type_cd varchar2(12) -- 利率曲线类型代码
    ,base_rat number(18,8) -- 基准利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,reval_way_cd varchar2(30) -- 重定价方式代码
    ,comn_loan_int_set_way_cd varchar2(10) -- 普通贷款结息方式代码
    ,int_rat_adj_way_cd varchar2(10) -- 利率调整方式代码
    ,int_rat_float_way_cd varchar2(10) -- 利率浮动方式代码
    ,int_rat_adj_ped_corp_cd varchar2(10) -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq number(10,0) -- 利率调整周期频率
    ,int_rat_flo_val number(18,6) -- 利率浮动值
    ,curr_int_rat_effect_dt date -- 当前利率生效日期
    ,next_int_rat_adj_dt date -- 下次利率调整日期
    ,comp_int_flg varchar2(10) -- 复息标志
    ,int_set_way_cd varchar2(10) -- 结息方式代码
    ,int_accr_way_cd varchar2(10) -- 计息方式代码
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,repay_ped_corp_cd varchar2(10) -- 还款周期单位代码
    ,repay_ped number(10,2) -- 还款周期
    ,money_use_type varchar2(10) -- 款项使用类型
    ,lmt_type varchar2(10) -- 额度类型
    ,abs_flg varchar2(10) -- 资产证券化标志
    ,asset_tran_flg varchar2(10) -- 资产转让标志
    ,asset_tran_status_cd varchar2(10) -- 资产转让状态代码
    ,asset_tran_dt date -- 资产转让日期
    ,tran_bf_int_recvbl number(30,2) -- 转让前应收利息
    ,ovdue_flg varchar2(10) -- 逾期标志
    ,pric_ovdue_flg varchar2(10) -- 本金逾期标志
    ,int_ovdue_flg varchar2(10) -- 利息逾期标志
    ,curr_ovdue_perds number(10,0) -- 当前逾期期数
    ,pric_ovdue_days number(10,0) -- 本金逾期天数
    ,int_ovdue_days number(10,0) -- 利息逾期天数
    ,ovdue_pric_bal number(30,2) -- 逾期本金余额
    ,ovdue_int_amt number(30,2) -- 逾期利息金额
    ,ovdue_comp_int_amt number(30,2) -- 逾期复利金额
    ,fir_ovdue_dt date -- 首次逾期日期
    ,pric_ovdue_dt date -- 本金逾期日期
    ,int_ovdue_dt date -- 利息逾期日期
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,ovdue_int_rat_flo_val number(18,6) -- 逾期利率浮动值
    ,tot_perds number(10,0) -- 贷款期数
    ,curr_issue_perds number(10,0) -- 当前期数
    ,last_repay_dt date -- 上次还款日期
    ,next_repay_dt date -- 下次还款日期
    ,curr_cd varchar2(10) -- 币种代码
    ,next_rpp_amt number(30,2) -- 下次还本金额
    ,next_repay_int_amt number(30,2) -- 下次还息金额
    ,td_acru_int number(30,8) -- 当日应计利息
    ,currt_acru_int number(30,8) -- 当期应计利息
    ,td_int_income number(30,8) -- 当日利息收入
    ,td_int_income_adj number(30,8) -- 当日利息收入调整
    ,td_tax_income number(30,8) -- 当日税额收入
    ,td_spd_pl number(30,2) -- 当日价差损益
    ,cont_amt number(30,2) -- 合同金额
    ,dubil_amt number(30,2) -- 借据金额
    ,distr_amt number(30,2) -- 放款金额
    ,nomal_pric number(30,2) -- 正常本金
    ,ovdue_pric number(30,2) -- 逾期本金
    ,grace_period_pric number(30,2) -- 宽限期本金
    ,grace_period_int number(30,2) -- 宽限期利息
    ,idle_pric number(30,2) -- 呆滞本金
    ,bad_debt_pric number(30,2) -- 呆账本金
    ,recvbl_over_int number(30,2) -- 应收欠息
    ,recvbl_acru_pnlt number(30,2) -- 应收应计罚息
    ,coll_acru_pnlt number(30,2) -- 催收应计罚息
    ,recvbl_pnlt number(30,2) -- 应收罚息
    ,coll_pnlt number(30,2) -- 催收罚息
    ,acru_comp_int number(30,2) -- 应计复息
    ,recvbl_comp_int number(30,2) -- 应收复息_计量后
    ,recvbl_fee number(30,2) -- 应收费用
    ,wrt_off_pric number(30,2) -- 核销本金
    ,wrt_off_int number(30,2) -- 核销利息
    ,in_bs_over_int_bal number(30,2) -- 表内欠息余额
    ,off_bs_over_int_bal number(30,2) -- 表外欠息余额
    ,in_bs_int number(30,2) -- 表内利息
    ,off_bs_int number(30,2) -- 表外利息
    ,acm_recvbl_uncol_int_amt number(30,2) -- 累计应收未收利息金额
    ,recvbl_uncol_int number(30,2) -- 应收未收利息_计量后
    ,int_recvbl number(30,2) -- 应收利息
    ,non_acru_int_recvbl number(30,2) -- 非应计应收利息_计量后
    ,acru_aldy_impam_int number(30,2) -- 应计已减值利息
    ,trade_fin_int_adj number(30,2) -- 贸易融资利息调整
    ,repaid_pric number(30,2) -- 已偿还本金
    ,repaid_int number(30,2) -- 已偿还利息
    ,repaid_pnlt number(30,2) -- 已偿还罚息
    ,repaid_comp_int number(30,2) -- 已偿还复利
    ,repaid_fee number(30,2) -- 已偿还费用
    ,wrt_off_advc_fee_amt number(30,2) -- 核销垫付费金额
    ,pric_bal number(30,2) -- 本金余额
    ,currt_bal number(30,2) -- 当期余额
    ,cl_curr_currt_bal number(30,2) -- 折本币当期余额
    ,ear_d_bal number(30,2) -- 日初余额
    ,ear_m_bal number(30,2) -- 月初余额
    ,ear_s_bal number(30,2) -- 季初余额
    ,ear_y_bal number(30,2) -- 年初余额
    ,y_acm_bal number(30,2) -- 年累计余额
    ,s_acm_bal number(30,2) -- 季累计余额
    ,m_acm_bal number(30,2) -- 月累计余额
    ,cl_curr_ear_d_bal number(30,2) -- 折本币日初余额
    ,cl_curr_ear_m_bal number(30,2) -- 折本币月初余额
    ,cl_curr_ear_s_bal number(30,2) -- 折本币季初余额
    ,cl_curr_ear_y_bal number(30,2) -- 折本币年初余额
    ,cl_curr_y_acm_bal number(30,2) -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal number(30,2) -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal number(30,2) -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal number(30,2) -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal number(30,2) -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal number(30,2) -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal number(30,2) -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal number(30,2) -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal number(30,2) -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal number(30,2) -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal number(30,2) -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal number(30,2) -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal number(30,2) -- 折本币年初月累计余额
    ,y_avg_bal number(30,2) -- 年日均余额
    ,q_avg_bal number(30,2) -- 季日均余额
    ,m_avg_bal number(30,2) -- 月日均余额
    ,cl_curr_y_avg_bal number(30,2) -- 折本币年日均余额
    ,cl_curr_q_avg_bal number(30,2) -- 折本币季日均余额
    ,cl_curr_m_avg_bal number(30,2) -- 折本币月日均余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_corp_loan_acct_info to ${idl_schema};
grant select on ${icl_schema}.cmm_corp_loan_acct_info to ${iel_schema};
grant select on ${icl_schema}.cmm_corp_loan_acct_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_corp_loan_acct_info is '对公贷款账户信息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cont_id is '合同编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.dubil_num is '借据号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.core_dubil_num is '核心借据号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.loan_num is '贷款号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.loan_distr_acct_num is '贷款放款账号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.loan_repay_num is '贷款还款账号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_sub_ps_stl_acct_num is '贴息人结算账号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.entr_dep_acct_num is '委托存款账号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.csner_dep_acct_num is '委托人存款账号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.distr_flow_num is '放款流水号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.inpwn_acct_num_id is '质押账号ID';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.out_acct_num is '出账号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.rela_bill_id is '关联票证编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.init_pric_subj_id is '原本金科目编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_subj_id is '表内利息科目编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.recvbl_uncol_int_subj_id is '应收未收利息科目编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.recvbl_int_paybl_adj_subj_id is '应收应付利息调整科目编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.off_bs_int_subj_id is '表外利息科目编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.acru_aldy_impam_int_subj_id is '应计已减值利息科目编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_income_subj_id is '利息收入科目编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_income_adj_subj_id is '利息收入调整科目编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.spd_pl_subj_id is '价差损益科目编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.loan_modal_cd is '贷款形态代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.loan_acct_status_cd is '贷款账户状态代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.loan_tenor is '贷款期限';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.loan_tenor_type_cd is '贷款期限类型代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.loan_cate_cd is '贷款类别代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.belong_bus_strip_line_cd is '所属业务条线代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.guar_way_cd is '担保方式代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.loan_usage_descb is '贷款用途描述';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.acru_non_acru_cd is '应计非应计代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.turn_non_acru_loan_dt is '转非应计贷款日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.open_acct_org_id is '开户机构编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.mgmt_org_id is '管理机构编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.acct_instit_id is '账务机构编号';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.open_acct_dt is '开户日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.open_acct_timestamp is '开户时间';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.distr_dt is '放款日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.stop_accr_int_dt is '停息日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.init_exp_dt is '原始到期日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.clos_acct_dt is '销户日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.clos_acct_timestamp is '销户时间';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_sub_flg is '贴息标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_sub_ratio is '贴息比例';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_sub_exp_day is '贴息到期日';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.entr_loan_comm_fee_coll_way is '委托贷款手续费收取方式';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.entr_loan_comm_fee_coll_ratio is '委托贷款手续费收取比例';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.entr_loan_comm_fee is '委托贷款手续费';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_accr_flg is '计息标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.stop_accr_int_flg is '停息标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.impam_flg is '减值标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.crdt_distr_repay_plan_flg is '信贷发放还款计划标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.finc_prod_flg is '理财产品标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.prepay_int_amort_flg is '预付利息摊销标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.pric_auto_deduct_flg is '本金自动扣收标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_auto_deduct_flg is '利息自动扣收标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.acpt_flg is '承兑标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.gover_fin_plat_loan_flg is '政府融资平台贷款标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.tax_flg is '扣税标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.wrt_off_flg is '核销标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.renew_flg is '展期标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.renew_cnt is '展期次数';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.fir_renew_exp_dt is '首次展期到期日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.renew_exp_day is '展期到期日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.allow_adv_repay_flg is '允许提前还款标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.repay_seq_no_cd is '还款次序代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.adv_repay_way_cd is '提前还款方式代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.margin_curr_cd is '保证金币种代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_rat_base_type_cd is '利率基准类型代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_rat_curve_type_cd is '利率曲线类型代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.base_rat is '基准利率';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.exec_int_rat is '执行利率';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.reval_way_cd is '重定价方式代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.comn_loan_int_set_way_cd is '普通贷款结息方式代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_rat_adj_ped_corp_cd is '利率调整周期单位代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_rat_adj_ped_freq is '利率调整周期频率';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_rat_flo_val is '利率浮动值';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.curr_int_rat_effect_dt is '当前利率生效日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.next_int_rat_adj_dt is '下次利率调整日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.comp_int_flg is '复息标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_set_way_cd is '结息方式代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_accr_way_cd is '计息方式代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.repay_way_cd is '还款方式代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.repay_ped_corp_cd is '还款周期单位代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.repay_ped is '还款周期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.money_use_type is '款项使用类型';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.lmt_type is '额度类型';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.abs_flg is '资产证券化标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.asset_tran_flg is '资产转让标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.asset_tran_status_cd is '资产转让状态代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.asset_tran_dt is '资产转让日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.tran_bf_int_recvbl is '转让前应收利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ovdue_flg is '逾期标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.pric_ovdue_flg is '本金逾期标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_ovdue_flg is '利息逾期标志';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.curr_ovdue_perds is '当前逾期期数';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.pric_ovdue_days is '本金逾期天数';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_ovdue_days is '利息逾期天数';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ovdue_pric_bal is '逾期本金余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ovdue_int_amt is '逾期利息金额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ovdue_comp_int_amt is '逾期复利金额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.fir_ovdue_dt is '首次逾期日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.pric_ovdue_dt is '本金逾期日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_ovdue_dt is '利息逾期日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ovdue_int_rat is '逾期利率';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ovdue_int_rat_flo_val is '逾期利率浮动值';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.tot_perds is '贷款期数';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.curr_issue_perds is '当前期数';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.last_repay_dt is '上次还款日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.next_repay_dt is '下次还款日期';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.next_rpp_amt is '下次还本金额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.next_repay_int_amt is '下次还息金额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.td_acru_int is '当日应计利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.td_int_income is '当日利息收入';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.td_int_income_adj is '当日利息收入调整';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.td_tax_income is '当日税额收入';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.td_spd_pl is '当日价差损益';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cont_amt is '合同金额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.dubil_amt is '借据金额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.distr_amt is '放款金额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.nomal_pric is '正常本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ovdue_pric is '逾期本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.grace_period_pric is '宽限期本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.grace_period_int is '宽限期利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.idle_pric is '呆滞本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.bad_debt_pric is '呆账本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.recvbl_over_int is '应收欠息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.recvbl_acru_pnlt is '应收应计罚息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.coll_acru_pnlt is '催收应计罚息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.recvbl_pnlt is '应收罚息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.coll_pnlt is '催收罚息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.acru_comp_int is '应计复息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.recvbl_comp_int is '应收复息_计量后';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.recvbl_fee is '应收费用';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.wrt_off_pric is '核销本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.wrt_off_int is '核销利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.in_bs_over_int_bal is '表内欠息余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.off_bs_over_int_bal is '表外欠息余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.in_bs_int is '表内利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.off_bs_int is '表外利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.acm_recvbl_uncol_int_amt is '累计应收未收利息金额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.recvbl_uncol_int is '应收未收利息_计量后';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.non_acru_int_recvbl is '非应计应收利息_计量后';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.acru_aldy_impam_int is '应计已减值利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.trade_fin_int_adj is '贸易融资利息调整';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.repaid_pric is '已偿还本金';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.repaid_int is '已偿还利息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.repaid_pnlt is '已偿还罚息';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.repaid_comp_int is '已偿还复利';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.repaid_fee is '已偿还费用';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.wrt_off_advc_fee_amt is '核销垫付费金额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.pric_bal is '本金余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_currt_bal is '折本币当期余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ear_d_bal is '日初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ear_m_bal is '月初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ear_s_bal is '季初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.ear_y_bal is '年初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.y_acm_bal is '年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.s_acm_bal is '季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.m_acm_bal is '月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_d_bal is '折本币日初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_m_bal is '折本币月初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_s_bal is '折本币季初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_y_bal is '折本币年初余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_y_acm_bal is '折本币年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_d_y_acm_bal is '折本币日初年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_m_y_acm_bal is '折本币月初年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_s_y_acm_bal is '折本币季初年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_y_y_acm_bal is '折本币年初年累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_s_acm_bal is '折本币季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_d_s_acm_bal is '折本币日初季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_s_s_acm_bal is '折本币季初季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_y_s_acm_bal is '折本币年初季累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_m_acm_bal is '折本币月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_d_m_acm_bal is '折本币日初月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_m_m_acm_bal is '折本币月初月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_ear_y_m_acm_bal is '折本币年初月累计余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.y_avg_bal is '年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.q_avg_bal is '季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.m_avg_bal is '月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_y_avg_bal is '折本币年日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_q_avg_bal is '折本币季日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.cl_curr_m_avg_bal is '折本币月日均余额';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_corp_loan_acct_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_corp_loan_acct_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_corp_loan_acct_info.etl_timestamp is 'ETL处理时间戳';
