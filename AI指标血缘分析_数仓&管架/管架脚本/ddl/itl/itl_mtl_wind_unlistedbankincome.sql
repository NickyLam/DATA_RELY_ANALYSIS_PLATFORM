/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_wind_unlistedbankincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_wind_unlistedbankincome
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_wind_unlistedbankincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_wind_unlistedbankincome(
    etl_dt date -- ETL处理日期
    ,object_id varchar2(100) -- 对象ID
    ,s_info_compcode varchar2(40) -- 公司ID
    ,ann_dt varchar2(8) -- 公告日期
    ,report_period varchar2(8) -- 报告期
    ,statement_type varchar2(10) -- 报表类型代码
    ,crncy_code varchar2(10) -- 货币代码
    ,ebit number(20,4) -- 息税前利润
    ,ebitda number(20,4) -- 息税折旧摊销前利润
    ,net_profit_after_ded_nr_lp number(20,4) -- 扣除非经常性损益后净利润
    ,net_profit_under_intl_acc_sta number(20,4) -- 国际会计准则净利润
    ,s_fa_eps_basic number(20,4) -- 基本每股收益
    ,s_fa_eps_diluted number(20,4) -- 稀释每股收益
    ,actual_ann_dt varchar2(8) -- 实际公告日期
    ,oper_rev number(20,4) -- 营业收入
    ,net_int_inc number(20,4) -- 利息净收入
    ,int_inc number(20,4) -- 利息收入
    ,less_int_exp number(20,4) -- 减:利息支出
    ,net_handling_chrg_comm_inc number(20,4) -- 手续费及佣金净收入
    ,handling_chrg_comm_inc number(20,4) -- 手续费及佣金收入
    ,less_handling_chrg_comm_exp number(20,4) -- 减:手续费及佣金支出
    ,plus_net_invest_inc number(20,4) -- 加:投资净收益
    ,incl_inc_invest_assoc_jv_entp number(20,4) -- 其中：对联营企业和合营企业的投资收益
    ,plus_net_gain_chg_fv number(20,4) -- 加:公允价值变动净收益
    ,net_inc_other_ops number(20,4) -- 其他经营净收益
    ,plus_net_gain_fx_trans number(20,4) -- 加:汇兑净收益
    ,plus_net_inc_other_bus number(20,4) -- 加:其他业务净收益
    ,other_bus_inc number(20,4) -- 其他业务收入
    ,other_bus_cost number(20,4) -- 其他业务成本
    ,oper_exp number(20,4) -- 营业支出
    ,less_taxes_surcharges_ops number(20,4) -- 减:营业税金及附加
    ,less_gerl_admin_exp number(20,4) -- 减:管理费用
    ,less_impair_loss_assets number(20,4) -- 减:资产减值损失
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
    ,other_compreh_inc number(20,4) -- 其他综合收益
    ,tot_compreh_inc number(20,4) -- 综合收益总额
    ,tot_compreh_inc_min_shrhldr number(20,4) -- 综合收益总额(少数股东)
    ,tot_compreh_inc_parent_comp number(20,4) -- 综合收益总额(母公司)
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.mtl_wind_unlistedbankincome to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_wind_unlistedbankincome is '非上市银行利润表';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.object_id is '对象ID';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.s_info_compcode is '公司ID';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.ann_dt is '公告日期';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.report_period is '报告期';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.statement_type is '报表类型代码';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.crncy_code is '货币代码';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.ebit is '息税前利润';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.ebitda is '息税折旧摊销前利润';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.net_profit_after_ded_nr_lp is '扣除非经常性损益后净利润';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.net_profit_under_intl_acc_sta is '国际会计准则净利润';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.s_fa_eps_basic is '基本每股收益';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.s_fa_eps_diluted is '稀释每股收益';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.actual_ann_dt is '实际公告日期';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.oper_rev is '营业收入';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.net_int_inc is '利息净收入';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.int_inc is '利息收入';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.less_int_exp is '减:利息支出';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.net_handling_chrg_comm_inc is '手续费及佣金净收入';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.handling_chrg_comm_inc is '手续费及佣金收入';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.less_handling_chrg_comm_exp is '减:手续费及佣金支出';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.plus_net_invest_inc is '加:投资净收益';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.incl_inc_invest_assoc_jv_entp is '其中：对联营企业和合营企业的投资收益';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.plus_net_gain_chg_fv is '加:公允价值变动净收益';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.net_inc_other_ops is '其他经营净收益';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.plus_net_gain_fx_trans is '加:汇兑净收益';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.plus_net_inc_other_bus is '加:其他业务净收益';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.other_bus_inc is '其他业务收入';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.other_bus_cost is '其他业务成本';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.oper_exp is '营业支出';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.less_taxes_surcharges_ops is '减:营业税金及附加';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.less_gerl_admin_exp is '减:管理费用';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.less_impair_loss_assets is '减:资产减值损失';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.spe_bal_oper_profit is '营业利润差额(特殊报表科目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.tot_bal_oper_profit is '营业利润差额(合计平衡项目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.oper_profit is '营业利润';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.plus_non_oper_rev is '加:营业外收入';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.less_non_oper_exp is '减：营业外支出';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.il_net_loss_disp_noncur_asset is '其中：减：非流动资产处置净损失';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.spe_bal_tot_profit is '利润总额差额(特殊报表科目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.tot_bal_tot_profit is '利润总额差额(合计平衡项目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.tot_profit is '利润总额';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.inc_tax is '所得税';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.unconfirmed_invest_loss is '未确认投资损失';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.spe_bal_net_profit is '净利润差额(特殊报表科目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.tot_bal_net_profit is '净利润差额(合计平衡项目)';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.net_profit_incl_min_int_inc is '净利润(含少数股东损益)';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.net_profit_excl_min_int_inc is '净利润(不含少数股东损益)';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.other_compreh_inc is '其他综合收益';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.tot_compreh_inc is '综合收益总额';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.tot_compreh_inc_min_shrhldr is '综合收益总额(少数股东)';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.tot_compreh_inc_parent_comp is '综合收益总额(母公司)';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_unlistedbankincome.etl_timestamp is 'ETL处理时间戳';
