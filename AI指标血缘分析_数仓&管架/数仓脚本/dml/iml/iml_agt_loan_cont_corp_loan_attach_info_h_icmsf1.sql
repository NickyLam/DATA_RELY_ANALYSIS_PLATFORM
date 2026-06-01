/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_cont_corp_loan_attach_info_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,fin_cont_flg -- 融资合同标志
    ,cont_type_cd -- 合同类型代码
    ,trade_cont_id -- 贸易合同编号
    ,lc_kind_cd -- 信用证种类代码
    ,lc_amt -- 信用证金额
    ,lc_curr_cd -- 信用证币种代码
    ,lc_id -- 信用证编号
    ,load_bill_id -- 提单编号
    ,batch_id -- 批文编号
    ,setup_proj_batch_id -- 立项批文编号
    ,lc_type_cd -- 信用证类型代码
    ,aldy_acpt_fwd_lc_flg -- 已承兑远期信用证标志
    ,lc_tenor_type_cd -- 信用证期限类型代码
    ,lc_char_cd -- 信用证性质代码
    ,fwd_pay_day_tenor -- 远期付款日期限
    ,fee_undertaker -- 费用承担人
    ,other_fee_rat -- 其他费率
    ,cargo_name -- 货物名称
    ,cargo_underly -- 货物标的
    ,cargo_traff_destination -- 货物运输目的地
    ,traff_way_cd -- 运输方式代码
    ,cls_freq -- 分类频率
    ,mom_lics_id -- 母证编号
    ,mom_lics_curr_cd -- 母证币种代码
    ,mom_lics_amt -- 母证金额
    ,acct_recvbl_net_amnt -- 应收帐款净额
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,tran_bg_descb -- 交易背景描述
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,entr_dep_ec_cls_cd -- 委托存款钞汇分类代码
    ,pkg_ratio -- 打包比例
    ,guar_type_cd -- 担保类型代码
    ,entr_loan_cap_src_cd -- 委托贷款资金来源代码
    ,nego_bank_cfm_flg -- 经议付行确认标志
    ,discnt_int_buyer_bear_ratio -- 贴现利息买方承担比例
    ,discnt_bf_revw_flg -- 先贴后查标志
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,margin_agt_rat -- 保证金协议利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,csner_name -- 委托人名称
    ,repay_comnt_descb -- 还款说明描述
    ,start_up_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,pay_way_cd -- 付款方式代码
    ,draw_comnt_descb -- 提款说明描述
    ,loan_amt_ocup_tran_price_money_ratio -- 贷款金额占交易价款比例
    ,trade_fin_mang_merchd -- 贸易融资经营商品
    ,draft_qtty -- 汇票数量
    ,discnt_commer_accpt_bil_cls_cd -- 贴现商业承兑汇票分类代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,commer_inv_amt -- 商业发票金额
    ,other_lics_id -- 其他许可证编号
    ,other_lics_name -- 其他许可证名称
    ,hp_lics_id -- 环评许可证编号
    ,arch_land_lics_id -- 建设用地许可证编号
    ,plan_lics_id -- 规划许可证编号
    ,cnstr_lics_id -- 施工许可证编号
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,entr_loan_espec_dir_cd -- 委托贷款特殊投向代码
    ,start_up_bus_guar_loan_flg -- 创业担保贷款标志
    ,entr_dep_acct_id -- 委托存款账户账号
    ,underly_prod_id -- 标的产品编号
    ,prod_coll_amt -- 产品募集金额
    ,underly_prod_cls_lev_cd -- 标的产品分级级别代码
    ,surp_indus_cd -- 过剩行业代码
    ,buy_house_site_dist_cd -- 买房所在地行政区划代码
    ,agclt_flg -- 涉农贷款标志
    ,cntpty_name -- 交易对手名称
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_strg -- 交易对手实力
    ,other_cond_request_descb -- 其他条件和要求描述
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,distr_ratio -- 放款比例
    ,obank_open_flg -- 他行代开标志
    ,capital_amt -- 资本金金额
    ,mgers_name -- 管理方名称
    ,trade_fin_prod_id -- 贸易融资产品编号
    ,benefc_local_cty_or_rg_cd -- 受益人所在国家或地区
    ,buyer_name -- 买方名称
    ,agclt_loan_main_type_cd -- 涉农贷款类型代码
    ,issue_appl_form_id -- 开证申请书编号
    ,csner_id -- 委托人编号
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,discnt_int_rat_comnt_descb -- 贴现利率说明描述
    ,factor_type_cd -- 保理类型代码
    ,agt_pay_int_flg -- 协议付息标志
    ,start_work_dt -- 开工日期
    ,cdb_crdt_flg -- 国开行授信标志
    ,provi_doc_dt -- 提供单据日期
    ,actl_finer -- 实际融资人
    ,discnt_applit_type_cd -- 贴现申请人类型代码
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,three_old_trasf_city_update_proj_flg -- 三旧改造城市更新项目标志
    ,syn_distrd_loan_amt -- 银团已发放贷款金额
    ,cap_src_cd -- 资金来源代码
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,crdtc_indus_dir_cd -- 征信行业投向代码
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,proj_info_text_id -- 项目信息文本编号
    ,exist_m_l_claus_flg -- 存在溢短装的条款标志
    ,benefc_name -- 受益人名称
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,prepay_acct_recvbl_flg -- 预付应收帐款标志
    ,acpt_bank_name -- 承兑行名称
    ,distr_org_id -- 放款机构编号
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,gover_crdt_flg -- 政府授信标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,major_incre_crdt_way_cd -- 主要增信方式代码
    ,m_l_ratio -- 溢短装比例
    ,loan_char_cd -- 贷款性质代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,advise_bank_name -- 通知行名称
    ,tran_asset_name -- 交易资产名称
    ,loan_trast_way_cd -- 贷款办理方式代码
    ,payfan_type_cd -- 代付类型代码
    ,remote_bus_flg -- 异地业务标志
    ,estate_loan_type_cd -- 房地产贷款类型代码
    ,discnt_int_applit_pay_ratio -- 贴现利息申请人支付比例
    ,proj_tot_invest_amt -- 项目总投资金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,loc_fin_plat_solv_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,acct_recvbl_prepay_way_cd -- 应收帐款预付方式代码
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,overs_loan_flg -- 境外贷款标志
    ,land_use_cert_id -- 土地使用证编号
    ,land_use_cert_dt -- 土地使用证日期
    ,land_plan_lics_id -- 用地规划许可证编号
    ,land_plan_lics_dt -- 用地规划许可证日期
    ,cnstr_lics_dt -- 施工许可证日期
    ,proj_plan_lics_dt -- 工程规划许可证日期
    ,order_name -- 购货方名称
    ,seller_name -- 销货方名称
    ,trade_tran_content_descb -- 贸易交易内容描述
    ,advanced_manu_flg -- 先进制造业标志
    ,cultur_industry_flg -- 文化产业标志
    ,only_new_minorent_flg -- 专精特新中小企业标志
    ,only_new_littlegiantent_flg -- 专精特新小巨人企业标志
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,high_tech_serv_loan_flg -- 高技术服务业贷款标志
    ,high_tech_serv_loan_type_cd -- 高技术服务业贷款类型代码
    ,acct_recvbl_tran_way_cd -- 应收账款转让方式代码
    ,oper_start_dt -- 运营开始日期
    ,ppp_proj_flg -- PPP项目标志
    ,new_distr_flg -- 新机制放款标志
    ,cashflow_cover_bbal_flg -- 预测现金流覆盖借款余额标志
    ,mger_cert_type_cd -- 管理人证件类型代码
    ,mger_cert_no -- 管理人证件号码
    ,int_payer_name -- 付息方名称
    ,guar_housing_loan_type_cd -- 保障性住房贷款类型代码
    ,cust_ins_adj_type_cd -- 客户产业结构调整类型代码
    ,proj_fin_flg -- 项目融资标志
    ,rela_peop_guar_loan_flg -- 关系人保证贷款标志
    ,rei_loan_flg -- 房地产开发贷款标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bc_extend_d-1
