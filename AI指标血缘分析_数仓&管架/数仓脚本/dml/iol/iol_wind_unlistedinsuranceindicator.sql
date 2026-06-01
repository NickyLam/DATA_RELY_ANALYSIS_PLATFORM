/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_unlistedinsuranceindicator
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
drop table ${iol_schema}.wind_unlistedinsuranceindicator_ex purge;
alter table ${iol_schema}.wind_unlistedinsuranceindicator add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_unlistedinsuranceindicator truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_unlistedinsuranceindicator_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_unlistedinsuranceindicator where 0=1;

insert /*+ append */ into ${iol_schema}.wind_unlistedinsuranceindicator_ex(
    object_id -- 对象ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,cap_adequacy_ratio_life -- 寿险：偿付能力充足率
    ,cap_adequacy_ratio_property -- 产险：偿付能力充足率
    ,surrender_rate -- 退保率
    ,policy_persistency_rate_13m -- 保单继续率-13个月
    ,policy_persistency_rate_25m -- 保单继续率-25个月
    ,policy_persistency_rate_14m -- 保单继续率-14个月
    ,policy_persistency_rate_26m -- 保单继续率-26个月
    ,net_investment_yield -- 净投资收益率
    ,total_investment_yield -- 总投资收益率
    ,risk_discount_rate -- 评估利率假设：风险贴现率
    ,combined_cost_property -- 产险：综合成本率
    ,loss_ratio_property -- 产险：赔付率
    ,fee_ratio_property -- 产险：费用率
    ,intrinsic_value_life -- 寿险：内含价值
    ,value_new_business_life -- 寿险：新业务价值
    ,value_effective_business_life -- 寿险：有效业务价值
    ,actual_capital_life -- 寿险：实际资本
    ,minimun_capital_life -- 寿险：最低资本
    ,actual_capital_property -- 产险：实际资本
    ,minimun_capital_property -- 产险：最低资本
    ,actual_capital_group -- 集团：实际资本
    ,minimun_capital_group -- 集团：最低资本
    ,capital_adequacy_ratio_group -- 集团：偿付能力充足率
    ,crncy_code -- 货币代码
    ,report_type -- 报告类型代码
    ,s_info_compcode -- 公司id
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,cap_adequacy_ratio_life -- 寿险：偿付能力充足率
    ,cap_adequacy_ratio_property -- 产险：偿付能力充足率
    ,surrender_rate -- 退保率
    ,policy_persistency_rate_13m -- 保单继续率-13个月
    ,policy_persistency_rate_25m -- 保单继续率-25个月
    ,policy_persistency_rate_14m -- 保单继续率-14个月
    ,policy_persistency_rate_26m -- 保单继续率-26个月
    ,net_investment_yield -- 净投资收益率
    ,total_investment_yield -- 总投资收益率
    ,risk_discount_rate -- 评估利率假设：风险贴现率
    ,combined_cost_property -- 产险：综合成本率
    ,loss_ratio_property -- 产险：赔付率
    ,fee_ratio_property -- 产险：费用率
    ,intrinsic_value_life -- 寿险：内含价值
    ,value_new_business_life -- 寿险：新业务价值
    ,value_effective_business_life -- 寿险：有效业务价值
    ,actual_capital_life -- 寿险：实际资本
    ,minimun_capital_life -- 寿险：最低资本
    ,actual_capital_property -- 产险：实际资本
    ,minimun_capital_property -- 产险：最低资本
    ,actual_capital_group -- 集团：实际资本
    ,minimun_capital_group -- 集团：最低资本
    ,capital_adequacy_ratio_group -- 集团：偿付能力充足率
    ,crncy_code -- 货币代码
    ,report_type -- 报告类型代码
    ,s_info_compcode -- 公司id
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_unlistedinsuranceindicator
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_unlistedinsuranceindicator exchange partition p_${batch_date} with table ${iol_schema}.wind_unlistedinsuranceindicator_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_unlistedinsuranceindicator to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_unlistedinsuranceindicator_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_unlistedinsuranceindicator',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);