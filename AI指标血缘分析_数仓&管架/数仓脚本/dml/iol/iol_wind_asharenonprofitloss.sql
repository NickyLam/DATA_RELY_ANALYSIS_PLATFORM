/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_asharenonprofitloss
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
drop table ${iol_schema}.wind_asharenonprofitloss_ex purge;
alter table ${iol_schema}.wind_asharenonprofitloss add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_asharenonprofitloss truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_asharenonprofitloss_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_asharenonprofitloss where 0=1;

insert /*+ append */ into ${iol_schema}.wind_asharenonprofitloss_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,crncy_code -- 货币代码
    ,non_current_gains_losses -- 非流动资产处置损益
    ,tax_return -- 税收返还减免
    ,government_subsidy -- 政府补助
    ,capital_occupation_fee -- 资金占用费
    ,consolidated_gains_losses -- 企业合并产生的损益
    ,non_assets_gains_losses -- 非货币性资产交换损益
    ,investment_gains_losses -- 委托投资损益
    ,impairment_assets -- 资产减值准备
    ,debt_restructuring -- 债务重组损益
    ,enterprise_restructuring -- 企业重组费用
    ,trading_price_unfair -- 交易价格显失公允产生的损益
    ,net_profit_loss_subsidiaries -- 同一控制下企业合并产生的子公司净损益
    ,expected_liabilities -- 预计负债产生的损益
    ,onoiae -- 其他营业外收支净额
    ,other_projects -- 其他项目
    ,non_recurring_gains_losses -- 非经常性损益项目小计
    ,income_tax_impact -- 所得税影响数
    ,profit_loss_shareholders -- 少数股东损益影响数
    ,non_recurring_gains_losses1 -- 非经常性损益项目合计
    ,s_fa_deductedprofittoprofit -- 扣除非经常损益后的净利润
    ,s_fa_deductedprofittoprofit1 -- 扣除非经常损益后的归属公司股东的净利润
    ,fairvalue_change_gains_losses -- 持有(或处置)交易性金融资产和负债产生的公允价值变动损益
    ,provision_impairment_reversed -- 单独进行监制测试的应收款项减值准备转回
    ,proceeds_loan -- 对外委托贷款取得的收益
    ,changes_real_estate_value -- 公允价值法计量的投资性房地产价值变动损益
    ,profit_loss_adjustment -- 法规要求一次性损益调整影响
    ,custody_fee_income -- 受托经营取得的托管费收入
    ,is_published -- 是否公布
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,crncy_code -- 货币代码
    ,non_current_gains_losses -- 非流动资产处置损益
    ,tax_return -- 税收返还减免
    ,government_subsidy -- 政府补助
    ,capital_occupation_fee -- 资金占用费
    ,consolidated_gains_losses -- 企业合并产生的损益
    ,non_assets_gains_losses -- 非货币性资产交换损益
    ,investment_gains_losses -- 委托投资损益
    ,impairment_assets -- 资产减值准备
    ,debt_restructuring -- 债务重组损益
    ,enterprise_restructuring -- 企业重组费用
    ,trading_price_unfair -- 交易价格显失公允产生的损益
    ,net_profit_loss_subsidiaries -- 同一控制下企业合并产生的子公司净损益
    ,expected_liabilities -- 预计负债产生的损益
    ,onoiae -- 其他营业外收支净额
    ,other_projects -- 其他项目
    ,non_recurring_gains_losses -- 非经常性损益项目小计
    ,income_tax_impact -- 所得税影响数
    ,profit_loss_shareholders -- 少数股东损益影响数
    ,non_recurring_gains_losses1 -- 非经常性损益项目合计
    ,s_fa_deductedprofittoprofit -- 扣除非经常损益后的净利润
    ,s_fa_deductedprofittoprofit1 -- 扣除非经常损益后的归属公司股东的净利润
    ,fairvalue_change_gains_losses -- 持有(或处置)交易性金融资产和负债产生的公允价值变动损益
    ,provision_impairment_reversed -- 单独进行监制测试的应收款项减值准备转回
    ,proceeds_loan -- 对外委托贷款取得的收益
    ,changes_real_estate_value -- 公允价值法计量的投资性房地产价值变动损益
    ,profit_loss_adjustment -- 法规要求一次性损益调整影响
    ,custody_fee_income -- 受托经营取得的托管费收入
    ,is_published -- 是否公布
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_asharenonprofitloss
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_asharenonprofitloss exchange partition p_${batch_date} with table ${iol_schema}.wind_asharenonprofitloss_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_asharenonprofitloss to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_asharenonprofitloss_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_asharenonprofitloss',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);