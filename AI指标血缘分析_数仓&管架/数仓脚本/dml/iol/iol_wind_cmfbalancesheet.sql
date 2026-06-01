/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cmfbalancesheet
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
drop table ${iol_schema}.wind_cmfbalancesheet_ex purge;
alter table ${iol_schema}.wind_cmfbalancesheet add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_cmfbalancesheet truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_cmfbalancesheet_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_cmfbalancesheet where 0=1;

insert /*+ append */ into ${iol_schema}.wind_cmfbalancesheet_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,sec_id -- 证券ID
    ,report_period -- 报告期
    ,ann_dt -- 公告日期
    ,is_list -- 是否上市后数据
    ,f_stm_bs -- 银行存款
    ,settle_rsrv -- 清算备付金
    ,mrgn_paid -- 交易保证金
    ,tradable_fin_assets -- 交易性金融资产
    ,stock_value -- 股票投资市值
    ,stock_cost -- 股票投资成本
    ,stock_add_value -- 股票投资估值增值
    ,fund_value -- 基金投资市值(基金投资)
    ,bond_value -- 债券投资市值
    ,abs_value -- 资产支持证券投资市值
    ,bond_cost -- 债券投资成本
    ,bond_add_value -- 债券投资估值增值
    ,govbond_cost -- 国债投资成本
    ,govbond_add_value -- 国债投资估值增值
    ,convertbond_cost -- 可转债投资成本
    ,convertbond_add_value -- 可转债投资估值增值
    ,derivative_fin_value -- 权证投资市值
    ,derivative_fin_cost -- 权证投资成本
    ,trade_rcv -- 应收证券交易清算款
    ,war_rcv -- 配股权证
    ,int_rcv -- 应收利息
    ,acct_rcv -- 应收帐款
    ,dvd_rcv -- 应收股利
    ,pur_rcv -- 应收申购款
    ,deferred_tax_assets -- 递延所得税资产
    ,oth_rcv -- 其他应收款项
    ,deferred_exp -- 待摊费用
    ,repo_rev -- 买入返售证券
    ,oth_assets -- 其他资产
    ,tot_assets -- 资产总计
    ,st_borrow -- 短期借款
    ,manage_payable -- 应付基金管理费
    ,trustee_payable -- 应付基金托管费
    ,sec_trade_payable -- 应付交易清算款
    ,acct_payable -- 应付帐款
    ,trade_payable -- 应付佣金
    ,oth_payable -- 其他应付款项
    ,right_payable -- 应付配股款
    ,rede_payable -- 应付赎回费
    ,rede_payable2 -- 应付赎回款
    ,repo_amount -- 卖出回购证券
    ,int_payable -- 应付利息
    ,rev_payable -- 应付收益
    ,notpaytax -- 未交税金
    ,acc_exp -- 预提费用
    ,deferred_tax_liab -- 递延所得税负债
    ,oth_liab -- 其他负债
    ,sell_exp -- 应付销售费用
    ,tradable_fin_liab -- 交易性金融负债
    ,derivative_fin_liab -- 衍生金融负债
    ,tot_liab -- 负债总额
    ,paidincapital -- 实收基金
    ,undistributed_et_inc -- 未分配收益
    ,unrealized_profit -- 未实现利得
    ,undistributed_profit -- 未分配利润
    ,unrealized_add_value -- 未实现估值增值
    ,holder_equity -- 持有人权益合计
    ,prt_netasset -- 基金资产净值
    ,tot_liab_shrhldr_eqy -- 负债及持有人权益合计
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
    ,f_stm_bs -- 银行存款
    ,settle_rsrv -- 清算备付金
    ,mrgn_paid -- 交易保证金
    ,tradable_fin_assets -- 交易性金融资产
    ,stock_value -- 股票投资市值
    ,stock_cost -- 股票投资成本
    ,stock_add_value -- 股票投资估值增值
    ,fund_value -- 基金投资市值(基金投资)
    ,bond_value -- 债券投资市值
    ,abs_value -- 资产支持证券投资市值
    ,bond_cost -- 债券投资成本
    ,bond_add_value -- 债券投资估值增值
    ,govbond_cost -- 国债投资成本
    ,govbond_add_value -- 国债投资估值增值
    ,convertbond_cost -- 可转债投资成本
    ,convertbond_add_value -- 可转债投资估值增值
    ,derivative_fin_value -- 权证投资市值
    ,derivative_fin_cost -- 权证投资成本
    ,trade_rcv -- 应收证券交易清算款
    ,war_rcv -- 配股权证
    ,int_rcv -- 应收利息
    ,acct_rcv -- 应收帐款
    ,dvd_rcv -- 应收股利
    ,pur_rcv -- 应收申购款
    ,deferred_tax_assets -- 递延所得税资产
    ,oth_rcv -- 其他应收款项
    ,deferred_exp -- 待摊费用
    ,repo_rev -- 买入返售证券
    ,oth_assets -- 其他资产
    ,tot_assets -- 资产总计
    ,st_borrow -- 短期借款
    ,manage_payable -- 应付基金管理费
    ,trustee_payable -- 应付基金托管费
    ,sec_trade_payable -- 应付交易清算款
    ,acct_payable -- 应付帐款
    ,trade_payable -- 应付佣金
    ,oth_payable -- 其他应付款项
    ,right_payable -- 应付配股款
    ,rede_payable -- 应付赎回费
    ,rede_payable2 -- 应付赎回款
    ,repo_amount -- 卖出回购证券
    ,int_payable -- 应付利息
    ,rev_payable -- 应付收益
    ,notpaytax -- 未交税金
    ,acc_exp -- 预提费用
    ,deferred_tax_liab -- 递延所得税负债
    ,oth_liab -- 其他负债
    ,sell_exp -- 应付销售费用
    ,tradable_fin_liab -- 交易性金融负债
    ,derivative_fin_liab -- 衍生金融负债
    ,tot_liab -- 负债总额
    ,paidincapital -- 实收基金
    ,undistributed_et_inc -- 未分配收益
    ,unrealized_profit -- 未实现利得
    ,undistributed_profit -- 未分配利润
    ,unrealized_add_value -- 未实现估值增值
    ,holder_equity -- 持有人权益合计
    ,prt_netasset -- 基金资产净值
    ,tot_liab_shrhldr_eqy -- 负债及持有人权益合计
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_cmfbalancesheet
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_cmfbalancesheet exchange partition p_${batch_date} with table ${iol_schema}.wind_cmfbalancesheet_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cmfbalancesheet to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_cmfbalancesheet_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cmfbalancesheet',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);