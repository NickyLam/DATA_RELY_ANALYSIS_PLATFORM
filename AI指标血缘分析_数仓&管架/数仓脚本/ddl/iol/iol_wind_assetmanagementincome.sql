/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_assetmanagementincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_assetmanagementincome
whenever sqlerror continue none;
drop table ${iol_schema}.wind_assetmanagementincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_assetmanagementincome(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(15) -- 报表类型代码
    ,crncy_code varchar2(15) -- 货币代码
    ,ebit number(20,4) -- 息税前利润
    ,ebitda number(20,4) -- 息税折旧摊销前利润
    ,net_profit_after_ded_nr_lp number(20,4) -- 扣除非经常性损益后净利润
    ,net_profit_under_intl_acc_sta number(20,4) -- 国际会计准则净利润
    ,s_fa_eps_basic number(20,4) -- 基本每股收益
    ,s_fa_eps_diluted number(20,4) -- 稀释每股收益
    ,actual_ann_dt varchar2(12) -- 实际公告日期
    ,oper_rev number(20,4) -- 营业收入
    ,handling_chrg_comm_inc number(20,4) -- 手续费及佣金收入
    ,net_inc_sec_trading_brok_bus number(20,4) -- 代理买卖证券业务净收入
    ,net_inc_sec_uw_bus number(20,4) -- 证券承销业务净收入
    ,net_inc_ec_asset_mgmt_bus number(20,4) -- 受托客户资产管理业务净收入
    ,net_int_inc number(20,4) -- 利息净收入
    ,plus_net_invest_inc number(20,4) -- 加:投资净收益
    ,incl_inc_invest_assoc_jv_entp number(20,4) -- 其中：对联营企业和合营企业的投资收益
    ,plus_net_gain_chg_fv number(20,4) -- 加:公允价值变动净收益
    ,plus_net_gain_fx_trans number(20,4) -- 加:汇兑净收益
    ,other_bus_inc number(20,4) -- 其他业务收入
    ,oper_exp number(20,4) -- 营业支出
    ,less_taxes_surcharges_ops number(20,4) -- 减:营业税金及附加
    ,less_gerl_admin_exp number(20,4) -- 减:管理费用
    ,less_impair_loss_assets number(20,4) -- 减:资产减值损失
    ,other_bus_cost number(20,4) -- 其他业务成本
    ,spe_bal_oper_profit number(20,4) -- 营业利润差额(特殊报表科目)
    ,tot_bal_oper_profit number(20,4) -- 营业利润差额(合计平衡项目)
    ,oper_profit number(20,4) -- 营业利润
    ,plus_non_oper_rev number(20,4) -- 加:营业外收入
    ,less_non_oper_exp number(20,4) -- 减：营业外支出
    ,il_net_loss_disp_noncur_asset number(20,4) -- 其中：减：非流动资产处置净损失
    ,spe_bal_tot_profit number(20,4) -- 利润总额差额(特殊报表科目)
    ,tot_bal_tot_profit number(20,4) -- 利润总额差额(合计平衡项目)
    ,tot_profit number(20,4) -- 利润总额
    ,inc_tax number(20,4) -- 所得税
    ,unconfirmed_invest_loss number(20,4) -- 未确认投资损失
    ,spe_bal_net_profit number(20,4) -- 净利润差额(特殊报表科目)
    ,tot_bal_net_profit number(20,4) -- 净利润差额(合计平衡项目)
    ,net_profit_incl_min_int_inc number(20,4) -- 净利润(含少数股东损益)
    ,net_profit_excl_min_int_inc number(20,4) -- 净利润(不含少数股东损益)
    ,minority_int_inc number(20,4) -- 少数股东损益
    ,other_compreh_inc number(20,4) -- 其他综合收益
    ,tot_compreh_inc number(20,4) -- 综合收益总额
    ,tot_compreh_inc_min_shrhldr number(20,4) -- 综合收益总额(少数股东)
    ,tot_compreh_inc_parent_comp number(20,4) -- 综合收益总额(母公司)
    ,feeandcominc number(20,4) -- 手续费及佣金净收入
    ,other_income number(20,4) -- 其他收益
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
grant select on ${iol_schema}.wind_assetmanagementincome to ${iml_schema};
grant select on ${iol_schema}.wind_assetmanagementincome to ${icl_schema};
grant select on ${iol_schema}.wind_assetmanagementincome to ${idl_schema};
grant select on ${iol_schema}.wind_assetmanagementincome to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_assetmanagementincome is '非上市资产管理公司利润表';
comment on column ${iol_schema}.wind_assetmanagementincome.object_id is '对象ID';
comment on column ${iol_schema}.wind_assetmanagementincome.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_assetmanagementincome.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_assetmanagementincome.report_period is '报告期';
comment on column ${iol_schema}.wind_assetmanagementincome.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_assetmanagementincome.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_assetmanagementincome.ebit is '息税前利润';
comment on column ${iol_schema}.wind_assetmanagementincome.ebitda is '息税折旧摊销前利润';
comment on column ${iol_schema}.wind_assetmanagementincome.net_profit_after_ded_nr_lp is '扣除非经常性损益后净利润';
comment on column ${iol_schema}.wind_assetmanagementincome.net_profit_under_intl_acc_sta is '国际会计准则净利润';
comment on column ${iol_schema}.wind_assetmanagementincome.s_fa_eps_basic is '基本每股收益';
comment on column ${iol_schema}.wind_assetmanagementincome.s_fa_eps_diluted is '稀释每股收益';
comment on column ${iol_schema}.wind_assetmanagementincome.actual_ann_dt is '实际公告日期';
comment on column ${iol_schema}.wind_assetmanagementincome.oper_rev is '营业收入';
comment on column ${iol_schema}.wind_assetmanagementincome.handling_chrg_comm_inc is '手续费及佣金收入';
comment on column ${iol_schema}.wind_assetmanagementincome.net_inc_sec_trading_brok_bus is '代理买卖证券业务净收入';
comment on column ${iol_schema}.wind_assetmanagementincome.net_inc_sec_uw_bus is '证券承销业务净收入';
comment on column ${iol_schema}.wind_assetmanagementincome.net_inc_ec_asset_mgmt_bus is '受托客户资产管理业务净收入';
comment on column ${iol_schema}.wind_assetmanagementincome.net_int_inc is '利息净收入';
comment on column ${iol_schema}.wind_assetmanagementincome.plus_net_invest_inc is '加:投资净收益';
comment on column ${iol_schema}.wind_assetmanagementincome.incl_inc_invest_assoc_jv_entp is '其中：对联营企业和合营企业的投资收益';
comment on column ${iol_schema}.wind_assetmanagementincome.plus_net_gain_chg_fv is '加:公允价值变动净收益';
comment on column ${iol_schema}.wind_assetmanagementincome.plus_net_gain_fx_trans is '加:汇兑净收益';
comment on column ${iol_schema}.wind_assetmanagementincome.other_bus_inc is '其他业务收入';
comment on column ${iol_schema}.wind_assetmanagementincome.oper_exp is '营业支出';
comment on column ${iol_schema}.wind_assetmanagementincome.less_taxes_surcharges_ops is '减:营业税金及附加';
comment on column ${iol_schema}.wind_assetmanagementincome.less_gerl_admin_exp is '减:管理费用';
comment on column ${iol_schema}.wind_assetmanagementincome.less_impair_loss_assets is '减:资产减值损失';
comment on column ${iol_schema}.wind_assetmanagementincome.other_bus_cost is '其他业务成本';
comment on column ${iol_schema}.wind_assetmanagementincome.spe_bal_oper_profit is '营业利润差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementincome.tot_bal_oper_profit is '营业利润差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementincome.oper_profit is '营业利润';
comment on column ${iol_schema}.wind_assetmanagementincome.plus_non_oper_rev is '加:营业外收入';
comment on column ${iol_schema}.wind_assetmanagementincome.less_non_oper_exp is '减：营业外支出';
comment on column ${iol_schema}.wind_assetmanagementincome.il_net_loss_disp_noncur_asset is '其中：减：非流动资产处置净损失';
comment on column ${iol_schema}.wind_assetmanagementincome.spe_bal_tot_profit is '利润总额差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementincome.tot_bal_tot_profit is '利润总额差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementincome.tot_profit is '利润总额';
comment on column ${iol_schema}.wind_assetmanagementincome.inc_tax is '所得税';
comment on column ${iol_schema}.wind_assetmanagementincome.unconfirmed_invest_loss is '未确认投资损失';
comment on column ${iol_schema}.wind_assetmanagementincome.spe_bal_net_profit is '净利润差额(特殊报表科目)';
comment on column ${iol_schema}.wind_assetmanagementincome.tot_bal_net_profit is '净利润差额(合计平衡项目)';
comment on column ${iol_schema}.wind_assetmanagementincome.net_profit_incl_min_int_inc is '净利润(含少数股东损益)';
comment on column ${iol_schema}.wind_assetmanagementincome.net_profit_excl_min_int_inc is '净利润(不含少数股东损益)';
comment on column ${iol_schema}.wind_assetmanagementincome.minority_int_inc is '少数股东损益';
comment on column ${iol_schema}.wind_assetmanagementincome.other_compreh_inc is '其他综合收益';
comment on column ${iol_schema}.wind_assetmanagementincome.tot_compreh_inc is '综合收益总额';
comment on column ${iol_schema}.wind_assetmanagementincome.tot_compreh_inc_min_shrhldr is '综合收益总额(少数股东)';
comment on column ${iol_schema}.wind_assetmanagementincome.tot_compreh_inc_parent_comp is '综合收益总额(母公司)';
comment on column ${iol_schema}.wind_assetmanagementincome.feeandcominc is '手续费及佣金净收入';
comment on column ${iol_schema}.wind_assetmanagementincome.other_income is '其他收益';
comment on column ${iol_schema}.wind_assetmanagementincome.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_assetmanagementincome.etl_timestamp is 'ETL处理时间戳';
