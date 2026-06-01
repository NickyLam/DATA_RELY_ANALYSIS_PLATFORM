/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_sec_corp_main_indicators
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_sec_corp_main_indicators
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_sec_corp_main_indicators purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_sec_corp_main_indicators(
    seq number(28,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录通讯到用户端时间
    ,announcement_date date -- 公告日期
    ,ed date -- 截止日期
    ,net_capital number(18,4) -- 净资本
    ,nc_to_total_risk_reserve number(18,4) -- 净资本/各项风险资本准备之和
    ,net_capital_to_net_assets number(18,4) -- 净资本/净资产
    ,net_capital_to_liab number(18,4) -- 净资本/负债
    ,net_assets_to_liab number(18,4) -- 净资产/负债
    ,ss_equity_sec_etc_to_nc number(18,4) -- 自营权益类证券及证券衍生品/净资本
    ,ss_fixed_income_sec_to_nc number(18,4) -- 自营固定收益类证券/净资本
    ,total_risk_capital_reserve number(18,4) -- 各项风险资本准备之和
    ,entrusted_capital number(18,4) -- 受托资金
    ,net_capital_ratio number(18,4) -- 净资本比率
    ,self_operate_nb number(18,4) -- 自营国债
    ,self_operate_fund number(18,4) -- 自营基金
    ,self_operate_stock number(18,4) -- 自营股票
    ,self_operate_sec_sum number(18,4) -- 自营证券合计
    ,self_operate_cb number(18,4) -- 自营证可转债
    ,special_am_income number(18,4) -- 专项资产管理业务收入
    ,entrusted_am_scale number(18,4) -- 受托管理资产总规模
    ,directional_am_income number(18,4) -- 定向资产管理业务收入
    ,collective_am_income number(18,4) -- 集合资产管理业务收入
    ,net_stable_funding_ratio number(18,4) -- 净稳定资金率
    ,lcr number(18,4) -- 流动性覆盖率
    ,capital_leverage number(18,4) -- 资本杠杆率
    ,corp_code varchar2(60) -- 公司代码
    ,ib_net_income number(18,4) -- 投资银行业务净收入
    ,si_net_income number(18,4) -- 证券投资业务净收入
    ,sb_net_income number(18,4) -- 证券经纪业务净收入
    ,am_net_income number(18,4) -- 资产管理业务净收入
    ,ib_income number(18,4) -- 投资银行业务收入
    ,si_income number(18,4) -- 证券投资业务收入
    ,sb_income number(18,4) -- 证券经纪业务收入
    ,am_income number(18,4) -- 资产管理业务收入
    ,fs_trade_fina_assets number(18,4) -- 融出证券:交易性金融资产
    ,fs_other_equity_instr_invest number(18,4) -- 融出证券:其他权益工具投资
    ,fs_impai_provi number(18,4) -- 融出证券:减值准备
    ,fs_avail_sale_fina_assets number(18,4) -- 融出证券:可供出售金融资产
    ,total_fs number(18,4) -- 融出证券总额
    ,fs_refin_secur_amo number(18,4) -- 融出证券:转融通融入证券
    ,total_ins_refin_secur_amo number(18,4) -- 融入证券:转融通融入证券总额
    ,ins_borr_secur number(18,4) -- 融入证券:借入证券
    ,total_ins number(18,4) -- 融入证券总额
    ,fs_borr_secur number(18,4) -- 融出证券:借入证券
    ,nii_pur_resale_fina_assets number(18,4) -- 利息净收入:买入返售金融资产
    ,nii_debt_invest number(18,4) -- 利息净收入:债权投资
    ,nii_other number(18,4) -- 利息净收入:其他
    ,nii_other_debt_invest number(18,4) -- 利息净收入:其他债权投资
    ,nii_other_fina_assets_ceirm number(18,4) -- 利息净收入:其他按实际利率法计算的金融资产
    ,nii_fina_assets_calcu_eirm number(18,4) -- 利息净收入:存放金融同业
    ,nii_lend_funds number(18,4) -- 利息净收入:拆出资金
    ,nii_margin_trade number(18,4) -- 利息净收入:融资融券业务
    ,nii_monet_funds_settl_provi number(18,4) -- 利息净收入:货币资金及结算备付金
    ,nii_loans_recei number(18,4) -- 利息净收入:贷款和应收款
    ,ii_purch_resale_fina_asset number(18,4) -- 利息收入:买入返售金融资产
    ,ii_debt_invest number(18,4) -- 利息收入:债权投资
    ,ii_other number(18,4) -- 利息收入:其他
    ,ii_other_debt_invest number(18,4) -- 利息收入:其他债权投资
    ,ii_other_fina_assets_ceirm number(18,4) -- 利息收入:其他按实际利率法计算的金融资产
    ,ii_fina_assets_calcu_eirm number(18,4) -- 利息收入:存放金融同业
    ,ii_lend_funds number(18,4) -- 利息收入:拆出资金
    ,ii_margin_trade number(18,4) -- 利息收入:融资融券业务
    ,ii_monet_funds_settl_provi number(18,4) -- 利息收入:货币资金及结算备付金
    ,ii_loans_recei number(18,4) -- 利息收入:贷款和应收款
    ,nhfci_other number(18,4) -- 手续费及佣金净收入:其他
    ,nhfci_fund_manag number(18,4) -- 手续费及佣金净收入:基金管理业务
    ,nhfci_invest_consul number(18,4) -- 手续费及佣金净收入:投资咨询业务
    ,nhfci_invest_bank number(18,4) -- 手续费及佣金净收入:投资银行业务
    ,nhfci_futur_broke number(18,4) -- 手续费及佣金净收入:期货经纪业务
    ,nhfci_secur_broke number(18,4) -- 手续费及佣金净收入:证券经纪业务
    ,nhfci_asset_manag number(18,4) -- 手续费及佣金净收入:资产管理业务
    ,hfci_other number(18,4) -- 手续费及佣金收入:其他
    ,hfci_fund_manag number(18,4) -- 手续费及佣金收入:基金管理业务
    ,hfci_invest_consul number(18,4) -- 手续费及佣金收入:投资咨询业务
    ,hfci_invest_bank number(18,4) -- 手续费及佣金收入:投资银行业务
    ,hfci_futur_broke number(18,4) -- 手续费及佣金收入:期货经纪业务
    ,hfci_secur_broke number(18,4) -- 手续费及佣金收入:证券经纪业务
    ,hfci_asset_manag number(18,4) -- 手续费及佣金收入:资产管理业务
    ,fs_hk_margin_fina_colla number(24,4) -- 融出证券:香港孖展融资担保物
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_sec_corp_main_indicators to ${iml_schema};
grant select on ${iol_schema}.uxds_sec_corp_main_indicators to ${icl_schema};
grant select on ${iol_schema}.uxds_sec_corp_main_indicators to ${idl_schema};
grant select on ${iol_schema}.uxds_sec_corp_main_indicators to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_sec_corp_main_indicators is '证券公司主要指标';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.rtime is '记录通讯到用户端时间';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.announcement_date is '公告日期';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ed is '截止日期';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.net_capital is '净资本';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nc_to_total_risk_reserve is '净资本/各项风险资本准备之和';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.net_capital_to_net_assets is '净资本/净资产';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.net_capital_to_liab is '净资本/负债';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.net_assets_to_liab is '净资产/负债';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ss_equity_sec_etc_to_nc is '自营权益类证券及证券衍生品/净资本';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ss_fixed_income_sec_to_nc is '自营固定收益类证券/净资本';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.total_risk_capital_reserve is '各项风险资本准备之和';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.entrusted_capital is '受托资金';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.net_capital_ratio is '净资本比率';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.self_operate_nb is '自营国债';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.self_operate_fund is '自营基金';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.self_operate_stock is '自营股票';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.self_operate_sec_sum is '自营证券合计';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.self_operate_cb is '自营证可转债';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.special_am_income is '专项资产管理业务收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.entrusted_am_scale is '受托管理资产总规模';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.directional_am_income is '定向资产管理业务收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.collective_am_income is '集合资产管理业务收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.net_stable_funding_ratio is '净稳定资金率';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.lcr is '流动性覆盖率';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.capital_leverage is '资本杠杆率';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.corp_code is '公司代码';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ib_net_income is '投资银行业务净收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.si_net_income is '证券投资业务净收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.sb_net_income is '证券经纪业务净收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.am_net_income is '资产管理业务净收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ib_income is '投资银行业务收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.si_income is '证券投资业务收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.sb_income is '证券经纪业务收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.am_income is '资产管理业务收入';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.fs_trade_fina_assets is '融出证券:交易性金融资产';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.fs_other_equity_instr_invest is '融出证券:其他权益工具投资';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.fs_impai_provi is '融出证券:减值准备';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.fs_avail_sale_fina_assets is '融出证券:可供出售金融资产';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.total_fs is '融出证券总额';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.fs_refin_secur_amo is '融出证券:转融通融入证券';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.total_ins_refin_secur_amo is '融入证券:转融通融入证券总额';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ins_borr_secur is '融入证券:借入证券';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.total_ins is '融入证券总额';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.fs_borr_secur is '融出证券:借入证券';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nii_pur_resale_fina_assets is '利息净收入:买入返售金融资产';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nii_debt_invest is '利息净收入:债权投资';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nii_other is '利息净收入:其他';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nii_other_debt_invest is '利息净收入:其他债权投资';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nii_other_fina_assets_ceirm is '利息净收入:其他按实际利率法计算的金融资产';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nii_fina_assets_calcu_eirm is '利息净收入:存放金融同业';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nii_lend_funds is '利息净收入:拆出资金';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nii_margin_trade is '利息净收入:融资融券业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nii_monet_funds_settl_provi is '利息净收入:货币资金及结算备付金';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nii_loans_recei is '利息净收入:贷款和应收款';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ii_purch_resale_fina_asset is '利息收入:买入返售金融资产';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ii_debt_invest is '利息收入:债权投资';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ii_other is '利息收入:其他';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ii_other_debt_invest is '利息收入:其他债权投资';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ii_other_fina_assets_ceirm is '利息收入:其他按实际利率法计算的金融资产';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ii_fina_assets_calcu_eirm is '利息收入:存放金融同业';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ii_lend_funds is '利息收入:拆出资金';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ii_margin_trade is '利息收入:融资融券业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ii_monet_funds_settl_provi is '利息收入:货币资金及结算备付金';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.ii_loans_recei is '利息收入:贷款和应收款';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nhfci_other is '手续费及佣金净收入:其他';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nhfci_fund_manag is '手续费及佣金净收入:基金管理业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nhfci_invest_consul is '手续费及佣金净收入:投资咨询业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nhfci_invest_bank is '手续费及佣金净收入:投资银行业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nhfci_futur_broke is '手续费及佣金净收入:期货经纪业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nhfci_secur_broke is '手续费及佣金净收入:证券经纪业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.nhfci_asset_manag is '手续费及佣金净收入:资产管理业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.hfci_other is '手续费及佣金收入:其他';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.hfci_fund_manag is '手续费及佣金收入:基金管理业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.hfci_invest_consul is '手续费及佣金收入:投资咨询业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.hfci_invest_bank is '手续费及佣金收入:投资银行业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.hfci_futur_broke is '手续费及佣金收入:期货经纪业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.hfci_secur_broke is '手续费及佣金收入:证券经纪业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.hfci_asset_manag is '手续费及佣金收入:资产管理业务';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.fs_hk_margin_fina_colla is '融出证券:香港孖展融资担保物';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_sec_corp_main_indicators.etl_timestamp is 'ETL处理时间戳';
