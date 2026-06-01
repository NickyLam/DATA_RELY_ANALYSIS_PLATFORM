/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_loan_acct_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_loan_acct_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_loan_acct_info_h(
etl_dt date --数据日期
,acct_id varchar2(100) --账户编号
,loan_num varchar2(60) --贷款号
,prod_id varchar2(100) --产品编号
,acct_name varchar2(500) --账户名称
,curr_cd varchar2(30) --币种代码
,dubil_id varchar2(100) --借据编号
,distr_flow_num varchar2(100) --放款流水号
,open_acct_org_id varchar2(100) --开户机构编号
,cust_id varchar2(100) --客户编号
,open_acct_dt date --开户日期
,effect_dt date --生效日期
,fir_tran_dt date --首次交易日期
,acct_status_cd varchar2(30) --账户状态代码
,last_acct_status_cd varchar2(30) --上一账户状态代码
,acct_status_modif_dt date --账户状态变更日期
,accti_status_cd varchar2(30) --核算状态代码
,last_accti_status_cd varchar2(30) --上一核算状态代码
,accti_status_modif_dt date --核算状态变更日期
,clos_acct_dt date --销户日期
,clos_acct_rs varchar2(500) --销户原因
,init_open_acct_dt date --原始开户日期
,init_exp_dt date --原始到期日期
,cust_mgr_id varchar2(100) --客户经理编号
,bal_type_cd varchar2(30) --钞汇余额代码
,off_shore_flg varchar2(10) --离岸标志
,ftz_flg varchar2(10) --自贸区标志
,loan_tenor number(10,0) --贷款期限
,tenor_type_cd varchar2(30) --期限类型代码
,exp_dt date --到期日期
,appl_org_id varchar2(100) --申请机构编号
,mgmt_org_id varchar2(100) --管理机构编号
,cust_name varchar2(500) --客户名称
,level5_cls_cd varchar2(30) --五级分类代码
,loan_rs_cd varchar2(30) --贷款原因代码
,acct_aldy_check_flg varchar2(10) --账户已复核标志
,check_dt date --复核日期
,repay_way_cd varchar2(30) --还款方式代码
,sub_plan_way_cd varchar2(30) --子计划方式代码
,open_acct_chn_id varchar2(100) --开户渠道编号
,src_module_type_cd varchar2(30) --源模块类型代码
,sob_cate_cd varchar2(30) --账套类别代码
,indv_bus_flg varchar2(10) --个体工商户标志
,int_accr_flg varchar2(10) --计息标志
,curr_pd number(10,0) --当前期次
,final_tran_dt date --最后交易日期
,anew_create_repay_plan_flg varchar2(10) --重新生成还款计划标志
,init_prod_id varchar2(100) --原产品编号
,perds number(10,0) --首段期数
,prog_intrv_perds number(10,0) --累进间隔期数
,prog_amt number(30,2) --累进金额
,prog_ratio number(18,6) --累进比例
,loan_auto_repay_type_cd varchar2(30) --贷款自动还款类型代码
,loan_pric_repay_seq_num varchar2(60) --贷款本金还款顺序号
,loan_int_repay_seq_num varchar2(60) --贷款利息还款顺序号
,loan_pnlt_repay_seq_num varchar2(60) --贷款罚息还款顺序号
,loan_comp_int_repay_seq_num varchar2(60) --贷款复利还款顺序号
,loan_fee_repay_seq_num varchar2(60) --贷款费用还款顺序号
,earliest_ovdue_dt date --最早逾期日期
,need_manual_input_repay_plan_flg varchar2(10) --需要手工录入还款计划标志
,contri_ratio number(18,6) --出资比例
,init_loan_num varchar2(60) --原贷款号
,init_distr_flow_num varchar2(100) --原放款流水号
,int_sub_closing_dt date --贴息截止日期
,chg_term_not_chg_lmt_final_chg_dt date --变期不变额最后变化日期
,ftz_acct_flg varchar2(10) --自贸区账户标志
,ftz_cd varchar2(30) --自贸区代码
,blon_loan_calc_pd number(10,0) --气球贷计算期次
,camp_prod_id varchar2(100) --营销产品编号
,camp_prod_name varchar2(500) --营销产品名称
,eh_issue_plan_repay_amt number(30,2) --每期计划还款金额
,loan_usage_cd varchar2(30) --贷款用途代码
,other_consm_descb varchar2(500) --其他消费描述
,repay_plan_modif_way_cd varchar2(30) --还款计划变更方式代码
,realtm_chase_capt_flg varchar2(10) --实时追缴标志
,wrt_off_post_auto_turn_money_flg varchar2(10) --核销后自动转款标志
,clos_acct_teller_id varchar2(100) --销户柜员编号
,check_teller_id varchar2(100) --复核柜员编号
,open_acct_teller_id varchar2(100) --开户柜员编号
,accrd_hours_int_rat number(18,8) --按小时利率
,cust_econ_type_cd varchar2(30) --客户经济类型代码
,accrd_hours_file_flg_cd varchar2(30) --按小时靠档标志代码
,check_entry_code varchar2(60) --对账编码
,auto_comb_repay_flg varchar2(10) --自动组合还款标志
,free_int_closing_dt date --免息截止日期
,abs_flg varchar2(10) --资产证券化标志
,auto_revs_flg varchar2(10) --自动冲正标志
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(250) --协议编号
,lp_id varchar2(100) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_loan_acct_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_loan_acct_info_h is '贷款账户信息历史';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.acct_id is '账户编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.loan_num is '贷款号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.prod_id is '产品编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.acct_name is '账户名称';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.dubil_id is '借据编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.distr_flow_num is '放款流水号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.open_acct_dt is '开户日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.effect_dt is '生效日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.fir_tran_dt is '首次交易日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.acct_status_cd is '账户状态代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.last_acct_status_cd is '上一账户状态代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.acct_status_modif_dt is '账户状态变更日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.accti_status_cd is '核算状态代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.last_accti_status_cd is '上一核算状态代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.accti_status_modif_dt is '核算状态变更日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.clos_acct_dt is '销户日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.clos_acct_rs is '销户原因';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.init_open_acct_dt is '原始开户日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.init_exp_dt is '原始到期日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.bal_type_cd is '钞汇余额代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.off_shore_flg is '离岸标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.ftz_flg is '自贸区标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.loan_tenor is '贷款期限';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.tenor_type_cd is '期限类型代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.exp_dt is '到期日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.appl_org_id is '申请机构编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.mgmt_org_id is '管理机构编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.cust_name is '客户名称';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.level5_cls_cd is '五级分类代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.loan_rs_cd is '贷款原因代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.acct_aldy_check_flg is '账户已复核标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.check_dt is '复核日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.repay_way_cd is '还款方式代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.sub_plan_way_cd is '子计划方式代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.open_acct_chn_id is '开户渠道编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.src_module_type_cd is '源模块类型代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.sob_cate_cd is '账套类别代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.indv_bus_flg is '个体工商户标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.int_accr_flg is '计息标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.curr_pd is '当前期次';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.final_tran_dt is '最后交易日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.anew_create_repay_plan_flg is '重新生成还款计划标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.init_prod_id is '原产品编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.perds is '首段期数';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.prog_intrv_perds is '累进间隔期数';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.prog_amt is '累进金额';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.prog_ratio is '累进比例';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.loan_auto_repay_type_cd is '贷款自动还款类型代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.loan_pric_repay_seq_num is '贷款本金还款顺序号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.loan_int_repay_seq_num is '贷款利息还款顺序号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.loan_pnlt_repay_seq_num is '贷款罚息还款顺序号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.loan_comp_int_repay_seq_num is '贷款复利还款顺序号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.loan_fee_repay_seq_num is '贷款费用还款顺序号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.earliest_ovdue_dt is '最早逾期日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.need_manual_input_repay_plan_flg is '需要手工录入还款计划标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.contri_ratio is '出资比例';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.init_loan_num is '原贷款号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.init_distr_flow_num is '原放款流水号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.int_sub_closing_dt is '贴息截止日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.chg_term_not_chg_lmt_final_chg_dt is '变期不变额最后变化日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.ftz_acct_flg is '自贸区账户标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.ftz_cd is '自贸区代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.blon_loan_calc_pd is '气球贷计算期次';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.camp_prod_id is '营销产品编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.camp_prod_name is '营销产品名称';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.eh_issue_plan_repay_amt is '每期计划还款金额';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.loan_usage_cd is '贷款用途代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.other_consm_descb is '其他消费描述';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.repay_plan_modif_way_cd is '还款计划变更方式代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.realtm_chase_capt_flg is '实时追缴标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.wrt_off_post_auto_turn_money_flg is '核销后自动转款标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.clos_acct_teller_id is '销户柜员编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.check_teller_id is '复核柜员编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.open_acct_teller_id is '开户柜员编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.accrd_hours_int_rat is '按小时利率';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.cust_econ_type_cd is '客户经济类型代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.accrd_hours_file_flg_cd is '按小时靠档标志代码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.check_entry_code is '对账编码';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.auto_comb_repay_flg is '自动组合还款标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.free_int_closing_dt is '免息截止日期';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.abs_flg is '资产证券化标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.auto_revs_flg is '自动冲正标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_loan_acct_info_h.lp_id is '法人编号';

