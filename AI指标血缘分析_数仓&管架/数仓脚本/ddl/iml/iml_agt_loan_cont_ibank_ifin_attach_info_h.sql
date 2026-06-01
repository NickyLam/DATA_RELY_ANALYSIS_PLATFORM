/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_cont_ibank_ifin_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,cont_id varchar2(100) -- 合同编号
    ,cntpty_name varchar2(500) -- 交易对手名称
    ,actl_finer_id varchar2(250) -- 实际融资人编号
    ,qual_centr_cntpty_flg varchar2(10) -- 合格中央交易对手标志
    ,imp_loan_proj_cd varchar2(30) -- 重点贷款项目代码
    ,cntpty_sucs_tran_cnt number(10) -- 与交易对手成功交易次数
    ,cntpty_co_years varchar2(30) -- 与交易对手合作年限
    ,cntpty_strg varchar2(30) -- 交易对手实力
    ,cdb_crdt_flg varchar2(10) -- 国开行授信标志
    ,cap_src_cd varchar2(30) -- 资金来源代码
    ,invest_way_cd varchar2(30) -- 投资方式代码
    ,mgmt_mode_cd varchar2(30) -- 管理模式代码
    ,tran_asset_name varchar2(500) -- 交易资产名称
    ,dir_ind_fund_flg varchar2(10) -- 投向产业基金标志
    ,dir_makti_debt_eqty_flg varchar2(10) -- 投向市场化债转股标志
    ,invo_gover_class_fin_flg varchar2(10) -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg varchar2(10) -- 消费服务类融资标志
    ,underly_prod_id varchar2(100) -- 标的产品编号
    ,underly_prod_name varchar2(500) -- 标的产品名称
    ,septbl_flg varchar2(10) -- 可分离标志
    ,cota_opt_choice_flg varchar2(10) -- 含有回售选择权标志
    ,put_appl_begin_dt date -- 回售申请起始日期
    ,put_appl_closing_dt date -- 回售申请截止日期
    ,tran_market_type_cd varchar2(30) -- 交易市场类型代码
    ,tran_market_name varchar2(500) -- 交易市场名称
    ,cash_dt date -- 兑付日期
    ,incre_crdt_way_cd varchar2(30) -- 增信方式代码
    ,class_crdt_flg varchar2(10) -- 类信贷标志
    ,underly_prod_cls_flg varchar2(10) -- 标的产品分级标志
    ,underly_prod_cls_lev_cd varchar2(30) -- 标的产品分级级别
    ,underly_prod_coll_amt number(30,2) -- 标的产品募集金额
    ,uder_asset_type_cd varchar2(30) -- 底层资产类型代码
    ,csner_name varchar2(500) -- 委托人名称
    ,csner_id varchar2(100) -- 委托人编号
    ,acpt_bank_no varchar2(60) -- 承兑行行号
    ,bill_draw_dt date -- 票据出票日期
    ,bill_id varchar2(100) -- 票据编号
    ,bill_curr_cd varchar2(30) -- 票据币种代码
    ,bill_exp_dt date -- 票据到期日期
    ,pente_type_cd varchar2(30) -- 穿透类型代码
    ,trust_am_cont_name varchar2(500) -- 信托资管合同名称
    ,trust_am_cont_type_cd varchar2(30) -- 信托资管合同类型代码
    ,guar_type_cd varchar2(30) -- 担保类型代码
    ,imp_loan_proj_flg varchar2(10) -- 重点贷款项目标志
    ,acpt_bank_name varchar2(500) -- 承兑行名称
    ,benefc_name varchar2(500) -- 受益人名称
    ,benefc_expect_year_net_yld_rat number(18,8) -- 受益人预计年净收益率
    ,benefc_acct_id varchar2(100) -- 受益人账户编号
    ,fix_asset_crdt_flg varchar2(10) -- 固定资产授信标志
    ,other_cond_request_descb varchar2(4000) -- 其他条件和要求描述
    ,dir_paste_bank_name varchar2(500) -- 直贴行名称
    ,dir_paste_bank_no varchar2(60) -- 直贴行行号
    ,dir_paste_hxb_cust_id varchar2(100) -- 直贴行我行客户编号
    ,hxb_dir_paste_bill_flg varchar2(10) -- 我行直贴票据标志
    ,cont_type_cd varchar2(30) -- 合同类型代码
    ,rela_trade_cont_id varchar2(100) -- 相关贸易合同编号
    ,stl_dep_flg varchar2(10) -- 结算性存款标志
    ,coll_cap_acct_id varchar2(100) -- 募集资金账户编号
    ,commer_inv_amt number(30,2) -- 商业发票金额
    ,loan_fin_supt_way_cd varchar2(30) -- 贷款财政扶持方式代码
    ,commer_inv_id varchar2(100) -- 商业发票编号
    ,commer_inv_type_cd varchar2(30) -- 商业发票类型代码
    ,sup_chain_fin_bus_flg varchar2(10) -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd varchar2(30) -- 供应链金融业务产品分类代码
    ,commer_inv_curr_cd varchar2(30) -- 商业发票币种代码
    ,surp_indus_cd varchar2(30) -- 过剩行业代码
    ,entred_ps_name varchar2(500) -- 受托人名称
    ,gover_crdt_flg varchar2(10) -- 政府授信标志
    ,gover_crdt_supt_way_cd varchar2(30) -- 政府授信支持方式代码
    ,gover_crdt_type_cd varchar2(30) -- 政府授信类型代码
    ,discount_int_rat number(18,8) -- 转贴现利率
    ,fac_val_amt number(30,2) -- 票面金额
    ,trustee_name varchar2(500) -- 托管人名称
    ,bill_cls_cd varchar2(30) -- 票据分类代码
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,underly_tenor number(10) -- 标的期限
    ,issue_amt number(30,2) -- 发行金额
    ,cty_lmt_indus_flg varchar2(10) -- 国家限制行业标志
    ,trade_cont_tot_amt number(30,2) -- 贸易合同总金额
    ,mger_name varchar2(500) -- 管理人名称
    ,dep_rcpt_no_code varchar2(60) -- 存单号码
    ,agclt_flg varchar2(10) -- 涉农贷款标志
    ,repay_comnt_descb varchar2(500) -- 还款说明描述
    ,underly_stock_cd varchar2(30) -- 标的股票代码
    ,underly_stock_name varchar2(500) -- 标的股票名称
    ,brwer_name varchar2(500) -- 借款人名称
    ,use_prod_cd varchar2(30) -- 使用产品代码
    ,draw_comnt_descb varchar2(500) -- 提款说明描述
    ,bank_int_indus_dir_cd varchar2(30) -- 行内行业投向代码
    ,invest_char_cd varchar2(30) -- 投资性质代码
    ,cdb_crdt_prod_id varchar2(100) -- 国开行授信产品编号
    ,issue_dt date -- 发行日期
    ,exp_dt date -- 到期日期
    ,tran_bg_descb varchar2(250) -- 交易背景描述
    ,ncds_abbr varchar2(60) -- 同业存单简称
    ,draw_way_cd varchar2(30) -- 提款方式代码
    ,repay_way_cd varchar2(30) -- 还款方式代码
    ,batch_data_src_cd varchar2(30) -- 批量数据来源代码
    ,asset_id varchar2(250) -- 资产编号
    ,abs_tran_name varchar2(500) -- 资产证券化交易名称
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,underly_corp_indus_type varchar2(500) -- 标的公司行业类型
    ,drawer_name varchar2(500) -- 出票方名称
    ,curr_bond_ext_rating_rest_cd varchar2(30) -- 当前债券外部评级结果代码
    ,issue_corp_name varchar2(500) -- 发行公司名称
    ,issue_corp_cert_no varchar2(60) -- 发行公司证件号码
    ,issue_corp_cert_type_cd varchar2(30) -- 发行公司证件类型代码
    ,issue_price number(30,8) -- 发行价格
    ,issue_qtty number(30,8) -- 发行量
    ,issue_bond_ext_rating_cd varchar2(30) -- 发行债券外部评级代码
    ,buy_bond_ext_rating_rest_cd varchar2(30) -- 购买债券外部评级结果代码
    ,repo_type_cd varchar2(30) -- 回购类型代码
    ,cntpty_id varchar2(100) -- 交易对手编号
    ,acct_cate_cd varchar2(60) -- 账户类别代码
    ,int_set_way_cd varchar2(30) -- 结息方式代码
    ,mang_merchd_kind_cd varchar2(60) -- 经营商品种类代码
    ,acpt_bank_cust_id varchar2(100) -- 承兑行客户编号
    ,trust_am_cont_cap number(30,8) -- 信托资管合同资金
    ,circlt_cap_stock number(30,8) -- 流通股本
    ,fac_val_int_rat number(18,8) -- 票面利率
    ,close_pos_line number(30,2) -- 平仓线
    ,actl_dlvy_dt date -- 实际交割日期
    ,bag_net_price number(30,8) -- 成交净价
    ,bag_int_rat number(18,8) -- 成交利率
    ,bag_qtty number(30,2) -- 成交量
    ,warning_line number(30,2) -- 预警线
    ,init_asset_uniq_idf varchar2(100) -- 原资产唯一标识
    ,info_integy_flg varchar2(10) -- 已完整录入全部底层资产信息标志
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h is '贷款合同同业投融资附属信息历史';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cont_id is '合同编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cntpty_name is '交易对手名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.actl_finer_id is '实际融资人编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.qual_centr_cntpty_flg is '合格中央交易对手标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.imp_loan_proj_cd is '重点贷款项目代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cntpty_sucs_tran_cnt is '与交易对手成功交易次数';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cntpty_co_years is '与交易对手合作年限';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cntpty_strg is '交易对手实力';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cdb_crdt_flg is '国开行授信标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cap_src_cd is '资金来源代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.invest_way_cd is '投资方式代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.mgmt_mode_cd is '管理模式代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.tran_asset_name is '交易资产名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.dir_ind_fund_flg is '投向产业基金标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.dir_makti_debt_eqty_flg is '投向市场化债转股标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.invo_gover_class_fin_flg is '涉及政府类融资标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.consm_serv_class_fin_flg is '消费服务类融资标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.underly_prod_id is '标的产品编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.underly_prod_name is '标的产品名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.septbl_flg is '可分离标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cota_opt_choice_flg is '含有回售选择权标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.put_appl_begin_dt is '回售申请起始日期';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.put_appl_closing_dt is '回售申请截止日期';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.tran_market_type_cd is '交易市场类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.tran_market_name is '交易市场名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cash_dt is '兑付日期';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.incre_crdt_way_cd is '增信方式代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.class_crdt_flg is '类信贷标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.underly_prod_cls_flg is '标的产品分级标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.underly_prod_cls_lev_cd is '标的产品分级级别';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.underly_prod_coll_amt is '标的产品募集金额';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.uder_asset_type_cd is '底层资产类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.csner_name is '委托人名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.csner_id is '委托人编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.acpt_bank_no is '承兑行行号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bill_draw_dt is '票据出票日期';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bill_id is '票据编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bill_curr_cd is '票据币种代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bill_exp_dt is '票据到期日期';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.pente_type_cd is '穿透类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.trust_am_cont_name is '信托资管合同名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.trust_am_cont_type_cd is '信托资管合同类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.guar_type_cd is '担保类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.imp_loan_proj_flg is '重点贷款项目标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.acpt_bank_name is '承兑行名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.benefc_name is '受益人名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.benefc_expect_year_net_yld_rat is '受益人预计年净收益率';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.benefc_acct_id is '受益人账户编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.fix_asset_crdt_flg is '固定资产授信标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.other_cond_request_descb is '其他条件和要求描述';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.dir_paste_bank_name is '直贴行名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.dir_paste_bank_no is '直贴行行号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.dir_paste_hxb_cust_id is '直贴行我行客户编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.hxb_dir_paste_bill_flg is '我行直贴票据标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cont_type_cd is '合同类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.rela_trade_cont_id is '相关贸易合同编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.stl_dep_flg is '结算性存款标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.coll_cap_acct_id is '募集资金账户编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.commer_inv_amt is '商业发票金额';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.loan_fin_supt_way_cd is '贷款财政扶持方式代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.commer_inv_id is '商业发票编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.commer_inv_type_cd is '商业发票类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.sup_chain_fin_bus_flg is '供应链金融业务标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.sup_chain_fin_bus_prod_cls_cd is '供应链金融业务产品分类代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.commer_inv_curr_cd is '商业发票币种代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.surp_indus_cd is '过剩行业代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.entred_ps_name is '受托人名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.gover_crdt_flg is '政府授信标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.gover_crdt_supt_way_cd is '政府授信支持方式代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.gover_crdt_type_cd is '政府授信类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.discount_int_rat is '转贴现利率';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.fac_val_amt is '票面金额';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.trustee_name is '托管人名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bill_cls_cd is '票据分类代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.underly_tenor is '标的期限';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.issue_amt is '发行金额';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cty_lmt_indus_flg is '国家限制行业标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.trade_cont_tot_amt is '贸易合同总金额';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.mger_name is '管理人名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.dep_rcpt_no_code is '存单号码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.agclt_flg is '涉农贷款标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.repay_comnt_descb is '还款说明描述';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.underly_stock_cd is '标的股票代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.underly_stock_name is '标的股票名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.brwer_name is '借款人名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.use_prod_cd is '使用产品代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.draw_comnt_descb is '提款说明描述';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bank_int_indus_dir_cd is '行内行业投向代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.invest_char_cd is '投资性质代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cdb_crdt_prod_id is '国开行授信产品编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.issue_dt is '发行日期';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.tran_bg_descb is '交易背景描述';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.ncds_abbr is '同业存单简称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.draw_way_cd is '提款方式代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.batch_data_src_cd is '批量数据来源代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.asset_id is '资产编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.abs_tran_name is '资产证券化交易名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.underly_corp_indus_type is '标的公司行业类型';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.drawer_name is '出票方名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.curr_bond_ext_rating_rest_cd is '当前债券外部评级结果代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.issue_corp_name is '发行公司名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.issue_corp_cert_no is '发行公司证件号码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.issue_corp_cert_type_cd is '发行公司证件类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.issue_price is '发行价格';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.issue_qtty is '发行量';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.issue_bond_ext_rating_cd is '发行债券外部评级代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.buy_bond_ext_rating_rest_cd is '购买债券外部评级结果代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.repo_type_cd is '回购类型代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.cntpty_id is '交易对手编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.acct_cate_cd is '账户类别代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.int_set_way_cd is '结息方式代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.mang_merchd_kind_cd is '经营商品种类代码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.acpt_bank_cust_id is '承兑行客户编号';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.trust_am_cont_cap is '信托资管合同资金';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.circlt_cap_stock is '流通股本';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.fac_val_int_rat is '票面利率';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.close_pos_line is '平仓线';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.actl_dlvy_dt is '实际交割日期';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bag_net_price is '成交净价';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bag_int_rat is '成交利率';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.bag_qtty is '成交量';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.warning_line is '预警线';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.init_asset_uniq_idf is '原资产唯一标识';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.info_integy_flg is '已完整录入全部底层资产信息标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h.etl_timestamp is 'ETL处理时间戳';
