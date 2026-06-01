/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_wind_unlistedbankbalancesheet
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
--alter table ${itl_schema}.mtl_wind_unlistedbankbalancesheet drop partition p_${retain_day};
alter table ${itl_schema}.mtl_wind_unlistedbankbalancesheet drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_wind_unlistedbankbalancesheet add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_wind_unlistedbankbalancesheet partition for (to_date('${batch_date}','yyyymmdd')) (
     object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,crncy_code -- 货币代码
    ,actual_ann_dt -- 实际公告日期
    ,cash_deposits_central_bank -- 现金及存放中央银行款项
    ,asset_dep_oth_banks_fin_inst -- 存放同业和其它金融机构款项
    ,precious_metals -- 贵金属
    ,loans_to_oth_banks -- 拆出资金
    ,tradable_fin_assets -- 交易性金融资产
    ,derivative_fin_assets -- 衍生金融资产
    ,red_monetary_cap_for_sale -- 买入返售金融资产
    ,int_rcv -- 应收利息
    ,loans_and_adv_granted -- 发放贷款及垫款
    ,agency_bus_assets -- 代理业务资产
    ,fin_assets_avail_for_sale -- 可供出售金融资产
    ,held_to_mty_invest -- 持有至到期投资
    ,long_term_eqy_invest -- 长期股权投资
    ,rcv_invest -- 应收款项类投资
    ,fix_assets -- 固定资产
    ,intang_assets -- 无形资产
    ,goodwill -- 商誉
    ,deferred_tax_assets -- 递延所得税资产
    ,invest_real_estate -- 投资性房地产
    ,oth_assets -- 其他资产
    ,spe_bal_assets -- 资产差额(特殊报表科目)
    ,tot_bal_assets -- 资产差额(合计平衡项目)
    ,tot_assets -- 资产总计
    ,liab_dep_oth_banks_fin_inst -- 同业和其它金融机构存放款项
    ,borrow_central_bank -- 向中央银行借款
    ,loans_oth_banks -- 拆入资金
    ,tradable_fin_liab -- 交易性金融负债
    ,derivative_fin_liab -- 衍生金融负债
    ,fund_sales_fin_assets_rp -- 卖出回购金融资产款
    ,cust_bank_dep -- 吸收存款
    ,empl_ben_payable -- 应付职工薪酬
    ,taxes_surcharges_payable -- 应交税费
    ,int_payable -- 应付利息
    ,agency_bus_liab -- 代理业务负债
    ,bonds_payable -- 应付债券
    ,deferred_tax_liab -- 递延所得税负债
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
    ,etl_timestamp -- ETL处理时间
)
select
     nvl(trim(object_id), ' ') as object_id -- 对象ID
    ,nvl(trim(s_info_compcode), ' ') as s_info_compcode -- 公司ID
    ,nvl(trim(ann_dt), ' ') as ann_dt -- 公告日期
    ,nvl(trim(report_period), ' ') as report_period -- 报告期
    ,nvl(trim(statement_type), ' ') as statement_type -- 报表类型
    ,nvl(trim(crncy_code), ' ') as crncy_code -- 货币代码
    ,nvl(trim(actual_ann_dt), ' ') as actual_ann_dt -- 实际公告日期
    ,nvl(trim(cash_deposits_central_bank), 0) as cash_deposits_central_bank -- 现金及存放中央银行款项
    ,nvl(trim(asset_dep_oth_banks_fin_inst), 0) as asset_dep_oth_banks_fin_inst -- 存放同业和其它金融机构款项
    ,nvl(trim(precious_metals), 0) as precious_metals -- 贵金属
    ,nvl(trim(loans_to_oth_banks), 0) as loans_to_oth_banks -- 拆出资金
    ,nvl(trim(tradable_fin_assets), 0) as tradable_fin_assets -- 交易性金融资产
    ,nvl(trim(derivative_fin_assets), 0) as derivative_fin_assets -- 衍生金融资产
    ,nvl(trim(red_monetary_cap_for_sale), 0) as red_monetary_cap_for_sale -- 买入返售金融资产
    ,nvl(trim(int_rcv), 0) as int_rcv -- 应收利息
    ,nvl(trim(loans_and_adv_granted), 0) as loans_and_adv_granted -- 发放贷款及垫款
    ,nvl(trim(agency_bus_assets), 0) as agency_bus_assets -- 代理业务资产
    ,nvl(trim(fin_assets_avail_for_sale), 0) as fin_assets_avail_for_sale -- 可供出售金融资产
    ,nvl(trim(held_to_mty_invest), 0) as held_to_mty_invest -- 持有至到期投资
    ,nvl(trim(long_term_eqy_invest), 0) as long_term_eqy_invest -- 长期股权投资
    ,nvl(trim(rcv_invest), 0) as rcv_invest -- 应收款项类投资
    ,nvl(trim(fix_assets), 0) as fix_assets -- 固定资产
    ,nvl(trim(intang_assets), 0) as intang_assets -- 无形资产
    ,nvl(trim(goodwill), 0) as goodwill -- 商誉
    ,nvl(trim(deferred_tax_assets), 0) as deferred_tax_assets -- 递延所得税资产
    ,nvl(trim(invest_real_estate), 0) as invest_real_estate -- 投资性房地产
    ,nvl(trim(oth_assets), 0) as oth_assets -- 其他资产
    ,nvl(trim(spe_bal_assets), 0) as spe_bal_assets -- 资产差额(特殊报表科目)
    ,nvl(trim(tot_bal_assets), 0) as tot_bal_assets -- 资产差额(合计平衡项目)
    ,nvl(trim(tot_assets), 0) as tot_assets -- 资产总计
    ,nvl(trim(liab_dep_oth_banks_fin_inst), 0) as liab_dep_oth_banks_fin_inst -- 同业和其它金融机构存放款项
    ,nvl(trim(borrow_central_bank), 0) as borrow_central_bank -- 向中央银行借款
    ,nvl(trim(loans_oth_banks), 0) as loans_oth_banks -- 拆入资金
    ,nvl(trim(tradable_fin_liab), 0) as tradable_fin_liab -- 交易性金融负债
    ,nvl(trim(derivative_fin_liab), 0) as derivative_fin_liab -- 衍生金融负债
    ,nvl(trim(fund_sales_fin_assets_rp), 0) as fund_sales_fin_assets_rp -- 卖出回购金融资产款
    ,nvl(trim(cust_bank_dep), 0) as cust_bank_dep -- 吸收存款
    ,nvl(trim(empl_ben_payable), 0) as empl_ben_payable -- 应付职工薪酬
    ,nvl(trim(taxes_surcharges_payable), 0) as taxes_surcharges_payable -- 应交税费
    ,nvl(trim(int_payable), 0) as int_payable -- 应付利息
    ,nvl(trim(agency_bus_liab), 0) as agency_bus_liab -- 代理业务负债
    ,nvl(trim(bonds_payable), 0) as bonds_payable -- 应付债券
    ,nvl(trim(deferred_tax_liab), 0) as deferred_tax_liab -- 递延所得税负债
    ,nvl(trim(provisions), 0) as provisions -- 预计负债
    ,nvl(trim(oth_liab), 0) as oth_liab -- 其他负债
    ,nvl(trim(spe_bal_liab), 0) as spe_bal_liab -- 负债差额(特殊报表科目)
    ,nvl(trim(tot_bal_liab), 0) as tot_bal_liab -- 负债差额(合计平衡项目)
    ,nvl(trim(tot_liab), 0) as tot_liab -- 负债合计
    ,nvl(trim(cap_stk), 0) as cap_stk -- 股本
    ,nvl(trim(cap_rsrv), 0) as cap_rsrv -- 资本公积金
    ,nvl(trim(less_tsy_stk), 0) as less_tsy_stk -- 减：库存股
    ,nvl(trim(surplus_rsrv), 0) as surplus_rsrv -- 盈余公积金
    ,nvl(trim(undistributed_profit), 0) as undistributed_profit -- 未分配利润
    ,nvl(trim(prov_nom_risks), 0) as prov_nom_risks -- 一般风险准备
    ,nvl(trim(cnvd_diff_foreign_curr_stat), 0) as cnvd_diff_foreign_curr_stat -- 外币报表折算差额
    ,nvl(trim(unconfirmed_invest_loss), 0) as unconfirmed_invest_loss -- 未确认的投资损失
    ,nvl(trim(spe_bal_shrhldr_eqy), 0) as spe_bal_shrhldr_eqy -- 股东权益差额(特殊报表科目)
    ,nvl(trim(tot_bal_shrhldr_eqy), 0) as tot_bal_shrhldr_eqy -- 股东权益差额(合计平衡项目)
    ,nvl(trim(minority_int), 0) as minority_int -- 少数股东权益
    ,nvl(trim(tot_shrhldr_eqy_excl_min_int), 0) as tot_shrhldr_eqy_excl_min_int -- 股东权益合计(不含少数股东权益)
    ,nvl(trim(tot_shrhldr_eqy_incl_min_int), 0) as tot_shrhldr_eqy_incl_min_int -- 股东权益合计(含少数股东权益)
    ,nvl(trim(spe_bal_liab_eqy), 0) as spe_bal_liab_eqy -- 负债及股东权益差额(特殊报表项目)
    ,nvl(trim(tot_bal_liab_eqy), 0) as tot_bal_liab_eqy -- 负债及股东权益差额(合计平衡项目)
    ,nvl(trim(tot_liab_shrhldr_eqy), 0) as tot_liab_shrhldr_eqy -- 负债及股东权益总计
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_wind_unlistedbankbalancesheet
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_wind_unlistedbankbalancesheet to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_wind_unlistedbankbalancesheet',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);