/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl agt_loan_cont_corp_loan_attach_info_h
CreateDate: 20241231
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h(
etl_dt date --数据日期
,agt_id varchar2(250) --协议编号
,cont_id varchar2(100) --合同编号
,trade_cont_tot_amt number(30,2) --贸易合同总金额
,fin_cont_flg varchar2(10) --融资合同标志
,cont_type_cd varchar2(30) --合同类型代码
,trade_cont_id varchar2(100) --贸易合同编号
,lc_kind_cd varchar2(30) --信用证种类代码
,lc_amt number(30,2) --信用证金额
,lc_curr_cd varchar2(30) --信用证币种代码
,lc_id varchar2(100) --信用证编号
,load_bill_id varchar2(100) --提单编号
,batch_id varchar2(250) --批文编号
,setup_proj_batch_id varchar2(250) --立项批文编号
,lc_type_cd varchar2(30) --信用证类型代码
,aldy_acpt_fwd_lc_flg varchar2(10) --已承兑远期信用证标志
,lc_tenor_type_cd varchar2(30) --信用证期限类型代码
,lc_char_cd varchar2(30) --信用证性质代码
,fwd_pay_day_tenor number(22) --远期付款日期限
,fee_undertaker varchar2(500) --费用承担人
,other_fee_rat number(18,6) --其他费率
,cargo_name varchar2(500) --货物名称
,cargo_underly number(30,8) --货物标的
,cargo_traff_destination varchar2(500) --货物运输目的地
,traff_way_cd varchar2(30) --运输方式代码
,cls_freq number(30) --分类频率
,mom_lics_id varchar2(100) --母证编号
,mom_lics_curr_cd varchar2(30) --母证币种代码
,mom_lics_amt number(30,2) --母证金额
,acct_recvbl_net_amnt number(30,2) --应收帐款净额
,gover_crdt_type_cd varchar2(30) --政府授信类型代码
,tran_bg_descb varchar2(500) --交易背景描述
,fix_asset_crdt_flg varchar2(10) --固定资产授信标志
,entr_dep_ec_cls_cd varchar2(30) --委托存款钞汇分类代码
,pkg_ratio number(18,6) --打包比例
,guar_type_cd varchar2(30) --担保类型代码
,entr_loan_cap_src_cd varchar2(30) --委托贷款资金来源代码
,nego_bank_cfm_flg varchar2(10) --经议付行确认标志
,discnt_int_buyer_bear_ratio number(18,6) --贴现利息买方承担比例
,discnt_bf_revw_flg varchar2(10) --先贴后查标志
,qual_centr_cntpty_flg varchar2(10) --合格中央交易对手标志
,margin_acct_id varchar2(100) --保证金账户编号
,margin_curr_cd varchar2(30) --保证金币种代码
,margin_tran_out_acct_id varchar2(100) --保证金转出账户编号
,col_turn_margin_acct_id varchar2(100) --押品转保证金账户编号
,margin_agt_rat number(18,8) --保证金协议利率
,margin_int_rat_type_cd varchar2(100) --保证金利率类型代码
,margin_flo_val number(18,6) --保证金浮动值
,margin_int_rat_float_type_cd varchar2(30) --保证金利率浮动类型代码
,margin_int_rat_float_way_cd varchar2(100) --保证金利率浮动方式代码
,margin_int_accr_method_cd varchar2(30) --保证金计息方法代码
,margin_int_rat_level_cd varchar2(30) --保证金利率档次代码
,csner_name varchar2(500) --委托人名称
,repay_comnt_descb varchar2(500) --还款说明描述
,start_up_bus_guar_loan_type_cd varchar2(30) --创业担保贷款类型代码
,consm_serv_class_fin_flg varchar2(10) --消费服务类融资标志
,pay_way_cd varchar2(30) --付款方式代码
,draw_comnt_descb varchar2(500) --提款说明描述
,loan_amt_ocup_tran_price_money_ratio number(18,6) --贷款金额占交易价款比例
,trade_fin_mang_merchd varchar2(250) --贸易融资经营商品
,draft_qtty number(30) --汇票数量
,discnt_commer_accpt_bil_cls_cd varchar2(30) --贴现商业承兑汇票分类代码
,commer_inv_id varchar2(100) --商业发票编号
,commer_inv_type_cd varchar2(30) --商业发票类型代码
,commer_inv_curr_cd varchar2(30) --商业发票币种代码
,commer_inv_amt number(30,2) --商业发票金额
,other_lics_id varchar2(1000) --其他许可证编号
,other_lics_name varchar2(500) --其他许可证名称
,hp_lics_id varchar2(1000) --环评许可证编号
,arch_land_lics_id varchar2(1000) --建设用地许可证编号
,plan_lics_id varchar2(1000) --规划许可证编号
,cnstr_lics_id varchar2(1000) --施工许可证编号
,dir_ind_fund_flg varchar2(10) --投向产业基金标志
,entr_loan_espec_dir_cd varchar2(30) --委托贷款特殊投向代码
,start_up_bus_guar_loan_flg varchar2(10) --创业担保贷款标志
,entr_dep_acct_id varchar2(100) --委托存款账户账号
,underly_prod_id varchar2(100) --标的产品编号
,prod_coll_amt number(30,2) --产品募集金额
,underly_prod_cls_lev_cd varchar2(30) --标的产品分级级别代码
,surp_indus_cd varchar2(30) --过剩行业代码
,buy_house_site_dist_cd varchar2(30) --买房所在地行政区划代码
,agclt_flg varchar2(10) --涉农贷款标志
,cntpty_name varchar2(500) --交易对手名称
,cntpty_co_years varchar2(30) --与交易对手合作年限
,cntpty_sucs_tran_cnt number(10) --与交易对手成功交易次数
,cntpty_strg varchar2(30) --交易对手实力
,other_cond_request_descb varchar2(4000) --其他条件和要求描述
,imp_loan_proj_cd varchar2(30) --重点贷款项目代码
,agclt_loan_dir_cd varchar2(30) --涉农贷款用途类型代码
,distr_ratio number(18,6) --放款比例
,obank_open_flg varchar2(10) --他行代开标志
,capital_amt number(30,2) --资本金金额
,mgers_name varchar2(500) --管理方名称
,trade_fin_prod_id varchar2(100) --贸易融资产品编号
,benefc_local_cty_or_rg_cd varchar2(200) --受益人所在国家或地区
,buyer_name varchar2(500) --买方名称
,agclt_loan_main_type_cd varchar2(30) --涉农贷款类型代码
,issue_appl_form_id varchar2(100) --开证申请书编号
,csner_id varchar2(100) --委托人编号
,imp_loan_proj_flg varchar2(10) --重点贷款项目标志
,discnt_int_rat_comnt_descb varchar2(2000) --贴现利率说明描述
,factor_type_cd varchar2(30) --保理类型代码
,agt_pay_int_flg varchar2(10) --协议付息标志
,start_work_dt date --开工日期
,cdb_crdt_flg varchar2(10) --国开行授信标志
,provi_doc_dt date --提供单据日期
,actl_finer varchar2(250) --实际融资人
,discnt_applit_type_cd varchar2(30) --贴现申请人类型代码
,invo_gover_class_fin_flg varchar2(10) --涉及政府类融资标志
,loan_fin_supt_way_cd varchar2(30) --贷款财政扶持方式代码
,three_old_trasf_city_update_proj_flg varchar2(10) --三旧改造城市更新项目标志
,syn_distrd_loan_amt number(30,2) --银团已发放贷款金额
,cap_src_cd varchar2(30) --资金来源代码
,gover_crdt_supt_way_cd varchar2(30) --政府授信支持方式代码
,crdtc_indus_dir_cd varchar2(30) --征信行业投向代码
,sup_chain_fin_bus_prod_cls_cd varchar2(30) --供应链金融业务产品分类代码
,proj_info_text_id varchar2(100) --项目信息文本编号
,exist_m_l_claus_flg varchar2(10) --存在溢短装的条款标志
,benefc_name varchar2(500) --受益人名称
,entr_dep_curr_cd varchar2(30) --委托存款币种代码
,prepay_acct_recvbl_flg varchar2(10) --预付应收帐款标志
,acpt_bank_name varchar2(500) --承兑行名称
,distr_org_id varchar2(100) --放款机构编号
,cdb_crdt_prod_id varchar2(100) --国开行授信产品编号
,loan_usage_tran_amt number(30,2) --贷款用途交易金额
,gover_crdt_flg varchar2(10) --政府授信标志
,dir_makti_debt_eqty_flg varchar2(10) --投向市场化债转股标志
,major_incre_crdt_way_cd varchar2(30) --主要增信方式代码
,m_l_ratio number(18,6) --溢短装比例
,loan_char_cd varchar2(30) --贷款性质代码
,sup_chain_fin_bus_flg varchar2(10) --供应链金融业务标志
,advise_bank_name varchar2(500) --通知行名称
,tran_asset_name varchar2(500) --交易资产名称
,loan_trast_way_cd varchar2(30) --贷款办理方式代码
,payfan_type_cd varchar2(30) --代付类型代码
,remote_bus_flg varchar2(10) --异地业务标志
,estate_loan_type_cd varchar2(30) --房地产贷款类型代码
,discnt_int_applit_pay_ratio number(18,6) --贴现利息申请人支付比例
,proj_tot_invest_amt number(30,2) --项目总投资金额
,cty_lmt_indus_flg varchar2(10) --国家限制行业标志
,loc_fin_plat_solv_cap_src_cd varchar2(30) --地方融资平台偿债资金来源代码
,acct_recvbl_prepay_way_cd varchar2(30) --应收帐款预付方式代码
,draw_way_cd varchar2(30) --提款方式代码
,repay_way_cd varchar2(30) --还款方式代码
,overs_loan_flg varchar2(30) --境外贷款标志
,land_use_cert_id varchar2(1000) --土地使用证编号
,land_use_cert_dt date --土地使用证日期
,land_plan_lics_id varchar2(1000) --用地规划许可证编号
,land_plan_lics_dt date --用地规划许可证日期
,cnstr_lics_dt date --施工许可证日期
,proj_plan_lics_dt date --工程规划许可证日期
,order_name varchar2(1000) --购货方名称
,seller_name varchar2(1000) --销货方名称
,trade_tran_content_descb varchar2(4000) --贸易交易内容描述
,advanced_manu_flg varchar2(10) --先进制造业标志
,cultur_industry_flg varchar2(10) --文化产业标志
,only_new_minorent_flg varchar2(10) --专精特新中小企业标志
,only_new_littlegiantent_flg varchar2(10) --专精特新小巨人企业标志
,strtg_new_indus_type_cd varchar2(30) --战略新兴产业类型代码
,indent_tech_flg varchar2(10) --工业企业技术改造升级标志
,start_dt date --开始时间
,end_dt date --结束时间

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h is '贷款合同对公贷款附属信息历史';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.agt_id is '协议编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cont_id is '合同编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.trade_cont_tot_amt is '贸易合同总金额';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.fin_cont_flg is '融资合同标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cont_type_cd is '合同类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.trade_cont_id is '贸易合同编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.lc_kind_cd is '信用证种类代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.lc_amt is '信用证金额';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.lc_curr_cd is '信用证币种代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.lc_id is '信用证编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.load_bill_id is '提单编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.batch_id is '批文编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.setup_proj_batch_id is '立项批文编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.lc_type_cd is '信用证类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.aldy_acpt_fwd_lc_flg is '已承兑远期信用证标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.lc_tenor_type_cd is '信用证期限类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.lc_char_cd is '信用证性质代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.fwd_pay_day_tenor is '远期付款日期限';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.fee_undertaker is '费用承担人';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.other_fee_rat is '其他费率';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cargo_name is '货物名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cargo_underly is '货物标的';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cargo_traff_destination is '货物运输目的地';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.traff_way_cd is '运输方式代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cls_freq is '分类频率';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.mom_lics_id is '母证编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.mom_lics_curr_cd is '母证币种代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.mom_lics_amt is '母证金额';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.acct_recvbl_net_amnt is '应收帐款净额';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.gover_crdt_type_cd is '政府授信类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.tran_bg_descb is '交易背景描述';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.fix_asset_crdt_flg is '固定资产授信标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.entr_dep_ec_cls_cd is '委托存款钞汇分类代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.pkg_ratio is '打包比例';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.guar_type_cd is '担保类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.entr_loan_cap_src_cd is '委托贷款资金来源代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.nego_bank_cfm_flg is '经议付行确认标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.discnt_int_buyer_bear_ratio is '贴现利息买方承担比例';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.discnt_bf_revw_flg is '先贴后查标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.qual_centr_cntpty_flg is '合格中央交易对手标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.margin_acct_id is '保证金账户编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.margin_curr_cd is '保证金币种代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.margin_tran_out_acct_id is '保证金转出账户编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.col_turn_margin_acct_id is '押品转保证金账户编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.margin_agt_rat is '保证金协议利率';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.margin_int_rat_type_cd is '保证金利率类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.margin_flo_val is '保证金浮动值';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.margin_int_rat_float_type_cd is '保证金利率浮动类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.margin_int_rat_float_way_cd is '保证金利率浮动方式代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.margin_int_accr_method_cd is '保证金计息方法代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.margin_int_rat_level_cd is '保证金利率档次代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.csner_name is '委托人名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.repay_comnt_descb is '还款说明描述';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.start_up_bus_guar_loan_type_cd is '创业担保贷款类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.consm_serv_class_fin_flg is '消费服务类融资标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.pay_way_cd is '付款方式代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.draw_comnt_descb is '提款说明描述';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.loan_amt_ocup_tran_price_money_ratio is '贷款金额占交易价款比例';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.trade_fin_mang_merchd is '贸易融资经营商品';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.draft_qtty is '汇票数量';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.discnt_commer_accpt_bil_cls_cd is '贴现商业承兑汇票分类代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.commer_inv_id is '商业发票编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.commer_inv_type_cd is '商业发票类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.commer_inv_curr_cd is '商业发票币种代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.commer_inv_amt is '商业发票金额';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.other_lics_id is '其他许可证编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.other_lics_name is '其他许可证名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.hp_lics_id is '环评许可证编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.arch_land_lics_id is '建设用地许可证编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.plan_lics_id is '规划许可证编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cnstr_lics_id is '施工许可证编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.dir_ind_fund_flg is '投向产业基金标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.entr_loan_espec_dir_cd is '委托贷款特殊投向代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.start_up_bus_guar_loan_flg is '创业担保贷款标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.entr_dep_acct_id is '委托存款账户账号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.underly_prod_id is '标的产品编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.prod_coll_amt is '产品募集金额';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.underly_prod_cls_lev_cd is '标的产品分级级别代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.surp_indus_cd is '过剩行业代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.buy_house_site_dist_cd is '买房所在地行政区划代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.agclt_flg is '涉农贷款标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cntpty_name is '交易对手名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cntpty_co_years is '与交易对手合作年限';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cntpty_sucs_tran_cnt is '与交易对手成功交易次数';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cntpty_strg is '交易对手实力';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.other_cond_request_descb is '其他条件和要求描述';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.imp_loan_proj_cd is '重点贷款项目代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.agclt_loan_dir_cd is '涉农贷款用途类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.distr_ratio is '放款比例';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.obank_open_flg is '他行代开标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.capital_amt is '资本金金额';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.mgers_name is '管理方名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.trade_fin_prod_id is '贸易融资产品编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.benefc_local_cty_or_rg_cd is '受益人所在国家或地区';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.buyer_name is '买方名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.agclt_loan_main_type_cd is '涉农贷款类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.issue_appl_form_id is '开证申请书编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.csner_id is '委托人编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.imp_loan_proj_flg is '重点贷款项目标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.discnt_int_rat_comnt_descb is '贴现利率说明描述';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.factor_type_cd is '保理类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.agt_pay_int_flg is '协议付息标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.start_work_dt is '开工日期';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cdb_crdt_flg is '国开行授信标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.provi_doc_dt is '提供单据日期';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.actl_finer is '实际融资人';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.discnt_applit_type_cd is '贴现申请人类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.invo_gover_class_fin_flg is '涉及政府类融资标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.loan_fin_supt_way_cd is '贷款财政扶持方式代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.three_old_trasf_city_update_proj_flg is '三旧改造城市更新项目标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.syn_distrd_loan_amt is '银团已发放贷款金额';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cap_src_cd is '资金来源代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.gover_crdt_supt_way_cd is '政府授信支持方式代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.crdtc_indus_dir_cd is '征信行业投向代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.sup_chain_fin_bus_prod_cls_cd is '供应链金融业务产品分类代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.proj_info_text_id is '项目信息文本编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.exist_m_l_claus_flg is '存在溢短装的条款标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.benefc_name is '受益人名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.entr_dep_curr_cd is '委托存款币种代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.prepay_acct_recvbl_flg is '预付应收帐款标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.acpt_bank_name is '承兑行名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.distr_org_id is '放款机构编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cdb_crdt_prod_id is '国开行授信产品编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.loan_usage_tran_amt is '贷款用途交易金额';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.gover_crdt_flg is '政府授信标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.dir_makti_debt_eqty_flg is '投向市场化债转股标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.major_incre_crdt_way_cd is '主要增信方式代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.m_l_ratio is '溢短装比例';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.loan_char_cd is '贷款性质代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.sup_chain_fin_bus_flg is '供应链金融业务标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.advise_bank_name is '通知行名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.tran_asset_name is '交易资产名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.loan_trast_way_cd is '贷款办理方式代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.payfan_type_cd is '代付类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.remote_bus_flg is '异地业务标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.estate_loan_type_cd is '房地产贷款类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.discnt_int_applit_pay_ratio is '贴现利息申请人支付比例';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.proj_tot_invest_amt is '项目总投资金额';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cty_lmt_indus_flg is '国家限制行业标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.loc_fin_plat_solv_cap_src_cd is '地方融资平台偿债资金来源代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.acct_recvbl_prepay_way_cd is '应收帐款预付方式代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.draw_way_cd is '提款方式代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.repay_way_cd is '还款方式代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.overs_loan_flg is '境外贷款标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.land_use_cert_id is '土地使用证编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.land_use_cert_dt is '土地使用证日期';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.land_plan_lics_id is '用地规划许可证编号';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.land_plan_lics_dt is '用地规划许可证日期';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cnstr_lics_dt is '施工许可证日期';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.proj_plan_lics_dt is '工程规划许可证日期';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.order_name is '购货方名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.seller_name is '销货方名称';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.trade_tran_content_descb is '贸易交易内容描述';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.advanced_manu_flg is '先进制造业标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.cultur_industry_flg is '文化产业标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.only_new_minorent_flg is '专精特新中小企业标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.only_new_littlegiantent_flg is '专精特新小巨人企业标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.strtg_new_indus_type_cd is '战略新兴产业类型代码';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.indent_tech_flg is '工业企业技术改造升级标志';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.agt_loan_cont_corp_loan_attach_info_h.end_dt is '结束时间';

