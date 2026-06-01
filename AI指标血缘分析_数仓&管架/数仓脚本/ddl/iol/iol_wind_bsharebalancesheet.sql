/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_bsharebalancesheet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_bsharebalancesheet
whenever sqlerror continue none;
drop table ${iol_schema}.wind_bsharebalancesheet purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_bsharebalancesheet(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,wind_code varchar2(60) -- Wind代码
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(15) -- 报表类型
    ,crncy_code varchar2(15) -- 货币代码
    ,monetary_cap number(20,4) -- 货币资金
    ,tradable_fin_assets number(20,4) -- 交易性金融资产
    ,notes_rcv number(20,4) -- 应收票据
    ,acct_rcv number(20,4) -- 应收账款
    ,oth_rcv number(20,4) -- 其他应收款
    ,prepay number(20,4) -- 预付款项
    ,dvd_rcv number(20,4) -- 应收股利
    ,int_rcv number(20,4) -- 应收利息
    ,inventories number(20,4) -- 存货
    ,consumptive_bio_assets number(20,4) -- 消耗性生物资产
    ,deferred_exp number(20,4) -- 待摊费用
    ,non_cur_assets_due_within_1y number(20,4) -- 一年内到期的非流动资产
    ,settle_rsrv number(20,4) -- 结算备付金
    ,loans_to_oth_banks number(20,4) -- 拆出资金
    ,prem_rcv number(20,4) -- 应收保费
    ,rcv_from_reinsurer number(20,4) -- 应收分保账款
    ,rcv_from_ceded_insur_cont_rsrv number(20,4) -- 应收分保合同准备金
    ,red_monetary_cap_for_sale number(20,4) -- 买入返售金融资产
    ,oth_cur_assets number(20,4) -- 其他流动资产
    ,tot_cur_assets number(20,4) -- 流动资产合计
    ,fin_assets_avail_for_sale number(20,4) -- 可供出售金融资产
    ,held_to_mty_invest number(20,4) -- 持有至到期投资
    ,long_term_eqy_invest number(20,4) -- 长期股权投资
    ,invest_real_estate number(20,4) -- 投资性房地产
    ,time_deposits number(20,4) -- 定期存款
    ,oth_assets number(20,4) -- 其他资产
    ,long_term_rec number(20,4) -- 长期应收款
    ,fix_assets number(20,4) -- 固定资产
    ,const_in_prog number(20,4) -- 在建工程
    ,proj_matl number(20,4) -- 工程物资
    ,fix_assets_disp number(20,4) -- 固定资产清理
    ,productive_bio_assets number(20,4) -- 生产性生物资产
    ,oil_and_natural_gas_assets number(20,4) -- 油气资产
    ,intang_assets number(20,4) -- 无形资产
    ,r_and_d_costs number(20,4) -- 开发支出
    ,goodwill number(20,4) -- 商誉
    ,long_term_deferred_exp number(20,4) -- 长期待摊费用
    ,deferred_tax_assets number(20,4) -- 递延所得税资产
    ,loans_and_adv_granted number(20,4) -- 发放贷款及垫款
    ,oth_non_cur_assets number(20,4) -- 其他非流动资产
    ,tot_non_cur_assets number(20,4) -- 非流动资产合计
    ,cash_deposits_central_bank number(20,4) -- 现金及存放中央银行款项
    ,asset_dep_oth_banks_fin_inst number(20,4) -- 存放同业和其它金融机构款项
    ,precious_metals number(20,4) -- 贵金属
    ,derivative_fin_assets number(20,4) -- 衍生金融资产
    ,agency_bus_assets number(20,4) -- 代理业务资产
    ,subr_rec number(20,4) -- 应收代位追偿款
    ,rcv_ceded_unearned_prem_rsrv number(20,4) -- 应收分保未到期责任准备金
    ,rcv_ceded_claim_rsrv number(20,4) -- 应收分保未决赔款准备金
    ,rcv_ceded_life_insur_rsrv number(20,4) -- 应收分保寿险责任准备金
    ,rcv_ceded_lt_health_insur_rsrv number(20,4) -- 应收分保长期健康险责任准备金
    ,mrgn_paid number(20,4) -- 存出保证金
    ,insured_pledge_loan number(20,4) -- 保户质押贷款
    ,cap_mrgn_paid number(20,4) -- 存出资本保证金
    ,independent_acct_assets number(20,4) -- 独立账户资产
    ,clients_cap_deposit number(20,4) -- 客户资金存款
    ,clients_rsrv_settle number(20,4) -- 客户备付金
    ,incl_seat_fees_exchange number(20,4) -- 其中:交易席位费
    ,rcv_invest number(20,4) -- 应收款项类投资
    ,tot_assets number(20,4) -- 资产总计
    ,st_borrow number(20,4) -- 短期借款
    ,borrow_central_bank number(20,4) -- 向中央银行借款
    ,deposit_received_ib_deposits number(20,4) -- 吸收存款及同业存放
    ,loans_oth_banks number(20,4) -- 拆入资金
    ,tradable_fin_liab number(20,4) -- 交易性金融负债
    ,notes_payable number(20,4) -- 应付票据
    ,acct_payable number(20,4) -- 应付账款
    ,adv_from_cust number(20,4) -- 预收款项
    ,fund_sales_fin_assets_rp number(20,4) -- 卖出回购金融资产款
    ,handling_charges_comm_payable number(20,4) -- 应付手续费及佣金
    ,empl_ben_payable number(20,4) -- 应付职工薪酬
    ,taxes_surcharges_payable number(20,4) -- 应交税费
    ,int_payable number(20,4) -- 应付利息
    ,dvd_payable number(20,4) -- 应付股利
    ,oth_payable number(20,4) -- 其他应付款
    ,acc_exp number(20,4) -- 预提费用
    ,deferred_inc number(20,4) -- 递延收益
    ,st_bonds_payable number(20,4) -- 应付短期债券
    ,payable_to_reinsurer number(20,4) -- 应付分保账款
    ,rsrv_insur_cont number(20,4) -- 保险合同准备金
    ,acting_trading_sec number(20,4) -- 代理买卖证券款
    ,acting_uw_sec number(20,4) -- 代理承销证券款
    ,non_cur_liab_due_within_1y number(20,4) -- 一年内到期的非流动负债
    ,oth_cur_liab number(20,4) -- 其他流动负债
    ,tot_cur_liab number(20,4) -- 流动负债合计
    ,lt_borrow number(20,4) -- 长期借款
    ,bonds_payable number(20,4) -- 应付债券
    ,lt_payable number(20,4) -- 长期应付款
    ,specific_item_payable number(20,4) -- 专项应付款
    ,provisions number(20,4) -- 预计负债
    ,deferred_tax_liab number(20,4) -- 递延所得税负债
    ,deferred_inc_non_cur_liab number(20,4) -- 递延收益-非流动负债
    ,oth_non_cur_liab number(20,4) -- 其他非流动负债
    ,tot_non_cur_liab number(20,4) -- 非流动负债合计
    ,liab_dep_oth_banks_fin_inst number(20,4) -- 同业和其它金融机构存放款项
    ,derivative_fin_liab number(20,4) -- 衍生金融负债
    ,cust_bank_dep number(20,4) -- 吸收存款
    ,agency_bus_liab number(20,4) -- 代理业务负债
    ,oth_liab number(20,4) -- 其他负债
    ,prem_received_adv number(20,4) -- 预收保费
    ,deposit_received number(20,4) -- 存入保证金
    ,insured_deposit_invest number(20,4) -- 保户储金及投资款
    ,unearned_prem_rsrv number(20,4) -- 未到期责任准备金
    ,out_loss_rsrv number(20,4) -- 未决赔款准备金
    ,life_insur_rsrv number(20,4) -- 寿险责任准备金
    ,lt_health_insur_v number(20,4) -- 长期健康险责任准备金
    ,independent_acct_liab number(20,4) -- 独立账户负债
    ,incl_pledge_loan number(20,4) -- 其中:质押借款
    ,claims_payable number(20,4) -- 应付赔付款
    ,dvd_payable_insured number(20,4) -- 应付保单红利
    ,tot_liab number(20,4) -- 负债合计
    ,cap_stk number(20,4) -- 股本
    ,cap_rsrv number(20,4) -- 资本公积金
    ,special_rsrv number(20,4) -- 专项储备
    ,surplus_rsrv number(20,4) -- 盈余公积金
    ,undistributed_profit number(20,4) -- 未分配利润
    ,less_tsy_stk number(20,4) -- 减:库存股
    ,prov_nom_risks number(20,4) -- 一般风险准备
    ,cnvd_diff_foreign_curr_stat number(20,4) -- 外币报表折算差额
    ,unconfirmed_invest_loss number(20,4) -- 未确认的投资损失
    ,minority_int number(20,4) -- 少数股东权益
    ,tot_shrhldr_eqy_excl_min_int number(20,4) -- 股东权益合计(不含少数股东权益)
    ,tot_shrhldr_eqy_incl_min_int number(20,4) -- 股东权益合计(含少数股东权益)
    ,tot_liab_shrhldr_eqy number(20,4) -- 负债及股东权益总计
    ,comp_type_code varchar2(3) -- 公司类型代码
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_bsharebalancesheet to ${iml_schema};
grant select on ${iol_schema}.wind_bsharebalancesheet to ${icl_schema};
grant select on ${iol_schema}.wind_bsharebalancesheet to ${idl_schema};
grant select on ${iol_schema}.wind_bsharebalancesheet to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_bsharebalancesheet is '中国B股资产负债表';
comment on column ${iol_schema}.wind_bsharebalancesheet.object_id is '对象ID';
comment on column ${iol_schema}.wind_bsharebalancesheet.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_bsharebalancesheet.wind_code is 'Wind代码';
comment on column ${iol_schema}.wind_bsharebalancesheet.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_bsharebalancesheet.report_period is '报告期';
comment on column ${iol_schema}.wind_bsharebalancesheet.statement_type is '报表类型';
comment on column ${iol_schema}.wind_bsharebalancesheet.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_bsharebalancesheet.monetary_cap is '货币资金';
comment on column ${iol_schema}.wind_bsharebalancesheet.tradable_fin_assets is '交易性金融资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.notes_rcv is '应收票据';
comment on column ${iol_schema}.wind_bsharebalancesheet.acct_rcv is '应收账款';
comment on column ${iol_schema}.wind_bsharebalancesheet.oth_rcv is '其他应收款';
comment on column ${iol_schema}.wind_bsharebalancesheet.prepay is '预付款项';
comment on column ${iol_schema}.wind_bsharebalancesheet.dvd_rcv is '应收股利';
comment on column ${iol_schema}.wind_bsharebalancesheet.int_rcv is '应收利息';
comment on column ${iol_schema}.wind_bsharebalancesheet.inventories is '存货';
comment on column ${iol_schema}.wind_bsharebalancesheet.consumptive_bio_assets is '消耗性生物资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.deferred_exp is '待摊费用';
comment on column ${iol_schema}.wind_bsharebalancesheet.non_cur_assets_due_within_1y is '一年内到期的非流动资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.settle_rsrv is '结算备付金';
comment on column ${iol_schema}.wind_bsharebalancesheet.loans_to_oth_banks is '拆出资金';
comment on column ${iol_schema}.wind_bsharebalancesheet.prem_rcv is '应收保费';
comment on column ${iol_schema}.wind_bsharebalancesheet.rcv_from_reinsurer is '应收分保账款';
comment on column ${iol_schema}.wind_bsharebalancesheet.rcv_from_ceded_insur_cont_rsrv is '应收分保合同准备金';
comment on column ${iol_schema}.wind_bsharebalancesheet.red_monetary_cap_for_sale is '买入返售金融资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.oth_cur_assets is '其他流动资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.tot_cur_assets is '流动资产合计';
comment on column ${iol_schema}.wind_bsharebalancesheet.fin_assets_avail_for_sale is '可供出售金融资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.held_to_mty_invest is '持有至到期投资';
comment on column ${iol_schema}.wind_bsharebalancesheet.long_term_eqy_invest is '长期股权投资';
comment on column ${iol_schema}.wind_bsharebalancesheet.invest_real_estate is '投资性房地产';
comment on column ${iol_schema}.wind_bsharebalancesheet.time_deposits is '定期存款';
comment on column ${iol_schema}.wind_bsharebalancesheet.oth_assets is '其他资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.long_term_rec is '长期应收款';
comment on column ${iol_schema}.wind_bsharebalancesheet.fix_assets is '固定资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.const_in_prog is '在建工程';
comment on column ${iol_schema}.wind_bsharebalancesheet.proj_matl is '工程物资';
comment on column ${iol_schema}.wind_bsharebalancesheet.fix_assets_disp is '固定资产清理';
comment on column ${iol_schema}.wind_bsharebalancesheet.productive_bio_assets is '生产性生物资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.oil_and_natural_gas_assets is '油气资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.intang_assets is '无形资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.r_and_d_costs is '开发支出';
comment on column ${iol_schema}.wind_bsharebalancesheet.goodwill is '商誉';
comment on column ${iol_schema}.wind_bsharebalancesheet.long_term_deferred_exp is '长期待摊费用';
comment on column ${iol_schema}.wind_bsharebalancesheet.deferred_tax_assets is '递延所得税资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.loans_and_adv_granted is '发放贷款及垫款';
comment on column ${iol_schema}.wind_bsharebalancesheet.oth_non_cur_assets is '其他非流动资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.tot_non_cur_assets is '非流动资产合计';
comment on column ${iol_schema}.wind_bsharebalancesheet.cash_deposits_central_bank is '现金及存放中央银行款项';
comment on column ${iol_schema}.wind_bsharebalancesheet.asset_dep_oth_banks_fin_inst is '存放同业和其它金融机构款项';
comment on column ${iol_schema}.wind_bsharebalancesheet.precious_metals is '贵金属';
comment on column ${iol_schema}.wind_bsharebalancesheet.derivative_fin_assets is '衍生金融资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.agency_bus_assets is '代理业务资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.subr_rec is '应收代位追偿款';
comment on column ${iol_schema}.wind_bsharebalancesheet.rcv_ceded_unearned_prem_rsrv is '应收分保未到期责任准备金';
comment on column ${iol_schema}.wind_bsharebalancesheet.rcv_ceded_claim_rsrv is '应收分保未决赔款准备金';
comment on column ${iol_schema}.wind_bsharebalancesheet.rcv_ceded_life_insur_rsrv is '应收分保寿险责任准备金';
comment on column ${iol_schema}.wind_bsharebalancesheet.rcv_ceded_lt_health_insur_rsrv is '应收分保长期健康险责任准备金';
comment on column ${iol_schema}.wind_bsharebalancesheet.mrgn_paid is '存出保证金';
comment on column ${iol_schema}.wind_bsharebalancesheet.insured_pledge_loan is '保户质押贷款';
comment on column ${iol_schema}.wind_bsharebalancesheet.cap_mrgn_paid is '存出资本保证金';
comment on column ${iol_schema}.wind_bsharebalancesheet.independent_acct_assets is '独立账户资产';
comment on column ${iol_schema}.wind_bsharebalancesheet.clients_cap_deposit is '客户资金存款';
comment on column ${iol_schema}.wind_bsharebalancesheet.clients_rsrv_settle is '客户备付金';
comment on column ${iol_schema}.wind_bsharebalancesheet.incl_seat_fees_exchange is '其中:交易席位费';
comment on column ${iol_schema}.wind_bsharebalancesheet.rcv_invest is '应收款项类投资';
comment on column ${iol_schema}.wind_bsharebalancesheet.tot_assets is '资产总计';
comment on column ${iol_schema}.wind_bsharebalancesheet.st_borrow is '短期借款';
comment on column ${iol_schema}.wind_bsharebalancesheet.borrow_central_bank is '向中央银行借款';
comment on column ${iol_schema}.wind_bsharebalancesheet.deposit_received_ib_deposits is '吸收存款及同业存放';
comment on column ${iol_schema}.wind_bsharebalancesheet.loans_oth_banks is '拆入资金';
comment on column ${iol_schema}.wind_bsharebalancesheet.tradable_fin_liab is '交易性金融负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.notes_payable is '应付票据';
comment on column ${iol_schema}.wind_bsharebalancesheet.acct_payable is '应付账款';
comment on column ${iol_schema}.wind_bsharebalancesheet.adv_from_cust is '预收款项';
comment on column ${iol_schema}.wind_bsharebalancesheet.fund_sales_fin_assets_rp is '卖出回购金融资产款';
comment on column ${iol_schema}.wind_bsharebalancesheet.handling_charges_comm_payable is '应付手续费及佣金';
comment on column ${iol_schema}.wind_bsharebalancesheet.empl_ben_payable is '应付职工薪酬';
comment on column ${iol_schema}.wind_bsharebalancesheet.taxes_surcharges_payable is '应交税费';
comment on column ${iol_schema}.wind_bsharebalancesheet.int_payable is '应付利息';
comment on column ${iol_schema}.wind_bsharebalancesheet.dvd_payable is '应付股利';
comment on column ${iol_schema}.wind_bsharebalancesheet.oth_payable is '其他应付款';
comment on column ${iol_schema}.wind_bsharebalancesheet.acc_exp is '预提费用';
comment on column ${iol_schema}.wind_bsharebalancesheet.deferred_inc is '递延收益';
comment on column ${iol_schema}.wind_bsharebalancesheet.st_bonds_payable is '应付短期债券';
comment on column ${iol_schema}.wind_bsharebalancesheet.payable_to_reinsurer is '应付分保账款';
comment on column ${iol_schema}.wind_bsharebalancesheet.rsrv_insur_cont is '保险合同准备金';
comment on column ${iol_schema}.wind_bsharebalancesheet.acting_trading_sec is '代理买卖证券款';
comment on column ${iol_schema}.wind_bsharebalancesheet.acting_uw_sec is '代理承销证券款';
comment on column ${iol_schema}.wind_bsharebalancesheet.non_cur_liab_due_within_1y is '一年内到期的非流动负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.oth_cur_liab is '其他流动负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.tot_cur_liab is '流动负债合计';
comment on column ${iol_schema}.wind_bsharebalancesheet.lt_borrow is '长期借款';
comment on column ${iol_schema}.wind_bsharebalancesheet.bonds_payable is '应付债券';
comment on column ${iol_schema}.wind_bsharebalancesheet.lt_payable is '长期应付款';
comment on column ${iol_schema}.wind_bsharebalancesheet.specific_item_payable is '专项应付款';
comment on column ${iol_schema}.wind_bsharebalancesheet.provisions is '预计负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.deferred_tax_liab is '递延所得税负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.deferred_inc_non_cur_liab is '递延收益-非流动负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.oth_non_cur_liab is '其他非流动负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.tot_non_cur_liab is '非流动负债合计';
comment on column ${iol_schema}.wind_bsharebalancesheet.liab_dep_oth_banks_fin_inst is '同业和其它金融机构存放款项';
comment on column ${iol_schema}.wind_bsharebalancesheet.derivative_fin_liab is '衍生金融负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.cust_bank_dep is '吸收存款';
comment on column ${iol_schema}.wind_bsharebalancesheet.agency_bus_liab is '代理业务负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.oth_liab is '其他负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.prem_received_adv is '预收保费';
comment on column ${iol_schema}.wind_bsharebalancesheet.deposit_received is '存入保证金';
comment on column ${iol_schema}.wind_bsharebalancesheet.insured_deposit_invest is '保户储金及投资款';
comment on column ${iol_schema}.wind_bsharebalancesheet.unearned_prem_rsrv is '未到期责任准备金';
comment on column ${iol_schema}.wind_bsharebalancesheet.out_loss_rsrv is '未决赔款准备金';
comment on column ${iol_schema}.wind_bsharebalancesheet.life_insur_rsrv is '寿险责任准备金';
comment on column ${iol_schema}.wind_bsharebalancesheet.lt_health_insur_v is '长期健康险责任准备金';
comment on column ${iol_schema}.wind_bsharebalancesheet.independent_acct_liab is '独立账户负债';
comment on column ${iol_schema}.wind_bsharebalancesheet.incl_pledge_loan is '其中:质押借款';
comment on column ${iol_schema}.wind_bsharebalancesheet.claims_payable is '应付赔付款';
comment on column ${iol_schema}.wind_bsharebalancesheet.dvd_payable_insured is '应付保单红利';
comment on column ${iol_schema}.wind_bsharebalancesheet.tot_liab is '负债合计';
comment on column ${iol_schema}.wind_bsharebalancesheet.cap_stk is '股本';
comment on column ${iol_schema}.wind_bsharebalancesheet.cap_rsrv is '资本公积金';
comment on column ${iol_schema}.wind_bsharebalancesheet.special_rsrv is '专项储备';
comment on column ${iol_schema}.wind_bsharebalancesheet.surplus_rsrv is '盈余公积金';
comment on column ${iol_schema}.wind_bsharebalancesheet.undistributed_profit is '未分配利润';
comment on column ${iol_schema}.wind_bsharebalancesheet.less_tsy_stk is '减:库存股';
comment on column ${iol_schema}.wind_bsharebalancesheet.prov_nom_risks is '一般风险准备';
comment on column ${iol_schema}.wind_bsharebalancesheet.cnvd_diff_foreign_curr_stat is '外币报表折算差额';
comment on column ${iol_schema}.wind_bsharebalancesheet.unconfirmed_invest_loss is '未确认的投资损失';
comment on column ${iol_schema}.wind_bsharebalancesheet.minority_int is '少数股东权益';
comment on column ${iol_schema}.wind_bsharebalancesheet.tot_shrhldr_eqy_excl_min_int is '股东权益合计(不含少数股东权益)';
comment on column ${iol_schema}.wind_bsharebalancesheet.tot_shrhldr_eqy_incl_min_int is '股东权益合计(含少数股东权益)';
comment on column ${iol_schema}.wind_bsharebalancesheet.tot_liab_shrhldr_eqy is '负债及股东权益总计';
comment on column ${iol_schema}.wind_bsharebalancesheet.comp_type_code is '公司类型代码';
comment on column ${iol_schema}.wind_bsharebalancesheet.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_bsharebalancesheet.etl_timestamp is 'ETL处理时间戳';
