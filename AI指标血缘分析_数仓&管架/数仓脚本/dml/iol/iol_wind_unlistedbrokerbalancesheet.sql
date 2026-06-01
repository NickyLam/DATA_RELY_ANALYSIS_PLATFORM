/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_unlistedbrokerbalancesheet
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
drop table ${iol_schema}.wind_unlistedbrokerbalancesheet_ex purge;
alter table ${iol_schema}.wind_unlistedbrokerbalancesheet add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_unlistedbrokerbalancesheet truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_unlistedbrokerbalancesheet_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_unlistedbrokerbalancesheet where 0=1;

insert /*+ append */ into ${iol_schema}.wind_unlistedbrokerbalancesheet_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,actual_ann_dt -- 实际公告日期
    ,monetary_cap -- 货币资金
    ,clients_cap_deposit -- 客户资金存款
    ,settle_rsrv -- 结算备付金
    ,clients_rsrv_settle -- 客户备付金
    ,loans_to_oth_banks -- 拆出资金
    ,tradable_fin_assets -- 交易性金融资产
    ,derivative_fin_assets -- 衍生金融资产
    ,red_monetary_cap_for_sale -- 买入返售金融资产
    ,int_rcv -- 应收利息
    ,mrgn_paid -- 存出保证金
    ,agency_bus_assets -- 代理业务资产
    ,fin_assets_avail_for_sale -- 可供出售金融资产
    ,held_to_mty_invest -- 持有至到期投资
    ,long_term_eqy_invest -- 长期股权投资
    ,fix_assets -- 固定资产
    ,intang_assets -- 无形资产
    ,incl_seat_fees_exchange -- 其中：交易席位费
    ,goodwill -- 商誉
    ,deferred_tax_assets -- 递延所得税资产
    ,invest_real_estate -- 投资性房地产
    ,oth_assets -- 其他资产
    ,spe_bal_assets -- 资产差额(特殊报表科目)
    ,tot_bal_assets -- 资产差额(合计平衡项目)
    ,tot_assets -- 资产总计
    ,st_borrow -- 短期借款
    ,incl_pledge_loan -- 其中：质押借款
    ,loans_oth_banks -- 拆入资金
    ,tradable_fin_liab -- 交易性金融负债
    ,derivative_fin_liab -- 衍生金融负债
    ,fund_sales_fin_assets_rp -- 卖出回购金融资产款
    ,acting_trading_sec -- 代理买卖证券款
    ,acting_uw_sec -- 代理承销证券款
    ,empl_ben_payable -- 应付职工薪酬
    ,taxes_surcharges_payable -- 应交税费
    ,int_payable -- 应付利息
    ,agency_bus_liab -- 代理业务负债
    ,lt_borrow -- 长期借款
    ,bonds_payable -- 应付债券
    ,deferred_tax_liab -- 延所得税负债
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
    ,clients_cap_deposit -- 客户资金存款
    ,settle_rsrv -- 结算备付金
    ,clients_rsrv_settle -- 客户备付金
    ,loans_to_oth_banks -- 拆出资金
    ,tradable_fin_assets -- 交易性金融资产
    ,derivative_fin_assets -- 衍生金融资产
    ,red_monetary_cap_for_sale -- 买入返售金融资产
    ,int_rcv -- 应收利息
    ,mrgn_paid -- 存出保证金
    ,agency_bus_assets -- 代理业务资产
    ,fin_assets_avail_for_sale -- 可供出售金融资产
    ,held_to_mty_invest -- 持有至到期投资
    ,long_term_eqy_invest -- 长期股权投资
    ,fix_assets -- 固定资产
    ,intang_assets -- 无形资产
    ,incl_seat_fees_exchange -- 其中：交易席位费
    ,goodwill -- 商誉
    ,deferred_tax_assets -- 递延所得税资产
    ,invest_real_estate -- 投资性房地产
    ,oth_assets -- 其他资产
    ,spe_bal_assets -- 资产差额(特殊报表科目)
    ,tot_bal_assets -- 资产差额(合计平衡项目)
    ,tot_assets -- 资产总计
    ,st_borrow -- 短期借款
    ,incl_pledge_loan -- 其中：质押借款
    ,loans_oth_banks -- 拆入资金
    ,tradable_fin_liab -- 交易性金融负债
    ,derivative_fin_liab -- 衍生金融负债
    ,fund_sales_fin_assets_rp -- 卖出回购金融资产款
    ,acting_trading_sec -- 代理买卖证券款
    ,acting_uw_sec -- 代理承销证券款
    ,empl_ben_payable -- 应付职工薪酬
    ,taxes_surcharges_payable -- 应交税费
    ,int_payable -- 应付利息
    ,agency_bus_liab -- 代理业务负债
    ,lt_borrow -- 长期借款
    ,bonds_payable -- 应付债券
    ,deferred_tax_liab -- 延所得税负债
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
from ${itl_schema}.wind_unlistedbrokerbalancesheet
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_unlistedbrokerbalancesheet exchange partition p_${batch_date} with table ${iol_schema}.wind_unlistedbrokerbalancesheet_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_unlistedbrokerbalancesheet to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_unlistedbrokerbalancesheet_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_unlistedbrokerbalancesheet',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);