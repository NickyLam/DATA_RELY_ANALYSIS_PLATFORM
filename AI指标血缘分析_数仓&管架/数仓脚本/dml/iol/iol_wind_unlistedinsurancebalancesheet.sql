/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_unlistedinsurancebalancesheet
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
drop table ${iol_schema}.wind_unlistedinsurancebalancesheet_ex purge;
alter table ${iol_schema}.wind_unlistedinsurancebalancesheet add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_unlistedinsurancebalancesheet truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_unlistedinsurancebalancesheet_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_unlistedinsurancebalancesheet where 0=1;

insert /*+ append */ into ${iol_schema}.wind_unlistedinsurancebalancesheet_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,actual_ann_dt -- 实际公告日期
    ,monetary_cap -- 货币资金
    ,loans_to_oth_banks -- 拆出资金
    ,tradable_fin_assets -- 交易性金融资产
    ,derivative_fin_assets -- 衍生金融资产
    ,red_monetary_cap_for_sale -- 买入返售金融资产
    ,prem_rcv -- 应收保费
    ,int_rcv -- 应收利息
    ,subr_rec -- 应收代位追偿款
    ,payable_to_reinsurer -- 应付分保账款
    ,rcv_ceded_unearned_prem_rsrv -- 应收分保未到期责任准备金
    ,rcv_ceded_claim_rsrv -- 应收分保未决赔款准备金
    ,rcv_ceded_life_insur_rsrv -- 应收分保寿险责任准备金
    ,rcv_ceded_lt_health_insur_rsrv -- 应收分保长期健康险责任准备金
    ,insured_pledge_loan -- 保户质押贷款
    ,fin_assets_avail_for_sale -- 可供出售金融资产
    ,held_to_mty_invest -- 持有至到期投资
    ,long_term_eqy_invest -- 长期股权投资
    ,cap_mrgn_paid -- 存出资本保证金
    ,rcv_invest -- 应收款项类投资
    ,fix_assets -- 固定资产
    ,intang_assets -- 无形资产
    ,goodwill -- 商誉
    ,independent_acct_assets -- 独立账户资产
    ,deferred_tax_liab -- 递延所得税负债
    ,invest_real_estate -- 投资性房地产
    ,time_deposits -- 定期存款
    ,oth_assets -- 其他资产
    ,spe_bal_assets -- 资产差额(特殊报表科目)
    ,tot_bal_assets -- 资产差额(合计平衡项目)
    ,tot_assets -- 资产总计
    ,st_borrow -- 短期借款
    ,loans_oth_banks -- 拆入资金
    ,tradable_fin_liab -- 交易性金融负债
    ,fund_sales_fin_assets_rp -- 卖出回购金融资产款
    ,prem_received_adv -- 预收保费
    ,handling_charges_comm_payable -- 应付手续费及佣金
    ,empl_ben_payable -- 应付职工薪酬
    ,taxes_surcharges_payable -- 应交税费
    ,int_payable -- 应付利息
    ,claims_payable -- 应付赔付款
    ,dvd_payable_insured -- 应付保单红利
    ,deposit_received -- 存入保证金
    ,insured_deposit_invest -- 保户储金及投资款
    ,unearned_prem_rsrv -- 未到期责任准备金
    ,out_loss_rsrv -- 未决赔款准备金
    ,life_insur_rsrv -- 寿险责任准备金
    ,lt_health_insur_v -- 长期健康险责任准备金
    ,lt_borrow -- 长期借款
    ,bonds_payable -- 应付债券
    ,independent_acct_liab -- 独立账户负债
    ,deferred_tax_assets -- 递延所得税资产
    ,provisions -- 预计负债
    ,oth_liab -- 其他负债
    ,spe_bal_liab -- 负债差额(特殊报表科目)
    ,tot_bal_liab -- 负债差额(合计平衡项目)
    ,tot_liab -- 负债合计
    ,cap_stk -- 股本
    ,cap_rsrv -- 资本公积金
    ,less_tsy_stk -- 减：库存股
    ,surplus_rsrv -- 盈余公积金
    ,undistributed_profit -- 未分配利润
    ,prov_nom_risks -- 一般风险准备
    ,cnvd_diff_foreign_curr_stat -- 外币报表折算差额
    ,unconfirmed_invest_loss -- 未确认的投资损失
    ,spe_bal_shrhldr_eqy -- 股东权益差额(特殊报表科目)
    ,tot_bal_shrhldr_eqy -- 股东权益差额(合计平衡项目)
    ,minority_int -- 少数股东权益
    ,tot_shrhldr_eqy_excl_min_int -- 股东权益合计(不含少数股东权益)
    ,tot_shrhldr_eqy_incl_min_int -- 股东权益合计(含少数股东权益)
    ,spe_bal_liab_eqy -- 负债及股东权益差额(特殊报表项目)
    ,tot_bal_liab_eqy -- 负债及股东权益差额(合计平衡项目)
    ,tot_liab_shrhldr_eqy -- 负债及股东权益总计
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
    ,actual_ann_dt -- 实际公告日期
    ,monetary_cap -- 货币资金
    ,loans_to_oth_banks -- 拆出资金
    ,tradable_fin_assets -- 交易性金融资产
    ,derivative_fin_assets -- 衍生金融资产
    ,red_monetary_cap_for_sale -- 买入返售金融资产
    ,prem_rcv -- 应收保费
    ,int_rcv -- 应收利息
    ,subr_rec -- 应收代位追偿款
    ,payable_to_reinsurer -- 应付分保账款
    ,rcv_ceded_unearned_prem_rsrv -- 应收分保未到期责任准备金
    ,rcv_ceded_claim_rsrv -- 应收分保未决赔款准备金
    ,rcv_ceded_life_insur_rsrv -- 应收分保寿险责任准备金
    ,rcv_ceded_lt_health_insur_rsrv -- 应收分保长期健康险责任准备金
    ,insured_pledge_loan -- 保户质押贷款
    ,fin_assets_avail_for_sale -- 可供出售金融资产
    ,held_to_mty_invest -- 持有至到期投资
    ,long_term_eqy_invest -- 长期股权投资
    ,cap_mrgn_paid -- 存出资本保证金
    ,rcv_invest -- 应收款项类投资
    ,fix_assets -- 固定资产
    ,intang_assets -- 无形资产
    ,goodwill -- 商誉
    ,independent_acct_assets -- 独立账户资产
    ,deferred_tax_liab -- 递延所得税负债
    ,invest_real_estate -- 投资性房地产
    ,time_deposits -- 定期存款
    ,oth_assets -- 其他资产
    ,spe_bal_assets -- 资产差额(特殊报表科目)
    ,tot_bal_assets -- 资产差额(合计平衡项目)
    ,tot_assets -- 资产总计
    ,st_borrow -- 短期借款
    ,loans_oth_banks -- 拆入资金
    ,tradable_fin_liab -- 交易性金融负债
    ,fund_sales_fin_assets_rp -- 卖出回购金融资产款
    ,prem_received_adv -- 预收保费
    ,handling_charges_comm_payable -- 应付手续费及佣金
    ,empl_ben_payable -- 应付职工薪酬
    ,taxes_surcharges_payable -- 应交税费
    ,int_payable -- 应付利息
    ,claims_payable -- 应付赔付款
    ,dvd_payable_insured -- 应付保单红利
    ,deposit_received -- 存入保证金
    ,insured_deposit_invest -- 保户储金及投资款
    ,unearned_prem_rsrv -- 未到期责任准备金
    ,out_loss_rsrv -- 未决赔款准备金
    ,life_insur_rsrv -- 寿险责任准备金
    ,lt_health_insur_v -- 长期健康险责任准备金
    ,lt_borrow -- 长期借款
    ,bonds_payable -- 应付债券
    ,independent_acct_liab -- 独立账户负债
    ,deferred_tax_assets -- 递延所得税资产
    ,provisions -- 预计负债
    ,oth_liab -- 其他负债
    ,spe_bal_liab -- 负债差额(特殊报表科目)
    ,tot_bal_liab -- 负债差额(合计平衡项目)
    ,tot_liab -- 负债合计
    ,cap_stk -- 股本
    ,cap_rsrv -- 资本公积金
    ,less_tsy_stk -- 减：库存股
    ,surplus_rsrv -- 盈余公积金
    ,undistributed_profit -- 未分配利润
    ,prov_nom_risks -- 一般风险准备
    ,cnvd_diff_foreign_curr_stat -- 外币报表折算差额
    ,unconfirmed_invest_loss -- 未确认的投资损失
    ,spe_bal_shrhldr_eqy -- 股东权益差额(特殊报表科目)
    ,tot_bal_shrhldr_eqy -- 股东权益差额(合计平衡项目)
    ,minority_int -- 少数股东权益
    ,tot_shrhldr_eqy_excl_min_int -- 股东权益合计(不含少数股东权益)
    ,tot_shrhldr_eqy_incl_min_int -- 股东权益合计(含少数股东权益)
    ,spe_bal_liab_eqy -- 负债及股东权益差额(特殊报表项目)
    ,tot_bal_liab_eqy -- 负债及股东权益差额(合计平衡项目)
    ,tot_liab_shrhldr_eqy -- 负债及股东权益总计
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_unlistedinsurancebalancesheet
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_unlistedinsurancebalancesheet exchange partition p_${batch_date} with table ${iol_schema}.wind_unlistedinsurancebalancesheet_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_unlistedinsurancebalancesheet to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_unlistedinsurancebalancesheet_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_unlistedinsurancebalancesheet',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);