/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_wind_unlistedbankindicator
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
--alter table ${itl_schema}.mtl_wind_unlistedbankindicator drop partition p_${retain_day};
alter table ${itl_schema}.mtl_wind_unlistedbankindicator drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_wind_unlistedbankindicator add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_wind_unlistedbankindicator partition for (to_date('${batch_date}','yyyymmdd')) (
    object_id -- 对象ID
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
    ,net_interest_margin_is_ann -- 净息差是否公布值
    ,net_interest_spread -- 净利差
    ,net_interest_spread_is_ann -- 净利差是否公布值
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
    ,coretier1capi_ade_ratio -- 核心一级资本充足率
    ,s_info_compcode -- 公司id
    ,tier1capi_ade_ratio -- 一级资本充足率
    ,capi_ade_ratio_2013 -- 资本充足率(资本管理办法)
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(object_id), ' ') as object_id -- 对象ID
    ,nvl(trim(ann_dt), ' ') as ann_dt -- 公告日期
    ,nvl(trim(report_period), ' ') as report_period -- 报告期
    ,nvl(trim(statement_type), ' ') as statement_type -- 报表类型
    ,nvl(trim(crncy_code), ' ') as crncy_code -- 货币代码
    ,nvl(trim(capi_ade_ratio), 0) as capi_ade_ratio -- 资本充足率
    ,nvl(trim(core_capi_ade_ratio), 0) as core_capi_ade_ratio -- 核心资本充足率
    ,nvl(trim(npl_ratio), 0) as npl_ratio -- 不良贷款比例
    ,nvl(trim(loan_depo_ratio), 0) as loan_depo_ratio -- 存贷款比例
    ,nvl(trim(loan_depo_ratio_rmb), 0) as loan_depo_ratio_rmb -- 存贷款比例(人民币)
    ,nvl(trim(loan_depo_ratio_normb), 0) as loan_depo_ratio_normb -- 存贷款比例(外币)
    ,nvl(trim(st_asset_liq_ratio_rmb), 0) as st_asset_liq_ratio_rmb -- 短期资产流动性比例(人民币)
    ,nvl(trim(st_asset_liq_ratio_normb), 0) as st_asset_liq_ratio_normb -- 短期资产流动性比例(外币)
    ,nvl(trim(loan_from_banks_ratio), 0) as loan_from_banks_ratio -- 拆入资金比例
    ,nvl(trim(lend_to_banks_ratio), 0) as lend_to_banks_ratio -- 拆出资金比例
    ,nvl(trim(largest_customer_loan), 0) as largest_customer_loan -- 单一客户贷款比例
    ,nvl(trim(top_ten_customer_loan), 0) as top_ten_customer_loan -- 最大十家客户贷款比例
    ,nvl(trim(total_loan), 0) as total_loan -- 贷款总额
    ,nvl(trim(total_deposit), 0) as total_deposit -- 存款总额
    ,nvl(trim(loan_loss_provision), 0) as loan_loss_provision -- 贷款呆账准备金
    ,nvl(trim(bad_load_five_class), 0) as bad_load_five_class -- 不良贷款余额（5级分类）
    ,nvl(trim(npl_provision_coverage), 0) as npl_provision_coverage -- 不良贷款拨备覆盖率
    ,nvl(trim(cost_income_ratio), 0) as cost_income_ratio -- 成本收入比
    ,nvl(trim(non_interest_margin), 0) as non_interest_margin -- 非利息收入占比
    ,nvl(trim(net_capital), 0) as net_capital -- 资本净额
    ,nvl(trim(core_capi_net_amount), 0) as core_capi_net_amount -- 核心资本净额
    ,nvl(trim(risk_weight_asset), 0) as risk_weight_asset -- 加权风险资本净额
    ,nvl(trim(interest_bearing_asset), 0) as interest_bearing_asset -- 生息资产
    ,nvl(trim(interest_bearing_asset_comp), 0) as interest_bearing_asset_comp -- 生息资产(计算值)
    ,nvl(trim(interest_bearing_lia), 0) as interest_bearing_lia -- 计息负债
    ,nvl(trim(interest_bearing_lia_comp), 0) as interest_bearing_lia_comp -- 计息负债(计算值)
    ,nvl(trim(non_interest_income), 0) as non_interest_income -- 非利息收入
    ,nvl(trim(noneaning_asset), 0) as noneaning_asset -- 非生息资产
    ,nvl(trim(noneaning_lia), 0) as noneaning_lia -- 非计息负债
    ,nvl(trim(net_interest_margin), 0) as net_interest_margin -- 净息差
    ,nvl(trim(net_interest_margin_is_ann), 0) as net_interest_margin_is_ann -- 净息差是否公布值
    ,nvl(trim(net_interest_spread), 0) as net_interest_spread -- 净利差
    ,nvl(trim(net_interest_spread_is_ann), 0) as net_interest_spread_is_ann -- 净利差是否公布值
    ,nvl(trim(overdue_loan), 0) as overdue_loan -- 逾期贷款
    ,nvl(trim(total_interest_income), 0) as total_interest_income -- 总利息收入
    ,nvl(trim(total_interest_exp), 0) as total_interest_exp -- 总利息支出
    ,nvl(trim(cash_on_hand), 0) as cash_on_hand -- 库存现金
    ,nvl(trim(longterm_loans_ratio_cny), 0) as longterm_loans_ratio_cny -- 中长期贷款比例（人民币）
    ,nvl(trim(longterm_loans_ratio_fc), 0) as longterm_loans_ratio_fc -- 中长期贷款比例（外币）
    ,nvl(trim(ibusiness_loan_ratio), 0) as ibusiness_loan_ratio -- 国际商业借款比例
    ,nvl(trim(interect_collection_ratio), 0) as interect_collection_ratio -- 利息回收率
    ,nvl(trim(cash_reserve_ratio_cny), 0) as cash_reserve_ratio_cny -- 备付金比例（人民币）
    ,nvl(trim(cash_reserve_ratio_fc), 0) as cash_reserve_ratio_fc -- 备付金比例（外币）
    ,nvl(trim(overseas_funds_app_ratio), 0) as overseas_funds_app_ratio -- 境外资金运用比例
    ,nvl(trim(market_risk_capital), 0) as market_risk_capital -- 市场风险资本
    ,nvl(trim(interest_bearing_asset_ifpub), 0) as interest_bearing_asset_ifpub -- 生息资产是否是发布值
    ,nvl(trim(interest_bearing_lia_ifpub), 0) as interest_bearing_lia_ifpub -- 计息负债是否是发布值
    ,nvl(trim(net_interest_margin_ifpub), 0) as net_interest_margin_ifpub -- 净利差是否是发布值
    ,nvl(trim(coretier1capi_ade_ratio), 0) as coretier1capi_ade_ratio -- 核心一级资本充足率
    ,nvl(trim(s_info_compcode), ' ') as s_info_compcode -- 公司id
    ,nvl(trim(tier1capi_ade_ratio), 0) as tier1capi_ade_ratio -- 一级资本充足率
    ,nvl(trim(capi_ade_ratio_2013), 0) as capi_ade_ratio_2013 -- 资本充足率(资本管理办法)
    ,nvl(start_dt, null) as start_dt -- 开始时间
    ,nvl(end_dt, null) as end_dt -- 结束时间
    ,nvl(trim(id_mark), ' ') as id_mark -- 增删标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_wind_unlistedbankindicator
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_wind_unlistedbankindicator to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_wind_unlistedbankindicator',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);