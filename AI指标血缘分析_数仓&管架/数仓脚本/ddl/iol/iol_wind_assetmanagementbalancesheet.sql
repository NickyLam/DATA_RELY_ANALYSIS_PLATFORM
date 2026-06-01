/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_assetmanagementbalancesheet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_assetmanagementbalancesheet
whenever sqlerror continue none;
drop table ${iol_schema}.wind_assetmanagementbalancesheet purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_assetmanagementbalancesheet(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(15) -- 报表类型代码
    ,crncy_code varchar2(15) -- 货币代码
    ,actual_ann_dt varchar2(12) -- 实际公告日期
    ,monetary_cap number(20,4) -- 货币资金
    ,clients_cap_deposit number(20,4) -- 客户资金存款
    ,settle_rsrv number(20,4) -- 结算备付金
    ,clients_rsrv_settle number(20,4) -- 客户备付金
    ,loans_to_oth_banks number(20,4) -- 拆出资金
    ,tradable_fin_assets number(20,4) -- 交易性金融资产
    ,derivative_fin_assets number(20,4) -- 衍生金融资产
    ,red_monetary_cap_for_sale number(20,4) -- 买入返售金融资产
    ,int_rcv number(20,4) -- 应收利息
    ,mrgn_paid number(20,4) -- 存出保证金
    ,agency_bus_assets number(20,4) -- 代理业务资产
    ,fin_assets_avail_for_sale number(20,4) -- 可供出售金融资产
    ,held_to_mty_invest number(20,4) -- 持有至到期投资
    ,long_term_eqy_invest number(20,4) -- 长期股权投资
    ,fix_assets number(20,4) -- 固定资产
    ,intang_assets number(20,4) -- 无形资产
    ,incl_seat_fees_exchange number(20,4) -- 其中：交易席位费
    ,goodwill number(20,4) -- 商誉
    ,deferred_tax_assets number(20,4) -- 递延所得税资产
    ,invest_real_estate number(20,4) -- 投资性房地产
    ,oth_assets number(20,4) -- 其他资产
    ,spe_bal_assets number(20,4) -- 资产差额(特殊报表科目)
    ,tot_bal_assets number(20,4) -- 资产差额(合计平衡项目)
    ,tot_assets number(20,4) -- 资产总计
    ,st_borrow number(20,4) -- 短期借款
    ,incl_pledge_loan number(20,4) -- 其中：质押借款
    ,loans_oth_banks number(20,4) -- 拆入资金
    ,tradable_fin_liab number(20,4) -- 交易性金融负债
    ,derivative_fin_liab number(20,4) -- 衍生金融负债
    ,fund_sales_fin_assets_rp number(20,4) -- 卖出回购金融资产款
    ,acting_trading_sec number(20,4) -- 代理买卖证券款
    ,acting_uw_sec number(20,4) -- 代理承销证券款
    ,empl_ben_payable number(20,4) -- 应付职工薪酬
    ,taxes_surcharges_payable number(20,4) -- 应交税费
    ,int_payable number(20,4) -- 应付利息
    ,agency_bus_liab number(20,4) -- 代理业务负债
    ,lt_borrow number(20,4) -- 长期借款
    ,bonds_payable number(20,4) -- 应付债券
    ,deferred_tax_liab number(20,4) -- 延所得税负债
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
    ,other_comp_income number(20,4) -- 其他综合收益
    ,other_equity_tools number(20,4) -- 其他权益工具
    ,other_equity_tools_p_shr number(20,4) -- 其他权益工具:优先股
    ,melt_money number(20,4) -- 融出资金
    ,receivables number(20,4) -- 应收款项
    ,short_term_financing number(20,4) -- 应付短期融资款
    ,payables number(20,4) -- 应付款项
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
grant select on ${iol_schema}.wind_assetmanagementbalancesheet to ${iml_schema};
grant select on ${iol_schema}.wind_assetmanagementbalancesheet to ${icl_schema};
grant select on ${iol_schema}.wind_assetmanagementbalancesheet to ${idl_schema};
grant select on ${iol_schema}.wind_assetmanagementbalancesheet to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_assetmanagementbalancesheet is '非上市资产管理公司资产负债表';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.object_id is '对象ID';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.report_period is '报告期';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.actual_ann_dt is '实际公告日期';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.monetary_cap is '货币资金';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.clients_cap_deposit is '客户资金存款';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.settle_rsrv is '结算备付金';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.clients_rsrv_settle is '客户备付金';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.loans_to_oth_banks is '拆出资金';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tradable_fin_assets is '交易性金融资产';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.derivative_fin_assets is '衍生金融资产';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.red_monetary_cap_for_sale is '买入返售金融资产';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.int_rcv is '应收利息';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.mrgn_paid is '存出保证金';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.agency_bus_assets is '代理业务资产';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.fin_assets_avail_for_sale is '可供出售金融资产';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.held_to_mty_invest is '持有至到期投资';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.long_term_eqy_invest is '长期股权投资';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.fix_assets is '固定资产';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.intang_assets is '无形资产';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.incl_seat_fees_exchange is '其中：交易席位费';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.goodwill is '商誉';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.deferred_tax_assets is '递延所得税资产';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.invest_real_estate is '投资性房地产';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.oth_assets is '其他资产';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.spe_bal_assets is '资产差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tot_bal_assets is '资产差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tot_assets is '资产总计';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.st_borrow is '短期借款';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.incl_pledge_loan is '其中：质押借款';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.loans_oth_banks is '拆入资金';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tradable_fin_liab is '交易性金融负债';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.derivative_fin_liab is '衍生金融负债';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.fund_sales_fin_assets_rp is '卖出回购金融资产款';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.acting_trading_sec is '代理买卖证券款';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.acting_uw_sec is '代理承销证券款';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.empl_ben_payable is '应付职工薪酬';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.taxes_surcharges_payable is '应交税费';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.int_payable is '应付利息';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.agency_bus_liab is '代理业务负债';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.lt_borrow is '长期借款';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.bonds_payable is '应付债券';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.deferred_tax_liab is '延所得税负债';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.provisions is '预计负债';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.oth_liab is '其他负债';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.spe_bal_liab is '负债差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tot_bal_liab is '负债差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tot_liab is '负债合计';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.cap_stk is '股本';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.cap_rsrv is '资本公积金';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.less_tsy_stk is '减：库存股';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.surplus_rsrv is '盈余公积金';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.undistributed_profit is '未分配利润';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.prov_nom_risks is '一般风险准备';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.cnvd_diff_foreign_curr_stat is '外币报表折算差额';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.unconfirmed_invest_loss is '未确认的投资损失';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.spe_bal_shrhldr_eqy is '股东权益差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tot_bal_shrhldr_eqy is '股东权益差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.minority_int is '少数股东权益';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tot_shrhldr_eqy_excl_min_int is '股东权益合计(不含少数股东权益)';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tot_shrhldr_eqy_incl_min_int is '股东权益合计(含少数股东权益)';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.spe_bal_liab_eqy is '负债及股东权益差额(特殊报表项目)';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tot_bal_liab_eqy is '负债及股东权益差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.tot_liab_shrhldr_eqy is '负债及股东权益总计';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.other_comp_income is '其他综合收益';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.other_equity_tools is '其他权益工具';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.other_equity_tools_p_shr is '其他权益工具:优先股';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.melt_money is '融出资金';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.receivables is '应收款项';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.short_term_financing is '应付短期融资款';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.payables is '应付款项';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_assetmanagementbalancesheet.etl_timestamp is 'ETL处理时间戳';
