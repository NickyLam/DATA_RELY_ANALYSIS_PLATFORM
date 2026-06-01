/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_unlistedbankindicator
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.wind_unlistedbankindicator_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_unlistedbankindicator;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_unlistedbankindicator_op purge;
drop table ${iol_schema}.wind_unlistedbankindicator_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_unlistedbankindicator_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_unlistedbankindicator where 0=1;

create table ${iol_schema}.wind_unlistedbankindicator_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_unlistedbankindicator where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_unlistedbankindicator_op(
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
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.ann_dt -- 公告日期
    ,n.report_period -- 报告期
    ,n.statement_type -- 报表类型
    ,n.crncy_code -- 货币代码
    ,n.capi_ade_ratio -- 资本充足率
    ,n.core_capi_ade_ratio -- 核心资本充足率
    ,n.npl_ratio -- 不良贷款比例
    ,n.loan_depo_ratio -- 存贷款比例
    ,n.loan_depo_ratio_rmb -- 存贷款比例(人民币)
    ,n.loan_depo_ratio_normb -- 存贷款比例(外币)
    ,n.st_asset_liq_ratio_rmb -- 短期资产流动性比例(人民币)
    ,n.st_asset_liq_ratio_normb -- 短期资产流动性比例(外币)
    ,n.loan_from_banks_ratio -- 拆入资金比例
    ,n.lend_to_banks_ratio -- 拆出资金比例
    ,n.largest_customer_loan -- 单一客户贷款比例
    ,n.top_ten_customer_loan -- 最大十家客户贷款比例
    ,n.total_loan -- 贷款总额
    ,n.total_deposit -- 存款总额
    ,n.loan_loss_provision -- 贷款呆账准备金
    ,n.bad_load_five_class -- 不良贷款余额（5级分类）
    ,n.npl_provision_coverage -- 不良贷款拨备覆盖率
    ,n.cost_income_ratio -- 成本收入比
    ,n.non_interest_margin -- 非利息收入占比
    ,n.net_capital -- 资本净额
    ,n.core_capi_net_amount -- 核心资本净额
    ,n.risk_weight_asset -- 加权风险资本净额
    ,n.interest_bearing_asset -- 生息资产
    ,n.interest_bearing_asset_comp -- 生息资产(计算值)
    ,n.interest_bearing_lia -- 计息负债
    ,n.interest_bearing_lia_comp -- 计息负债(计算值)
    ,n.non_interest_income -- 非利息收入
    ,n.noneaning_asset -- 非生息资产
    ,n.noneaning_lia -- 非计息负债
    ,n.net_interest_margin -- 净息差
    ,n.net_interest_margin_is_ann -- 净息差是否公布值
    ,n.net_interest_spread -- 净利差
    ,n.net_interest_spread_is_ann -- 净利差是否公布值
    ,n.overdue_loan -- 逾期贷款
    ,n.total_interest_income -- 总利息收入
    ,n.total_interest_exp -- 总利息支出
    ,n.cash_on_hand -- 库存现金
    ,n.longterm_loans_ratio_cny -- 中长期贷款比例（人民币）
    ,n.longterm_loans_ratio_fc -- 中长期贷款比例（外币）
    ,n.ibusiness_loan_ratio -- 国际商业借款比例
    ,n.interect_collection_ratio -- 利息回收率
    ,n.cash_reserve_ratio_cny -- 备付金比例（人民币）
    ,n.cash_reserve_ratio_fc -- 备付金比例（外币）
    ,n.overseas_funds_app_ratio -- 境外资金运用比例
    ,n.market_risk_capital -- 市场风险资本
    ,n.interest_bearing_asset_ifpub -- 生息资产是否是发布值
    ,n.interest_bearing_lia_ifpub -- 计息负债是否是发布值
    ,n.net_interest_margin_ifpub -- 净利差是否是发布值
    ,n.coretier1capi_ade_ratio -- 核心一级资本充足率
    ,n.s_info_compcode -- 公司id
    ,n.tier1capi_ade_ratio -- 一级资本充足率
    ,n.capi_ade_ratio_2013 -- 资本充足率(资本管理办法)
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_unlistedbankindicator_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.wind_unlistedbankindicator where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
            and o.report_period = n.report_period
            and o.statement_type = n.statement_type
            and o.s_info_compcode = n.s_info_compcode
where (
        o.object_id is null
        and o.report_period is null
        and o.statement_type is null
        and o.s_info_compcode is null
    )
    or (
        o.ann_dt <> n.ann_dt
        or o.crncy_code <> n.crncy_code
        or o.capi_ade_ratio <> n.capi_ade_ratio
        or o.core_capi_ade_ratio <> n.core_capi_ade_ratio
        or o.npl_ratio <> n.npl_ratio
        or o.loan_depo_ratio <> n.loan_depo_ratio
        or o.loan_depo_ratio_rmb <> n.loan_depo_ratio_rmb
        or o.loan_depo_ratio_normb <> n.loan_depo_ratio_normb
        or o.st_asset_liq_ratio_rmb <> n.st_asset_liq_ratio_rmb
        or o.st_asset_liq_ratio_normb <> n.st_asset_liq_ratio_normb
        or o.loan_from_banks_ratio <> n.loan_from_banks_ratio
        or o.lend_to_banks_ratio <> n.lend_to_banks_ratio
        or o.largest_customer_loan <> n.largest_customer_loan
        or o.top_ten_customer_loan <> n.top_ten_customer_loan
        or o.total_loan <> n.total_loan
        or o.total_deposit <> n.total_deposit
        or o.loan_loss_provision <> n.loan_loss_provision
        or o.bad_load_five_class <> n.bad_load_five_class
        or o.npl_provision_coverage <> n.npl_provision_coverage
        or o.cost_income_ratio <> n.cost_income_ratio
        or o.non_interest_margin <> n.non_interest_margin
        or o.net_capital <> n.net_capital
        or o.core_capi_net_amount <> n.core_capi_net_amount
        or o.risk_weight_asset <> n.risk_weight_asset
        or o.interest_bearing_asset <> n.interest_bearing_asset
        or o.interest_bearing_asset_comp <> n.interest_bearing_asset_comp
        or o.interest_bearing_lia <> n.interest_bearing_lia
        or o.interest_bearing_lia_comp <> n.interest_bearing_lia_comp
        or o.non_interest_income <> n.non_interest_income
        or o.noneaning_asset <> n.noneaning_asset
        or o.noneaning_lia <> n.noneaning_lia
        or o.net_interest_margin <> n.net_interest_margin
        or o.net_interest_margin_is_ann <> n.net_interest_margin_is_ann
        or o.net_interest_spread <> n.net_interest_spread
        or o.net_interest_spread_is_ann <> n.net_interest_spread_is_ann
        or o.overdue_loan <> n.overdue_loan
        or o.total_interest_income <> n.total_interest_income
        or o.total_interest_exp <> n.total_interest_exp
        or o.cash_on_hand <> n.cash_on_hand
        or o.longterm_loans_ratio_cny <> n.longterm_loans_ratio_cny
        or o.longterm_loans_ratio_fc <> n.longterm_loans_ratio_fc
        or o.ibusiness_loan_ratio <> n.ibusiness_loan_ratio
        or o.interect_collection_ratio <> n.interect_collection_ratio
        or o.cash_reserve_ratio_cny <> n.cash_reserve_ratio_cny
        or o.cash_reserve_ratio_fc <> n.cash_reserve_ratio_fc
        or o.overseas_funds_app_ratio <> n.overseas_funds_app_ratio
        or o.market_risk_capital <> n.market_risk_capital
        or o.interest_bearing_asset_ifpub <> n.interest_bearing_asset_ifpub
        or o.interest_bearing_lia_ifpub <> n.interest_bearing_lia_ifpub
        or o.net_interest_margin_ifpub <> n.net_interest_margin_ifpub
        or o.coretier1capi_ade_ratio <> n.coretier1capi_ade_ratio
        or o.tier1capi_ade_ratio <> n.tier1capi_ade_ratio
        or o.capi_ade_ratio_2013 <> n.capi_ade_ratio_2013
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_unlistedbankindicator_cl(
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
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_unlistedbankindicator_op(
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
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.ann_dt -- 公告日期
    ,o.report_period -- 报告期
    ,o.statement_type -- 报表类型
    ,o.crncy_code -- 货币代码
    ,o.capi_ade_ratio -- 资本充足率
    ,o.core_capi_ade_ratio -- 核心资本充足率
    ,o.npl_ratio -- 不良贷款比例
    ,o.loan_depo_ratio -- 存贷款比例
    ,o.loan_depo_ratio_rmb -- 存贷款比例(人民币)
    ,o.loan_depo_ratio_normb -- 存贷款比例(外币)
    ,o.st_asset_liq_ratio_rmb -- 短期资产流动性比例(人民币)
    ,o.st_asset_liq_ratio_normb -- 短期资产流动性比例(外币)
    ,o.loan_from_banks_ratio -- 拆入资金比例
    ,o.lend_to_banks_ratio -- 拆出资金比例
    ,o.largest_customer_loan -- 单一客户贷款比例
    ,o.top_ten_customer_loan -- 最大十家客户贷款比例
    ,o.total_loan -- 贷款总额
    ,o.total_deposit -- 存款总额
    ,o.loan_loss_provision -- 贷款呆账准备金
    ,o.bad_load_five_class -- 不良贷款余额（5级分类）
    ,o.npl_provision_coverage -- 不良贷款拨备覆盖率
    ,o.cost_income_ratio -- 成本收入比
    ,o.non_interest_margin -- 非利息收入占比
    ,o.net_capital -- 资本净额
    ,o.core_capi_net_amount -- 核心资本净额
    ,o.risk_weight_asset -- 加权风险资本净额
    ,o.interest_bearing_asset -- 生息资产
    ,o.interest_bearing_asset_comp -- 生息资产(计算值)
    ,o.interest_bearing_lia -- 计息负债
    ,o.interest_bearing_lia_comp -- 计息负债(计算值)
    ,o.non_interest_income -- 非利息收入
    ,o.noneaning_asset -- 非生息资产
    ,o.noneaning_lia -- 非计息负债
    ,o.net_interest_margin -- 净息差
    ,o.net_interest_margin_is_ann -- 净息差是否公布值
    ,o.net_interest_spread -- 净利差
    ,o.net_interest_spread_is_ann -- 净利差是否公布值
    ,o.overdue_loan -- 逾期贷款
    ,o.total_interest_income -- 总利息收入
    ,o.total_interest_exp -- 总利息支出
    ,o.cash_on_hand -- 库存现金
    ,o.longterm_loans_ratio_cny -- 中长期贷款比例（人民币）
    ,o.longterm_loans_ratio_fc -- 中长期贷款比例（外币）
    ,o.ibusiness_loan_ratio -- 国际商业借款比例
    ,o.interect_collection_ratio -- 利息回收率
    ,o.cash_reserve_ratio_cny -- 备付金比例（人民币）
    ,o.cash_reserve_ratio_fc -- 备付金比例（外币）
    ,o.overseas_funds_app_ratio -- 境外资金运用比例
    ,o.market_risk_capital -- 市场风险资本
    ,o.interest_bearing_asset_ifpub -- 生息资产是否是发布值
    ,o.interest_bearing_lia_ifpub -- 计息负债是否是发布值
    ,o.net_interest_margin_ifpub -- 净利差是否是发布值
    ,o.coretier1capi_ade_ratio -- 核心一级资本充足率
    ,o.s_info_compcode -- 公司id
    ,o.tier1capi_ade_ratio -- 一级资本充足率
    ,o.capi_ade_ratio_2013 -- 资本充足率(资本管理办法)
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_unlistedbankindicator_bk o
    left join ${iol_schema}.wind_unlistedbankindicator_op n
        on
            o.object_id = n.object_id
            and o.report_period = n.report_period
            and o.statement_type = n.statement_type
            and o.s_info_compcode = n.s_info_compcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_unlistedbankindicator;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_unlistedbankindicator exchange partition p_19000101 with table ${iol_schema}.wind_unlistedbankindicator_cl;
alter table ${iol_schema}.wind_unlistedbankindicator exchange partition p_20991231 with table ${iol_schema}.wind_unlistedbankindicator_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_unlistedbankindicator to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_unlistedbankindicator_op purge;
drop table ${iol_schema}.wind_unlistedbankindicator_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_unlistedbankindicator_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_unlistedbankindicator',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
