/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_assetmanagementcashflow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_assetmanagementcashflow
whenever sqlerror continue none;
drop table ${iol_schema}.wind_assetmanagementcashflow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_assetmanagementcashflow(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(15) -- 报表类型代码
    ,crncy_code varchar2(15) -- 货币代码
    ,free_cash_flow number(20,4) -- 企业自由现金流量(FCFF)
    ,actual_ann_dt varchar2(12) -- 实际公告日期
    ,net_incr_disp_tfa number(20,4) -- 处置交易性金融资产净增加额
    ,net_incr_disp_faas number(20,4) -- 处置可供出售金融资产净增加额
    ,net_incr_int_handling_chrg number(20,4) -- 收取利息和手续费净增加额
    ,net_incr_loans_other_bank number(20,4) -- 拆入资金净增加额
    ,net_incr_repurch_bus_fund number(20,4) -- 回购业务资金净增加额
    ,other_cash_recp_ral_oper_act number(20,4) -- 收到其他与经营活动有关的现金
    ,spe_bal_cash_inflows_oper number(20,4) -- 经营活动现金流入差额(特殊报表科目)
    ,tot_bal_cash_inflows_oper number(20,4) -- 经营活动现金流入差额(合计平衡项目)
    ,stot_cash_inflows_oper_act number(20,4) -- 经营活动现金流入小计
    ,cash_pay_beh_empl number(20,4) -- 支付给职工以及为职工支付的现金
    ,pay_all_typ_tax number(20,4) -- 支付的各项税费
    ,other_cash_pay_ral_oper_act number(20,4) -- 支付其他与经营活动有关的现金
    ,handling_chrg_paid number(20,4) -- 支付手续费的现金
    ,spe_bal_cash_outflows_oper number(20,4) -- 经营活动现金流出差额(特殊报表科目)
    ,tot_bal_cash_outflows_oper number(20,4) -- 经营活动现金流出差额(合计平衡项目)
    ,stot_cash_outflows_oper_act number(20,4) -- 经营活动现金流出小计
    ,tot_bal_netcash_outflows_oper number(20,4) -- 经营活动产生的现金流量净额差额(合计平衡项目)
    ,net_cash_flows_oper_act number(20,4) -- 经营活动产生的现金流量净额
    ,cash_recp_disp_withdrwl_invest number(20,4) -- 收回投资收到的现金
    ,cash_recp_return_invest number(20,4) -- 取得投资收益收到的现金
    ,net_cash_recp_disp_fiolta number(20,4) -- 处置固定资产、无形资产和其他长期资产收回的现金净额
    ,other_cash_recp_ral_inv_act number(20,4) -- 收到其他与投资活动有关的现金
    ,spe_bal_cash_inflows_inv number(20,4) -- 投资活动现金流入差额(特殊报表科目)
    ,tot_bal_cash_inflows_inv number(20,4) -- 投资活动现金流入差额(合计平衡项目)
    ,stot_cash_inflows_inv_act number(20,4) -- 投资活动现金流入小计
    ,cash_paid_invest number(20,4) -- 投资支付的现金
    ,cash_pay_acq_const_fiolta number(20,4) -- 购建固定资产、无形资产和其他长期资产支付的现金
    ,other_cash_pay_ral_inv_act number(20,4) -- 支付其他与投资活动有关的现金
    ,spe_bal_cash_outflows_inv number(20,4) -- 投资活动现金流出差额(特殊报表科目)
    ,tot_bal_cash_outflows_inv number(20,4) -- 投资活动现金流出差额(合计平衡项目)
    ,stot_cash_outflows_inv_act number(20,4) -- 投资活动现金流出小计
    ,tot_bal_netcash_outflows_inv number(20,4) -- 投资活动产生的现金流量净额差额(合计平衡项目)
    ,net_cash_flows_inv_act number(20,4) -- 投资活动产生的现金流量净额
    ,cash_recp_cap_contrib number(20,4) -- 吸收投资收到的现金
    ,cash_recp_borrow number(20,4) -- 取得借款收到的现金
    ,proc_issue_bonds number(20,4) -- 发行债券收到的现金
    ,other_cash_recp_ral_fnc_act number(20,4) -- 收到其他与筹资活动有关的现金
    ,spe_bal_cash_inflows_fnc number(20,4) -- 筹资活动现金流入差额(特殊报表科目)
    ,tot_bal_cash_inflows_fnc number(20,4) -- 筹资活动现金流入差额(合计平衡项目)
    ,stot_cash_inflows_fnc_act number(20,4) -- 筹资活动现金流入小计
    ,cash_prepay_amt_borr number(20,4) -- 偿还债务支付的现金
    ,cash_pay_dist_dpcp_int_exp number(20,4) -- 分配股利、利润或偿付利息支付的现金
    ,other_cash_pay_ral_fnc_act number(20,4) -- 支付其他与筹资活动有关的现金
    ,spe_bal_cash_outflows_fnc number(20,4) -- 筹资活动现金流出差额(特殊报表科目)
    ,tot_bal_cash_outflows_fnc number(20,4) -- 筹资活动现金流出差额(合计平衡项目)
    ,stot_cash_outflows_fnc_act number(20,4) -- 筹资活动现金流出小计
    ,tot_bal_netcash_outflows_fnc number(20,4) -- 筹资活动产生的现金流量净额差额(合计平衡项目)
    ,net_cash_flows_fnc_act number(20,4) -- 筹资活动产生的现金流量净额
    ,eff_fx_flu_cash number(20,4) -- 汇率变动对现金的影响
    ,spe_bal_netcash_equ_dir number(20,4) -- 现金净增加额差额(特殊报表科目)
    ,tot_bal_netcash_equ_dir number(20,4) -- 现金净增加额差额(合计平衡项目)
    ,net_incr_cash_cash_equ number(20,4) -- 现金及现金等价物净增加额
    ,cash_cash_equ_beg_period number(20,4) -- 期初现金及现金等价物余额
    ,cash_cash_equ_end_period number(20,4) -- 期末现金及现金等价物余额
    ,net_profit number(20,4) -- 净利润
    ,plus_prov_depr_assets number(20,4) -- 加：资产减值准备
    ,depr_fa_coga_dpba number(20,4) -- 固定资产折旧、油气资产折耗、生产性生物资产折旧
    ,amort_intang_assets number(20,4) -- 无形资产摊销
    ,amort_lt_deferred_exp number(20,4) -- 长期待摊费用摊销
    ,decr_deferred_exp number(20,4) -- 待摊费用减少
    ,incr_acc_exp number(20,4) -- 预提费用增加
    ,loss_disp_fiolta number(20,4) -- 处置固定、无形资产和其他长期资产的损失
    ,loss_scr_fa number(20,4) -- 固定资产报废损失
    ,loss_fv_chg number(20,4) -- 公允价值变动损失
    ,fin_exp number(20,4) -- 财务费用
    ,invest_loss number(20,4) -- 投资损失
    ,decr_deferred_inc_tax_assets number(20,4) -- 递延所得税资产减少
    ,incr_deferred_inc_tax_liab number(20,4) -- 递延所得税负债增加
    ,decr_inventories number(20,4) -- 存货的减少
    ,decr_oper_payable number(20,4) -- 经营性应收项目的减少
    ,incr_oper_payable number(20,4) -- 经营性应付项目的增加
    ,others number(20,4) -- 其他
    ,spe_bal_netcash_equ_undir number(20,4) -- 间接法-经营活动现金流量净额差额(特殊报表科目)
    ,tot_bal_netcash_equ_undir number(20,4) -- 间接法-经营活动现金流量净额差额(合计平衡项目)
    ,im_net_cash_flows_oper_act number(20,4) -- 间接法-经营活动产生的现金流量净额
    ,conv_debt_into_cap number(20,4) -- 债务转为资本
    ,conv_corp_bonds_due_within_1y number(20,4) -- 一年内到期的可转换公司债券
    ,fa_fnc_leases number(20,4) -- 融资租入固定资产
    ,end_bal_cash number(20,4) -- 现金的期末余额
    ,less_beg_bal_cash number(20,4) -- 减：现金的期初余额
    ,plus_end_bal_cash_equ number(20,4) -- 加：现金等价物的期末余额
    ,less_beg_bal_cash_equ number(20,4) -- 减：现金等价物的期初余额
    ,spe_bal_netcash_inc_undir number(20,4) -- 间接法-现金净增加额差额(特殊报表科目)
    ,tot_bal_netcash_inc_undir number(20,4) -- 间接法-现金净增加额差额(合计平衡项目)
    ,im_net_incr_cash_cash_equ number(20,4) -- 间接法-现金及现金等价物净增加额
    ,agent_trading_sc_net_cash number(20,4) -- 代理买卖证券收到的现金净额
    ,melt_money_net_increase number(20,4) -- 融出资金净增加额
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.wind_assetmanagementcashflow to ${iml_schema};
grant select on ${iol_schema}.wind_assetmanagementcashflow to ${icl_schema};
grant select on ${iol_schema}.wind_assetmanagementcashflow to ${idl_schema};
grant select on ${iol_schema}.wind_assetmanagementcashflow to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_assetmanagementcashflow is '非上市资产管理公司现金流量表';
comment on column ${iol_schema}.wind_assetmanagementcashflow.object_id is '对象ID';
comment on column ${iol_schema}.wind_assetmanagementcashflow.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_assetmanagementcashflow.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_assetmanagementcashflow.report_period is '报告期';
comment on column ${iol_schema}.wind_assetmanagementcashflow.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_assetmanagementcashflow.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_assetmanagementcashflow.free_cash_flow is '企业自由现金流量(FCFF)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.actual_ann_dt is '实际公告日期';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_incr_disp_tfa is '处置交易性金融资产净增加额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_incr_disp_faas is '处置可供出售金融资产净增加额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_incr_int_handling_chrg is '收取利息和手续费净增加额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_incr_loans_other_bank is '拆入资金净增加额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_incr_repurch_bus_fund is '回购业务资金净增加额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.other_cash_recp_ral_oper_act is '收到其他与经营活动有关的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.spe_bal_cash_inflows_oper is '经营活动现金流入差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_cash_inflows_oper is '经营活动现金流入差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.stot_cash_inflows_oper_act is '经营活动现金流入小计';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_pay_beh_empl is '支付给职工以及为职工支付的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.pay_all_typ_tax is '支付的各项税费';
comment on column ${iol_schema}.wind_assetmanagementcashflow.other_cash_pay_ral_oper_act is '支付其他与经营活动有关的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.handling_chrg_paid is '支付手续费的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.spe_bal_cash_outflows_oper is '经营活动现金流出差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_cash_outflows_oper is '经营活动现金流出差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.stot_cash_outflows_oper_act is '经营活动现金流出小计';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_netcash_outflows_oper is '经营活动产生的现金流量净额差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_cash_flows_oper_act is '经营活动产生的现金流量净额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_recp_disp_withdrwl_invest is '收回投资收到的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_recp_return_invest is '取得投资收益收到的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_cash_recp_disp_fiolta is '处置固定资产、无形资产和其他长期资产收回的现金净额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.other_cash_recp_ral_inv_act is '收到其他与投资活动有关的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.spe_bal_cash_inflows_inv is '投资活动现金流入差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_cash_inflows_inv is '投资活动现金流入差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.stot_cash_inflows_inv_act is '投资活动现金流入小计';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_paid_invest is '投资支付的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_pay_acq_const_fiolta is '购建固定资产、无形资产和其他长期资产支付的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.other_cash_pay_ral_inv_act is '支付其他与投资活动有关的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.spe_bal_cash_outflows_inv is '投资活动现金流出差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_cash_outflows_inv is '投资活动现金流出差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.stot_cash_outflows_inv_act is '投资活动现金流出小计';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_netcash_outflows_inv is '投资活动产生的现金流量净额差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_cash_flows_inv_act is '投资活动产生的现金流量净额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_recp_cap_contrib is '吸收投资收到的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_recp_borrow is '取得借款收到的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.proc_issue_bonds is '发行债券收到的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.other_cash_recp_ral_fnc_act is '收到其他与筹资活动有关的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.spe_bal_cash_inflows_fnc is '筹资活动现金流入差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_cash_inflows_fnc is '筹资活动现金流入差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.stot_cash_inflows_fnc_act is '筹资活动现金流入小计';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_prepay_amt_borr is '偿还债务支付的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_pay_dist_dpcp_int_exp is '分配股利、利润或偿付利息支付的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.other_cash_pay_ral_fnc_act is '支付其他与筹资活动有关的现金';
comment on column ${iol_schema}.wind_assetmanagementcashflow.spe_bal_cash_outflows_fnc is '筹资活动现金流出差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_cash_outflows_fnc is '筹资活动现金流出差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.stot_cash_outflows_fnc_act is '筹资活动现金流出小计';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_netcash_outflows_fnc is '筹资活动产生的现金流量净额差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_cash_flows_fnc_act is '筹资活动产生的现金流量净额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.eff_fx_flu_cash is '汇率变动对现金的影响';
comment on column ${iol_schema}.wind_assetmanagementcashflow.spe_bal_netcash_equ_dir is '现金净增加额差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_netcash_equ_dir is '现金净增加额差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_incr_cash_cash_equ is '现金及现金等价物净增加额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_cash_equ_beg_period is '期初现金及现金等价物余额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.cash_cash_equ_end_period is '期末现金及现金等价物余额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.net_profit is '净利润';
comment on column ${iol_schema}.wind_assetmanagementcashflow.plus_prov_depr_assets is '加：资产减值准备';
comment on column ${iol_schema}.wind_assetmanagementcashflow.depr_fa_coga_dpba is '固定资产折旧、油气资产折耗、生产性生物资产折旧';
comment on column ${iol_schema}.wind_assetmanagementcashflow.amort_intang_assets is '无形资产摊销';
comment on column ${iol_schema}.wind_assetmanagementcashflow.amort_lt_deferred_exp is '长期待摊费用摊销';
comment on column ${iol_schema}.wind_assetmanagementcashflow.decr_deferred_exp is '待摊费用减少';
comment on column ${iol_schema}.wind_assetmanagementcashflow.incr_acc_exp is '预提费用增加';
comment on column ${iol_schema}.wind_assetmanagementcashflow.loss_disp_fiolta is '处置固定、无形资产和其他长期资产的损失';
comment on column ${iol_schema}.wind_assetmanagementcashflow.loss_scr_fa is '固定资产报废损失';
comment on column ${iol_schema}.wind_assetmanagementcashflow.loss_fv_chg is '公允价值变动损失';
comment on column ${iol_schema}.wind_assetmanagementcashflow.fin_exp is '财务费用';
comment on column ${iol_schema}.wind_assetmanagementcashflow.invest_loss is '投资损失';
comment on column ${iol_schema}.wind_assetmanagementcashflow.decr_deferred_inc_tax_assets is '递延所得税资产减少';
comment on column ${iol_schema}.wind_assetmanagementcashflow.incr_deferred_inc_tax_liab is '递延所得税负债增加';
comment on column ${iol_schema}.wind_assetmanagementcashflow.decr_inventories is '存货的减少';
comment on column ${iol_schema}.wind_assetmanagementcashflow.decr_oper_payable is '经营性应收项目的减少';
comment on column ${iol_schema}.wind_assetmanagementcashflow.incr_oper_payable is '经营性应付项目的增加';
comment on column ${iol_schema}.wind_assetmanagementcashflow.others is '其他';
comment on column ${iol_schema}.wind_assetmanagementcashflow.spe_bal_netcash_equ_undir is '间接法-经营活动现金流量净额差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_netcash_equ_undir is '间接法-经营活动现金流量净额差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.im_net_cash_flows_oper_act is '间接法-经营活动产生的现金流量净额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.conv_debt_into_cap is '债务转为资本';
comment on column ${iol_schema}.wind_assetmanagementcashflow.conv_corp_bonds_due_within_1y is '一年内到期的可转换公司债券';
comment on column ${iol_schema}.wind_assetmanagementcashflow.fa_fnc_leases is '融资租入固定资产';
comment on column ${iol_schema}.wind_assetmanagementcashflow.end_bal_cash is '现金的期末余额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.less_beg_bal_cash is '减：现金的期初余额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.plus_end_bal_cash_equ is '加：现金等价物的期末余额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.less_beg_bal_cash_equ is '减：现金等价物的期初余额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.spe_bal_netcash_inc_undir is '间接法-现金净增加额差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.tot_bal_netcash_inc_undir is '间接法-现金净增加额差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementcashflow.im_net_incr_cash_cash_equ is '间接法-现金及现金等价物净增加额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.agent_trading_sc_net_cash is '代理买卖证券收到的现金净额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.melt_money_net_increase is '融出资金净增加额';
comment on column ${iol_schema}.wind_assetmanagementcashflow.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_assetmanagementcashflow.etl_timestamp is 'ETL处理时间戳';
