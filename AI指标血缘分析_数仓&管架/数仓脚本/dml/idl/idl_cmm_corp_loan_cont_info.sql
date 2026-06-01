/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_cmm_corp_loan_cont_info
CreateDate: 20250508
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.cmm_corp_loan_cont_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_corp_loan_cont_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_corp_loan_cont_info (
etl_dt  --ETL处理日期
,lp_id  --法人编号
,cont_id  --合同编号
,cust_id  --客户编号
,lmt_cont_id  --额度合同编号
,apv_flow_num  --授信申请流水号
,manu_cont_id  --人工合同编号
,bus_breed_id  --业务品种编号
,bus_sub_type_cd  --业务子类型代码
,loan_happ_type_cd  --贷款发生类型代码
,cont_type_cd  --合同类型代码
,strtg_new_indus_type_cd  --战略新兴产业类型代码
,prod_type_cd  --产品类型代码
,valid_flg_cd  --有效标志代码
,dir_indus_cd  --投向行业代码
,surp_indus_cd  --过剩行业代码
,sub_guar_way_cd  --子担保方式代码
,guar_type_cd  --担保类型代码
,major_guar_way_cd  --主要担保方式代码
,crdt_type_cd  --授信类型代码
,appl_way_cd  --申请方式代码
,loan_fin_supt_way_cd  --贷款财政扶持方式代码
,invest_way_cd  --投资方式代码
,mgmt_mode_cd  --管理模式代码
,loan_level5_cls_cd  --贷款五级分类代码
,loan_level10_cls_cd  --贷款十级分类代码
,tenor_type_cd  --期限类型代码
,pric_repay_way_cd  --本金还款方式代码
,int_rat_float_way_cd  --利率浮动方式代码
,charge_way_cd  --收费方式代码
,draw_way_cd  --提款方式代码
,cap_src_cd  --资金来源代码
,int_rat_adj_way_cd  --利率调整方式代码
,curr_cd  --币种代码
,sup_chain_fin_bus_prod_cls_cd  --供应链金融业务产品分类代码
,sup_chain_fin_bus_flg  --供应链金融业务标志
,agent_patip_loan_flg  --代理参贷标志
,lmt_circl_flg  --额度循环标志
,circl_flg  --循环标志
,temp_store_flg  --暂存标志
,froz_flg  --冻结标志
,turn_crdt_flg  --转授信标志
,remote_loan_flg  --异地贷款标志
,other_guar_way_flg  --其他担保方式标志
,imp_proj_loan_flg  --重点项目贷款标志
,cty_lmt_indus_flg  --国家限制行业标志
,gover_crdt_flg  --政府授信标志
,cdb_crdt_flg  --国开行授信标志
,fix_asset_crdt_flg  --固定资产授信标志
,qual_centr_cntpty_flg  --合格中央交易对手标志
,low_risk_bus_flg  --低风险业务标志
,host_bank_no  --主办行行号
,patip_loan_bank_no  --参贷行行号
,agent_bank_no  --代理行行号
,cntpty_strg  --交易对手实力
,cntpty_co_years  --与交易对手合作年限
,cntpty_sucs_tran_cnt  --与交易对手成功交易次数
,mgmt_org_id  --管理机构编号
,rgst_org_id  --登记机构编号
,oper_org_id  --经办机构编号
,distr_org_id  --放款机构编号
,mgmt_teller_id  --管理柜员编号
,oper_teller_id  --经办柜员编号
,rgst_teller_id  --登记柜员编号
,start_dt  --起始日期
,distr_dt  --发放日期
,exp_dt  --到期日期
,oper_dt  --经办日期
,rgst_dt  --登记日期
,termnt_dt  --终止日期
,lmt_use_latest_dt  --额度使用最迟日期
,lmt_under_bus_latest_exp_dt  --额度项下业务最迟到期日期
,loan_usage_descb  --贷款用途描述
,repay_src_descb  --还款来源描述
,other_cond_request_descb  --其他条件和要求描述
,trdpty_cust_name1  --第三方客户名称1
,trdpty_cust_name2  --第三方客户名称2
,rela_cont_id  --相关合同编号
,stl_acct_num  --结算账号
,margin_acct_num  --保证金账号
,margin_curr_cd  --保证金币种代码
,margin_ratio  --保证金比例
,margin_amt  --保证金金额
,tran_market_type_cd  --交易市场类型代码
,incre_crdt_way_cd  --增信方式代码
,batch_data_src_cd  --批量数据来源代码
,backup_lmt_effect_cd  --备份额度生效代码
,backup_lmt_cont_id  --备份额度合同编号
,risk_type_cd  --风险类型代码
,major_loan_cls_cd  --专业贷款分类代码
,risk_expose_cls  --风险暴露分类
,tran_asset_name  --交易资产名称
,dir_ind_fund_flg  --投向产业基金标志
,dir_makti_debt_eqty_flg  --投向市场化债转股标志
,invo_gover_class_fin_flg  --涉及政府类融资标志
,consm_serv_class_fin_flg  --消费服务类融资标志
,stl_dep_flg  --结算性存款标志
,cota_opt_choice_flg  --含有回售选择权标志
,septbl_flg  --可分离标志
,onl_bus_flg  --线上业务标志
,class_crdt_flg  --类信贷标志
,crdt_bus_flow_type_cd  --授信业务流程类型代码
,crdt_rg_cd  --授信区域代码
,estate_fin_flg  --房地产融资标志
,gover_class_fin_flg1  --政府类融资标志1
,br_build_ifin_flg  --一带一路建设投融资标志
,green_crdt_fin_flg  --绿色信贷融资标志
,trade_cont_id  --贸易合同编号
,trade_cont_curr_cd  --贸易合同币种代码
,trade_cont_amt  --贸易合同金额
,bill_qtty  --票据数量
,discnt_bf_revw_flg  --先贴后查标志
,discnt_int_buyer_bear_ratio  --贴现利息买方承担比例
,discnt_int_applit_pay_ratio  --贴现利息申请人支付比例
,agt_pay_int_flg  --协议付息标志
,bill_uniq_idf_id  --票据唯一标识编号
,trdpty_acct_id  --第三方账户编号
,loan_src_cd  --贷款来源代码
,comm_fee_rat  --手续费费率
,comm_fee_amt  --手续费金额
,lc_id  --信用证编号
,lc_amt  --信用证金额
,syn_loan_distr_amt  --银团贷款发放金额
,tenor  --期限
,base_rat  --基准利率
,int_rat_flo_val  --利率浮动值
,exec_int_rat  --执行利率
,bank_fin_tot  --银行融资总额
,open_bal  --敞口余额
,cont_amt  --合同金额
,cont_aval_bal  --合同可用余额
,acm_distr_amt  --累计发放金额
,acm_callbk_amt  --累计回收金额
,occu_crdt_lmt  --已占用授信额度
,surp_crdt_lmt  --剩余授信额度
,entr_loan_espec_dir_cd  --委托贷款特殊投向代码
,underly_prod_cls_flg  --标的产品分级标志
,underly_prod_cls_lev_cd  --标的产品分级级别代码
,estate_loan_type_cd  --房地产贷款类型代码
,final_dir_type_cd  --最终投向类型代码
,pente_type_cd  --穿透类型代码
,underly_prod_coll_amt  --标的产品募集金额
,file_int_accr_flg  --靠档计息标志
,ibank_bond_id  --同业债券编号
,trast_chn_cd  --办理渠道代码
,syn_loan_tot_amt  --银团贷款总金额
,agclt_flg  --涉农标志
,agclt_loan_main_type_cd  --涉农贷款主体类型代码
,agclt_loan_dir_cd  --涉农贷款投向代码
,plat_solv_cap_src_cd  --平台偿债资金来源代码
,buid_bus_guar_loan_flg  --创业担保贷款标志
,buid_bus_guar_loan_type_cd  --创业担保贷款类型代码
,secd_guar_way_cd  --第二担保方式代码
,imp_loan_proj  --重点贷款项目代码
,fin_sys_cont_flg  --融资合同标志
,ibank_tran_org_id  --同业交易机构编号
,loan_enter_acct_acct_num  --贷款入账账号
,out_acct_flg  --出账标志
,asset_thd_cls_cd  --资产三分类代码
,base_rat_type_cd  --基准利率类型代码
,int_rat_mode_cd  --利率模式代码
,rsrv_amt  --预留金额
,std_prod_id  --标准产品编号
,ibank_asset_uniq_idf_id  --同业资产唯一标识编号
,aplv_flow_num  --申请流水号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合同编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id --额度合同编号
,replace(replace(t1.apv_flow_num,chr(13),''),chr(10),'') as apv_flow_num --授信申请流水号
,replace(replace(t1.manu_cont_id,chr(13),''),chr(10),'') as manu_cont_id --人工合同编号
,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id --业务品种编号
,replace(replace(t1.bus_sub_type_cd,chr(13),''),chr(10),'') as bus_sub_type_cd --业务子类型代码
,replace(replace(t1.loan_happ_type_cd,chr(13),''),chr(10),'') as loan_happ_type_cd --贷款发生类型代码
,replace(replace(t1.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd --合同类型代码
,replace(replace(t1.strtg_new_indus_type_cd,chr(13),''),chr(10),'') as strtg_new_indus_type_cd --战略新兴产业类型代码
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd --产品类型代码
,replace(replace(t1.valid_flg_cd,chr(13),''),chr(10),'') as valid_flg_cd --有效标志代码
,replace(replace(t1.dir_indus_cd,chr(13),''),chr(10),'') as dir_indus_cd --投向行业代码
,replace(replace(t1.surp_indus_cd,chr(13),''),chr(10),'') as surp_indus_cd --过剩行业代码
,replace(replace(t1.sub_guar_way_cd,chr(13),''),chr(10),'') as sub_guar_way_cd --子担保方式代码
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd --担保类型代码
,replace(replace(t1.major_guar_way_cd,chr(13),''),chr(10),'') as major_guar_way_cd --主要担保方式代码
,replace(replace(t1.crdt_type_cd,chr(13),''),chr(10),'') as crdt_type_cd --授信类型代码
,replace(replace(t1.appl_way_cd,chr(13),''),chr(10),'') as appl_way_cd --申请方式代码
,replace(replace(t1.loan_fin_supt_way_cd,chr(13),''),chr(10),'') as loan_fin_supt_way_cd --贷款财政扶持方式代码
,replace(replace(t1.invest_way_cd,chr(13),''),chr(10),'') as invest_way_cd --投资方式代码
,replace(replace(t1.mgmt_mode_cd,chr(13),''),chr(10),'') as mgmt_mode_cd --管理模式代码
,replace(replace(t1.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd --贷款五级分类代码
,replace(replace(t1.loan_level10_cls_cd,chr(13),''),chr(10),'') as loan_level10_cls_cd --贷款十级分类代码
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd --期限类型代码
,replace(replace(t1.pric_repay_way_cd,chr(13),''),chr(10),'') as pric_repay_way_cd --本金还款方式代码
,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd --利率浮动方式代码
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd --收费方式代码
,replace(replace(t1.draw_way_cd,chr(13),''),chr(10),'') as draw_way_cd --提款方式代码
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd --资金来源代码
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率调整方式代码
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.sup_chain_fin_bus_prod_cls_cd,chr(13),''),chr(10),'') as sup_chain_fin_bus_prod_cls_cd --供应链金融业务产品分类代码
,replace(replace(t1.sup_chain_fin_bus_flg,chr(13),''),chr(10),'') as sup_chain_fin_bus_flg --供应链金融业务标志
,replace(replace(t1.agent_patip_loan_flg,chr(13),''),chr(10),'') as agent_patip_loan_flg --代理参贷标志
,replace(replace(t1.lmt_circl_flg,chr(13),''),chr(10),'') as lmt_circl_flg --额度循环标志
,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg --循环标志
,replace(replace(t1.temp_store_flg,chr(13),''),chr(10),'') as temp_store_flg --暂存标志
,replace(replace(t1.froz_flg,chr(13),''),chr(10),'') as froz_flg --冻结标志
,replace(replace(t1.turn_crdt_flg,chr(13),''),chr(10),'') as turn_crdt_flg --转授信标志
,replace(replace(t1.remote_loan_flg,chr(13),''),chr(10),'') as remote_loan_flg --异地贷款标志
,replace(replace(t1.other_guar_way_flg,chr(13),''),chr(10),'') as other_guar_way_flg --其他担保方式标志
,replace(replace(t1.imp_proj_loan_flg,chr(13),''),chr(10),'') as imp_proj_loan_flg --重点项目贷款标志
,replace(replace(t1.cty_lmt_indus_flg,chr(13),''),chr(10),'') as cty_lmt_indus_flg --国家限制行业标志
,replace(replace(t1.gover_crdt_flg,chr(13),''),chr(10),'') as gover_crdt_flg --政府授信标志
,replace(replace(t1.cdb_crdt_flg,chr(13),''),chr(10),'') as cdb_crdt_flg --国开行授信标志
,replace(replace(t1.fix_asset_crdt_flg,chr(13),''),chr(10),'') as fix_asset_crdt_flg --固定资产授信标志
,replace(replace(t1.qual_centr_cntpty_flg,chr(13),''),chr(10),'') as qual_centr_cntpty_flg --合格中央交易对手标志
,replace(replace(t1.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg --低风险业务标志
,replace(replace(t1.host_bank_no,chr(13),''),chr(10),'') as host_bank_no --主办行行号
,replace(replace(t1.patip_loan_bank_no,chr(13),''),chr(10),'') as patip_loan_bank_no --参贷行行号
,replace(replace(t1.agent_bank_no,chr(13),''),chr(10),'') as agent_bank_no --代理行行号
,replace(replace(t1.cntpty_strg,chr(13),''),chr(10),'') as cntpty_strg --交易对手实力
,replace(replace(t1.cntpty_co_years,chr(13),''),chr(10),'') as cntpty_co_years --与交易对手合作年限
,replace(replace(t1.cntpty_sucs_tran_cnt,chr(13),''),chr(10),'') as cntpty_sucs_tran_cnt --与交易对手成功交易次数
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id --管理机构编号
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id --登记机构编号
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id --经办机构编号
,replace(replace(t1.distr_org_id,chr(13),''),chr(10),'') as distr_org_id --放款机构编号
,replace(replace(t1.mgmt_teller_id,chr(13),''),chr(10),'') as mgmt_teller_id --管理柜员编号
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id --经办柜员编号
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id --登记柜员编号
,t1.start_dt as start_dt --起始日期
,t1.distr_dt as distr_dt --发放日期
,t1.exp_dt as exp_dt --到期日期
,t1.oper_dt as oper_dt --经办日期
,t1.rgst_dt as rgst_dt --登记日期
,t1.termnt_dt as termnt_dt --终止日期
,t1.lmt_use_latest_dt as lmt_use_latest_dt --额度使用最迟日期
,t1.lmt_under_bus_latest_exp_dt as lmt_under_bus_latest_exp_dt --额度项下业务最迟到期日期
,replace(replace(t1.loan_usage_descb,chr(13),''),chr(10),'') as loan_usage_descb --贷款用途描述
,replace(replace(t1.repay_src_descb,chr(13),''),chr(10),'') as repay_src_descb --还款来源描述
,replace(replace(t1.other_cond_request_descb,chr(13),''),chr(10),'') as other_cond_request_descb --其他条件和要求描述
,replace(replace(t1.trdpty_cust_name1,chr(13),''),chr(10),'') as trdpty_cust_name1 --第三方客户名称1
,replace(replace(t1.trdpty_cust_name2,chr(13),''),chr(10),'') as trdpty_cust_name2 --第三方客户名称2
,replace(replace(t1.rela_cont_id,chr(13),''),chr(10),'') as rela_cont_id --相关合同编号
,replace(replace(t1.stl_acct_num,chr(13),''),chr(10),'') as stl_acct_num --结算账号
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num --保证金账号
,replace(replace(t1.margin_curr_cd,chr(13),''),chr(10),'') as margin_curr_cd --保证金币种代码
,t1.margin_ratio as margin_ratio --保证金比例
,t1.margin_amt as margin_amt --保证金金额
,replace(replace(t1.tran_market_type_cd,chr(13),''),chr(10),'') as tran_market_type_cd --交易市场类型代码
,replace(replace(t1.incre_crdt_way_cd,chr(13),''),chr(10),'') as incre_crdt_way_cd --增信方式代码
,replace(replace(t1.batch_data_src_cd,chr(13),''),chr(10),'') as batch_data_src_cd --批量数据来源代码
,replace(replace(t1.backup_lmt_effect_cd,chr(13),''),chr(10),'') as backup_lmt_effect_cd --备份额度生效代码
,replace(replace(t1.backup_lmt_cont_id,chr(13),''),chr(10),'') as backup_lmt_cont_id --备份额度合同编号
,replace(replace(t1.risk_type_cd,chr(13),''),chr(10),'') as risk_type_cd --风险类型代码
,replace(replace(t1.major_loan_cls_cd,chr(13),''),chr(10),'') as major_loan_cls_cd --专业贷款分类代码
,replace(replace(t1.risk_expose_cls,chr(13),''),chr(10),'') as risk_expose_cls --风险暴露分类
,replace(replace(t1.tran_asset_name,chr(13),''),chr(10),'') as tran_asset_name --交易资产名称
,replace(replace(t1.dir_ind_fund_flg,chr(13),''),chr(10),'') as dir_ind_fund_flg --投向产业基金标志
,replace(replace(t1.dir_makti_debt_eqty_flg,chr(13),''),chr(10),'') as dir_makti_debt_eqty_flg --投向市场化债转股标志
,replace(replace(t1.invo_gover_class_fin_flg,chr(13),''),chr(10),'') as invo_gover_class_fin_flg --涉及政府类融资标志
,replace(replace(t1.consm_serv_class_fin_flg,chr(13),''),chr(10),'') as consm_serv_class_fin_flg --消费服务类融资标志
,replace(replace(t1.stl_dep_flg,chr(13),''),chr(10),'') as stl_dep_flg --结算性存款标志
,replace(replace(t1.cota_opt_choice_flg,chr(13),''),chr(10),'') as cota_opt_choice_flg --含有回售选择权标志
,replace(replace(t1.septbl_flg,chr(13),''),chr(10),'') as septbl_flg --可分离标志
,replace(replace(t1.onl_bus_flg,chr(13),''),chr(10),'') as onl_bus_flg --线上业务标志
,replace(replace(t1.class_crdt_flg,chr(13),''),chr(10),'') as class_crdt_flg --类信贷标志
,replace(replace(t1.crdt_bus_flow_type_cd,chr(13),''),chr(10),'') as crdt_bus_flow_type_cd --授信业务流程类型代码
,replace(replace(t1.crdt_rg_cd,chr(13),''),chr(10),'') as crdt_rg_cd --授信区域代码
,replace(replace(t1.estate_fin_flg,chr(13),''),chr(10),'') as estate_fin_flg --房地产融资标志
,replace(replace(t1.gover_class_fin_flg1,chr(13),''),chr(10),'') as gover_class_fin_flg1 --政府类融资标志1
,replace(replace(t1.br_build_ifin_flg,chr(13),''),chr(10),'') as br_build_ifin_flg --一带一路建设投融资标志
,replace(replace(t1.green_crdt_fin_flg,chr(13),''),chr(10),'') as green_crdt_fin_flg --绿色信贷融资标志
,replace(replace(t1.trade_cont_id,chr(13),''),chr(10),'') as trade_cont_id --贸易合同编号
,replace(replace(t1.trade_cont_curr_cd,chr(13),''),chr(10),'') as trade_cont_curr_cd --贸易合同币种代码
,t1.trade_cont_amt as trade_cont_amt --贸易合同金额
,t1.bill_qtty as bill_qtty --票据数量
,replace(replace(t1.discnt_bf_revw_flg,chr(13),''),chr(10),'') as discnt_bf_revw_flg --先贴后查标志
,t1.discnt_int_buyer_bear_ratio as discnt_int_buyer_bear_ratio --贴现利息买方承担比例
,t1.discnt_int_applit_pay_ratio as discnt_int_applit_pay_ratio --贴现利息申请人支付比例
,replace(replace(t1.agt_pay_int_flg,chr(13),''),chr(10),'') as agt_pay_int_flg --协议付息标志
,replace(replace(t1.bill_uniq_idf_id,chr(13),''),chr(10),'') as bill_uniq_idf_id --票据唯一标识编号
,replace(replace(t1.trdpty_acct_id,chr(13),''),chr(10),'') as trdpty_acct_id --第三方账户编号
,replace(replace(t1.loan_src_cd,chr(13),''),chr(10),'') as loan_src_cd --贷款来源代码
,t1.comm_fee_rat as comm_fee_rat --手续费费率
,t1.comm_fee_amt as comm_fee_amt --手续费金额
,replace(replace(t1.lc_id,chr(13),''),chr(10),'') as lc_id --信用证编号
,t1.lc_amt as lc_amt --信用证金额
,t1.syn_loan_distr_amt as syn_loan_distr_amt --银团贷款发放金额
,t1.tenor as tenor --期限
,t1.base_rat as base_rat --基准利率
,t1.int_rat_flo_val as int_rat_flo_val --利率浮动值
,t1.exec_int_rat as exec_int_rat --执行利率
,t1.bank_fin_tot as bank_fin_tot --银行融资总额
,t1.open_bal as open_bal --敞口余额
,t1.cont_amt as cont_amt --合同金额
,t1.cont_aval_bal as cont_aval_bal --合同可用余额
,t1.acm_distr_amt as acm_distr_amt --累计发放金额
,t1.acm_callbk_amt as acm_callbk_amt --累计回收金额
,t1.occu_crdt_lmt as occu_crdt_lmt --已占用授信额度
,t1.surp_crdt_lmt as surp_crdt_lmt --剩余授信额度
,replace(replace(t1.entr_loan_espec_dir_cd,chr(13),''),chr(10),'') as entr_loan_espec_dir_cd --委托贷款特殊投向代码
,replace(replace(t1.underly_prod_cls_flg,chr(13),''),chr(10),'') as underly_prod_cls_flg --标的产品分级标志
,replace(replace(t1.underly_prod_cls_lev_cd,chr(13),''),chr(10),'') as underly_prod_cls_lev_cd --标的产品分级级别代码
,replace(replace(t1.estate_loan_type_cd,chr(13),''),chr(10),'') as estate_loan_type_cd --房地产贷款类型代码
,replace(replace(t1.final_dir_type_cd,chr(13),''),chr(10),'') as final_dir_type_cd --最终投向类型代码
,replace(replace(t1.pente_type_cd,chr(13),''),chr(10),'') as pente_type_cd --穿透类型代码
,t1.underly_prod_coll_amt as underly_prod_coll_amt --标的产品募集金额
,replace(replace(t1.file_int_accr_flg,chr(13),''),chr(10),'') as file_int_accr_flg --靠档计息标志
,replace(replace(t1.ibank_bond_id,chr(13),''),chr(10),'') as ibank_bond_id --同业债券编号
,replace(replace(t1.trast_chn_cd,chr(13),''),chr(10),'') as trast_chn_cd --办理渠道代码
,t1.syn_loan_tot_amt as syn_loan_tot_amt --银团贷款总金额
,replace(replace(t1.agclt_flg,chr(13),''),chr(10),'') as agclt_flg --涉农标志
,replace(replace(t1.agclt_loan_main_type_cd,chr(13),''),chr(10),'') as agclt_loan_main_type_cd --涉农贷款主体类型代码
,replace(replace(t1.agclt_loan_dir_cd,chr(13),''),chr(10),'') as agclt_loan_dir_cd --涉农贷款投向代码
,replace(replace(t1.plat_solv_cap_src_cd,chr(13),''),chr(10),'') as plat_solv_cap_src_cd --平台偿债资金来源代码
,replace(replace(t1.buid_bus_guar_loan_flg,chr(13),''),chr(10),'') as buid_bus_guar_loan_flg --创业担保贷款标志
,replace(replace(t1.buid_bus_guar_loan_type_cd,chr(13),''),chr(10),'') as buid_bus_guar_loan_type_cd --创业担保贷款类型代码
,replace(replace(t1.secd_guar_way_cd,chr(13),''),chr(10),'') as secd_guar_way_cd --第二担保方式代码
,replace(replace(t1.imp_loan_proj,chr(13),''),chr(10),'') as imp_loan_proj --重点贷款项目代码
,replace(replace(t1.fin_sys_cont_flg,chr(13),''),chr(10),'') as fin_sys_cont_flg --融资合同标志
,replace(replace(t1.ibank_tran_org_id,chr(13),''),chr(10),'') as ibank_tran_org_id --同业交易机构编号
,replace(replace(t1.loan_enter_acct_acct_num,chr(13),''),chr(10),'') as loan_enter_acct_acct_num --贷款入账账号
,replace(replace(t1.out_acct_flg,chr(13),''),chr(10),'') as out_acct_flg --出账标志
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd --资产三分类代码
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd --基准利率类型代码
,replace(replace(t1.int_rat_mode_cd,chr(13),''),chr(10),'') as int_rat_mode_cd --利率模式代码
,t1.rsrv_amt as rsrv_amt --预留金额
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id --标准产品编号
,replace(replace(t1.ibank_asset_uniq_idf_id,chr(13),''),chr(10),'') as ibank_asset_uniq_idf_id --同业资产唯一标识编号
,replace(replace(t1.aplv_flow_num,chr(13),''),chr(10),'') as aplv_flow_num --申请流水号
from ${icl_schema}.cmm_corp_loan_cont_info t1    --对公贷款合同信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_corp_loan_cont_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
