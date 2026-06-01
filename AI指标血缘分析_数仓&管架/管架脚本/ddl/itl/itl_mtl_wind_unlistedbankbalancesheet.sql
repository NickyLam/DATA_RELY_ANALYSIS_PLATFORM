/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_wind_unlistedbankbalancesheet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_wind_unlistedbankbalancesheet
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_wind_unlistedbankbalancesheet purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_wind_unlistedbankbalancesheet(
    etl_dt date -- ETL处理日期
    ,object_id varchar2(100) -- 对象ID
    ,s_info_compcode varchar2(40) -- 公司ID
    ,ann_dt varchar2(8) -- 公告日期
    ,report_period varchar2(8) -- 报告期
    ,statement_type varchar2(10) -- 报表类型
    ,crncy_code varchar2(10) -- 货币代码
    ,actual_ann_dt varchar2(8) -- 实际公告日期
    ,cash_deposits_central_bank number(20,4) -- 现金及存放中央银行款项
    ,asset_dep_oth_banks_fin_inst number(20,4) -- 存放同业和其它金融机构款项
    ,precious_metals number(20,4) -- 贵金属
    ,loans_to_oth_banks number(20,4) -- 拆出资金
    ,tradable_fin_assets number(20,4) -- 交易性金融资产
    ,derivative_fin_assets number(20,4) -- 衍生金融资产
    ,red_monetary_cap_for_sale number(20,4) -- 买入返售金融资产
    ,int_rcv number(20,4) -- 应收利息
    ,loans_and_adv_granted number(20,4) -- 发放贷款及垫款
    ,agency_bus_assets number(20,4) -- 代理业务资产
    ,fin_assets_avail_for_sale number(20,4) -- 可供出售金融资产
    ,held_to_mty_invest number(20,4) -- 持有至到期投资
    ,long_term_eqy_invest number(20,4) -- 长期股权投资
    ,rcv_invest number(20,4) -- 应收款项类投资
    ,fix_assets number(20,4) -- 固定资产
    ,intang_assets number(20,4) -- 无形资产
    ,goodwill number(20,4) -- 商誉
    ,deferred_tax_assets number(20,4) -- 递延所得税资产
    ,invest_real_estate number(20,4) -- 投资性房地产
    ,oth_assets number(20,4) -- 其他资产
    ,spe_bal_assets number(20,4) -- 资产差额(特殊报表科目)
    ,tot_bal_assets number(20,4) -- 资产差额(合计平衡项目)
    ,tot_assets number(20,4) -- 资产总计
    ,liab_dep_oth_banks_fin_inst number(20,4) -- 同业和其它金融机构存放款项
    ,borrow_central_bank number(20,4) -- 向中央银行借款
    ,loans_oth_banks number(20,4) -- 拆入资金
    ,tradable_fin_liab number(20,4) -- 交易性金融负债
    ,derivative_fin_liab number(20,4) -- 衍生金融负债
    ,fund_sales_fin_assets_rp number(20,4) -- 卖出回购金融资产款
    ,cust_bank_dep number(20,4) -- 吸收存款
    ,empl_ben_payable number(20,4) -- 应付职工薪酬
    ,taxes_surcharges_payable number(20,4) -- 应交税费
    ,int_payable number(20,4) -- 应付利息
    ,agency_bus_liab number(20,4) -- 代理业务负债
    ,bonds_payable number(20,4) -- 应付债券
    ,deferred_tax_liab number(20,4) -- 递延所得税负债
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
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.mtl_wind_unlistedbankbalancesheet to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_wind_unlistedbankbalancesheet is '非上市银行资产负债表';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.object_id is '对象ID';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.s_info_compcode is '公司ID';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.ann_dt is '公告日期';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.report_period is '报告期';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.statement_type is '报表类型';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.crncy_code is '货币代码';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.actual_ann_dt is '实际公告日期';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.cash_deposits_central_bank is '现金及存放中央银行款项';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.asset_dep_oth_banks_fin_inst is '存放同业和其它金融机构款项';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.precious_metals is '贵金属';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.loans_to_oth_banks is '拆出资金';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tradable_fin_assets is '交易性金融资产';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.derivative_fin_assets is '衍生金融资产';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.red_monetary_cap_for_sale is '买入返售金融资产';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.int_rcv is '应收利息';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.loans_and_adv_granted is '发放贷款及垫款';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.agency_bus_assets is '代理业务资产';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.fin_assets_avail_for_sale is '可供出售金融资产';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.held_to_mty_invest is '持有至到期投资';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.long_term_eqy_invest is '长期股权投资';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.rcv_invest is '应收款项类投资';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.fix_assets is '固定资产';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.intang_assets is '无形资产';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.goodwill is '商誉';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.deferred_tax_assets is '递延所得税资产';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.invest_real_estate is '投资性房地产';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.oth_assets is '其他资产';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.spe_bal_assets is '资产差额(特殊报表科目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tot_bal_assets is '资产差额(合计平衡项目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tot_assets is '资产总计';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.liab_dep_oth_banks_fin_inst is '同业和其它金融机构存放款项';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.borrow_central_bank is '向中央银行借款';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.loans_oth_banks is '拆入资金';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tradable_fin_liab is '交易性金融负债';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.derivative_fin_liab is '衍生金融负债';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.fund_sales_fin_assets_rp is '卖出回购金融资产款';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.cust_bank_dep is '吸收存款';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.empl_ben_payable is '应付职工薪酬';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.taxes_surcharges_payable is '应交税费';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.int_payable is '应付利息';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.agency_bus_liab is '代理业务负债';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.bonds_payable is '应付债券';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.deferred_tax_liab is '递延所得税负债';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.provisions is '预计负债';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.oth_liab is '其他负债';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.spe_bal_liab is '负债差额(特殊报表科目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tot_bal_liab is '负债差额(合计平衡项目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tot_liab is '负债合计';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.cap_stk is '股本';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.cap_rsrv is '资本公积金';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.less_tsy_stk is '减：库存股';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.surplus_rsrv is '盈余公积金';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.undistributed_profit is '未分配利润';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.prov_nom_risks is '一般风险准备';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.cnvd_diff_foreign_curr_stat is '外币报表折算差额';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.unconfirmed_invest_loss is '未确认的投资损失';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.spe_bal_shrhldr_eqy is '股东权益差额(特殊报表科目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tot_bal_shrhldr_eqy is '股东权益差额(合计平衡项目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.minority_int is '少数股东权益';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tot_shrhldr_eqy_excl_min_int is '股东权益合计(不含少数股东权益)';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tot_shrhldr_eqy_incl_min_int is '股东权益合计(含少数股东权益)';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.spe_bal_liab_eqy is '负债及股东权益差额(特殊报表项目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tot_bal_liab_eqy is '负债及股东权益差额(合计平衡项目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.tot_liab_shrhldr_eqy is '负债及股东权益总计';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_unlistedbankbalancesheet.etl_timestamp is 'ETL处理时间戳';
