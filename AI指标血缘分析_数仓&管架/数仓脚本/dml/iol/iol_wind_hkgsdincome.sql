/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hkgsdincome
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
drop table ${iol_schema}.wind_hkgsdincome_ex purge;
alter table ${iol_schema}.wind_hkgsdincome add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_hkgsdincome truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_hkgsdincome_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_hkgsdincome where 0=1;

insert /*+ append */ into ${iol_schema}.wind_hkgsdincome_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,ann_dt -- 公告日期
    ,begin_dt -- 起始日期
    ,end_dt -- 截止日期
    ,report_type -- 报告类型代码
    ,statement_type -- 报表类型代码
    ,is_calc -- 是否计算值
    ,crncy_code -- 货币代码
    ,tot_oper_rev -- 总营业收入
    ,bus_inc -- 主营收入
    ,oth_bus_inc -- 其他营业收入
    ,rev_comm_inc -- 扣除贷款损失准备前收入
    ,prov_loan_loss -- 贷款损失准备
    ,premiums_earned -- 净已赚保费
    ,trade_inc_net -- 交易账户净收入
    ,int_inverst_inc -- 利息及股息收入
    ,rev_rent -- 租金收入
    ,tenant_reim_exp -- 租户认缴物业维护综合费
    ,gain_sale_real_estate -- 房地产销售收入
    ,mtg_inc -- 抵押贷款相关收入
    ,net_int_inc -- 利息净收入
    ,broker_comm_inc -- 经纪佣金收入
    ,uw_ib_inc -- 承销与投资银行费收入
    ,aum_inc -- 资产管理费收入
    ,trade_inc -- 自营业务收入
    ,net_fee_inc -- 手续费及佣金净收入
    ,fee_inc -- 手续费及佣金收入
    ,fee_exp -- 减：手续费及佣金开支
    ,premiums_inc -- 毛承保保费及保单费收入
    ,reserve_chg -- 减:未到期责任准备金变动
    ,premium_ceded -- 减:分出保费
    ,tot_oper_cost -- 总营业支出
    ,bus_cost -- 营业成本
    ,oper_exp -- 营业开支
    ,policy_int -- 保单持有人利益
    ,sga_exp -- 销售、行政及一般费用
    ,dist_exp -- 营销费用
    ,admin_exp -- 行政(管理)费用
    ,rd_exp -- 研发费用
    ,oth_bus_exp -- 其他营业费用合计
    ,opprofit -- 营业利润
    ,grossmargin -- 毛利
    ,int_inc -- 利息收入
    ,int_exp -- 利息支出
    ,invest_gain -- 权益性投资损益
    ,oth_nonpo_inc -- 其他非经营性损益
    ,nonrecuritem_bef_profits -- 非经常项目前利润
    ,unusual_items -- 非经常项目损益
    ,inc_pretax -- 除税前利润(除税前盈利)
    ,tax -- 所得税
    ,minority_int_inc -- 少数股东损益
    ,noncontinuous_net_op -- 持续经营净利润
    ,disc_oper -- 非持续经营净利润
    ,oth_spec_item -- 其他特殊项
    ,net_profit_cs -- 净利润
    ,dvd_pfd_adj -- 优先股利及其他调整项
    ,np_belongto_commonsh -- 归属普通股东净利润
    ,ci_belongto_commonsh -- 归属普通股东综合收益
    ,tot_ci -- 综合收益总值
    ,inc_afttax -- 除税后利润(除税后但未计少数股东权益之盈利)
    ,fairvalue_chg -- 公平值变动损益
    ,s_info_comptype -- 报告期公司类型代码
    ,s_memo -- 备注
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
    ,tot_oper_rev -- 总营业收入
    ,bus_inc -- 主营收入
    ,oth_bus_inc -- 其他营业收入
    ,rev_comm_inc -- 扣除贷款损失准备前收入
    ,prov_loan_loss -- 贷款损失准备
    ,premiums_earned -- 净已赚保费
    ,trade_inc_net -- 交易账户净收入
    ,int_inverst_inc -- 利息及股息收入
    ,rev_rent -- 租金收入
    ,tenant_reim_exp -- 租户认缴物业维护综合费
    ,gain_sale_real_estate -- 房地产销售收入
    ,mtg_inc -- 抵押贷款相关收入
    ,net_int_inc -- 利息净收入
    ,broker_comm_inc -- 经纪佣金收入
    ,uw_ib_inc -- 承销与投资银行费收入
    ,aum_inc -- 资产管理费收入
    ,trade_inc -- 自营业务收入
    ,net_fee_inc -- 手续费及佣金净收入
    ,fee_inc -- 手续费及佣金收入
    ,fee_exp -- 减：手续费及佣金开支
    ,premiums_inc -- 毛承保保费及保单费收入
    ,reserve_chg -- 减:未到期责任准备金变动
    ,premium_ceded -- 减:分出保费
    ,tot_oper_cost -- 总营业支出
    ,bus_cost -- 营业成本
    ,oper_exp -- 营业开支
    ,policy_int -- 保单持有人利益
    ,sga_exp -- 销售、行政及一般费用
    ,dist_exp -- 营销费用
    ,admin_exp -- 行政(管理)费用
    ,rd_exp -- 研发费用
    ,oth_bus_exp -- 其他营业费用合计
    ,opprofit -- 营业利润
    ,grossmargin -- 毛利
    ,int_inc -- 利息收入
    ,int_exp -- 利息支出
    ,invest_gain -- 权益性投资损益
    ,oth_nonpo_inc -- 其他非经营性损益
    ,nonrecuritem_bef_profits -- 非经常项目前利润
    ,unusual_items -- 非经常项目损益
    ,inc_pretax -- 除税前利润(除税前盈利)
    ,tax -- 所得税
    ,minority_int_inc -- 少数股东损益
    ,noncontinuous_net_op -- 持续经营净利润
    ,disc_oper -- 非持续经营净利润
    ,oth_spec_item -- 其他特殊项
    ,net_profit_cs -- 净利润
    ,dvd_pfd_adj -- 优先股利及其他调整项
    ,np_belongto_commonsh -- 归属普通股东净利润
    ,ci_belongto_commonsh -- 归属普通股东综合收益
    ,tot_ci -- 综合收益总值
    ,inc_afttax -- 除税后利润(除税后但未计少数股东权益之盈利)
    ,fairvalue_chg -- 公平值变动损益
    ,s_info_comptype -- 报告期公司类型代码
    ,s_memo -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_hkgsdincome
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_hkgsdincome exchange partition p_${batch_date} with table ${iol_schema}.wind_hkgsdincome_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hkgsdincome to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_hkgsdincome_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hkgsdincome',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);