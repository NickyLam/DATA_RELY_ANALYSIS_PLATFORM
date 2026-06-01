/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_unlistedinsurancebalancesheet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_unlistedinsurancebalancesheet
whenever sqlerror continue none;
drop table ${iol_schema}.wind_unlistedinsurancebalancesheet purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_unlistedinsurancebalancesheet(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type number(9,0) -- 报表类型代码
    ,crncy_code varchar2(15) -- 货币代码
    ,actual_ann_dt varchar2(12) -- 实际公告日期
    ,monetary_cap number(20,4) -- 货币资金
    ,loans_to_oth_banks number(20,4) -- 拆出资金
    ,tradable_fin_assets number(20,4) -- 交易性金融资产
    ,derivative_fin_assets number(20,4) -- 衍生金融资产
    ,red_monetary_cap_for_sale number(20,4) -- 买入返售金融资产
    ,prem_rcv number(20,4) -- 应收保费
    ,int_rcv number(20,4) -- 应收利息
    ,subr_rec number(20,4) -- 应收代位追偿款
    ,payable_to_reinsurer number(20,4) -- 应付分保账款
    ,rcv_ceded_unearned_prem_rsrv number(20,4) -- 应收分保未到期责任准备金
    ,rcv_ceded_claim_rsrv number(20,4) -- 应收分保未决赔款准备金
    ,rcv_ceded_life_insur_rsrv number(20,4) -- 应收分保寿险责任准备金
    ,rcv_ceded_lt_health_insur_rsrv number(20,4) -- 应收分保长期健康险责任准备金
    ,insured_pledge_loan number(20,4) -- 保户质押贷款
    ,fin_assets_avail_for_sale number(20,4) -- 可供出售金融资产
    ,held_to_mty_invest number(20,4) -- 持有至到期投资
    ,long_term_eqy_invest number(20,4) -- 长期股权投资
    ,cap_mrgn_paid number(20,4) -- 存出资本保证金
    ,rcv_invest number(20,4) -- 应收款项类投资
    ,fix_assets number(20,4) -- 固定资产
    ,intang_assets number(20,4) -- 无形资产
    ,goodwill number(20,4) -- 商誉
    ,independent_acct_assets number(20,4) -- 独立账户资产
    ,deferred_tax_liab number(20,4) -- 递延所得税负债
    ,invest_real_estate number(20,4) -- 投资性房地产
    ,time_deposits number(20,4) -- 定期存款
    ,oth_assets number(20,4) -- 其他资产
    ,spe_bal_assets number(20,4) -- 资产差额(特殊报表科目)
    ,tot_bal_assets number(20,4) -- 资产差额(合计平衡项目)
    ,tot_assets number(20,4) -- 资产总计
    ,st_borrow number(20,4) -- 短期借款
    ,loans_oth_banks number(20,4) -- 拆入资金
    ,tradable_fin_liab number(20,4) -- 交易性金融负债
    ,fund_sales_fin_assets_rp number(20,4) -- 卖出回购金融资产款
    ,prem_received_adv number(20,4) -- 预收保费
    ,handling_charges_comm_payable number(20,4) -- 应付手续费及佣金
    ,empl_ben_payable number(20,4) -- 应付职工薪酬
    ,taxes_surcharges_payable number(20,4) -- 应交税费
    ,int_payable number(20,4) -- 应付利息
    ,claims_payable number(20,4) -- 应付赔付款
    ,dvd_payable_insured number(20,4) -- 应付保单红利
    ,deposit_received number(20,4) -- 存入保证金
    ,insured_deposit_invest number(20,4) -- 保户储金及投资款
    ,unearned_prem_rsrv number(20,4) -- 未到期责任准备金
    ,out_loss_rsrv number(20,4) -- 未决赔款准备金
    ,life_insur_rsrv number(20,4) -- 寿险责任准备金
    ,lt_health_insur_v number(20,4) -- 长期健康险责任准备金
    ,lt_borrow number(20,4) -- 长期借款
    ,bonds_payable number(20,4) -- 应付债券
    ,independent_acct_liab number(20,4) -- 独立账户负债
    ,deferred_tax_assets number(20,4) -- 递延所得税资产
    ,provisions number(20,4) -- 预计负债
    ,oth_liab number(20,4) -- 其他负债
    ,spe_bal_liab number(20,4) -- 负债差额(特殊报表科目)
    ,tot_bal_liab number(20,4) -- 负债差额(合计平衡项目)
    ,tot_liab number(20,4) -- 负债合计
    ,cap_stk number(20,4) -- 股本
    ,cap_rsrv number(20,4) -- 资本公积金
    ,less_tsy_stk number(20,4) -- 减：库存股
    ,surplus_rsrv number(20,4) -- 盈余公积金
    ,undistributed_profit number(20,4) -- 未分配利润
    ,prov_nom_risks number(20,4) -- 一般风险准备
    ,cnvd_diff_foreign_curr_stat number(20,4) -- 外币报表折算差额
    ,unconfirmed_invest_loss number(20,4) -- 未确认的投资损失
    ,spe_bal_shrhldr_eqy number(20,4) -- 股东权益差额(特殊报表科目)
    ,tot_bal_shrhldr_eqy number(20,4) -- 股东权益差额(合计平衡项目)
    ,minority_int number(20,4) -- 少数股东权益
    ,tot_shrhldr_eqy_excl_min_int number(20,4) -- 股东权益合计(不含少数股东权益)
    ,tot_shrhldr_eqy_incl_min_int number(20,4) -- 股东权益合计(含少数股东权益)
    ,spe_bal_liab_eqy number(20,4) -- 负债及股东权益差额(特殊报表项目)
    ,tot_bal_liab_eqy number(20,4) -- 负债及股东权益差额(合计平衡项目)
    ,tot_liab_shrhldr_eqy number(20,4) -- 负债及股东权益总计
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
grant select on ${iol_schema}.wind_unlistedinsurancebalancesheet to ${iml_schema};
grant select on ${iol_schema}.wind_unlistedinsurancebalancesheet to ${icl_schema};
grant select on ${iol_schema}.wind_unlistedinsurancebalancesheet to ${idl_schema};
grant select on ${iol_schema}.wind_unlistedinsurancebalancesheet to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_unlistedinsurancebalancesheet is '非上市保险资产负债表';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.object_id is '对象ID';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.report_period is '报告期';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.actual_ann_dt is '实际公告日期';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.monetary_cap is '货币资金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.loans_to_oth_banks is '拆出资金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tradable_fin_assets is '交易性金融资产';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.derivative_fin_assets is '衍生金融资产';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.red_monetary_cap_for_sale is '买入返售金融资产';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.prem_rcv is '应收保费';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.int_rcv is '应收利息';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.subr_rec is '应收代位追偿款';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.payable_to_reinsurer is '应付分保账款';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.rcv_ceded_unearned_prem_rsrv is '应收分保未到期责任准备金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.rcv_ceded_claim_rsrv is '应收分保未决赔款准备金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.rcv_ceded_life_insur_rsrv is '应收分保寿险责任准备金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.rcv_ceded_lt_health_insur_rsrv is '应收分保长期健康险责任准备金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.insured_pledge_loan is '保户质押贷款';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.fin_assets_avail_for_sale is '可供出售金融资产';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.held_to_mty_invest is '持有至到期投资';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.long_term_eqy_invest is '长期股权投资';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.cap_mrgn_paid is '存出资本保证金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.rcv_invest is '应收款项类投资';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.fix_assets is '固定资产';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.intang_assets is '无形资产';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.goodwill is '商誉';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.independent_acct_assets is '独立账户资产';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.deferred_tax_liab is '递延所得税负债';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.invest_real_estate is '投资性房地产';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.time_deposits is '定期存款';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.oth_assets is '其他资产';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.spe_bal_assets is '资产差额(特殊报表科目)';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tot_bal_assets is '资产差额(合计平衡项目)';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tot_assets is '资产总计';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.st_borrow is '短期借款';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.loans_oth_banks is '拆入资金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tradable_fin_liab is '交易性金融负债';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.fund_sales_fin_assets_rp is '卖出回购金融资产款';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.prem_received_adv is '预收保费';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.handling_charges_comm_payable is '应付手续费及佣金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.empl_ben_payable is '应付职工薪酬';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.taxes_surcharges_payable is '应交税费';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.int_payable is '应付利息';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.claims_payable is '应付赔付款';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.dvd_payable_insured is '应付保单红利';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.deposit_received is '存入保证金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.insured_deposit_invest is '保户储金及投资款';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.unearned_prem_rsrv is '未到期责任准备金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.out_loss_rsrv is '未决赔款准备金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.life_insur_rsrv is '寿险责任准备金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.lt_health_insur_v is '长期健康险责任准备金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.lt_borrow is '长期借款';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.bonds_payable is '应付债券';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.independent_acct_liab is '独立账户负债';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.deferred_tax_assets is '递延所得税资产';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.provisions is '预计负债';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.oth_liab is '其他负债';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.spe_bal_liab is '负债差额(特殊报表科目)';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tot_bal_liab is '负债差额(合计平衡项目)';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tot_liab is '负债合计';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.cap_stk is '股本';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.cap_rsrv is '资本公积金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.less_tsy_stk is '减：库存股';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.surplus_rsrv is '盈余公积金';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.undistributed_profit is '未分配利润';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.prov_nom_risks is '一般风险准备';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.cnvd_diff_foreign_curr_stat is '外币报表折算差额';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.unconfirmed_invest_loss is '未确认的投资损失';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.spe_bal_shrhldr_eqy is '股东权益差额(特殊报表科目)';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tot_bal_shrhldr_eqy is '股东权益差额(合计平衡项目)';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.minority_int is '少数股东权益';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tot_shrhldr_eqy_excl_min_int is '股东权益合计(不含少数股东权益)';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tot_shrhldr_eqy_incl_min_int is '股东权益合计(含少数股东权益)';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.spe_bal_liab_eqy is '负债及股东权益差额(特殊报表项目)';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tot_bal_liab_eqy is '负债及股东权益差额(合计平衡项目)';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.tot_liab_shrhldr_eqy is '负债及股东权益总计';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_unlistedinsurancebalancesheet.etl_timestamp is 'ETL处理时间戳';
