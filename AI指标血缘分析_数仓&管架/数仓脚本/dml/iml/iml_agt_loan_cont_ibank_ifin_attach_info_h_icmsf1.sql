/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_cont_ibank_ifin_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,cntpty_name -- 交易对手名称
    ,actl_finer_id -- 实际融资人编号
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_strg -- 交易对手实力
    ,cdb_crdt_flg -- 国开行授信标志
    ,cap_src_cd -- 资金来源代码
    ,invest_way_cd -- 投资方式代码
    ,mgmt_mode_cd -- 管理模式代码
    ,tran_asset_name -- 交易资产名称
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,underly_prod_id -- 标的产品编号
    ,underly_prod_name -- 标的产品名称
    ,septbl_flg -- 可分离标志
    ,cota_opt_choice_flg -- 含有回售选择权标志
    ,put_appl_begin_dt -- 回售申请起始日期
    ,put_appl_closing_dt -- 回售申请截止日期
    ,tran_market_type_cd -- 交易市场类型代码
    ,tran_market_name -- 交易市场名称
    ,cash_dt -- 兑付日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,class_crdt_flg -- 类信贷标志
    ,underly_prod_cls_flg -- 标的产品分级标志
    ,underly_prod_cls_lev_cd -- 标的产品分级级别
    ,underly_prod_coll_amt -- 标的产品募集金额
    ,uder_asset_type_cd -- 底层资产类型代码
    ,csner_name -- 委托人名称
    ,csner_id -- 委托人编号
    ,acpt_bank_no -- 承兑行行号
    ,bill_draw_dt -- 票据出票日期
    ,bill_id -- 票据编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_exp_dt -- 票据到期日期
    ,pente_type_cd -- 穿透类型代码
    ,trust_am_cont_name -- 信托资管合同名称
    ,trust_am_cont_type_cd -- 信托资管合同类型代码
    ,guar_type_cd -- 担保类型代码
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,acpt_bank_name -- 承兑行名称
    ,benefc_name -- 受益人名称
    ,benefc_expect_year_net_yld_rat -- 受益人预计年净收益率
    ,benefc_acct_id -- 受益人账户编号
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,other_cond_request_descb -- 其他条件和要求描述
    ,dir_paste_bank_name -- 直贴行名称
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_hxb_cust_id -- 直贴行我行客户编号
    ,hxb_dir_paste_bill_flg -- 我行直贴票据标志
    ,cont_type_cd -- 合同类型代码
    ,rela_trade_cont_id -- 相关贸易合同编号
    ,stl_dep_flg -- 结算性存款标志
    ,coll_cap_acct_id -- 募集资金账户编号
    ,commer_inv_amt -- 商业发票金额
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,surp_indus_cd -- 过剩行业代码
    ,entred_ps_name -- 受托人名称
    ,gover_crdt_flg -- 政府授信标志
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,discount_int_rat -- 转贴现利率
    ,fac_val_amt -- 票面金额
    ,trustee_name -- 托管人名称
    ,bill_cls_cd -- 票据分类代码
    ,bill_type_cd -- 票据类型代码
    ,underly_tenor -- 标的期限
    ,issue_amt -- 发行金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,mger_name -- 管理人名称
    ,dep_rcpt_no_code -- 存单号码
    ,agclt_flg -- 涉农贷款标志
    ,repay_comnt_descb -- 还款说明描述
    ,underly_stock_cd -- 标的股票代码
    ,underly_stock_name -- 标的股票名称
    ,brwer_name -- 借款人名称
    ,use_prod_cd -- 使用产品代码
    ,draw_comnt_descb -- 提款说明描述
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,invest_char_cd -- 投资性质代码
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,tran_bg_descb -- 交易背景描述
    ,ncds_abbr -- 同业存单简称
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,batch_data_src_cd -- 批量数据来源代码
    ,asset_id -- 资产编号
    ,abs_tran_name -- 资产证券化交易名称
    ,bus_type_cd -- 业务类型代码
    ,underly_corp_indus_type -- 标的公司行业类型
    ,drawer_name -- 出票方名称
    ,curr_bond_ext_rating_rest_cd -- 当前债券外部评级结果代码
    ,issue_corp_name -- 发行公司名称
    ,issue_corp_cert_no -- 发行公司证件号码
    ,issue_corp_cert_type_cd -- 发行公司证件类型代码
    ,issue_price -- 发行价格
    ,issue_qtty -- 发行量
    ,issue_bond_ext_rating_cd -- 发行债券外部评级代码
    ,buy_bond_ext_rating_rest_cd -- 购买债券外部评级结果代码
    ,repo_type_cd -- 回购类型代码
    ,cntpty_id -- 交易对手编号
    ,acct_cate_cd -- 账户类别代码
    ,int_set_way_cd -- 结息方式代码
    ,mang_merchd_kind_cd -- 经营商品种类代码
    ,acpt_bank_cust_id -- 承兑行客户编号
    ,trust_am_cont_cap -- 信托资管合同资金
    ,circlt_cap_stock -- 流通股本
    ,fac_val_int_rat -- 票面利率
    ,close_pos_line -- 平仓线
    ,actl_dlvy_dt -- 实际交割日期
    ,bag_net_price -- 成交净价
    ,bag_int_rat -- 成交利率
    ,bag_qtty -- 成交量
    ,warning_line -- 预警线
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,info_integy_flg -- 已完整录入全部底层资产信息标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bc_extend_t-1
insert into ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,cntpty_name -- 交易对手名称
    ,actl_finer_id -- 实际融资人编号
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_strg -- 交易对手实力
    ,cdb_crdt_flg -- 国开行授信标志
    ,cap_src_cd -- 资金来源代码
    ,invest_way_cd -- 投资方式代码
    ,mgmt_mode_cd -- 管理模式代码
    ,tran_asset_name -- 交易资产名称
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,underly_prod_id -- 标的产品编号
    ,underly_prod_name -- 标的产品名称
    ,septbl_flg -- 可分离标志
    ,cota_opt_choice_flg -- 含有回售选择权标志
    ,put_appl_begin_dt -- 回售申请起始日期
    ,put_appl_closing_dt -- 回售申请截止日期
    ,tran_market_type_cd -- 交易市场类型代码
    ,tran_market_name -- 交易市场名称
    ,cash_dt -- 兑付日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,class_crdt_flg -- 类信贷标志
    ,underly_prod_cls_flg -- 标的产品分级标志
    ,underly_prod_cls_lev_cd -- 标的产品分级级别
    ,underly_prod_coll_amt -- 标的产品募集金额
    ,uder_asset_type_cd -- 底层资产类型代码
    ,csner_name -- 委托人名称
    ,csner_id -- 委托人编号
    ,acpt_bank_no -- 承兑行行号
    ,bill_draw_dt -- 票据出票日期
    ,bill_id -- 票据编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_exp_dt -- 票据到期日期
    ,pente_type_cd -- 穿透类型代码
    ,trust_am_cont_name -- 信托资管合同名称
    ,trust_am_cont_type_cd -- 信托资管合同类型代码
    ,guar_type_cd -- 担保类型代码
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,acpt_bank_name -- 承兑行名称
    ,benefc_name -- 受益人名称
    ,benefc_expect_year_net_yld_rat -- 受益人预计年净收益率
    ,benefc_acct_id -- 受益人账户编号
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,other_cond_request_descb -- 其他条件和要求描述
    ,dir_paste_bank_name -- 直贴行名称
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_hxb_cust_id -- 直贴行我行客户编号
    ,hxb_dir_paste_bill_flg -- 我行直贴票据标志
    ,cont_type_cd -- 合同类型代码
    ,rela_trade_cont_id -- 相关贸易合同编号
    ,stl_dep_flg -- 结算性存款标志
    ,coll_cap_acct_id -- 募集资金账户编号
    ,commer_inv_amt -- 商业发票金额
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,surp_indus_cd -- 过剩行业代码
    ,entred_ps_name -- 受托人名称
    ,gover_crdt_flg -- 政府授信标志
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,discount_int_rat -- 转贴现利率
    ,fac_val_amt -- 票面金额
    ,trustee_name -- 托管人名称
    ,bill_cls_cd -- 票据分类代码
    ,bill_type_cd -- 票据类型代码
    ,underly_tenor -- 标的期限
    ,issue_amt -- 发行金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,mger_name -- 管理人名称
    ,dep_rcpt_no_code -- 存单号码
    ,agclt_flg -- 涉农贷款标志
    ,repay_comnt_descb -- 还款说明描述
    ,underly_stock_cd -- 标的股票代码
    ,underly_stock_name -- 标的股票名称
    ,brwer_name -- 借款人名称
    ,use_prod_cd -- 使用产品代码
    ,draw_comnt_descb -- 提款说明描述
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,invest_char_cd -- 投资性质代码
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,tran_bg_descb -- 交易背景描述
    ,ncds_abbr -- 同业存单简称
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,batch_data_src_cd -- 批量数据来源代码
    ,asset_id -- 资产编号
    ,abs_tran_name -- 资产证券化交易名称
    ,bus_type_cd -- 业务类型代码
    ,underly_corp_indus_type -- 标的公司行业类型
    ,drawer_name -- 出票方名称
    ,curr_bond_ext_rating_rest_cd -- 当前债券外部评级结果代码
    ,issue_corp_name -- 发行公司名称
    ,issue_corp_cert_no -- 发行公司证件号码
    ,issue_corp_cert_type_cd -- 发行公司证件类型代码
    ,issue_price -- 发行价格
    ,issue_qtty -- 发行量
    ,issue_bond_ext_rating_cd -- 发行债券外部评级代码
    ,buy_bond_ext_rating_rest_cd -- 购买债券外部评级结果代码
    ,repo_type_cd -- 回购类型代码
    ,cntpty_id -- 交易对手编号
    ,acct_cate_cd -- 账户类别代码
    ,int_set_way_cd -- 结息方式代码
    ,mang_merchd_kind_cd -- 经营商品种类代码
    ,acpt_bank_cust_id -- 承兑行客户编号
    ,trust_am_cont_cap -- 信托资管合同资金
    ,circlt_cap_stock -- 流通股本
    ,fac_val_int_rat -- 票面利率
    ,close_pos_line -- 平仓线
    ,actl_dlvy_dt -- 实际交割日期
    ,bag_net_price -- 成交净价
    ,bag_int_rat -- 成交利率
    ,bag_qtty -- 成交量
    ,warning_line -- 预警线
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,info_integy_flg -- 已完整录入全部底层资产信息标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300002'||P1.SERIALNO -- 协议编号
    ,P1.SERIALNO -- 合同编号
    ,P1.RIVALNAME -- 交易对手名称
    ,P1.FINANCIER -- 实际融资人编号
    ,nvl(trim(P1.ISCOUNTERPARTY),'-') -- 合格中央交易对手标志
    ,nvl(trim(P1.IMPORTANTLOAN),'-') -- 重点贷款项目代码
    ,nvl(regexp_substr(P1.TDTIMES, '[0-9]+'),'0') -- 与交易对手成功交易次数
    ,P1.TDYEARS -- 与交易对手合作年限
    ,P1.TDSTRENTH -- 交易对手实力
    ,nvl(trim(P1.SFGKSX),'-') -- 国开行授信标志
    ,nvl(trim(P1.FUNDSOURCE),'-') -- 资金来源代码
    ,nvl(trim(P1.INVESTWAY),'-') -- 投资方式代码
    ,P1.MANAGEMODEL -- 管理模式代码
    ,P1.TRADINGASSETS -- 交易资产名称
    ,nvl(trim(P1.TOINDUSTRYFUND),'-') -- 投向产业基金标志
    ,nvl(trim(P1.ISDEBTTOEQUITY),'-') -- 投向市场化债转股标志
    ,nvl(trim(P1.ISGOVERNFINANCE),'-') -- 涉及政府类融资标志
    ,nvl(trim(P1.ISCONSUMERFINANCE),'-') -- 消费服务类融资标志
    ,P1.BONDNO -- 标的产品编号
    ,P1.BONDNAME -- 标的产品名称
    ,P1.CANSEPARATE -- 可分离标志
    ,P1.CANBACKTOSALE -- 含有回售选择权标志
    ,${iml_schema}.dateformat_max2(P1.SALEBACKBEGINDATE) -- 回售申请起始日期
    ,${iml_schema}.dateformat_max2(P1.SALEBACKENDDATE) -- 回售申请截止日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.BUSINESSMARKETTYPE END -- 交易市场类型代码
    ,P1.BUSINESSMARKETNAME -- 交易市场名称
    ,decode(P1.PAYMENTDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),P1.PAYMENTDATE) -- 兑付日期
    ,nvl(trim(P1.CREDITINCREMENTTYPE),'-') -- 增信方式代码
    ,nvl(trim(P1.ISLIKELOAN),'-') -- 类信贷标志
    ,decode(trim(P1.ISCLASSFLAG),'Y','1','N','0','','-',null,'-',P1.ISCLASSFLAG)  -- 标的产品分级标志
    ,P1.PRODUCTLEVEL -- 标的产品分级级别
    ,P1.PRODUCTCOLLECTMONEY -- 标的产品募集金额
    ,P1.FINALINVESTDIRECTTYPE -- 底层资产类型代码
    ,P1.MANDATECUSTNAME -- 委托人名称
    ,P1.MANDATECUSTID -- 委托人编号
    ,P1.ACCEPTBANKID -- 承兑行行号
    ,${iml_schema}.dateformat_max2(P1.BILLACPTDATE) -- 票据出票日期
    ,P1.BILLNO -- 票据编号
    ,nvl(trim(P1.BILLCURRENCY),'-') -- 票据币种代码
    ,${iml_schema}.dateformat_max2(P1.BILLMATURITY) -- 票据到期日期
    ,P1.CHUANTOUTYPE -- 穿透类型代码
    ,P1.ECONTRACTNAME -- 信托资管合同名称
    ,P1.ECONTRACTTYPE -- 信托资管合同类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.GUARANTYTYPE END -- 担保类型代码
    ,nvl(trim(P1.ISIMPORTANTLOAN),'-') -- 重点贷款项目标志
    ,P1.ACCEPTBANKNAME -- 承兑行名称
    ,P1.BENEFICIARYNAME -- 受益人名称
    ,P1.BENEFICIARYYIELDRATE -- 受益人预计年净收益率
    ,P1.BENEFICIARYACCTNO -- 受益人账户编号
    ,nvl(trim(P1.IFGUDINGCREDIT),'-') -- 固定资产授信标志
    ,P1.OTHERCONDITION -- 其他条件和要求描述
    ,P1.ZTACCEPTBANKNAME -- 直贴行名称
    ,P1.ZTACCEPTBANKID -- 直贴行行号
    ,P1.RELZTACCEPTBANKCUSTID -- 直贴行我行客户编号
    ,P1.ISWHZT -- 我行直贴票据标志
    ,nvl(trim(p1.CREDITATTRIBUTE),'00') -- 合同类型代码
    ,P1.TRADECONTRACTNO -- 相关贸易合同编号
    ,P1.ISBALANCEDEPOSIT -- 结算性存款标志
    ,P1.RAISEMONEYACCOUNTID -- 募集资金账户编号
    ,P1.BUSINESSINVOICESUM -- 商业发票金额
    ,nvl(trim(P1.FINANCESUPPORTMODE),'-')  -- 贷款财政扶持方式代码
    ,P1.BUSINESSINVOICEINFO -- 商业发票编号
    ,nvl(trim(P1.BUSINESSINVOICETYPE),'-') -- 商业发票类型代码
    ,nvl(trim(P1.ISSUPPLYCHAINFINANCE),'-') -- 供应链金融业务标志
    ,nvl(trim(P1.SUPPLYCHAINFINANCETYPE),'-') -- 供应链金融业务产品分类代码
    ,nvl(trim(P1.BUSINESSINVOICECURRENCY),'-') -- 商业发票币种代码
    ,nvl(trim(P1.GSHY),'-') -- 过剩行业代码
    ,P1.BAILEENAME -- 受托人名称
    ,nvl(trim(P1.SFZFSX),'-') -- 政府授信标志
    ,nvl(trim(P1.ZFSXFS),'-') -- 政府授信支持方式代码
    ,nvl(trim(P1.ZFSXLX),'-') -- 政府授信类型代码
    ,P1.ZTRATE -- 转贴现利率
    ,P1.BILLSUM -- 票面金额
    ,P1.TRUSTEENAME -- 托管人名称
    ,nvl(trim(P1.BILLKIND),'0') -- 票据分类代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.BILLTYPE END -- 票据类型代码
    ,P1.DEADLINE -- 标的期限
    ,P1.ISSUESUM -- 发行金额
    ,nvl(trim(P1.SFGJXZHY),'-') -- 国家限制行业标志
    ,P1.TRADESUM -- 贸易合同总金额
    ,P1.CUSTODIANNAME -- 管理人名称
    ,P1.DEPOSITNO -- 存单号码
    ,nvl(trim(P1.ISFARMING),'-') -- 涉农贷款标志
    ,P1.REPAYREMARK -- 还款说明描述
    ,P1.STOCKCODE -- 标的股票代码
    ,P1.STOCKNAME -- 标的股票名称
    ,P1.PARTYBNAME -- 借款人名称
    ,nvl(trim(P1.USEPRODUCT),'-') -- 使用产品代码
    ,P1.DRAWINGREMARK -- 提款说明描述
    ,nvl(trim(P1.DIRECTIONRS),'-') -- 行内行业投向代码
    ,P1.INVESTKIND -- 投资性质代码
    ,P1.GKSXPZ -- 国开行授信产品编号
    ,P1.BEGINDATE -- 发行日期
    ,${iml_schema}.dateformat_max2(P1.ENDDATE) -- 到期日期
    ,P1.CONTEXTINFO -- 交易背景描述
    ,P1.DEPOSITNAME -- 同业存单简称
    ,nvl(trim(P1.DRAWINGTYPE),'00') -- 提款方式代码
    ,nvl(trim(P1.CORPUSPAYMETHOD),'-') -- 还款方式代码
    ,nvl(trim(P1.DATATYPE),'-') -- 批量数据来源代码
    ,P1.ASSETNO -- 资产编号
    ,P1.ABSABNNAME -- 资产证券化交易名称
    ,nvl(trim(P1.OPERATIONTYPE),'-') -- 业务类型代码
    ,P1.BDINDUSTRY -- 标的公司行业类型
    ,P1.BILLWRITER -- 出票方名称
    ,decode(trim(P1.OUTEREVALUATE3),'无','999','','999',P1.OUTEREVALUATE3) -- 当前债券外部评级结果代码
    ,P1.CONSIGNEENAME -- 发行公司名称
    ,P1.CONSIGNEECERTID -- 发行公司证件号码
    ,nvl(trim(P1.CONSIGNEECERTTYPE),'0000') -- 发行公司证件类型代码
    ,P1.ISSUEPRICE -- 发行价格
    ,P1.ISSUEAMOUNT -- 发行量
    ,decode(trim(P1.OUTEREVALUATE1),'无','999','','999',P1.OUTEREVALUATE1)  -- 发行债券外部评级代码
    ,nvl(trim(P1.OUTEREVALUATE2),'999') -- 购买债券外部评级结果代码
    ,nvl(trim(P1.BACKTOSALETYPE),'-') -- 回购类型代码
    ,P1.RIVALID -- 交易对手编号
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.ACCOUNTCATAGORY END -- 账户类别代码
    ,nvl(trim(P1.INTERESTREPAYCYCLE),'-') -- 结息方式代码
    ,nvl(trim(P1.MAINPRODUCT),'U') -- 经营商品种类代码
    ,P1.ACCEPTCUSTOMERID -- 承兑行客户编号
    ,P1.CONTRACTSUM -- 信托资管合同资金
    ,P1.CIRCULATESTOCKAMOUNT -- 流通股本
    ,P1.COUPONRATE -- 票面利率
    ,nvl(to_number(regexp_replace(P1.PCLINE,'[^0-9.]','')) ,0) -- 平仓线
    ,${iml_schema}.dateformat_max2(P1.TRANSACTIONDATE) -- 实际交割日期
    ,P1.TRANSACTIONPRICE -- 成交净价
    ,P1.TRANSACTIONRATE -- 成交利率
    ,nvl(to_number(regexp_replace(P1.TRANSACTOINAMOUNT,'[^0-9.]','')) ,0)  -- 成交量
    ,nvl(to_number(regexp_replace(P1.ALARMLINE,'[^0-9.]','')) ,0) -- 预警线
    ,P1.OLDASSETNO -- 原资产唯一标识
    ,nvl(trim(P1.ISFILLASSETSINFO),'-') -- 已完整录入全部底层资产信息标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bc_extend_t' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bc_extend_t p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.BUSINESSMARKETTYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_BC_EXTEND_T'
        AND R1.SRC_FIELD_EN_NAME= 'BUSINESSMARKETTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_CONT_IBANK_IFIN_ATTACH_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_MARKET_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.GUARANTYTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD='ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_BC_EXTEND_T'
        AND R2.SRC_FIELD_EN_NAME= 'GUARANTYTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_LOAN_CONT_IBANK_IFIN_ATTACH_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'GUAR_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.BILLTYPE= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD='ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_BC_EXTEND_T'
        AND R3.SRC_FIELD_EN_NAME= 'BILLTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_LOAN_CONT_IBANK_IFIN_ATTACH_INFO_H'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.ACCOUNTCATAGORY = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ICMS'
        AND R4.SRC_TAB_EN_NAME= 'ICMS_BC_EXTEND_T'
        AND R4.SRC_FIELD_EN_NAME= 'ACCOUNTCATAGORY'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_LOAN_CONT_IBANK_IFIN_ATTACH_INFO_H'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'ACCT_CATE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_tm 
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
        into ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,cntpty_name -- 交易对手名称
    ,actl_finer_id -- 实际融资人编号
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_strg -- 交易对手实力
    ,cdb_crdt_flg -- 国开行授信标志
    ,cap_src_cd -- 资金来源代码
    ,invest_way_cd -- 投资方式代码
    ,mgmt_mode_cd -- 管理模式代码
    ,tran_asset_name -- 交易资产名称
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,underly_prod_id -- 标的产品编号
    ,underly_prod_name -- 标的产品名称
    ,septbl_flg -- 可分离标志
    ,cota_opt_choice_flg -- 含有回售选择权标志
    ,put_appl_begin_dt -- 回售申请起始日期
    ,put_appl_closing_dt -- 回售申请截止日期
    ,tran_market_type_cd -- 交易市场类型代码
    ,tran_market_name -- 交易市场名称
    ,cash_dt -- 兑付日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,class_crdt_flg -- 类信贷标志
    ,underly_prod_cls_flg -- 标的产品分级标志
    ,underly_prod_cls_lev_cd -- 标的产品分级级别
    ,underly_prod_coll_amt -- 标的产品募集金额
    ,uder_asset_type_cd -- 底层资产类型代码
    ,csner_name -- 委托人名称
    ,csner_id -- 委托人编号
    ,acpt_bank_no -- 承兑行行号
    ,bill_draw_dt -- 票据出票日期
    ,bill_id -- 票据编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_exp_dt -- 票据到期日期
    ,pente_type_cd -- 穿透类型代码
    ,trust_am_cont_name -- 信托资管合同名称
    ,trust_am_cont_type_cd -- 信托资管合同类型代码
    ,guar_type_cd -- 担保类型代码
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,acpt_bank_name -- 承兑行名称
    ,benefc_name -- 受益人名称
    ,benefc_expect_year_net_yld_rat -- 受益人预计年净收益率
    ,benefc_acct_id -- 受益人账户编号
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,other_cond_request_descb -- 其他条件和要求描述
    ,dir_paste_bank_name -- 直贴行名称
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_hxb_cust_id -- 直贴行我行客户编号
    ,hxb_dir_paste_bill_flg -- 我行直贴票据标志
    ,cont_type_cd -- 合同类型代码
    ,rela_trade_cont_id -- 相关贸易合同编号
    ,stl_dep_flg -- 结算性存款标志
    ,coll_cap_acct_id -- 募集资金账户编号
    ,commer_inv_amt -- 商业发票金额
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,surp_indus_cd -- 过剩行业代码
    ,entred_ps_name -- 受托人名称
    ,gover_crdt_flg -- 政府授信标志
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,discount_int_rat -- 转贴现利率
    ,fac_val_amt -- 票面金额
    ,trustee_name -- 托管人名称
    ,bill_cls_cd -- 票据分类代码
    ,bill_type_cd -- 票据类型代码
    ,underly_tenor -- 标的期限
    ,issue_amt -- 发行金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,mger_name -- 管理人名称
    ,dep_rcpt_no_code -- 存单号码
    ,agclt_flg -- 涉农贷款标志
    ,repay_comnt_descb -- 还款说明描述
    ,underly_stock_cd -- 标的股票代码
    ,underly_stock_name -- 标的股票名称
    ,brwer_name -- 借款人名称
    ,use_prod_cd -- 使用产品代码
    ,draw_comnt_descb -- 提款说明描述
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,invest_char_cd -- 投资性质代码
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,tran_bg_descb -- 交易背景描述
    ,ncds_abbr -- 同业存单简称
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,batch_data_src_cd -- 批量数据来源代码
    ,asset_id -- 资产编号
    ,abs_tran_name -- 资产证券化交易名称
    ,bus_type_cd -- 业务类型代码
    ,underly_corp_indus_type -- 标的公司行业类型
    ,drawer_name -- 出票方名称
    ,curr_bond_ext_rating_rest_cd -- 当前债券外部评级结果代码
    ,issue_corp_name -- 发行公司名称
    ,issue_corp_cert_no -- 发行公司证件号码
    ,issue_corp_cert_type_cd -- 发行公司证件类型代码
    ,issue_price -- 发行价格
    ,issue_qtty -- 发行量
    ,issue_bond_ext_rating_cd -- 发行债券外部评级代码
    ,buy_bond_ext_rating_rest_cd -- 购买债券外部评级结果代码
    ,repo_type_cd -- 回购类型代码
    ,cntpty_id -- 交易对手编号
    ,acct_cate_cd -- 账户类别代码
    ,int_set_way_cd -- 结息方式代码
    ,mang_merchd_kind_cd -- 经营商品种类代码
    ,acpt_bank_cust_id -- 承兑行客户编号
    ,trust_am_cont_cap -- 信托资管合同资金
    ,circlt_cap_stock -- 流通股本
    ,fac_val_int_rat -- 票面利率
    ,close_pos_line -- 平仓线
    ,actl_dlvy_dt -- 实际交割日期
    ,bag_net_price -- 成交净价
    ,bag_int_rat -- 成交利率
    ,bag_qtty -- 成交量
    ,warning_line -- 预警线
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,info_integy_flg -- 已完整录入全部底层资产信息标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,cntpty_name -- 交易对手名称
    ,actl_finer_id -- 实际融资人编号
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_strg -- 交易对手实力
    ,cdb_crdt_flg -- 国开行授信标志
    ,cap_src_cd -- 资金来源代码
    ,invest_way_cd -- 投资方式代码
    ,mgmt_mode_cd -- 管理模式代码
    ,tran_asset_name -- 交易资产名称
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,underly_prod_id -- 标的产品编号
    ,underly_prod_name -- 标的产品名称
    ,septbl_flg -- 可分离标志
    ,cota_opt_choice_flg -- 含有回售选择权标志
    ,put_appl_begin_dt -- 回售申请起始日期
    ,put_appl_closing_dt -- 回售申请截止日期
    ,tran_market_type_cd -- 交易市场类型代码
    ,tran_market_name -- 交易市场名称
    ,cash_dt -- 兑付日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,class_crdt_flg -- 类信贷标志
    ,underly_prod_cls_flg -- 标的产品分级标志
    ,underly_prod_cls_lev_cd -- 标的产品分级级别
    ,underly_prod_coll_amt -- 标的产品募集金额
    ,uder_asset_type_cd -- 底层资产类型代码
    ,csner_name -- 委托人名称
    ,csner_id -- 委托人编号
    ,acpt_bank_no -- 承兑行行号
    ,bill_draw_dt -- 票据出票日期
    ,bill_id -- 票据编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_exp_dt -- 票据到期日期
    ,pente_type_cd -- 穿透类型代码
    ,trust_am_cont_name -- 信托资管合同名称
    ,trust_am_cont_type_cd -- 信托资管合同类型代码
    ,guar_type_cd -- 担保类型代码
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,acpt_bank_name -- 承兑行名称
    ,benefc_name -- 受益人名称
    ,benefc_expect_year_net_yld_rat -- 受益人预计年净收益率
    ,benefc_acct_id -- 受益人账户编号
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,other_cond_request_descb -- 其他条件和要求描述
    ,dir_paste_bank_name -- 直贴行名称
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_hxb_cust_id -- 直贴行我行客户编号
    ,hxb_dir_paste_bill_flg -- 我行直贴票据标志
    ,cont_type_cd -- 合同类型代码
    ,rela_trade_cont_id -- 相关贸易合同编号
    ,stl_dep_flg -- 结算性存款标志
    ,coll_cap_acct_id -- 募集资金账户编号
    ,commer_inv_amt -- 商业发票金额
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,surp_indus_cd -- 过剩行业代码
    ,entred_ps_name -- 受托人名称
    ,gover_crdt_flg -- 政府授信标志
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,discount_int_rat -- 转贴现利率
    ,fac_val_amt -- 票面金额
    ,trustee_name -- 托管人名称
    ,bill_cls_cd -- 票据分类代码
    ,bill_type_cd -- 票据类型代码
    ,underly_tenor -- 标的期限
    ,issue_amt -- 发行金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,mger_name -- 管理人名称
    ,dep_rcpt_no_code -- 存单号码
    ,agclt_flg -- 涉农贷款标志
    ,repay_comnt_descb -- 还款说明描述
    ,underly_stock_cd -- 标的股票代码
    ,underly_stock_name -- 标的股票名称
    ,brwer_name -- 借款人名称
    ,use_prod_cd -- 使用产品代码
    ,draw_comnt_descb -- 提款说明描述
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,invest_char_cd -- 投资性质代码
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,tran_bg_descb -- 交易背景描述
    ,ncds_abbr -- 同业存单简称
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,batch_data_src_cd -- 批量数据来源代码
    ,asset_id -- 资产编号
    ,abs_tran_name -- 资产证券化交易名称
    ,bus_type_cd -- 业务类型代码
    ,underly_corp_indus_type -- 标的公司行业类型
    ,drawer_name -- 出票方名称
    ,curr_bond_ext_rating_rest_cd -- 当前债券外部评级结果代码
    ,issue_corp_name -- 发行公司名称
    ,issue_corp_cert_no -- 发行公司证件号码
    ,issue_corp_cert_type_cd -- 发行公司证件类型代码
    ,issue_price -- 发行价格
    ,issue_qtty -- 发行量
    ,issue_bond_ext_rating_cd -- 发行债券外部评级代码
    ,buy_bond_ext_rating_rest_cd -- 购买债券外部评级结果代码
    ,repo_type_cd -- 回购类型代码
    ,cntpty_id -- 交易对手编号
    ,acct_cate_cd -- 账户类别代码
    ,int_set_way_cd -- 结息方式代码
    ,mang_merchd_kind_cd -- 经营商品种类代码
    ,acpt_bank_cust_id -- 承兑行客户编号
    ,trust_am_cont_cap -- 信托资管合同资金
    ,circlt_cap_stock -- 流通股本
    ,fac_val_int_rat -- 票面利率
    ,close_pos_line -- 平仓线
    ,actl_dlvy_dt -- 实际交割日期
    ,bag_net_price -- 成交净价
    ,bag_int_rat -- 成交利率
    ,bag_qtty -- 成交量
    ,warning_line -- 预警线
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,info_integy_flg -- 已完整录入全部底层资产信息标志
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
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.actl_finer_id, o.actl_finer_id) as actl_finer_id -- 实际融资人编号
    ,nvl(n.qual_centr_cntpty_flg, o.qual_centr_cntpty_flg) as qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,nvl(n.imp_loan_proj_cd, o.imp_loan_proj_cd) as imp_loan_proj_cd -- 重点贷款项目代码
    ,nvl(n.cntpty_sucs_tran_cnt, o.cntpty_sucs_tran_cnt) as cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,nvl(n.cntpty_co_years, o.cntpty_co_years) as cntpty_co_years -- 与交易对手合作年限
    ,nvl(n.cntpty_strg, o.cntpty_strg) as cntpty_strg -- 交易对手实力
    ,nvl(n.cdb_crdt_flg, o.cdb_crdt_flg) as cdb_crdt_flg -- 国开行授信标志
    ,nvl(n.cap_src_cd, o.cap_src_cd) as cap_src_cd -- 资金来源代码
    ,nvl(n.invest_way_cd, o.invest_way_cd) as invest_way_cd -- 投资方式代码
    ,nvl(n.mgmt_mode_cd, o.mgmt_mode_cd) as mgmt_mode_cd -- 管理模式代码
    ,nvl(n.tran_asset_name, o.tran_asset_name) as tran_asset_name -- 交易资产名称
    ,nvl(n.dir_ind_fund_flg, o.dir_ind_fund_flg) as dir_ind_fund_flg -- 投向产业基金标志
    ,nvl(n.dir_makti_debt_eqty_flg, o.dir_makti_debt_eqty_flg) as dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,nvl(n.invo_gover_class_fin_flg, o.invo_gover_class_fin_flg) as invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,nvl(n.consm_serv_class_fin_flg, o.consm_serv_class_fin_flg) as consm_serv_class_fin_flg -- 消费服务类融资标志
    ,nvl(n.underly_prod_id, o.underly_prod_id) as underly_prod_id -- 标的产品编号
    ,nvl(n.underly_prod_name, o.underly_prod_name) as underly_prod_name -- 标的产品名称
    ,nvl(n.septbl_flg, o.septbl_flg) as septbl_flg -- 可分离标志
    ,nvl(n.cota_opt_choice_flg, o.cota_opt_choice_flg) as cota_opt_choice_flg -- 含有回售选择权标志
    ,nvl(n.put_appl_begin_dt, o.put_appl_begin_dt) as put_appl_begin_dt -- 回售申请起始日期
    ,nvl(n.put_appl_closing_dt, o.put_appl_closing_dt) as put_appl_closing_dt -- 回售申请截止日期
    ,nvl(n.tran_market_type_cd, o.tran_market_type_cd) as tran_market_type_cd -- 交易市场类型代码
    ,nvl(n.tran_market_name, o.tran_market_name) as tran_market_name -- 交易市场名称
    ,nvl(n.cash_dt, o.cash_dt) as cash_dt -- 兑付日期
    ,nvl(n.incre_crdt_way_cd, o.incre_crdt_way_cd) as incre_crdt_way_cd -- 增信方式代码
    ,nvl(n.class_crdt_flg, o.class_crdt_flg) as class_crdt_flg -- 类信贷标志
    ,nvl(n.underly_prod_cls_flg, o.underly_prod_cls_flg) as underly_prod_cls_flg -- 标的产品分级标志
    ,nvl(n.underly_prod_cls_lev_cd, o.underly_prod_cls_lev_cd) as underly_prod_cls_lev_cd -- 标的产品分级级别
    ,nvl(n.underly_prod_coll_amt, o.underly_prod_coll_amt) as underly_prod_coll_amt -- 标的产品募集金额
    ,nvl(n.uder_asset_type_cd, o.uder_asset_type_cd) as uder_asset_type_cd -- 底层资产类型代码
    ,nvl(n.csner_name, o.csner_name) as csner_name -- 委托人名称
    ,nvl(n.csner_id, o.csner_id) as csner_id -- 委托人编号
    ,nvl(n.acpt_bank_no, o.acpt_bank_no) as acpt_bank_no -- 承兑行行号
    ,nvl(n.bill_draw_dt, o.bill_draw_dt) as bill_draw_dt -- 票据出票日期
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.bill_curr_cd, o.bill_curr_cd) as bill_curr_cd -- 票据币种代码
    ,nvl(n.bill_exp_dt, o.bill_exp_dt) as bill_exp_dt -- 票据到期日期
    ,nvl(n.pente_type_cd, o.pente_type_cd) as pente_type_cd -- 穿透类型代码
    ,nvl(n.trust_am_cont_name, o.trust_am_cont_name) as trust_am_cont_name -- 信托资管合同名称
    ,nvl(n.trust_am_cont_type_cd, o.trust_am_cont_type_cd) as trust_am_cont_type_cd -- 信托资管合同类型代码
    ,nvl(n.guar_type_cd, o.guar_type_cd) as guar_type_cd -- 担保类型代码
    ,nvl(n.imp_loan_proj_flg, o.imp_loan_proj_flg) as imp_loan_proj_flg -- 重点贷款项目标志
    ,nvl(n.acpt_bank_name, o.acpt_bank_name) as acpt_bank_name -- 承兑行名称
    ,nvl(n.benefc_name, o.benefc_name) as benefc_name -- 受益人名称
    ,nvl(n.benefc_expect_year_net_yld_rat, o.benefc_expect_year_net_yld_rat) as benefc_expect_year_net_yld_rat -- 受益人预计年净收益率
    ,nvl(n.benefc_acct_id, o.benefc_acct_id) as benefc_acct_id -- 受益人账户编号
    ,nvl(n.fix_asset_crdt_flg, o.fix_asset_crdt_flg) as fix_asset_crdt_flg -- 固定资产授信标志
    ,nvl(n.other_cond_request_descb, o.other_cond_request_descb) as other_cond_request_descb -- 其他条件和要求描述
    ,nvl(n.dir_paste_bank_name, o.dir_paste_bank_name) as dir_paste_bank_name -- 直贴行名称
    ,nvl(n.dir_paste_bank_no, o.dir_paste_bank_no) as dir_paste_bank_no -- 直贴行行号
    ,nvl(n.dir_paste_hxb_cust_id, o.dir_paste_hxb_cust_id) as dir_paste_hxb_cust_id -- 直贴行我行客户编号
    ,nvl(n.hxb_dir_paste_bill_flg, o.hxb_dir_paste_bill_flg) as hxb_dir_paste_bill_flg -- 我行直贴票据标志
    ,nvl(n.cont_type_cd, o.cont_type_cd) as cont_type_cd -- 合同类型代码
    ,nvl(n.rela_trade_cont_id, o.rela_trade_cont_id) as rela_trade_cont_id -- 相关贸易合同编号
    ,nvl(n.stl_dep_flg, o.stl_dep_flg) as stl_dep_flg -- 结算性存款标志
    ,nvl(n.coll_cap_acct_id, o.coll_cap_acct_id) as coll_cap_acct_id -- 募集资金账户编号
    ,nvl(n.commer_inv_amt, o.commer_inv_amt) as commer_inv_amt -- 商业发票金额
    ,nvl(n.loan_fin_supt_way_cd, o.loan_fin_supt_way_cd) as loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,nvl(n.commer_inv_id, o.commer_inv_id) as commer_inv_id -- 商业发票编号
    ,nvl(n.commer_inv_type_cd, o.commer_inv_type_cd) as commer_inv_type_cd -- 商业发票类型代码
    ,nvl(n.sup_chain_fin_bus_flg, o.sup_chain_fin_bus_flg) as sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,nvl(n.sup_chain_fin_bus_prod_cls_cd, o.sup_chain_fin_bus_prod_cls_cd) as sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,nvl(n.commer_inv_curr_cd, o.commer_inv_curr_cd) as commer_inv_curr_cd -- 商业发票币种代码
    ,nvl(n.surp_indus_cd, o.surp_indus_cd) as surp_indus_cd -- 过剩行业代码
    ,nvl(n.entred_ps_name, o.entred_ps_name) as entred_ps_name -- 受托人名称
    ,nvl(n.gover_crdt_flg, o.gover_crdt_flg) as gover_crdt_flg -- 政府授信标志
    ,nvl(n.gover_crdt_supt_way_cd, o.gover_crdt_supt_way_cd) as gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,nvl(n.gover_crdt_type_cd, o.gover_crdt_type_cd) as gover_crdt_type_cd -- 政府授信类型代码
    ,nvl(n.discount_int_rat, o.discount_int_rat) as discount_int_rat -- 转贴现利率
    ,nvl(n.fac_val_amt, o.fac_val_amt) as fac_val_amt -- 票面金额
    ,nvl(n.trustee_name, o.trustee_name) as trustee_name -- 托管人名称
    ,nvl(n.bill_cls_cd, o.bill_cls_cd) as bill_cls_cd -- 票据分类代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.underly_tenor, o.underly_tenor) as underly_tenor -- 标的期限
    ,nvl(n.issue_amt, o.issue_amt) as issue_amt -- 发行金额
    ,nvl(n.cty_lmt_indus_flg, o.cty_lmt_indus_flg) as cty_lmt_indus_flg -- 国家限制行业标志
    ,nvl(n.trade_cont_tot_amt, o.trade_cont_tot_amt) as trade_cont_tot_amt -- 贸易合同总金额
    ,nvl(n.mger_name, o.mger_name) as mger_name -- 管理人名称
    ,nvl(n.dep_rcpt_no_code, o.dep_rcpt_no_code) as dep_rcpt_no_code -- 存单号码
    ,nvl(n.agclt_flg, o.agclt_flg) as agclt_flg -- 涉农贷款标志
    ,nvl(n.repay_comnt_descb, o.repay_comnt_descb) as repay_comnt_descb -- 还款说明描述
    ,nvl(n.underly_stock_cd, o.underly_stock_cd) as underly_stock_cd -- 标的股票代码
    ,nvl(n.underly_stock_name, o.underly_stock_name) as underly_stock_name -- 标的股票名称
    ,nvl(n.brwer_name, o.brwer_name) as brwer_name -- 借款人名称
    ,nvl(n.use_prod_cd, o.use_prod_cd) as use_prod_cd -- 使用产品代码
    ,nvl(n.draw_comnt_descb, o.draw_comnt_descb) as draw_comnt_descb -- 提款说明描述
    ,nvl(n.bank_int_indus_dir_cd, o.bank_int_indus_dir_cd) as bank_int_indus_dir_cd -- 行内行业投向代码
    ,nvl(n.invest_char_cd, o.invest_char_cd) as invest_char_cd -- 投资性质代码
    ,nvl(n.cdb_crdt_prod_id, o.cdb_crdt_prod_id) as cdb_crdt_prod_id -- 国开行授信产品编号
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发行日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.tran_bg_descb, o.tran_bg_descb) as tran_bg_descb -- 交易背景描述
    ,nvl(n.ncds_abbr, o.ncds_abbr) as ncds_abbr -- 同业存单简称
    ,nvl(n.draw_way_cd, o.draw_way_cd) as draw_way_cd -- 提款方式代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.batch_data_src_cd, o.batch_data_src_cd) as batch_data_src_cd -- 批量数据来源代码
    ,nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.abs_tran_name, o.abs_tran_name) as abs_tran_name -- 资产证券化交易名称
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.underly_corp_indus_type, o.underly_corp_indus_type) as underly_corp_indus_type -- 标的公司行业类型
    ,nvl(n.drawer_name, o.drawer_name) as drawer_name -- 出票方名称
    ,nvl(n.curr_bond_ext_rating_rest_cd, o.curr_bond_ext_rating_rest_cd) as curr_bond_ext_rating_rest_cd -- 当前债券外部评级结果代码
    ,nvl(n.issue_corp_name, o.issue_corp_name) as issue_corp_name -- 发行公司名称
    ,nvl(n.issue_corp_cert_no, o.issue_corp_cert_no) as issue_corp_cert_no -- 发行公司证件号码
    ,nvl(n.issue_corp_cert_type_cd, o.issue_corp_cert_type_cd) as issue_corp_cert_type_cd -- 发行公司证件类型代码
    ,nvl(n.issue_price, o.issue_price) as issue_price -- 发行价格
    ,nvl(n.issue_qtty, o.issue_qtty) as issue_qtty -- 发行量
    ,nvl(n.issue_bond_ext_rating_cd, o.issue_bond_ext_rating_cd) as issue_bond_ext_rating_cd -- 发行债券外部评级代码
    ,nvl(n.buy_bond_ext_rating_rest_cd, o.buy_bond_ext_rating_rest_cd) as buy_bond_ext_rating_rest_cd -- 购买债券外部评级结果代码
    ,nvl(n.repo_type_cd, o.repo_type_cd) as repo_type_cd -- 回购类型代码
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.acct_cate_cd, o.acct_cate_cd) as acct_cate_cd -- 账户类别代码
    ,nvl(n.int_set_way_cd, o.int_set_way_cd) as int_set_way_cd -- 结息方式代码
    ,nvl(n.mang_merchd_kind_cd, o.mang_merchd_kind_cd) as mang_merchd_kind_cd -- 经营商品种类代码
    ,nvl(n.acpt_bank_cust_id, o.acpt_bank_cust_id) as acpt_bank_cust_id -- 承兑行客户编号
    ,nvl(n.trust_am_cont_cap, o.trust_am_cont_cap) as trust_am_cont_cap -- 信托资管合同资金
    ,nvl(n.circlt_cap_stock, o.circlt_cap_stock) as circlt_cap_stock -- 流通股本
    ,nvl(n.fac_val_int_rat, o.fac_val_int_rat) as fac_val_int_rat -- 票面利率
    ,nvl(n.close_pos_line, o.close_pos_line) as close_pos_line -- 平仓线
    ,nvl(n.actl_dlvy_dt, o.actl_dlvy_dt) as actl_dlvy_dt -- 实际交割日期
    ,nvl(n.bag_net_price, o.bag_net_price) as bag_net_price -- 成交净价
    ,nvl(n.bag_int_rat, o.bag_int_rat) as bag_int_rat -- 成交利率
    ,nvl(n.bag_qtty, o.bag_qtty) as bag_qtty -- 成交量
    ,nvl(n.warning_line, o.warning_line) as warning_line -- 预警线
    ,nvl(n.init_asset_uniq_idf, o.init_asset_uniq_idf) as init_asset_uniq_idf -- 原资产唯一标识
    ,nvl(n.info_integy_flg, o.info_integy_flg) as info_integy_flg -- 已完整录入全部底层资产信息标志
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
from ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.cntpty_name <> n.cntpty_name
        or o.actl_finer_id <> n.actl_finer_id
        or o.qual_centr_cntpty_flg <> n.qual_centr_cntpty_flg
        or o.imp_loan_proj_cd <> n.imp_loan_proj_cd
        or o.cntpty_sucs_tran_cnt <> n.cntpty_sucs_tran_cnt
        or o.cntpty_co_years <> n.cntpty_co_years
        or o.cntpty_strg <> n.cntpty_strg
        or o.cdb_crdt_flg <> n.cdb_crdt_flg
        or o.cap_src_cd <> n.cap_src_cd
        or o.invest_way_cd <> n.invest_way_cd
        or o.mgmt_mode_cd <> n.mgmt_mode_cd
        or o.tran_asset_name <> n.tran_asset_name
        or o.dir_ind_fund_flg <> n.dir_ind_fund_flg
        or o.dir_makti_debt_eqty_flg <> n.dir_makti_debt_eqty_flg
        or o.invo_gover_class_fin_flg <> n.invo_gover_class_fin_flg
        or o.consm_serv_class_fin_flg <> n.consm_serv_class_fin_flg
        or o.underly_prod_id <> n.underly_prod_id
        or o.underly_prod_name <> n.underly_prod_name
        or o.septbl_flg <> n.septbl_flg
        or o.cota_opt_choice_flg <> n.cota_opt_choice_flg
        or o.put_appl_begin_dt <> n.put_appl_begin_dt
        or o.put_appl_closing_dt <> n.put_appl_closing_dt
        or o.tran_market_type_cd <> n.tran_market_type_cd
        or o.tran_market_name <> n.tran_market_name
        or o.cash_dt <> n.cash_dt
        or o.incre_crdt_way_cd <> n.incre_crdt_way_cd
        or o.class_crdt_flg <> n.class_crdt_flg
        or o.underly_prod_cls_flg <> n.underly_prod_cls_flg
        or o.underly_prod_cls_lev_cd <> n.underly_prod_cls_lev_cd
        or o.underly_prod_coll_amt <> n.underly_prod_coll_amt
        or o.uder_asset_type_cd <> n.uder_asset_type_cd
        or o.csner_name <> n.csner_name
        or o.csner_id <> n.csner_id
        or o.acpt_bank_no <> n.acpt_bank_no
        or o.bill_draw_dt <> n.bill_draw_dt
        or o.bill_id <> n.bill_id
        or o.bill_curr_cd <> n.bill_curr_cd
        or o.bill_exp_dt <> n.bill_exp_dt
        or o.pente_type_cd <> n.pente_type_cd
        or o.trust_am_cont_name <> n.trust_am_cont_name
        or o.trust_am_cont_type_cd <> n.trust_am_cont_type_cd
        or o.guar_type_cd <> n.guar_type_cd
        or o.imp_loan_proj_flg <> n.imp_loan_proj_flg
        or o.acpt_bank_name <> n.acpt_bank_name
        or o.benefc_name <> n.benefc_name
        or o.benefc_expect_year_net_yld_rat <> n.benefc_expect_year_net_yld_rat
        or o.benefc_acct_id <> n.benefc_acct_id
        or o.fix_asset_crdt_flg <> n.fix_asset_crdt_flg
        or o.other_cond_request_descb <> n.other_cond_request_descb
        or o.dir_paste_bank_name <> n.dir_paste_bank_name
        or o.dir_paste_bank_no <> n.dir_paste_bank_no
        or o.dir_paste_hxb_cust_id <> n.dir_paste_hxb_cust_id
        or o.hxb_dir_paste_bill_flg <> n.hxb_dir_paste_bill_flg
        or o.cont_type_cd <> n.cont_type_cd
        or o.rela_trade_cont_id <> n.rela_trade_cont_id
        or o.stl_dep_flg <> n.stl_dep_flg
        or o.coll_cap_acct_id <> n.coll_cap_acct_id
        or o.commer_inv_amt <> n.commer_inv_amt
        or o.loan_fin_supt_way_cd <> n.loan_fin_supt_way_cd
        or o.commer_inv_id <> n.commer_inv_id
        or o.commer_inv_type_cd <> n.commer_inv_type_cd
        or o.sup_chain_fin_bus_flg <> n.sup_chain_fin_bus_flg
        or o.sup_chain_fin_bus_prod_cls_cd <> n.sup_chain_fin_bus_prod_cls_cd
        or o.commer_inv_curr_cd <> n.commer_inv_curr_cd
        or o.surp_indus_cd <> n.surp_indus_cd
        or o.entred_ps_name <> n.entred_ps_name
        or o.gover_crdt_flg <> n.gover_crdt_flg
        or o.gover_crdt_supt_way_cd <> n.gover_crdt_supt_way_cd
        or o.gover_crdt_type_cd <> n.gover_crdt_type_cd
        or o.discount_int_rat <> n.discount_int_rat
        or o.fac_val_amt <> n.fac_val_amt
        or o.trustee_name <> n.trustee_name
        or o.bill_cls_cd <> n.bill_cls_cd
        or o.bill_type_cd <> n.bill_type_cd
        or o.underly_tenor <> n.underly_tenor
        or o.issue_amt <> n.issue_amt
        or o.cty_lmt_indus_flg <> n.cty_lmt_indus_flg
        or o.trade_cont_tot_amt <> n.trade_cont_tot_amt
        or o.mger_name <> n.mger_name
        or o.dep_rcpt_no_code <> n.dep_rcpt_no_code
        or o.agclt_flg <> n.agclt_flg
        or o.repay_comnt_descb <> n.repay_comnt_descb
        or o.underly_stock_cd <> n.underly_stock_cd
        or o.underly_stock_name <> n.underly_stock_name
        or o.brwer_name <> n.brwer_name
        or o.use_prod_cd <> n.use_prod_cd
        or o.draw_comnt_descb <> n.draw_comnt_descb
        or o.bank_int_indus_dir_cd <> n.bank_int_indus_dir_cd
        or o.invest_char_cd <> n.invest_char_cd
        or o.cdb_crdt_prod_id <> n.cdb_crdt_prod_id
        or o.issue_dt <> n.issue_dt
        or o.exp_dt <> n.exp_dt
        or o.tran_bg_descb <> n.tran_bg_descb
        or o.ncds_abbr <> n.ncds_abbr
        or o.draw_way_cd <> n.draw_way_cd
        or o.repay_way_cd <> n.repay_way_cd
        or o.batch_data_src_cd <> n.batch_data_src_cd
        or o.asset_id <> n.asset_id
        or o.abs_tran_name <> n.abs_tran_name
        or o.bus_type_cd <> n.bus_type_cd
        or o.underly_corp_indus_type <> n.underly_corp_indus_type
        or o.drawer_name <> n.drawer_name
        or o.curr_bond_ext_rating_rest_cd <> n.curr_bond_ext_rating_rest_cd
        or o.issue_corp_name <> n.issue_corp_name
        or o.issue_corp_cert_no <> n.issue_corp_cert_no
        or o.issue_corp_cert_type_cd <> n.issue_corp_cert_type_cd
        or o.issue_price <> n.issue_price
        or o.issue_qtty <> n.issue_qtty
        or o.issue_bond_ext_rating_cd <> n.issue_bond_ext_rating_cd
        or o.buy_bond_ext_rating_rest_cd <> n.buy_bond_ext_rating_rest_cd
        or o.repo_type_cd <> n.repo_type_cd
        or o.cntpty_id <> n.cntpty_id
        or o.acct_cate_cd <> n.acct_cate_cd
        or o.int_set_way_cd <> n.int_set_way_cd
        or o.mang_merchd_kind_cd <> n.mang_merchd_kind_cd
        or o.acpt_bank_cust_id <> n.acpt_bank_cust_id
        or o.trust_am_cont_cap <> n.trust_am_cont_cap
        or o.circlt_cap_stock <> n.circlt_cap_stock
        or o.fac_val_int_rat <> n.fac_val_int_rat
        or o.close_pos_line <> n.close_pos_line
        or o.actl_dlvy_dt <> n.actl_dlvy_dt
        or o.bag_net_price <> n.bag_net_price
        or o.bag_int_rat <> n.bag_int_rat
        or o.bag_qtty <> n.bag_qtty
        or o.warning_line <> n.warning_line
        or o.init_asset_uniq_idf <> n.init_asset_uniq_idf
        or o.info_integy_flg <> n.info_integy_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,cntpty_name -- 交易对手名称
    ,actl_finer_id -- 实际融资人编号
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_strg -- 交易对手实力
    ,cdb_crdt_flg -- 国开行授信标志
    ,cap_src_cd -- 资金来源代码
    ,invest_way_cd -- 投资方式代码
    ,mgmt_mode_cd -- 管理模式代码
    ,tran_asset_name -- 交易资产名称
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,underly_prod_id -- 标的产品编号
    ,underly_prod_name -- 标的产品名称
    ,septbl_flg -- 可分离标志
    ,cota_opt_choice_flg -- 含有回售选择权标志
    ,put_appl_begin_dt -- 回售申请起始日期
    ,put_appl_closing_dt -- 回售申请截止日期
    ,tran_market_type_cd -- 交易市场类型代码
    ,tran_market_name -- 交易市场名称
    ,cash_dt -- 兑付日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,class_crdt_flg -- 类信贷标志
    ,underly_prod_cls_flg -- 标的产品分级标志
    ,underly_prod_cls_lev_cd -- 标的产品分级级别
    ,underly_prod_coll_amt -- 标的产品募集金额
    ,uder_asset_type_cd -- 底层资产类型代码
    ,csner_name -- 委托人名称
    ,csner_id -- 委托人编号
    ,acpt_bank_no -- 承兑行行号
    ,bill_draw_dt -- 票据出票日期
    ,bill_id -- 票据编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_exp_dt -- 票据到期日期
    ,pente_type_cd -- 穿透类型代码
    ,trust_am_cont_name -- 信托资管合同名称
    ,trust_am_cont_type_cd -- 信托资管合同类型代码
    ,guar_type_cd -- 担保类型代码
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,acpt_bank_name -- 承兑行名称
    ,benefc_name -- 受益人名称
    ,benefc_expect_year_net_yld_rat -- 受益人预计年净收益率
    ,benefc_acct_id -- 受益人账户编号
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,other_cond_request_descb -- 其他条件和要求描述
    ,dir_paste_bank_name -- 直贴行名称
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_hxb_cust_id -- 直贴行我行客户编号
    ,hxb_dir_paste_bill_flg -- 我行直贴票据标志
    ,cont_type_cd -- 合同类型代码
    ,rela_trade_cont_id -- 相关贸易合同编号
    ,stl_dep_flg -- 结算性存款标志
    ,coll_cap_acct_id -- 募集资金账户编号
    ,commer_inv_amt -- 商业发票金额
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,surp_indus_cd -- 过剩行业代码
    ,entred_ps_name -- 受托人名称
    ,gover_crdt_flg -- 政府授信标志
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,discount_int_rat -- 转贴现利率
    ,fac_val_amt -- 票面金额
    ,trustee_name -- 托管人名称
    ,bill_cls_cd -- 票据分类代码
    ,bill_type_cd -- 票据类型代码
    ,underly_tenor -- 标的期限
    ,issue_amt -- 发行金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,mger_name -- 管理人名称
    ,dep_rcpt_no_code -- 存单号码
    ,agclt_flg -- 涉农贷款标志
    ,repay_comnt_descb -- 还款说明描述
    ,underly_stock_cd -- 标的股票代码
    ,underly_stock_name -- 标的股票名称
    ,brwer_name -- 借款人名称
    ,use_prod_cd -- 使用产品代码
    ,draw_comnt_descb -- 提款说明描述
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,invest_char_cd -- 投资性质代码
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,tran_bg_descb -- 交易背景描述
    ,ncds_abbr -- 同业存单简称
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,batch_data_src_cd -- 批量数据来源代码
    ,asset_id -- 资产编号
    ,abs_tran_name -- 资产证券化交易名称
    ,bus_type_cd -- 业务类型代码
    ,underly_corp_indus_type -- 标的公司行业类型
    ,drawer_name -- 出票方名称
    ,curr_bond_ext_rating_rest_cd -- 当前债券外部评级结果代码
    ,issue_corp_name -- 发行公司名称
    ,issue_corp_cert_no -- 发行公司证件号码
    ,issue_corp_cert_type_cd -- 发行公司证件类型代码
    ,issue_price -- 发行价格
    ,issue_qtty -- 发行量
    ,issue_bond_ext_rating_cd -- 发行债券外部评级代码
    ,buy_bond_ext_rating_rest_cd -- 购买债券外部评级结果代码
    ,repo_type_cd -- 回购类型代码
    ,cntpty_id -- 交易对手编号
    ,acct_cate_cd -- 账户类别代码
    ,int_set_way_cd -- 结息方式代码
    ,mang_merchd_kind_cd -- 经营商品种类代码
    ,acpt_bank_cust_id -- 承兑行客户编号
    ,trust_am_cont_cap -- 信托资管合同资金
    ,circlt_cap_stock -- 流通股本
    ,fac_val_int_rat -- 票面利率
    ,close_pos_line -- 平仓线
    ,actl_dlvy_dt -- 实际交割日期
    ,bag_net_price -- 成交净价
    ,bag_int_rat -- 成交利率
    ,bag_qtty -- 成交量
    ,warning_line -- 预警线
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,info_integy_flg -- 已完整录入全部底层资产信息标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,cont_id -- 合同编号
    ,cntpty_name -- 交易对手名称
    ,actl_finer_id -- 实际融资人编号
    ,qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,imp_loan_proj_cd -- 重点贷款项目代码
    ,cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,cntpty_co_years -- 与交易对手合作年限
    ,cntpty_strg -- 交易对手实力
    ,cdb_crdt_flg -- 国开行授信标志
    ,cap_src_cd -- 资金来源代码
    ,invest_way_cd -- 投资方式代码
    ,mgmt_mode_cd -- 管理模式代码
    ,tran_asset_name -- 交易资产名称
    ,dir_ind_fund_flg -- 投向产业基金标志
    ,dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,consm_serv_class_fin_flg -- 消费服务类融资标志
    ,underly_prod_id -- 标的产品编号
    ,underly_prod_name -- 标的产品名称
    ,septbl_flg -- 可分离标志
    ,cota_opt_choice_flg -- 含有回售选择权标志
    ,put_appl_begin_dt -- 回售申请起始日期
    ,put_appl_closing_dt -- 回售申请截止日期
    ,tran_market_type_cd -- 交易市场类型代码
    ,tran_market_name -- 交易市场名称
    ,cash_dt -- 兑付日期
    ,incre_crdt_way_cd -- 增信方式代码
    ,class_crdt_flg -- 类信贷标志
    ,underly_prod_cls_flg -- 标的产品分级标志
    ,underly_prod_cls_lev_cd -- 标的产品分级级别
    ,underly_prod_coll_amt -- 标的产品募集金额
    ,uder_asset_type_cd -- 底层资产类型代码
    ,csner_name -- 委托人名称
    ,csner_id -- 委托人编号
    ,acpt_bank_no -- 承兑行行号
    ,bill_draw_dt -- 票据出票日期
    ,bill_id -- 票据编号
    ,bill_curr_cd -- 票据币种代码
    ,bill_exp_dt -- 票据到期日期
    ,pente_type_cd -- 穿透类型代码
    ,trust_am_cont_name -- 信托资管合同名称
    ,trust_am_cont_type_cd -- 信托资管合同类型代码
    ,guar_type_cd -- 担保类型代码
    ,imp_loan_proj_flg -- 重点贷款项目标志
    ,acpt_bank_name -- 承兑行名称
    ,benefc_name -- 受益人名称
    ,benefc_expect_year_net_yld_rat -- 受益人预计年净收益率
    ,benefc_acct_id -- 受益人账户编号
    ,fix_asset_crdt_flg -- 固定资产授信标志
    ,other_cond_request_descb -- 其他条件和要求描述
    ,dir_paste_bank_name -- 直贴行名称
    ,dir_paste_bank_no -- 直贴行行号
    ,dir_paste_hxb_cust_id -- 直贴行我行客户编号
    ,hxb_dir_paste_bill_flg -- 我行直贴票据标志
    ,cont_type_cd -- 合同类型代码
    ,rela_trade_cont_id -- 相关贸易合同编号
    ,stl_dep_flg -- 结算性存款标志
    ,coll_cap_acct_id -- 募集资金账户编号
    ,commer_inv_amt -- 商业发票金额
    ,loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,commer_inv_id -- 商业发票编号
    ,commer_inv_type_cd -- 商业发票类型代码
    ,sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,commer_inv_curr_cd -- 商业发票币种代码
    ,surp_indus_cd -- 过剩行业代码
    ,entred_ps_name -- 受托人名称
    ,gover_crdt_flg -- 政府授信标志
    ,gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,gover_crdt_type_cd -- 政府授信类型代码
    ,discount_int_rat -- 转贴现利率
    ,fac_val_amt -- 票面金额
    ,trustee_name -- 托管人名称
    ,bill_cls_cd -- 票据分类代码
    ,bill_type_cd -- 票据类型代码
    ,underly_tenor -- 标的期限
    ,issue_amt -- 发行金额
    ,cty_lmt_indus_flg -- 国家限制行业标志
    ,trade_cont_tot_amt -- 贸易合同总金额
    ,mger_name -- 管理人名称
    ,dep_rcpt_no_code -- 存单号码
    ,agclt_flg -- 涉农贷款标志
    ,repay_comnt_descb -- 还款说明描述
    ,underly_stock_cd -- 标的股票代码
    ,underly_stock_name -- 标的股票名称
    ,brwer_name -- 借款人名称
    ,use_prod_cd -- 使用产品代码
    ,draw_comnt_descb -- 提款说明描述
    ,bank_int_indus_dir_cd -- 行内行业投向代码
    ,invest_char_cd -- 投资性质代码
    ,cdb_crdt_prod_id -- 国开行授信产品编号
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,tran_bg_descb -- 交易背景描述
    ,ncds_abbr -- 同业存单简称
    ,draw_way_cd -- 提款方式代码
    ,repay_way_cd -- 还款方式代码
    ,batch_data_src_cd -- 批量数据来源代码
    ,asset_id -- 资产编号
    ,abs_tran_name -- 资产证券化交易名称
    ,bus_type_cd -- 业务类型代码
    ,underly_corp_indus_type -- 标的公司行业类型
    ,drawer_name -- 出票方名称
    ,curr_bond_ext_rating_rest_cd -- 当前债券外部评级结果代码
    ,issue_corp_name -- 发行公司名称
    ,issue_corp_cert_no -- 发行公司证件号码
    ,issue_corp_cert_type_cd -- 发行公司证件类型代码
    ,issue_price -- 发行价格
    ,issue_qtty -- 发行量
    ,issue_bond_ext_rating_cd -- 发行债券外部评级代码
    ,buy_bond_ext_rating_rest_cd -- 购买债券外部评级结果代码
    ,repo_type_cd -- 回购类型代码
    ,cntpty_id -- 交易对手编号
    ,acct_cate_cd -- 账户类别代码
    ,int_set_way_cd -- 结息方式代码
    ,mang_merchd_kind_cd -- 经营商品种类代码
    ,acpt_bank_cust_id -- 承兑行客户编号
    ,trust_am_cont_cap -- 信托资管合同资金
    ,circlt_cap_stock -- 流通股本
    ,fac_val_int_rat -- 票面利率
    ,close_pos_line -- 平仓线
    ,actl_dlvy_dt -- 实际交割日期
    ,bag_net_price -- 成交净价
    ,bag_int_rat -- 成交利率
    ,bag_qtty -- 成交量
    ,warning_line -- 预警线
    ,init_asset_uniq_idf -- 原资产唯一标识
    ,info_integy_flg -- 已完整录入全部底层资产信息标志
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
    ,o.cntpty_name -- 交易对手名称
    ,o.actl_finer_id -- 实际融资人编号
    ,o.qual_centr_cntpty_flg -- 合格中央交易对手标志
    ,o.imp_loan_proj_cd -- 重点贷款项目代码
    ,o.cntpty_sucs_tran_cnt -- 与交易对手成功交易次数
    ,o.cntpty_co_years -- 与交易对手合作年限
    ,o.cntpty_strg -- 交易对手实力
    ,o.cdb_crdt_flg -- 国开行授信标志
    ,o.cap_src_cd -- 资金来源代码
    ,o.invest_way_cd -- 投资方式代码
    ,o.mgmt_mode_cd -- 管理模式代码
    ,o.tran_asset_name -- 交易资产名称
    ,o.dir_ind_fund_flg -- 投向产业基金标志
    ,o.dir_makti_debt_eqty_flg -- 投向市场化债转股标志
    ,o.invo_gover_class_fin_flg -- 涉及政府类融资标志
    ,o.consm_serv_class_fin_flg -- 消费服务类融资标志
    ,o.underly_prod_id -- 标的产品编号
    ,o.underly_prod_name -- 标的产品名称
    ,o.septbl_flg -- 可分离标志
    ,o.cota_opt_choice_flg -- 含有回售选择权标志
    ,o.put_appl_begin_dt -- 回售申请起始日期
    ,o.put_appl_closing_dt -- 回售申请截止日期
    ,o.tran_market_type_cd -- 交易市场类型代码
    ,o.tran_market_name -- 交易市场名称
    ,o.cash_dt -- 兑付日期
    ,o.incre_crdt_way_cd -- 增信方式代码
    ,o.class_crdt_flg -- 类信贷标志
    ,o.underly_prod_cls_flg -- 标的产品分级标志
    ,o.underly_prod_cls_lev_cd -- 标的产品分级级别
    ,o.underly_prod_coll_amt -- 标的产品募集金额
    ,o.uder_asset_type_cd -- 底层资产类型代码
    ,o.csner_name -- 委托人名称
    ,o.csner_id -- 委托人编号
    ,o.acpt_bank_no -- 承兑行行号
    ,o.bill_draw_dt -- 票据出票日期
    ,o.bill_id -- 票据编号
    ,o.bill_curr_cd -- 票据币种代码
    ,o.bill_exp_dt -- 票据到期日期
    ,o.pente_type_cd -- 穿透类型代码
    ,o.trust_am_cont_name -- 信托资管合同名称
    ,o.trust_am_cont_type_cd -- 信托资管合同类型代码
    ,o.guar_type_cd -- 担保类型代码
    ,o.imp_loan_proj_flg -- 重点贷款项目标志
    ,o.acpt_bank_name -- 承兑行名称
    ,o.benefc_name -- 受益人名称
    ,o.benefc_expect_year_net_yld_rat -- 受益人预计年净收益率
    ,o.benefc_acct_id -- 受益人账户编号
    ,o.fix_asset_crdt_flg -- 固定资产授信标志
    ,o.other_cond_request_descb -- 其他条件和要求描述
    ,o.dir_paste_bank_name -- 直贴行名称
    ,o.dir_paste_bank_no -- 直贴行行号
    ,o.dir_paste_hxb_cust_id -- 直贴行我行客户编号
    ,o.hxb_dir_paste_bill_flg -- 我行直贴票据标志
    ,o.cont_type_cd -- 合同类型代码
    ,o.rela_trade_cont_id -- 相关贸易合同编号
    ,o.stl_dep_flg -- 结算性存款标志
    ,o.coll_cap_acct_id -- 募集资金账户编号
    ,o.commer_inv_amt -- 商业发票金额
    ,o.loan_fin_supt_way_cd -- 贷款财政扶持方式代码
    ,o.commer_inv_id -- 商业发票编号
    ,o.commer_inv_type_cd -- 商业发票类型代码
    ,o.sup_chain_fin_bus_flg -- 供应链金融业务标志
    ,o.sup_chain_fin_bus_prod_cls_cd -- 供应链金融业务产品分类代码
    ,o.commer_inv_curr_cd -- 商业发票币种代码
    ,o.surp_indus_cd -- 过剩行业代码
    ,o.entred_ps_name -- 受托人名称
    ,o.gover_crdt_flg -- 政府授信标志
    ,o.gover_crdt_supt_way_cd -- 政府授信支持方式代码
    ,o.gover_crdt_type_cd -- 政府授信类型代码
    ,o.discount_int_rat -- 转贴现利率
    ,o.fac_val_amt -- 票面金额
    ,o.trustee_name -- 托管人名称
    ,o.bill_cls_cd -- 票据分类代码
    ,o.bill_type_cd -- 票据类型代码
    ,o.underly_tenor -- 标的期限
    ,o.issue_amt -- 发行金额
    ,o.cty_lmt_indus_flg -- 国家限制行业标志
    ,o.trade_cont_tot_amt -- 贸易合同总金额
    ,o.mger_name -- 管理人名称
    ,o.dep_rcpt_no_code -- 存单号码
    ,o.agclt_flg -- 涉农贷款标志
    ,o.repay_comnt_descb -- 还款说明描述
    ,o.underly_stock_cd -- 标的股票代码
    ,o.underly_stock_name -- 标的股票名称
    ,o.brwer_name -- 借款人名称
    ,o.use_prod_cd -- 使用产品代码
    ,o.draw_comnt_descb -- 提款说明描述
    ,o.bank_int_indus_dir_cd -- 行内行业投向代码
    ,o.invest_char_cd -- 投资性质代码
    ,o.cdb_crdt_prod_id -- 国开行授信产品编号
    ,o.issue_dt -- 发行日期
    ,o.exp_dt -- 到期日期
    ,o.tran_bg_descb -- 交易背景描述
    ,o.ncds_abbr -- 同业存单简称
    ,o.draw_way_cd -- 提款方式代码
    ,o.repay_way_cd -- 还款方式代码
    ,o.batch_data_src_cd -- 批量数据来源代码
    ,o.asset_id -- 资产编号
    ,o.abs_tran_name -- 资产证券化交易名称
    ,o.bus_type_cd -- 业务类型代码
    ,o.underly_corp_indus_type -- 标的公司行业类型
    ,o.drawer_name -- 出票方名称
    ,o.curr_bond_ext_rating_rest_cd -- 当前债券外部评级结果代码
    ,o.issue_corp_name -- 发行公司名称
    ,o.issue_corp_cert_no -- 发行公司证件号码
    ,o.issue_corp_cert_type_cd -- 发行公司证件类型代码
    ,o.issue_price -- 发行价格
    ,o.issue_qtty -- 发行量
    ,o.issue_bond_ext_rating_cd -- 发行债券外部评级代码
    ,o.buy_bond_ext_rating_rest_cd -- 购买债券外部评级结果代码
    ,o.repo_type_cd -- 回购类型代码
    ,o.cntpty_id -- 交易对手编号
    ,o.acct_cate_cd -- 账户类别代码
    ,o.int_set_way_cd -- 结息方式代码
    ,o.mang_merchd_kind_cd -- 经营商品种类代码
    ,o.acpt_bank_cust_id -- 承兑行客户编号
    ,o.trust_am_cont_cap -- 信托资管合同资金
    ,o.circlt_cap_stock -- 流通股本
    ,o.fac_val_int_rat -- 票面利率
    ,o.close_pos_line -- 平仓线
    ,o.actl_dlvy_dt -- 实际交割日期
    ,o.bag_net_price -- 成交净价
    ,o.bag_int_rat -- 成交利率
    ,o.bag_qtty -- 成交量
    ,o.warning_line -- 预警线
    ,o.init_asset_uniq_idf -- 原资产唯一标识
    ,o.info_integy_flg -- 已完整录入全部底层资产信息标志
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
from ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.cont_id = n.cont_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_cl d
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
--truncate table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h;
--alter table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_cont_ibank_ifin_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_cont_ibank_ifin_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
