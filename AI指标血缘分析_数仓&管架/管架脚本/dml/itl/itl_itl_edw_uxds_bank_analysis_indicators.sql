/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_uxds_bank_analysis_indicators
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_uxds_bank_analysis_indicators drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_uxds_bank_analysis_indicators drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_uxds_bank_analysis_indicators add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_uxds_bank_analysis_indicators partition for (to_date('${batch_date}','yyyymmdd')) (
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
    ,bad_loan -- 不良贷款(npls)
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
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(seq), 0) as seq -- 记录唯一标识
    ,nvl(ctime, to_date('00010101', 'yyyymmdd')) as ctime -- 记录创建时间
    ,nvl(mtime, to_date('00010101', 'yyyymmdd')) as mtime -- 记录修改时间
    ,nvl(rtime, to_date('00010101', 'yyyymmdd')) as rtime -- 记录同步时间
    ,nvl(trim(interest_recovery), 0) as interest_recovery -- 利息回收率
    ,nvl(trim(rwa_to_general_loan_ratio), 0) as rwa_to_general_loan_ratio -- 加权风险资产/一般性贷款
    ,nvl(trim(corp_code), ' ') as corp_code -- 公司代码/关联到corp_basic_info.org_id
    ,nvl(trim(corp_name), ' ') as corp_name -- 企业名称
    ,nvl(ed, to_date('00010101', 'yyyymmdd')) as ed -- 截止日期
    ,nvl(trim(currency_code), ' ') as currency_code -- 货币代码
    ,nvl(trim(total_assets), 0) as total_assets -- 总资产
    ,nvl(trim(net_assets), 0) as net_assets -- 净资产
    ,nvl(trim(interbank_storage), 0) as interbank_storage -- 同业往来资产
    ,nvl(trim(interest_earning_assets), 0) as interest_earning_assets -- 生息资产
    ,nvl(trim(market_venture_cap), 0) as market_venture_cap -- 市场风险资本
    ,nvl(trim(interest_earning_assets_cv), 0) as interest_earning_assets_cv -- 生息资产(计算值)
    ,nvl(trim(interest_earning_assets_value), 0) as interest_earning_assets_value -- 生息资产是否公布值
    ,nvl(trim(non_living_asset), 0) as non_living_asset -- 非生息资产
    ,nvl(trim(interest_bearing_liab), 0) as interest_bearing_liab -- 计息负债
    ,nvl(trim(interest_bearing_liab_cv), 0) as interest_bearing_liab_cv -- 计息负债(计算值)
    ,nvl(trim(is_interest_bearing_liab_value), 0) as is_interest_bearing_liab_value -- 计息负债是否公布值
    ,nvl(trim(non_interest_liab), 0) as non_interest_liab -- 非计息负债
    ,nvl(trim(total_deposit_amt), 0) as total_deposit_amt -- 存款总额
    ,nvl(trim(total_loan_amt), 0) as total_loan_amt -- 贷款总额
    ,nvl(trim(cash_inv_cfd), 0) as cash_inv_cfd -- 库存现金
    ,nvl(trim(leverage_ratio), 0) as leverage_ratio -- 杠杆率
    ,nvl(trim(prov_to_loan_ratio), 0) as prov_to_loan_ratio -- 拨贷比
    ,nvl(trim(general_loan), 0) as general_loan -- 一般性贷款
    ,nvl(trim(recombine_loan), 0) as recombine_loan -- 重组贷款
    ,nvl(trim(overdue_loan), 0) as overdue_loan -- 逾期贷款
    ,nvl(trim(overdue_loan_ratio), 0) as overdue_loan_ratio -- 逾期贷款占比
    ,nvl(trim(bad_loan), 0) as bad_loan -- 不良贷款(npls)
    ,nvl(trim(bad_loan_ratio), 0) as bad_loan_ratio -- 不良贷款比例
    ,nvl(trim(overdue_loan_mrth_90d), 0) as overdue_loan_mrth_90d -- 90天以上逾期贷款
    ,nvl(trim(loans_to_eassets_ratio), 0) as loans_to_eassets_ratio -- 贷款总额/生息资产
    ,nvl(trim(interbank_assets_ratio), 0) as interbank_assets_ratio -- 同业往来资产/生息资产
    ,nvl(trim(total_liab), 0) as total_liab -- 总负债
    ,nvl(trim(interbank_deposit_etc), 0) as interbank_deposit_etc -- 同业往来负债
    ,nvl(trim(deposit_to_ibl_ratio), 0) as deposit_to_ibl_ratio -- 存款总额/计息负债
    ,nvl(trim(interbank_liab_ratio), 0) as interbank_liab_ratio -- 同业往来负债/计息负债
    ,nvl(trim(bank_wproduct_balance), 0) as bank_wproduct_balance -- 银行理财产品余额
    ,nvl(trim(loan_ratio_slc), 0) as loan_ratio_slc -- 单一最大客户贷款比例
    ,nvl(trim(top10_customer_loan_ratio), 0) as top10_customer_loan_ratio -- 最大十家客户贷款比例
    ,nvl(trim(normal_asset), 0) as normal_asset -- 正常类资产
    ,nvl(trim(normal_proportion), 0) as normal_proportion -- 正常类占比
    ,nvl(trim(special_mention_asset), 0) as special_mention_asset -- 关注类资产
    ,nvl(trim(special_proportion), 0) as special_proportion -- 关注类占比
    ,nvl(trim(substandard_asset), 0) as substandard_asset -- 次级类资产
    ,nvl(trim(substandard_proportion), 0) as substandard_proportion -- 次级类占比
    ,nvl(trim(suspicious_asset), 0) as suspicious_asset -- 可疑类资产
    ,nvl(trim(suspicious_proportion), 0) as suspicious_proportion -- 可疑类占比
    ,nvl(trim(loss_asset), 0) as loss_asset -- 损失类资产
    ,nvl(trim(loss_proportion), 0) as loss_proportion -- 损失类占比
    ,nvl(trim(provision_coverage), 0) as provision_coverage -- 拨备覆盖率
    ,nvl(trim(loan_loss_reserve), 0) as loan_loss_reserve -- 贷款损失准备
    ,nvl(trim(loan_loss_resr_cover_ratio), 0) as loan_loss_resr_cover_ratio -- 贷款损失准备充足率
    ,nvl(trim(normal_loan_migration_rate), 0) as normal_loan_migration_rate -- 正常类贷款迁徙率
    ,nvl(trim(focused_loan_migration_rate), 0) as focused_loan_migration_rate -- 关注类贷款迁徙率
    ,nvl(trim(subprime_loan_migration_rate), 0) as subprime_loan_migration_rate -- 次级类贷款迁徙率
    ,nvl(trim(suspicious_loan_migration_rate), 0) as suspicious_loan_migration_rate -- 可疑类贷款迁徙率
    ,nvl(trim(deposit_loan_ratio), 0) as deposit_loan_ratio -- 存贷款比例
    ,nvl(trim(deposit_and_loan_ratio_rmb), 0) as deposit_and_loan_ratio_rmb -- 存贷款比例(人民币)
    ,nvl(trim(deposit_and_loan_ratio_fc), 0) as deposit_and_loan_ratio_fc -- 存贷款比例(外币)
    ,nvl(trim(lending_funds_ratio), 0) as lending_funds_ratio -- 拆入资金比例
    ,nvl(trim(borrowing_funds_ratio), 0) as borrowing_funds_ratio -- 拆出资金比例
    ,nvl(trim(provision_ratio_rmb), 0) as provision_ratio_rmb -- 备付金比例(人民币)
    ,nvl(trim(provision_ratio_fc), 0) as provision_ratio_fc -- 备付金比例(外币)
    ,nvl(trim(mal_loan_ratio_rmb), 0) as mal_loan_ratio_rmb -- 中长期贷款比率(人民币)
    ,nvl(trim(mal_loan_ratio_fc), 0) as mal_loan_ratio_fc -- 中长期贷款比率(外币)
    ,nvl(trim(st_asset_flow_ratio), 0) as st_asset_flow_ratio -- 短期资产流动性比例
    ,nvl(trim(st_assets_liquid_ratio), 0) as st_assets_liquid_ratio -- 短期资产流动性比例(人民币)
    ,nvl(trim(st_asset_liquid_ratio_fc), 0) as st_asset_liquid_ratio_fc -- 短期资产流动性比例(外币)
    ,nvl(trim(lcr), 0) as lcr -- 流动性覆盖率
    ,nvl(trim(net_interest_margin), 0) as net_interest_margin -- 净息差
    ,nvl(trim(net_interest_margin_cv), 0) as net_interest_margin_cv -- 净息差计算值
    ,nvl(trim(is_net_interest_margin_value), 0) as is_net_interest_margin_value -- 净息差是否公布值
    ,nvl(trim(net_profit_margin), 0) as net_profit_margin -- 净利差
    ,nvl(trim(np_margin_cv), 0) as np_margin_cv -- 净利差计算值
    ,nvl(trim(is_np_margin_value), 0) as is_np_margin_value -- 净利差是否公布值
    ,nvl(trim(living_asset_avg_interest), 0) as living_asset_avg_interest -- 生息资产平均利率
    ,nvl(trim(interest_liab_avg_interest), 0) as interest_liab_avg_interest -- 付息负债平均利率
    ,nvl(trim(non_interest_income), 0) as non_interest_income -- 非利息收入
    ,nvl(trim(non_interest_income_ratio), 0) as non_interest_income_ratio -- 非利息收入占比
    ,nvl(trim(cost_to_income_ratio), 0) as cost_to_income_ratio -- 成本收入比
    ,nvl(trim(net_capital), 0) as net_capital -- 资本净额
    ,nvl(trim(net_core_capital), 0) as net_core_capital -- 核心资本净额
    ,nvl(trim(net_primary_capital_net_amt), 0) as net_primary_capital_net_amt -- 一级资本净额
    ,nvl(trim(net_core_first_capital), 0) as net_core_first_capital -- 核心一级资本净额
    ,nvl(trim(capital_adequacy_ratio), 0) as capital_adequacy_ratio -- 资本充足率
    ,nvl(trim(core_capital_adequacy_ratio), 0) as core_capital_adequacy_ratio -- 核心资本充足率
    ,nvl(trim(first_capital_adequacy_ratio), 0) as first_capital_adequacy_ratio -- 一级资本充足率
    ,nvl(trim(core_fc_adequacy_ratio), 0) as core_fc_adequacy_ratio -- 核心一级资本充足率
    ,nvl(trim(wgt_risk_net_amt), 0) as wgt_risk_net_amt -- 加权风险资产净额
    ,nvl(trim(rwa_to_total_asset_ratio), 0) as rwa_to_total_asset_ratio -- 加权风险资产/总资产
    ,nvl(trim(rwa_to_ear_asset_ratio), 0) as rwa_to_ear_asset_ratio -- 加权风险资产/生息资产
    ,nvl(trim(rwa_to_total_loan_ratio), 0) as rwa_to_total_loan_ratio -- 加权风险资产/贷款总额
    ,nvl(trim(isvalid), 0) as isvalid -- 是否有效/默认值为1
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_uxds_bank_analysis_indicators
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_uxds_bank_analysis_indicators to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_uxds_bank_analysis_indicators',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);