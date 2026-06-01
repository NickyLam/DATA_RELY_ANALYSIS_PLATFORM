/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cmfincome
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
drop table ${iol_schema}.wind_cmfincome_ex purge;
alter table ${iol_schema}.wind_cmfincome add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_cmfincome truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_cmfincome_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_cmfincome where 0=1;

insert /*+ append */ into ${iol_schema}.wind_cmfincome_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,sec_id -- 证券ID
    ,report_period -- 报告期
    ,ann_dt -- 公告日期
    ,is_list -- 是否上市后数据
    ,tot_inc -- 收入合计
    ,int_inc -- 利息收入合计
    ,cash_int_inc -- 存款利息收入
    ,bond_int_inc -- 债券利息收入
    ,abs_int_inc -- 资产支持证券利息收入
    ,repo_int_inc -- 买入返售证券收入
    ,other_int_inc -- 其他利息收入
    ,inv_inc -- 投资收益合计
    ,stock_inv_inc -- 股票差价收入
    ,bond_inv_inc -- 债券差价收入
    ,fund_inv_inc -- 证券买卖差价-基金
    ,abs_inv_inc -- 资产支持证券投资收益
    ,derivative_inv_inc -- 权证差价收入
    ,dvd_inc -- 股息收入
    ,change_fair_value -- 未实现利得
    ,exch_inc -- 汇兑收入
    ,other_inc -- 其它收入
    ,tot_exp -- 费用合计
    ,mgmt_exp -- 管理费
    ,cust_maint_exp -- 客户维护费
    ,custodian_exp -- 托管费
    ,selling_dist_exp -- 基金销售服务费
    ,trade_exp -- 交易费用
    ,int_exp -- 利息支出
    ,repo_exp -- 卖出回购证券支出
    ,other_exp -- 其他费用合计
    ,acct_exp -- 会计师费
    ,audit_exp -- 审计费用
    ,tot_profit -- 基金经营业绩
    ,inc_tax -- 所得税费用
    ,net_profit -- 净利润
    ,memo -- 备注
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,sec_id -- 证券ID
    ,report_period -- 报告期
    ,ann_dt -- 公告日期
    ,is_list -- 是否上市后数据
    ,tot_inc -- 收入合计
    ,int_inc -- 利息收入合计
    ,cash_int_inc -- 存款利息收入
    ,bond_int_inc -- 债券利息收入
    ,abs_int_inc -- 资产支持证券利息收入
    ,repo_int_inc -- 买入返售证券收入
    ,other_int_inc -- 其他利息收入
    ,inv_inc -- 投资收益合计
    ,stock_inv_inc -- 股票差价收入
    ,bond_inv_inc -- 债券差价收入
    ,fund_inv_inc -- 证券买卖差价-基金
    ,abs_inv_inc -- 资产支持证券投资收益
    ,derivative_inv_inc -- 权证差价收入
    ,dvd_inc -- 股息收入
    ,change_fair_value -- 未实现利得
    ,exch_inc -- 汇兑收入
    ,other_inc -- 其它收入
    ,tot_exp -- 费用合计
    ,mgmt_exp -- 管理费
    ,cust_maint_exp -- 客户维护费
    ,custodian_exp -- 托管费
    ,selling_dist_exp -- 基金销售服务费
    ,trade_exp -- 交易费用
    ,int_exp -- 利息支出
    ,repo_exp -- 卖出回购证券支出
    ,other_exp -- 其他费用合计
    ,acct_exp -- 会计师费
    ,audit_exp -- 审计费用
    ,tot_profit -- 基金经营业绩
    ,inc_tax -- 所得税费用
    ,net_profit -- 净利润
    ,memo -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_cmfincome
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_cmfincome exchange partition p_${batch_date} with table ${iol_schema}.wind_cmfincome_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cmfincome to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_cmfincome_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cmfincome',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);