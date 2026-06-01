/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_unlistedbankincome
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
drop table ${iol_schema}.wind_unlistedbankincome_ex purge;
alter table ${iol_schema}.wind_unlistedbankincome add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_unlistedbankincome truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_unlistedbankincome_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_unlistedbankincome where 0=1;

insert /*+ append */ into ${iol_schema}.wind_unlistedbankincome_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,ebit -- 息税前利润
    ,ebitda -- 息税折旧摊销前利润
    ,net_profit_after_ded_nr_lp -- 扣除非经常性损益后净利润
    ,net_profit_under_intl_acc_sta -- 国际会计准则净利润
    ,s_fa_eps_basic -- 基本每股收益
    ,s_fa_eps_diluted -- 稀释每股收益
    ,actual_ann_dt -- 实际公告日期
    ,oper_rev -- 营业收入
    ,net_int_inc -- 利息净收入
    ,int_inc -- 利息收入
    ,less_int_exp -- 减:利息支出
    ,net_handling_chrg_comm_inc -- 手续费及佣金净收入
    ,handling_chrg_comm_inc -- 手续费及佣金收入
    ,less_handling_chrg_comm_exp -- 减:手续费及佣金支出
    ,plus_net_invest_inc -- 加:投资净收益
    ,incl_inc_invest_assoc_jv_entp -- 其中：对联营企业和合营企业的投资收益
    ,plus_net_gain_chg_fv -- 加:公允价值变动净收益
    ,net_inc_other_ops -- 其他经营净收益
    ,plus_net_gain_fx_trans -- 加:汇兑净收益
    ,plus_net_inc_other_bus -- 加:其他业务净收益
    ,other_bus_inc -- 其他业务收入
    ,other_bus_cost -- 其他业务成本
    ,oper_exp -- 营业支出
    ,less_taxes_surcharges_ops -- 减:营业税金及附加
    ,less_gerl_admin_exp -- 减:管理费用
    ,less_impair_loss_assets -- 减:资产减值损失
    ,spe_bal_oper_profit -- 营业利润差额(特殊报表科目)
    ,tot_bal_oper_profit -- 营业利润差额(合计平衡项目)
    ,oper_profit -- 营业利润
    ,plus_non_oper_rev -- 加:营业外收入
    ,less_non_oper_exp -- 减：营业外支出
    ,il_net_loss_disp_noncur_asset -- 其中：减：非流动资产处置净损失
    ,spe_bal_tot_profit -- 利润总额差额(特殊报表科目)
    ,tot_bal_tot_profit -- 利润总额差额(合计平衡项目)
    ,tot_profit -- 利润总额
    ,inc_tax -- 所得税
    ,unconfirmed_invest_loss -- 未确认投资损失
    ,spe_bal_net_profit -- 净利润差额(特殊报表科目)
    ,tot_bal_net_profit -- 净利润差额(合计平衡项目)
    ,net_profit_incl_min_int_inc -- 净利润(含少数股东损益)
    ,net_profit_excl_min_int_inc -- 净利润(不含少数股东损益)
    ,other_compreh_inc -- 其他综合收益
    ,tot_compreh_inc -- 综合收益总额
    ,tot_compreh_inc_min_shrhldr -- 综合收益总额(少数股东)
    ,tot_compreh_inc_parent_comp -- 综合收益总额(母公司)
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,ebit -- 息税前利润
    ,ebitda -- 息税折旧摊销前利润
    ,net_profit_after_ded_nr_lp -- 扣除非经常性损益后净利润
    ,net_profit_under_intl_acc_sta -- 国际会计准则净利润
    ,s_fa_eps_basic -- 基本每股收益
    ,s_fa_eps_diluted -- 稀释每股收益
    ,actual_ann_dt -- 实际公告日期
    ,oper_rev -- 营业收入
    ,net_int_inc -- 利息净收入
    ,int_inc -- 利息收入
    ,less_int_exp -- 减:利息支出
    ,net_handling_chrg_comm_inc -- 手续费及佣金净收入
    ,handling_chrg_comm_inc -- 手续费及佣金收入
    ,less_handling_chrg_comm_exp -- 减:手续费及佣金支出
    ,plus_net_invest_inc -- 加:投资净收益
    ,incl_inc_invest_assoc_jv_entp -- 其中：对联营企业和合营企业的投资收益
    ,plus_net_gain_chg_fv -- 加:公允价值变动净收益
    ,net_inc_other_ops -- 其他经营净收益
    ,plus_net_gain_fx_trans -- 加:汇兑净收益
    ,plus_net_inc_other_bus -- 加:其他业务净收益
    ,other_bus_inc -- 其他业务收入
    ,other_bus_cost -- 其他业务成本
    ,oper_exp -- 营业支出
    ,less_taxes_surcharges_ops -- 减:营业税金及附加
    ,less_gerl_admin_exp -- 减:管理费用
    ,less_impair_loss_assets -- 减:资产减值损失
    ,spe_bal_oper_profit -- 营业利润差额(特殊报表科目)
    ,tot_bal_oper_profit -- 营业利润差额(合计平衡项目)
    ,oper_profit -- 营业利润
    ,plus_non_oper_rev -- 加:营业外收入
    ,less_non_oper_exp -- 减：营业外支出
    ,il_net_loss_disp_noncur_asset -- 其中：减：非流动资产处置净损失
    ,spe_bal_tot_profit -- 利润总额差额(特殊报表科目)
    ,tot_bal_tot_profit -- 利润总额差额(合计平衡项目)
    ,tot_profit -- 利润总额
    ,inc_tax -- 所得税
    ,unconfirmed_invest_loss -- 未确认投资损失
    ,spe_bal_net_profit -- 净利润差额(特殊报表科目)
    ,tot_bal_net_profit -- 净利润差额(合计平衡项目)
    ,net_profit_incl_min_int_inc -- 净利润(含少数股东损益)
    ,net_profit_excl_min_int_inc -- 净利润(不含少数股东损益)
    ,other_compreh_inc -- 其他综合收益
    ,tot_compreh_inc -- 综合收益总额
    ,tot_compreh_inc_min_shrhldr -- 综合收益总额(少数股东)
    ,tot_compreh_inc_parent_comp -- 综合收益总额(母公司)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_unlistedbankincome
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_unlistedbankincome exchange partition p_${batch_date} with table ${iol_schema}.wind_unlistedbankincome_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_unlistedbankincome to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_unlistedbankincome_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_unlistedbankincome',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);