/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_agt_loan_cont_info_h
CreateDate: 20250314
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.agt_loan_cont_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.agt_loan_cont_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.agt_loan_cont_info_h (
etl_dt  --数据日期
,agt_id  --协议编号
,lp_id  --法人编号
,cont_id  --合同编号
,apv_flow_num  --审批流水号
,rela_cont_id  --关联合同编号
,text_cont_id  --文本合同编号
,cust_id  --客户编号
,cust_name  --客户名称
,lmt_cont_flg  --额度合同标志
,rela_old_cont_id  --关联旧合同编号
,appl_way_cd  --申请方式代码
,loan_distr_type_cd  --贷款发放类型代码
,distr_mode_pay_cd  --放款支付方式代码
,happ_dt  --发生日期
,curr_cd  --币种代码
,cont_amt  --合同金额
,actl_out_acct_amt  --实际出账金额
,out_acct_dt  --出账日期
,base_prod_id  --基础产品编号
,prod_id  --产品编号
,mon_tenor  --月期限
,day_tenor  --日期限
,cont_effect_dt  --合同生效日期
,cont_exp_dt  --合同到期日期
,lmt_circl_flg  --循环贷款标志
,risk_type_cd  --风险类型代码
,low_risk_bus_flg  --低风险业务标志
,remote_bus_flg  --异地业务标志
,int_rat_mode_cd  --利率模式代码
,fix_int_rat  --固定利率
,base_rat_type_cd  --基准利率类型代码
,base_rat  --基准利率
,int_rat_float_type_cd  --利率浮动类型代码
,int_rat_adj_way_cd  --利率调整方式代码
,int_rat_flo_val  --利率浮动值
,exec_int_rat  --执行利率
,main_guar_way_cd  --主担保方式代码
,supp_guar_way_flg  --追加担保方式标志
,other_cond_descb  --其他条件描述
,guar_way_cd_two  --担保方式代码二
,guar_way_cd_three  --担保方式代码三
,repay_way_cd  --还款方式代码
,sub_guar_way_cd  --子担保方式代码
,repay_ped  --还款周期
,repay_ped_cd  --还款周期单位代码
,deflt_repay_day  --默认还款日
,stl_acct_id  --结算账户编号
,crdt_dir_cd  --授信投向代码
,nat_std_indus_dir_cd  --国标行业投向代码
,bank_int_indus_dir_cd  --行内行业投向代码
,usage_descb  --用途描述
,data_input_integy_flg  --数据录入已完善标志
,rsrv_amt  --预留金额
,curr_bal  --当前余额
,nomal_bal  --正常余额
,loan_ovdue_amt  --贷款逾期金额
,idle_bal  --呆滞余额
,bad_debt_bal  --呆账余额
,in_bs_over_int_bal  --表内欠息余额
,off_bs_over_int_bal  --表外欠息余额
,ovdue_pnlt_bal  --逾期罚息余额
,comp_int_bal  --复息余额
,loan_ovdue_days  --贷款逾期天数
,over_int_days  --欠息天数
,wrt_off_pric  --核销本金
,wrt_off_int  --核销利息
,pre_loss_amt  --预测损失金额
,fir_idtfy_non_dt  --首次认定不良日期
,cont_status_cd  --合同状态代码
,effect_dt  --生效日期
,termnt_dt  --终止日期
,payoff_flg  --结清标志
,off_bs_flg  --表外标志
,onl_bus_flg  --线上业务标志
,belong_strip_line_cd  --所属条线代码
,apv_status_cd  --审批状态代码
,lmt_id  --额度编号
,oper_teller_id  --业务经办人编号
,oper_org_id  --经办机构编号
,oper_dt  --经办日期
,rgst_teller_id  --登记柜员编号
,rgst_org_id  --登记机构编号
,rgst_dt  --登记日期
,update_teller_id  --更新柜员编号
,update_org_id  --更新机构编号
,modif_dt  --变更日期
,spec_ped_corp_cd  --指定周期单位代码
,spec_ped_cd  --指定周期代码
,b_renew_exp_dt  --展期前到期日期
,b_renew_amt  --展期前金额
,b_renew_exec_year_int_rat  --展期前执行年利率
,hxb_rela_party_flg  --我行关联方标志
,loan_usage_cd  --贷款用途代码
,int_rat_adj_ped_cd  --利率调整周期代码
,lmt_open_amt  --额度敞口金额
,occu_lmt  --已占用额度
,margin_curr_cd  --保证金币种代码
,margin_ratio  --保证金比例
,margin_amt  --保证金金额
,open_amt  --敞口金额
,open_amt_stat  --敞口金额统计
,lmt_cont_id  --额度合同编号
,exec_mon_int_rat  --执行月利率
,asset_thd_cls_cd  --资产三分类代码
,level5_cls_cd  --五级分类代码
,level5_cls_dt  --五级分类日期
,level11_cls_cd  --十一级分类代码
,lon_post_mgmt_teller_id  --贷后管理柜员编号
,lon_post_mgmt_org_id  --贷后管理机构编号
,file_dt  --归档日期
,froz_flg  --冻结状态代码
,ovdue_exec_int_rat  --逾期执行利率
,ovdue_int_rat_float_way_cd  --逾期利率浮动方式代码
,ovdue_int_rat_flo_val  --逾期利率浮动值
,core_out_acct_org_id  --核心出账机构编号
,stl_acct_name  --结算账户名称
,enter_id  --入账账户编号
,enter_name  --入账账户名称
,enter_open_acct_org_id  --入账账户开户机构编号
,backup_status_cd  --备份状态代码
,backup_lmt_cont_id  --备份额度合同编号
,comm_fee_rat  --手续费率
,move_remark  --迁移备注
,strtg_new_indus_type_cd  --战略新兴产业类型代码
,high_new_tech_corp_flg  --高新技术企业标志
,scen_tech_corp_flg  --科技企业标志
,tech_inovt_corp_flg  --科创企业标志
,xxd_camp_lmt_flg  --新兴贷营销额度标志
,provi_for_aged_property_flg  --养老产业标志
,seed_loan_flg  --种业振兴贷款标志
,county_loan_flg  --县城城区贷款标志
,high_tech_property_flg  --投向高技术产业标志
,digit_econ_core_type_cd  --数字经济核心产业类型代码
,remark  --备注
,prod_gen_id  --产品大类编号
,tran_bf_prod_id  --转换前产品编号
,tran_bf_cust_id  --转换前客户编号
,attach_rgst_bus_type_cd  --补登业务类型代码
,margin_acct_id  --保证金账户编号
,margin_tran_out_acct_id  --保证金转出账户编号
,update_cnt  --更新次数
,dubil_id  --借据编号
,sign_lmt_cont_flg  --签订额度合同标志
,sign_paper_cont_flg  --签署纸质合同标志
,comm_fee_amt  --手续费金额
,crdt_apv_aval_amt  --信贷审批可用金额
,b_renew_cont_id  --展期前合同编号
,ocup_open_lmt_risk_type_cd  --占用敞口额度风险类型代码
,ocup_o_use_lmt_flg  --占用他用额度标志
,risk_mgmt_apv_aval_amt  --风控审批可用金额
,ifc_cnt_tot_apv_aval_amt  --ifc数总审批可用金额
,ifc_apved_lmt_cont_amt  --ifc审批后额度合同金额
,regroup_loan_flg  --重组贷款标志
,only_new_minorent_flg  --专精特新小巨人企业标志
,only_new_littlegiantent_flg  --专精特新中小企业标志
,indent_tech_flg  --工业企业技术改造升级标志
,cul_property_flg  --文化产业标志
,advanced_manu_flg  --先进制造业标志
,auto_que_lon_post_rept_flg  --自动查询贷后报告标志

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合同编号
,replace(replace(t1.apv_flow_num,chr(13),''),chr(10),'') as apv_flow_num --审批流水号
,replace(replace(t1.rela_cont_id,chr(13),''),chr(10),'') as rela_cont_id --关联合同编号
,replace(replace(t1.text_cont_id,chr(13),''),chr(10),'') as text_cont_id --文本合同编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.lmt_cont_flg,chr(13),''),chr(10),'') as lmt_cont_flg --额度合同标志
,replace(replace(t1.rela_old_cont_id,chr(13),''),chr(10),'') as rela_old_cont_id --关联旧合同编号
,replace(replace(t1.appl_way_cd,chr(13),''),chr(10),'') as appl_way_cd --申请方式代码
,replace(replace(t1.loan_distr_type_cd,chr(13),''),chr(10),'') as loan_distr_type_cd --贷款发放类型代码
,replace(replace(t1.distr_mode_pay_cd,chr(13),''),chr(10),'') as distr_mode_pay_cd --放款支付方式代码
,t1.happ_dt as happ_dt --发生日期
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,t1.cont_amt as cont_amt --合同金额
,t1.actl_out_acct_amt as actl_out_acct_amt --实际出账金额
,t1.out_acct_dt as out_acct_dt --出账日期
,replace(replace(t1.base_prod_id,chr(13),''),chr(10),'') as base_prod_id --基础产品编号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,t1.mon_tenor as mon_tenor --月期限
,t1.day_tenor as day_tenor --日期限
,t1.cont_effect_dt as cont_effect_dt --合同生效日期
,t1.cont_exp_dt as cont_exp_dt --合同到期日期
,replace(replace(t1.lmt_circl_flg,chr(13),''),chr(10),'') as lmt_circl_flg --循环贷款标志
,replace(replace(t1.risk_type_cd,chr(13),''),chr(10),'') as risk_type_cd --风险类型代码
,replace(replace(t1.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg --低风险业务标志
,replace(replace(t1.remote_bus_flg,chr(13),''),chr(10),'') as remote_bus_flg --异地业务标志
,replace(replace(t1.int_rat_mode_cd,chr(13),''),chr(10),'') as int_rat_mode_cd --利率模式代码
,t1.fix_int_rat as fix_int_rat --固定利率
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd --基准利率类型代码
,t1.base_rat as base_rat --基准利率
,replace(replace(t1.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd --利率浮动类型代码
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率调整方式代码
,t1.int_rat_flo_val as int_rat_flo_val --利率浮动值
,t1.exec_int_rat as exec_int_rat --执行利率
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd --主担保方式代码
,replace(replace(t1.supp_guar_way_flg,chr(13),''),chr(10),'') as supp_guar_way_flg --追加担保方式标志
,replace(replace(t1.other_cond_descb,chr(13),''),chr(10),'') as other_cond_descb --其他条件描述
,replace(replace(t1.guar_way_cd_two,chr(13),''),chr(10),'') as guar_way_cd_two --担保方式代码二
,replace(replace(t1.guar_way_cd_three,chr(13),''),chr(10),'') as guar_way_cd_three --担保方式代码三
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd --还款方式代码
,replace(replace(t1.sub_guar_way_cd,chr(13),''),chr(10),'') as sub_guar_way_cd --子担保方式代码
,replace(replace(t1.repay_ped,chr(13),''),chr(10),'') as repay_ped --还款周期
,replace(replace(t1.repay_ped_cd,chr(13),''),chr(10),'') as repay_ped_cd --还款周期单位代码
,t1.deflt_repay_day as deflt_repay_day --默认还款日
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id --结算账户编号
,replace(replace(t1.crdt_dir_cd,chr(13),''),chr(10),'') as crdt_dir_cd --授信投向代码
,replace(replace(t1.nat_std_indus_dir_cd,chr(13),''),chr(10),'') as nat_std_indus_dir_cd --国标行业投向代码
,replace(replace(t1.bank_int_indus_dir_cd,chr(13),''),chr(10),'') as bank_int_indus_dir_cd --行内行业投向代码
,replace(replace(t1.usage_descb,chr(13),''),chr(10),'') as usage_descb --用途描述
,replace(replace(t1.data_input_integy_flg,chr(13),''),chr(10),'') as data_input_integy_flg --数据录入已完善标志
,t1.rsrv_amt as rsrv_amt --预留金额
,t1.curr_bal as curr_bal --当前余额
,t1.nomal_bal as nomal_bal --正常余额
,t1.loan_ovdue_amt as loan_ovdue_amt --贷款逾期金额
,t1.idle_bal as idle_bal --呆滞余额
,t1.bad_debt_bal as bad_debt_bal --呆账余额
,t1.in_bs_over_int_bal as in_bs_over_int_bal --表内欠息余额
,t1.off_bs_over_int_bal as off_bs_over_int_bal --表外欠息余额
,t1.ovdue_pnlt_bal as ovdue_pnlt_bal --逾期罚息余额
,t1.comp_int_bal as comp_int_bal --复息余额
,t1.loan_ovdue_days as loan_ovdue_days --贷款逾期天数
,t1.over_int_days as over_int_days --欠息天数
,t1.wrt_off_pric as wrt_off_pric --核销本金
,t1.wrt_off_int as wrt_off_int --核销利息
,t1.pre_loss_amt as pre_loss_amt --预测损失金额
,t1.fir_idtfy_non_dt as fir_idtfy_non_dt --首次认定不良日期
,replace(replace(t1.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd --合同状态代码
,t1.effect_dt as effect_dt --生效日期
,t1.termnt_dt as termnt_dt --终止日期
,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'') as payoff_flg --结清标志
,replace(replace(t1.off_bs_flg,chr(13),''),chr(10),'') as off_bs_flg --表外标志
,replace(replace(t1.onl_bus_flg,chr(13),''),chr(10),'') as onl_bus_flg --线上业务标志
,replace(replace(t1.belong_strip_line_cd,chr(13),''),chr(10),'') as belong_strip_line_cd --所属条线代码
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd --审批状态代码
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id --额度编号
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id --业务经办人编号
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id --经办机构编号
,t1.oper_dt as oper_dt --经办日期
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id --登记柜员编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,t1.rgst_dt as rgst_dt --登记日期
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id --更新柜员编号
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id --更新机构编号
,t1.modif_dt as modif_dt --变更日期
,replace(replace(t1.spec_ped_corp_cd,chr(13),''),chr(10),'') as spec_ped_corp_cd --指定周期单位代码
,replace(replace(t1.spec_ped_cd,chr(13),''),chr(10),'') as spec_ped_cd --指定周期代码
,t1.b_renew_exp_dt as b_renew_exp_dt --展期前到期日期
,t1.b_renew_amt as b_renew_amt --展期前金额
,t1.b_renew_exec_year_int_rat as b_renew_exec_year_int_rat --展期前执行年利率
,replace(replace(t1.hxb_rela_party_flg,chr(13),''),chr(10),'') as hxb_rela_party_flg --我行关联方标志
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd --贷款用途代码
,replace(replace(t1.int_rat_adj_ped_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_cd --利率调整周期代码
,t1.lmt_open_amt as lmt_open_amt --额度敞口金额
,t1.occu_lmt as occu_lmt --已占用额度
,replace(replace(t1.margin_curr_cd,chr(13),''),chr(10),'') as margin_curr_cd --保证金币种代码
,t1.margin_ratio as margin_ratio --保证金比例
,t1.margin_amt as margin_amt --保证金金额
,t1.open_amt as open_amt --敞口金额
,t1.open_amt_stat as open_amt_stat --敞口金额统计
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id --额度合同编号
,t1.exec_mon_int_rat as exec_mon_int_rat --执行月利率
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd --资产三分类代码
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd --五级分类代码
,t1.level5_cls_dt as level5_cls_dt --五级分类日期
,replace(replace(t1.level11_cls_cd,chr(13),''),chr(10),'') as level11_cls_cd --十一级分类代码
,replace(replace(t1.lon_post_mgmt_teller_id,chr(13),''),chr(10),'') as lon_post_mgmt_teller_id --贷后管理柜员编号
,replace(replace(t1.lon_post_mgmt_org_id,chr(13),''),chr(10),'') as lon_post_mgmt_org_id --贷后管理机构编号
,t1.file_dt as file_dt --归档日期
,replace(replace(t1.froz_flg,chr(13),''),chr(10),'') as froz_flg --冻结状态代码
,t1.ovdue_exec_int_rat as ovdue_exec_int_rat --逾期执行利率
,replace(replace(t1.ovdue_int_rat_float_way_cd,chr(13),''),chr(10),'') as ovdue_int_rat_float_way_cd --逾期利率浮动方式代码
,t1.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val --逾期利率浮动值
,replace(replace(t1.core_out_acct_org_id,chr(13),''),chr(10),'') as core_out_acct_org_id --核心出账机构编号
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name --结算账户名称
,replace(replace(t1.enter_id,chr(13),''),chr(10),'') as enter_id --入账账户编号
,replace(replace(t1.enter_name,chr(13),''),chr(10),'') as enter_name --入账账户名称
,replace(replace(t1.enter_open_acct_org_id,chr(13),''),chr(10),'') as enter_open_acct_org_id --入账账户开户机构编号
,replace(replace(t1.backup_status_cd,chr(13),''),chr(10),'') as backup_status_cd --备份状态代码
,replace(replace(t1.backup_lmt_cont_id,chr(13),''),chr(10),'') as backup_lmt_cont_id --备份额度合同编号
,t1.comm_fee_rat as comm_fee_rat --手续费率
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark --迁移备注
,replace(replace(t1.strtg_new_indus_type_cd,chr(13),''),chr(10),'') as strtg_new_indus_type_cd --战略新兴产业类型代码
,replace(replace(t1.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg --高新技术企业标志
,replace(replace(t1.scen_tech_corp_flg,chr(13),''),chr(10),'') as scen_tech_corp_flg --科技企业标志
,replace(replace(t1.tech_inovt_corp_flg,chr(13),''),chr(10),'') as tech_inovt_corp_flg --科创企业标志
,replace(replace(t1.xxd_camp_lmt_flg,chr(13),''),chr(10),'') as xxd_camp_lmt_flg --新兴贷营销额度标志
,replace(replace(t1.provi_for_aged_property_flg,chr(13),''),chr(10),'') as provi_for_aged_property_flg --养老产业标志
,replace(replace(t1.seed_loan_flg,chr(13),''),chr(10),'') as seed_loan_flg --种业振兴贷款标志
,replace(replace(t1.county_loan_flg,chr(13),''),chr(10),'') as county_loan_flg --县城城区贷款标志
,replace(replace(t1.high_tech_property_flg,chr(13),''),chr(10),'') as high_tech_property_flg --投向高技术产业标志
,replace(replace(t1.digit_econ_core_type_cd,chr(13),''),chr(10),'') as digit_econ_core_type_cd --数字经济核心产业类型代码
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.prod_gen_id,chr(13),''),chr(10),'') as prod_gen_id --产品大类编号
,replace(replace(t1.tran_bf_prod_id,chr(13),''),chr(10),'') as tran_bf_prod_id --转换前产品编号
,replace(replace(t1.tran_bf_cust_id,chr(13),''),chr(10),'') as tran_bf_cust_id --转换前客户编号
,replace(replace(t1.attach_rgst_bus_type_cd,chr(13),''),chr(10),'') as attach_rgst_bus_type_cd --补登业务类型代码
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id --保证金账户编号
,replace(replace(t1.margin_tran_out_acct_id,chr(13),''),chr(10),'') as margin_tran_out_acct_id --保证金转出账户编号
,t1.update_cnt as update_cnt --更新次数
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id --借据编号
,replace(replace(t1.sign_lmt_cont_flg,chr(13),''),chr(10),'') as sign_lmt_cont_flg --签订额度合同标志
,replace(replace(t1.sign_paper_cont_flg,chr(13),''),chr(10),'') as sign_paper_cont_flg --签署纸质合同标志
,t1.comm_fee_amt as comm_fee_amt --手续费金额
,t1.crdt_apv_aval_amt as crdt_apv_aval_amt --信贷审批可用金额
,replace(replace(t1.b_renew_cont_id,chr(13),''),chr(10),'') as b_renew_cont_id --展期前合同编号
,replace(replace(t1.ocup_open_lmt_risk_type_cd,chr(13),''),chr(10),'') as ocup_open_lmt_risk_type_cd --占用敞口额度风险类型代码
,replace(replace(t1.ocup_o_use_lmt_flg,chr(13),''),chr(10),'') as ocup_o_use_lmt_flg --占用他用额度标志
,t1.risk_mgmt_apv_aval_amt as risk_mgmt_apv_aval_amt --风控审批可用金额
,t1.ifc_cnt_tot_apv_aval_amt as ifc_cnt_tot_apv_aval_amt --ifc数总审批可用金额
,t1.ifc_apved_lmt_cont_amt as ifc_apved_lmt_cont_amt --ifc审批后额度合同金额
,replace(replace(t1.regroup_loan_flg,chr(13),''),chr(10),'') as regroup_loan_flg --重组贷款标志
,replace(replace(t1.only_new_minorent_flg,chr(13),''),chr(10),'') as only_new_minorent_flg --专精特新小巨人企业标志
,replace(replace(t1.only_new_littlegiantent_flg,chr(13),''),chr(10),'') as only_new_littlegiantent_flg --专精特新中小企业标志
,replace(replace(t1.indent_tech_flg,chr(13),''),chr(10),'') as indent_tech_flg --工业企业技术改造升级标志
,replace(replace(t1.cul_property_flg,chr(13),''),chr(10),'') as cul_property_flg --文化产业标志
,replace(replace(t1.advanced_manu_flg,chr(13),''),chr(10),'') as advanced_manu_flg --先进制造业标志
,replace(replace(t1.auto_que_lon_post_rept_flg,chr(13),''),chr(10),'') as auto_que_lon_post_rept_flg --自动查询贷后报告标志
from ${iml_schema}.agt_loan_cont_info_h t1    --贷款合同信息历史
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'agt_loan_cont_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
