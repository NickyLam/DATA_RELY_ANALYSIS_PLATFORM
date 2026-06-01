/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hkgsdcashflow
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
drop table ${iol_schema}.wind_hkgsdcashflow_ex purge;
alter table ${iol_schema}.wind_hkgsdcashflow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_hkgsdcashflow truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_hkgsdcashflow_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_hkgsdcashflow where 0=1;

insert /*+ append */ into ${iol_schema}.wind_hkgsdcashflow_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,ann_dt -- 公告日期
    ,begin_dt -- 起始日期
    ,end_dt -- 截止日期
    ,report_type -- 报告类型代码
    ,statement_type -- 报表类型代码
    ,is_calc -- 是否计算值
    ,crncy_code -- 货币代码
    ,net_cash_flows_oper_act -- 经营活动产生的现金流量净额
    ,net_profit_cs -- 净利润
    ,plus_net_da -- 折旧与摊销
    ,op_cap_change -- 营运资本变动
    ,oth_noncash_change -- 其他非现金调整
    ,net_cash_flows_inv_act -- 投资活动产生的现金流量净额
    ,cash_recp_fixasset_sell -- 出售固定资产收到的现金
    ,less_cap_expense -- 资本性支出
    ,less_inv_incr -- 投资增加
    ,inv_decr -- 投资减少
    ,net_oth_icf -- 其他投资活动产生的现金流量净额
    ,net_cash_flows_fund_act -- 筹资活动产生现金流量净额(融资活动产生的现金流量净额)
    ,debt_incr -- 债务增加
    ,less_debt_decr -- 债务减少
    ,cap_incr -- 股本增加
    ,plus_net_cap_decr -- 股本减少
    ,tot_div_paid -- 支付的股利合计
    ,net_oth_fcf -- 其他筹资活动产生的现金流量净额
    ,e_change_effect -- 汇率变动影响
    ,oth_cf_adjust -- 其他现金流量调整
    ,net_incr_cash_cash_equ -- 现金及现金等价物净增加额
    ,cash_cash_equ_beg_period -- 现金及现金等价物期初余额
    ,cash_cash_equ_end_period -- 现金及现金等价物期末余额
    ,s_meno -- 备注
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,ann_dt -- 公告日期
    ,begin_dt -- 起始日期
    ,end_dt -- 截止日期
    ,report_type -- 报告类型代码
    ,statement_type -- 报表类型代码
    ,is_calc -- 是否计算值
    ,crncy_code -- 货币代码
    ,net_cash_flows_oper_act -- 经营活动产生的现金流量净额
    ,net_profit_cs -- 净利润
    ,plus_net_da -- 折旧与摊销
    ,op_cap_change -- 营运资本变动
    ,oth_noncash_change -- 其他非现金调整
    ,net_cash_flows_inv_act -- 投资活动产生的现金流量净额
    ,cash_recp_fixasset_sell -- 出售固定资产收到的现金
    ,less_cap_expense -- 资本性支出
    ,less_inv_incr -- 投资增加
    ,inv_decr -- 投资减少
    ,net_oth_icf -- 其他投资活动产生的现金流量净额
    ,net_cash_flows_fund_act -- 筹资活动产生现金流量净额(融资活动产生的现金流量净额)
    ,debt_incr -- 债务增加
    ,less_debt_decr -- 债务减少
    ,cap_incr -- 股本增加
    ,plus_net_cap_decr -- 股本减少
    ,tot_div_paid -- 支付的股利合计
    ,net_oth_fcf -- 其他筹资活动产生的现金流量净额
    ,e_change_effect -- 汇率变动影响
    ,oth_cf_adjust -- 其他现金流量调整
    ,net_incr_cash_cash_equ -- 现金及现金等价物净增加额
    ,cash_cash_equ_beg_period -- 现金及现金等价物期初余额
    ,cash_cash_equ_end_period -- 现金及现金等价物期末余额
    ,s_meno -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_hkgsdcashflow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_hkgsdcashflow exchange partition p_${batch_date} with table ${iol_schema}.wind_hkgsdcashflow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hkgsdcashflow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_hkgsdcashflow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hkgsdcashflow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);