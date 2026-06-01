/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_uxds_bank_special_fnncl_indicator
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
--alter table ${itl_schema}.itl_edw_uxds_bank_special_fnncl_indicator drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_uxds_bank_special_fnncl_indicator drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_uxds_bank_special_fnncl_indicator add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_uxds_bank_special_fnncl_indicator partition for (to_date('${batch_date}','yyyymmdd')) (
    seq -- 记录唯一标识
    ,ctime -- 记录创建日期
    ,mtime -- 记录修改日期
    ,rtime -- 记录通讯到用户端日期
    ,corp_code -- 公司代码/关联到corp_basic_info.org_id
    ,ed -- 截止日期/
    ,total_deposit_amt -- 存款总额/单位：元
    ,total_loan_amt -- 贷款总额/单位：元
    ,loan_loss_reserve -- 贷款损失准备/单位：元
    ,bad_loan_ratio -- 不良贷款率/单位：%
    ,capital_adequacy_ratio -- 资本充足率/单位：%
    ,core_capital_adequacy_ratio -- 核心资本充足率/单位：%；核心资本足率(％)= 核心资本净额／加权风险资产净额，《商业银行资本充足率管理办法》标准
    ,bad_loan -- 不良贷款/单位：元
    ,provision_coverage -- 拨备覆盖率/单位：%
    ,deposit_loan_ratio -- 存贷款比例/单位：%
    ,deposit_and_loan_ratio_rmb -- 存贷款比例(人民币)/单位：%
    ,deposit_and_loan_ratio_fc -- 存贷款比例(外币)/单位：%
    ,st_assets_liquid_ratio -- 短期资产流动性比例(人民币)/单位：%
    ,st_asset_liquid_ratio_fc -- 短期资产流动性比例(外币)/单位：%
    ,lending_funds_ratio -- 拆入资金比例/单位：%
    ,borrowing_funds_ratio -- 拆出资金比例/单位：%
    ,provision_ratio_rmb -- 备付金比例(人民币)/单位：%
    ,provision_ratio_fc -- 备付金比例(外币)/单位：%
    ,interest_recovery -- 利息回收率/单位：%
    ,net_interest_margin -- 净息差/单位：%
    ,non_interest_income_ratio -- 非利息收入占比/单位：%
    ,living_asset_avg_interest -- 生息资产平均利率（%）/单位：%
    ,interest_liab_avg_interest -- 付息负债平均利率（%）/单位：%
    ,loan_ratio_slc -- 单一最大客户贷款比例/单位：%
    ,cost_to_income_ratio -- 成本收入比/单位：%
    ,non_interest_liab -- 非计息负债/单位：元
    ,non_living_asset -- 非生息资产/单位：元
    ,net_core_capital -- 核心资本净额/单位：元；20130101之前为《商业银行资本充足率管理办法》标准，20130101开始为《商业银行资本管理办法(试行)》标准
    ,interest_bearing_liab -- 计息负债/单位：元
    ,interest_bearing_liab_cv -- 计息负债(计算值)/单位：元
    ,is_interest_bearing_liab_value -- 计息负债是否公布值/0：否；1：是
    ,wgt_risk_net_amt -- 加权风险资产净额/单位：元；20130101之前为《商业银行资本充足率管理办法》标准，20130101开始为《商业银行资本管理办法(试行)》标准
    ,net_profit_margin -- 净利差/单位：%
    ,net_interest_margin_cv -- 净息差(％)计算值/单位：%
    ,is_np_margin_value -- 净利差是否公布值/0：否；1：是
    ,np_margin_cv -- 净利差(％)计算值/单位：%
    ,is_net_interest_margin_value -- 净息差是否公布值/0：否；1：是
    ,interest_earning_assets -- 生息资产/单位：元
    ,interest_earning_assets_cv -- 生息资产(计算值)/单位：元
    ,interest_earning_assets_value -- 生息资产是否公布值/0：否；1：是
    ,market_venture_cap -- 市场风险资本/单位：元，《商业银行资本充足率管理办法》标准
    ,net_capital -- 资本净额/单位：元；20130101之前为《商业银行资本充足率管理办法》标准，20130101开始为《商业银行资本管理办法(试行)》标准
    ,top10_customer_loan_ratio -- 最大十家客户贷款比例/单位：%
    ,bad_loan_ratio_third_classi -- 不良贷款比例-3级分类/单位：%
    ,non_interest_income -- 非利息收入/单位：元
    ,cash_inv_cfd -- 库存现金/单位：元
    ,first_capital_adequacy_ratio -- 一级资本充足率/单位：%，《商业银行资本管理办法(试行)》标准，数据从20130101开始
    ,core_fc_adequacy_ratio -- 核心一级资本充足率/单位：%，《商业银行资本管理办法(试行)》标准，数据从20130101开始
    ,net_primary_capital_net_amt -- 一级资本净额/单位:元；《商业银行资本管理办法(试行)》标准，数据从20130101开始
    ,net_core_first_capital -- 核心一级资本净额/单位：元，《商业银行资本管理办法(试行)》标准，数据从20130101开始
    ,lcr -- 流动性覆盖率/单位：%
    ,leverage_ratio -- 杠杆率/单位：%
    ,overdue_loan -- 逾期贷款/单位：元
    ,overdue_loan_ratio -- 逾期贷款占比/单位：%
    ,overdue_loan_of_more_than_90d -- 90天以上逾期贷款/单位：元
    ,recombine_loan -- 重组贷款/单位：元
    ,normal_loan_migration_rate -- 正常类贷款迁徙率/单位：%
    ,focused_loan_migration_rate -- 关注类贷款迁徙率/单位：%
    ,subprime_loan_migration_rate -- 次级类贷款迁徙率/单位：%
    ,suspicious_loan_migration_rate -- 可疑类贷款迁徙率/单位：%
    ,mal_loan_ratio_fc -- 中长期贷款比率(外币)/单位：%
    ,mal_loan_ratio_rmb -- 中长期贷款比率(人民币)/单位：%
    ,currency_code -- 货币代码/关联到public_code_table.ctgry_code,public_code_table.class_encode=518
    ,st_asset_flow_ratio -- 短期资产流动性比例/单位：%
    ,normal_asset -- 正常类资产/单位:元
    ,normal_asset_ratio -- 正常类占比/公式:正常类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%
    ,special_mention_asset -- 关注类资产/单位:元
    ,special_mention_asset_ratio -- 关注类占比/公式:关注类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%
    ,sub_asset -- 次级类资产/单位:元
    ,sub_asset_ratio -- 次级类占比/公式:次级类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%
    ,doubtful_asset -- 可疑类资产/单位:元
    ,doubtful_asset_ratio -- 可疑类占比/公式:可疑类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%
    ,loss_asset -- 损失类资产/单位:元
    ,loss_asset_ratio -- 损失类占比/公式:损失类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%
    ,bank_wproduct_balance -- 银行理财产品余额/单位:元
    ,credit_card_credit_limit -- 信用卡信用额度/单位:元
    ,issue_guarantee_letter -- 开出保函/单位:元
    ,issue_credit_letter -- 开出信用证/单位:元
    ,adj_asset_balance -- 调整后的表内外资产余额/单位:元
    ,loan_commitment -- 贷款承诺/单位:元
    ,acceptance_bill -- 银行承兑汇票/单位:元
    ,credit_risk_wgt_asset -- 信用风险加权资产/单位:元
    ,net_stable_funds_ratio -- 净稳定资金比例/单位:%
    ,available_stable_funds_ratio -- 可用的稳定资金/单位:元
    ,market_risk_wgt_asset -- 市场风险加权资产/单位:元
    ,needed_stable_funds_ratio -- 所需的稳定资金/单位:元
    ,prov_to_loan_ratio -- 拨贷比/单位:%
    ,operational_risk_wgt_asset -- 操作风险加权资产/单位:元
    ,green_credit_balance -- 绿色信贷余额/单位:元
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(seq), 0) as seq -- 记录唯一标识
    ,nvl(ctime, to_date('00010101', 'yyyymmdd')) as ctime -- 记录创建日期
    ,nvl(mtime, to_date('00010101', 'yyyymmdd')) as mtime -- 记录修改日期
    ,nvl(rtime, to_date('00010101', 'yyyymmdd')) as rtime -- 记录通讯到用户端日期
    ,nvl(trim(corp_code), ' ') as corp_code -- 公司代码/关联到corp_basic_info.org_id
    ,nvl(ed, to_date('00010101', 'yyyymmdd')) as ed -- 截止日期/
    ,nvl(trim(total_deposit_amt), 0) as total_deposit_amt -- 存款总额/单位：元
    ,nvl(trim(total_loan_amt), 0) as total_loan_amt -- 贷款总额/单位：元
    ,nvl(trim(loan_loss_reserve), 0) as loan_loss_reserve -- 贷款损失准备/单位：元
    ,nvl(trim(bad_loan_ratio), 0) as bad_loan_ratio -- 不良贷款率/单位：%
    ,nvl(trim(capital_adequacy_ratio), 0) as capital_adequacy_ratio -- 资本充足率/单位：%
    ,nvl(trim(core_capital_adequacy_ratio), 0) as core_capital_adequacy_ratio -- 核心资本充足率/单位：%；核心资本足率(％)= 核心资本净额／加权风险资产净额，《商业银行资本充足率管理办法》标准
    ,nvl(trim(bad_loan), 0) as bad_loan -- 不良贷款/单位：元
    ,nvl(trim(provision_coverage), 0) as provision_coverage -- 拨备覆盖率/单位：%
    ,nvl(trim(deposit_loan_ratio), 0) as deposit_loan_ratio -- 存贷款比例/单位：%
    ,nvl(trim(deposit_and_loan_ratio_rmb), 0) as deposit_and_loan_ratio_rmb -- 存贷款比例(人民币)/单位：%
    ,nvl(trim(deposit_and_loan_ratio_fc), 0) as deposit_and_loan_ratio_fc -- 存贷款比例(外币)/单位：%
    ,nvl(trim(st_assets_liquid_ratio), 0) as st_assets_liquid_ratio -- 短期资产流动性比例(人民币)/单位：%
    ,nvl(trim(st_asset_liquid_ratio_fc), 0) as st_asset_liquid_ratio_fc -- 短期资产流动性比例(外币)/单位：%
    ,nvl(trim(lending_funds_ratio), 0) as lending_funds_ratio -- 拆入资金比例/单位：%
    ,nvl(trim(borrowing_funds_ratio), 0) as borrowing_funds_ratio -- 拆出资金比例/单位：%
    ,nvl(trim(provision_ratio_rmb), 0) as provision_ratio_rmb -- 备付金比例(人民币)/单位：%
    ,nvl(trim(provision_ratio_fc), 0) as provision_ratio_fc -- 备付金比例(外币)/单位：%
    ,nvl(trim(interest_recovery), 0) as interest_recovery -- 利息回收率/单位：%
    ,nvl(trim(net_interest_margin), 0) as net_interest_margin -- 净息差/单位：%
    ,nvl(trim(non_interest_income_ratio), 0) as non_interest_income_ratio -- 非利息收入占比/单位：%
    ,nvl(trim(living_asset_avg_interest), 0) as living_asset_avg_interest -- 生息资产平均利率（%）/单位：%
    ,nvl(trim(interest_liab_avg_interest), 0) as interest_liab_avg_interest -- 付息负债平均利率（%）/单位：%
    ,nvl(trim(loan_ratio_slc), 0) as loan_ratio_slc -- 单一最大客户贷款比例/单位：%
    ,nvl(trim(cost_to_income_ratio), 0) as cost_to_income_ratio -- 成本收入比/单位：%
    ,nvl(trim(non_interest_liab), 0) as non_interest_liab -- 非计息负债/单位：元
    ,nvl(trim(non_living_asset), 0) as non_living_asset -- 非生息资产/单位：元
    ,nvl(trim(net_core_capital), 0) as net_core_capital -- 核心资本净额/单位：元；20130101之前为《商业银行资本充足率管理办法》标准，20130101开始为《商业银行资本管理办法(试行)》标准
    ,nvl(trim(interest_bearing_liab), 0) as interest_bearing_liab -- 计息负债/单位：元
    ,nvl(trim(interest_bearing_liab_cv), 0) as interest_bearing_liab_cv -- 计息负债(计算值)/单位：元
    ,nvl(trim(is_interest_bearing_liab_value), 0) as is_interest_bearing_liab_value -- 计息负债是否公布值/0：否；1：是
    ,nvl(trim(wgt_risk_net_amt), 0) as wgt_risk_net_amt -- 加权风险资产净额/单位：元；20130101之前为《商业银行资本充足率管理办法》标准，20130101开始为《商业银行资本管理办法(试行)》标准
    ,nvl(trim(net_profit_margin), 0) as net_profit_margin -- 净利差/单位：%
    ,nvl(trim(net_interest_margin_cv), 0) as net_interest_margin_cv -- 净息差(％)计算值/单位：%
    ,nvl(trim(is_np_margin_value), 0) as is_np_margin_value -- 净利差是否公布值/0：否；1：是
    ,nvl(trim(np_margin_cv), 0) as np_margin_cv -- 净利差(％)计算值/单位：%
    ,nvl(trim(is_net_interest_margin_value), 0) as is_net_interest_margin_value -- 净息差是否公布值/0：否；1：是
    ,nvl(trim(interest_earning_assets), 0) as interest_earning_assets -- 生息资产/单位：元
    ,nvl(trim(interest_earning_assets_cv), 0) as interest_earning_assets_cv -- 生息资产(计算值)/单位：元
    ,nvl(trim(interest_earning_assets_value), 0) as interest_earning_assets_value -- 生息资产是否公布值/0：否；1：是
    ,nvl(trim(market_venture_cap), 0) as market_venture_cap -- 市场风险资本/单位：元，《商业银行资本充足率管理办法》标准
    ,nvl(trim(net_capital), 0) as net_capital -- 资本净额/单位：元；20130101之前为《商业银行资本充足率管理办法》标准，20130101开始为《商业银行资本管理办法(试行)》标准
    ,nvl(trim(top10_customer_loan_ratio), 0) as top10_customer_loan_ratio -- 最大十家客户贷款比例/单位：%
    ,nvl(trim(bad_loan_ratio_third_classi), 0) as bad_loan_ratio_third_classi -- 不良贷款比例-3级分类/单位：%
    ,nvl(trim(non_interest_income), 0) as non_interest_income -- 非利息收入/单位：元
    ,nvl(trim(cash_inv_cfd), 0) as cash_inv_cfd -- 库存现金/单位：元
    ,nvl(trim(first_capital_adequacy_ratio), 0) as first_capital_adequacy_ratio -- 一级资本充足率/单位：%，《商业银行资本管理办法(试行)》标准，数据从20130101开始
    ,nvl(trim(core_fc_adequacy_ratio), 0) as core_fc_adequacy_ratio -- 核心一级资本充足率/单位：%，《商业银行资本管理办法(试行)》标准，数据从20130101开始
    ,nvl(trim(net_primary_capital_net_amt), 0) as net_primary_capital_net_amt -- 一级资本净额/单位:元；《商业银行资本管理办法(试行)》标准，数据从20130101开始
    ,nvl(trim(net_core_first_capital), 0) as net_core_first_capital -- 核心一级资本净额/单位：元，《商业银行资本管理办法(试行)》标准，数据从20130101开始
    ,nvl(trim(lcr), 0) as lcr -- 流动性覆盖率/单位：%
    ,nvl(trim(leverage_ratio), 0) as leverage_ratio -- 杠杆率/单位：%
    ,nvl(trim(overdue_loan), 0) as overdue_loan -- 逾期贷款/单位：元
    ,nvl(trim(overdue_loan_ratio), 0) as overdue_loan_ratio -- 逾期贷款占比/单位：%
    ,nvl(trim(overdue_loan_of_more_than_90d), 0) as overdue_loan_of_more_than_90d -- 90天以上逾期贷款/单位：元
    ,nvl(trim(recombine_loan), 0) as recombine_loan -- 重组贷款/单位：元
    ,nvl(trim(normal_loan_migration_rate), 0) as normal_loan_migration_rate -- 正常类贷款迁徙率/单位：%
    ,nvl(trim(focused_loan_migration_rate), 0) as focused_loan_migration_rate -- 关注类贷款迁徙率/单位：%
    ,nvl(trim(subprime_loan_migration_rate), 0) as subprime_loan_migration_rate -- 次级类贷款迁徙率/单位：%
    ,nvl(trim(suspicious_loan_migration_rate), 0) as suspicious_loan_migration_rate -- 可疑类贷款迁徙率/单位：%
    ,nvl(trim(mal_loan_ratio_fc), 0) as mal_loan_ratio_fc -- 中长期贷款比率(外币)/单位：%
    ,nvl(trim(mal_loan_ratio_rmb), 0) as mal_loan_ratio_rmb -- 中长期贷款比率(人民币)/单位：%
    ,nvl(trim(currency_code), ' ') as currency_code -- 货币代码/关联到public_code_table.ctgry_code,public_code_table.class_encode=518
    ,nvl(trim(st_asset_flow_ratio), 0) as st_asset_flow_ratio -- 短期资产流动性比例/单位：%
    ,nvl(trim(normal_asset), 0) as normal_asset -- 正常类资产/单位:元
    ,nvl(trim(normal_asset_ratio), 0) as normal_asset_ratio -- 正常类占比/公式:正常类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%
    ,nvl(trim(special_mention_asset), 0) as special_mention_asset -- 关注类资产/单位:元
    ,nvl(trim(special_mention_asset_ratio), 0) as special_mention_asset_ratio -- 关注类占比/公式:关注类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%
    ,nvl(trim(sub_asset), 0) as sub_asset -- 次级类资产/单位:元
    ,nvl(trim(sub_asset_ratio), 0) as sub_asset_ratio -- 次级类占比/公式:次级类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%
    ,nvl(trim(doubtful_asset), 0) as doubtful_asset -- 可疑类资产/单位:元
    ,nvl(trim(doubtful_asset_ratio), 0) as doubtful_asset_ratio -- 可疑类占比/公式:可疑类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%
    ,nvl(trim(loss_asset), 0) as loss_asset -- 损失类资产/单位:元
    ,nvl(trim(loss_asset_ratio), 0) as loss_asset_ratio -- 损失类占比/公式:损失类资产/(正常类资产+关注类资产+次级类资产+可疑类资产+损失类资产)*100单位:%
    ,nvl(trim(bank_wproduct_balance), 0) as bank_wproduct_balance -- 银行理财产品余额/单位:元
    ,nvl(trim(credit_card_credit_limit), 0) as credit_card_credit_limit -- 信用卡信用额度/单位:元
    ,nvl(trim(issue_guarantee_letter), 0) as issue_guarantee_letter -- 开出保函/单位:元
    ,nvl(trim(issue_credit_letter), 0) as issue_credit_letter -- 开出信用证/单位:元
    ,nvl(trim(adj_asset_balance), 0) as adj_asset_balance -- 调整后的表内外资产余额/单位:元
    ,nvl(trim(loan_commitment), 0) as loan_commitment -- 贷款承诺/单位:元
    ,nvl(trim(acceptance_bill), 0) as acceptance_bill -- 银行承兑汇票/单位:元
    ,nvl(trim(credit_risk_wgt_asset), 0) as credit_risk_wgt_asset -- 信用风险加权资产/单位:元
    ,nvl(trim(net_stable_funds_ratio), 0) as net_stable_funds_ratio -- 净稳定资金比例/单位:%
    ,nvl(trim(available_stable_funds_ratio), 0) as available_stable_funds_ratio -- 可用的稳定资金/单位:元
    ,nvl(trim(market_risk_wgt_asset), 0) as market_risk_wgt_asset -- 市场风险加权资产/单位:元
    ,nvl(trim(needed_stable_funds_ratio), 0) as needed_stable_funds_ratio -- 所需的稳定资金/单位:元
    ,nvl(trim(prov_to_loan_ratio), 0) as prov_to_loan_ratio -- 拨贷比/单位:%
    ,nvl(trim(operational_risk_wgt_asset), 0) as operational_risk_wgt_asset -- 操作风险加权资产/单位:元
    ,nvl(trim(green_credit_balance), 0) as green_credit_balance -- 绿色信贷余额/单位:元
    ,nvl(trim(isvalid), 0) as isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_uxds_bank_special_fnncl_indicator
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_uxds_bank_special_fnncl_indicator to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_uxds_bank_special_fnncl_indicator',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);