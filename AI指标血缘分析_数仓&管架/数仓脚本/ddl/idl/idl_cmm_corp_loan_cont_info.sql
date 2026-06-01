/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl cmm_corp_loan_cont_info
CreateDate: 20250508
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.cmm_corp_loan_cont_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.cmm_corp_loan_cont_info(
etl_dt date --ETL处理日期
,lp_id varchar2(60) --法人编号
,cont_id varchar2(60) --合同编号
,cust_id varchar2(60) --客户编号
,lmt_cont_id varchar2(60) --额度合同编号
,apv_flow_num varchar2(60) --授信申请流水号
,manu_cont_id varchar2(500) --人工合同编号
,bus_breed_id varchar2(60) --业务品种编号
,bus_sub_type_cd varchar2(60) --业务子类型代码
,loan_happ_type_cd varchar2(30) --贷款发生类型代码
,cont_type_cd varchar2(10) --合同类型代码
,strtg_new_indus_type_cd varchar2(10) --战略新兴产业类型代码
,prod_type_cd varchar2(60) --产品类型代码
,valid_flg_cd varchar2(10) --有效标志代码
,dir_indus_cd varchar2(10) --投向行业代码
,surp_indus_cd varchar2(10) --过剩行业代码
,sub_guar_way_cd varchar2(10) --子担保方式代码
,guar_type_cd varchar2(10) --担保类型代码
,major_guar_way_cd varchar2(10) --主要担保方式代码
,crdt_type_cd varchar2(10) --授信类型代码
,appl_way_cd varchar2(30) --申请方式代码
,loan_fin_supt_way_cd varchar2(60) --贷款财政扶持方式代码
,invest_way_cd varchar2(10) --投资方式代码
,mgmt_mode_cd varchar2(10) --管理模式代码
,loan_level5_cls_cd varchar2(10) --贷款五级分类代码
,loan_level10_cls_cd varchar2(10) --贷款十级分类代码
,tenor_type_cd varchar2(10) --期限类型代码
,pric_repay_way_cd varchar2(10) --本金还款方式代码
,int_rat_float_way_cd varchar2(10) --利率浮动方式代码
,charge_way_cd varchar2(30) --收费方式代码
,draw_way_cd varchar2(10) --提款方式代码
,cap_src_cd varchar2(10) --资金来源代码
,int_rat_adj_way_cd varchar2(10) --利率调整方式代码
,curr_cd varchar2(10) --币种代码
,sup_chain_fin_bus_prod_cls_cd varchar2(10) --供应链金融业务产品分类代码
,sup_chain_fin_bus_flg varchar2(10) --供应链金融业务标志
,agent_patip_loan_flg varchar2(10) --代理参贷标志
,lmt_circl_flg varchar2(10) --额度循环标志
,circl_flg varchar2(10) --循环标志
,temp_store_flg varchar2(10) --暂存标志
,froz_flg varchar2(10) --冻结标志
,turn_crdt_flg varchar2(10) --转授信标志
,remote_loan_flg varchar2(10) --异地贷款标志
,other_guar_way_flg varchar2(10) --其他担保方式标志
,imp_proj_loan_flg varchar2(10) --重点项目贷款标志
,cty_lmt_indus_flg varchar2(10) --国家限制行业标志
,gover_crdt_flg varchar2(10) --政府授信标志
,cdb_crdt_flg varchar2(10) --国开行授信标志
,fix_asset_crdt_flg varchar2(10) --固定资产授信标志
,qual_centr_cntpty_flg varchar2(10) --合格中央交易对手标志
,low_risk_bus_flg varchar2(10) --低风险业务标志
,host_bank_no varchar2(200) --主办行行号
,patip_loan_bank_no varchar2(500) --参贷行行号
,agent_bank_no varchar2(200) --代理行行号
,cntpty_strg varchar2(60) --交易对手实力
,cntpty_co_years varchar2(60) --与交易对手合作年限
,cntpty_sucs_tran_cnt varchar2(60) --与交易对手成功交易次数
,mgmt_org_id varchar2(60) --管理机构编号
,rgst_org_id varchar2(60) --登记机构编号
,oper_org_id varchar2(60) --经办机构编号
,distr_org_id varchar2(60) --放款机构编号
,mgmt_teller_id varchar2(60) --管理柜员编号
,oper_teller_id varchar2(60) --经办柜员编号
,rgst_teller_id varchar2(60) --登记柜员编号
,start_dt date --起始日期
,distr_dt date --发放日期
,exp_dt date --到期日期
,oper_dt date --经办日期
,rgst_dt date --登记日期
,termnt_dt date --终止日期
,lmt_use_latest_dt date --额度使用最迟日期
,lmt_under_bus_latest_exp_dt date --额度项下业务最迟到期日期
,loan_usage_descb varchar2(2000) --贷款用途描述
,repay_src_descb varchar2(500) --还款来源描述
,other_cond_request_descb varchar2(4000) --其他条件和要求描述
,trdpty_cust_name1 varchar2(250) --第三方客户名称1
,trdpty_cust_name2 varchar2(250) --第三方客户名称2
,rela_cont_id varchar2(60) --相关合同编号
,stl_acct_num varchar2(60) --结算账号
,margin_acct_num varchar2(60) --保证金账号
,margin_curr_cd varchar2(10) --保证金币种代码
,margin_ratio number(18,6) --保证金比例
,margin_amt number(30,2) --保证金金额
,tran_market_type_cd varchar2(10) --交易市场类型代码
,incre_crdt_way_cd varchar2(10) --增信方式代码
,batch_data_src_cd varchar2(10) --批量数据来源代码
,backup_lmt_effect_cd varchar2(10) --备份额度生效代码
,backup_lmt_cont_id varchar2(60) --备份额度合同编号
,risk_type_cd varchar2(20) --风险类型代码
,major_loan_cls_cd varchar2(60) --专业贷款分类代码
,risk_expose_cls varchar2(100) --风险暴露分类
,tran_asset_name varchar2(250) --交易资产名称
,dir_ind_fund_flg varchar2(10) --投向产业基金标志
,dir_makti_debt_eqty_flg varchar2(10) --投向市场化债转股标志
,invo_gover_class_fin_flg varchar2(10) --涉及政府类融资标志
,consm_serv_class_fin_flg varchar2(10) --消费服务类融资标志
,stl_dep_flg varchar2(10) --结算性存款标志
,cota_opt_choice_flg varchar2(10) --含有回售选择权标志
,septbl_flg varchar2(10) --可分离标志
,onl_bus_flg varchar2(10) --线上业务标志
,class_crdt_flg varchar2(10) --类信贷标志
,crdt_bus_flow_type_cd varchar2(30) --授信业务流程类型代码
,crdt_rg_cd varchar2(10) --授信区域代码
,estate_fin_flg varchar2(10) --房地产融资标志
,gover_class_fin_flg1 varchar2(10) --政府类融资标志1
,br_build_ifin_flg varchar2(10) --一带一路建设投融资标志
,green_crdt_fin_flg varchar2(10) --绿色信贷融资标志
,trade_cont_id varchar2(60) --贸易合同编号
,trade_cont_curr_cd varchar2(10) --贸易合同币种代码
,trade_cont_amt number(30,2) --贸易合同金额
,bill_qtty number(30) --票据数量
,discnt_bf_revw_flg varchar2(10) --先贴后查标志
,discnt_int_buyer_bear_ratio number(18,6) --贴现利息买方承担比例
,discnt_int_applit_pay_ratio number(18,6) --贴现利息申请人支付比例
,agt_pay_int_flg varchar2(10) --协议付息标志
,bill_uniq_idf_id varchar2(60) --票据唯一标识编号
,trdpty_acct_id varchar2(60) --第三方账户编号
,loan_src_cd varchar2(10) --贷款来源代码
,comm_fee_rat number(18,8) --手续费费率
,comm_fee_amt number(30,2) --手续费金额
,lc_id varchar2(60) --信用证编号
,lc_amt number(30,2) --信用证金额
,syn_loan_distr_amt number(30,2) --银团贷款发放金额
,tenor number(20,0) --期限
,base_rat number(18,8) --基准利率
,int_rat_flo_val number(18,6) --利率浮动值
,exec_int_rat number(18,8) --执行利率
,bank_fin_tot number(30,2) --银行融资总额
,open_bal number(30,2) --敞口余额
,cont_amt number(30,2) --合同金额
,cont_aval_bal number(30,2) --合同可用余额
,acm_distr_amt number(30,2) --累计发放金额
,acm_callbk_amt number(30,2) --累计回收金额
,occu_crdt_lmt number(30,2) --已占用授信额度
,surp_crdt_lmt number(30,2) --剩余授信额度
,entr_loan_espec_dir_cd varchar2(30) --委托贷款特殊投向代码
,underly_prod_cls_flg varchar2(10) --标的产品分级标志
,underly_prod_cls_lev_cd varchar2(30) --标的产品分级级别代码
,estate_loan_type_cd varchar2(30) --房地产贷款类型代码
,final_dir_type_cd varchar2(30) --最终投向类型代码
,pente_type_cd varchar2(30) --穿透类型代码
,underly_prod_coll_amt number(30,8) --标的产品募集金额
,file_int_accr_flg varchar2(10) --靠档计息标志
,ibank_bond_id varchar2(250) --同业债券编号
,trast_chn_cd varchar2(30) --办理渠道代码
,syn_loan_tot_amt number(30,8) --银团贷款总金额
,agclt_flg varchar2(10) --涉农标志
,agclt_loan_main_type_cd varchar2(30) --涉农贷款主体类型代码
,agclt_loan_dir_cd varchar2(30) --涉农贷款投向代码
,plat_solv_cap_src_cd varchar2(30) --平台偿债资金来源代码
,buid_bus_guar_loan_flg varchar2(10) --创业担保贷款标志
,buid_bus_guar_loan_type_cd varchar2(30) --创业担保贷款类型代码
,secd_guar_way_cd varchar2(30) --第二担保方式代码
,imp_loan_proj varchar2(30) --重点贷款项目代码
,fin_sys_cont_flg varchar2(10) --融资合同标志
,ibank_tran_org_id varchar2(60) --同业交易机构编号
,loan_enter_acct_acct_num varchar2(60) --贷款入账账号
,out_acct_flg varchar2(10) --出账标志
,asset_thd_cls_cd varchar2(30) --资产三分类代码
,base_rat_type_cd varchar2(30) --基准利率类型代码
,int_rat_mode_cd varchar2(30) --利率模式代码
,rsrv_amt number(30,6) --预留金额
,std_prod_id varchar2(60) --标准产品编号
,ibank_asset_uniq_idf_id varchar2(100) --同业资产唯一标识编号
,aplv_flow_num varchar2(100) --申请流水号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.cmm_corp_loan_cont_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.cmm_corp_loan_cont_info is '对公贷款合同信息';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.lp_id is '法人编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cont_id is '合同编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cust_id is '客户编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.lmt_cont_id is '额度合同编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.apv_flow_num is '授信申请流水号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.manu_cont_id is '人工合同编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.bus_breed_id is '业务品种编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.bus_sub_type_cd is '业务子类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.loan_happ_type_cd is '贷款发生类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cont_type_cd is '合同类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.strtg_new_indus_type_cd is '战略新兴产业类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.prod_type_cd is '产品类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.valid_flg_cd is '有效标志代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.dir_indus_cd is '投向行业代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.surp_indus_cd is '过剩行业代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.sub_guar_way_cd is '子担保方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.guar_type_cd is '担保类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.major_guar_way_cd is '主要担保方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.crdt_type_cd is '授信类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.appl_way_cd is '申请方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.loan_fin_supt_way_cd is '贷款财政扶持方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.invest_way_cd is '投资方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.mgmt_mode_cd is '管理模式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.loan_level10_cls_cd is '贷款十级分类代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.tenor_type_cd is '期限类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.pric_repay_way_cd is '本金还款方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.int_rat_float_way_cd is '利率浮动方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.charge_way_cd is '收费方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.draw_way_cd is '提款方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cap_src_cd is '资金来源代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.curr_cd is '币种代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.sup_chain_fin_bus_prod_cls_cd is '供应链金融业务产品分类代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.sup_chain_fin_bus_flg is '供应链金融业务标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.agent_patip_loan_flg is '代理参贷标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.lmt_circl_flg is '额度循环标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.circl_flg is '循环标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.temp_store_flg is '暂存标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.froz_flg is '冻结标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.turn_crdt_flg is '转授信标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.remote_loan_flg is '异地贷款标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.other_guar_way_flg is '其他担保方式标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.imp_proj_loan_flg is '重点项目贷款标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cty_lmt_indus_flg is '国家限制行业标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.gover_crdt_flg is '政府授信标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cdb_crdt_flg is '国开行授信标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.fix_asset_crdt_flg is '固定资产授信标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.qual_centr_cntpty_flg is '合格中央交易对手标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.low_risk_bus_flg is '低风险业务标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.host_bank_no is '主办行行号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.patip_loan_bank_no is '参贷行行号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.agent_bank_no is '代理行行号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cntpty_strg is '交易对手实力';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cntpty_co_years is '与交易对手合作年限';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cntpty_sucs_tran_cnt is '与交易对手成功交易次数';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.mgmt_org_id is '管理机构编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.oper_org_id is '经办机构编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.distr_org_id is '放款机构编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.mgmt_teller_id is '管理柜员编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.oper_teller_id is '经办柜员编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.rgst_teller_id is '登记柜员编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.start_dt is '起始日期';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.distr_dt is '发放日期';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.exp_dt is '到期日期';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.oper_dt is '经办日期';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.rgst_dt is '登记日期';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.termnt_dt is '终止日期';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.lmt_use_latest_dt is '额度使用最迟日期';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.lmt_under_bus_latest_exp_dt is '额度项下业务最迟到期日期';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.loan_usage_descb is '贷款用途描述';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.repay_src_descb is '还款来源描述';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.other_cond_request_descb is '其他条件和要求描述';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.trdpty_cust_name1 is '第三方客户名称1';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.trdpty_cust_name2 is '第三方客户名称2';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.rela_cont_id is '相关合同编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.stl_acct_num is '结算账号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.margin_acct_num is '保证金账号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.margin_curr_cd is '保证金币种代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.margin_ratio is '保证金比例';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.margin_amt is '保证金金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.tran_market_type_cd is '交易市场类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.incre_crdt_way_cd is '增信方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.batch_data_src_cd is '批量数据来源代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.backup_lmt_effect_cd is '备份额度生效代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.backup_lmt_cont_id is '备份额度合同编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.risk_type_cd is '风险类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.major_loan_cls_cd is '专业贷款分类代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.risk_expose_cls is '风险暴露分类';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.tran_asset_name is '交易资产名称';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.dir_ind_fund_flg is '投向产业基金标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.dir_makti_debt_eqty_flg is '投向市场化债转股标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.invo_gover_class_fin_flg is '涉及政府类融资标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.consm_serv_class_fin_flg is '消费服务类融资标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.stl_dep_flg is '结算性存款标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cota_opt_choice_flg is '含有回售选择权标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.septbl_flg is '可分离标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.onl_bus_flg is '线上业务标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.class_crdt_flg is '类信贷标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.crdt_bus_flow_type_cd is '授信业务流程类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.crdt_rg_cd is '授信区域代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.estate_fin_flg is '房地产融资标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.gover_class_fin_flg1 is '政府类融资标志1';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.br_build_ifin_flg is '一带一路建设投融资标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.green_crdt_fin_flg is '绿色信贷融资标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.trade_cont_id is '贸易合同编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.trade_cont_curr_cd is '贸易合同币种代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.trade_cont_amt is '贸易合同金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.bill_qtty is '票据数量';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.discnt_bf_revw_flg is '先贴后查标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.discnt_int_buyer_bear_ratio is '贴现利息买方承担比例';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.discnt_int_applit_pay_ratio is '贴现利息申请人支付比例';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.agt_pay_int_flg is '协议付息标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.bill_uniq_idf_id is '票据唯一标识编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.trdpty_acct_id is '第三方账户编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.loan_src_cd is '贷款来源代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.comm_fee_rat is '手续费费率';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.comm_fee_amt is '手续费金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.lc_id is '信用证编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.lc_amt is '信用证金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.syn_loan_distr_amt is '银团贷款发放金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.tenor is '期限';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.base_rat is '基准利率';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.int_rat_flo_val is '利率浮动值';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.exec_int_rat is '执行利率';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.bank_fin_tot is '银行融资总额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.open_bal is '敞口余额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cont_amt is '合同金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.cont_aval_bal is '合同可用余额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.acm_distr_amt is '累计发放金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.acm_callbk_amt is '累计回收金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.occu_crdt_lmt is '已占用授信额度';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.surp_crdt_lmt is '剩余授信额度';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.entr_loan_espec_dir_cd is '委托贷款特殊投向代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.underly_prod_cls_flg is '标的产品分级标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.underly_prod_cls_lev_cd is '标的产品分级级别代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.estate_loan_type_cd is '房地产贷款类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.final_dir_type_cd is '最终投向类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.pente_type_cd is '穿透类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.underly_prod_coll_amt is '标的产品募集金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.file_int_accr_flg is '靠档计息标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.ibank_bond_id is '同业债券编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.trast_chn_cd is '办理渠道代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.syn_loan_tot_amt is '银团贷款总金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.agclt_flg is '涉农标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.agclt_loan_main_type_cd is '涉农贷款主体类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.agclt_loan_dir_cd is '涉农贷款投向代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.plat_solv_cap_src_cd is '平台偿债资金来源代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.buid_bus_guar_loan_flg is '创业担保贷款标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.buid_bus_guar_loan_type_cd is '创业担保贷款类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.secd_guar_way_cd is '第二担保方式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.imp_loan_proj is '重点贷款项目代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.fin_sys_cont_flg is '融资合同标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.ibank_tran_org_id is '同业交易机构编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.loan_enter_acct_acct_num is '贷款入账账号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.out_acct_flg is '出账标志';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.asset_thd_cls_cd is '资产三分类代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.base_rat_type_cd is '基准利率类型代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.int_rat_mode_cd is '利率模式代码';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.rsrv_amt is '预留金额';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.std_prod_id is '标准产品编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.ibank_asset_uniq_idf_id is '同业资产唯一标识编号';
comment on column ${idl_schema}.cmm_corp_loan_cont_info.aplv_flow_num is '申请流水号';

