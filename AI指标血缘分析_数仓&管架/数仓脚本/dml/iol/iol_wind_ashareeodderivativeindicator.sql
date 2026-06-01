/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareeodderivativeindicator
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
drop table ${iol_schema}.wind_ashareeodderivativeindicator_ex purge;
alter table ${iol_schema}.wind_ashareeodderivativeindicator add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_ashareeodderivativeindicator truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_ashareeodderivativeindicator_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareeodderivativeindicator where 0=1;

insert /*+ append */ into ${iol_schema}.wind_ashareeodderivativeindicator_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,trade_dt -- 交易日期
    ,crncy_code -- 货币代码
    ,s_val_mv -- 当日总市值
    ,s_dq_mv -- 当日流通市值
    ,s_pq_high_52w_ -- 52周最高价
    ,s_pq_low_52w_ -- 52周最低价
    ,s_val_pe -- 市盈率(PE)
    ,s_val_pb_new -- 市净率(PB)
    ,s_val_pe_ttm -- 市盈率(PE,TTM)
    ,s_val_pcf_ocf -- 市现率(PCF,经营现金流)
    ,s_val_pcf_ocfttm -- 市现率(PCF,经营现金流TTM)
    ,s_val_pcf_ncf -- 市现率(PCF,现金净流量)
    ,s_val_pcf_ncfttm -- 市现率(PCF,现金净流量TTM)
    ,s_val_ps -- 市销率(PS)
    ,s_val_ps_ttm -- 市销率(PS,TTM)
    ,s_dq_turn -- 换手率
    ,s_dq_freeturnover -- 换手率(基准.自由流通股本)
    ,tot_shr_today -- 当日总股本
    ,float_a_shr_today -- 当日流通股本
    ,s_dq_close_today -- 当日收盘价
    ,s_price_div_dps -- 股价/每股派息
    ,s_pq_adjhigh_52w -- 52周最高价(复权)
    ,s_pq_adjlow_52w -- 52周最低价(复权)
    ,free_shares_today -- 当日自由流通股本
    ,net_profit_parent_comp_ttm -- 归属母公司净利润(TTM)
    ,net_profit_parent_comp_lyr -- 归属母公司净利润(LYR)
    ,net_assets_today -- 当日净资产
    ,net_cash_flows_oper_act_ttm -- 经营活动产生的现金流量净额(TTM)
    ,net_cash_flows_oper_act_lyr -- 经营活动产生的现金流量净额(LYR)
    ,oper_rev_ttm -- 营业收入(TTM)
    ,oper_rev_lyr -- 营业收入(LYR)
    ,net_incr_cash_cash_equ_ttm -- 现金及现金等价物净增加额(TTM)
    ,net_incr_cash_cash_equ_lyr -- 现金及现金等价物净增加额(LYR)
    ,up_down_limit_status -- 涨跌停状态
    ,lowest_highest_status -- 最高最低价状态
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,trade_dt -- 交易日期
    ,crncy_code -- 货币代码
    ,s_val_mv -- 当日总市值
    ,s_dq_mv -- 当日流通市值
    ,s_pq_high_52w_ -- 52周最高价
    ,s_pq_low_52w_ -- 52周最低价
    ,s_val_pe -- 市盈率(PE)
    ,s_val_pb_new -- 市净率(PB)
    ,s_val_pe_ttm -- 市盈率(PE,TTM)
    ,s_val_pcf_ocf -- 市现率(PCF,经营现金流)
    ,s_val_pcf_ocfttm -- 市现率(PCF,经营现金流TTM)
    ,s_val_pcf_ncf -- 市现率(PCF,现金净流量)
    ,s_val_pcf_ncfttm -- 市现率(PCF,现金净流量TTM)
    ,s_val_ps -- 市销率(PS)
    ,s_val_ps_ttm -- 市销率(PS,TTM)
    ,s_dq_turn -- 换手率
    ,s_dq_freeturnover -- 换手率(基准.自由流通股本)
    ,tot_shr_today -- 当日总股本
    ,float_a_shr_today -- 当日流通股本
    ,s_dq_close_today -- 当日收盘价
    ,s_price_div_dps -- 股价/每股派息
    ,s_pq_adjhigh_52w -- 52周最高价(复权)
    ,s_pq_adjlow_52w -- 52周最低价(复权)
    ,free_shares_today -- 当日自由流通股本
    ,net_profit_parent_comp_ttm -- 归属母公司净利润(TTM)
    ,net_profit_parent_comp_lyr -- 归属母公司净利润(LYR)
    ,net_assets_today -- 当日净资产
    ,net_cash_flows_oper_act_ttm -- 经营活动产生的现金流量净额(TTM)
    ,net_cash_flows_oper_act_lyr -- 经营活动产生的现金流量净额(LYR)
    ,oper_rev_ttm -- 营业收入(TTM)
    ,oper_rev_lyr -- 营业收入(LYR)
    ,net_incr_cash_cash_equ_ttm -- 现金及现金等价物净增加额(TTM)
    ,net_incr_cash_cash_equ_lyr -- 现金及现金等价物净增加额(LYR)
    ,up_down_limit_status -- 涨跌停状态
    ,lowest_highest_status -- 最高最低价状态
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_ashareeodderivativeindicator
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_ashareeodderivativeindicator exchange partition p_${batch_date} with table ${iol_schema}.wind_ashareeodderivativeindicator_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareeodderivativeindicator to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_ashareeodderivativeindicator_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareeodderivativeindicator',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);