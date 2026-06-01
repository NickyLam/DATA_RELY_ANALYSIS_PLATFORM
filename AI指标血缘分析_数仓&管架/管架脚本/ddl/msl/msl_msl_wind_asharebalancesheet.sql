/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_wind_asharebalancesheet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_wind_asharebalancesheet
whenever sqlerror continue none;
drop table ${msl_schema}.msl_wind_asharebalancesheet purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_wind_asharebalancesheet(
    ETL_DT DATE
    ,OBJECT_ID VARCHAR2(100)
    ,S_INFO_WINDCODE VARCHAR2(40)
    ,WIND_CODE VARCHAR2(40)
    ,ANN_DT VARCHAR2(8)
    ,REPORT_PERIOD VARCHAR2(8)
    ,STATEMENT_TYPE VARCHAR2(10)
    ,CRNCY_CODE VARCHAR2(10)
    ,MONETARY_CAP NUMBER(20,4)
    ,TRADABLE_FIN_ASSETS NUMBER(20,4)
    ,NOTES_RCV NUMBER(20,4)
    ,ACCT_RCV NUMBER(20,4)
    ,OTH_RCV NUMBER(20,4)
    ,PREPAY NUMBER(20,4)
    ,DVD_RCV NUMBER(20,4)
    ,INT_RCV NUMBER(20,4)
    ,INVENTORIES NUMBER(20,4)
    ,CONSUMPTIVE_BIO_ASSETS NUMBER(20,4)
    ,DEFERRED_EXP NUMBER(20,4)
    ,NON_CUR_ASSETS_DUE_WITHIN_1Y NUMBER(20,4)
    ,SETTLE_RSRV NUMBER(20,4)
    ,LOANS_TO_OTH_BANKS NUMBER(20,4)
    ,PREM_RCV NUMBER(20,4)
    ,RCV_FROM_REINSURER NUMBER(20,4)
    ,RCV_FROM_CEDED_INSUR_CONT_RSRV NUMBER(20,4)
    ,RED_MONETARY_CAP_FOR_SALE NUMBER(20,4)
    ,OTH_CUR_ASSETS NUMBER(20,4)
    ,TOT_CUR_ASSETS NUMBER(20,4)
    ,FIN_ASSETS_AVAIL_FOR_SALE NUMBER(20,4)
    ,HELD_TO_MTY_INVEST NUMBER(20,4)
    ,LONG_TERM_EQY_INVEST NUMBER(20,4)
    ,INVEST_REAL_ESTATE NUMBER(20,4)
    ,TIME_DEPOSITS NUMBER(20,4)
    ,OTH_ASSETS NUMBER(20,4)
    ,LONG_TERM_REC NUMBER(20,4)
    ,FIX_ASSETS NUMBER(20,4)
    ,CONST_IN_PROG NUMBER(20,4)
    ,PROJ_MATL NUMBER(20,4)
    ,FIX_ASSETS_DISP NUMBER(20,4)
    ,PRODUCTIVE_BIO_ASSETS NUMBER(20,4)
    ,OIL_AND_NATURAL_GAS_ASSETS NUMBER(20,4)
    ,INTANG_ASSETS NUMBER(20,4)
    ,R_AND_D_COSTS NUMBER(20,4)
    ,GOODWILL NUMBER(20,4)
    ,LONG_TERM_DEFERRED_EXP NUMBER(20,4)
    ,DEFERRED_TAX_ASSETS NUMBER(20,4)
    ,LOANS_AND_ADV_GRANTED NUMBER(20,4)
    ,OTH_NON_CUR_ASSETS NUMBER(20,4)
    ,TOT_NON_CUR_ASSETS NUMBER(20,4)
    ,CASH_DEPOSITS_CENTRAL_BANK NUMBER(20,4)
    ,ASSET_DEP_OTH_BANKS_FIN_INST NUMBER(20,4)
    ,PRECIOUS_METALS NUMBER(20,4)
    ,DERIVATIVE_FIN_ASSETS NUMBER(20,4)
    ,AGENCY_BUS_ASSETS NUMBER(20,4)
    ,SUBR_REC NUMBER(20,4)
    ,RCV_CEDED_UNEARNED_PREM_RSRV NUMBER(20,4)
    ,RCV_CEDED_CLAIM_RSRV NUMBER(20,4)
    ,RCV_CEDED_LIFE_INSUR_RSRV NUMBER(20,4)
    ,RCV_CEDED_LT_HEALTH_INSUR_RSRV NUMBER(20,4)
    ,MRGN_PAID NUMBER(20,4)
    ,INSURED_PLEDGE_LOAN NUMBER(20,4)
    ,CAP_MRGN_PAID NUMBER(20,4)
    ,INDEPENDENT_ACCT_ASSETS NUMBER(20,4)
    ,CLIENTS_CAP_DEPOSIT NUMBER(20,4)
    ,CLIENTS_RSRV_SETTLE NUMBER(20,4)
    ,INCL_SEAT_FEES_EXCHANGE NUMBER(20,4)
    ,RCV_INVEST NUMBER(20,4)
    ,TOT_ASSETS NUMBER(20,4)
    ,ST_BORROW NUMBER(20,4)
    ,BORROW_CENTRAL_BANK NUMBER(20,4)
    ,DEPOSIT_RECEIVED_IB_DEPOSITS NUMBER(20,4)
    ,LOANS_OTH_BANKS NUMBER(20,4)
    ,TRADABLE_FIN_LIAB NUMBER(20,4)
    ,NOTES_PAYABLE NUMBER(20,4)
    ,ACCT_PAYABLE NUMBER(20,4)
    ,ADV_FROM_CUST NUMBER(20,4)
    ,FUND_SALES_FIN_ASSETS_RP NUMBER(20,4)
    ,HANDLING_CHARGES_COMM_PAYABLE NUMBER(20,4)
    ,EMPL_BEN_PAYABLE NUMBER(20,4)
    ,TAXES_SURCHARGES_PAYABLE NUMBER(20,4)
    ,INT_PAYABLE NUMBER(20,4)
    ,DVD_PAYABLE NUMBER(20,4)
    ,OTH_PAYABLE NUMBER(20,4)
    ,ACC_EXP NUMBER(20,4)
    ,DEFERRED_INC NUMBER(20,4)
    ,ST_BONDS_PAYABLE NUMBER(20,4)
    ,PAYABLE_TO_REINSURER NUMBER(20,4)
    ,RSRV_INSUR_CONT NUMBER(20,4)
    ,ACTING_TRADING_SEC NUMBER(20,4)
    ,ACTING_UW_SEC NUMBER(20,4)
    ,NON_CUR_LIAB_DUE_WITHIN_1Y NUMBER(20,4)
    ,OTH_CUR_LIAB NUMBER(20,4)
    ,TOT_CUR_LIAB NUMBER(20,4)
    ,LT_BORROW NUMBER(20,4)
    ,BONDS_PAYABLE NUMBER(20,4)
    ,LT_PAYABLE NUMBER(20,4)
    ,SPECIFIC_ITEM_PAYABLE NUMBER(20,4)
    ,PROVISIONS NUMBER(20,4)
    ,DEFERRED_TAX_LIAB NUMBER(20,4)
    ,DEFERRED_INC_NON_CUR_LIAB NUMBER(20,4)
    ,OTH_NON_CUR_LIAB NUMBER(20,4)
    ,TOT_NON_CUR_LIAB NUMBER(20,4)
    ,LIAB_DEP_OTH_BANKS_FIN_INST NUMBER(20,4)
    ,DERIVATIVE_FIN_LIAB NUMBER(20,4)
    ,CUST_BANK_DEP NUMBER(20,4)
    ,AGENCY_BUS_LIAB NUMBER(20,4)
    ,OTH_LIAB NUMBER(20,4)
    ,PREM_RECEIVED_ADV NUMBER(20,4)
    ,DEPOSIT_RECEIVED NUMBER(20,4)
    ,INSURED_DEPOSIT_INVEST NUMBER(20,4)
    ,UNEARNED_PREM_RSRV NUMBER(20,4)
    ,OUT_LOSS_RSRV NUMBER(20,4)
    ,LIFE_INSUR_RSRV NUMBER(20,4)
    ,LT_HEALTH_INSUR_V NUMBER(20,4)
    ,INDEPENDENT_ACCT_LIAB NUMBER(20,4)
    ,INCL_PLEDGE_LOAN NUMBER(20,4)
    ,CLAIMS_PAYABLE NUMBER(20,4)
    ,DVD_PAYABLE_INSURED NUMBER(20,4)
    ,TOT_LIAB NUMBER(20,4)
    ,CAP_STK NUMBER(20,4)
    ,CAP_RSRV NUMBER(20,4)
    ,SPECIAL_RSRV NUMBER(20,4)
    ,SURPLUS_RSRV NUMBER(20,4)
    ,UNDISTRIBUTED_PROFIT NUMBER(20,4)
    ,LESS_TSY_STK NUMBER(20,4)
    ,PROV_NOM_RISKS NUMBER(20,4)
    ,CNVD_DIFF_FOREIGN_CURR_STAT NUMBER(20,4)
    ,UNCONFIRMED_INVEST_LOSS NUMBER(20,4)
    ,MINORITY_INT NUMBER(20,4)
    ,TOT_SHRHLDR_EQY_EXCL_MIN_INT NUMBER(20,4)
    ,TOT_SHRHLDR_EQY_INCL_MIN_INT NUMBER(20,4)
    ,TOT_LIAB_SHRHLDR_EQY NUMBER(20,4)
    ,COMP_TYPE_CODE VARCHAR2(2)
    ,ACTUAL_ANN_DT VARCHAR2(8)
    ,SPE_CUR_ASSETS_DIFF NUMBER(20,4)
    ,TOT_CUR_ASSETS_DIFF NUMBER(20,4)
    ,SPE_NON_CUR_ASSETS_DIFF NUMBER(20,4)
    ,TOT_NON_CUR_ASSETS_DIFF NUMBER(20,4)
    ,SPE_BAL_ASSETS_DIFF NUMBER(20,4)
    ,TOT_BAL_ASSETS_DIFF NUMBER(20,4)
    ,SPE_CUR_LIAB_DIFF NUMBER(20,4)
    ,TOT_CUR_LIAB_DIFF NUMBER(20,4)
    ,SPE_NON_CUR_LIAB_DIFF NUMBER(20,4)
    ,TOT_NON_CUR_LIAB_DIFF NUMBER(20,4)
    ,SPE_BAL_LIAB_DIFF NUMBER(20,4)
    ,TOT_BAL_LIAB_DIFF NUMBER(20,4)
    ,SPE_BAL_SHRHLDR_EQY_DIFF NUMBER(20,4)
    ,TOT_BAL_SHRHLDR_EQY_DIFF NUMBER(20,4)
    ,SPE_BAL_LIAB_EQY_DIFF NUMBER(20,4)
    ,TOT_BAL_LIAB_EQY_DIFF NUMBER(20,4)
    ,LT_PAYROLL_PAYABLE NUMBER(20,4)
    ,OTHER_COMP_INCOME NUMBER(20,4)
    ,OTHER_EQUITY_TOOLS NUMBER(20,4)
    ,OTHER_EQUITY_TOOLS_P_SHR NUMBER(20,4)
    ,LENDING_FUNDS NUMBER(20,4)
    ,ACCOUNTS_RECEIVABLE NUMBER(20,4)
    ,ST_FINANCING_PAYABLE NUMBER(20,4)
    ,PAYABLES NUMBER(20,4)
    ,S_INFO_COMPCODE VARCHAR2(10)
    ,TOT_SHR NUMBER(20,4)
    ,HFS_ASSETS NUMBER(20,4)
    ,HFS_SALES NUMBER(20,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
-- grant select on ${msl_schema}.msl_wind_asharebalancesheet to itl;

-- comment
comment on table ${msl_schema}.msl_wind_asharebalancesheet is '中国A股资产负债表';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ETL_DT is 'ETL处理日期';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OBJECT_ID is '对象ID';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.S_INFO_WINDCODE is 'Wind代码';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.WIND_CODE is 'Wind代码';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ANN_DT is '公告日期';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.REPORT_PERIOD is '报告期';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.STATEMENT_TYPE is '报表类型';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CRNCY_CODE is '货币代码';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.MONETARY_CAP is '货币资金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TRADABLE_FIN_ASSETS is '交易性金融资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.NOTES_RCV is '应收票据';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ACCT_RCV is '应收账款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTH_RCV is '其他应收款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.PREPAY is '预付款项';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DVD_RCV is '应收股利';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INT_RCV is '应收利息';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INVENTORIES is '存货';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CONSUMPTIVE_BIO_ASSETS is '消耗性生物资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DEFERRED_EXP is '待摊费用';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.NON_CUR_ASSETS_DUE_WITHIN_1Y is '一年内到期的非流动资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SETTLE_RSRV is '结算备付金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LOANS_TO_OTH_BANKS is '拆出资金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.PREM_RCV is '应收保费';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.RCV_FROM_REINSURER is '应收分保账款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.RCV_FROM_CEDED_INSUR_CONT_RSRV is '应收分保合同准备金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.RED_MONETARY_CAP_FOR_SALE is '买入返售金融资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTH_CUR_ASSETS is '其他流动资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_CUR_ASSETS is '流动资产合计';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.FIN_ASSETS_AVAIL_FOR_SALE is '可供出售金融资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.HELD_TO_MTY_INVEST is '持有至到期投资';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LONG_TERM_EQY_INVEST is '长期股权投资';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INVEST_REAL_ESTATE is '投资性房地产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TIME_DEPOSITS is '定期存款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTH_ASSETS is '其他资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LONG_TERM_REC is '长期应收款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.FIX_ASSETS is '固定资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CONST_IN_PROG is '在建工程';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.PROJ_MATL is '工程物资';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.FIX_ASSETS_DISP is '固定资产清理';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.PRODUCTIVE_BIO_ASSETS is '生产性生物资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OIL_AND_NATURAL_GAS_ASSETS is '油气资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INTANG_ASSETS is '无形资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.R_AND_D_COSTS is '开发支出';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.GOODWILL is '商誉';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LONG_TERM_DEFERRED_EXP is '长期待摊费用';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DEFERRED_TAX_ASSETS is '递延所得税资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LOANS_AND_ADV_GRANTED is '发放贷款及垫款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTH_NON_CUR_ASSETS is '其他非流动资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_NON_CUR_ASSETS is '非流动资产合计';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CASH_DEPOSITS_CENTRAL_BANK is '现金及存放中央银行款项';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ASSET_DEP_OTH_BANKS_FIN_INST is '存放同业和其它金融机构款项';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.PRECIOUS_METALS is '贵金属';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DERIVATIVE_FIN_ASSETS is '衍生金融资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.AGENCY_BUS_ASSETS is '代理业务资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SUBR_REC is '应收代位追偿款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.RCV_CEDED_UNEARNED_PREM_RSRV is '应收分保未到期责任准备金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.RCV_CEDED_CLAIM_RSRV is '应收分保未决赔款准备金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.RCV_CEDED_LIFE_INSUR_RSRV is '应收分保寿险责任准备金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.RCV_CEDED_LT_HEALTH_INSUR_RSRV is '应收分保长期健康险责任准备金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.MRGN_PAID is '存出保证金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INSURED_PLEDGE_LOAN is '保户质押贷款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CAP_MRGN_PAID is '存出资本保证金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INDEPENDENT_ACCT_ASSETS is '独立账户资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CLIENTS_CAP_DEPOSIT is '客户资金存款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CLIENTS_RSRV_SETTLE is '客户备付金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INCL_SEAT_FEES_EXCHANGE is '其中:交易席位费';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.RCV_INVEST is '应收款项类投资';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_ASSETS is '资产总计';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ST_BORROW is '短期借款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.BORROW_CENTRAL_BANK is '向中央银行借款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DEPOSIT_RECEIVED_IB_DEPOSITS is '吸收存款及同业存放';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LOANS_OTH_BANKS is '拆入资金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TRADABLE_FIN_LIAB is '交易性金融负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.NOTES_PAYABLE is '应付票据';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ACCT_PAYABLE is '应付账款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ADV_FROM_CUST is '预收款项';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.FUND_SALES_FIN_ASSETS_RP is '卖出回购金融资产款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.HANDLING_CHARGES_COMM_PAYABLE is '应付手续费及佣金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.EMPL_BEN_PAYABLE is '应付职工薪酬';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TAXES_SURCHARGES_PAYABLE is '应交税费';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INT_PAYABLE is '应付利息';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DVD_PAYABLE is '应付股利';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTH_PAYABLE is '其他应付款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ACC_EXP is '预提费用';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DEFERRED_INC is '递延收益';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ST_BONDS_PAYABLE is '应付短期债券';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.PAYABLE_TO_REINSURER is '应付分保账款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.RSRV_INSUR_CONT is '保险合同准备金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ACTING_TRADING_SEC is '代理买卖证券款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ACTING_UW_SEC is '代理承销证券款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.NON_CUR_LIAB_DUE_WITHIN_1Y is '一年内到期的非流动负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTH_CUR_LIAB is '其他流动负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_CUR_LIAB is '流动负债合计';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LT_BORROW is '长期借款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.BONDS_PAYABLE is '应付债券';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LT_PAYABLE is '长期应付款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SPECIFIC_ITEM_PAYABLE is '专项应付款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.PROVISIONS is '预计负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DEFERRED_TAX_LIAB is '递延所得税负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DEFERRED_INC_NON_CUR_LIAB is '递延收益-非流动负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTH_NON_CUR_LIAB is '其他非流动负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_NON_CUR_LIAB is '非流动负债合计';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LIAB_DEP_OTH_BANKS_FIN_INST is '同业和其它金融机构存放款项';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DERIVATIVE_FIN_LIAB is '衍生金融负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CUST_BANK_DEP is '吸收存款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.AGENCY_BUS_LIAB is '代理业务负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTH_LIAB is '其他负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.PREM_RECEIVED_ADV is '预收保费';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DEPOSIT_RECEIVED is '存入保证金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INSURED_DEPOSIT_INVEST is '保户储金及投资款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.UNEARNED_PREM_RSRV is '未到期责任准备金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OUT_LOSS_RSRV is '未决赔款准备金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LIFE_INSUR_RSRV is '寿险责任准备金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LT_HEALTH_INSUR_V is '长期健康险责任准备金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INDEPENDENT_ACCT_LIAB is '独立账户负债';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.INCL_PLEDGE_LOAN is '其中:质押借款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CLAIMS_PAYABLE is '应付赔付款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.DVD_PAYABLE_INSURED is '应付保单红利';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_LIAB is '负债合计';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CAP_STK is '股本';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CAP_RSRV is '资本公积金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SPECIAL_RSRV is '专项储备';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SURPLUS_RSRV is '盈余公积金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.UNDISTRIBUTED_PROFIT is '未分配利润';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LESS_TSY_STK is '减:库存股';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.PROV_NOM_RISKS is '一般风险准备';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.CNVD_DIFF_FOREIGN_CURR_STAT is '外币报表折算差额';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.UNCONFIRMED_INVEST_LOSS is '未确认的投资损失';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.MINORITY_INT is '少数股东权益';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_SHRHLDR_EQY_EXCL_MIN_INT is '股东权益合计(不含少数股东权益)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_SHRHLDR_EQY_INCL_MIN_INT is '股东权益合计(含少数股东权益)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_LIAB_SHRHLDR_EQY is '负债及股东权益总计';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.COMP_TYPE_CODE is '公司类型代码';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ACTUAL_ANN_DT is '实际公告日期';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SPE_CUR_ASSETS_DIFF is '流动资产差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_CUR_ASSETS_DIFF is '流动资产差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SPE_NON_CUR_ASSETS_DIFF is '非流动资产差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_NON_CUR_ASSETS_DIFF is '非流动资产差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SPE_BAL_ASSETS_DIFF is '资产差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_BAL_ASSETS_DIFF is '资产差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SPE_CUR_LIAB_DIFF is '流动负债差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_CUR_LIAB_DIFF is '流动负债差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SPE_NON_CUR_LIAB_DIFF is '非流动负债差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_NON_CUR_LIAB_DIFF is '非流动负债差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SPE_BAL_LIAB_DIFF is '负债差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_BAL_LIAB_DIFF is '负债差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SPE_BAL_SHRHLDR_EQY_DIFF is '股东权益差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_BAL_SHRHLDR_EQY_DIFF is '股东权益差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.SPE_BAL_LIAB_EQY_DIFF is '负债及股东权益差额(特殊报表项目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_BAL_LIAB_EQY_DIFF is '负债及股东权益差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LT_PAYROLL_PAYABLE is '长期应付职工薪酬';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTHER_COMP_INCOME is '其他综合收益';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTHER_EQUITY_TOOLS is '其他权益工具';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.OTHER_EQUITY_TOOLS_P_SHR is '其他权益工具:优先股';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.LENDING_FUNDS is '融出资金';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ACCOUNTS_RECEIVABLE is '应收款项';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.ST_FINANCING_PAYABLE is '应付短期融资款';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.PAYABLES is '应付款项';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.S_INFO_COMPCODE is '公司ID';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.TOT_SHR is '期末总股本';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.HFS_ASSETS is '持有待售的资产';
comment on column ${msl_schema}.msl_wind_asharebalancesheet.HFS_SALES is '持有待售的负债';
