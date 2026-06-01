/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_acct_info_h
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_agt_loan_acct_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_acct_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_acct_info_h (
etl_dt  --数据日期
,acct_id  --账户编号
,loan_num  --贷款号
,prod_id  --产品编号
,acct_name  --账户名称
,curr_cd  --币种代码
,dubil_id  --借据编号
,distr_flow_num  --放款流水号
,open_acct_org_id  --开户机构编号
,cust_id  --客户编号
,open_acct_dt  --开户日期
,effect_dt  --生效日期
,fir_tran_dt  --首次交易日期
,acct_status_cd  --账户状态代码
,last_acct_status_cd  --上一账户状态代码
,acct_status_modif_dt  --账户状态变更日期
,accti_status_cd  --核算状态代码
,last_accti_status_cd  --上一核算状态代码
,accti_status_modif_dt  --核算状态变更日期
,clos_acct_dt  --销户日期
,clos_acct_rs  --销户原因
,init_open_acct_dt  --原始开户日期
,init_exp_dt  --原始到期日期
,cust_mgr_id  --客户经理编号
,bal_type_cd  --钞汇余额代码
,off_shore_flg  --离岸标志
,ftz_flg  --自贸区标志
,loan_tenor  --贷款期限
,tenor_type_cd  --期限类型代码
,exp_dt  --到期日期
,appl_org_id  --申请机构编号
,mgmt_org_id  --管理机构编号
,cust_name  --客户名称
,level5_cls_cd  --五级分类代码
,loan_rs_cd  --贷款原因代码
,acct_aldy_check_flg  --账户已复核标志
,check_dt  --复核日期
,repay_way_cd  --还款方式代码
,sub_plan_way_cd  --子计划方式代码
,open_acct_chn_id  --开户渠道编号
,src_module_type_cd  --源模块类型代码
,sob_cate_cd  --账套类别代码
,indv_bus_flg  --个体工商户标志
,int_accr_flg  --计息标志
,curr_pd  --当前期次
,final_tran_dt  --最后交易日期
,anew_create_repay_plan_flg  --重新生成还款计划标志
,init_prod_id  --原产品编号
,perds  --首段期数
,prog_intrv_perds  --累进间隔期数
,prog_amt  --累进金额
,prog_ratio  --累进比例
,loan_auto_repay_type_cd  --贷款自动还款类型代码
,loan_pric_repay_seq_num  --贷款本金还款顺序号
,loan_int_repay_seq_num  --贷款利息还款顺序号
,loan_pnlt_repay_seq_num  --贷款罚息还款顺序号
,loan_comp_int_repay_seq_num  --贷款复利还款顺序号
,loan_fee_repay_seq_num  --贷款费用还款顺序号
,earliest_ovdue_dt  --最早逾期日期
,need_manual_input_repay_plan_flg  --需要手工录入还款计划标志
,contri_ratio  --出资比例
,init_loan_num  --原贷款号
,init_distr_flow_num  --原放款流水号
,int_sub_closing_dt  --贴息截止日期
,chg_term_not_chg_lmt_final_chg_dt  --变期不变额最后变化日期
,ftz_acct_flg  --自贸区账户标志
,ftz_cd  --自贸区代码
,blon_loan_calc_pd  --气球贷计算期次
,camp_prod_id  --营销产品编号
,camp_prod_name  --营销产品名称
,eh_issue_plan_repay_amt  --每期计划还款金额
,loan_usage_cd  --贷款用途代码
,other_consm_descb  --其他消费描述
,repay_plan_modif_way_cd  --还款计划变更方式代码
,realtm_chase_capt_flg  --实时追缴标志
,wrt_off_post_auto_turn_money_flg  --核销后自动转款标志
,clos_acct_teller_id  --销户柜员编号
,check_teller_id  --复核柜员编号
,open_acct_teller_id  --开户柜员编号
,accrd_hours_int_rat  --按小时利率
,cust_econ_type_cd  --客户经济类型代码
,accrd_hours_file_flg_cd  --按小时靠档标志代码
,check_entry_code  --对账编码
,auto_comb_repay_flg  --自动组合还款标志
,free_int_closing_dt  --免息截止日期
,abs_flg  --资产证券化标志
,auto_revs_flg  --自动冲正标志
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num --贷款号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name --账户名称
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id --借据编号
,replace(replace(t1.distr_flow_num,chr(13),''),chr(10),'') as distr_flow_num --放款流水号
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id --开户机构编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,t1.open_acct_dt as open_acct_dt --开户日期
,t1.effect_dt as effect_dt --生效日期
,t1.fir_tran_dt as fir_tran_dt --首次交易日期
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd --账户状态代码
,replace(replace(t1.last_acct_status_cd,chr(13),''),chr(10),'') as last_acct_status_cd --上一账户状态代码
,t1.acct_status_modif_dt as acct_status_modif_dt --账户状态变更日期
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd --核算状态代码
,replace(replace(t1.last_accti_status_cd,chr(13),''),chr(10),'') as last_accti_status_cd --上一核算状态代码
,t1.accti_status_modif_dt as accti_status_modif_dt --核算状态变更日期
,t1.clos_acct_dt as clos_acct_dt --销户日期
,replace(replace(t1.clos_acct_rs,chr(13),''),chr(10),'') as clos_acct_rs --销户原因
,t1.init_open_acct_dt as init_open_acct_dt --原始开户日期
,t1.init_exp_dt as init_exp_dt --原始到期日期
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.bal_type_cd,chr(13),''),chr(10),'') as bal_type_cd --钞汇余额代码
,replace(replace(t1.off_shore_flg,chr(13),''),chr(10),'') as off_shore_flg --离岸标志
,replace(replace(t1.ftz_flg,chr(13),''),chr(10),'') as ftz_flg --自贸区标志
,t1.loan_tenor as loan_tenor --贷款期限
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd --期限类型代码
,t1.exp_dt as exp_dt --到期日期
,replace(replace(t1.appl_org_id,chr(13),''),chr(10),'') as appl_org_id --申请机构编号
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id --管理机构编号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd --五级分类代码
,replace(replace(t1.loan_rs_cd,chr(13),''),chr(10),'') as loan_rs_cd --贷款原因代码
,replace(replace(t1.acct_aldy_check_flg,chr(13),''),chr(10),'') as acct_aldy_check_flg --账户已复核标志
,t1.check_dt as check_dt --复核日期
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd --还款方式代码
,replace(replace(t1.sub_plan_way_cd,chr(13),''),chr(10),'') as sub_plan_way_cd --子计划方式代码
,replace(replace(t1.open_acct_chn_id,chr(13),''),chr(10),'') as open_acct_chn_id --开户渠道编号
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd --源模块类型代码
,replace(replace(t1.sob_cate_cd,chr(13),''),chr(10),'') as sob_cate_cd --账套类别代码
,replace(replace(t1.indv_bus_flg,chr(13),''),chr(10),'') as indv_bus_flg --个体工商户标志
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg --计息标志
,t1.curr_pd as curr_pd --当前期次
,t1.final_tran_dt as final_tran_dt --最后交易日期
,replace(replace(t1.anew_create_repay_plan_flg,chr(13),''),chr(10),'') as anew_create_repay_plan_flg --重新生成还款计划标志
,replace(replace(t1.init_prod_id,chr(13),''),chr(10),'') as init_prod_id --原产品编号
,t1.perds as perds --首段期数
,t1.prog_intrv_perds as prog_intrv_perds --累进间隔期数
,t1.prog_amt as prog_amt --累进金额
,t1.prog_ratio as prog_ratio --累进比例
,replace(replace(t1.loan_auto_repay_type_cd,chr(13),''),chr(10),'') as loan_auto_repay_type_cd --贷款自动还款类型代码
,replace(replace(t1.loan_pric_repay_seq_num,chr(13),''),chr(10),'') as loan_pric_repay_seq_num --贷款本金还款顺序号
,replace(replace(t1.loan_int_repay_seq_num,chr(13),''),chr(10),'') as loan_int_repay_seq_num --贷款利息还款顺序号
,replace(replace(t1.loan_pnlt_repay_seq_num,chr(13),''),chr(10),'') as loan_pnlt_repay_seq_num --贷款罚息还款顺序号
,replace(replace(t1.loan_comp_int_repay_seq_num,chr(13),''),chr(10),'') as loan_comp_int_repay_seq_num --贷款复利还款顺序号
,replace(replace(t1.loan_fee_repay_seq_num,chr(13),''),chr(10),'') as loan_fee_repay_seq_num --贷款费用还款顺序号
,t1.earliest_ovdue_dt as earliest_ovdue_dt --最早逾期日期
,replace(replace(t1.need_manual_input_repay_plan_flg,chr(13),''),chr(10),'') as need_manual_input_repay_plan_flg --需要手工录入还款计划标志
,t1.contri_ratio as contri_ratio --出资比例
,replace(replace(t1.init_loan_num,chr(13),''),chr(10),'') as init_loan_num --原贷款号
,replace(replace(t1.init_distr_flow_num,chr(13),''),chr(10),'') as init_distr_flow_num --原放款流水号
,t1.int_sub_closing_dt as int_sub_closing_dt --贴息截止日期
,t1.chg_term_not_chg_lmt_final_chg_dt as chg_term_not_chg_lmt_final_chg_dt --变期不变额最后变化日期
,replace(replace(t1.ftz_acct_flg,chr(13),''),chr(10),'') as ftz_acct_flg --自贸区账户标志
,replace(replace(t1.ftz_cd,chr(13),''),chr(10),'') as ftz_cd --自贸区代码
,t1.blon_loan_calc_pd as blon_loan_calc_pd --气球贷计算期次
,replace(replace(t1.camp_prod_id,chr(13),''),chr(10),'') as camp_prod_id --营销产品编号
,replace(replace(t1.camp_prod_name,chr(13),''),chr(10),'') as camp_prod_name --营销产品名称
,t1.eh_issue_plan_repay_amt as eh_issue_plan_repay_amt --每期计划还款金额
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd --贷款用途代码
,replace(replace(t1.other_consm_descb,chr(13),''),chr(10),'') as other_consm_descb --其他消费描述
,replace(replace(t1.repay_plan_modif_way_cd,chr(13),''),chr(10),'') as repay_plan_modif_way_cd --还款计划变更方式代码
,replace(replace(t1.realtm_chase_capt_flg,chr(13),''),chr(10),'') as realtm_chase_capt_flg --实时追缴标志
,replace(replace(t1.wrt_off_post_auto_turn_money_flg,chr(13),''),chr(10),'') as wrt_off_post_auto_turn_money_flg --核销后自动转款标志
,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id --销户柜员编号
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id --复核柜员编号
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id --开户柜员编号
,t1.accrd_hours_int_rat as accrd_hours_int_rat --按小时利率
,replace(replace(t1.cust_econ_type_cd,chr(13),''),chr(10),'') as cust_econ_type_cd --客户经济类型代码
,replace(replace(t1.accrd_hours_file_flg_cd,chr(13),''),chr(10),'') as accrd_hours_file_flg_cd --按小时靠档标志代码
,replace(replace(t1.check_entry_code,chr(13),''),chr(10),'') as check_entry_code --对账编码
,replace(replace(t1.auto_comb_repay_flg,chr(13),''),chr(10),'') as auto_comb_repay_flg --自动组合还款标志
,t1.free_int_closing_dt as free_int_closing_dt --免息截止日期
,replace(replace(t1.abs_flg,chr(13),''),chr(10),'') as abs_flg --资产证券化标志
,replace(replace(t1.auto_revs_flg,chr(13),''),chr(10),'') as auto_revs_flg --自动冲正标志
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_loan_acct_info_h t1    --贷款账户信息历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_acct_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