insert into ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,fin_cont_flg -- 融资合同标志
    ,cont_type_cd -- 合同类型代码
    ,trade_cont_id -- 贸易合同编号
    ,lc_kind_cd -- 信用证种类代码
    ,lc_amt -- 信用证金额
    ,lc_curr_cd -- 信用证币种代码
    ,lc_id -- 信用证编号
    ,load_bill_id -- 提单编号
    ,batch_id -- 批文编号
    ,setup_proj_batch_id -- 立项批文编号
    ,lc_type_cd -- 信用证类型代码
    ,aldy_acpt_fwd_lc_flg -- 已承兑远期信用证标志
    ,lc_tenor_type_cd -- 信用证期限类型代码
    ,lc_char_cd -- 信用证性质代码
    ,fwd_pay_day_tenor -- 远期付款日期限
    ,fee_undertaker -- 费用承担人
    ,other_fee_rat -- 其他费率
    ,cargo_name -- 货物名称
    ,cargo_underly -- 货物标的
    ,cargo_traff_destination -- 货物运输目的地
    ,traff_way_cd -- 运输方式代码
    ,cls_freq -- 分类频率
    ,mom_lics_id -- 母证编号
    ,mom_lics_curr_cd -- 母证币种代码
    ,mom_lics_amt -- 母证金额
    ,acct_recvbl_net_amnt -- 应收帐款净额
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,tran_bg_descb -- 交易背景描述
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,entr_dep_ec_cls_cd -- 委托存款钞汇分类代码
    ,pkg_ratio -- 打包比例
    ,guar_type_cd -- 担保类型代码
    ,entr_loan_cap_src_cd -- 委托贷款资金来源代码
    ,nego_bank_cfm_flg -- 经议付行确认标志
    ,discnt_int_buyer_bear_ratio -- 贴现利息买方承担比例
    ,discnt_bf_revw_flg -- 先贴后查标志
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,margin_agt_rat -- 保证金协议利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,csner_name -- 委托人名称
    ,repay_comnt_descb -- 还款说明描述
    ,start_up_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,pay_way_cd -- 付款方式代码
    ,draw_comnt_descb -- 提款说明描述
    ,loan_amt_ocup_tran_price_money_ratio -- 贷款金额占交易价款比例
    ,trade_fin_mang_merchd -- 贸易融资经营商品
    ,draft_qtty -- 汇票数量
    ,discnt_commer_accpt_bil_cls_cd -- 贴现商业承兑汇票分类代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,commer_inv_amt -- 商业发票金额
    ,other_lics_id -- 其他许可证编号
    ,other_lics_name -- 其他许可证名称
    ,hp_lics_id -- 环评许可证编号
    ,arch_land_lics_id -- 建设用地许可证编号
    ,plan_lics_id -- 规划许可证编号
    ,cnstr_lics_id -- 施工许可证编号
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,entr_loan_espec_dir_cd -- 委托贷款特殊投向代码
    ,start_up_bus_guar_loan_flg -- 创业担保贷款标志
    ,entr_dep_acct_id -- 委托存款账户账号
    ,underly_prod_id -- 标的产品编号
    ,prod_coll_amt -- 产品募集金额
    ,underly_prod_cls_lev_cd -- 标的产品分级级别代码
    ,surp_indus_cd -- 过剩行业代码
    ,buy_house_site_dist_cd -- 买房所在地行政区划代码
    ,agclt_flg -- 涉农贷款标志
    ,cntpty_name -- 交易对手名称
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_strg -- 交易对手实力
    ,other_cond_request_descb -- 其他条件和要求描述
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,distr_ratio -- 放款比例
    ,obank_open_flg -- 他行代开标志
    ,capital_amt -- 资本金金额
    ,mgers_name -- 管理方名称
    ,trade_fin_prod_id -- 贸易融资产品编号
    ,benefc_local_cty_or_rg_cd -- 受益人所在国家或地区
    ,buyer_name -- 买方名称
    ,agclt_loan_main_type_cd -- 涉农贷款类型代码
    ,issue_appl_form_id -- 开证申请书编号
    ,csner_id -- 委托人编号
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,discnt_int_rat_comnt_descb -- 贴现利率说明描述
    ,factor_type_cd -- 保理类型代码
    ,agt_pay_int_flg -- 协议付息标志
    ,start_work_dt -- 开工日期
    ,cdb_crdt_flg -- 国开行授信标志
    ,provi_doc_dt -- 提供单据日期
    ,actl_finer -- 实际融资人
    ,discnt_applit_type_cd -- 贴现申请人类型代码
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,three_old_trasf_city_update_proj_flg -- 三旧改造城市更新项目标志
    ,syn_distrd_loan_amt -- 银团已发放贷款金额
    ,cap_src_cd -- 资金来源代码
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,crdtc_indus_dir_cd -- 征信行业投向代码
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,proj_info_text_id -- 项目信息文本编号
    ,exist_m_l_claus_flg -- 存在溢短装的条款标志
    ,benefc_name -- 受益人名称
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,prepay_acct_recvbl_flg -- 预付应收帐款标志
    ,acpt_bank_name -- 承兑行名称
    ,distr_org_id -- 放款机构编号
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,gover_crdt_flg -- 政府授信标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,major_incre_crdt_way_cd -- 主要增信方式代码
    ,m_l_ratio -- 溢短装比例
    ,loan_char_cd -- 贷款性质代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,advise_bank_name -- 通知行名称
    ,tran_asset_name -- 交易资产名称
    ,loan_trast_way_cd -- 贷款办理方式代码
    ,payfan_type_cd -- 代付类型代码
    ,remote_bus_flg -- 异地业务标志
    ,estate_loan_type_cd -- 房地产贷款类型代码
    ,discnt_int_applit_pay_ratio -- 贴现利息申请人支付比例
    ,proj_tot_invest_amt -- 项目总投资金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,loc_fin_plat_solv_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,acct_recvbl_prepay_way_cd -- 应收帐款预付方式代码
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,overs_loan_flg -- 境外贷款标志
    ,land_use_cert_id -- 土地使用证编号
    ,land_use_cert_dt -- 土地使用证日期
    ,land_plan_lics_id -- 用地规划许可证编号
    ,land_plan_lics_dt -- 用地规划许可证日期
    ,cnstr_lics_dt -- 施工许可证日期
    ,proj_plan_lics_dt -- 工程规划许可证日期
    ,order_name -- 购货方名称
    ,seller_name -- 销货方名称
    ,trade_tran_content_descb -- 贸易交易内容描述
    ,advanced_manu_flg -- 先进制造业标志
    ,cultur_industry_flg -- 文化产业标志
    ,only_new_minorent_flg -- 专精特新中小企业标志
    ,only_new_littlegiantent_flg -- 专精特新小巨人企业标志
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,high_tech_serv_loan_flg -- 高技术服务业贷款标志
    ,high_tech_serv_loan_type_cd -- 高技术服务业贷款类型代码
    ,acct_recvbl_tran_way_cd -- 应收账款转让方式代码
    ,oper_start_dt -- 运营开始日期
    ,ppp_proj_flg -- PPP项目标志
    ,new_distr_flg -- 新机制放款标志
    ,cashflow_cover_bbal_flg -- 预测现金流覆盖借款余额标志
    ,mger_cert_type_cd -- 管理人证件类型代码
    ,mger_cert_no -- 管理人证件号码
    ,int_payer_name -- 付息方名称
    ,guar_housing_loan_type_cd -- 保障性住房贷款类型代码
    ,cust_ins_adj_type_cd -- 客户产业结构调整类型代码
    ,proj_fin_flg -- 项目融资标志
    ,rela_peop_guar_loan_flg -- 关系人保证贷款标志
    ,rei_loan_flg -- 房地产开发贷款标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300002'||P1.SERIALNO -- 协议编号
    ,P1.SERIALNO -- 合同编号
    ,P1.TRADESUM -- 贸易合同总金额
    ,nvl(trim(P1.ISRZ),'-') -- 融资合同标志
    ,nvl(trim(p1.CREDITATTRIBUTE),'00') -- 合同类型代码
    ,P1.TRADECONTRACTNO -- 贸易合同编号
    ,nvl(trim(P1.LCTYPE),'-') -- 信用证种类代码
    ,P1.LCSUM -- 信用证金额
    ,nvl(trim(P1.LCCURRENCY),'-') -- 信用证币种代码
    ,P1.LCNO -- 信用证编号
    ,P1.THIRDPARTYACCOUNTS -- 提单编号
    ,P1.PWWH -- 批文编号
    ,P1.LXPW -- 立项批文编号
    ,nvl(trim(P1.LCOPERTYPE),'-') -- 信用证类型代码
    ,nvl(trim(P1.LCCDFLAG),'-') -- 已承兑远期信用证标志
    ,nvl(trim(P1.LCTERMTYPE),'-') -- 信用证期限类型代码
    ,nvl(trim(P1.LCQUALITY),'-') -- 信用证性质代码
    ,P1.GRACEPERIOD -- 远期付款日期限
    ,P1.COSTPERSONTYPE -- 费用承担人
    ,P1.MFEERATIO -- 其他费率
    ,P1.CARGOINFO -- 货物名称
    ,P1.TOTALCAST -- 货物标的
    ,P1.DESTINATION2 -- 货物运输目的地
    ,nvl(trim(P1.SECURITIESTYPE),'-') -- 运输方式代码
    ,P1.CLASSIFYFREQUENCY -- 分类频率
    ,P1.OLDLCNO -- 母证编号
    ,nvl(trim(P1.OLDLCCURRENCY),'-') -- 母证币种代码
    ,P1.OLDLCSUM -- 母证金额
    ,P1.DISCOUNTSUM -- 应收帐款净额
    ,nvl(trim(P1.ZFSXLX),'-') -- 政府授信类型代码
    ,P1.CONTEXTINFO -- 交易背景描述
    ,nvl(trim(P1.IFGUDINGCREDIT),'-') -- 固定资产授信标志
    ,nvl(trim(P1.MONEYTYPE),'-') -- 委托存款钞汇分类代码
    ,P1.RESTBALANCESUM -- 打包比例
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.GUARANTYTYPE END -- 担保类型代码
    ,nvl(trim(P1.MANDATESOURCE),'-') -- 委托贷款资金来源代码
    ,nvl(trim(P1.ISYFCONFIRMED),'-') -- 经议付行确认标志
    ,P1.PURCHASERPAYINTRATIO -- 贴现利息买方承担比例
    ,nvl(trim(P1.IFQUERYFLAG),'-') -- 先贴后查标志
    ,nvl(trim(P1.ISCOUNTERPARTY),'-') -- 合格中央交易对手标志
    ,P1.BAILACCOUNT -- 保证金账户编号
    ,nvl(trim(P1.BAILCURRENCY),'-') -- 保证金币种代码
    ,P1.BAILTRANSACCOUNT -- 保证金转出账户编号
    ,P1.GUARANTYBAILACCOUNT -- 押品转保证金账户编号
    ,P1.INTERESTRATE -- 保证金协议利率
    ,nvl(trim(P1.FXFLTP),'-') -- 保证金利率类型代码
    ,nvl(regexp_substr(P1.PDRIFV, '[0-9]+'),'0') -- 保证金浮动值
    ,nvl(trim(P1.PDRIFD),'-') -- 保证金利率浮动类型代码
    ,nvl(trim(p1.PDRIFM),0) -- 保证金利率浮动方式代码
    ,nvl(trim(P1.INTERESTMETHOD),'-') -- 保证金计息方法代码
    ,nvl(trim(P1.TERMCD),'-') -- 保证金利率档次代码
    ,nvl(trim(p1.MANDATECUSTNAME),0) -- 委托人名称
    ,nvl(trim(p1.REPAYREMARK),0) -- 还款说明描述
    ,nvl(trim(P1.VENTUREGUARANTYTYPE),'-') -- 创业担保贷款类型代码
    ,nvl(trim(P1.ISCONSUMERFINANCE),'-') -- 消费服务类融资标志
    ,nvl(trim(P1.LCPAYMETHOD),'-') -- 付款方式代码
    ,P1.DRAWINGREMARK -- 提款说明描述
    ,P1.LOANTRADERATIO -- 贷款金额占交易价款比例
    ,P1.MAINPRODUCT -- 贸易融资经营商品
    ,P1.BILLNUM -- 汇票数量
    ,nvl(trim(P1.DISCOUNTDRAFTTYPE),'-') -- 贴现商业承兑汇票分类代码
    ,P1.BUSINESSINVOICEINFO -- 商业发票编号
    ,nvl(trim(P1.BUSINESSINVOICETYPE),'-') -- 商业发票类型代码
    ,nvl(trim(P1.BUSINESSINVOICECURRENCY),'-') -- 商业发票币种代码
    ,P1.BUSINESSINVOICESUM -- 商业发票金额
    ,P1.QTXKZBH -- 其他许可证编号
    ,P1.QTXKZ -- 其他许可证名称
    ,P1.HPXKZBH -- 环评许可证编号
    ,P1.JSYDXKZBH -- 建设用地许可证编号
    ,P1.GHXKZBH -- 规划许可证编号
    ,P1.SGXKZBH -- 施工许可证编号
    ,nvl(trim(P1.TOINDUSTRYFUND),'-') -- 投向产业基金标志
    ,nvl(trim(P1.CONSIGNMENTLOANDIRECT),'-') -- 委托贷款特殊投向代码
    ,nvl(trim(P1.ISCAREERGUARANTEELOAN),'-') -- 创业担保贷款标志
    ,P1.MANDATEDEPACCTNO -- 委托存款账户账号
    ,P1.BONDNO -- 标的产品编号
    ,P1.PRODUCTCOLLECTMONEY -- 产品募集金额
    ,nvl(trim(P1.PRODUCTLEVEL),'-') -- 标的产品分级级别代码
    ,nvl(trim(P1.GSHY),'-') -- 过剩行业代码
    ,nvl(trim(p1.PURCHASERREGION),'000000') -- 买房所在地行政区划代码
    ,nvl(trim(p1.ISFARMING),'-') -- 涉农贷款标志
    ,P1.RIVALNAME -- 交易对手名称
    ,P1.TDYEARS -- 与交易对手合作年限
    ,nvl(trim(P1.TDTIMES),0) -- 与交易对手成功交易次数
    ,P1.TDSTRENTH -- 交易对手实力
    ,P1.OTHERCONDITION -- 其他条件和要求描述
    ,nvl(trim(P1.IMPORTANTLOAN),'-') -- 重点贷款项目代码
    ,nvl(trim(P1.FARMINGLOANUSE),'-') -- 涉农贷款用途类型代码
    ,P1.BUSINESSPROP -- 放款比例
    ,nvl(trim(P1.REGISTERINOTHERBANK),'-') -- 他行代开标志
    ,P1.ZBJ -- 资本金金额
    ,P1.CONSIGNEENAME -- 管理方名称
    ,P1.USEPRODUCT -- 贸易融资产品编号
    ,P1.BENEFICIARYCOUNTRYNAME -- 受益人所在国家或地区
    ,P1.PURCHASERNAME -- 买方名称
    ,nvl(trim(p1.FARMINGLOANTYPE),'-') -- 涉农贷款类型代码
    ,P1.LCAPPLYSERIALNO -- 开证申请书编号
    ,P1.MANDATECUSTID -- 委托人编号
    ,nvl(trim(P1.ISIMPORTANTLOAN),'-') -- 重点贷款项目标志
    ,P1.DISCOUNTRATENOTE -- 贴现利率说明描述
    ,nvl(trim(P1.FACTORINGTYPE),'-') -- 保理类型代码
    ,nvl(trim(P1.IFAGREEMENTFLAG),'-') -- 协议付息标志
    ,${iml_schema}.dateformat_max2(P1.KGRQ) -- 开工日期
    ,nvl(trim(P1.SFGKSX),'-') -- 国开行授信标志
    ,${iml_schema}.dateformat_max2(P1.OFFERBILLDATE) -- 提供单据日期
    ,nvl(trim(p1.FINANCIER),0) -- 实际融资人
    ,nvl(trim(P1.DISCOUNTCUSTTYPE),'-') -- 贴现申请人类型代码
    ,nvl(trim(P1.ISGOVERNFINANCE),'-') -- 涉及政府类融资标志
    ,nvl(trim(P1.FINANCESUPPORTMODE),'-') -- 贷款财政扶持方式代码
    ,nvl(trim(P1.ISSJORCS),'-') -- 三旧改造城市更新项目标志
    ,P1.YFFDKJE -- 银团已发放贷款金额
    ,nvl(trim(P1.FUNDSOURCE),'-')  -- 资金来源代码
    ,nvl(trim(P1.ZFSXFS),'-') -- 政府授信支持方式代码
    ,nvl(trim(P1.DIRECTIONRS),'-') -- 征信行业投向代码
    ,nvl(trim(P1.SUPPLYCHAINFINANCETYPE),'00') -- 供应链金融业务产品分类代码
    ,nvl(trim(p1.PROJECTARTIFICIALNO),0) -- 项目信息文本编号
    ,nvl(trim(P1.HASOUTRADIO),'-') -- 存在溢短装的条款标志
    ,P1.BENEFICIARYNAME -- 受益人名称
    ,nvl(trim(P1.TRADECURRENCY),'-') -- 委托存款币种代码
    ,nvl(trim(P1.ISYFRECEIVE),'-') -- 预付应收帐款标志
    ,P1.ACCEPTBANKNAME -- 承兑行名称
    ,P1.PUTOUTORGID -- 放款机构编号
    ,P1.GKSXPZ -- 国开行授信产品编号
    ,P1.LOANTRADESUM -- 贷款用途交易金额
    ,nvl(trim(P1.SFZFSX),'-') -- 政府授信标志
    ,nvl(trim(P1.ISDEBTTOEQUITY),'-') -- 投向市场化债转股标志
    ,nvl(trim(P1.CREDITINCREMENTTYPE),'00')  -- 主要增信方式代码
    ,P1.OUTRADIO -- 溢短装比例
    ,nvl(trim(P1.LOANQUALITY),'-') -- 贷款性质代码
    ,nvl(trim(P1.ISSUPPLYCHAINFINANCE),'-') -- 供应链金融业务标志
    ,P1.NOTICEBANKNAME -- 通知行名称
    ,P1.TRADINGASSETS -- 交易资产名称
    ,nvl(trim(P1.LOANHANDLECHANNEL),'-') -- 贷款办理方式代码
    ,nvl(trim(P1.THIRDPARTY1TYPE),'-') -- 代付类型代码
    ,nvl(trim(P1.OTHERAREALOAN),'-') -- 异地业务标志
    ,nvl(trim(P1.REALESTATELOANTYPE),'-') -- 房地产贷款类型代码
    ,P1.PROPOSERPAYMENTSCALE -- 贴现利息申请人支付比例
    ,P1.XMZTZ -- 项目总投资金额
    ,nvl(trim(P1.SFGJXZHY),'-') -- 国家限制行业标志
    ,nvl(trim(P1.LOCFINANCEFUNDSOURCE),'-') -- 地方融资平台偿债资金来源代码
    ,nvl(trim(P1.DUEPAYMETHOD),'-') -- 应收帐款预付方式代码
    ,nvl(trim(P1.DRAWINGTYPE),'00') -- 提款方式代码
    ,nvl(trim(P1.CORPUSPAYMETHOD),'-') -- 还款方式代码
    ,nvl(trim(P1.ISFOREIGN),'-') -- 境外贷款标志
    ,P1.LANDUSENO -- 土地使用证编号
    ,P1.LANDUSEDATE -- 土地使用证日期
    ,P1.LANDPLANPERMITNO -- 用地规划许可证编号
    ,P1.LANDPLANPERMITDATE -- 用地规划许可证日期
    ,P1.CONSTRUCTPERMITDATE -- 施工许可证日期
    ,P1.PROJECTPLANPERMITDATE -- 工程规划许可证日期
    ,P1.BUYERNAME -- 购货方名称
    ,P1.SELLERNAME -- 销货方名称
    ,P1.TRADETRANSACTIONCONTENT -- 贸易交易内容描述
    ,nvl(trim(P1.ADVANCEDMANUFLAG),'-') -- 先进制造业标志
    ,nvl(trim(P1.CULTUREINDUSTRYFLAG),'-') -- 文化产业标志
    ,nvl(trim(P1.ONLYNEWENTFLAG),'-') -- 专精特新中小企业标志
    ,nvl(trim(P1.ONLYNEWSMALLENTFLAG),'-') -- 专精特新小巨人企业标志
    ,nvl(trim(P1.STRATEGICEMERGINGINDUSTRYTYPE),'-') -- 战略新兴产业类型代码
    ,nvl(trim(P1.TRANSFORMATIONANDUPGRADEID),'-') -- 工业企业技术改造升级标志
    ,nvl(trim(P1.ISADVANCEDINDUSTRY),'-') -- 高技术服务业贷款标志
    ,nvl(trim(P1.ADVANCEDINDUSTRYLOANTYPE),'-') -- 高技术服务业贷款类型代码
    ,nvl(trim(P1.TRANSFERACC),'-') -- 应收账款转让方式代码
    ,P1.OPERATIONSTARTDATE -- 运营开始日期
    ,nvl(trim(P1.ISOVERSSOCIPPROJ),'-') -- PPP项目标志
    ,nvl(trim(P1.ISNEWMECHISSUELOAN),'-') -- 新机制放款标志
    ,nvl(trim(P1.ISCOVERDBBALANCE),'-') -- 预测现金流覆盖借款余额标志
    ,nvl(trim(P1.CONSIGNEECERTTYPE),'0000') -- 管理人证件类型代码
    ,P1.CONSIGNEECERTID -- 管理人证件号码
    ,nvl(trim(P1.PAYMENTNAME),'-') -- 付息方名称
    ,nvl(trim(P1.GUARANTEEHPROJECTTYPE),'090')  -- 保障性住房贷款类型代码
    ,nvl(trim(P1.INDUSTRIALRESTRUCTURINGTYPE),'0') -- 客户产业结构调整类型代码
    ,decode(trim(P1.ISPROJECTFINANCING),'2','0','','-',P1.ISPROJECTFINANCING) -- 项目融资标志
    ,nvl(trim(P1.ISGUARANTEELOAN),'-') -- 关系人保证贷款标志
    ,nvl(trim(P1.ISREALESTATELOAN),'-') -- 房地产开发贷款标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bc_extend_d' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bc_extend_d p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.GUARANTYTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD='ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_BC_EXTEND_D'
        AND R1.SRC_FIELD_EN_NAME= 'GUARANTYTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_CONT_CORP_LOAN_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'GUAR_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,cont_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,fin_cont_flg -- 融资合同标志
    ,cont_type_cd -- 合同类型代码
    ,trade_cont_id -- 贸易合同编号
    ,lc_kind_cd -- 信用证种类代码
    ,lc_amt -- 信用证金额
    ,lc_curr_cd -- 信用证币种代码
    ,lc_id -- 信用证编号
    ,load_bill_id -- 提单编号
    ,batch_id -- 批文编号
    ,setup_proj_batch_id -- 立项批文编号
    ,lc_type_cd -- 信用证类型代码
    ,aldy_acpt_fwd_lc_flg -- 已承兑远期信用证标志
    ,lc_tenor_type_cd -- 信用证期限类型代码
    ,lc_char_cd -- 信用证性质代码
    ,fwd_pay_day_tenor -- 远期付款日期限
    ,fee_undertaker -- 费用承担人
    ,other_fee_rat -- 其他费率
    ,cargo_name -- 货物名称
    ,cargo_underly -- 货物标的
    ,cargo_traff_destination -- 货物运输目的地
    ,traff_way_cd -- 运输方式代码
    ,cls_freq -- 分类频率
    ,mom_lics_id -- 母证编号
    ,mom_lics_curr_cd -- 母证币种代码
    ,mom_lics_amt -- 母证金额
    ,acct_recvbl_net_amnt -- 应收帐款净额
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,tran_bg_descb -- 交易背景描述
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,entr_dep_ec_cls_cd -- 委托存款钞汇分类代码
    ,pkg_ratio -- 打包比例
    ,guar_type_cd -- 担保类型代码
    ,entr_loan_cap_src_cd -- 委托贷款资金来源代码
    ,nego_bank_cfm_flg -- 经议付行确认标志
    ,discnt_int_buyer_bear_ratio -- 贴现利息买方承担比例
    ,discnt_bf_revw_flg -- 先贴后查标志
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,margin_agt_rat -- 保证金协议利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,csner_name -- 委托人名称
    ,repay_comnt_descb -- 还款说明描述
    ,start_up_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,pay_way_cd -- 付款方式代码
    ,draw_comnt_descb -- 提款说明描述
    ,loan_amt_ocup_tran_price_money_ratio -- 贷款金额占交易价款比例
    ,trade_fin_mang_merchd -- 贸易融资经营商品
    ,draft_qtty -- 汇票数量
    ,discnt_commer_accpt_bil_cls_cd -- 贴现商业承兑汇票分类代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,commer_inv_amt -- 商业发票金额
    ,other_lics_id -- 其他许可证编号
    ,other_lics_name -- 其他许可证名称
    ,hp_lics_id -- 环评许可证编号
    ,arch_land_lics_id -- 建设用地许可证编号
    ,plan_lics_id -- 规划许可证编号
    ,cnstr_lics_id -- 施工许可证编号
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,entr_loan_espec_dir_cd -- 委托贷款特殊投向代码
    ,start_up_bus_guar_loan_flg -- 创业担保贷款标志
    ,entr_dep_acct_id -- 委托存款账户账号
    ,underly_prod_id -- 标的产品编号
    ,prod_coll_amt -- 产品募集金额
    ,underly_prod_cls_lev_cd -- 标的产品分级级别代码
    ,surp_indus_cd -- 过剩行业代码
    ,buy_house_site_dist_cd -- 买房所在地行政区划代码
    ,agclt_flg -- 涉农贷款标志
    ,cntpty_name -- 交易对手名称
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_strg -- 交易对手实力
    ,other_cond_request_descb -- 其他条件和要求描述
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,distr_ratio -- 放款比例
    ,obank_open_flg -- 他行代开标志
    ,capital_amt -- 资本金金额
    ,mgers_name -- 管理方名称
    ,trade_fin_prod_id -- 贸易融资产品编号
    ,benefc_local_cty_or_rg_cd -- 受益人所在国家或地区
    ,buyer_name -- 买方名称
    ,agclt_loan_main_type_cd -- 涉农贷款类型代码
    ,issue_appl_form_id -- 开证申请书编号
    ,csner_id -- 委托人编号
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,discnt_int_rat_comnt_descb -- 贴现利率说明描述
    ,factor_type_cd -- 保理类型代码
    ,agt_pay_int_flg -- 协议付息标志
    ,start_work_dt -- 开工日期
    ,cdb_crdt_flg -- 国开行授信标志
    ,provi_doc_dt -- 提供单据日期
    ,actl_finer -- 实际融资人
    ,discnt_applit_type_cd -- 贴现申请人类型代码
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,three_old_trasf_city_update_proj_flg -- 三旧改造城市更新项目标志
    ,syn_distrd_loan_amt -- 银团已发放贷款金额
    ,cap_src_cd -- 资金来源代码
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,crdtc_indus_dir_cd -- 征信行业投向代码
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,proj_info_text_id -- 项目信息文本编号
    ,exist_m_l_claus_flg -- 存在溢短装的条款标志
    ,benefc_name -- 受益人名称
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,prepay_acct_recvbl_flg -- 预付应收帐款标志
    ,acpt_bank_name -- 承兑行名称
    ,distr_org_id -- 放款机构编号
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,gover_crdt_flg -- 政府授信标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,major_incre_crdt_way_cd -- 主要增信方式代码
    ,m_l_ratio -- 溢短装比例
    ,loan_char_cd -- 贷款性质代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,advise_bank_name -- 通知行名称
    ,tran_asset_name -- 交易资产名称
    ,loan_trast_way_cd -- 贷款办理方式代码
    ,payfan_type_cd -- 代付类型代码
    ,remote_bus_flg -- 异地业务标志
    ,estate_loan_type_cd -- 房地产贷款类型代码
    ,discnt_int_applit_pay_ratio -- 贴现利息申请人支付比例
    ,proj_tot_invest_amt -- 项目总投资金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,loc_fin_plat_solv_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,acct_recvbl_prepay_way_cd -- 应收帐款预付方式代码
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,overs_loan_flg -- 境外贷款标志
    ,land_use_cert_id -- 土地使用证编号
    ,land_use_cert_dt -- 土地使用证日期
    ,land_plan_lics_id -- 用地规划许可证编号
    ,land_plan_lics_dt -- 用地规划许可证日期
    ,cnstr_lics_dt -- 施工许可证日期
    ,proj_plan_lics_dt -- 工程规划许可证日期
    ,order_name -- 购货方名称
    ,seller_name -- 销货方名称
    ,trade_tran_content_descb -- 贸易交易内容描述
    ,advanced_manu_flg -- 先进制造业标志
    ,cultur_industry_flg -- 文化产业标志
    ,only_new_minorent_flg -- 专精特新中小企业标志
    ,only_new_littlegiantent_flg -- 专精特新小巨人企业标志
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,high_tech_serv_loan_flg -- 高技术服务业贷款标志
    ,high_tech_serv_loan_type_cd -- 高技术服务业贷款类型代码
    ,acct_recvbl_tran_way_cd -- 应收账款转让方式代码
    ,oper_start_dt -- 运营开始日期
    ,ppp_proj_flg -- PPP项目标志
    ,new_distr_flg -- 新机制放款标志
    ,cashflow_cover_bbal_flg -- 预测现金流覆盖借款余额标志
    ,mger_cert_type_cd -- 管理人证件类型代码
    ,mger_cert_no -- 管理人证件号码
    ,int_payer_name -- 付息方名称
    ,guar_housing_loan_type_cd -- 保障性住房贷款类型代码
    ,cust_ins_adj_type_cd -- 客户产业结构调整类型代码
    ,proj_fin_flg -- 项目融资标志
    ,rela_peop_guar_loan_flg -- 关系人保证贷款标志
    ,rei_loan_flg -- 房地产开发贷款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,fin_cont_flg -- 融资合同标志
    ,cont_type_cd -- 合同类型代码
    ,trade_cont_id -- 贸易合同编号
    ,lc_kind_cd -- 信用证种类代码
    ,lc_amt -- 信用证金额
    ,lc_curr_cd -- 信用证币种代码
    ,lc_id -- 信用证编号
    ,load_bill_id -- 提单编号
    ,batch_id -- 批文编号
    ,setup_proj_batch_id -- 立项批文编号
    ,lc_type_cd -- 信用证类型代码
    ,aldy_acpt_fwd_lc_flg -- 已承兑远期信用证标志
    ,lc_tenor_type_cd -- 信用证期限类型代码
    ,lc_char_cd -- 信用证性质代码
    ,fwd_pay_day_tenor -- 远期付款日期限
    ,fee_undertaker -- 费用承担人
    ,other_fee_rat -- 其他费率
    ,cargo_name -- 货物名称
    ,cargo_underly -- 货物标的
    ,cargo_traff_destination -- 货物运输目的地
    ,traff_way_cd -- 运输方式代码
    ,cls_freq -- 分类频率
    ,mom_lics_id -- 母证编号
    ,mom_lics_curr_cd -- 母证币种代码
    ,mom_lics_amt -- 母证金额
    ,acct_recvbl_net_amnt -- 应收帐款净额
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,tran_bg_descb -- 交易背景描述
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,entr_dep_ec_cls_cd -- 委托存款钞汇分类代码
    ,pkg_ratio -- 打包比例
    ,guar_type_cd -- 担保类型代码
    ,entr_loan_cap_src_cd -- 委托贷款资金来源代码
    ,nego_bank_cfm_flg -- 经议付行确认标志
    ,discnt_int_buyer_bear_ratio -- 贴现利息买方承担比例
    ,discnt_bf_revw_flg -- 先贴后查标志
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,margin_agt_rat -- 保证金协议利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,csner_name -- 委托人名称
    ,repay_comnt_descb -- 还款说明描述
    ,start_up_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,pay_way_cd -- 付款方式代码
    ,draw_comnt_descb -- 提款说明描述
    ,loan_amt_ocup_tran_price_money_ratio -- 贷款金额占交易价款比例
    ,trade_fin_mang_merchd -- 贸易融资经营商品
    ,draft_qtty -- 汇票数量
    ,discnt_commer_accpt_bil_cls_cd -- 贴现商业承兑汇票分类代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,commer_inv_amt -- 商业发票金额
    ,other_lics_id -- 其他许可证编号
    ,other_lics_name -- 其他许可证名称
    ,hp_lics_id -- 环评许可证编号
    ,arch_land_lics_id -- 建设用地许可证编号
    ,plan_lics_id -- 规划许可证编号
    ,cnstr_lics_id -- 施工许可证编号
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,entr_loan_espec_dir_cd -- 委托贷款特殊投向代码
    ,start_up_bus_guar_loan_flg -- 创业担保贷款标志
    ,entr_dep_acct_id -- 委托存款账户账号
    ,underly_prod_id -- 标的产品编号
    ,prod_coll_amt -- 产品募集金额
    ,underly_prod_cls_lev_cd -- 标的产品分级级别代码
    ,surp_indus_cd -- 过剩行业代码
    ,buy_house_site_dist_cd -- 买房所在地行政区划代码
    ,agclt_flg -- 涉农贷款标志
    ,cntpty_name -- 交易对手名称
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_strg -- 交易对手实力
    ,other_cond_request_descb -- 其他条件和要求描述
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,distr_ratio -- 放款比例
    ,obank_open_flg -- 他行代开标志
    ,capital_amt -- 资本金金额
    ,mgers_name -- 管理方名称
    ,trade_fin_prod_id -- 贸易融资产品编号
    ,benefc_local_cty_or_rg_cd -- 受益人所在国家或地区
    ,buyer_name -- 买方名称
    ,agclt_loan_main_type_cd -- 涉农贷款类型代码
    ,issue_appl_form_id -- 开证申请书编号
    ,csner_id -- 委托人编号
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,discnt_int_rat_comnt_descb -- 贴现利率说明描述
    ,factor_type_cd -- 保理类型代码
    ,agt_pay_int_flg -- 协议付息标志
    ,start_work_dt -- 开工日期
    ,cdb_crdt_flg -- 国开行授信标志
    ,provi_doc_dt -- 提供单据日期
    ,actl_finer -- 实际融资人
    ,discnt_applit_type_cd -- 贴现申请人类型代码
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,three_old_trasf_city_update_proj_flg -- 三旧改造城市更新项目标志
    ,syn_distrd_loan_amt -- 银团已发放贷款金额
    ,cap_src_cd -- 资金来源代码
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,crdtc_indus_dir_cd -- 征信行业投向代码
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,proj_info_text_id -- 项目信息文本编号
    ,exist_m_l_claus_flg -- 存在溢短装的条款标志
    ,benefc_name -- 受益人名称
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,prepay_acct_recvbl_flg -- 预付应收帐款标志
    ,acpt_bank_name -- 承兑行名称
    ,distr_org_id -- 放款机构编号
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,gover_crdt_flg -- 政府授信标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,major_incre_crdt_way_cd -- 主要增信方式代码
    ,m_l_ratio -- 溢短装比例
    ,loan_char_cd -- 贷款性质代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,advise_bank_name -- 通知行名称
    ,tran_asset_name -- 交易资产名称
    ,loan_trast_way_cd -- 贷款办理方式代码
    ,payfan_type_cd -- 代付类型代码
    ,remote_bus_flg -- 异地业务标志
    ,estate_loan_type_cd -- 房地产贷款类型代码
    ,discnt_int_applit_pay_ratio -- 贴现利息申请人支付比例
    ,proj_tot_invest_amt -- 项目总投资金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,loc_fin_plat_solv_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,acct_recvbl_prepay_way_cd -- 应收帐款预付方式代码
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,overs_loan_flg -- 境外贷款标志
    ,land_use_cert_id -- 土地使用证编号
    ,land_use_cert_dt -- 土地使用证日期
    ,land_plan_lics_id -- 用地规划许可证编号
    ,land_plan_lics_dt -- 用地规划许可证日期
    ,cnstr_lics_dt -- 施工许可证日期
    ,proj_plan_lics_dt -- 工程规划许可证日期
    ,order_name -- 购货方名称
    ,seller_name -- 销货方名称
    ,trade_tran_content_descb -- 贸易交易内容描述
    ,advanced_manu_flg -- 先进制造业标志
    ,cultur_industry_flg -- 文化产业标志
    ,only_new_minorent_flg -- 专精特新中小企业标志
    ,only_new_littlegiantent_flg -- 专精特新小巨人企业标志
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,high_tech_serv_loan_flg -- 高技术服务业贷款标志
    ,high_tech_serv_loan_type_cd -- 高技术服务业贷款类型代码
    ,acct_recvbl_tran_way_cd -- 应收账款转让方式代码
    ,oper_start_dt -- 运营开始日期
    ,ppp_proj_flg -- PPP项目标志
    ,new_distr_flg -- 新机制放款标志
    ,cashflow_cover_bbal_flg -- 预测现金流覆盖借款余额标志
    ,mger_cert_type_cd -- 管理人证件类型代码
    ,mger_cert_no -- 管理人证件号码
    ,int_payer_name -- 付息方名称
    ,guar_housing_loan_type_cd -- 保障性住房贷款类型代码
    ,cust_ins_adj_type_cd -- 客户产业结构调整类型代码
    ,proj_fin_flg -- 项目融资标志
    ,rela_peop_guar_loan_flg -- 关系人保证贷款标志
    ,rei_loan_flg -- 房地产开发贷款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.trade_cont_tot_amt, o.trade_cont_tot_amt) as trade_cont_tot_amt -- 贸易合同总金额
    ,nvl(n.fin_cont_flg, o.fin_cont_flg) as fin_cont_flg -- 融资合同标志
    ,nvl(n.cont_type_cd, o.cont_type_cd) as cont_type_cd -- 合同类型代码
    ,nvl(n.trade_cont_id, o.trade_cont_id) as trade_cont_id -- 贸易合同编号
    ,nvl(n.lc_kind_cd, o.lc_kind_cd) as lc_kind_cd -- 信用证种类代码
    ,nvl(n.lc_amt, o.lc_amt) as lc_amt -- 信用证金额
    ,nvl(n.lc_curr_cd, o.lc_curr_cd) as lc_curr_cd -- 信用证币种代码
    ,nvl(n.lc_id, o.lc_id) as lc_id -- 信用证编号
    ,nvl(n.load_bill_id, o.load_bill_id) as load_bill_id -- 提单编号
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批文编号
    ,nvl(n.setup_proj_batch_id, o.setup_proj_batch_id) as setup_proj_batch_id -- 立项批文编号
    ,nvl(n.lc_type_cd, o.lc_type_cd) as lc_type_cd -- 信用证类型代码
    ,nvl(n.aldy_acpt_fwd_lc_flg, o.aldy_acpt_fwd_lc_flg) as aldy_acpt_fwd_lc_flg -- 已承兑远期信用证标志
    ,nvl(n.lc_tenor_type_cd, o.lc_tenor_type_cd) as lc_tenor_type_cd -- 信用证期限类型代码
    ,nvl(n.lc_char_cd, o.lc_char_cd) as lc_char_cd -- 信用证性质代码
    ,nvl(n.fwd_pay_day_tenor, o.fwd_pay_day_tenor) as fwd_pay_day_tenor -- 远期付款日期限
    ,nvl(n.fee_undertaker, o.fee_undertaker) as fee_undertaker -- 费用承担人
    ,nvl(n.other_fee_rat, o.other_fee_rat) as other_fee_rat -- 其他费率
    ,nvl(n.cargo_name, o.cargo_name) as cargo_name -- 货物名称
    ,nvl(n.cargo_underly, o.cargo_underly) as cargo_underly -- 货物标的
    ,nvl(n.cargo_traff_destination, o.cargo_traff_destination) as cargo_traff_destination -- 货物运输目的地
    ,nvl(n.traff_way_cd, o.traff_way_cd) as traff_way_cd -- 运输方式代码
    ,nvl(n.cls_freq, o.cls_freq) as cls_freq -- 分类频率
    ,nvl(n.mom_lics_id, o.mom_lics_id) as mom_lics_id -- 母证编号
    ,nvl(n.mom_lics_curr_cd, o.mom_lics_curr_cd) as mom_lics_curr_cd -- 母证币种代码
    ,nvl(n.mom_lics_amt, o.mom_lics_amt) as mom_lics_amt -- 母证金额
    ,nvl(n.acct_recvbl_net_amnt, o.acct_recvbl_net_amnt) as acct_recvbl_net_amnt -- 应收帐款净额
    ,nvl(n.gover_crdt_type_cd, o.gover_crdt_type_cd) as gover_crdt_type_cd -- 政府授信类型代码
    ,nvl(n.tran_bg_descb, o.tran_bg_descb) as tran_bg_descb -- 交易背景描述
    ,nvl(n.fix_asset_crdt_flg, o.fix_asset_crdt_flg) as fix_asset_crdt_flg -- 固定资产授信标志
    ,nvl(n.entr_dep_ec_cls_cd, o.entr_dep_ec_cls_cd) as entr_dep_ec_cls_cd -- 委托存款钞汇分类代码
    ,nvl(n.pkg_ratio, o.pkg_ratio) as pkg_ratio -- 打包比例
    ,nvl(n.guar_type_cd, o.guar_type_cd) as guar_type_cd -- 担保类型代码
    ,nvl(n.entr_loan_cap_src_cd, o.entr_loan_cap_src_cd) as entr_loan_cap_src_cd -- 委托贷款资金来源代码
    ,nvl(n.nego_bank_cfm_flg, o.nego_bank_cfm_flg) as nego_bank_cfm_flg -- 经议付行确认标志
    ,nvl(n.discnt_int_buyer_bear_ratio, o.discnt_int_buyer_bear_ratio) as discnt_int_buyer_bear_ratio -- 贴现利息买方承担比例
    ,nvl(n.discnt_bf_revw_flg, o.discnt_bf_revw_flg) as discnt_bf_revw_flg -- 先贴后查标志
    ,nvl(n.qual_centr_cntpty_flg, o.qual_centr_cntpty_flg) as qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,nvl(n.margin_acct_id, o.margin_acct_id) as margin_acct_id -- 保证金账户编号
    ,nvl(n.margin_curr_cd, o.margin_curr_cd) as margin_curr_cd -- 保证金币种代码
    ,nvl(n.margin_tran_out_acct_id, o.margin_tran_out_acct_id) as margin_tran_out_acct_id -- 保证金转出账户编号
    ,nvl(n.col_turn_margin_acct_id, o.col_turn_margin_acct_id) as col_turn_margin_acct_id -- 押品转保证金账户编号
    ,nvl(n.margin_agt_rat, o.margin_agt_rat) as margin_agt_rat -- 保证金协议利率
    ,nvl(n.margin_int_rat_type_cd, o.margin_int_rat_type_cd) as margin_int_rat_type_cd -- 保证金利率类型代码
    ,nvl(n.margin_flo_val, o.margin_flo_val) as margin_flo_val -- 保证金浮动值
    ,nvl(n.margin_int_rat_float_type_cd, o.margin_int_rat_float_type_cd) as margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,nvl(n.margin_int_rat_float_way_cd, o.margin_int_rat_float_way_cd) as margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,nvl(n.margin_int_accr_method_cd, o.margin_int_accr_method_cd) as margin_int_accr_method_cd -- 保证金计息方法代码
    ,nvl(n.margin_int_rat_level_cd, o.margin_int_rat_level_cd) as margin_int_rat_level_cd -- 保证金利率档次代码
    ,nvl(n.csner_name, o.csner_name) as csner_name -- 委托人名称
    ,nvl(n.repay_comnt_descb, o.repay_comnt_descb) as repay_comnt_descb -- 还款说明描述
    ,nvl(n.start_up_bus_guar_loan_type_cd, o.start_up_bus_guar_loan_type_cd) as start_up_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,nvl(n.consm_serv_class_fin_flg, o.consm_serv_class_fin_flg) as consm_serv_class_fin_flg -- 消费服务类融资标志
    ,nvl(n.pay_way_cd, o.pay_way_cd) as pay_way_cd -- 付款方式代码
    ,nvl(n.draw_comnt_descb, o.draw_comnt_descb) as draw_comnt_descb -- 提款说明描述
    ,nvl(n.loan_amt_ocup_tran_price_money_ratio, o.loan_amt_ocup_tran_price_money_ratio) as loan_amt_ocup_tran_price_money_ratio -- 贷款金额占交易价款比例
    ,nvl(n.trade_fin_mang_merchd, o.trade_fin_mang_merchd) as trade_fin_mang_merchd -- 贸易融资经营商品
    ,nvl(n.draft_qtty, o.draft_qtty) as draft_qtty -- 汇票数量
    ,nvl(n.discnt_commer_accpt_bil_cls_cd, o.discnt_commer_accpt_bil_cls_cd) as discnt_commer_accpt_bil_cls_cd -- 贴现商业承兑汇票分类代码
    ,nvl(n.commer_inv_id, o.commer_inv_id) as commer_inv_id -- 商业发票编号
    ,nvl(n.commer_inv_type_cd, o.commer_inv_type_cd) as commer_inv_type_cd -- 商业发票类型代码
    ,nvl(n.commer_inv_curr_cd, o.commer_inv_curr_cd) as commer_inv_curr_cd -- 商业发票币种代码
    ,nvl(n.commer_inv_amt, o.commer_inv_amt) as commer_inv_amt -- 商业发票金额
    ,nvl(n.other_lics_id, o.other_lics_id) as other_lics_id -- 其他许可证编号
    ,nvl(n.other_lics_name, o.other_lics_name) as other_lics_name -- 其他许可证名称
    ,nvl(n.hp_lics_id, o.hp_lics_id) as hp_lics_id -- 环评许可证编号
    ,nvl(n.arch_land_lics_id, o.arch_land_lics_id) as arch_land_lics_id -- 建设用地许可证编号
    ,nvl(n.plan_lics_id, o.plan_lics_id) as plan_lics_id -- 规划许可证编号
    ,nvl(n.cnstr_lics_id, o.cnstr_lics_id) as cnstr_lics_id -- 施工许可证编号
    ,nvl(n.dir_ind_fund_flg, o.dir_ind_fund_flg) as dir_ind_fund_flg -- 投向产业基金标志
    ,nvl(n.entr_loan_espec_dir_cd, o.entr_loan_espec_dir_cd) as entr_loan_espec_dir_cd -- 委托贷款特殊投向代码
    ,nvl(n.start_up_bus_guar_loan_flg, o.start_up_bus_guar_loan_flg) as start_up_bus_guar_loan_flg -- 创业担保贷款标志
    ,nvl(n.entr_dep_acct_id, o.entr_dep_acct_id) as entr_dep_acct_id -- 委托存款账户账号
    ,nvl(n.underly_prod_id, o.underly_prod_id) as underly_prod_id -- 标的产品编号
    ,nvl(n.prod_coll_amt, o.prod_coll_amt) as prod_coll_amt -- 产品募集金额
    ,nvl(n.underly_prod_cls_lev_cd, o.underly_prod_cls_lev_cd) as underly_prod_cls_lev_cd -- 标的产品分级级别代码
    ,nvl(n.surp_indus_cd, o.surp_indus_cd) as surp_indus_cd -- 过剩行业代码
    ,nvl(n.buy_house_site_dist_cd, o.buy_house_site_dist_cd) as buy_house_site_dist_cd -- 买房所在地行政区划代码
    ,nvl(n.agclt_flg, o.agclt_flg) as agclt_flg -- 涉农贷款标志
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.cntpty_co_years, o.cntpty_co_years) as cntpty_co_years -- 与交易对手合作年限
    ,nvl(n.cntpty_sucs_tran_cnt, o.cntpty_sucs_tran_cnt) as cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,nvl(n.cntpty_strg, o.cntpty_strg) as cntpty_strg -- 交易对手实力
    ,nvl(n.other_cond_request_descb, o.other_cond_request_descb) as other_cond_request_descb -- 其他条件和要求描述
    ,nvl(n.imp_loan_proj_cd, o.imp_loan_proj_cd) as imp_loan_proj_cd -- 重点贷款项目代码
    ,nvl(n.agclt_loan_dir_cd, o.agclt_loan_dir_cd) as agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,nvl(n.distr_ratio, o.distr_ratio) as distr_ratio -- 放款比例
    ,nvl(n.obank_open_flg, o.obank_open_flg) as obank_open_flg -- 他行代开标志
    ,nvl(n.capital_amt, o.capital_amt) as capital_amt -- 资本金金额
    ,nvl(n.mgers_name, o.mgers_name) as mgers_name -- 管理方名称
    ,nvl(n.trade_fin_prod_id, o.trade_fin_prod_id) as trade_fin_prod_id -- 贸易融资产品编号
    ,nvl(n.benefc_local_cty_or_rg_cd, o.benefc_local_cty_or_rg_cd) as benefc_local_cty_or_rg_cd -- 受益人所在国家或地区
    ,nvl(n.buyer_name, o.buyer_name) as buyer_name -- 买方名称
    ,nvl(n.agclt_loan_main_type_cd, o.agclt_loan_main_type_cd) as agclt_loan_main_type_cd -- 涉农贷款类型代码
    ,nvl(n.issue_appl_form_id, o.issue_appl_form_id) as issue_appl_form_id -- 开证申请书编号
    ,nvl(n.csner_id, o.csner_id) as csner_id -- 委托人编号
    ,nvl(n.imp_loan_proj_flg, o.imp_loan_proj_flg) as imp_loan_proj_flg -- 重点贷款项目标志
    ,nvl(n.discnt_int_rat_comnt_descb, o.discnt_int_rat_comnt_descb) as discnt_int_rat_comnt_descb -- 贴现利率说明描述
    ,nvl(n.factor_type_cd, o.factor_type_cd) as factor_type_cd -- 保理类型代码
    ,nvl(n.agt_pay_int_flg, o.agt_pay_int_flg) as agt_pay_int_flg -- 协议付息标志
    ,nvl(n.start_work_dt, o.start_work_dt) as start_work_dt -- 开工日期
    ,nvl(n.cdb_crdt_flg, o.cdb_crdt_flg) as cdb_crdt_flg -- 国开行授信标志
    ,nvl(n.provi_doc_dt, o.provi_doc_dt) as provi_doc_dt -- 提供单据日期
    ,nvl(n.actl_finer, o.actl_finer) as actl_finer -- 实际融资人
    ,nvl(n.discnt_applit_type_cd, o.discnt_applit_type_cd) as discnt_applit_type_cd -- 贴现申请人类型代码
    ,nvl(n.invo_gover_class_fin_flg, o.invo_gover_class_fin_flg) as invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,nvl(n.loan_fin_supt_way_cd, o.loan_fin_supt_way_cd) as loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,nvl(n.three_old_trasf_city_update_proj_flg, o.three_old_trasf_city_update_proj_flg) as three_old_trasf_city_update_proj_flg -- 三旧改造城市更新项目标志
    ,nvl(n.syn_distrd_loan_amt, o.syn_distrd_loan_amt) as syn_distrd_loan_amt -- 银团已发放贷款金额
    ,nvl(n.cap_src_cd, o.cap_src_cd) as cap_src_cd -- 资金来源代码
    ,nvl(n.gover_crdt_supt_way_cd, o.gover_crdt_supt_way_cd) as gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,nvl(n.crdtc_indus_dir_cd, o.crdtc_indus_dir_cd) as crdtc_indus_dir_cd -- 征信行业投向代码
    ,nvl(n.sup_chain_fin_bus_prod_cls_cd, o.sup_chain_fin_bus_prod_cls_cd) as sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,nvl(n.proj_info_text_id, o.proj_info_text_id) as proj_info_text_id -- 项目信息文本编号
    ,nvl(n.exist_m_l_claus_flg, o.exist_m_l_claus_flg) as exist_m_l_claus_flg -- 存在溢短装的条款标志
    ,nvl(n.benefc_name, o.benefc_name) as benefc_name -- 受益人名称
    ,nvl(n.entr_dep_curr_cd, o.entr_dep_curr_cd) as entr_dep_curr_cd -- 委托存款币种代码
    ,nvl(n.prepay_acct_recvbl_flg, o.prepay_acct_recvbl_flg) as prepay_acct_recvbl_flg -- 预付应收帐款标志
    ,nvl(n.acpt_bank_name, o.acpt_bank_name) as acpt_bank_name -- 承兑行名称
    ,nvl(n.distr_org_id, o.distr_org_id) as distr_org_id -- 放款机构编号
    ,nvl(n.cdb_crdt_prod_id, o.cdb_crdt_prod_id) as cdb_crdt_prod_id -- 国开行授信产品编号
    ,nvl(n.loan_usage_tran_amt, o.loan_usage_tran_amt) as loan_usage_tran_amt -- 贷款用途交易金额
    ,nvl(n.gover_crdt_flg, o.gover_crdt_flg) as gover_crdt_flg -- 政府授信标志
    ,nvl(n.dir_makti_debt_eqty_flg, o.dir_makti_debt_eqty_flg) as dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,nvl(n.major_incre_crdt_way_cd, o.major_incre_crdt_way_cd) as major_incre_crdt_way_cd -- 主要增信方式代码
    ,nvl(n.m_l_ratio, o.m_l_ratio) as m_l_ratio -- 溢短装比例
    ,nvl(n.loan_char_cd, o.loan_char_cd) as loan_char_cd -- 贷款性质代码
    ,nvl(n.sup_chain_fin_bus_flg, o.sup_chain_fin_bus_flg) as sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,nvl(n.advise_bank_name, o.advise_bank_name) as advise_bank_name -- 通知行名称
    ,nvl(n.tran_asset_name, o.tran_asset_name) as tran_asset_name -- 交易资产名称
    ,nvl(n.loan_trast_way_cd, o.loan_trast_way_cd) as loan_trast_way_cd -- 贷款办理方式代码
    ,nvl(n.payfan_type_cd, o.payfan_type_cd) as payfan_type_cd -- 代付类型代码
    ,nvl(n.remote_bus_flg, o.remote_bus_flg) as remote_bus_flg -- 异地业务标志
    ,nvl(n.estate_loan_type_cd, o.estate_loan_type_cd) as estate_loan_type_cd -- 房地产贷款类型代码
    ,nvl(n.discnt_int_applit_pay_ratio, o.discnt_int_applit_pay_ratio) as discnt_int_applit_pay_ratio -- 贴现利息申请人支付比例
    ,nvl(n.proj_tot_invest_amt, o.proj_tot_invest_amt) as proj_tot_invest_amt -- 项目总投资金额
    ,nvl(n.cty_lmt_indus_flg, o.cty_lmt_indus_flg) as cty_lmt_indus_flg -- 国家限制行业标志
    ,nvl(n.loc_fin_plat_solv_cap_src_cd, o.loc_fin_plat_solv_cap_src_cd) as loc_fin_plat_solv_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,nvl(n.acct_recvbl_prepay_way_cd, o.acct_recvbl_prepay_way_cd) as acct_recvbl_prepay_way_cd -- 应收帐款预付方式代码
    ,nvl(n.draw_way_cd, o.draw_way_cd) as draw_way_cd -- 提款方式代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.overs_loan_flg, o.overs_loan_flg) as overs_loan_flg -- 境外贷款标志
    ,nvl(n.land_use_cert_id, o.land_use_cert_id) as land_use_cert_id -- 土地使用证编号
    ,nvl(n.land_use_cert_dt, o.land_use_cert_dt) as land_use_cert_dt -- 土地使用证日期
    ,nvl(n.land_plan_lics_id, o.land_plan_lics_id) as land_plan_lics_id -- 用地规划许可证编号
    ,nvl(n.land_plan_lics_dt, o.land_plan_lics_dt) as land_plan_lics_dt -- 用地规划许可证日期
    ,nvl(n.cnstr_lics_dt, o.cnstr_lics_dt) as cnstr_lics_dt -- 施工许可证日期
    ,nvl(n.proj_plan_lics_dt, o.proj_plan_lics_dt) as proj_plan_lics_dt -- 工程规划许可证日期
    ,nvl(n.order_name, o.order_name) as order_name -- 购货方名称
    ,nvl(n.seller_name, o.seller_name) as seller_name -- 销货方名称
    ,nvl(n.trade_tran_content_descb, o.trade_tran_content_descb) as trade_tran_content_descb -- 贸易交易内容描述
    ,nvl(n.advanced_manu_flg, o.advanced_manu_flg) as advanced_manu_flg -- 先进制造业标志
    ,nvl(n.cultur_industry_flg, o.cultur_industry_flg) as cultur_industry_flg -- 文化产业标志
    ,nvl(n.only_new_minorent_flg, o.only_new_minorent_flg) as only_new_minorent_flg -- 专精特新中小企业标志
    ,nvl(n.only_new_littlegiantent_flg, o.only_new_littlegiantent_flg) as only_new_littlegiantent_flg -- 专精特新小巨人企业标志
    ,nvl(n.strtg_new_indus_type_cd, o.strtg_new_indus_type_cd) as strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,nvl(n.indent_tech_flg, o.indent_tech_flg) as indent_tech_flg -- 工业企业技术改造升级标志
    ,nvl(n.high_tech_serv_loan_flg, o.high_tech_serv_loan_flg) as high_tech_serv_loan_flg -- 高技术服务业贷款标志
    ,nvl(n.high_tech_serv_loan_type_cd, o.high_tech_serv_loan_type_cd) as high_tech_serv_loan_type_cd -- 高技术服务业贷款类型代码
    ,nvl(n.acct_recvbl_tran_way_cd, o.acct_recvbl_tran_way_cd) as acct_recvbl_tran_way_cd -- 应收账款转让方式代码
    ,nvl(n.oper_start_dt, o.oper_start_dt) as oper_start_dt -- 运营开始日期
    ,nvl(n.ppp_proj_flg, o.ppp_proj_flg) as ppp_proj_flg -- PPP项目标志
    ,nvl(n.new_distr_flg, o.new_distr_flg) as new_distr_flg -- 新机制放款标志
    ,nvl(n.cashflow_cover_bbal_flg, o.cashflow_cover_bbal_flg) as cashflow_cover_bbal_flg -- 预测现金流覆盖借款余额标志
    ,nvl(n.mger_cert_type_cd, o.mger_cert_type_cd) as mger_cert_type_cd -- 管理人证件类型代码
    ,nvl(n.mger_cert_no, o.mger_cert_no) as mger_cert_no -- 管理人证件号码
    ,nvl(n.int_payer_name, o.int_payer_name) as int_payer_name -- 付息方名称
    ,nvl(n.guar_housing_loan_type_cd, o.guar_housing_loan_type_cd) as guar_housing_loan_type_cd -- 保障性住房贷款类型代码
    ,nvl(n.cust_ins_adj_type_cd, o.cust_ins_adj_type_cd) as cust_ins_adj_type_cd -- 客户产业结构调整类型代码
    ,nvl(n.proj_fin_flg, o.proj_fin_flg) as proj_fin_flg -- 项目融资标志
    ,nvl(n.rela_peop_guar_loan_flg, o.rela_peop_guar_loan_flg) as rela_peop_guar_loan_flg -- 关系人保证贷款标志
    ,nvl(n.rei_loan_flg, o.rei_loan_flg) as rei_loan_flg -- 房地产开发贷款标志
    ,case when
            n.agt_id is null
            and n.cont_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.cont_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.cont_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.cont_id = n.cont_id
