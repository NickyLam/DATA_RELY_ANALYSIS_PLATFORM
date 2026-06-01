/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_wind_unlistedbankbalancesheet
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_wind_unlistedbankbalancesheet
whenever sqlerror continue none;
drop table ${msl_schema}.msl_wind_unlistedbankbalancesheet purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_wind_unlistedbankbalancesheet(
    ETL_DT DATE
    ,OBJECT_ID VARCHAR2(100)
    ,S_INFO_COMPCODE VARCHAR2(40)
    ,ANN_DT VARCHAR2(8)
    ,REPORT_PERIOD VARCHAR2(8)
    ,STATEMENT_TYPE VARCHAR2(10)
    ,CRNCY_CODE VARCHAR2(10)
    ,ACTUAL_ANN_DT VARCHAR2(8)
    ,CASH_DEPOSITS_CENTRAL_BANK NUMBER(20,4)
    ,ASSET_DEP_OTH_BANKS_FIN_INST NUMBER(20,4)
    ,PRECIOUS_METALS NUMBER(20,4)
    ,LOANS_TO_OTH_BANKS NUMBER(20,4)
    ,TRADABLE_FIN_ASSETS NUMBER(20,4)
    ,DERIVATIVE_FIN_ASSETS NUMBER(20,4)
    ,RED_MONETARY_CAP_FOR_SALE NUMBER(20,4)
    ,INT_RCV NUMBER(20,4)
    ,LOANS_AND_ADV_GRANTED NUMBER(20,4)
    ,AGENCY_BUS_ASSETS NUMBER(20,4)
    ,FIN_ASSETS_AVAIL_FOR_SALE NUMBER(20,4)
    ,HELD_TO_MTY_INVEST NUMBER(20,4)
    ,LONG_TERM_EQY_INVEST NUMBER(20,4)
    ,RCV_INVEST NUMBER(20,4)
    ,FIX_ASSETS NUMBER(20,4)
    ,INTANG_ASSETS NUMBER(20,4)
    ,GOODWILL NUMBER(20,4)
    ,DEFERRED_TAX_ASSETS NUMBER(20,4)
    ,INVEST_REAL_ESTATE NUMBER(20,4)
    ,OTH_ASSETS NUMBER(20,4)
    ,SPE_BAL_ASSETS NUMBER(20,4)
    ,TOT_BAL_ASSETS NUMBER(20,4)
    ,TOT_ASSETS NUMBER(20,4)
    ,LIAB_DEP_OTH_BANKS_FIN_INST NUMBER(20,4)
    ,BORROW_CENTRAL_BANK NUMBER(20,4)
    ,LOANS_OTH_BANKS NUMBER(20,4)
    ,TRADABLE_FIN_LIAB NUMBER(20,4)
    ,DERIVATIVE_FIN_LIAB NUMBER(20,4)
    ,FUND_SALES_FIN_ASSETS_RP NUMBER(20,4)
    ,CUST_BANK_DEP NUMBER(20,4)
    ,EMPL_BEN_PAYABLE NUMBER(20,4)
    ,TAXES_SURCHARGES_PAYABLE NUMBER(20,4)
    ,INT_PAYABLE NUMBER(20,4)
    ,AGENCY_BUS_LIAB NUMBER(20,4)
    ,BONDS_PAYABLE NUMBER(20,4)
    ,DEFERRED_TAX_LIAB NUMBER(20,4)
    ,PROVISIONS NUMBER(20,4)
    ,OTH_LIAB NUMBER(20,4)
    ,SPE_BAL_LIAB NUMBER(20,4)
    ,TOT_BAL_LIAB NUMBER(20,4)
    ,TOT_LIAB NUMBER(20,4)
    ,CAP_STK NUMBER(20,4)
    ,CAP_RSRV NUMBER(20,4)
    ,LESS_TSY_STK NUMBER(20,4)
    ,SURPLUS_RSRV NUMBER(20,4)
    ,UNDISTRIBUTED_PROFIT NUMBER(20,4)
    ,PROV_NOM_RISKS NUMBER(20,4)
    ,CNVD_DIFF_FOREIGN_CURR_STAT NUMBER(20,4)
    ,UNCONFIRMED_INVEST_LOSS NUMBER(20,4)
    ,SPE_BAL_SHRHLDR_EQY NUMBER(20,4)
    ,TOT_BAL_SHRHLDR_EQY NUMBER(20,4)
    ,MINORITY_INT NUMBER(20,4)
    ,TOT_SHRHLDR_EQY_EXCL_MIN_INT NUMBER(20,4)
    ,TOT_SHRHLDR_EQY_INCL_MIN_INT NUMBER(20,4)
    ,SPE_BAL_LIAB_EQY NUMBER(20,4)
    ,TOT_BAL_LIAB_EQY NUMBER(20,4)
    ,TOT_LIAB_SHRHLDR_EQY NUMBER(20,4)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
-- grant select on ${msl_schema}.msl_wind_unlistedbankbalancesheet to itl;

-- comment
comment on table ${msl_schema}.msl_wind_unlistedbankbalancesheet is '非上市银行资产负债表';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.ETL_DT is 'ETL处理日期';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.OBJECT_ID is '对象ID';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.S_INFO_COMPCODE is '公司ID';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.ANN_DT is '公告日期';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.REPORT_PERIOD is '报告期';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.STATEMENT_TYPE is '报表类型';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.CRNCY_CODE is '货币代码';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.ACTUAL_ANN_DT is '实际公告日期';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.CASH_DEPOSITS_CENTRAL_BANK is '现金及存放中央银行款项';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.ASSET_DEP_OTH_BANKS_FIN_INST is '存放同业和其它金融机构款项';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.PRECIOUS_METALS is '贵金属';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.LOANS_TO_OTH_BANKS is '拆出资金';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TRADABLE_FIN_ASSETS is '交易性金融资产';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.DERIVATIVE_FIN_ASSETS is '衍生金融资产';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.RED_MONETARY_CAP_FOR_SALE is '买入返售金融资产';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.INT_RCV is '应收利息';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.LOANS_AND_ADV_GRANTED is '发放贷款及垫款';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.AGENCY_BUS_ASSETS is '代理业务资产';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.FIN_ASSETS_AVAIL_FOR_SALE is '可供出售金融资产';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.HELD_TO_MTY_INVEST is '持有至到期投资';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.LONG_TERM_EQY_INVEST is '长期股权投资';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.RCV_INVEST is '应收款项类投资';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.FIX_ASSETS is '固定资产';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.INTANG_ASSETS is '无形资产';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.GOODWILL is '商誉';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.DEFERRED_TAX_ASSETS is '递延所得税资产';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.INVEST_REAL_ESTATE is '投资性房地产';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.OTH_ASSETS is '其他资产';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.SPE_BAL_ASSETS is '资产差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TOT_BAL_ASSETS is '资产差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TOT_ASSETS is '资产总计';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.LIAB_DEP_OTH_BANKS_FIN_INST is '同业和其它金融机构存放款项';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.BORROW_CENTRAL_BANK is '向中央银行借款';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.LOANS_OTH_BANKS is '拆入资金';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TRADABLE_FIN_LIAB is '交易性金融负债';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.DERIVATIVE_FIN_LIAB is '衍生金融负债';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.FUND_SALES_FIN_ASSETS_RP is '卖出回购金融资产款';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.CUST_BANK_DEP is '吸收存款';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.EMPL_BEN_PAYABLE is '应付职工薪酬';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TAXES_SURCHARGES_PAYABLE is '应交税费';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.INT_PAYABLE is '应付利息';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.AGENCY_BUS_LIAB is '代理业务负债';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.BONDS_PAYABLE is '应付债券';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.DEFERRED_TAX_LIAB is '递延所得税负债';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.PROVISIONS is '预计负债';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.OTH_LIAB is '其他负债';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.SPE_BAL_LIAB is '负债差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TOT_BAL_LIAB is '负债差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TOT_LIAB is '负债合计';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.CAP_STK is '股本';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.CAP_RSRV is '资本公积金';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.LESS_TSY_STK is '减：库存股';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.SURPLUS_RSRV is '盈余公积金';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.UNDISTRIBUTED_PROFIT is '未分配利润';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.PROV_NOM_RISKS is '一般风险准备';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.CNVD_DIFF_FOREIGN_CURR_STAT is '外币报表折算差额';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.UNCONFIRMED_INVEST_LOSS is '未确认的投资损失';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.SPE_BAL_SHRHLDR_EQY is '股东权益差额(特殊报表科目)';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TOT_BAL_SHRHLDR_EQY is '股东权益差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.MINORITY_INT is '少数股东权益';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TOT_SHRHLDR_EQY_EXCL_MIN_INT is '股东权益合计(不含少数股东权益)';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TOT_SHRHLDR_EQY_INCL_MIN_INT is '股东权益合计(含少数股东权益)';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.SPE_BAL_LIAB_EQY is '负债及股东权益差额(特殊报表项目)';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TOT_BAL_LIAB_EQY is '负债及股东权益差额(合计平衡项目)';
comment on column ${msl_schema}.msl_wind_unlistedbankbalancesheet.TOT_LIAB_SHRHLDR_EQY is '负债及股东权益总计';
