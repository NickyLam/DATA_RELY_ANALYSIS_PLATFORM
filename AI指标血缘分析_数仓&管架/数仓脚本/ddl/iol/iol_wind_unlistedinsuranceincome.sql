/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_unlistedinsuranceincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_unlistedinsuranceincome
whenever sqlerror continue none;
drop table ${iol_schema}.wind_unlistedinsuranceincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_unlistedinsuranceincome(
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
    ,insur_prem_unearned number(20,4) -- 已赚保费
    ,prem_inc number(20,4) -- 保费业务收入
    ,incl_reinsurance_prem_inc number(20,4) -- 其中：分保费收入
    ,less_ceded_out_prem number(20,4) -- 减：分出保费
    ,chg_unearned_prem_res number(20,4) -- 提取未到期责任准备金
    ,plus_net_invest_inc number(20,4) -- 加:投资净收益
    ,incl_inc_invest_assoc_jv_entp number(20,4) -- 其中：对联营企业和合营企业的投资收益
    ,plus_net_gain_chg_fv number(20,4) -- 加:公允价值变动净收益
    ,plus_net_gain_fx_trans number(20,4) -- 加:汇兑净收益
    ,oper_exp number(20,4) -- 营业支出
    ,prepay_surr number(20,4) -- 退保金
    ,tot_claim_exp number(20,4) -- 赔付总支出
    ,less_claim_recb_reinsurer number(20,4) -- 减：摊回赔付支出
    ,less_ins_rsrv_recb_reinsurer number(20,4) -- 减：摊回保险责任准备金
    ,dvd_exp_insured number(20,4) -- 保户红利支出
    ,reinsurance_exp number(20,4) -- 分保费用
    ,less_taxes_surcharges_ops number(20,4) -- 减:营业税金及附加
    ,less_handling_chrg_comm_exp number(20,4) -- 减:手续费及佣金支出
    ,less_gerl_admin_exp number(20,4) -- 减:管理费用
    ,less_exp_recb_reinsurer number(20,4) -- 减：摊回分保费用
    ,other_bus_cost number(20,4) -- 其他业务成本
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
    ,minority_int_inc number(20,4) -- 少数股东损益
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
grant select on ${iol_schema}.wind_unlistedinsuranceincome to ${iml_schema};
grant select on ${iol_schema}.wind_unlistedinsuranceincome to ${icl_schema};
grant select on ${iol_schema}.wind_unlistedinsuranceincome to ${idl_schema};
grant select on ${iol_schema}.wind_unlistedinsuranceincome to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_unlistedinsuranceincome is '非上市保险利润表';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.object_id is '对象ID';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.report_period is '报告期';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.ebit is '息税前利润';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.ebitda is '息税折旧摊销前利润';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.net_profit_after_ded_nr_lp is '扣除非经常性损益后净利润';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.net_profit_under_intl_acc_sta is '国际会计准则净利润';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.s_fa_eps_basic is '基本每股收益';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.s_fa_eps_diluted is '稀释每股收益';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.actual_ann_dt is '实际公告日期';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.oper_rev is '营业收入';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.insur_prem_unearned is '已赚保费';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.prem_inc is '保费业务收入';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.incl_reinsurance_prem_inc is '其中：分保费收入';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.less_ceded_out_prem is '减：分出保费';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.chg_unearned_prem_res is '提取未到期责任准备金';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.plus_net_invest_inc is '加:投资净收益';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.incl_inc_invest_assoc_jv_entp is '其中：对联营企业和合营企业的投资收益';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.plus_net_gain_chg_fv is '加:公允价值变动净收益';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.plus_net_gain_fx_trans is '加:汇兑净收益';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.oper_exp is '营业支出';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.prepay_surr is '退保金';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.tot_claim_exp is '赔付总支出';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.less_claim_recb_reinsurer is '减：摊回赔付支出';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.less_ins_rsrv_recb_reinsurer is '减：摊回保险责任准备金';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.dvd_exp_insured is '保户红利支出';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.reinsurance_exp is '分保费用';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.less_taxes_surcharges_ops is '减:营业税金及附加';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.less_handling_chrg_comm_exp is '减:手续费及佣金支出';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.less_gerl_admin_exp is '减:管理费用';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.less_exp_recb_reinsurer is '减：摊回分保费用';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.other_bus_cost is '其他业务成本';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.less_impair_loss_assets is '减:资产减值损失';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.spe_bal_oper_profit is '营业利润差额(特殊报表科目)';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.tot_bal_oper_profit is '营业利润差额(合计平衡项目)';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.oper_profit is '营业利润';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.plus_non_oper_rev is '加:营业外收入';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.less_non_oper_exp is '减：营业外支出';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.il_net_loss_disp_noncur_asset is '其中：减：非流动资产处置净损失';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.spe_bal_tot_profit is '利润总额差额(特殊报表科目)';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.tot_bal_tot_profit is '利润总额差额(合计平衡项目)';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.tot_profit is '利润总额';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.inc_tax is '所得税';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.unconfirmed_invest_loss is '未确认投资损失';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.spe_bal_net_profit is '净利润差额(特殊报表科目)';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.tot_bal_net_profit is '净利润差额(合计平衡项目)';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.net_profit_incl_min_int_inc is '净利润(含少数股东损益)';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.net_profit_excl_min_int_inc is '净利润(不含少数股东损益)';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.minority_int_inc is '少数股东损益';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_unlistedinsuranceincome.etl_timestamp is 'ETL处理时间戳';
