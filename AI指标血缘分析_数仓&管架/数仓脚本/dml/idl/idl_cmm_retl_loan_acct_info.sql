/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_cmm_retl_loan_acct_info
CreateDate: 20240910
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
alter table ${idl_schema}.cmm_retl_loan_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_retl_loan_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_retl_loan_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,acct_name  -- 账户名称
    ,cust_id  -- 客户编号
    ,cont_id  -- 合同编号
    ,dubil_num  -- 借据号
    ,loan_distr_acct_num  -- 贷款放款账号
    ,loan_repay_num  -- 贷款还款账号
    ,std_prod_id  -- 标准产品编号
    ,prod_id  -- 产品编号
    ,subj_id  -- 科目编号
    ,acctnt_cate_cd  -- 会计类别代码
    ,bus_breed_id  -- 业务品种编号
    ,asset_thd_cls_cd  -- 资产三分类代码
    ,loan_modal_cd  -- 贷款形态代码
    ,loan_acct_status_cd  -- 贷款账户状态代码
    ,unite_loan_cd  -- 联合贷款代码
    ,priv_loan_flg  -- 对私贷款标志
    ,promis_loan_flg  -- 承诺贷款标志
    ,circl_loan_flg  -- 循环贷款标志
    ,deriv_loan_flg  -- 衍生贷款标志
    ,agent_loan_flg  -- 代理贷款标志
    ,oots_accti_flg  -- 按一逾两呆核算标志
    ,loan_modal_dg_subj_accti_flg  -- 贷款形态分科目核算标志
    ,loan_tenor  -- 贷款期限
    ,loan_tenor_type_cd  -- 贷款期限类型代码
    ,acru_non_acru_cd  -- 应计非应计代码
    ,final_fin_dt  -- 最后财务日期
    ,open_acct_teller_id  -- 开户柜员编号
    ,clos_acct_teller_id  -- 销户柜员编号
    ,open_acct_org_id  -- 开户机构编号
    ,mgmt_org_id  -- 管理机构编号
    ,acct_instit_id  -- 账务机构编号
    ,open_acct_dt  -- 开户日期
    ,distr_dt  -- 放款日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,clos_acct_dt  -- 销户日期
    ,int_sub_flg  -- 贴息标志
    ,renew_flg  -- 展期标志
    ,renew_cnt  -- 展期次数
    ,int_accr_rule  -- 计息规则
    ,int_accr_flg  -- 计息标志
    ,comp_int_flg  -- 复息标志
    ,pre_recv_int_way  -- 预收息方式
    ,int_rat_adj_way_cd  -- 利率调整方式代码
    ,int_rat_base_type_cd  -- 利率基准类型代码
    ,base_rat_id  -- 基准利率编号
    ,base_rat  -- 基准利率
    ,exec_int_rat  -- 执行利率
    ,int_rat_float_way_cd  -- 利率浮动方式代码
    ,int_rat_adj_ped_corp_cd  -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq  -- 利率调整周期频率
    ,int_rat_flo_val  -- 利率浮动值
    ,curr_int_rat_effect_dt  -- 当前利率生效日期
    ,next_int_rat_adj_dt  -- 下次利率调整日期
    ,int_set_way_cd  -- 结息方式代码
    ,int_accr_way_cd  -- 计息方式代码
    ,ped_distr_flg  -- 周期性放款标志
    ,distr_way_cd  -- 放款方式代码
    ,repay_way_cd  -- 还款方式代码
    ,repay_ped_corp_cd  -- 还款周期单位代码
    ,repay_ped  -- 还款周期
    ,allow_adv_repay_flg  -- 允许提前还款标志
    ,wrt_off_flg  -- 核销标志
    ,ovdue_flg  -- 逾期标志
    ,ovdue_int_accr_way_cd  -- 逾期计息方式代码
    ,ovdue_pnlt_float_way_cd  -- 逾期罚息浮动方式代码
    ,pric_ovdue_flg  -- 本金逾期标志
    ,int_ovdue_flg  -- 利息逾期标志
    ,curr_ovdue_perds  -- 当前逾期期数
    ,pric_ovdue_days  -- 本金逾期天数
    ,int_ovdue_days  -- 利息逾期天数
    ,ovdue_pric_bal  -- 逾期本金余额
    ,ovdue_int_amt  -- 逾期利息金额
    ,ovdue_comp_int_amt  -- 逾期复利金额
    ,fir_ovdue_dt  -- 首次逾期日期
    ,ovdue_int_rat  -- 逾期利率
    ,ovdue_int_rat_flo_val  -- 逾期利率浮动值
    ,tot_perds  -- 总期数
    ,curr_issue_perds  -- 本期期数
    ,last_repay_dt  -- 上次还款日期
    ,curr_cd  -- 币种代码
    ,next_repay_dt  -- 下次还款日期
    ,next_rpp_amt  -- 下次还本金额
    ,next_repay_int_amt  -- 下次还息金额
    ,cont_amt  -- 合同金额
    ,dubil_amt  -- 借据金额
    ,distr_amt  -- 放款金额
    ,froz_distrd_amt  -- 冻结可发放金额
    ,distrd_amt  -- 可发放金额
    ,td_acru_int  -- 当日应计利息
    ,currt_acru_int  -- 当期应计利息
    ,nomal_pric  -- 正常本金
    ,ovdue_pric  -- 逾期本金
    ,idle_pric  -- 呆滞本金
    ,bad_debt_pric  -- 呆账本金
    ,loan_fund  -- 贷款基金
    ,recvbl_acru_int  -- 应收应计利息
    ,coll_acru_int  -- 催收应计利息
    ,recvbl_acru_pnlt  -- 应收应计罚息
    ,coll_acru_pnlt  -- 催收应计罚息
    ,recvbl_pnlt  -- 应收罚息
    ,coll_pnlt  -- 催收罚息
    ,acru_comp_int  -- 应计复息
    ,recvbl_comp_int  -- 应收复息
    ,acru_int_sub  -- 应计贴息
    ,recvbl_int_sub  -- 应收贴息
    ,amorted_int  -- 待摊利息
    ,wrt_off_pric  -- 核销本金
    ,wrt_off_int  -- 核销利息
    ,int_income  -- 利息收入
    ,wrt_off_advc_fee_bal  -- 核销垫付费余额
    ,wrt_off_advc_fee_amt  -- 核销垫付费金额
    ,recvbl_fine  -- 应收罚金
    ,fine_inco  -- 罚金收入
    ,resv  -- 准备金
    ,recvbl_over_int  -- 应收欠息
    ,coll_over_int  -- 催收欠息
    ,in_bs_int  -- 表内利息
    ,off_bs_int  -- 表外利息
    ,acm_recvbl_uncol_int_amt  -- 累计应收未收利息金额
    ,repaid_pric  -- 已偿还本金
    ,repaid_int  -- 已偿还利息
    ,repaid_pnlt  -- 已偿还罚息
    ,repaid_comp_int  -- 已偿还复利
    ,repaid_fee  -- 已偿还费用
    ,pric_bal  -- 本金余额
    ,currt_bal  -- 当期余额
    ,cl_curr_currt_bal  -- 折本币当期余额
    ,ear_d_bal  -- 日初余额
    ,ear_m_bal  -- 月初余额
    ,ear_s_bal  -- 季初余额
    ,ear_y_bal  -- 年初余额
    ,y_acm_bal  -- 年累计余额
    ,s_acm_bal  -- 季累计余额
    ,m_acm_bal  -- 月累计余额
    ,cl_curr_ear_d_bal  -- 折本币日初余额
    ,cl_curr_ear_m_bal  -- 折本币月初余额
    ,cl_curr_ear_s_bal  -- 折本币季初余额
    ,cl_curr_ear_y_bal  -- 折本币年初余额
    ,cl_curr_y_acm_bal  -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal  -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal  -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,y_avg_bal  -- 年日均余额
    ,q_avg_bal  -- 季日均余额
    ,m_avg_bal  -- 月日均余额
    ,cl_curr_y_avg_bal  -- 折本币年日均余额
    ,cl_curr_q_avg_bal  -- 折本币季日均余额
    ,cl_curr_m_avg_bal  -- 折本币月日均余额
    ,init_pric_subj_id  -- 原本金科目编号
    ,asset_tran_status_cd  -- 资产转让状态代码
    ,tran_bf_int_recvbl  -- 转让前应收利息
    ,td_int_income  -- 当日利息收入
    ,in_bs_int_subj_id  -- 表内利息科目编号
    ,off_bs_int_subj_id  -- 表外利息科目编号
    ,int_income_subj_id  -- 利息收入科目编号
    ,int_income_adj_subj_id  -- 利息收入调整科目编号
    ,td_int_income_adj  -- 当日利息收入调整
    ,irr_repay_way_cd  -- 不规则还款方式代码
    ,renew_exp_dt  -- 展期到期日期
    ,asset_tran_dt  -- 资产转让日期
    ,pric_ovdue_dt  -- 本金逾期日期
    ,int_ovdue_dt  -- 利息逾期日期
    ,loan_num  -- 贷款号
    ,acru_aldy_impam_int_subj_id  -- 应计已减值利息科目编号
    ,recvbl_int_paybl_adj_subj_id  -- 应收应付利息调整科目编号
    ,recvbl_uncol_int_subj_id  -- 应收未收利息科目编号
	,open_acct_timestamp  --开户时间
	,clos_acct_timestamp  --销户时间
    ,grace_period_pric  -- 宽限期本金
    ,grace_period_int  -- 宽限期利息
    ,out_acct_num  -- 出账号
    ,init_exp_dt  -- 原始到期日期
    ,abs_flg  -- 资产证券化标志
    ,asset_tran_flg  -- 资产转让标志
    ,recvbl_uncol_int  -- 应收未收利息_计量后
    ,int_recvbl  -- 应收利息
    ,non_acru_int_recvbl  -- 非应计应收利息_计量后
    ,acru_aldy_impam_int  -- 应计已减值利息
    ,fir_renew_exp_dt  -- 首次展期到期日
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- ETL处理日期
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id  -- 法人编号
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id  -- 账户编号
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name  -- 账户名称
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id  -- 客户编号
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id  -- 合同编号
    ,replace(replace(t.dubil_num,chr(13),''),chr(10),'') as dubil_num  -- 借据号
    ,replace(replace(t.loan_distr_acct_num,chr(13),''),chr(10),'') as loan_distr_acct_num  -- 贷款放款账号
    ,replace(replace(t.loan_repay_num,chr(13),''),chr(10),'') as loan_repay_num  -- 贷款还款账号
    ,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id  -- 标准产品编号
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id  -- 产品编号
    ,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id  -- 科目编号
    ,replace(replace(t.acctnt_cate_cd,chr(13),''),chr(10),'') as acctnt_cate_cd  -- 会计类别代码
    ,replace(replace(t.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id  -- 业务品种编号
    ,replace(replace(t.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd  -- 资产三分类代码
    ,replace(replace(t.loan_modal_cd,chr(13),''),chr(10),'') as loan_modal_cd  -- 贷款形态代码
    ,replace(replace(t.loan_acct_status_cd,chr(13),''),chr(10),'') as loan_acct_status_cd  -- 贷款账户状态代码
    ,replace(replace(t.unite_loan_cd,chr(13),''),chr(10),'') as unite_loan_cd  -- 联合贷款代码
    ,replace(replace(t.priv_loan_flg,chr(13),''),chr(10),'') as priv_loan_flg  -- 对私贷款标志
    ,replace(replace(t.promis_loan_flg,chr(13),''),chr(10),'') as promis_loan_flg  -- 承诺贷款标志
    ,replace(replace(t.circl_loan_flg,chr(13),''),chr(10),'') as circl_loan_flg  -- 循环贷款标志
    ,replace(replace(t.deriv_loan_flg,chr(13),''),chr(10),'') as deriv_loan_flg  -- 衍生贷款标志
    ,replace(replace(t.agent_loan_flg,chr(13),''),chr(10),'') as agent_loan_flg  -- 代理贷款标志
    ,replace(replace(t.oots_accti_flg,chr(13),''),chr(10),'') as oots_accti_flg  -- 按一逾两呆核算标志
    ,replace(replace(t.loan_modal_dg_subj_accti_flg,chr(13),''),chr(10),'') as loan_modal_dg_subj_accti_flg  -- 贷款形态分科目核算标志
    ,replace(replace(t.loan_tenor,chr(13),''),chr(10),'') as loan_tenor  -- 贷款期限
    ,replace(replace(t.loan_tenor_type_cd,chr(13),''),chr(10),'') as loan_tenor_type_cd  -- 贷款期限类型代码
    ,replace(replace(t.acru_non_acru_cd,chr(13),''),chr(10),'') as acru_non_acru_cd  -- 应计非应计代码
    ,t.final_fin_dt as final_fin_dt  -- 最后财务日期
    ,replace(replace(t.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id  -- 开户柜员编号
    ,replace(replace(t.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id  -- 销户柜员编号
    ,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id  -- 开户机构编号
    ,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id  -- 管理机构编号
    ,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id  -- 账务机构编号
    ,t.open_acct_dt as open_acct_dt  -- 开户日期
    ,t.distr_dt as distr_dt  -- 放款日期
    ,t.value_dt as value_dt  -- 起息日期
    ,t.exp_dt as exp_dt  -- 到期日期
    ,t.clos_acct_dt as clos_acct_dt  -- 销户日期
    ,replace(replace(t.int_sub_flg,chr(13),''),chr(10),'') as int_sub_flg  -- 贴息标志
    ,replace(replace(t.renew_flg,chr(13),''),chr(10),'') as renew_flg  -- 展期标志
    ,t.renew_cnt as renew_cnt  -- 展期次数
    ,replace(replace(t.int_accr_rule,chr(13),''),chr(10),'') as int_accr_rule  -- 计息规则
    ,replace(replace(t.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg  -- 计息标志
    ,replace(replace(t.comp_int_flg,chr(13),''),chr(10),'') as comp_int_flg  -- 复息标志
    ,replace(replace(t.pre_recv_int_way,chr(13),''),chr(10),'') as pre_recv_int_way  -- 预收息方式
    ,replace(replace(t.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd  -- 利率调整方式代码
    ,replace(replace(t.int_rat_base_type_cd,chr(13),''),chr(10),'') as int_rat_base_type_cd  -- 利率基准类型代码
    ,replace(replace(t.base_rat_id,chr(13),''),chr(10),'') as base_rat_id  -- 基准利率编号
    ,t.base_rat as base_rat  -- 基准利率
    ,t.exec_int_rat as exec_int_rat  -- 执行利率
    ,replace(replace(t.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd  -- 利率浮动方式代码
    ,replace(replace(t.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd  -- 利率调整周期单位代码
    ,t.int_rat_adj_ped_freq as int_rat_adj_ped_freq  -- 利率调整周期频率
    ,t.int_rat_flo_val as int_rat_flo_val  -- 利率浮动值
    ,t.curr_int_rat_effect_dt as curr_int_rat_effect_dt  -- 当前利率生效日期
    ,t.next_int_rat_adj_dt as next_int_rat_adj_dt  -- 下次利率调整日期
    ,replace(replace(t.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd  -- 结息方式代码
    ,replace(replace(t.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd  -- 计息方式代码
    ,replace(replace(t.ped_distr_flg,chr(13),''),chr(10),'') as ped_distr_flg  -- 周期性放款标志
    ,replace(replace(t.distr_way_cd,chr(13),''),chr(10),'') as distr_way_cd  -- 放款方式代码
    ,replace(replace(t.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd  -- 还款方式代码
    ,replace(replace(t.repay_ped_corp_cd,chr(13),''),chr(10),'') as repay_ped_corp_cd  -- 还款周期单位代码
    ,t.repay_ped as repay_ped  -- 还款周期
    ,replace(replace(t.allow_adv_repay_flg,chr(13),''),chr(10),'') as allow_adv_repay_flg  -- 允许提前还款标志
    ,replace(replace(t.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg  -- 核销标志
    ,replace(replace(t.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg  -- 逾期标志
    ,replace(replace(t.ovdue_int_accr_way_cd,chr(13),''),chr(10),'') as ovdue_int_accr_way_cd  -- 逾期计息方式代码
    ,replace(replace(t.ovdue_pnlt_float_way_cd,chr(13),''),chr(10),'') as ovdue_pnlt_float_way_cd  -- 逾期罚息浮动方式代码
    ,replace(replace(t.pric_ovdue_flg,chr(13),''),chr(10),'') as pric_ovdue_flg  -- 本金逾期标志
    ,replace(replace(t.int_ovdue_flg,chr(13),''),chr(10),'') as int_ovdue_flg  -- 利息逾期标志
    ,t.curr_ovdue_perds as curr_ovdue_perds  -- 当前逾期期数
    ,t.pric_ovdue_days as pric_ovdue_days  -- 本金逾期天数
    ,t.int_ovdue_days as int_ovdue_days  -- 利息逾期天数
    ,t.ovdue_pric_bal as ovdue_pric_bal  -- 逾期本金余额
    ,t.ovdue_int_amt as ovdue_int_amt  -- 逾期利息金额
    ,t.ovdue_comp_int_amt as ovdue_comp_int_amt  -- 逾期复利金额
    ,t.fir_ovdue_dt as fir_ovdue_dt  -- 首次逾期日期
    ,t.ovdue_int_rat as ovdue_int_rat  -- 逾期利率
    ,t.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val  -- 逾期利率浮动值
    ,t.tot_perds as tot_perds  -- 总期数
    ,t.curr_issue_perds as curr_issue_perds  -- 本期期数
    ,t.last_repay_dt as last_repay_dt  -- 上次还款日期
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd  -- 币种代码
    ,t.next_repay_dt as next_repay_dt  -- 下次还款日期
    ,t.next_rpp_amt as next_rpp_amt  -- 下次还本金额
    ,t.next_repay_int_amt as next_repay_int_amt  -- 下次还息金额
    ,t.cont_amt as cont_amt  -- 合同金额
    ,t.dubil_amt as dubil_amt  -- 借据金额
    ,t.distr_amt as distr_amt  -- 放款金额
    ,t.froz_distrd_amt as froz_distrd_amt  -- 冻结可发放金额
    ,t.distrd_amt as distrd_amt  -- 可发放金额
    ,t.td_acru_int as td_acru_int  -- 当日应计利息
    ,t.currt_acru_int as currt_acru_int  -- 当期应计利息
    ,t.nomal_pric as nomal_pric  -- 正常本金
    ,t.ovdue_pric as ovdue_pric  -- 逾期本金
    ,t.idle_pric as idle_pric  -- 呆滞本金
    ,t.bad_debt_pric as bad_debt_pric  -- 呆账本金
    ,t.loan_fund as loan_fund  -- 贷款基金
    ,t.recvbl_acru_int as recvbl_acru_int  -- 应收应计利息
    ,t.coll_acru_int as coll_acru_int  -- 催收应计利息
    ,t.recvbl_acru_pnlt as recvbl_acru_pnlt  -- 应收应计罚息
    ,t.coll_acru_pnlt as coll_acru_pnlt  -- 催收应计罚息
    ,t.recvbl_pnlt as recvbl_pnlt  -- 应收罚息
    ,t.coll_pnlt as coll_pnlt  -- 催收罚息
    ,t.acru_comp_int as acru_comp_int  -- 应计复息
    ,t.recvbl_comp_int as recvbl_comp_int  -- 应收复息
    ,t.acru_int_sub as acru_int_sub  -- 应计贴息
    ,t.recvbl_int_sub as recvbl_int_sub  -- 应收贴息
    ,t.amorted_int as amorted_int  -- 待摊利息
    ,t.wrt_off_pric as wrt_off_pric  -- 核销本金
    ,t.wrt_off_int as wrt_off_int  -- 核销利息
    ,t.int_income as int_income  -- 利息收入
    ,t.wrt_off_advc_fee_bal as wrt_off_advc_fee_bal  -- 核销垫付费余额
    ,t.wrt_off_advc_fee_amt as wrt_off_advc_fee_amt  -- 核销垫付费金额
    ,t.recvbl_fine as recvbl_fine  -- 应收罚金
    ,t.fine_inco as fine_inco  -- 罚金收入
    ,t.resv as resv  -- 准备金
    ,t.recvbl_over_int as recvbl_over_int  -- 应收欠息
    ,t.coll_over_int as coll_over_int  -- 催收欠息
    ,t.in_bs_int as in_bs_int  -- 表内利息
    ,t.off_bs_int as off_bs_int  -- 表外利息
    ,t.acm_recvbl_uncol_int_amt as acm_recvbl_uncol_int_amt  -- 累计应收未收利息金额
    ,t.repaid_pric as repaid_pric  -- 已偿还本金
    ,t.repaid_int as repaid_int  -- 已偿还利息
    ,t.repaid_pnlt as repaid_pnlt  -- 已偿还罚息
    ,t.repaid_comp_int as repaid_comp_int  -- 已偿还复利
    ,t.repaid_fee as repaid_fee  -- 已偿还费用
    ,t.pric_bal as pric_bal  -- 本金余额
    ,t.currt_bal as currt_bal  -- 当期余额
    ,t.cl_curr_currt_bal as cl_curr_currt_bal  -- 折本币当期余额
    ,t.ear_d_bal as ear_d_bal  -- 日初余额
    ,t.ear_m_bal as ear_m_bal  -- 月初余额
    ,t.ear_s_bal as ear_s_bal  -- 季初余额
    ,t.ear_y_bal as ear_y_bal  -- 年初余额
    ,t.y_acm_bal as y_acm_bal  -- 年累计余额
    ,t.s_acm_bal as s_acm_bal  -- 季累计余额
    ,t.m_acm_bal as m_acm_bal  -- 月累计余额
    ,t.cl_curr_ear_d_bal as cl_curr_ear_d_bal  -- 折本币日初余额
    ,t.cl_curr_ear_m_bal as cl_curr_ear_m_bal  -- 折本币月初余额
    ,t.cl_curr_ear_s_bal as cl_curr_ear_s_bal  -- 折本币季初余额
    ,t.cl_curr_ear_y_bal as cl_curr_ear_y_bal  -- 折本币年初余额
    ,t.cl_curr_y_acm_bal as cl_curr_y_acm_bal  -- 折本币年累计余额
    ,t.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,t.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,t.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,t.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,t.cl_curr_s_acm_bal as cl_curr_s_acm_bal  -- 折本币季累计余额
    ,t.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,t.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,t.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,t.cl_curr_m_acm_bal as cl_curr_m_acm_bal  -- 折本币月累计余额
    ,t.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,t.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,t.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,t.y_avg_bal as y_avg_bal  -- 年日均余额
    ,t.q_avg_bal as q_avg_bal  -- 季日均余额
    ,t.m_avg_bal as m_avg_bal  -- 月日均余额
    ,t.cl_curr_y_avg_bal as cl_curr_y_avg_bal  -- 折本币年日均余额
    ,t.cl_curr_q_avg_bal as cl_curr_q_avg_bal  -- 折本币季日均余额
    ,t.cl_curr_m_avg_bal as cl_curr_m_avg_bal  -- 折本币月日均余额
    ,replace(replace(t.init_pric_subj_id,chr(13),''),chr(10),'') as init_pric_subj_id  -- 原本金科目编号
    ,replace(replace(t.asset_tran_status_cd,chr(13),''),chr(10),'') as asset_tran_status_cd  -- 资产转让状态代码
    ,t.tran_bf_int_recvbl as tran_bf_int_recvbl  -- 转让前应收利息
    ,t.td_int_income as td_int_income  -- 当日利息收入
    ,replace(replace(t.in_bs_int_subj_id,chr(13),''),chr(10),'') as in_bs_int_subj_id  -- 表内利息科目编号
    ,replace(replace(t.off_bs_int_subj_id,chr(13),''),chr(10),'') as off_bs_int_subj_id  -- 表外利息科目编号
    ,replace(replace(t.int_income_subj_id,chr(13),''),chr(10),'') as int_income_subj_id  -- 利息收入科目编号
    ,replace(replace(t.int_income_adj_subj_id,chr(13),''),chr(10),'') as int_income_adj_subj_id  -- 利息收入调整科目编号
    ,t.td_int_income_adj as td_int_income_adj  -- 当日利息收入调整
    ,replace(replace(t.irr_repay_way_cd,chr(13),''),chr(10),'') as irr_repay_way_cd  -- 不规则还款方式代码
    ,t.renew_exp_dt as renew_exp_dt  -- 展期到期日期
    ,t.asset_tran_dt as asset_tran_dt  -- 资产转让日期
    ,t.pric_ovdue_dt as pric_ovdue_dt  -- 本金逾期日期
    ,t.int_ovdue_dt as int_ovdue_dt  -- 利息逾期日期
    ,replace(replace(t.loan_num,chr(13),''),chr(10),'') as loan_num  -- 贷款号
    ,replace(replace(t.acru_aldy_impam_int_subj_id,chr(13),''),chr(10),'') as acru_aldy_impam_int_subj_id  -- 应计已减值利息科目编号
    ,replace(replace(t.recvbl_int_paybl_adj_subj_id,chr(13),''),chr(10),'') as recvbl_int_paybl_adj_subj_id  -- 应收应付利息调整科目编号
    ,replace(replace(t.recvbl_uncol_int_subj_id,chr(13),''),chr(10),'') as recvbl_uncol_int_subj_id  -- 应收未收利息科目编号
	,t.open_acct_timestamp as open_acct_timestamp --开户时间
	,t.clos_acct_timestamp as clos_acct_timestamp --销户时间
    ,t.grace_period_pric as grace_period_pric --宽限期本金
    ,t.grace_period_int as grace_period_int --宽限期利息
    ,replace(replace(t.out_acct_num,chr(13),''),chr(10),'') as out_acct_num  -- 出账号
    ,t.init_exp_dt as init_exp_dt  -- 原始到期日期
    ,replace(replace(t.abs_flg,chr(13),''),chr(10),'') as abs_flg  -- 资产证券化标志
    ,replace(replace(t.asset_tran_flg,chr(13),''),chr(10),'') as asset_tran_flg  -- 资产转让标志
    ,t.recvbl_uncol_int as recvbl_uncol_int  -- 应收未收利息_计量后
    ,t.int_recvbl as int_recvbl  -- 应收利息
    ,t.non_acru_int_recvbl as non_acru_int_recvbl  -- 非应计应收利息_计量后
    ,t.acru_aldy_impam_int as acru_aldy_impam_int  -- 应计已减值利息
    ,t.fir_renew_exp_dt as fir_renew_exp_dt  -- 首次展期到期日
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_retl_loan_acct_info t--零售贷款账户信息
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.cmm_retl_loan_acct_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_retl_loan_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);