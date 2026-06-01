/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_cmm_unite_wl_loan_cont_info
CreateDate: 20250620
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.crps_cmm_unite_wl_loan_cont_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_cmm_unite_wl_loan_cont_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_cmm_unite_wl_loan_cont_info (
etl_dt  --数据日期
,lp_id  --法人编号
,cont_id  --合同编号
,crdt_appl_flow_num  --授信申请流水号
,cust_id  --客户编号
,cust_name  --客户名称
,std_prod_id  --标准产品编号
,crdt_type_cd  --授信类型代码
,appl_type_cd  --申请类型代码
,curr_cd  --币种代码
,base_rat_type_cd  --基准利率类型代码
,int_rat_adj_way_cd  --利率调整方式代码
,cont_status_cd  --合同状态代码
,apv_status_cd  --审批状态代码
,guar_way_cd  --担保方式代码
,repay_way_cd  --还款方式代码
,loan_usage_type_cd  --贷款用途类型代码
,recvbl_acct_name  --收款账户名称
,recvbl_acct_open_org_id  --收款账户开户机构编号
,exec_int_rat  --执行利率
,cont_bal  --合同余额
,cont_amt  --合同金额
,distr_amt  --放款金额
,tenor  --期限
,begin_dt  --起始日期
,exp_dt  --到期日期
,sign_dt  --签订日期
,distr_dt  --放款日期
,termnt_dt  --终止日期
,spec_repay_day  --指定还款日
,operr_id  --经办人编号
,oper_org_id  --经办机构编号
,oper_dt  --经办日期
,rgstrat_id  --登记人编号
,rgst_org_id  --登记机构编号
,rgst_dt  --登记日期
,update_id  --更新人编号
,update_org_id  --更新机构编号
,update_dt  --更新日期
,high_tech_property_flg  --投向高技术产业标志
,digit_econ_core_type_cd  --投向数字经济核心产业类型代码
,lmt_cont_id  --额度合同编号
,dir_indus_cd --行业投向代码
,lmt_or_encrge_indus_cd -- 限制或鼓励行业代码
,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
,guar_proj_loan_type_cd -- 保障性安居工程贷款类型代码
,buid_bus_guar_loan_type_cd -- 创业担保贷款类型代码
,estate_loan_type_cd -- 房地产贷款类型代码
,strate_new_indus_type_cd -- 战略性新兴产业类型代码
,agclt_loan_main_type_cd -- 涉农贷款主体类型代码
,agclt_loan_dir_cd -- 涉农贷款投向代码
,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
,surp_indus_cd -- 过剩行业代码
,adv_man_indu_flg -- 先进制造业标志
,green_crdt_fin_flg -- 绿色信贷融资标志
,cty_lmt_indus_flg -- 国家限制行业标志
,high_tech_serv_loan_flg -- 高技术服务业贷款标志
,sci_tech_inovt_corp_flg -- 科创企业标志
,sci_tech_corp_flg -- 科技型企业标志
,high_new_tech_corp_flg -- 高新技术企业标志
,spe_soph_unq_new_med_side_enter_flg -- 专精特新中小企业标志
,spe_soph_unq_new_lte_gnt_corp_flg -- 专精特新小巨人企业标志
,provi_for_aged_property_flg -- 养老产业标志
,indu_corp_tech_rem_ugd_flg -- 工业转型升级标识
,three_old_tf_or_city_update_proj_flg -- 三旧改造或城市更新项目标志
,br_build_ifin_flg -- 一带一路建设投融资标志
,sup_chain_fin_bus_flg -- 供应链金融业务标志
,buid_bus_guar_loan_flg -- 创业担保贷款标志
,county_loan_flg -- 县城区贷款标志
,overs_loan_flg -- 境外贷款标志
,ppp_proj_flg -- 投向政府和社会资本合作项目标志
,cul_property_flg -- 文化产业标志
,new_distr_flg -- 新机制发放贷款标志
,agclt_flg -- 涉农标志
,seed_loan_flg -- 种业振兴贷款标志
,proj_fin_flg -- 项目融资标志

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合同编号
,replace(replace(t1.crdt_appl_flow_num,chr(13),''),chr(10),'') as crdt_appl_flow_num --授信申请流水号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id --标准产品编号
,replace(replace(t1.crdt_type_cd,chr(13),''),chr(10),'') as crdt_type_cd --授信类型代码
,replace(replace(t1.appl_type_cd,chr(13),''),chr(10),'') as appl_type_cd --申请类型代码
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd --基准利率类型代码
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率调整方式代码
,replace(replace(t1.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd --合同状态代码
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd --审批状态代码
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd --担保方式代码
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd --还款方式代码
,replace(replace(t1.loan_usage_type_cd,chr(13),''),chr(10),'') as loan_usage_type_cd --贷款用途类型代码
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name --收款账户名称
,replace(replace(t1.recvbl_acct_open_org_id,chr(13),''),chr(10),'') as recvbl_acct_open_org_id --收款账户开户机构编号
,t1.exec_int_rat as exec_int_rat --执行利率
,t1.cont_bal as cont_bal --合同余额
,t1.cont_amt as cont_amt --合同金额
,t1.distr_amt as distr_amt --放款金额
,replace(replace(t1.tenor,chr(13),''),chr(10),'') as tenor --期限
,t1.begin_dt as begin_dt --起始日期
,t1.exp_dt as exp_dt --到期日期
,t1.sign_dt as sign_dt --签订日期
,t1.distr_dt as distr_dt --放款日期
,t1.termnt_dt as termnt_dt --终止日期
,t1.spec_repay_day as spec_repay_day --指定还款日
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id --经办人编号
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id --经办机构编号
,t1.oper_dt as oper_dt --经办日期
,replace(replace(t1.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id --登记人编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,t1.rgst_dt as rgst_dt --登记日期
,replace(replace(t1.update_id,chr(13),''),chr(10),'') as update_id --更新人编号
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id --更新机构编号
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.high_tech_property_flg,chr(13),''),chr(10),'') as high_tech_property_flg --投向高技术产业标志
,replace(replace(t1.digit_econ_core_type_cd,chr(13),''),chr(10),'') as digit_econ_core_type_cd --投向数字经济核心产业类型代码
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id --额度合同编号
,replace(replace(t1.dir_indus_cd,chr(13),''),chr(10),'') as dir_indus_cd --行业投向代码
,replace(replace(t1.lmt_or_encrge_indus_cd,chr(13),''),chr(10),'') as lmt_or_encrge_indus_cd --限制或鼓励行业代码
,replace(replace(t1.sup_chain_fin_bus_prod_cls_cd,chr(13),''),chr(10),'') as sup_chain_fin_bus_prod_cls_cd --供应链金融业务产品分类代码
,replace(replace(t1.guar_proj_loan_type_cd,chr(13),''),chr(10),'') as guar_proj_loan_type_cd --保障性安居工程贷款类型代码
,replace(replace(t1.buid_bus_guar_loan_type_cd,chr(13),''),chr(10),'') as buid_bus_guar_loan_type_cd --创业担保贷款类型代码
,replace(replace(t1.estate_loan_type_cd,chr(13),''),chr(10),'') as estate_loan_type_cd --房地产贷款类型代码
,replace(replace(t1.strate_new_indus_type_cd,chr(13),''),chr(10),'') as strate_new_indus_type_cd --战略性新兴产业类型代码
,replace(replace(t1.agclt_loan_main_type_cd,chr(13),''),chr(10),'') as agclt_loan_main_type_cd --涉农贷款主体类型代码
,replace(replace(t1.agclt_loan_dir_cd,chr(13),''),chr(10),'') as agclt_loan_dir_cd --涉农贷款投向代码
,replace(replace(t1.loan_fin_supt_way_cd,chr(13),''),chr(10),'') as loan_fin_supt_way_cd --贷款财政扶持方式代码
,replace(replace(t1.surp_indus_cd,chr(13),''),chr(10),'') as surp_indus_cd --过剩行业代码
,replace(replace(t1.adv_man_indu_flg,chr(13),''),chr(10),'') as adv_man_indu_flg --先进制造业标志
,replace(replace(t1.green_crdt_fin_flg,chr(13),''),chr(10),'') as green_crdt_fin_flg --绿色信贷融资标志
,replace(replace(t1.cty_lmt_indus_flg,chr(13),''),chr(10),'') as cty_lmt_indus_flg --国家限制行业标志
,replace(replace(t1.high_tech_serv_loan_flg,chr(13),''),chr(10),'') as high_tech_serv_loan_flg --高技术服务业贷款标志
,replace(replace(t1.sci_tech_inovt_corp_flg,chr(13),''),chr(10),'') as sci_tech_inovt_corp_flg --科创企业标志
,replace(replace(t1.sci_tech_corp_flg,chr(13),''),chr(10),'') as sci_tech_corp_flg --科技型企业标志
,replace(replace(t1.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg --高新技术企业标志
,replace(replace(t1.spe_soph_unq_new_med_side_enter_flg,chr(13),''),chr(10),'') as spe_soph_unq_new_med_side_enter_flg --专精特新中小企业标志
,replace(replace(t1.spe_soph_unq_new_lte_gnt_corp_flg,chr(13),''),chr(10),'') as spe_soph_unq_new_lte_gnt_corp_flg --专精特新小巨人企业标志
,replace(replace(t1.provi_for_aged_property_flg,chr(13),''),chr(10),'') as provi_for_aged_property_flg --养老产业标志
,replace(replace(t1.indu_corp_tech_rem_ugd_flg,chr(13),''),chr(10),'') as indu_corp_tech_rem_ugd_flg --工业转型升级标识
,replace(replace(t1.three_old_tf_or_city_update_proj_flg,chr(13),''),chr(10),'') as three_old_tf_or_city_update_proj_flg --三旧改造或城市更新项目标志
,replace(replace(t1.br_build_ifin_flg,chr(13),''),chr(10),'') as br_build_ifin_flg --一带一路建设投融资标志
,replace(replace(t1.sup_chain_fin_bus_flg,chr(13),''),chr(10),'') as sup_chain_fin_bus_flg --供应链金融业务标志
,replace(replace(t1.buid_bus_guar_loan_flg,chr(13),''),chr(10),'') as buid_bus_guar_loan_flg --创业担保贷款标志
,replace(replace(t1.county_loan_flg,chr(13),''),chr(10),'') as county_loan_flg --县城区贷款标志
,replace(replace(t1.overs_loan_flg,chr(13),''),chr(10),'') as overs_loan_flg --境外贷款标志
,replace(replace(t1.ppp_proj_flg,chr(13),''),chr(10),'') as ppp_proj_flg --投向政府和社会资本合作项目标志
,replace(replace(t1.cul_property_flg,chr(13),''),chr(10),'') as cul_property_flg --文化产业标志
,replace(replace(t1.new_distr_flg,chr(13),''),chr(10),'') as new_distr_flg --新机制发放贷款标志
,replace(replace(t1.agclt_flg,chr(13),''),chr(10),'') as agclt_flg --涉农标志
,replace(replace(t1.seed_loan_flg,chr(13),''),chr(10),'') as seed_loan_flg --种业振兴贷款标志
,replace(replace(t1.proj_fin_flg,chr(13),''),chr(10),'') as proj_fin_flg --项目融资标志

from ${icl_schema}.cmm_unite_wl_loan_cont_info t1    --联合网贷贷款合同信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_cmm_unite_wl_loan_cont_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
