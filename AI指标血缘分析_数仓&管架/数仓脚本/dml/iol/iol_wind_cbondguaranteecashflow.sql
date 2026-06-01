/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cbondguaranteecashflow
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
drop table ${iol_schema}.wind_cbondguaranteecashflow_ex purge;
alter table ${iol_schema}.wind_cbondguaranteecashflow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_cbondguaranteecashflow truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_cbondguaranteecashflow_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_cbondguaranteecashflow where 0=1;

insert /*+ append */ into ${iol_schema}.wind_cbondguaranteecashflow_ex(
    object_id -- 对象ID
    ,s_info_compcode -- 公司ID
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型代码
    ,crncy_code -- 货币代码
    ,cash_recp_sg_and_rs -- 销售商品、提供劳务收到的现金
    ,recp_tax_rends -- 收到的税费返还
    ,net_incr_dep_cob -- 客户存款和同业存放款项净增加额
    ,net_incr_loans_central_bank -- 向中央银行借款净增加额
    ,net_incr_fund_borr_ofi -- 向其他金融机构拆入资金净增加额
    ,cash_recp_prem_orig_inco -- 收到原保险合同保费取得的现金
    ,net_incr_insured_dep -- 保户储金净增加额
    ,net_cash_received_reinsu_bus -- 收到再保业务现金净额
    ,net_incr_disp_tfa -- 处置交易性金融资产净增加额
    ,net_incr_int_handling_chrg -- 收取利息和手续费净增加额
    ,net_incr_disp_faas -- 处置可供出售金融资产净增加额
    ,net_incr_loans_other_bank -- 拆入资金净增加额
    ,net_incr_repurch_bus_fund -- 回购业务资金净增加额
    ,other_cash_recp_ral_oper_act -- 收到其他与经营活动有关的现金
    ,stot_cash_inflows_oper_act -- 经营活动现金流入小计
    ,cash_pay_goods_purch_serv_rec -- 购买商品、接受劳务支付的现金
    ,cash_pay_beh_empl -- 支付给职工以及为职工支付的现金
    ,pay_all_typ_tax -- 支付的各项税费
    ,net_incr_clients_loan_adv -- 客户贷款及垫款净增加额
    ,net_incr_dep_cbob -- 存放央行和同业款项净增加额
    ,cash_pay_claims_orig_inco -- 支付原保险合同赔付款项的现金
    ,handling_chrg_paid -- 支付手续费的现金
    ,comm_insur_plcy_paid -- 支付保单红利的现金
    ,other_cash_pay_ral_oper_act -- 支付其他与经营活动有关的现金
    ,stot_cash_outflows_oper_act -- 经营活动现金流出小计
    ,net_cash_flows_oper_act -- 经营活动产生的现金流量净额
    ,cash_recp_disp_withdrwl_invest -- 收回投资收到的现金
    ,cash_recp_return_invest -- 取得投资收益收到的现金
    ,net_cash_recp_disp_fiolta -- 处置固定资产、无形资产和其他长期资产收回的现金净额
    ,net_cash_recp_disp_sobu -- 处置子公司及其他营业单位收到的现金净额
    ,other_cash_recp_ral_inv_act -- 收到其他与投资活动有关的现金
    ,stot_cash_inflows_inv_act -- 投资活动现金流入小计
    ,cash_pay_acq_const_fiolta -- 购建固定资产、无形资产和其他长期资产支付的现金
    ,cash_paid_invest -- 投资支付的现金
    ,net_cash_pay_aquis_sobu -- 取得子公司及其他营业单位支付的现金净额
    ,other_cash_pay_ral_inv_act -- 支付其他与投资活动有关的现金
    ,net_incr_pledge_loan -- 质押贷款净增加额
    ,stot_cash_outflows_inv_act -- 投资活动现金流出小计
    ,net_cash_flows_inv_act -- 投资活动产生的现金流量净额
    ,cash_recp_cap_contrib -- 吸收投资收到的现金
    ,incl_cash_rec_saims -- 其中：子公司吸收少数股东投资收到的现金
    ,cash_recp_borrow -- 取得借款收到的现金
    ,proc_issue_bonds -- 发行债券收到的现金
    ,other_cash_recp_ral_fnc_act -- 收到其他与筹资活动有关的现金
    ,stot_cash_inflows_fnc_act -- 筹资活动现金流入小计
    ,cash_prepay_amt_borr -- 偿还债务支付的现金
    ,cash_pay_dist_dpcp_int_exp -- 分配股利、利润或偿付利息支付的现金
    ,incl_dvd_profit_paid_sc_ms -- 其中：子公司支付给少数股东的股利、利润
    ,other_cash_pay_ral_fnc_act -- 支付其他与筹资活动有关的现金
    ,stot_cash_outflows_fnc_act -- 筹资活动现金流出小计
    ,net_cash_flows_fnc_act -- 筹资活动产生的现金流量净额
    ,eff_fx_flu_cash -- 汇率变动对现金的影响
    ,net_incr_cash_cash_equ -- 现金及现金等价物净增加额
    ,cash_cash_equ_beg_period -- 期初现金及现金等价物余额
    ,cash_cash_equ_end_period -- 期末现金及现金等价物余额
    ,net_profit -- 净利润
    ,unconfirmed_invest_loss -- 未确认投资损失
    ,plus_prov_depr_assets -- 加：资产减值准备
    ,depr_fa_coga_dpba -- 固定资产折旧、油气资产折耗、生产性生物资产折旧
    ,amort_intang_assets -- 无形资产摊销
    ,amort_lt_deferred_exp -- 长期待摊费用摊销
    ,decr_deferred_exp -- 待摊费用减少
    ,incr_acc_exp -- 预提费用增加
    ,loss_disp_fiolta -- 处置固定、无形资产和其他长期资产的损失
    ,loss_scr_fa -- 固定资产报废损失
    ,loss_fv_chg -- 公允价值变动损失
    ,fin_exp -- 财务费用
    ,invest_loss -- 投资损失
    ,decr_deferred_inc_tax_assets -- 递延所得税资产减少
    ,incr_deferred_inc_tax_liab -- 递延所得税负债增加
    ,decr_inventories -- 存货的减少
    ,decr_oper_payable -- 经营性应收项目的减少
    ,incr_oper_payable -- 经营性应付项目的增加
    ,others -- 其他
    ,im_net_cash_flows_oper_act -- 间接法-经营活动产生的现金流量净额
    ,conv_debt_into_cap -- 债务转为资本
    ,conv_corp_bonds_due_within_1y -- 一年内到期的可转换公司债券
    ,fa_fnc_leases -- 融资租入固定资产
    ,end_bal_cash -- 现金的期末余额
    ,less_beg_bal_cash -- 减：现金的期初余额
    ,plus_end_bal_cash_equ -- 加：现金等价物的期末余额
    ,less_beg_bal_cash_equ -- 减：现金等价物的期初余额
    ,im_net_incr_cash_cash_equ -- 间接法-现金及现金等价物净增加额
    ,free_cash_flow -- 企业自由现金流量(FCFF)
    ,comp_type_code -- 公司类型代码
    ,actual_ann_dt -- [内部]实际公告日期
    ,spe_bal_cash_inflows_oper -- 经营活动现金流入差额(特殊报表科目)
    ,tot_bal_cash_inflows_oper -- 经营活动现金流入差额(合计平衡项目)
    ,spe_bal_cash_outflows_oper -- 经营活动现金流出差额(特殊报表科目)
    ,tot_bal_cash_outflows_oper -- 经营活动现金流出差额(合计平衡项目)
    ,tot_bal_netcash_outflows_oper -- 经营活动产生的现金流量净额差额(合计平衡项目)
    ,spe_bal_cash_inflows_inv -- 投资活动现金流入差额(特殊报表科目)
    ,tot_bal_cash_inflows_inv -- 投资活动现金流入差额(合计平衡项目)
    ,spe_bal_cash_outflows_inv -- 投资活动现金流出差额(特殊报表科目)
    ,tot_bal_cash_outflows_inv -- 投资活动现金流出差额(合计平衡项目)
    ,tot_bal_netcash_outflows_inv -- 投资活动产生的现金流量净额差额(合计平衡项目)
    ,spe_bal_cash_inflows_fnc -- 筹资活动现金流入差额(特殊报表科目)
    ,tot_bal_cash_inflows_fnc -- 筹资活动现金流入差额(合计平衡项目)
    ,spe_bal_cash_outflows_fnc -- 筹资活动现金流出差额(特殊报表科目)
    ,tot_bal_cash_outflows_fnc -- 筹资活动现金流出差额(合计平衡项目)
    ,tot_bal_netcash_outflows_fnc -- 筹资活动产生的现金流量净额差额(合计平衡项目)
    ,spe_bal_netcash_inc -- 现金净增加额差额(特殊报表科目)
    ,tot_bal_netcash_inc -- 现金净增加额差额(合计平衡项目)
    ,spe_bal_netcash_equ_undir -- 间接法-经营活动现金流量净额差额(特殊报表科目)
    ,tot_bal_netcash_equ_undir -- 间接法-经营活动现金流量净额差额(合计平衡项目)
    ,spe_bal_netcash_inc_undir -- 间接法-现金净增加额差额(特殊报表科目)
    ,tot_bal_netcash_inc_undir -- 间接法-现金净增加额差额(合计平衡项目)
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
    ,cash_recp_sg_and_rs -- 销售商品、提供劳务收到的现金
    ,recp_tax_rends -- 收到的税费返还
    ,net_incr_dep_cob -- 客户存款和同业存放款项净增加额
    ,net_incr_loans_central_bank -- 向中央银行借款净增加额
    ,net_incr_fund_borr_ofi -- 向其他金融机构拆入资金净增加额
    ,cash_recp_prem_orig_inco -- 收到原保险合同保费取得的现金
    ,net_incr_insured_dep -- 保户储金净增加额
    ,net_cash_received_reinsu_bus -- 收到再保业务现金净额
    ,net_incr_disp_tfa -- 处置交易性金融资产净增加额
    ,net_incr_int_handling_chrg -- 收取利息和手续费净增加额
    ,net_incr_disp_faas -- 处置可供出售金融资产净增加额
    ,net_incr_loans_other_bank -- 拆入资金净增加额
    ,net_incr_repurch_bus_fund -- 回购业务资金净增加额
    ,other_cash_recp_ral_oper_act -- 收到其他与经营活动有关的现金
    ,stot_cash_inflows_oper_act -- 经营活动现金流入小计
    ,cash_pay_goods_purch_serv_rec -- 购买商品、接受劳务支付的现金
    ,cash_pay_beh_empl -- 支付给职工以及为职工支付的现金
    ,pay_all_typ_tax -- 支付的各项税费
    ,net_incr_clients_loan_adv -- 客户贷款及垫款净增加额
    ,net_incr_dep_cbob -- 存放央行和同业款项净增加额
    ,cash_pay_claims_orig_inco -- 支付原保险合同赔付款项的现金
    ,handling_chrg_paid -- 支付手续费的现金
    ,comm_insur_plcy_paid -- 支付保单红利的现金
    ,other_cash_pay_ral_oper_act -- 支付其他与经营活动有关的现金
    ,stot_cash_outflows_oper_act -- 经营活动现金流出小计
    ,net_cash_flows_oper_act -- 经营活动产生的现金流量净额
    ,cash_recp_disp_withdrwl_invest -- 收回投资收到的现金
    ,cash_recp_return_invest -- 取得投资收益收到的现金
    ,net_cash_recp_disp_fiolta -- 处置固定资产、无形资产和其他长期资产收回的现金净额
    ,net_cash_recp_disp_sobu -- 处置子公司及其他营业单位收到的现金净额
    ,other_cash_recp_ral_inv_act -- 收到其他与投资活动有关的现金
    ,stot_cash_inflows_inv_act -- 投资活动现金流入小计
    ,cash_pay_acq_const_fiolta -- 购建固定资产、无形资产和其他长期资产支付的现金
    ,cash_paid_invest -- 投资支付的现金
    ,net_cash_pay_aquis_sobu -- 取得子公司及其他营业单位支付的现金净额
    ,other_cash_pay_ral_inv_act -- 支付其他与投资活动有关的现金
    ,net_incr_pledge_loan -- 质押贷款净增加额
    ,stot_cash_outflows_inv_act -- 投资活动现金流出小计
    ,net_cash_flows_inv_act -- 投资活动产生的现金流量净额
    ,cash_recp_cap_contrib -- 吸收投资收到的现金
    ,incl_cash_rec_saims -- 其中：子公司吸收少数股东投资收到的现金
    ,cash_recp_borrow -- 取得借款收到的现金
    ,proc_issue_bonds -- 发行债券收到的现金
    ,other_cash_recp_ral_fnc_act -- 收到其他与筹资活动有关的现金
    ,stot_cash_inflows_fnc_act -- 筹资活动现金流入小计
    ,cash_prepay_amt_borr -- 偿还债务支付的现金
    ,cash_pay_dist_dpcp_int_exp -- 分配股利、利润或偿付利息支付的现金
    ,incl_dvd_profit_paid_sc_ms -- 其中：子公司支付给少数股东的股利、利润
    ,other_cash_pay_ral_fnc_act -- 支付其他与筹资活动有关的现金
    ,stot_cash_outflows_fnc_act -- 筹资活动现金流出小计
    ,net_cash_flows_fnc_act -- 筹资活动产生的现金流量净额
    ,eff_fx_flu_cash -- 汇率变动对现金的影响
    ,net_incr_cash_cash_equ -- 现金及现金等价物净增加额
    ,cash_cash_equ_beg_period -- 期初现金及现金等价物余额
    ,cash_cash_equ_end_period -- 期末现金及现金等价物余额
    ,net_profit -- 净利润
    ,unconfirmed_invest_loss -- 未确认投资损失
    ,plus_prov_depr_assets -- 加：资产减值准备
    ,depr_fa_coga_dpba -- 固定资产折旧、油气资产折耗、生产性生物资产折旧
    ,amort_intang_assets -- 无形资产摊销
    ,amort_lt_deferred_exp -- 长期待摊费用摊销
    ,decr_deferred_exp -- 待摊费用减少
    ,incr_acc_exp -- 预提费用增加
    ,loss_disp_fiolta -- 处置固定、无形资产和其他长期资产的损失
    ,loss_scr_fa -- 固定资产报废损失
    ,loss_fv_chg -- 公允价值变动损失
    ,fin_exp -- 财务费用
    ,invest_loss -- 投资损失
    ,decr_deferred_inc_tax_assets -- 递延所得税资产减少
    ,incr_deferred_inc_tax_liab -- 递延所得税负债增加
    ,decr_inventories -- 存货的减少
    ,decr_oper_payable -- 经营性应收项目的减少
    ,incr_oper_payable -- 经营性应付项目的增加
    ,others -- 其他
    ,im_net_cash_flows_oper_act -- 间接法-经营活动产生的现金流量净额
    ,conv_debt_into_cap -- 债务转为资本
    ,conv_corp_bonds_due_within_1y -- 一年内到期的可转换公司债券
    ,fa_fnc_leases -- 融资租入固定资产
    ,end_bal_cash -- 现金的期末余额
    ,less_beg_bal_cash -- 减：现金的期初余额
    ,plus_end_bal_cash_equ -- 加：现金等价物的期末余额
    ,less_beg_bal_cash_equ -- 减：现金等价物的期初余额
    ,im_net_incr_cash_cash_equ -- 间接法-现金及现金等价物净增加额
    ,free_cash_flow -- 企业自由现金流量(FCFF)
    ,comp_type_code -- 公司类型代码
    ,actual_ann_dt -- [内部]实际公告日期
    ,spe_bal_cash_inflows_oper -- 经营活动现金流入差额(特殊报表科目)
    ,tot_bal_cash_inflows_oper -- 经营活动现金流入差额(合计平衡项目)
    ,spe_bal_cash_outflows_oper -- 经营活动现金流出差额(特殊报表科目)
    ,tot_bal_cash_outflows_oper -- 经营活动现金流出差额(合计平衡项目)
    ,tot_bal_netcash_outflows_oper -- 经营活动产生的现金流量净额差额(合计平衡项目)
    ,spe_bal_cash_inflows_inv -- 投资活动现金流入差额(特殊报表科目)
    ,tot_bal_cash_inflows_inv -- 投资活动现金流入差额(合计平衡项目)
    ,spe_bal_cash_outflows_inv -- 投资活动现金流出差额(特殊报表科目)
    ,tot_bal_cash_outflows_inv -- 投资活动现金流出差额(合计平衡项目)
    ,tot_bal_netcash_outflows_inv -- 投资活动产生的现金流量净额差额(合计平衡项目)
    ,spe_bal_cash_inflows_fnc -- 筹资活动现金流入差额(特殊报表科目)
    ,tot_bal_cash_inflows_fnc -- 筹资活动现金流入差额(合计平衡项目)
    ,spe_bal_cash_outflows_fnc -- 筹资活动现金流出差额(特殊报表科目)
    ,tot_bal_cash_outflows_fnc -- 筹资活动现金流出差额(合计平衡项目)
    ,tot_bal_netcash_outflows_fnc -- 筹资活动产生的现金流量净额差额(合计平衡项目)
    ,spe_bal_netcash_inc -- 现金净增加额差额(特殊报表科目)
    ,tot_bal_netcash_inc -- 现金净增加额差额(合计平衡项目)
    ,spe_bal_netcash_equ_undir -- 间接法-经营活动现金流量净额差额(特殊报表科目)
    ,tot_bal_netcash_equ_undir -- 间接法-经营活动现金流量净额差额(合计平衡项目)
    ,spe_bal_netcash_inc_undir -- 间接法-现金净增加额差额(特殊报表科目)
    ,tot_bal_netcash_inc_undir -- 间接法-现金净增加额差额(合计平衡项目)
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_cbondguaranteecashflow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_cbondguaranteecashflow exchange partition p_${batch_date} with table ${iol_schema}.wind_cbondguaranteecashflow_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cbondguaranteecashflow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_cbondguaranteecashflow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cbondguaranteecashflow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);