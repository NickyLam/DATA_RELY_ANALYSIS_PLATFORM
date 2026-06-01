/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_agt_loan_cont_corp_loan_attach_info_h
CreateDate: 20241231
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h (
etl_dt  --数据日期
,agt_id  --协议编号
,cont_id  --合同编号
,trade_cont_tot_amt  --贸易合同总金额
,fin_cont_flg  --融资合同标志
,cont_type_cd  --合同类型代码
,trade_cont_id  --贸易合同编号
,lc_kind_cd  --信用证种类代码
,lc_amt  --信用证金额
,lc_curr_cd  --信用证币种代码
,lc_id  --信用证编号
,load_bill_id  --提单编号
,batch_id  --批文编号
,setup_proj_batch_id  --立项批文编号
,lc_type_cd  --信用证类型代码
,aldy_acpt_fwd_lc_flg  --已承兑远期信用证标志
,lc_tenor_type_cd  --信用证期限类型代码
,lc_char_cd  --信用证性质代码
,fwd_pay_day_tenor  --远期付款日期限
,fee_undertaker  --费用承担人
,other_fee_rat  --其他费率
,cargo_name  --货物名称
,cargo_underly  --货物标的
,cargo_traff_destination  --货物运输目的地
,traff_way_cd  --运输方式代码
,cls_freq  --分类频率
,mom_lics_id  --母证编号
,mom_lics_curr_cd  --母证币种代码
,mom_lics_amt  --母证金额
,acct_recvbl_net_amnt  --应收帐款净额
,gover_crdt_type_cd  --政府授信类型代码
,tran_bg_descb  --交易背景描述
,fix_asset_crdt_flg  --固定资产授信标志
,entr_dep_ec_cls_cd  --委托存款钞汇分类代码
,pkg_ratio  --打包比例
,guar_type_cd  --担保类型代码
,entr_loan_cap_src_cd  --委托贷款资金来源代码
,nego_bank_cfm_flg  --经议付行确认标志
,discnt_int_buyer_bear_ratio  --贴现利息买方承担比例
,discnt_bf_revw_flg  --先贴后查标志
,qual_centr_cntpty_flg  --合格中央交易对手标志
,margin_acct_id  --保证金账户编号
,margin_curr_cd  --保证金币种代码
,margin_tran_out_acct_id  --保证金转出账户编号
,col_turn_margin_acct_id  --押品转保证金账户编号
,margin_agt_rat  --保证金协议利率
,margin_int_rat_type_cd  --保证金利率类型代码
,margin_flo_val  --保证金浮动值
,margin_int_rat_float_type_cd  --保证金利率浮动类型代码
,margin_int_rat_float_way_cd  --保证金利率浮动方式代码
,margin_int_accr_method_cd  --保证金计息方法代码
,margin_int_rat_level_cd  --保证金利率档次代码
,csner_name  --委托人名称
,repay_comnt_descb  --还款说明描述
,start_up_bus_guar_loan_type_cd  --创业担保贷款类型代码
,consm_serv_class_fin_flg  --消费服务类融资标志
,pay_way_cd  --付款方式代码
,draw_comnt_descb  --提款说明描述
,loan_amt_ocup_tran_price_money_ratio  --贷款金额占交易价款比例
,trade_fin_mang_merchd  --贸易融资经营商品
,draft_qtty  --汇票数量
,discnt_commer_accpt_bil_cls_cd  --贴现商业承兑汇票分类代码
,commer_inv_id  --商业发票编号
,commer_inv_type_cd  --商业发票类型代码
,commer_inv_curr_cd  --商业发票币种代码
,commer_inv_amt  --商业发票金额
,other_lics_id  --其他许可证编号
,other_lics_name  --其他许可证名称
,hp_lics_id  --环评许可证编号
,arch_land_lics_id  --建设用地许可证编号
,plan_lics_id  --规划许可证编号
,cnstr_lics_id  --施工许可证编号
,dir_ind_fund_flg  --投向产业基金标志
,entr_loan_espec_dir_cd  --委托贷款特殊投向代码
,start_up_bus_guar_loan_flg  --创业担保贷款标志
,entr_dep_acct_id  --委托存款账户账号
,underly_prod_id  --标的产品编号
,prod_coll_amt  --产品募集金额
,underly_prod_cls_lev_cd  --标的产品分级级别代码
,surp_indus_cd  --过剩行业代码
,buy_house_site_dist_cd  --买房所在地行政区划代码
,agclt_flg  --涉农贷款标志
,cntpty_name  --交易对手名称
,cntpty_co_years  --与交易对手合作年限
,cntpty_sucs_tran_cnt  --与交易对手成功交易次数
,cntpty_strg  --交易对手实力
,other_cond_request_descb  --其他条件和要求描述
,imp_loan_proj_cd  --重点贷款项目代码
,agclt_loan_dir_cd  --涉农贷款用途类型代码
,distr_ratio  --放款比例
,obank_open_flg  --他行代开标志
,capital_amt  --资本金金额
,mgers_name  --管理方名称
,trade_fin_prod_id  --贸易融资产品编号
,benefc_local_cty_or_rg_cd  --受益人所在国家或地区
,buyer_name  --买方名称
,agclt_loan_main_type_cd  --涉农贷款类型代码
,issue_appl_form_id  --开证申请书编号
,csner_id  --委托人编号
,imp_loan_proj_flg  --重点贷款项目标志
,discnt_int_rat_comnt_descb  --贴现利率说明描述
,factor_type_cd  --保理类型代码
,agt_pay_int_flg  --协议付息标志
,start_work_dt  --开工日期
,cdb_crdt_flg  --国开行授信标志
,provi_doc_dt  --提供单据日期
,actl_finer  --实际融资人
,discnt_applit_type_cd  --贴现申请人类型代码
,invo_gover_class_fin_flg  --涉及政府类融资标志
,loan_fin_supt_way_cd  --贷款财政扶持方式代码
,three_old_trasf_city_update_proj_flg  --三旧改造城市更新项目标志
,syn_distrd_loan_amt  --银团已发放贷款金额
,cap_src_cd  --资金来源代码
,gover_crdt_supt_way_cd  --政府授信支持方式代码
,crdtc_indus_dir_cd  --征信行业投向代码
,sup_chain_fin_bus_prod_cls_cd  --供应链金融业务产品分类代码
,proj_info_text_id  --项目信息文本编号
,exist_m_l_claus_flg  --存在溢短装的条款标志
,benefc_name  --受益人名称
,entr_dep_curr_cd  --委托存款币种代码
,prepay_acct_recvbl_flg  --预付应收帐款标志
,acpt_bank_name  --承兑行名称
,distr_org_id  --放款机构编号
,cdb_crdt_prod_id  --国开行授信产品编号
,loan_usage_tran_amt  --贷款用途交易金额
,gover_crdt_flg  --政府授信标志
,dir_makti_debt_eqty_flg  --投向市场化债转股标志
,major_incre_crdt_way_cd  --主要增信方式代码
,m_l_ratio  --溢短装比例
,loan_char_cd  --贷款性质代码
,sup_chain_fin_bus_flg  --供应链金融业务标志
,advise_bank_name  --通知行名称
,tran_asset_name  --交易资产名称
,loan_trast_way_cd  --贷款办理方式代码
,payfan_type_cd  --代付类型代码
,remote_bus_flg  --异地业务标志
,estate_loan_type_cd  --房地产贷款类型代码
,discnt_int_applit_pay_ratio  --贴现利息申请人支付比例
,proj_tot_invest_amt  --项目总投资金额
,cty_lmt_indus_flg  --国家限制行业标志
,loc_fin_plat_solv_cap_src_cd  --地方融资平台偿债资金来源代码
,acct_recvbl_prepay_way_cd  --应收帐款预付方式代码
,draw_way_cd  --提款方式代码
,repay_way_cd  --还款方式代码
,overs_loan_flg  --境外贷款标志
,land_use_cert_id  --土地使用证编号
,land_use_cert_dt  --土地使用证日期
,land_plan_lics_id  --用地规划许可证编号
,land_plan_lics_dt  --用地规划许可证日期
,cnstr_lics_dt  --施工许可证日期
,proj_plan_lics_dt  --工程规划许可证日期
,order_name  --购货方名称
,seller_name  --销货方名称
,trade_tran_content_descb  --贸易交易内容描述
,advanced_manu_flg  --先进制造业标志
,cultur_industry_flg  --文化产业标志
,only_new_minorent_flg  --专精特新中小企业标志
,only_new_littlegiantent_flg  --专精特新小巨人企业标志
,strtg_new_indus_type_cd  --战略新兴产业类型代码
,indent_tech_flg  --工业企业技术改造升级标志
,start_dt  --开始时间
,end_dt  --结束时间

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合同编号
,t1.trade_cont_tot_amt as trade_cont_tot_amt --贸易合同总金额
,replace(replace(t1.fin_cont_flg,chr(13),''),chr(10),'') as fin_cont_flg --融资合同标志
,replace(replace(t1.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd --合同类型代码
,replace(replace(t1.trade_cont_id,chr(13),''),chr(10),'') as trade_cont_id --贸易合同编号
,replace(replace(t1.lc_kind_cd,chr(13),''),chr(10),'') as lc_kind_cd --信用证种类代码
,t1.lc_amt as lc_amt --信用证金额
,replace(replace(t1.lc_curr_cd,chr(13),''),chr(10),'') as lc_curr_cd --信用证币种代码
,replace(replace(t1.lc_id,chr(13),''),chr(10),'') as lc_id --信用证编号
,replace(replace(t1.load_bill_id,chr(13),''),chr(10),'') as load_bill_id --提单编号
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id --批文编号
,replace(replace(t1.setup_proj_batch_id,chr(13),''),chr(10),'') as setup_proj_batch_id --立项批文编号
,replace(replace(t1.lc_type_cd,chr(13),''),chr(10),'') as lc_type_cd --信用证类型代码
,replace(replace(t1.aldy_acpt_fwd_lc_flg,chr(13),''),chr(10),'') as aldy_acpt_fwd_lc_flg --已承兑远期信用证标志
,replace(replace(t1.lc_tenor_type_cd,chr(13),''),chr(10),'') as lc_tenor_type_cd --信用证期限类型代码
,replace(replace(t1.lc_char_cd,chr(13),''),chr(10),'') as lc_char_cd --信用证性质代码
,t1.fwd_pay_day_tenor as fwd_pay_day_tenor --远期付款日期限
,replace(replace(t1.fee_undertaker,chr(13),''),chr(10),'') as fee_undertaker --费用承担人
,t1.other_fee_rat as other_fee_rat --其他费率
,replace(replace(t1.cargo_name,chr(13),''),chr(10),'') as cargo_name --货物名称
,t1.cargo_underly as cargo_underly --货物标的
,replace(replace(t1.cargo_traff_destination,chr(13),''),chr(10),'') as cargo_traff_destination --货物运输目的地
,replace(replace(t1.traff_way_cd,chr(13),''),chr(10),'') as traff_way_cd --运输方式代码
,t1.cls_freq as cls_freq --分类频率
,replace(replace(t1.mom_lics_id,chr(13),''),chr(10),'') as mom_lics_id --母证编号
,replace(replace(t1.mom_lics_curr_cd,chr(13),''),chr(10),'') as mom_lics_curr_cd --母证币种代码
,t1.mom_lics_amt as mom_lics_amt --母证金额
,t1.acct_recvbl_net_amnt as acct_recvbl_net_amnt --应收帐款净额
,replace(replace(t1.gover_crdt_type_cd,chr(13),''),chr(10),'') as gover_crdt_type_cd --政府授信类型代码
,replace(replace(t1.tran_bg_descb,chr(13),''),chr(10),'') as tran_bg_descb --交易背景描述
,replace(replace(t1.fix_asset_crdt_flg,chr(13),''),chr(10),'') as fix_asset_crdt_flg --固定资产授信标志
,replace(replace(t1.entr_dep_ec_cls_cd,chr(13),''),chr(10),'') as entr_dep_ec_cls_cd --委托存款钞汇分类代码
,t1.pkg_ratio as pkg_ratio --打包比例
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd --担保类型代码
,replace(replace(t1.entr_loan_cap_src_cd,chr(13),''),chr(10),'') as entr_loan_cap_src_cd --委托贷款资金来源代码
,replace(replace(t1.nego_bank_cfm_flg,chr(13),''),chr(10),'') as nego_bank_cfm_flg --经议付行确认标志
,t1.discnt_int_buyer_bear_ratio as discnt_int_buyer_bear_ratio --贴现利息买方承担比例
,replace(replace(t1.discnt_bf_revw_flg,chr(13),''),chr(10),'') as discnt_bf_revw_flg --先贴后查标志
,replace(replace(t1.qual_centr_cntpty_flg,chr(13),''),chr(10),'') as qual_centr_cntpty_flg --合格中央交易对手标志
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id --保证金账户编号
,replace(replace(t1.margin_curr_cd,chr(13),''),chr(10),'') as margin_curr_cd --保证金币种代码
,replace(replace(t1.margin_tran_out_acct_id,chr(13),''),chr(10),'') as margin_tran_out_acct_id --保证金转出账户编号
,replace(replace(t1.col_turn_margin_acct_id,chr(13),''),chr(10),'') as col_turn_margin_acct_id --押品转保证金账户编号
,t1.margin_agt_rat as margin_agt_rat --保证金协议利率
,replace(replace(t1.margin_int_rat_type_cd,chr(13),''),chr(10),'') as margin_int_rat_type_cd --保证金利率类型代码
,t1.margin_flo_val as margin_flo_val --保证金浮动值
,replace(replace(t1.margin_int_rat_float_type_cd,chr(13),''),chr(10),'') as margin_int_rat_float_type_cd --保证金利率浮动类型代码
,replace(replace(t1.margin_int_rat_float_way_cd,chr(13),''),chr(10),'') as margin_int_rat_float_way_cd --保证金利率浮动方式代码
,replace(replace(t1.margin_int_accr_method_cd,chr(13),''),chr(10),'') as margin_int_accr_method_cd --保证金计息方法代码
,replace(replace(t1.margin_int_rat_level_cd,chr(13),''),chr(10),'') as margin_int_rat_level_cd --保证金利率档次代码
,replace(replace(t1.csner_name,chr(13),''),chr(10),'') as csner_name --委托人名称
,replace(replace(t1.repay_comnt_descb,chr(13),''),chr(10),'') as repay_comnt_descb --还款说明描述
,replace(replace(t1.start_up_bus_guar_loan_type_cd,chr(13),''),chr(10),'') as start_up_bus_guar_loan_type_cd --创业担保贷款类型代码
,replace(replace(t1.consm_serv_class_fin_flg,chr(13),''),chr(10),'') as consm_serv_class_fin_flg --消费服务类融资标志
,replace(replace(t1.pay_way_cd,chr(13),''),chr(10),'') as pay_way_cd --付款方式代码
,replace(replace(t1.draw_comnt_descb,chr(13),''),chr(10),'') as draw_comnt_descb --提款说明描述
,t1.loan_amt_ocup_tran_price_money_ratio as loan_amt_ocup_tran_price_money_ratio --贷款金额占交易价款比例
,replace(replace(t1.trade_fin_mang_merchd,chr(13),''),chr(10),'') as trade_fin_mang_merchd --贸易融资经营商品
,t1.draft_qtty as draft_qtty --汇票数量
,replace(replace(t1.discnt_commer_accpt_bil_cls_cd,chr(13),''),chr(10),'') as discnt_commer_accpt_bil_cls_cd --贴现商业承兑汇票分类代码
,replace(replace(t1.commer_inv_id,chr(13),''),chr(10),'') as commer_inv_id --商业发票编号
,replace(replace(t1.commer_inv_type_cd,chr(13),''),chr(10),'') as commer_inv_type_cd --商业发票类型代码
,replace(replace(t1.commer_inv_curr_cd,chr(13),''),chr(10),'') as commer_inv_curr_cd --商业发票币种代码
,t1.commer_inv_amt as commer_inv_amt --商业发票金额
,replace(replace(t1.other_lics_id,chr(13),''),chr(10),'') as other_lics_id --其他许可证编号
,replace(replace(t1.other_lics_name,chr(13),''),chr(10),'') as other_lics_name --其他许可证名称
,replace(replace(t1.hp_lics_id,chr(13),''),chr(10),'') as hp_lics_id --环评许可证编号
,replace(replace(t1.arch_land_lics_id,chr(13),''),chr(10),'') as arch_land_lics_id --建设用地许可证编号
,replace(replace(t1.plan_lics_id,chr(13),''),chr(10),'') as plan_lics_id --规划许可证编号
,replace(replace(t1.cnstr_lics_id,chr(13),''),chr(10),'') as cnstr_lics_id --施工许可证编号
,replace(replace(t1.dir_ind_fund_flg,chr(13),''),chr(10),'') as dir_ind_fund_flg --投向产业基金标志
,replace(replace(t1.entr_loan_espec_dir_cd,chr(13),''),chr(10),'') as entr_loan_espec_dir_cd --委托贷款特殊投向代码
,replace(replace(t1.start_up_bus_guar_loan_flg,chr(13),''),chr(10),'') as start_up_bus_guar_loan_flg --创业担保贷款标志
,replace(replace(t1.entr_dep_acct_id,chr(13),''),chr(10),'') as entr_dep_acct_id --委托存款账户账号
,replace(replace(t1.underly_prod_id,chr(13),''),chr(10),'') as underly_prod_id --标的产品编号
,t1.prod_coll_amt as prod_coll_amt --产品募集金额
,replace(replace(t1.underly_prod_cls_lev_cd,chr(13),''),chr(10),'') as underly_prod_cls_lev_cd --标的产品分级级别代码
,replace(replace(t1.surp_indus_cd,chr(13),''),chr(10),'') as surp_indus_cd --过剩行业代码
,replace(replace(t1.buy_house_site_dist_cd,chr(13),''),chr(10),'') as buy_house_site_dist_cd --买房所在地行政区划代码
,replace(replace(t1.agclt_flg,chr(13),''),chr(10),'') as agclt_flg --涉农贷款标志
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name --交易对手名称
,replace(replace(t1.cntpty_co_years,chr(13),''),chr(10),'') as cntpty_co_years --与交易对手合作年限
,t1.cntpty_sucs_tran_cnt as cntpty_sucs_tran_cnt --与交易对手成功交易次数
,replace(replace(t1.cntpty_strg,chr(13),''),chr(10),'') as cntpty_strg --交易对手实力
,replace(replace(t1.other_cond_request_descb,chr(13),''),chr(10),'') as other_cond_request_descb --其他条件和要求描述
,replace(replace(t1.imp_loan_proj_cd,chr(13),''),chr(10),'') as imp_loan_proj_cd --重点贷款项目代码
,replace(replace(t1.agclt_loan_dir_cd,chr(13),''),chr(10),'') as agclt_loan_dir_cd --涉农贷款用途类型代码
,t1.distr_ratio as distr_ratio --放款比例
,replace(replace(t1.obank_open_flg,chr(13),''),chr(10),'') as obank_open_flg --他行代开标志
,t1.capital_amt as capital_amt --资本金金额
,replace(replace(t1.mgers_name,chr(13),''),chr(10),'') as mgers_name --管理方名称
,replace(replace(t1.trade_fin_prod_id,chr(13),''),chr(10),'') as trade_fin_prod_id --贸易融资产品编号
,replace(replace(t1.benefc_local_cty_or_rg_cd,chr(13),''),chr(10),'') as benefc_local_cty_or_rg_cd --受益人所在国家或地区
,replace(replace(t1.buyer_name,chr(13),''),chr(10),'') as buyer_name --买方名称
,replace(replace(t1.agclt_loan_main_type_cd,chr(13),''),chr(10),'') as agclt_loan_main_type_cd --涉农贷款类型代码
,replace(replace(t1.issue_appl_form_id,chr(13),''),chr(10),'') as issue_appl_form_id --开证申请书编号
,replace(replace(t1.csner_id,chr(13),''),chr(10),'') as csner_id --委托人编号
,replace(replace(t1.imp_loan_proj_flg,chr(13),''),chr(10),'') as imp_loan_proj_flg --重点贷款项目标志
,replace(replace(t1.discnt_int_rat_comnt_descb,chr(13),''),chr(10),'') as discnt_int_rat_comnt_descb --贴现利率说明描述
,replace(replace(t1.factor_type_cd,chr(13),''),chr(10),'') as factor_type_cd --保理类型代码
,replace(replace(t1.agt_pay_int_flg,chr(13),''),chr(10),'') as agt_pay_int_flg --协议付息标志
,t1.start_work_dt as start_work_dt --开工日期
,replace(replace(t1.cdb_crdt_flg,chr(13),''),chr(10),'') as cdb_crdt_flg --国开行授信标志
,t1.provi_doc_dt as provi_doc_dt --提供单据日期
,replace(replace(t1.actl_finer,chr(13),''),chr(10),'') as actl_finer --实际融资人
,replace(replace(t1.discnt_applit_type_cd,chr(13),''),chr(10),'') as discnt_applit_type_cd --贴现申请人类型代码
,replace(replace(t1.invo_gover_class_fin_flg,chr(13),''),chr(10),'') as invo_gover_class_fin_flg --涉及政府类融资标志
,replace(replace(t1.loan_fin_supt_way_cd,chr(13),''),chr(10),'') as loan_fin_supt_way_cd --贷款财政扶持方式代码
,replace(replace(t1.three_old_trasf_city_update_proj_flg,chr(13),''),chr(10),'') as three_old_trasf_city_update_proj_flg --三旧改造城市更新项目标志
,t1.syn_distrd_loan_amt as syn_distrd_loan_amt --银团已发放贷款金额
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd --资金来源代码
,replace(replace(t1.gover_crdt_supt_way_cd,chr(13),''),chr(10),'') as gover_crdt_supt_way_cd --政府授信支持方式代码
,replace(replace(t1.crdtc_indus_dir_cd,chr(13),''),chr(10),'') as crdtc_indus_dir_cd --征信行业投向代码
,replace(replace(t1.sup_chain_fin_bus_prod_cls_cd,chr(13),''),chr(10),'') as sup_chain_fin_bus_prod_cls_cd --供应链金融业务产品分类代码
,replace(replace(t1.proj_info_text_id,chr(13),''),chr(10),'') as proj_info_text_id --项目信息文本编号
,replace(replace(t1.exist_m_l_claus_flg,chr(13),''),chr(10),'') as exist_m_l_claus_flg --存在溢短装的条款标志
,replace(replace(t1.benefc_name,chr(13),''),chr(10),'') as benefc_name --受益人名称
,replace(replace(t1.entr_dep_curr_cd,chr(13),''),chr(10),'') as entr_dep_curr_cd --委托存款币种代码
,replace(replace(t1.prepay_acct_recvbl_flg,chr(13),''),chr(10),'') as prepay_acct_recvbl_flg --预付应收帐款标志
,replace(replace(t1.acpt_bank_name,chr(13),''),chr(10),'') as acpt_bank_name --承兑行名称
,replace(replace(t1.distr_org_id,chr(13),''),chr(10),'') as distr_org_id --放款机构编号
,replace(replace(t1.cdb_crdt_prod_id,chr(13),''),chr(10),'') as cdb_crdt_prod_id --国开行授信产品编号
,t1.loan_usage_tran_amt as loan_usage_tran_amt --贷款用途交易金额
,replace(replace(t1.gover_crdt_flg,chr(13),''),chr(10),'') as gover_crdt_flg --政府授信标志
,replace(replace(t1.dir_makti_debt_eqty_flg,chr(13),''),chr(10),'') as dir_makti_debt_eqty_flg --投向市场化债转股标志
,replace(replace(t1.major_incre_crdt_way_cd,chr(13),''),chr(10),'') as major_incre_crdt_way_cd --主要增信方式代码
,t1.m_l_ratio as m_l_ratio --溢短装比例
,replace(replace(t1.loan_char_cd,chr(13),''),chr(10),'') as loan_char_cd --贷款性质代码
,replace(replace(t1.sup_chain_fin_bus_flg,chr(13),''),chr(10),'') as sup_chain_fin_bus_flg --供应链金融业务标志
,replace(replace(t1.advise_bank_name,chr(13),''),chr(10),'') as advise_bank_name --通知行名称
,replace(replace(t1.tran_asset_name,chr(13),''),chr(10),'') as tran_asset_name --交易资产名称
,replace(replace(t1.loan_trast_way_cd,chr(13),''),chr(10),'') as loan_trast_way_cd --贷款办理方式代码
,replace(replace(t1.payfan_type_cd,chr(13),''),chr(10),'') as payfan_type_cd --代付类型代码
,replace(replace(t1.remote_bus_flg,chr(13),''),chr(10),'') as remote_bus_flg --异地业务标志
,replace(replace(t1.estate_loan_type_cd,chr(13),''),chr(10),'') as estate_loan_type_cd --房地产贷款类型代码
,t1.discnt_int_applit_pay_ratio as discnt_int_applit_pay_ratio --贴现利息申请人支付比例
,t1.proj_tot_invest_amt as proj_tot_invest_amt --项目总投资金额
,replace(replace(t1.cty_lmt_indus_flg,chr(13),''),chr(10),'') as cty_lmt_indus_flg --国家限制行业标志
,replace(replace(t1.loc_fin_plat_solv_cap_src_cd,chr(13),''),chr(10),'') as loc_fin_plat_solv_cap_src_cd --地方融资平台偿债资金来源代码
,replace(replace(t1.acct_recvbl_prepay_way_cd,chr(13),''),chr(10),'') as acct_recvbl_prepay_way_cd --应收帐款预付方式代码
,replace(replace(t1.draw_way_cd,chr(13),''),chr(10),'') as draw_way_cd --提款方式代码
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd --还款方式代码
,replace(replace(t1.overs_loan_flg,chr(13),''),chr(10),'') as overs_loan_flg --境外贷款标志
,replace(replace(t1.land_use_cert_id,chr(13),''),chr(10),'') as land_use_cert_id --土地使用证编号
,t1.land_use_cert_dt as land_use_cert_dt --土地使用证日期
,replace(replace(t1.land_plan_lics_id,chr(13),''),chr(10),'') as land_plan_lics_id --用地规划许可证编号
,t1.land_plan_lics_dt as land_plan_lics_dt --用地规划许可证日期
,t1.cnstr_lics_dt as cnstr_lics_dt --施工许可证日期
,t1.proj_plan_lics_dt as proj_plan_lics_dt --工程规划许可证日期
,replace(replace(t1.order_name,chr(13),''),chr(10),'') as order_name --购货方名称
,replace(replace(t1.seller_name,chr(13),''),chr(10),'') as seller_name --销货方名称
,replace(replace(t1.trade_tran_content_descb,chr(13),''),chr(10),'') as trade_tran_content_descb --贸易交易内容描述
,replace(replace(t1.advanced_manu_flg,chr(13),''),chr(10),'') as advanced_manu_flg --先进制造业标志
,replace(replace(t1.cultur_industry_flg,chr(13),''),chr(10),'') as cultur_industry_flg --文化产业标志
,replace(replace(t1.only_new_minorent_flg,chr(13),''),chr(10),'') as only_new_minorent_flg --专精特新中小企业标志
,replace(replace(t1.only_new_littlegiantent_flg,chr(13),''),chr(10),'') as only_new_littlegiantent_flg --专精特新小巨人企业标志
,replace(replace(t1.strtg_new_indus_type_cd,chr(13),''),chr(10),'') as strtg_new_indus_type_cd --战略新兴产业类型代码
,replace(replace(t1.indent_tech_flg,chr(13),''),chr(10),'') as indent_tech_flg --工业企业技术改造升级标志
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间

from ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h t1    --贷款合同对公贷款附属信息历史
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'agt_loan_cont_corp_loan_attach_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
