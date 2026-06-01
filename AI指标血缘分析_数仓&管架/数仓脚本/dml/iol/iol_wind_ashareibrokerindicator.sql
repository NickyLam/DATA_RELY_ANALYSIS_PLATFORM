/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareibrokerindicator
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
drop table ${iol_schema}.wind_ashareibrokerindicator_ex purge;
alter table ${iol_schema}.wind_ashareibrokerindicator add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_ashareibrokerindicator truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_ashareibrokerindicator_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareibrokerindicator where 0=1;

insert /*+ append */ into ${iol_schema}.wind_ashareibrokerindicator_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,report_period -- 报告期
    ,ann_dt -- 公告日期
    ,statement_type -- 报表类型
    ,iflisted_data -- 是否上市后数据
    ,net_capital -- 净资本
    ,trusted_capital -- 受托资金
    ,net_gearing_ratio -- 净资本负债率(%)
    ,prop_equity_ratio -- 自营权益类证券比例
    ,longterm_invest_ratio -- 长期投资比例
    ,fixed_capital_ratio -- 固定资本比例
    ,fee_business_ratio -- 营业费用率
    ,total_capital_return -- 总资产收益率
    ,net_capital_yield -- 净资本收益率
    ,current_ratio -- 流动比率
    ,asset_liability_ratio -- 资产负债率
    ,asset_turnover_ratio -- 资产周转率
    ,net_capital_return -- 净资产收益率
    ,contingent_liability_ratio -- 或有负债(担保）比率
    ,prop_securities -- 自营证券
    ,treasury_bond -- 国债
    ,investment_funds -- 投资基金
    ,stocks -- 股票
    ,convertible_bond -- 可转债
    ,per_capita_profits -- 人均利润
    ,net_cap_total_riskprov -- 风险覆盖率
    ,net_cap_net_assets -- 净资本/净资产
    ,prop_equ_der_netcap -- 自营权益类证券及证券衍生品/净资本
    ,prop_fixedincome_netcap -- 自营固定收益类证券/净资本
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,report_period -- 报告期
    ,ann_dt -- 公告日期
    ,statement_type -- 报表类型
    ,iflisted_data -- 是否上市后数据
    ,net_capital -- 净资本
    ,trusted_capital -- 受托资金
    ,net_gearing_ratio -- 净资本负债率(%)
    ,prop_equity_ratio -- 自营权益类证券比例
    ,longterm_invest_ratio -- 长期投资比例
    ,fixed_capital_ratio -- 固定资本比例
    ,fee_business_ratio -- 营业费用率
    ,total_capital_return -- 总资产收益率
    ,net_capital_yield -- 净资本收益率
    ,current_ratio -- 流动比率
    ,asset_liability_ratio -- 资产负债率
    ,asset_turnover_ratio -- 资产周转率
    ,net_capital_return -- 净资产收益率
    ,contingent_liability_ratio -- 或有负债(担保）比率
    ,prop_securities -- 自营证券
    ,treasury_bond -- 国债
    ,investment_funds -- 投资基金
    ,stocks -- 股票
    ,convertible_bond -- 可转债
    ,per_capita_profits -- 人均利润
    ,net_cap_total_riskprov -- 风险覆盖率
    ,net_cap_net_assets -- 净资本/净资产
    ,prop_equ_der_netcap -- 自营权益类证券及证券衍生品/净资本
    ,prop_fixedincome_netcap -- 自营固定收益类证券/净资本
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_ashareibrokerindicator
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_ashareibrokerindicator exchange partition p_${batch_date} with table ${iol_schema}.wind_ashareibrokerindicator_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareibrokerindicator to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_ashareibrokerindicator_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareibrokerindicator',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);