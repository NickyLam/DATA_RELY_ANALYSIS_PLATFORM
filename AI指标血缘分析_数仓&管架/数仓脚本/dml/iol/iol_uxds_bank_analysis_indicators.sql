/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_bank_analysis_indicators
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
drop table ${iol_schema}.uxds_bank_analysis_indicators_ex purge;
alter table ${iol_schema}.uxds_bank_analysis_indicators add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_bank_analysis_indicators;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_bank_analysis_indicators_ex nologging
compress
as
select * from ${iol_schema}.uxds_bank_analysis_indicators where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_bank_analysis_indicators_ex(
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录同步时间
    ,interest_recovery -- 利息回收率
    ,rwa_to_general_loan_ratio -- 加权风险资产/一般性贷款
    ,corp_code -- 公司代码/关联到corp_basic_info.org_id
    ,corp_name -- 企业名称
    ,ed -- 截止日期
    ,currency_code -- 货币代码
    ,total_assets -- 总资产
    ,net_assets -- 净资产
    ,interbank_storage -- 同业往来资产
    ,interest_earning_assets -- 生息资产
    ,market_venture_cap -- 市场风险资本
    ,interest_earning_assets_cv -- 生息资产(计算值)
    ,interest_earning_assets_value -- 生息资产是否公布值
    ,non_living_asset -- 非生息资产
    ,interest_bearing_liab -- 计息负债
    ,interest_bearing_liab_cv -- 计息负债(计算值)
    ,is_interest_bearing_liab_value -- 计息负债是否公布值
    ,non_interest_liab -- 非计息负债
    ,total_deposit_amt -- 存款总额
    ,total_loan_amt -- 贷款总额
    ,cash_inv_cfd -- 库存现金
    ,leverage_ratio -- 杠杆率
    ,prov_to_loan_ratio -- 拨贷比
    ,general_loan -- 一般性贷款
    ,recombine_loan -- 重组贷款
    ,overdue_loan -- 逾期贷款
    ,overdue_loan_ratio -- 逾期贷款占比
    ,bad_loan -- 不良贷款(NPLs)
    ,bad_loan_ratio -- 不良贷款比例
    ,overdue_loan_mrth_90d -- 90天以上逾期贷款
    ,loans_to_eassets_ratio -- 贷款总额/生息资产
    ,interbank_assets_ratio -- 同业往来资产/生息资产
    ,total_liab -- 总负债
    ,interbank_deposit_etc -- 同业往来负债
    ,deposit_to_ibl_ratio -- 存款总额/计息负债
    ,interbank_liab_ratio -- 同业往来负债/计息负债
    ,bank_wproduct_balance -- 银行理财产品余额
    ,loan_ratio_slc -- 单一最大客户贷款比例
    ,top10_customer_loan_ratio -- 最大十家客户贷款比例
    ,normal_asset -- 正常类资产
    ,normal_proportion -- 正常类占比
    ,special_mention_asset -- 关注类资产
    ,special_proportion -- 关注类占比
    ,substandard_asset -- 次级类资产
    ,substandard_proportion -- 次级类占比
    ,suspicious_asset -- 可疑类资产
    ,suspicious_proportion -- 可疑类占比
    ,loss_asset -- 损失类资产
    ,loss_proportion -- 损失类占比
    ,provision_coverage -- 拨备覆盖率
    ,loan_loss_reserve -- 贷款损失准备
    ,loan_loss_resr_cover_ratio -- 贷款损失准备充足率
    ,normal_loan_migration_rate -- 正常类贷款迁徙率
    ,focused_loan_migration_rate -- 关注类贷款迁徙率
    ,subprime_loan_migration_rate -- 次级类贷款迁徙率
    ,suspicious_loan_migration_rate -- 可疑类贷款迁徙率
    ,deposit_loan_ratio -- 存贷款比例
    ,deposit_and_loan_ratio_rmb -- 存贷款比例(人民币)
    ,deposit_and_loan_ratio_fc -- 存贷款比例(外币)
    ,lending_funds_ratio -- 拆入资金比例
    ,borrowing_funds_ratio -- 拆出资金比例
    ,provision_ratio_rmb -- 备付金比例(人民币)
    ,provision_ratio_fc -- 备付金比例(外币)
    ,mal_loan_ratio_rmb -- 中长期贷款比率(人民币)
    ,mal_loan_ratio_fc -- 中长期贷款比率(外币)
    ,st_asset_flow_ratio -- 短期资产流动性比例
    ,st_assets_liquid_ratio -- 短期资产流动性比例(人民币)
    ,st_asset_liquid_ratio_fc -- 短期资产流动性比例(外币)
    ,lcr -- 流动性覆盖率
    ,net_interest_margin -- 净息差
    ,net_interest_margin_cv -- 净息差计算值
    ,is_net_interest_margin_value -- 净息差是否公布值
    ,net_profit_margin -- 净利差
    ,np_margin_cv -- 净利差计算值
    ,is_np_margin_value -- 净利差是否公布值
    ,living_asset_avg_interest -- 生息资产平均利率
    ,interest_liab_avg_interest -- 付息负债平均利率
    ,non_interest_income -- 非利息收入
    ,non_interest_income_ratio -- 非利息收入占比
    ,cost_to_income_ratio -- 成本收入比
    ,net_capital -- 资本净额
    ,net_core_capital -- 核心资本净额
    ,net_primary_capital_net_amt -- 一级资本净额
    ,net_core_first_capital -- 核心一级资本净额
    ,capital_adequacy_ratio -- 资本充足率
    ,core_capital_adequacy_ratio -- 核心资本充足率
    ,first_capital_adequacy_ratio -- 一级资本充足率
    ,core_fc_adequacy_ratio -- 核心一级资本充足率
    ,wgt_risk_net_amt -- 加权风险资产净额
    ,rwa_to_total_asset_ratio -- 加权风险资产/总资产
    ,rwa_to_ear_asset_ratio -- 加权风险资产/生息资产
    ,rwa_to_total_loan_ratio -- 加权风险资产/贷款总额
    ,isvalid -- 是否有效/默认值为1
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录同步时间
    ,interest_recovery -- 利息回收率
    ,rwa_to_general_loan_ratio -- 加权风险资产/一般性贷款
    ,corp_code -- 公司代码/关联到corp_basic_info.org_id
    ,corp_name -- 企业名称
    ,ed -- 截止日期
    ,currency_code -- 货币代码
    ,total_assets -- 总资产
    ,net_assets -- 净资产
    ,interbank_storage -- 同业往来资产
    ,interest_earning_assets -- 生息资产
    ,market_venture_cap -- 市场风险资本
    ,interest_earning_assets_cv -- 生息资产(计算值)
    ,interest_earning_assets_value -- 生息资产是否公布值
    ,non_living_asset -- 非生息资产
    ,interest_bearing_liab -- 计息负债
    ,interest_bearing_liab_cv -- 计息负债(计算值)
    ,is_interest_bearing_liab_value -- 计息负债是否公布值
    ,non_interest_liab -- 非计息负债
    ,total_deposit_amt -- 存款总额
    ,total_loan_amt -- 贷款总额
    ,cash_inv_cfd -- 库存现金
    ,leverage_ratio -- 杠杆率
    ,prov_to_loan_ratio -- 拨贷比
    ,general_loan -- 一般性贷款
    ,recombine_loan -- 重组贷款
    ,overdue_loan -- 逾期贷款
    ,overdue_loan_ratio -- 逾期贷款占比
    ,bad_loan -- 不良贷款(NPLs)
    ,bad_loan_ratio -- 不良贷款比例
    ,overdue_loan_mrth_90d -- 90天以上逾期贷款
    ,loans_to_eassets_ratio -- 贷款总额/生息资产
    ,interbank_assets_ratio -- 同业往来资产/生息资产
    ,total_liab -- 总负债
    ,interbank_deposit_etc -- 同业往来负债
    ,deposit_to_ibl_ratio -- 存款总额/计息负债
    ,interbank_liab_ratio -- 同业往来负债/计息负债
    ,bank_wproduct_balance -- 银行理财产品余额
    ,loan_ratio_slc -- 单一最大客户贷款比例
    ,top10_customer_loan_ratio -- 最大十家客户贷款比例
    ,normal_asset -- 正常类资产
    ,normal_proportion -- 正常类占比
    ,special_mention_asset -- 关注类资产
    ,special_proportion -- 关注类占比
    ,substandard_asset -- 次级类资产
    ,substandard_proportion -- 次级类占比
    ,suspicious_asset -- 可疑类资产
    ,suspicious_proportion -- 可疑类占比
    ,loss_asset -- 损失类资产
    ,loss_proportion -- 损失类占比
    ,provision_coverage -- 拨备覆盖率
    ,loan_loss_reserve -- 贷款损失准备
    ,loan_loss_resr_cover_ratio -- 贷款损失准备充足率
    ,normal_loan_migration_rate -- 正常类贷款迁徙率
    ,focused_loan_migration_rate -- 关注类贷款迁徙率
    ,subprime_loan_migration_rate -- 次级类贷款迁徙率
    ,suspicious_loan_migration_rate -- 可疑类贷款迁徙率
    ,deposit_loan_ratio -- 存贷款比例
    ,deposit_and_loan_ratio_rmb -- 存贷款比例(人民币)
    ,deposit_and_loan_ratio_fc -- 存贷款比例(外币)
    ,lending_funds_ratio -- 拆入资金比例
    ,borrowing_funds_ratio -- 拆出资金比例
    ,provision_ratio_rmb -- 备付金比例(人民币)
    ,provision_ratio_fc -- 备付金比例(外币)
    ,mal_loan_ratio_rmb -- 中长期贷款比率(人民币)
    ,mal_loan_ratio_fc -- 中长期贷款比率(外币)
    ,st_asset_flow_ratio -- 短期资产流动性比例
    ,st_assets_liquid_ratio -- 短期资产流动性比例(人民币)
    ,st_asset_liquid_ratio_fc -- 短期资产流动性比例(外币)
    ,lcr -- 流动性覆盖率
    ,net_interest_margin -- 净息差
    ,net_interest_margin_cv -- 净息差计算值
    ,is_net_interest_margin_value -- 净息差是否公布值
    ,net_profit_margin -- 净利差
    ,np_margin_cv -- 净利差计算值
    ,is_np_margin_value -- 净利差是否公布值
    ,living_asset_avg_interest -- 生息资产平均利率
    ,interest_liab_avg_interest -- 付息负债平均利率
    ,non_interest_income -- 非利息收入
    ,non_interest_income_ratio -- 非利息收入占比
    ,cost_to_income_ratio -- 成本收入比
    ,net_capital -- 资本净额
    ,net_core_capital -- 核心资本净额
    ,net_primary_capital_net_amt -- 一级资本净额
    ,net_core_first_capital -- 核心一级资本净额
    ,capital_adequacy_ratio -- 资本充足率
    ,core_capital_adequacy_ratio -- 核心资本充足率
    ,first_capital_adequacy_ratio -- 一级资本充足率
    ,core_fc_adequacy_ratio -- 核心一级资本充足率
    ,wgt_risk_net_amt -- 加权风险资产净额
    ,rwa_to_total_asset_ratio -- 加权风险资产/总资产
    ,rwa_to_ear_asset_ratio -- 加权风险资产/生息资产
    ,rwa_to_total_loan_ratio -- 加权风险资产/贷款总额
    ,isvalid -- 是否有效/默认值为1
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_bank_analysis_indicators
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_bank_analysis_indicators exchange partition p_${batch_date} with table ${iol_schema}.uxds_bank_analysis_indicators_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_bank_analysis_indicators to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_bank_analysis_indicators_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_bank_analysis_indicators',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);