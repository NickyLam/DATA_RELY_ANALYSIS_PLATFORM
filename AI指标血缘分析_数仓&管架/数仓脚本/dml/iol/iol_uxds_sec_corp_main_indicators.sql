/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_sec_corp_main_indicators
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_sec_corp_main_indicators_ex purge;
alter table ${iol_schema}.uxds_sec_corp_main_indicators add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_sec_corp_main_indicators;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_sec_corp_main_indicators_ex nologging
compress
as
select * from ${iol_schema}.uxds_sec_corp_main_indicators where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_sec_corp_main_indicators_ex(
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录通讯到用户端时间
    ,announcement_date -- 公告日期
    ,ed -- 截止日期
    ,net_capital -- 净资本
    ,nc_to_total_risk_reserve -- 净资本/各项风险资本准备之和
    ,net_capital_to_net_assets -- 净资本/净资产
    ,net_capital_to_liab -- 净资本/负债
    ,net_assets_to_liab -- 净资产/负债
    ,ss_equity_sec_etc_to_nc -- 自营权益类证券及证券衍生品/净资本
    ,ss_fixed_income_sec_to_nc -- 自营固定收益类证券/净资本
    ,total_risk_capital_reserve -- 各项风险资本准备之和
    ,entrusted_capital -- 受托资金
    ,net_capital_ratio -- 净资本比率
    ,self_operate_nb -- 自营国债
    ,self_operate_fund -- 自营基金
    ,self_operate_stock -- 自营股票
    ,self_operate_sec_sum -- 自营证券合计
    ,self_operate_cb -- 自营证可转债
    ,special_am_income -- 专项资产管理业务收入
    ,entrusted_am_scale -- 受托管理资产总规模
    ,directional_am_income -- 定向资产管理业务收入
    ,collective_am_income -- 集合资产管理业务收入
    ,net_stable_funding_ratio -- 净稳定资金率
    ,lcr -- 流动性覆盖率
    ,capital_leverage -- 资本杠杆率
    ,corp_code -- 公司代码
    ,ib_net_income -- 投资银行业务净收入
    ,si_net_income -- 证券投资业务净收入
    ,sb_net_income -- 证券经纪业务净收入
    ,am_net_income -- 资产管理业务净收入
    ,ib_income -- 投资银行业务收入
    ,si_income -- 证券投资业务收入
    ,sb_income -- 证券经纪业务收入
    ,am_income -- 资产管理业务收入
    ,fs_trade_fina_assets -- 融出证券:交易性金融资产
    ,fs_other_equity_instr_invest -- 融出证券:其他权益工具投资
    ,fs_impai_provi -- 融出证券:减值准备
    ,fs_avail_sale_fina_assets -- 融出证券:可供出售金融资产
    ,total_fs -- 融出证券总额
    ,fs_refin_secur_amo -- 融出证券:转融通融入证券
    ,total_ins_refin_secur_amo -- 融入证券:转融通融入证券总额
    ,ins_borr_secur -- 融入证券:借入证券
    ,total_ins -- 融入证券总额
    ,fs_borr_secur -- 融出证券:借入证券
    ,nii_pur_resale_fina_assets -- 利息净收入:买入返售金融资产
    ,nii_debt_invest -- 利息净收入:债权投资
    ,nii_other -- 利息净收入:其他
    ,nii_other_debt_invest -- 利息净收入:其他债权投资
    ,nii_other_fina_assets_ceirm -- 利息净收入:其他按实际利率法计算的金融资产
    ,nii_fina_assets_calcu_eirm -- 利息净收入:存放金融同业
    ,nii_lend_funds -- 利息净收入:拆出资金
    ,nii_margin_trade -- 利息净收入:融资融券业务
    ,nii_monet_funds_settl_provi -- 利息净收入:货币资金及结算备付金
    ,nii_loans_recei -- 利息净收入:贷款和应收款
    ,ii_purch_resale_fina_asset -- 利息收入:买入返售金融资产
    ,ii_debt_invest -- 利息收入:债权投资
    ,ii_other -- 利息收入:其他
    ,ii_other_debt_invest -- 利息收入:其他债权投资
    ,ii_other_fina_assets_ceirm -- 利息收入:其他按实际利率法计算的金融资产
    ,ii_fina_assets_calcu_eirm -- 利息收入:存放金融同业
    ,ii_lend_funds -- 利息收入:拆出资金
    ,ii_margin_trade -- 利息收入:融资融券业务
    ,ii_monet_funds_settl_provi -- 利息收入:货币资金及结算备付金
    ,ii_loans_recei -- 利息收入:贷款和应收款
    ,nhfci_other -- 手续费及佣金净收入:其他
    ,nhfci_fund_manag -- 手续费及佣金净收入:基金管理业务
    ,nhfci_invest_consul -- 手续费及佣金净收入:投资咨询业务
    ,nhfci_invest_bank -- 手续费及佣金净收入:投资银行业务
    ,nhfci_futur_broke -- 手续费及佣金净收入:期货经纪业务
    ,nhfci_secur_broke -- 手续费及佣金净收入:证券经纪业务
    ,nhfci_asset_manag -- 手续费及佣金净收入:资产管理业务
    ,hfci_other -- 手续费及佣金收入:其他
    ,hfci_fund_manag -- 手续费及佣金收入:基金管理业务
    ,hfci_invest_consul -- 手续费及佣金收入:投资咨询业务
    ,hfci_invest_bank -- 手续费及佣金收入:投资银行业务
    ,hfci_futur_broke -- 手续费及佣金收入:期货经纪业务
    ,hfci_secur_broke -- 手续费及佣金收入:证券经纪业务
    ,hfci_asset_manag -- 手续费及佣金收入:资产管理业务
    ,fs_hk_margin_fina_colla -- 融出证券:香港孖展融资担保物
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录通讯到用户端时间
    ,announcement_date -- 公告日期
    ,ed -- 截止日期
    ,net_capital -- 净资本
    ,nc_to_total_risk_reserve -- 净资本/各项风险资本准备之和
    ,net_capital_to_net_assets -- 净资本/净资产
    ,net_capital_to_liab -- 净资本/负债
    ,net_assets_to_liab -- 净资产/负债
    ,ss_equity_sec_etc_to_nc -- 自营权益类证券及证券衍生品/净资本
    ,ss_fixed_income_sec_to_nc -- 自营固定收益类证券/净资本
    ,total_risk_capital_reserve -- 各项风险资本准备之和
    ,entrusted_capital -- 受托资金
    ,net_capital_ratio -- 净资本比率
    ,self_operate_nb -- 自营国债
    ,self_operate_fund -- 自营基金
    ,self_operate_stock -- 自营股票
    ,self_operate_sec_sum -- 自营证券合计
    ,self_operate_cb -- 自营证可转债
    ,special_am_income -- 专项资产管理业务收入
    ,entrusted_am_scale -- 受托管理资产总规模
    ,directional_am_income -- 定向资产管理业务收入
    ,collective_am_income -- 集合资产管理业务收入
    ,net_stable_funding_ratio -- 净稳定资金率
    ,lcr -- 流动性覆盖率
    ,capital_leverage -- 资本杠杆率
    ,corp_code -- 公司代码
    ,ib_net_income -- 投资银行业务净收入
    ,si_net_income -- 证券投资业务净收入
    ,sb_net_income -- 证券经纪业务净收入
    ,am_net_income -- 资产管理业务净收入
    ,ib_income -- 投资银行业务收入
    ,si_income -- 证券投资业务收入
    ,sb_income -- 证券经纪业务收入
    ,am_income -- 资产管理业务收入
    ,fs_trade_fina_assets -- 融出证券:交易性金融资产
    ,fs_other_equity_instr_invest -- 融出证券:其他权益工具投资
    ,fs_impai_provi -- 融出证券:减值准备
    ,fs_avail_sale_fina_assets -- 融出证券:可供出售金融资产
    ,total_fs -- 融出证券总额
    ,fs_refin_secur_amo -- 融出证券:转融通融入证券
    ,total_ins_refin_secur_amo -- 融入证券:转融通融入证券总额
    ,ins_borr_secur -- 融入证券:借入证券
    ,total_ins -- 融入证券总额
    ,fs_borr_secur -- 融出证券:借入证券
    ,nii_pur_resale_fina_assets -- 利息净收入:买入返售金融资产
    ,nii_debt_invest -- 利息净收入:债权投资
    ,nii_other -- 利息净收入:其他
    ,nii_other_debt_invest -- 利息净收入:其他债权投资
    ,nii_other_fina_assets_ceirm -- 利息净收入:其他按实际利率法计算的金融资产
    ,nii_fina_assets_calcu_eirm -- 利息净收入:存放金融同业
    ,nii_lend_funds -- 利息净收入:拆出资金
    ,nii_margin_trade -- 利息净收入:融资融券业务
    ,nii_monet_funds_settl_provi -- 利息净收入:货币资金及结算备付金
    ,nii_loans_recei -- 利息净收入:贷款和应收款
    ,ii_purch_resale_fina_asset -- 利息收入:买入返售金融资产
    ,ii_debt_invest -- 利息收入:债权投资
    ,ii_other -- 利息收入:其他
    ,ii_other_debt_invest -- 利息收入:其他债权投资
    ,ii_other_fina_assets_ceirm -- 利息收入:其他按实际利率法计算的金融资产
    ,ii_fina_assets_calcu_eirm -- 利息收入:存放金融同业
    ,ii_lend_funds -- 利息收入:拆出资金
    ,ii_margin_trade -- 利息收入:融资融券业务
    ,ii_monet_funds_settl_provi -- 利息收入:货币资金及结算备付金
    ,ii_loans_recei -- 利息收入:贷款和应收款
    ,nhfci_other -- 手续费及佣金净收入:其他
    ,nhfci_fund_manag -- 手续费及佣金净收入:基金管理业务
    ,nhfci_invest_consul -- 手续费及佣金净收入:投资咨询业务
    ,nhfci_invest_bank -- 手续费及佣金净收入:投资银行业务
    ,nhfci_futur_broke -- 手续费及佣金净收入:期货经纪业务
    ,nhfci_secur_broke -- 手续费及佣金净收入:证券经纪业务
    ,nhfci_asset_manag -- 手续费及佣金净收入:资产管理业务
    ,hfci_other -- 手续费及佣金收入:其他
    ,hfci_fund_manag -- 手续费及佣金收入:基金管理业务
    ,hfci_invest_consul -- 手续费及佣金收入:投资咨询业务
    ,hfci_invest_bank -- 手续费及佣金收入:投资银行业务
    ,hfci_futur_broke -- 手续费及佣金收入:期货经纪业务
    ,hfci_secur_broke -- 手续费及佣金收入:证券经纪业务
    ,hfci_asset_manag -- 手续费及佣金收入:资产管理业务
    ,fs_hk_margin_fina_colla -- 融出证券:香港孖展融资担保物
    ,isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_sec_corp_main_indicators
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_sec_corp_main_indicators exchange partition p_${batch_date} with table ${iol_schema}.uxds_sec_corp_main_indicators_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_sec_corp_main_indicators to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_sec_corp_main_indicators_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_sec_corp_main_indicators',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);