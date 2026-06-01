/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hkgsdbalancesheet
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
drop table ${iol_schema}.wind_hkgsdbalancesheet_ex purge;
alter table ${iol_schema}.wind_hkgsdbalancesheet add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_hkgsdbalancesheet truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_hkgsdbalancesheet_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_hkgsdbalancesheet where 0=1;

insert /*+ append */ into ${iol_schema}.wind_hkgsdbalancesheet_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,ann_dt -- 公告日期
    ,report_period -- 截至日期
    ,report_type -- 报告类型代码
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,tot_cur_assets -- 流动资产合计
    ,cash_cash_equ -- 现金及现金等价物
    ,tradable_fin_assets -- 短期投资(交易性金融资产)
    ,oth_short_inv -- 其他短期投资
    ,ar_total -- 应收款项合计
    ,stm_bs -- 应收账款及票据
    ,oth_rcv -- 其他应收款
    ,inventories -- 存货
    ,oth_cur_assets -- 其他流动资产合计
    ,non_cur_assets -- 非流动资产合计
    ,net_oth_fix_assets -- 固定资产净值
    ,equity_inv -- 权益性投资
    ,held_to_mty_invest -- 持有至到期投资
    ,avail_for_sale_inv -- 可供出售投资
    ,oth_long_inv -- 其他长期投资
    ,goodwill_intang_assets -- 商誉及无形资产
    ,goodwill -- 其中:商誉
    ,right_land_usage -- [内部]租赁土地
    ,oth_noncurrent_assets -- 其他非流动资产合计
    ,tot_assets -- 总资产
    ,cur_liab -- 流动负债合计
    ,ap_note -- 应付账款及票据
    ,taxes_surcharges_payable -- 应交税金
    ,tradable_fin_liab -- 交易性金融负债
    ,stloans_ltloans_curdue -- 短期借贷及长期借贷当期到期部分
    ,oth_cur_liab -- 其他流动负债
    ,non_cur_liab -- 非流动负债合计
    ,lt_borrow -- 长期借贷
    ,oth_non_cur_liab -- 其他非流动负债合计
    ,total_liabilities -- 总负债
    ,prfshare -- 优先股
    ,comshare -- 普通股股本(股本)
    ,reserve -- 储备
    ,premium_stock -- 股本溢价
    ,retained_earn -- 留存收益
    ,oth_reserve -- 其他储备
    ,treasuryshare -- 库存股
    ,oth_com_income -- 其他综合性收益
    ,tot_com_equity -- 普通股权益总额
    ,parsh_int -- 股东权益
    ,minority_int -- 少数股东权益
    ,tot_shrhldr_eqy -- 股东权益合计
    ,tot_liab_eqy -- 总负债及总权益
    ,cash_inter_bal -- 现金及同业结存
    ,due_bank -- 存放同业
    ,net_loans -- 客户贷款及垫款净额
    ,deposit_bank -- 银行同业存款
    ,funds_lent -- 拆出资金
    ,mort_sec -- 抵押担保证券
    ,sale_loan -- 可供出售贷款
    ,tot_deposits -- 总存款
    ,loans_oth_banks -- 拆入资金
    ,secured_fin -- 抵押担保融资
    ,reinsur_pay -- 应付再保
    ,reinsur_rece -- 应收再保
    ,insur_pre_rec -- 应收保费
    ,defer_cost -- 递延保单获得成本
    ,insur_liab -- 保险合同负债
    ,invest_liab -- 投资合同负债
    ,oth_inv -- 其他投资
    ,oth_assets -- 其他资产
    ,oth_liab -- 其他负债
    ,s_info_comptype -- 报告期公司类型代码
    ,s_memo -- 备注
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,ann_dt -- 公告日期
    ,report_period -- 截至日期
    ,report_type -- 报告类型代码
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,tot_cur_assets -- 流动资产合计
    ,cash_cash_equ -- 现金及现金等价物
    ,tradable_fin_assets -- 短期投资(交易性金融资产)
    ,oth_short_inv -- 其他短期投资
    ,ar_total -- 应收款项合计
    ,stm_bs -- 应收账款及票据
    ,oth_rcv -- 其他应收款
    ,inventories -- 存货
    ,oth_cur_assets -- 其他流动资产合计
    ,non_cur_assets -- 非流动资产合计
    ,net_oth_fix_assets -- 固定资产净值
    ,equity_inv -- 权益性投资
    ,held_to_mty_invest -- 持有至到期投资
    ,avail_for_sale_inv -- 可供出售投资
    ,oth_long_inv -- 其他长期投资
    ,goodwill_intang_assets -- 商誉及无形资产
    ,goodwill -- 其中:商誉
    ,right_land_usage -- [内部]租赁土地
    ,oth_noncurrent_assets -- 其他非流动资产合计
    ,tot_assets -- 总资产
    ,cur_liab -- 流动负债合计
    ,ap_note -- 应付账款及票据
    ,taxes_surcharges_payable -- 应交税金
    ,tradable_fin_liab -- 交易性金融负债
    ,stloans_ltloans_curdue -- 短期借贷及长期借贷当期到期部分
    ,oth_cur_liab -- 其他流动负债
    ,non_cur_liab -- 非流动负债合计
    ,lt_borrow -- 长期借贷
    ,oth_non_cur_liab -- 其他非流动负债合计
    ,total_liabilities -- 总负债
    ,prfshare -- 优先股
    ,comshare -- 普通股股本(股本)
    ,reserve -- 储备
    ,premium_stock -- 股本溢价
    ,retained_earn -- 留存收益
    ,oth_reserve -- 其他储备
    ,treasuryshare -- 库存股
    ,oth_com_income -- 其他综合性收益
    ,tot_com_equity -- 普通股权益总额
    ,parsh_int -- 股东权益
    ,minority_int -- 少数股东权益
    ,tot_shrhldr_eqy -- 股东权益合计
    ,tot_liab_eqy -- 总负债及总权益
    ,cash_inter_bal -- 现金及同业结存
    ,due_bank -- 存放同业
    ,net_loans -- 客户贷款及垫款净额
    ,deposit_bank -- 银行同业存款
    ,funds_lent -- 拆出资金
    ,mort_sec -- 抵押担保证券
    ,sale_loan -- 可供出售贷款
    ,tot_deposits -- 总存款
    ,loans_oth_banks -- 拆入资金
    ,secured_fin -- 抵押担保融资
    ,reinsur_pay -- 应付再保
    ,reinsur_rece -- 应收再保
    ,insur_pre_rec -- 应收保费
    ,defer_cost -- 递延保单获得成本
    ,insur_liab -- 保险合同负债
    ,invest_liab -- 投资合同负债
    ,oth_inv -- 其他投资
    ,oth_assets -- 其他资产
    ,oth_liab -- 其他负债
    ,s_info_comptype -- 报告期公司类型代码
    ,s_memo -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_hkgsdbalancesheet
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_hkgsdbalancesheet exchange partition p_${batch_date} with table ${iol_schema}.wind_hkgsdbalancesheet_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hkgsdbalancesheet to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_hkgsdbalancesheet_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hkgsdbalancesheet',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);