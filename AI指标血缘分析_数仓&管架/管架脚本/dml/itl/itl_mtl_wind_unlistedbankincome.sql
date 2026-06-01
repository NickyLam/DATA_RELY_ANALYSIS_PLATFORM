/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_wind_unlistedbankincome
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.mtl_wind_unlistedbankincome drop partition p_${retain_day};
alter table ${itl_schema}.mtl_wind_unlistedbankincome drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_wind_unlistedbankincome add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_wind_unlistedbankincome partition for (to_date('${batch_date}','yyyymmdd')) (
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
    ,etl_timestamp -- ETL处理时间
)
select
     nvl(trim(object_id), ' ') as object_id -- 对象ID
    ,nvl(trim(s_info_compcode), ' ') as s_info_compcode -- 公司ID
    ,nvl(trim(ann_dt), ' ') as ann_dt -- 公告日期
    ,nvl(trim(report_period), ' ') as report_period -- 报告期
    ,nvl(trim(statement_type), ' ') as statement_type -- 报表类型代码
    ,nvl(trim(crncy_code), ' ') as crncy_code -- 货币代码
    ,nvl(trim(ebit), 0) as ebit -- 息税前利润
    ,nvl(trim(ebitda), 0) as ebitda -- 息税折旧摊销前利润
    ,nvl(trim(net_profit_after_ded_nr_lp), 0) as net_profit_after_ded_nr_lp -- 扣除非经常性损益后净利润
    ,nvl(trim(net_profit_under_intl_acc_sta), 0) as net_profit_under_intl_acc_sta -- 国际会计准则净利润
    ,nvl(trim(s_fa_eps_basic), 0) as s_fa_eps_basic -- 基本每股收益
    ,nvl(trim(s_fa_eps_diluted), 0) as s_fa_eps_diluted -- 稀释每股收益
    ,nvl(trim(actual_ann_dt), ' ') as actual_ann_dt -- 实际公告日期
    ,nvl(trim(oper_rev), 0) as oper_rev -- 营业收入
    ,nvl(trim(net_int_inc), 0) as net_int_inc -- 利息净收入
    ,nvl(trim(int_inc), 0) as int_inc -- 利息收入
    ,nvl(trim(less_int_exp), 0) as less_int_exp -- 减:利息支出
    ,nvl(trim(net_handling_chrg_comm_inc), 0) as net_handling_chrg_comm_inc -- 手续费及佣金净收入
    ,nvl(trim(handling_chrg_comm_inc), 0) as handling_chrg_comm_inc -- 手续费及佣金收入
    ,nvl(trim(less_handling_chrg_comm_exp), 0) as less_handling_chrg_comm_exp -- 减:手续费及佣金支出
    ,nvl(trim(plus_net_invest_inc), 0) as plus_net_invest_inc -- 加:投资净收益
    ,nvl(trim(incl_inc_invest_assoc_jv_entp), 0) as incl_inc_invest_assoc_jv_entp -- 其中：对联营企业和合营企业的投资收益
    ,nvl(trim(plus_net_gain_chg_fv), 0) as plus_net_gain_chg_fv -- 加:公允价值变动净收益
    ,nvl(trim(net_inc_other_ops), 0) as net_inc_other_ops -- 其他经营净收益
    ,nvl(trim(plus_net_gain_fx_trans), 0) as plus_net_gain_fx_trans -- 加:汇兑净收益
    ,nvl(trim(plus_net_inc_other_bus), 0) as plus_net_inc_other_bus -- 加:其他业务净收益
    ,nvl(trim(other_bus_inc), 0) as other_bus_inc -- 其他业务收入
    ,nvl(trim(other_bus_cost), 0) as other_bus_cost -- 其他业务成本
    ,nvl(trim(oper_exp), 0) as oper_exp -- 营业支出
    ,nvl(trim(less_taxes_surcharges_ops), 0) as less_taxes_surcharges_ops -- 减:营业税金及附加
    ,nvl(trim(less_gerl_admin_exp), 0) as less_gerl_admin_exp -- 减:管理费用
    ,nvl(trim(less_impair_loss_assets), 0) as less_impair_loss_assets -- 减:资产减值损失
    ,nvl(trim(spe_bal_oper_profit), 0) as spe_bal_oper_profit -- 营业利润差额(特殊报表科目)
    ,nvl(trim(tot_bal_oper_profit), 0) as tot_bal_oper_profit -- 营业利润差额(合计平衡项目)
    ,nvl(trim(oper_profit), 0) as oper_profit -- 营业利润
    ,nvl(trim(plus_non_oper_rev), 0) as plus_non_oper_rev -- 加:营业外收入
    ,nvl(trim(less_non_oper_exp), 0) as less_non_oper_exp -- 减：营业外支出
    ,nvl(trim(il_net_loss_disp_noncur_asset), 0) as il_net_loss_disp_noncur_asset -- 其中：减：非流动资产处置净损失
    ,nvl(trim(spe_bal_tot_profit), 0) as spe_bal_tot_profit -- 利润总额差额(特殊报表科目)
    ,nvl(trim(tot_bal_tot_profit), 0) as tot_bal_tot_profit -- 利润总额差额(合计平衡项目)
    ,nvl(trim(tot_profit), 0) as tot_profit -- 利润总额
    ,nvl(trim(inc_tax), 0) as inc_tax -- 所得税
    ,nvl(trim(unconfirmed_invest_loss), 0) as unconfirmed_invest_loss -- 未确认投资损失
    ,nvl(trim(spe_bal_net_profit), 0) as spe_bal_net_profit -- 净利润差额(特殊报表科目)
    ,nvl(trim(tot_bal_net_profit), 0) as tot_bal_net_profit -- 净利润差额(合计平衡项目)
    ,nvl(trim(net_profit_incl_min_int_inc), 0) as net_profit_incl_min_int_inc -- 净利润(含少数股东损益)
    ,nvl(trim(net_profit_excl_min_int_inc), 0) as net_profit_excl_min_int_inc -- 净利润(不含少数股东损益)
    ,nvl(trim(other_compreh_inc), 0) as other_compreh_inc -- 其他综合收益
    ,nvl(trim(tot_compreh_inc), 0) as tot_compreh_inc -- 综合收益总额
    ,nvl(trim(tot_compreh_inc_min_shrhldr), 0) as tot_compreh_inc_min_shrhldr -- 综合收益总额(少数股东)
    ,nvl(trim(tot_compreh_inc_parent_comp), 0) as tot_compreh_inc_parent_comp -- 综合收益总额(母公司)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_wind_unlistedbankincome
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_wind_unlistedbankincome to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_wind_unlistedbankincome',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);