where (
        o.agt_id is null
        and o.cont_id is null
    )
    or (
        n.agt_id is null
        and n.cont_id is null
    )
    or (
        o.trade_cont_tot_amt <> n.trade_cont_tot_amt
        or o.fin_cont_flg <> n.fin_cont_flg
        or o.cont_type_cd <> n.cont_type_cd
        or o.trade_cont_id <> n.trade_cont_id
        or o.lc_kind_cd <> n.lc_kind_cd
        or o.lc_amt <> n.lc_amt
        or o.lc_curr_cd <> n.lc_curr_cd
        or o.lc_id <> n.lc_id
        or o.load_bill_id <> n.load_bill_id
        or o.batch_id <> n.batch_id
        or o.setup_proj_batch_id <> n.setup_proj_batch_id
        or o.lc_type_cd <> n.lc_type_cd
        or o.aldy_acpt_fwd_lc_flg <> n.aldy_acpt_fwd_lc_flg
        or o.lc_tenor_type_cd <> n.lc_tenor_type_cd
        or o.lc_char_cd <> n.lc_char_cd
        or o.fwd_pay_day_tenor <> n.fwd_pay_day_tenor
        or o.fee_undertaker <> n.fee_undertaker
        or o.other_fee_rat <> n.other_fee_rat
        or o.cargo_name <> n.cargo_name
        or o.cargo_underly <> n.cargo_underly
        or o.cargo_traff_destination <> n.cargo_traff_destination
        or o.traff_way_cd <> n.traff_way_cd
        or o.cls_freq <> n.cls_freq
        or o.mom_lics_id <> n.mom_lics_id
        or o.mom_lics_curr_cd <> n.mom_lics_curr_cd
        or o.mom_lics_amt <> n.mom_lics_amt
        or o.acct_recvbl_net_amnt <> n.acct_recvbl_net_amnt
        or o.gover_crdt_type_cd <> n.gover_crdt_type_cd
        or o.tran_bg_descb <> n.tran_bg_descb
        or o.fix_asset_crdt_flg <> n.fix_asset_crdt_flg
        or o.entr_dep_ec_cls_cd <> n.entr_dep_ec_cls_cd
        or o.pkg_ratio <> n.pkg_ratio
        or o.guar_type_cd <> n.guar_type_cd
        or o.entr_loan_cap_src_cd <> n.entr_loan_cap_src_cd
        or o.nego_bank_cfm_flg <> n.nego_bank_cfm_flg
        or o.discnt_int_buyer_bear_ratio <> n.discnt_int_buyer_bear_ratio
        or o.discnt_bf_revw_flg <> n.discnt_bf_revw_flg
        or o.qual_centr_cntpty_flg <> n.qual_centr_cntpty_flg
        or o.margin_acct_id <> n.margin_acct_id
        or o.margin_curr_cd <> n.margin_curr_cd
        or o.margin_tran_out_acct_id <> n.margin_tran_out_acct_id
        or o.col_turn_margin_acct_id <> n.col_turn_margin_acct_id
        or o.margin_agt_rat <> n.margin_agt_rat
        or o.margin_int_rat_type_cd <> n.margin_int_rat_type_cd
        or o.margin_flo_val <> n.margin_flo_val
        or o.margin_int_rat_float_type_cd <> n.margin_int_rat_float_type_cd
        or o.margin_int_rat_float_way_cd <> n.margin_int_rat_float_way_cd
        or o.margin_int_accr_method_cd <> n.margin_int_accr_method_cd
        or o.margin_int_rat_level_cd <> n.margin_int_rat_level_cd
        or o.csner_name <> n.csner_name
        or o.repay_comnt_descb <> n.repay_comnt_descb
        or o.start_up_bus_guar_loan_type_cd <> n.start_up_bus_guar_loan_type_cd
        or o.consm_serv_class_fin_flg <> n.consm_serv_class_fin_flg
        or o.pay_way_cd <> n.pay_way_cd
        or o.draw_comnt_descb <> n.draw_comnt_descb
        or o.loan_amt_ocup_tran_price_money_ratio <> n.loan_amt_ocup_tran_price_money_ratio
        or o.trade_fin_mang_merchd <> n.trade_fin_mang_merchd
        or o.draft_qtty <> n.draft_qtty
        or o.discnt_commer_accpt_bil_cls_cd <> n.discnt_commer_accpt_bil_cls_cd
        or o.commer_inv_id <> n.commer_inv_id
        or o.commer_inv_type_cd <> n.commer_inv_type_cd
        or o.commer_inv_curr_cd <> n.commer_inv_curr_cd
        or o.commer_inv_amt <> n.commer_inv_amt
        or o.other_lics_id <> n.other_lics_id
        or o.other_lics_name <> n.other_lics_name
        or o.hp_lics_id <> n.hp_lics_id
        or o.arch_land_lics_id <> n.arch_land_lics_id
        or o.plan_lics_id <> n.plan_lics_id
        or o.cnstr_lics_id <> n.cnstr_lics_id
        or o.dir_ind_fund_flg <> n.dir_ind_fund_flg
        or o.entr_loan_espec_dir_cd <> n.entr_loan_espec_dir_cd
        or o.start_up_bus_guar_loan_flg <> n.start_up_bus_guar_loan_flg
        or o.entr_dep_acct_id <> n.entr_dep_acct_id
        or o.underly_prod_id <> n.underly_prod_id
        or o.prod_coll_amt <> n.prod_coll_amt
        or o.underly_prod_cls_lev_cd <> n.underly_prod_cls_lev_cd
        or o.surp_indus_cd <> n.surp_indus_cd
        or o.buy_house_site_dist_cd <> n.buy_house_site_dist_cd
        or o.agclt_flg <> n.agclt_flg
        or o.cntpty_name <> n.cntpty_name
        or o.cntpty_co_years <> n.cntpty_co_years
        or o.cntpty_sucs_tran_cnt <> n.cntpty_sucs_tran_cnt
        or o.cntpty_strg <> n.cntpty_strg
        or o.other_cond_request_descb <> n.other_cond_request_descb
        or o.imp_loan_proj_cd <> n.imp_loan_proj_cd
        or o.agclt_loan_dir_cd <> n.agclt_loan_dir_cd
        or o.distr_ratio <> n.distr_ratio
        or o.obank_open_flg <> n.obank_open_flg
        or o.capital_amt <> n.capital_amt
        or o.mgers_name <> n.mgers_name
        or o.trade_fin_prod_id <> n.trade_fin_prod_id
        or o.benefc_local_cty_or_rg_cd <> n.benefc_local_cty_or_rg_cd
        or o.buyer_name <> n.buyer_name
        or o.agclt_loan_main_type_cd <> n.agclt_loan_main_type_cd
        or o.issue_appl_form_id <> n.issue_appl_form_id
        or o.csner_id <> n.csner_id
        or o.imp_loan_proj_flg <> n.imp_loan_proj_flg
        or o.discnt_int_rat_comnt_descb <> n.discnt_int_rat_comnt_descb
        or o.factor_type_cd <> n.factor_type_cd
        or o.agt_pay_int_flg <> n.agt_pay_int_flg
        or o.start_work_dt <> n.start_work_dt
        or o.cdb_crdt_flg <> n.cdb_crdt_flg
        or o.provi_doc_dt <> n.provi_doc_dt
        or o.actl_finer <> n.actl_finer
        or o.discnt_applit_type_cd <> n.discnt_applit_type_cd
        or o.invo_gover_class_fin_flg <> n.invo_gover_class_fin_flg
        or o.loan_fin_supt_way_cd <> n.loan_fin_supt_way_cd
        or o.three_old_trasf_city_update_proj_flg <> n.three_old_trasf_city_update_proj_flg
        or o.syn_distrd_loan_amt <> n.syn_distrd_loan_amt
        or o.cap_src_cd <> n.cap_src_cd
        or o.gover_crdt_supt_way_cd <> n.gover_crdt_supt_way_cd
        or o.crdtc_indus_dir_cd <> n.crdtc_indus_dir_cd
        or o.sup_chain_fin_bus_prod_cls_cd <> n.sup_chain_fin_bus_prod_cls_cd
        or o.proj_info_text_id <> n.proj_info_text_id
        or o.exist_m_l_claus_flg <> n.exist_m_l_claus_flg
        or o.benefc_name <> n.benefc_name
        or o.entr_dep_curr_cd <> n.entr_dep_curr_cd
        or o.prepay_acct_recvbl_flg <> n.prepay_acct_recvbl_flg
        or o.acpt_bank_name <> n.acpt_bank_name
        or o.distr_org_id <> n.distr_org_id
        or o.cdb_crdt_prod_id <> n.cdb_crdt_prod_id
        or o.loan_usage_tran_amt <> n.loan_usage_tran_amt
        or o.gover_crdt_flg <> n.gover_crdt_flg
        or o.dir_makti_debt_eqty_flg <> n.dir_makti_debt_eqty_flg
        or o.major_incre_crdt_way_cd <> n.major_incre_crdt_way_cd
        or o.m_l_ratio <> n.m_l_ratio
        or o.loan_char_cd <> n.loan_char_cd
        or o.sup_chain_fin_bus_flg <> n.sup_chain_fin_bus_flg
        or o.advise_bank_name <> n.advise_bank_name
        or o.tran_asset_name <> n.tran_asset_name
        or o.loan_trast_way_cd <> n.loan_trast_way_cd
        or o.payfan_type_cd <> n.payfan_type_cd
        or o.remote_bus_flg <> n.remote_bus_flg
        or o.estate_loan_type_cd <> n.estate_loan_type_cd
        or o.discnt_int_applit_pay_ratio <> n.discnt_int_applit_pay_ratio
        or o.proj_tot_invest_amt <> n.proj_tot_invest_amt
        or o.cty_lmt_indus_flg <> n.cty_lmt_indus_flg
        or o.loc_fin_plat_solv_cap_src_cd <> n.loc_fin_plat_solv_cap_src_cd
        or o.acct_recvbl_prepay_way_cd <> n.acct_recvbl_prepay_way_cd
        or o.draw_way_cd <> n.draw_way_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.overs_loan_flg <> n.overs_loan_flg
        or o.land_use_cert_id <> n.land_use_cert_id
        or o.land_use_cert_dt <> n.land_use_cert_dt
        or o.land_plan_lics_id <> n.land_plan_lics_id
        or o.land_plan_lics_dt <> n.land_plan_lics_dt
        or o.cnstr_lics_dt <> n.cnstr_lics_dt
        or o.proj_plan_lics_dt <> n.proj_plan_lics_dt
        or o.order_name <> n.order_name
        or o.seller_name <> n.seller_name
        or o.trade_tran_content_descb <> n.trade_tran_content_descb
        or o.advanced_manu_flg <> n.advanced_manu_flg
        or o.cultur_industry_flg <> n.cultur_industry_flg
        or o.only_new_minorent_flg <> n.only_new_minorent_flg
        or o.only_new_littlegiantent_flg <> n.only_new_littlegiantent_flg
        or o.strtg_new_indus_type_cd <> n.strtg_new_indus_type_cd
        or o.indent_tech_flg <> n.indent_tech_flg
        or o.high_tech_serv_loan_flg <> n.high_tech_serv_loan_flg
        or o.high_tech_serv_loan_type_cd <> n.high_tech_serv_loan_type_cd
        or o.acct_recvbl_tran_way_cd <> n.acct_recvbl_tran_way_cd
        or o.oper_start_dt <> n.oper_start_dt
        or o.ppp_proj_flg <> n.ppp_proj_flg
        or o.new_distr_flg <> n.new_distr_flg
        or o.cashflow_cover_bbal_flg <> n.cashflow_cover_bbal_flg
        or o.mger_cert_type_cd <> n.mger_cert_type_cd
        or o.mger_cert_no <> n.mger_cert_no
        or o.int_payer_name <> n.int_payer_name
        or o.guar_housing_loan_type_cd <> n.guar_housing_loan_type_cd
        or o.cust_ins_adj_type_cd <> n.cust_ins_adj_type_cd
        or o.proj_fin_flg <> n.proj_fin_flg
        or o.rela_peop_guar_loan_flg <> n.rela_peop_guar_loan_flg
        or o.rei_loan_flg <> n.rei_loan_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,fin_cont_flg -- 融资合同标志
    ,cont_type_cd -- 合同类型代码
    ,trade_cont_id -- 贸易合同编号
    ,lc_kind_cd -- 信用证种类代码
    ,lc_amt -- 信用证金额
    ,lc_curr_cd -- 信用证币种代码
    ,lc_id -- 信用证编号
    ,load_bill_id -- 提单编号
    ,batch_id -- 批文编号
    ,setup_proj_batch_id -- 立项批文编号
    ,lc_type_cd -- 信用证类型代码
    ,aldy_acpt_fwd_lc_flg -- 已承兑远期信用证标志
    ,lc_tenor_type_cd -- 信用证期限类型代码
    ,lc_char_cd -- 信用证性质代码
    ,fwd_pay_day_tenor -- 远期付款日期限
    ,fee_undertaker -- 费用承担人
    ,other_fee_rat -- 其他费率
    ,cargo_name -- 货物名称
    ,cargo_underly -- 货物标的
    ,cargo_traff_destination -- 货物运输目的地
    ,traff_way_cd -- 运输方式代码
    ,cls_freq -- 分类频率
    ,mom_lics_id -- 母证编号
    ,mom_lics_curr_cd -- 母证币种代码
    ,mom_lics_amt -- 母证金额
    ,acct_recvbl_net_amnt -- 应收帐款净额
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,tran_bg_descb -- 交易背景描述
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,entr_dep_ec_cls_cd -- 委托存款钞汇分类代码
    ,pkg_ratio -- 打包比例
    ,guar_type_cd -- 担保类型代码
    ,entr_loan_cap_src_cd -- 委托贷款资金来源代码
    ,nego_bank_cfm_flg -- 经议付行确认标志
    ,discnt_int_buyer_bear_ratio -- 贴现利息买方承担比例
    ,discnt_bf_revw_flg -- 先贴后查标志
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,margin_agt_rat -- 保证金协议利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,csner_name -- 委托人名称
    ,repay_comnt_descb -- 还款说明描述
    ,start_up_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,pay_way_cd -- 付款方式代码
    ,draw_comnt_descb -- 提款说明描述
    ,loan_amt_ocup_tran_price_money_ratio -- 贷款金额占交易价款比例
    ,trade_fin_mang_merchd -- 贸易融资经营商品
    ,draft_qtty -- 汇票数量
    ,discnt_commer_accpt_bil_cls_cd -- 贴现商业承兑汇票分类代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,commer_inv_amt -- 商业发票金额
    ,other_lics_id -- 其他许可证编号
    ,other_lics_name -- 其他许可证名称
    ,hp_lics_id -- 环评许可证编号
    ,arch_land_lics_id -- 建设用地许可证编号
    ,plan_lics_id -- 规划许可证编号
    ,cnstr_lics_id -- 施工许可证编号
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,entr_loan_espec_dir_cd -- 委托贷款特殊投向代码
    ,start_up_bus_guar_loan_flg -- 创业担保贷款标志
    ,entr_dep_acct_id -- 委托存款账户账号
    ,underly_prod_id -- 标的产品编号
    ,prod_coll_amt -- 产品募集金额
    ,underly_prod_cls_lev_cd -- 标的产品分级级别代码
    ,surp_indus_cd -- 过剩行业代码
    ,buy_house_site_dist_cd -- 买房所在地行政区划代码
    ,agclt_flg -- 涉农贷款标志
    ,cntpty_name -- 交易对手名称
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_strg -- 交易对手实力
    ,other_cond_request_descb -- 其他条件和要求描述
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,distr_ratio -- 放款比例
    ,obank_open_flg -- 他行代开标志
    ,capital_amt -- 资本金金额
    ,mgers_name -- 管理方名称
    ,trade_fin_prod_id -- 贸易融资产品编号
    ,benefc_local_cty_or_rg_cd -- 受益人所在国家或地区
    ,buyer_name -- 买方名称
    ,agclt_loan_main_type_cd -- 涉农贷款类型代码
    ,issue_appl_form_id -- 开证申请书编号
    ,csner_id -- 委托人编号
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,discnt_int_rat_comnt_descb -- 贴现利率说明描述
    ,factor_type_cd -- 保理类型代码
    ,agt_pay_int_flg -- 协议付息标志
    ,start_work_dt -- 开工日期
    ,cdb_crdt_flg -- 国开行授信标志
    ,provi_doc_dt -- 提供单据日期
    ,actl_finer -- 实际融资人
    ,discnt_applit_type_cd -- 贴现申请人类型代码
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,three_old_trasf_city_update_proj_flg -- 三旧改造城市更新项目标志
    ,syn_distrd_loan_amt -- 银团已发放贷款金额
    ,cap_src_cd -- 资金来源代码
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,crdtc_indus_dir_cd -- 征信行业投向代码
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,proj_info_text_id -- 项目信息文本编号
    ,exist_m_l_claus_flg -- 存在溢短装的条款标志
    ,benefc_name -- 受益人名称
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,prepay_acct_recvbl_flg -- 预付应收帐款标志
    ,acpt_bank_name -- 承兑行名称
    ,distr_org_id -- 放款机构编号
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,gover_crdt_flg -- 政府授信标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,major_incre_crdt_way_cd -- 主要增信方式代码
    ,m_l_ratio -- 溢短装比例
    ,loan_char_cd -- 贷款性质代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,advise_bank_name -- 通知行名称
    ,tran_asset_name -- 交易资产名称
    ,loan_trast_way_cd -- 贷款办理方式代码
    ,payfan_type_cd -- 代付类型代码
    ,remote_bus_flg -- 异地业务标志
    ,estate_loan_type_cd -- 房地产贷款类型代码
    ,discnt_int_applit_pay_ratio -- 贴现利息申请人支付比例
    ,proj_tot_invest_amt -- 项目总投资金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,loc_fin_plat_solv_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,acct_recvbl_prepay_way_cd -- 应收帐款预付方式代码
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,overs_loan_flg -- 境外贷款标志
    ,land_use_cert_id -- 土地使用证编号
    ,land_use_cert_dt -- 土地使用证日期
    ,land_plan_lics_id -- 用地规划许可证编号
    ,land_plan_lics_dt -- 用地规划许可证日期
    ,cnstr_lics_dt -- 施工许可证日期
    ,proj_plan_lics_dt -- 工程规划许可证日期
    ,order_name -- 购货方名称
    ,seller_name -- 销货方名称
    ,trade_tran_content_descb -- 贸易交易内容描述
    ,advanced_manu_flg -- 先进制造业标志
    ,cultur_industry_flg -- 文化产业标志
    ,only_new_minorent_flg -- 专精特新中小企业标志
    ,only_new_littlegiantent_flg -- 专精特新小巨人企业标志
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,high_tech_serv_loan_flg -- 高技术服务业贷款标志
    ,high_tech_serv_loan_type_cd -- 高技术服务业贷款类型代码
    ,acct_recvbl_tran_way_cd -- 应收账款转让方式代码
    ,oper_start_dt -- 运营开始日期
    ,ppp_proj_flg -- PPP项目标志
    ,new_distr_flg -- 新机制放款标志
    ,cashflow_cover_bbal_flg -- 预测现金流覆盖借款余额标志
    ,mger_cert_type_cd -- 管理人证件类型代码
    ,mger_cert_no -- 管理人证件号码
    ,int_payer_name -- 付息方名称
    ,guar_housing_loan_type_cd -- 保障性住房贷款类型代码
    ,cust_ins_adj_type_cd -- 客户产业结构调整类型代码
    ,proj_fin_flg -- 项目融资标志
    ,rela_peop_guar_loan_flg -- 关系人保证贷款标志
    ,rei_loan_flg -- 房地产开发贷款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,fin_cont_flg -- 融资合同标志
    ,cont_type_cd -- 合同类型代码
    ,trade_cont_id -- 贸易合同编号
    ,lc_kind_cd -- 信用证种类代码
    ,lc_amt -- 信用证金额
    ,lc_curr_cd -- 信用证币种代码
    ,lc_id -- 信用证编号
    ,load_bill_id -- 提单编号
    ,batch_id -- 批文编号
    ,setup_proj_batch_id -- 立项批文编号
    ,lc_type_cd -- 信用证类型代码
    ,aldy_acpt_fwd_lc_flg -- 已承兑远期信用证标志
    ,lc_tenor_type_cd -- 信用证期限类型代码
    ,lc_char_cd -- 信用证性质代码
    ,fwd_pay_day_tenor -- 远期付款日期限
    ,fee_undertaker -- 费用承担人
    ,other_fee_rat -- 其他费率
    ,cargo_name -- 货物名称
    ,cargo_underly -- 货物标的
    ,cargo_traff_destination -- 货物运输目的地
    ,traff_way_cd -- 运输方式代码
    ,cls_freq -- 分类频率
    ,mom_lics_id -- 母证编号
    ,mom_lics_curr_cd -- 母证币种代码
    ,mom_lics_amt -- 母证金额
    ,acct_recvbl_net_amnt -- 应收帐款净额
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,tran_bg_descb -- 交易背景描述
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,entr_dep_ec_cls_cd -- 委托存款钞汇分类代码
    ,pkg_ratio -- 打包比例
    ,guar_type_cd -- 担保类型代码
    ,entr_loan_cap_src_cd -- 委托贷款资金来源代码
    ,nego_bank_cfm_flg -- 经议付行确认标志
    ,discnt_int_buyer_bear_ratio -- 贴现利息买方承担比例
    ,discnt_bf_revw_flg -- 先贴后查标志
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,margin_acct_id -- 保证金账户编号
    ,margin_curr_cd -- 保证金币种代码
    ,margin_tran_out_acct_id -- 保证金转出账户编号
    ,col_turn_margin_acct_id -- 押品转保证金账户编号
    ,margin_agt_rat -- 保证金协议利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,margin_flo_val -- 保证金浮动值
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_int_accr_method_cd -- 保证金计息方法代码
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,csner_name -- 委托人名称
    ,repay_comnt_descb -- 还款说明描述
    ,start_up_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,pay_way_cd -- 付款方式代码
    ,draw_comnt_descb -- 提款说明描述
    ,loan_amt_ocup_tran_price_money_ratio -- 贷款金额占交易价款比例
    ,trade_fin_mang_merchd -- 贸易融资经营商品
    ,draft_qtty -- 汇票数量
    ,discnt_commer_accpt_bil_cls_cd -- 贴现商业承兑汇票分类代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,commer_inv_amt -- 商业发票金额
    ,other_lics_id -- 其他许可证编号
    ,other_lics_name -- 其他许可证名称
    ,hp_lics_id -- 环评许可证编号
    ,arch_land_lics_id -- 建设用地许可证编号
    ,plan_lics_id -- 规划许可证编号
    ,cnstr_lics_id -- 施工许可证编号
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,entr_loan_espec_dir_cd -- 委托贷款特殊投向代码
    ,start_up_bus_guar_loan_flg -- 创业担保贷款标志
    ,entr_dep_acct_id -- 委托存款账户账号
    ,underly_prod_id -- 标的产品编号
    ,prod_coll_amt -- 产品募集金额
    ,underly_prod_cls_lev_cd -- 标的产品分级级别代码
    ,surp_indus_cd -- 过剩行业代码
    ,buy_house_site_dist_cd -- 买房所在地行政区划代码
    ,agclt_flg -- 涉农贷款标志
    ,cntpty_name -- 交易对手名称
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_strg -- 交易对手实力
    ,other_cond_request_descb -- 其他条件和要求描述
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,distr_ratio -- 放款比例
    ,obank_open_flg -- 他行代开标志
    ,capital_amt -- 资本金金额
    ,mgers_name -- 管理方名称
    ,trade_fin_prod_id -- 贸易融资产品编号
    ,benefc_local_cty_or_rg_cd -- 受益人所在国家或地区
    ,buyer_name -- 买方名称
    ,agclt_loan_main_type_cd -- 涉农贷款类型代码
    ,issue_appl_form_id -- 开证申请书编号
    ,csner_id -- 委托人编号
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,discnt_int_rat_comnt_descb -- 贴现利率说明描述
    ,factor_type_cd -- 保理类型代码
    ,agt_pay_int_flg -- 协议付息标志
    ,start_work_dt -- 开工日期
    ,cdb_crdt_flg -- 国开行授信标志
    ,provi_doc_dt -- 提供单据日期
    ,actl_finer -- 实际融资人
    ,discnt_applit_type_cd -- 贴现申请人类型代码
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,three_old_trasf_city_update_proj_flg -- 三旧改造城市更新项目标志
    ,syn_distrd_loan_amt -- 银团已发放贷款金额
    ,cap_src_cd -- 资金来源代码
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,crdtc_indus_dir_cd -- 征信行业投向代码
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,proj_info_text_id -- 项目信息文本编号
    ,exist_m_l_claus_flg -- 存在溢短装的条款标志
    ,benefc_name -- 受益人名称
    ,entr_dep_curr_cd -- 委托存款币种代码
    ,prepay_acct_recvbl_flg -- 预付应收帐款标志
    ,acpt_bank_name -- 承兑行名称
    ,distr_org_id -- 放款机构编号
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,loan_usage_tran_amt -- 贷款用途交易金额
    ,gover_crdt_flg -- 政府授信标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,major_incre_crdt_way_cd -- 主要增信方式代码
    ,m_l_ratio -- 溢短装比例
    ,loan_char_cd -- 贷款性质代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,advise_bank_name -- 通知行名称
    ,tran_asset_name -- 交易资产名称
    ,loan_trast_way_cd -- 贷款办理方式代码
    ,payfan_type_cd -- 代付类型代码
    ,remote_bus_flg -- 异地业务标志
    ,estate_loan_type_cd -- 房地产贷款类型代码
    ,discnt_int_applit_pay_ratio -- 贴现利息申请人支付比例
    ,proj_tot_invest_amt -- 项目总投资金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,loc_fin_plat_solv_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,acct_recvbl_prepay_way_cd -- 应收帐款预付方式代码
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,overs_loan_flg -- 境外贷款标志
    ,land_use_cert_id -- 土地使用证编号
    ,land_use_cert_dt -- 土地使用证日期
    ,land_plan_lics_id -- 用地规划许可证编号
    ,land_plan_lics_dt -- 用地规划许可证日期
    ,cnstr_lics_dt -- 施工许可证日期
    ,proj_plan_lics_dt -- 工程规划许可证日期
    ,order_name -- 购货方名称
    ,seller_name -- 销货方名称
    ,trade_tran_content_descb -- 贸易交易内容描述
    ,advanced_manu_flg -- 先进制造业标志
    ,cultur_industry_flg -- 文化产业标志
    ,only_new_minorent_flg -- 专精特新中小企业标志
    ,only_new_littlegiantent_flg -- 专精特新小巨人企业标志
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,indent_tech_flg -- 工业企业技术改造升级标志
    ,high_tech_serv_loan_flg -- 高技术服务业贷款标志
    ,high_tech_serv_loan_type_cd -- 高技术服务业贷款类型代码
    ,acct_recvbl_tran_way_cd -- 应收账款转让方式代码
    ,oper_start_dt -- 运营开始日期
    ,ppp_proj_flg -- PPP项目标志
    ,new_distr_flg -- 新机制放款标志
    ,cashflow_cover_bbal_flg -- 预测现金流覆盖借款余额标志
    ,mger_cert_type_cd -- 管理人证件类型代码
    ,mger_cert_no -- 管理人证件号码
    ,int_payer_name -- 付息方名称
    ,guar_housing_loan_type_cd -- 保障性住房贷款类型代码
    ,cust_ins_adj_type_cd -- 客户产业结构调整类型代码
    ,proj_fin_flg -- 项目融资标志
    ,rela_peop_guar_loan_flg -- 关系人保证贷款标志
    ,rei_loan_flg -- 房地产开发贷款标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.cont_id -- 合同编号
    ,o.trade_cont_tot_amt -- 贸易合同总金额
    ,o.fin_cont_flg -- 融资合同标志
    ,o.cont_type_cd -- 合同类型代码
    ,o.trade_cont_id -- 贸易合同编号
    ,o.lc_kind_cd -- 信用证种类代码
    ,o.lc_amt -- 信用证金额
    ,o.lc_curr_cd -- 信用证币种代码
    ,o.lc_id -- 信用证编号
    ,o.load_bill_id -- 提单编号
    ,o.batch_id -- 批文编号
    ,o.setup_proj_batch_id -- 立项批文编号
    ,o.lc_type_cd -- 信用证类型代码
    ,o.aldy_acpt_fwd_lc_flg -- 已承兑远期信用证标志
    ,o.lc_tenor_type_cd -- 信用证期限类型代码
    ,o.lc_char_cd -- 信用证性质代码
    ,o.fwd_pay_day_tenor -- 远期付款日期限
    ,o.fee_undertaker -- 费用承担人
    ,o.other_fee_rat -- 其他费率
    ,o.cargo_name -- 货物名称
    ,o.cargo_underly -- 货物标的
    ,o.cargo_traff_destination -- 货物运输目的地
    ,o.traff_way_cd -- 运输方式代码
    ,o.cls_freq -- 分类频率
    ,o.mom_lics_id -- 母证编号
    ,o.mom_lics_curr_cd -- 母证币种代码
    ,o.mom_lics_amt -- 母证金额
    ,o.acct_recvbl_net_amnt -- 应收帐款净额
    ,o.gover_crdt_type_cd -- 政府授信类型代码
    ,o.tran_bg_descb -- 交易背景描述
    ,o.fix_asset_crdt_flg -- 固定资产授信标志
    ,o.entr_dep_ec_cls_cd -- 委托存款钞汇分类代码
    ,o.pkg_ratio -- 打包比例
    ,o.guar_type_cd -- 担保类型代码
    ,o.entr_loan_cap_src_cd -- 委托贷款资金来源代码
    ,o.nego_bank_cfm_flg -- 经议付行确认标志
    ,o.discnt_int_buyer_bear_ratio -- 贴现利息买方承担比例
    ,o.discnt_bf_revw_flg -- 先贴后查标志
    ,o.qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,o.margin_acct_id -- 保证金账户编号
    ,o.margin_curr_cd -- 保证金币种代码
    ,o.margin_tran_out_acct_id -- 保证金转出账户编号
    ,o.col_turn_margin_acct_id -- 押品转保证金账户编号
    ,o.margin_agt_rat -- 保证金协议利率
    ,o.margin_int_rat_type_cd -- 保证金利率类型代码
    ,o.margin_flo_val -- 保证金浮动值
    ,o.margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,o.margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,o.margin_int_accr_method_cd -- 保证金计息方法代码
    ,o.margin_int_rat_level_cd -- 保证金利率档次代码
    ,o.csner_name -- 委托人名称
    ,o.repay_comnt_descb -- 还款说明描述
    ,o.start_up_bus_guar_loan_type_cd -- 创业担保贷款类型代码
    ,o.consm_serv_class_fin_flg -- 消费服务类融资标志
    ,o.pay_way_cd -- 付款方式代码
    ,o.draw_comnt_descb -- 提款说明描述
    ,o.loan_amt_ocup_tran_price_money_ratio -- 贷款金额占交易价款比例
    ,o.trade_fin_mang_merchd -- 贸易融资经营商品
    ,o.draft_qtty -- 汇票数量
    ,o.discnt_commer_accpt_bil_cls_cd -- 贴现商业承兑汇票分类代码
    ,o.commer_inv_id -- 商业发票编号
    ,o.commer_inv_type_cd -- 商业发票类型代码
    ,o.commer_inv_curr_cd -- 商业发票币种代码
    ,o.commer_inv_amt -- 商业发票金额
    ,o.other_lics_id -- 其他许可证编号
    ,o.other_lics_name -- 其他许可证名称
    ,o.hp_lics_id -- 环评许可证编号
    ,o.arch_land_lics_id -- 建设用地许可证编号
    ,o.plan_lics_id -- 规划许可证编号
    ,o.cnstr_lics_id -- 施工许可证编号
    ,o.dir_ind_fund_flg -- 投向产业基金标志
    ,o.entr_loan_espec_dir_cd -- 委托贷款特殊投向代码
    ,o.start_up_bus_guar_loan_flg -- 创业担保贷款标志
    ,o.entr_dep_acct_id -- 委托存款账户账号
    ,o.underly_prod_id -- 标的产品编号
    ,o.prod_coll_amt -- 产品募集金额
    ,o.underly_prod_cls_lev_cd -- 标的产品分级级别代码
    ,o.surp_indus_cd -- 过剩行业代码
    ,o.buy_house_site_dist_cd -- 买房所在地行政区划代码
    ,o.agclt_flg -- 涉农贷款标志
    ,o.cntpty_name -- 交易对手名称
    ,o.cntpty_co_years -- 与交易对手合作年限
    ,o.cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,o.cntpty_strg -- 交易对手实力
    ,o.other_cond_request_descb -- 其他条件和要求描述
    ,o.imp_loan_proj_cd -- 重点贷款项目代码
    ,o.agclt_loan_dir_cd -- 涉农贷款用途类型代码
    ,o.distr_ratio -- 放款比例
    ,o.obank_open_flg -- 他行代开标志
    ,o.capital_amt -- 资本金金额
    ,o.mgers_name -- 管理方名称
    ,o.trade_fin_prod_id -- 贸易融资产品编号
    ,o.benefc_local_cty_or_rg_cd -- 受益人所在国家或地区
    ,o.buyer_name -- 买方名称
    ,o.agclt_loan_main_type_cd -- 涉农贷款类型代码
    ,o.issue_appl_form_id -- 开证申请书编号
    ,o.csner_id -- 委托人编号
    ,o.imp_loan_proj_flg -- 重点贷款项目标志
    ,o.discnt_int_rat_comnt_descb -- 贴现利率说明描述
    ,o.factor_type_cd -- 保理类型代码
    ,o.agt_pay_int_flg -- 协议付息标志
    ,o.start_work_dt -- 开工日期
    ,o.cdb_crdt_flg -- 国开行授信标志
    ,o.provi_doc_dt -- 提供单据日期
    ,o.actl_finer -- 实际融资人
    ,o.discnt_applit_type_cd -- 贴现申请人类型代码
    ,o.invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,o.loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,o.three_old_trasf_city_update_proj_flg -- 三旧改造城市更新项目标志
    ,o.syn_distrd_loan_amt -- 银团已发放贷款金额
    ,o.cap_src_cd -- 资金来源代码
    ,o.gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,o.crdtc_indus_dir_cd -- 征信行业投向代码
    ,o.sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,o.proj_info_text_id -- 项目信息文本编号
    ,o.exist_m_l_claus_flg -- 存在溢短装的条款标志
    ,o.benefc_name -- 受益人名称
    ,o.entr_dep_curr_cd -- 委托存款币种代码
    ,o.prepay_acct_recvbl_flg -- 预付应收帐款标志
    ,o.acpt_bank_name -- 承兑行名称
    ,o.distr_org_id -- 放款机构编号
    ,o.cdb_crdt_prod_id -- 国开行授信产品编号
    ,o.loan_usage_tran_amt -- 贷款用途交易金额
    ,o.gover_crdt_flg -- 政府授信标志
    ,o.dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,o.major_incre_crdt_way_cd -- 主要增信方式代码
    ,o.m_l_ratio -- 溢短装比例
    ,o.loan_char_cd -- 贷款性质代码
    ,o.sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,o.advise_bank_name -- 通知行名称
    ,o.tran_asset_name -- 交易资产名称
    ,o.loan_trast_way_cd -- 贷款办理方式代码
    ,o.payfan_type_cd -- 代付类型代码
    ,o.remote_bus_flg -- 异地业务标志
    ,o.estate_loan_type_cd -- 房地产贷款类型代码
    ,o.discnt_int_applit_pay_ratio -- 贴现利息申请人支付比例
    ,o.proj_tot_invest_amt -- 项目总投资金额
    ,o.cty_lmt_indus_flg -- 国家限制行业标志
    ,o.loc_fin_plat_solv_cap_src_cd -- 地方融资平台偿债资金来源代码
    ,o.acct_recvbl_prepay_way_cd -- 应收帐款预付方式代码
    ,o.draw_way_cd -- 提款方式代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.overs_loan_flg -- 境外贷款标志
    ,o.land_use_cert_id -- 土地使用证编号
    ,o.land_use_cert_dt -- 土地使用证日期
    ,o.land_plan_lics_id -- 用地规划许可证编号
    ,o.land_plan_lics_dt -- 用地规划许可证日期
    ,o.cnstr_lics_dt -- 施工许可证日期
    ,o.proj_plan_lics_dt -- 工程规划许可证日期
    ,o.order_name -- 购货方名称
    ,o.seller_name -- 销货方名称
    ,o.trade_tran_content_descb -- 贸易交易内容描述
    ,o.advanced_manu_flg -- 先进制造业标志
    ,o.cultur_industry_flg -- 文化产业标志
    ,o.only_new_minorent_flg -- 专精特新中小企业标志
    ,o.only_new_littlegiantent_flg -- 专精特新小巨人企业标志
    ,o.strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,o.indent_tech_flg -- 工业企业技术改造升级标志
    ,o.high_tech_serv_loan_flg -- 高技术服务业贷款标志
    ,o.high_tech_serv_loan_type_cd -- 高技术服务业贷款类型代码
    ,o.acct_recvbl_tran_way_cd -- 应收账款转让方式代码
    ,o.oper_start_dt -- 运营开始日期
    ,o.ppp_proj_flg -- PPP项目标志
    ,o.new_distr_flg -- 新机制放款标志
    ,o.cashflow_cover_bbal_flg -- 预测现金流覆盖借款余额标志
    ,o.mger_cert_type_cd -- 管理人证件类型代码
    ,o.mger_cert_no -- 管理人证件号码
    ,o.int_payer_name -- 付息方名称
    ,o.guar_housing_loan_type_cd -- 保障性住房贷款类型代码
    ,o.cust_ins_adj_type_cd -- 客户产业结构调整类型代码
    ,o.proj_fin_flg -- 项目融资标志
    ,o.rela_peop_guar_loan_flg -- 关系人保证贷款标志
    ,o.rei_loan_flg -- 房地产开发贷款标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.cont_id = n.cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.cont_id = d.cont_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h;
--alter table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_cont_corp_loan_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_cont_corp_loan_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_cont_corp_loan_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
