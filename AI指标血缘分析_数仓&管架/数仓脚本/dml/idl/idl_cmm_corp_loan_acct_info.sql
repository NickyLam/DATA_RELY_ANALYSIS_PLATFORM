/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_cmm_corp_loan_acct_info
CreateDate: 20240902
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.cmm_corp_loan_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_corp_loan_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_corp_loan_acct_info (
etl_dt  --ETL处理日期
,lp_id  --法人编号
,acct_id  --账户编号
,acct_name  --账户名称
,cust_id  --客户编号
,cont_id  --合同编号
,dubil_num  --借据号
,loan_distr_acct_num  --贷款放款账号
,loan_repay_num  --贷款还款账号
,int_sub_ps_stl_acct_num  --贴息人结算账号
,entr_dep_acct_num  --委托存款账号
,csner_dep_acct_num  --委托人存款账号
,inpwn_acct_num_id  --质押账号ID
,out_acct_num  --出账号
,rela_bill_id  --关联票证编号
,std_prod_id  --标准产品编号
,prod_id  --产品编号
,subj_id  --科目编号
,int_subj_id  --表内利息科目编号
,loan_acct_status_cd  --贷款账户状态代码
,loan_tenor  --贷款期限
,loan_tenor_type_cd  --贷款期限类型代码
,loan_cate_cd  --贷款类别代码
,belong_bus_strip_line_cd  --所属业务条线代码
,guar_way_cd  --担保方式代码
,loan_usage_descb  --贷款用途描述
,acru_non_acru_cd  --应计非应计代码
,turn_non_acru_loan_dt  --转非应计贷款日期
,cust_mgr_id  --客户经理编号
,open_acct_org_id  --开户机构编号
,mgmt_org_id  --管理机构编号
,acct_instit_id  --账务机构编号
,open_acct_dt  --开户日期
,distr_dt  --放款日期
,value_dt  --起息日期
,stop_accr_int_dt  --停息日期
,exp_dt  --到期日期
,clos_acct_dt  --销户日期
,int_sub_flg  --贴息标志
,int_sub_ratio  --贴息比例
,int_sub_exp_day  --贴息到期日
,entr_loan_comm_fee_coll_way  --委托贷款手续费收取方式
,entr_loan_comm_fee_coll_ratio  --委托贷款手续费收取比例
,entr_loan_comm_fee  --委托贷款手续费
,stop_accr_int_flg  --停息标志
,impam_flg  --减值标志
,crdt_distr_repay_plan_flg  --信贷发放还款计划标志
,finc_prod_flg  --理财产品标志
,prepay_int_amort_flg  --预付利息摊销标志
,pric_auto_deduct_flg  --本金自动扣收标志
,int_auto_deduct_flg  --利息自动扣收标志
,acpt_flg  --承兑标志
,gover_fin_plat_loan_flg  --政府融资平台贷款标志
,tax_flg  --扣税标志
,wrt_off_flg  --核销标志
,renew_flg  --展期标志
,renew_cnt  --展期次数
,allow_adv_repay_flg  --允许提前还款标志
,repay_seq_no_cd  --还款次序代码
,adv_repay_way_cd  --提前还款方式代码
,margin_curr_cd  --保证金币种代码
,int_rat_base_type_cd  --利率基准类型代码
,int_rat_curve_type_cd  --利率曲线类型代码
,base_rat  --基准利率
,exec_int_rat  --执行利率
,int_rat_adj_way_cd  --利率调整方式代码
,int_rat_float_way_cd  --利率浮动方式代码
,int_rat_adj_ped_corp_cd  --利率调整周期单位代码
,int_rat_adj_ped_freq  --利率调整周期频率
,int_rat_flo_val  --利率浮动值
,curr_int_rat_effect_dt  --当前利率生效日期
,next_int_rat_adj_dt  --下次利率调整日期
,comp_int_flg  --复息标志
,int_set_way_cd  --结息方式代码
,int_accr_way_cd  --计息方式代码
,repay_way_cd  --还款方式代码
,repay_ped_corp_cd  --还款周期单位代码
,repay_ped  --还款周期
,money_use_type  --款项使用类型
,lmt_type  --额度类型
,ovdue_flg  --逾期标志
,pric_ovdue_flg  --本金逾期标志
,int_ovdue_flg  --利息逾期标志
,curr_ovdue_perds  --当前逾期期数
,pric_ovdue_days  --本金逾期天数
,int_ovdue_days  --利息逾期天数
,ovdue_pric_bal  --逾期本金余额
,ovdue_int_amt  --逾期利息金额
,ovdue_comp_int_amt  --逾期复利金额
,fir_ovdue_dt  --首次逾期日期
,ovdue_int_rat  --逾期利率
,ovdue_int_rat_flo_val  --逾期利率浮动值
,tot_perds  --总期数
,curr_issue_perds  --本期期数
,last_repay_dt  --上次还款日期
,next_repay_dt  --下次还款日期
,curr_cd  --币种代码
,next_rpp_amt  --下次还本金额
,next_repay_int_amt  --下次还息金额
,td_acru_int  --当日应计利息
,currt_acru_int  --当期应计利息
,cont_amt  --合同金额
,dubil_amt  --借据金额
,distr_amt  --放款金额
,nomal_pric  --正常本金
,ovdue_pric  --逾期本金
,idle_pric  --呆滞本金
,bad_debt_pric  --呆账本金
,recvbl_over_int  --应收欠息
,recvbl_acru_pnlt  --应收应计罚息
,recvbl_pnlt  --应收罚息
,acru_comp_int  --应计复息
,recvbl_comp_int  --应收复息
,recvbl_fee  --应收费用
,wrt_off_pric  --核销本金
,wrt_off_int  --核销利息
,in_bs_over_int_bal  --表内欠息余额
,off_bs_over_int_bal  --表外欠息余额
,in_bs_int  --表内利息
,off_bs_int  --表外利息
,acm_recvbl_uncol_int_amt  --累计应收未收利息金额
,repaid_pric  --已偿还本金
,repaid_int  --已偿还利息
,repaid_pnlt  --已偿还罚息
,repaid_comp_int  --已偿还复利
,repaid_fee  --已偿还费用
,pric_bal  --本金余额
,currt_bal  --当期余额
,cl_curr_currt_bal  --折本币当期余额
,ear_d_bal  --日初余额
,ear_m_bal  --月初余额
,ear_s_bal  --季初余额
,ear_y_bal  --年初余额
,y_acm_bal  --年累计余额
,s_acm_bal  --季累计余额
,m_acm_bal  --月累计余额
,cl_curr_ear_d_bal  --折本币日初余额
,cl_curr_ear_m_bal  --折本币月初余额
,cl_curr_ear_s_bal  --折本币季初余额
,cl_curr_ear_y_bal  --折本币年初余额
,cl_curr_y_acm_bal  --折本币年累计余额
,cl_curr_ear_d_y_acm_bal  --折本币日初年累计余额
,cl_curr_ear_m_y_acm_bal  --折本币月初年累计余额
,cl_curr_ear_s_y_acm_bal  --折本币季初年累计余额
,cl_curr_ear_y_y_acm_bal  --折本币年初年累计余额
,cl_curr_s_acm_bal  --折本币季累计余额
,cl_curr_ear_d_s_acm_bal  --折本币日初季累计余额
,cl_curr_ear_s_s_acm_bal  --折本币季初季累计余额
,cl_curr_ear_y_s_acm_bal  --折本币年初季累计余额
,cl_curr_m_acm_bal  --折本币月累计余额
,cl_curr_ear_d_m_acm_bal  --折本币日初月累计余额
,cl_curr_ear_m_m_acm_bal  --折本币月初月累计余额
,cl_curr_ear_y_m_acm_bal  --折本币年初月累计余额
,y_avg_bal  --年日均余额
,q_avg_bal  --季日均余额
,m_avg_bal  --月日均余额
,cl_curr_y_avg_bal  --折本币年日均余额
,cl_curr_q_avg_bal  --折本币季日均余额
,cl_curr_m_avg_bal  --折本币月日均余额
,off_bs_int_subj_id  --表外利息科目编号
,int_income_subj_id  --利息收入科目编号
,asset_thd_cls_cd  --资产三分类代码
,int_accr_flg  --计息标志
,init_pric_subj_id  --原本金科目编号
,asset_tran_status_cd  --资产转让状态代码
,tran_bf_int_recvbl  --转让前应收利息
,td_int_income  --当日利息收入
,int_income_adj_subj_id  --利息收入调整科目编号
,renew_exp_day  --展期到期日
,td_int_income_adj  --当日利息收入调整
,asset_tran_dt  --资产转让日期
,distr_flow_num  --放款流水号
,reval_way_cd  --重定价方式代码
,comn_loan_int_set_way_cd  --普通贷款结息方式代码
,pric_ovdue_dt  --本金逾期日期
,int_ovdue_dt  --利息逾期日期
,loan_num  --贷款号
,acru_aldy_impam_int_subj_id  --应计已减值利息科目编号
,recvbl_int_paybl_adj_subj_id  --应收应付利息调整科目编号
,recvbl_uncol_int_subj_id  --应收未收利息科目编号
,trade_fin_int_adj  --贸易融资利息调整
,grace_period_pric  --宽限期本金
,grace_period_int  --宽限期利息
,td_tax_income  --当日税额收入
,abs_flg  --资产证券化标志
,asset_tran_flg  --资产转让标志
,recvbl_uncol_int  --应收未收利息_计量后
,int_recvbl  --应收利息
,non_acru_int_recvbl  --非应计应收利息_计量后
,acru_aldy_impam_int  --应计已减值利息
,fir_renew_exp_dt  --首次展期到期日
,coll_acru_pnlt  --催收应计罚息
,coll_pnlt  --催收罚息
,init_exp_dt  --原始到期日期
,core_dubil_num  --核心借据号
,spd_pl_subj_id  --价差损益科目编号
,loan_modal_cd  --贷款形态代码
,open_acct_timestamp  --开户时间
,clos_acct_timestamp  --销户时间
,td_spd_pl  --当日价差损益
,wrt_off_advc_fee_amt  --核销垫付费金额

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name --账户名称
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合同编号
,replace(replace(t1.dubil_num,chr(13),''),chr(10),'') as dubil_num --借据号
,replace(replace(t1.loan_distr_acct_num,chr(13),''),chr(10),'') as loan_distr_acct_num --贷款放款账号
,replace(replace(t1.loan_repay_num,chr(13),''),chr(10),'') as loan_repay_num --贷款还款账号
,replace(replace(t1.int_sub_ps_stl_acct_num,chr(13),''),chr(10),'') as int_sub_ps_stl_acct_num --贴息人结算账号
,replace(replace(t1.entr_dep_acct_num,chr(13),''),chr(10),'') as entr_dep_acct_num --委托存款账号
,replace(replace(t1.csner_dep_acct_num,chr(13),''),chr(10),'') as csner_dep_acct_num --委托人存款账号
,replace(replace(t1.inpwn_acct_num_id,chr(13),''),chr(10),'') as inpwn_acct_num_id --质押账号ID
,replace(replace(t1.out_acct_num,chr(13),''),chr(10),'') as out_acct_num --出账号
,replace(replace(t1.rela_bill_id,chr(13),''),chr(10),'') as rela_bill_id --关联票证编号
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id --标准产品编号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id --科目编号
,replace(replace(t1.int_subj_id,chr(13),''),chr(10),'') as int_subj_id --表内利息科目编号
,replace(replace(t1.loan_acct_status_cd,chr(13),''),chr(10),'') as loan_acct_status_cd --贷款账户状态代码
,replace(replace(t1.loan_tenor,chr(13),''),chr(10),'') as loan_tenor --贷款期限
,replace(replace(t1.loan_tenor_type_cd,chr(13),''),chr(10),'') as loan_tenor_type_cd --贷款期限类型代码
,replace(replace(t1.loan_cate_cd,chr(13),''),chr(10),'') as loan_cate_cd --贷款类别代码
,replace(replace(t1.belong_bus_strip_line_cd,chr(13),''),chr(10),'') as belong_bus_strip_line_cd --所属业务条线代码
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd --担保方式代码
,replace(replace(t1.loan_usage_descb,chr(13),''),chr(10),'') as loan_usage_descb --贷款用途描述
,replace(replace(t1.acru_non_acru_cd,chr(13),''),chr(10),'') as acru_non_acru_cd --应计非应计代码
,t1.turn_non_acru_loan_dt as turn_non_acru_loan_dt --转非应计贷款日期
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id --开户机构编号
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id --管理机构编号
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id --账务机构编号
,t1.open_acct_dt as open_acct_dt --开户日期
,t1.distr_dt as distr_dt --放款日期
,t1.value_dt as value_dt --起息日期
,t1.stop_accr_int_dt as stop_accr_int_dt --停息日期
,t1.exp_dt as exp_dt --到期日期
,t1.clos_acct_dt as clos_acct_dt --销户日期
,replace(replace(t1.int_sub_flg,chr(13),''),chr(10),'') as int_sub_flg --贴息标志
,t1.int_sub_ratio as int_sub_ratio --贴息比例
,t1.int_sub_exp_day as int_sub_exp_day --贴息到期日
,replace(replace(t1.entr_loan_comm_fee_coll_way,chr(13),''),chr(10),'') as entr_loan_comm_fee_coll_way --委托贷款手续费收取方式
,t1.entr_loan_comm_fee_coll_ratio as entr_loan_comm_fee_coll_ratio --委托贷款手续费收取比例
,t1.entr_loan_comm_fee as entr_loan_comm_fee --委托贷款手续费
,replace(replace(t1.stop_accr_int_flg,chr(13),''),chr(10),'') as stop_accr_int_flg --停息标志
,replace(replace(t1.impam_flg,chr(13),''),chr(10),'') as impam_flg --减值标志
,replace(replace(t1.crdt_distr_repay_plan_flg,chr(13),''),chr(10),'') as crdt_distr_repay_plan_flg --信贷发放还款计划标志
,replace(replace(t1.finc_prod_flg,chr(13),''),chr(10),'') as finc_prod_flg --理财产品标志
,replace(replace(t1.prepay_int_amort_flg,chr(13),''),chr(10),'') as prepay_int_amort_flg --预付利息摊销标志
,replace(replace(t1.pric_auto_deduct_flg,chr(13),''),chr(10),'') as pric_auto_deduct_flg --本金自动扣收标志
,replace(replace(t1.int_auto_deduct_flg,chr(13),''),chr(10),'') as int_auto_deduct_flg --利息自动扣收标志
,replace(replace(t1.acpt_flg,chr(13),''),chr(10),'') as acpt_flg --承兑标志
,replace(replace(t1.gover_fin_plat_loan_flg,chr(13),''),chr(10),'') as gover_fin_plat_loan_flg --政府融资平台贷款标志
,replace(replace(t1.tax_flg,chr(13),''),chr(10),'') as tax_flg --扣税标志
,replace(replace(t1.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg --核销标志
,replace(replace(t1.renew_flg,chr(13),''),chr(10),'') as renew_flg --展期标志
,t1.renew_cnt as renew_cnt --展期次数
,replace(replace(t1.allow_adv_repay_flg,chr(13),''),chr(10),'') as allow_adv_repay_flg --允许提前还款标志
,replace(replace(t1.repay_seq_no_cd,chr(13),''),chr(10),'') as repay_seq_no_cd --还款次序代码
,replace(replace(t1.adv_repay_way_cd,chr(13),''),chr(10),'') as adv_repay_way_cd --提前还款方式代码
,replace(replace(t1.margin_curr_cd,chr(13),''),chr(10),'') as margin_curr_cd --保证金币种代码
,replace(replace(t1.int_rat_base_type_cd,chr(13),''),chr(10),'') as int_rat_base_type_cd --利率基准类型代码
,replace(replace(t1.int_rat_curve_type_cd,chr(13),''),chr(10),'') as int_rat_curve_type_cd --利率曲线类型代码
,t1.base_rat as base_rat --基准利率
,t1.exec_int_rat as exec_int_rat --执行利率
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率调整方式代码
,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd --利率浮动方式代码
,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd --利率调整周期单位代码
,t1.int_rat_adj_ped_freq as int_rat_adj_ped_freq --利率调整周期频率
,t1.int_rat_flo_val as int_rat_flo_val --利率浮动值
,t1.curr_int_rat_effect_dt as curr_int_rat_effect_dt --当前利率生效日期
,t1.next_int_rat_adj_dt as next_int_rat_adj_dt --下次利率调整日期
,replace(replace(t1.comp_int_flg,chr(13),''),chr(10),'') as comp_int_flg --复息标志
,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd --结息方式代码
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd --计息方式代码
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd --还款方式代码
,replace(replace(t1.repay_ped_corp_cd,chr(13),''),chr(10),'') as repay_ped_corp_cd --还款周期单位代码
,t1.repay_ped as repay_ped --还款周期
,replace(replace(t1.money_use_type,chr(13),''),chr(10),'') as money_use_type --款项使用类型
,replace(replace(t1.lmt_type,chr(13),''),chr(10),'') as lmt_type --额度类型
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg --逾期标志
,replace(replace(t1.pric_ovdue_flg,chr(13),''),chr(10),'') as pric_ovdue_flg --本金逾期标志
,replace(replace(t1.int_ovdue_flg,chr(13),''),chr(10),'') as int_ovdue_flg --利息逾期标志
,t1.curr_ovdue_perds as curr_ovdue_perds --当前逾期期数
,t1.pric_ovdue_days as pric_ovdue_days --本金逾期天数
,t1.int_ovdue_days as int_ovdue_days --利息逾期天数
,t1.ovdue_pric_bal as ovdue_pric_bal --逾期本金余额
,t1.ovdue_int_amt as ovdue_int_amt --逾期利息金额
,t1.ovdue_comp_int_amt as ovdue_comp_int_amt --逾期复利金额
,t1.fir_ovdue_dt as fir_ovdue_dt --首次逾期日期
,t1.ovdue_int_rat as ovdue_int_rat --逾期利率
,t1.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val --逾期利率浮动值
,t1.tot_perds as tot_perds --总期数
,t1.curr_issue_perds as curr_issue_perds --本期期数
,t1.last_repay_dt as last_repay_dt --上次还款日期
,t1.next_repay_dt as next_repay_dt --下次还款日期
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.next_rpp_amt as next_rpp_amt --下次还本金额
,t1.next_repay_int_amt as next_repay_int_amt --下次还息金额
,t1.td_acru_int as td_acru_int --当日应计利息
,t1.currt_acru_int as currt_acru_int --当期应计利息
,t1.cont_amt as cont_amt --合同金额
,t1.dubil_amt as dubil_amt --借据金额
,t1.distr_amt as distr_amt --放款金额
,t1.nomal_pric as nomal_pric --正常本金
,t1.ovdue_pric as ovdue_pric --逾期本金
,t1.idle_pric as idle_pric --呆滞本金
,t1.bad_debt_pric as bad_debt_pric --呆账本金
,t1.recvbl_over_int as recvbl_over_int --应收欠息
,t1.recvbl_acru_pnlt as recvbl_acru_pnlt --应收应计罚息
,t1.recvbl_pnlt as recvbl_pnlt --应收罚息
,t1.acru_comp_int as acru_comp_int --应计复息
,t1.recvbl_comp_int as recvbl_comp_int --应收复息
,t1.recvbl_fee as recvbl_fee --应收费用
,t1.wrt_off_pric as wrt_off_pric --核销本金
,t1.wrt_off_int as wrt_off_int --核销利息
,t1.in_bs_over_int_bal as in_bs_over_int_bal --表内欠息余额
,t1.off_bs_over_int_bal as off_bs_over_int_bal --表外欠息余额
,t1.in_bs_int as in_bs_int --表内利息
,t1.off_bs_int as off_bs_int --表外利息
,t1.acm_recvbl_uncol_int_amt as acm_recvbl_uncol_int_amt --累计应收未收利息金额
,t1.repaid_pric as repaid_pric --已偿还本金
,t1.repaid_int as repaid_int --已偿还利息
,t1.repaid_pnlt as repaid_pnlt --已偿还罚息
,t1.repaid_comp_int as repaid_comp_int --已偿还复利
,t1.repaid_fee as repaid_fee --已偿还费用
,t1.pric_bal as pric_bal --本金余额
,t1.currt_bal as currt_bal --当期余额
,t1.cl_curr_currt_bal as cl_curr_currt_bal --折本币当期余额
,t1.ear_d_bal as ear_d_bal --日初余额
,t1.ear_m_bal as ear_m_bal --月初余额
,t1.ear_s_bal as ear_s_bal --季初余额
,t1.ear_y_bal as ear_y_bal --年初余额
,t1.y_acm_bal as y_acm_bal --年累计余额
,t1.s_acm_bal as s_acm_bal --季累计余额
,t1.m_acm_bal as m_acm_bal --月累计余额
,t1.cl_curr_ear_d_bal as cl_curr_ear_d_bal --折本币日初余额
,t1.cl_curr_ear_m_bal as cl_curr_ear_m_bal --折本币月初余额
,t1.cl_curr_ear_s_bal as cl_curr_ear_s_bal --折本币季初余额
,t1.cl_curr_ear_y_bal as cl_curr_ear_y_bal --折本币年初余额
,t1.cl_curr_y_acm_bal as cl_curr_y_acm_bal --折本币年累计余额
,t1.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal --折本币日初年累计余额
,t1.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal --折本币月初年累计余额
,t1.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal --折本币季初年累计余额
,t1.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal --折本币年初年累计余额
,t1.cl_curr_s_acm_bal as cl_curr_s_acm_bal --折本币季累计余额
,t1.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal --折本币日初季累计余额
,t1.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal --折本币季初季累计余额
,t1.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal --折本币年初季累计余额
,t1.cl_curr_m_acm_bal as cl_curr_m_acm_bal --折本币月累计余额
,t1.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal --折本币日初月累计余额
,t1.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal --折本币月初月累计余额
,t1.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal --折本币年初月累计余额
,t1.y_avg_bal as y_avg_bal --年日均余额
,t1.q_avg_bal as q_avg_bal --季日均余额
,t1.m_avg_bal as m_avg_bal --月日均余额
,t1.cl_curr_y_avg_bal as cl_curr_y_avg_bal --折本币年日均余额
,t1.cl_curr_q_avg_bal as cl_curr_q_avg_bal --折本币季日均余额
,t1.cl_curr_m_avg_bal as cl_curr_m_avg_bal --折本币月日均余额
,replace(replace(t1.off_bs_int_subj_id,chr(13),''),chr(10),'') as off_bs_int_subj_id --表外利息科目编号
,replace(replace(t1.int_income_subj_id,chr(13),''),chr(10),'') as int_income_subj_id --利息收入科目编号
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd --资产三分类代码
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg --计息标志
,replace(replace(t1.init_pric_subj_id,chr(13),''),chr(10),'') as init_pric_subj_id --原本金科目编号
,replace(replace(t1.asset_tran_status_cd,chr(13),''),chr(10),'') as asset_tran_status_cd --资产转让状态代码
,t1.tran_bf_int_recvbl as tran_bf_int_recvbl --转让前应收利息
,t1.td_int_income as td_int_income --当日利息收入
,replace(replace(t1.int_income_adj_subj_id,chr(13),''),chr(10),'') as int_income_adj_subj_id --利息收入调整科目编号
,t1.renew_exp_day as renew_exp_day --展期到期日
,t1.td_int_income_adj as td_int_income_adj --当日利息收入调整
,t1.asset_tran_dt as asset_tran_dt --资产转让日期
,replace(replace(t1.distr_flow_num,chr(13),''),chr(10),'') as distr_flow_num --放款流水号
,replace(replace(t1.reval_way_cd,chr(13),''),chr(10),'') as reval_way_cd --重定价方式代码
,replace(replace(t1.comn_loan_int_set_way_cd,chr(13),''),chr(10),'') as comn_loan_int_set_way_cd --普通贷款结息方式代码
,t1.pric_ovdue_dt as pric_ovdue_dt --本金逾期日期
,t1.int_ovdue_dt as int_ovdue_dt --利息逾期日期
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num --贷款号
,replace(replace(t1.acru_aldy_impam_int_subj_id,chr(13),''),chr(10),'') as acru_aldy_impam_int_subj_id --应计已减值利息科目编号
,replace(replace(t1.recvbl_int_paybl_adj_subj_id,chr(13),''),chr(10),'') as recvbl_int_paybl_adj_subj_id --应收应付利息调整科目编号
,replace(replace(t1.recvbl_uncol_int_subj_id,chr(13),''),chr(10),'') as recvbl_uncol_int_subj_id --应收未收利息科目编号
,t1.trade_fin_int_adj as trade_fin_int_adj --贸易融资利息调整
,t1.grace_period_pric as grace_period_pric --宽限期本金
,t1.grace_period_int as grace_period_int --宽限期利息
,t1.td_tax_income as td_tax_income --当日税额收入
,replace(replace(t1.abs_flg,chr(13),''),chr(10),'') as abs_flg --资产证券化标志
,replace(replace(t1.asset_tran_flg,chr(13),''),chr(10),'') as asset_tran_flg --资产转让标志
,t1.recvbl_uncol_int as recvbl_uncol_int --应收未收利息_计量后
,t1.int_recvbl as int_recvbl --应收利息
,t1.non_acru_int_recvbl as non_acru_int_recvbl --非应计应收利息_计量后
,t1.acru_aldy_impam_int as acru_aldy_impam_int --应计已减值利息
,t1.fir_renew_exp_dt as fir_renew_exp_dt --首次展期到期日
,t1.coll_acru_pnlt as coll_acru_pnlt --催收应计罚息
,t1.coll_pnlt as coll_pnlt --催收罚息
,t1.init_exp_dt as init_exp_dt --原始到期日期
,replace(replace(t1.core_dubil_num,chr(13),''),chr(10),'') as core_dubil_num --核心借据号
,replace(replace(t1.spd_pl_subj_id,chr(13),''),chr(10),'') as spd_pl_subj_id --价差损益科目编号
,replace(replace(t1.loan_modal_cd,chr(13),''),chr(10),'') as loan_modal_cd --贷款形态代码
,t1.open_acct_timestamp as open_acct_timestamp --开户时间
,t1.clos_acct_timestamp as clos_acct_timestamp --销户时间
,t1.td_spd_pl as td_spd_pl --当日价差损益
,t1.wrt_off_advc_fee_amt as wrt_off_advc_fee_amt --核销垫付费金额
from ${icl_schema}.cmm_corp_loan_acct_info t1    --对公贷款账户信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_corp_loan_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
