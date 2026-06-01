/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_asharebankindicator
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
drop table ${iol_schema}.wind_asharebankindicator_ex purge;
alter table ${iol_schema}.wind_asharebankindicator add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_asharebankindicator truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_asharebankindicator_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_asharebankindicator where 0=1;

insert /*+ append */ into ${iol_schema}.wind_asharebankindicator_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,crncy_code -- 货币代码
    ,capi_ade_ratio -- 资本充足率
    ,core_capi_ade_ratio -- 核心资本充足率
    ,npl_ratio -- 不良贷款比例
    ,loan_depo_ratio -- 存贷款比例
    ,loan_depo_ratio_rmb -- 存贷款比例(人民币)
    ,loan_depo_ratio_normb -- 存贷款比例(外币)
    ,st_asset_liq_ratio_rmb -- 短期资产流动性比例(人民币)
    ,st_asset_liq_ratio_normb -- 短期资产流动性比例(外币)
    ,loan_from_banks_ratio -- 拆入资金比例
    ,lend_to_banks_ratio -- 拆出资金比例
    ,largest_customer_loan -- 单一客户贷款比例
    ,top_ten_customer_loan -- 最大十家客户贷款比例
    ,total_loan -- 贷款总额
    ,total_deposit -- 存款总额
    ,loan_loss_provision -- 贷款呆账准备金
    ,bad_load_five_class -- 不良贷款余额（5级分类）
    ,npl_provision_coverage -- 不良贷款拨备覆盖率
    ,cost_income_ratio -- 成本收入比
    ,non_interest_margin -- 非利息收入占比
    ,net_capital -- 资本净额
    ,core_capi_net_amount -- 核心资本净额
    ,risk_weight_asset -- 加权风险资本净额
    ,interest_bearing_asset -- 生息资产
    ,interest_bearing_asset_comp -- 生息资产(计算值)
    ,interest_bearing_lia -- 计息负债
    ,interest_bearing_lia_comp -- 计息负债(计算值)
    ,non_interest_income -- 非利息收入
    ,noneaning_asset -- 非生息资产
    ,noneaning_lia -- 非计息负债
    ,net_interest_margin -- 净息差
    ,net_interest_margin_is_ann -- 净息差(%)计算值
    ,net_interest_spread -- 净利差
    ,net_interest_spread_is_ann -- 净利差(%)计算值
    ,overdue_loan -- 逾期贷款
    ,total_interest_income -- 总利息收入
    ,total_interest_exp -- 总利息支出
    ,cash_on_hand -- 库存现金
    ,longterm_loans_ratio_cny -- 中长期贷款比例（人民币）
    ,longterm_loans_ratio_fc -- 中长期贷款比例（外币）
    ,ibusiness_loan_ratio -- 国际商业借款比例
    ,interect_collection_ratio -- 利息回收率
    ,cash_reserve_ratio_cny -- 备付金比例（人民币）
    ,cash_reserve_ratio_fc -- 备付金比例（外币）
    ,overseas_funds_app_ratio -- 境外资金运用比例
    ,market_risk_capital -- 市场风险资本
    ,interest_bearing_asset_ifpub -- 生息资产是否是发布值
    ,interest_bearing_lia_ifpub -- 计息负债是否是发布值
    ,net_interest_margin_ifpub -- 净利差是否是发布值
    ,loanreservesratio -- 贷款减值准备对贷款总额比率(%)
    ,subordinated_net_capi -- 附属资本净额
    ,int_bear_asset_avg_balance -- 生息资产平均余额
    ,int_bear_asset_avg_return -- 生息资产平均收益率(%)
    ,int_ccrued_liab_avg_balance -- 计息负债平均余额
    ,int_ccrued_liab_avg_costratio -- 计息负债平均成本率(%)
    ,rescheduledloans -- 已重组贷款
    ,coretier1_net_capi -- 核心一级资本净额
    ,tier1_net_capi -- 一级资本净额
    ,net_capital_2013 -- 资本净额(资本管理办法)
    ,coretier1capi_ade_ratio -- 核心一级资本充足率
    ,tier1capi_ade_ratio -- 一级资本充足率
    ,capi_ade_ratio_2013 -- 资本充足率(资本管理办法)
    ,risk_weight_net_asset_2013 -- 加权风险资产净额(资本管理办法)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,crncy_code -- 货币代码
    ,capi_ade_ratio -- 资本充足率
    ,core_capi_ade_ratio -- 核心资本充足率
    ,npl_ratio -- 不良贷款比例
    ,loan_depo_ratio -- 存贷款比例
    ,loan_depo_ratio_rmb -- 存贷款比例(人民币)
    ,loan_depo_ratio_normb -- 存贷款比例(外币)
    ,st_asset_liq_ratio_rmb -- 短期资产流动性比例(人民币)
    ,st_asset_liq_ratio_normb -- 短期资产流动性比例(外币)
    ,loan_from_banks_ratio -- 拆入资金比例
    ,lend_to_banks_ratio -- 拆出资金比例
    ,largest_customer_loan -- 单一客户贷款比例
    ,top_ten_customer_loan -- 最大十家客户贷款比例
    ,total_loan -- 贷款总额
    ,total_deposit -- 存款总额
    ,loan_loss_provision -- 贷款呆账准备金
    ,bad_load_five_class -- 不良贷款余额（5级分类）
    ,npl_provision_coverage -- 不良贷款拨备覆盖率
    ,cost_income_ratio -- 成本收入比
    ,non_interest_margin -- 非利息收入占比
    ,net_capital -- 资本净额
    ,core_capi_net_amount -- 核心资本净额
    ,risk_weight_asset -- 加权风险资本净额
    ,interest_bearing_asset -- 生息资产
    ,interest_bearing_asset_comp -- 生息资产(计算值)
    ,interest_bearing_lia -- 计息负债
    ,interest_bearing_lia_comp -- 计息负债(计算值)
    ,non_interest_income -- 非利息收入
    ,noneaning_asset -- 非生息资产
    ,noneaning_lia -- 非计息负债
    ,net_interest_margin -- 净息差
    ,net_interest_margin_is_ann -- 净息差(%)计算值
    ,net_interest_spread -- 净利差
    ,net_interest_spread_is_ann -- 净利差(%)计算值
    ,overdue_loan -- 逾期贷款
    ,total_interest_income -- 总利息收入
    ,total_interest_exp -- 总利息支出
    ,cash_on_hand -- 库存现金
    ,longterm_loans_ratio_cny -- 中长期贷款比例（人民币）
    ,longterm_loans_ratio_fc -- 中长期贷款比例（外币）
    ,ibusiness_loan_ratio -- 国际商业借款比例
    ,interect_collection_ratio -- 利息回收率
    ,cash_reserve_ratio_cny -- 备付金比例（人民币）
    ,cash_reserve_ratio_fc -- 备付金比例（外币）
    ,overseas_funds_app_ratio -- 境外资金运用比例
    ,market_risk_capital -- 市场风险资本
    ,interest_bearing_asset_ifpub -- 生息资产是否是发布值
    ,interest_bearing_lia_ifpub -- 计息负债是否是发布值
    ,net_interest_margin_ifpub -- 净利差是否是发布值
    ,loanreservesratio -- 贷款减值准备对贷款总额比率(%)
    ,subordinated_net_capi -- 附属资本净额
    ,int_bear_asset_avg_balance -- 生息资产平均余额
    ,int_bear_asset_avg_return -- 生息资产平均收益率(%)
    ,int_ccrued_liab_avg_balance -- 计息负债平均余额
    ,int_ccrued_liab_avg_costratio -- 计息负债平均成本率(%)
    ,rescheduledloans -- 已重组贷款
    ,coretier1_net_capi -- 核心一级资本净额
    ,tier1_net_capi -- 一级资本净额
    ,net_capital_2013 -- 资本净额(资本管理办法)
    ,coretier1capi_ade_ratio -- 核心一级资本充足率
    ,tier1capi_ade_ratio -- 一级资本充足率
    ,capi_ade_ratio_2013 -- 资本充足率(资本管理办法)
    ,risk_weight_net_asset_2013 -- 加权风险资产净额(资本管理办法)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_asharebankindicator
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_asharebankindicator exchange partition p_${batch_date} with table ${iol_schema}.wind_asharebankindicator_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_asharebankindicator to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_asharebankindicator_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_asharebankindicator',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);