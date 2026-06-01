/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_bshareincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_bshareincome
whenever sqlerror continue none;
drop table ${iol_schema}.wind_bshareincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_bshareincome(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,wind_code varchar2(60) -- Wind代码
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(15) -- 报表类型
    ,crncy_code varchar2(15) -- 货币代码
    ,tot_oper_rev number(20,4) -- 营业总收入
    ,oper_rev number(20,4) -- 营业收入
    ,int_inc number(20,4) -- 利息收入
    ,net_int_inc number(20,4) -- 利息净收入
    ,insur_prem_unearned number(20,4) -- 已赚保费
    ,handling_chrg_comm_inc number(20,4) -- 手续费及佣金收入
    ,net_handling_chrg_comm_inc number(20,4) -- 手续费及佣金净收入
    ,net_inc_other_ops number(20,4) -- 其他经营净收益
    ,plus_net_inc_other_bus number(20,4) -- 加:其他业务净收益
    ,prem_inc number(20,4) -- 保费业务收入
    ,less_ceded_out_prem number(20,4) -- 减:分出保费
    ,chg_unearned_prem_res number(20,4) -- 提取未到期责任准备金
    ,incl_reinsurance_prem_inc number(20,4) -- 其中:分保费收入
    ,net_inc_sec_trading_brok_bus number(20,4) -- 代理买卖证券业务净收入
    ,net_inc_sec_uw_bus number(20,4) -- 证券承销业务净收入
    ,net_inc_ec_asset_mgmt_bus number(20,4) -- 受托客户资产管理业务净收入
    ,other_bus_inc number(20,4) -- 其他业务收入
    ,plus_net_gain_chg_fv number(20,4) -- 加:公允价值变动净收益
    ,plus_net_invest_inc number(20,4) -- 加:投资净收益
    ,incl_inc_invest_assoc_jv_entp number(20,4) -- 其中:对联营企业和合营企业的投资收益
    ,plus_net_gain_fx_trans number(20,4) -- 加:汇兑净收益
    ,tot_oper_cost number(20,4) -- 营业总成本
    ,less_oper_cost number(20,4) -- 减:营业成本
    ,less_int_exp number(20,4) -- 减:利息支出
    ,less_handling_chrg_comm_exp number(20,4) -- 减:手续费及佣金支出
    ,less_taxes_surcharges_ops number(20,4) -- 减:营业税金及附加
    ,less_selling_dist_exp number(20,4) -- 减:销售费用
    ,less_gerl_admin_exp number(20,4) -- 减:管理费用
    ,less_fin_exp number(20,4) -- 减:财务费用
    ,less_impair_loss_assets number(20,4) -- 减:资产减值损失
    ,prepay_surr number(20,4) -- 退保金
    ,tot_claim_exp number(20,4) -- 赔付总支出
    ,chg_insur_cont_rsrv number(20,4) -- 提取保险责任准备金
    ,dvd_exp_insured number(20,4) -- 保户红利支出
    ,reinsurance_exp number(20,4) -- 分保费用
    ,oper_exp number(20,4) -- 营业支出
    ,less_claim_recb_reinsurer number(20,4) -- 减:摊回赔付支出
    ,less_ins_rsrv_recb_reinsurer number(20,4) -- 减:摊回保险责任准备金
    ,less_exp_recb_reinsurer number(20,4) -- 减:摊回分保费用
    ,other_bus_cost number(20,4) -- 其他业务成本
    ,oper_profit number(20,4) -- 营业利润
    ,plus_non_oper_rev number(20,4) -- 加:营业外收入
    ,less_non_oper_exp number(20,4) -- 减:营业外支出
    ,il_net_loss_disp_noncur_asset number(20,4) -- 其中:减:非流动资产处置净损失
    ,tot_profit number(20,4) -- 利润总额
    ,inc_tax number(20,4) -- 所得税
    ,unconfirmed_invest_loss number(20,4) -- 未确认投资损失
    ,net_profit_incl_min_int_inc number(20,4) -- 净利润(含少数股东损益)
    ,net_profit_excl_min_int_inc number(20,4) -- 净利润(不含少数股东损益)
    ,minority_int_inc number(20,4) -- 少数股东损益
    ,other_compreh_inc number(20,4) -- 其他综合收益
    ,tot_compreh_inc number(20,4) -- 综合收益总额
    ,tot_compreh_inc_parent_comp number(20,4) -- 综合收益总额(母公司)
    ,tot_compreh_inc_min_shrhldr number(20,4) -- 综合收益总额(少数股东)
    ,ebit number(20,4) -- 息税前利润
    ,ebitda number(20,4) -- 息税折旧摊销前利润
    ,net_profit_after_ded_nr_lp number(20,4) -- 扣除非经常性损益后净利润
    ,net_profit_under_intl_acc_sta number(20,4) -- 国际会计准则净利润
    ,comp_type_code varchar2(3) -- 公司类型代码
    ,s_fa_eps_basic number(20,4) -- 基本每股收益
    ,s_fa_eps_diluted number(20,4) -- 稀释每股收益
    ,other_income number(20,4) -- 其他收益
    ,memo varchar2(1500) -- 备注
    ,credit_impairment_loss number(20,4) -- 信用减值损失
    ,net_exposure_hedging_benefits number(20,4) -- 净敞口套期收益
    ,rd_expense number(20,4) -- 研发费用
    ,stmnote_finexp number(20,4) -- 财务费用:利息费用
    ,fin_exp_int_inc number(20,4) -- 财务费用:利息收入
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
grant select on ${iol_schema}.wind_bshareincome to ${iml_schema};
grant select on ${iol_schema}.wind_bshareincome to ${icl_schema};
grant select on ${iol_schema}.wind_bshareincome to ${idl_schema};
grant select on ${iol_schema}.wind_bshareincome to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_bshareincome is '中国B股利润表';
comment on column ${iol_schema}.wind_bshareincome.object_id is '对象ID';
comment on column ${iol_schema}.wind_bshareincome.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_bshareincome.wind_code is 'Wind代码';
comment on column ${iol_schema}.wind_bshareincome.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_bshareincome.report_period is '报告期';
comment on column ${iol_schema}.wind_bshareincome.statement_type is '报表类型';
comment on column ${iol_schema}.wind_bshareincome.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_bshareincome.tot_oper_rev is '营业总收入';
comment on column ${iol_schema}.wind_bshareincome.oper_rev is '营业收入';
comment on column ${iol_schema}.wind_bshareincome.int_inc is '利息收入';
comment on column ${iol_schema}.wind_bshareincome.net_int_inc is '利息净收入';
comment on column ${iol_schema}.wind_bshareincome.insur_prem_unearned is '已赚保费';
comment on column ${iol_schema}.wind_bshareincome.handling_chrg_comm_inc is '手续费及佣金收入';
comment on column ${iol_schema}.wind_bshareincome.net_handling_chrg_comm_inc is '手续费及佣金净收入';
comment on column ${iol_schema}.wind_bshareincome.net_inc_other_ops is '其他经营净收益';
comment on column ${iol_schema}.wind_bshareincome.plus_net_inc_other_bus is '加:其他业务净收益';
comment on column ${iol_schema}.wind_bshareincome.prem_inc is '保费业务收入';
comment on column ${iol_schema}.wind_bshareincome.less_ceded_out_prem is '减:分出保费';
comment on column ${iol_schema}.wind_bshareincome.chg_unearned_prem_res is '提取未到期责任准备金';
comment on column ${iol_schema}.wind_bshareincome.incl_reinsurance_prem_inc is '其中:分保费收入';
comment on column ${iol_schema}.wind_bshareincome.net_inc_sec_trading_brok_bus is '代理买卖证券业务净收入';
comment on column ${iol_schema}.wind_bshareincome.net_inc_sec_uw_bus is '证券承销业务净收入';
comment on column ${iol_schema}.wind_bshareincome.net_inc_ec_asset_mgmt_bus is '受托客户资产管理业务净收入';
comment on column ${iol_schema}.wind_bshareincome.other_bus_inc is '其他业务收入';
comment on column ${iol_schema}.wind_bshareincome.plus_net_gain_chg_fv is '加:公允价值变动净收益';
comment on column ${iol_schema}.wind_bshareincome.plus_net_invest_inc is '加:投资净收益';
comment on column ${iol_schema}.wind_bshareincome.incl_inc_invest_assoc_jv_entp is '其中:对联营企业和合营企业的投资收益';
comment on column ${iol_schema}.wind_bshareincome.plus_net_gain_fx_trans is '加:汇兑净收益';
comment on column ${iol_schema}.wind_bshareincome.tot_oper_cost is '营业总成本';
comment on column ${iol_schema}.wind_bshareincome.less_oper_cost is '减:营业成本';
comment on column ${iol_schema}.wind_bshareincome.less_int_exp is '减:利息支出';
comment on column ${iol_schema}.wind_bshareincome.less_handling_chrg_comm_exp is '减:手续费及佣金支出';
comment on column ${iol_schema}.wind_bshareincome.less_taxes_surcharges_ops is '减:营业税金及附加';
comment on column ${iol_schema}.wind_bshareincome.less_selling_dist_exp is '减:销售费用';
comment on column ${iol_schema}.wind_bshareincome.less_gerl_admin_exp is '减:管理费用';
comment on column ${iol_schema}.wind_bshareincome.less_fin_exp is '减:财务费用';
comment on column ${iol_schema}.wind_bshareincome.less_impair_loss_assets is '减:资产减值损失';
comment on column ${iol_schema}.wind_bshareincome.prepay_surr is '退保金';
comment on column ${iol_schema}.wind_bshareincome.tot_claim_exp is '赔付总支出';
comment on column ${iol_schema}.wind_bshareincome.chg_insur_cont_rsrv is '提取保险责任准备金';
comment on column ${iol_schema}.wind_bshareincome.dvd_exp_insured is '保户红利支出';
comment on column ${iol_schema}.wind_bshareincome.reinsurance_exp is '分保费用';
comment on column ${iol_schema}.wind_bshareincome.oper_exp is '营业支出';
comment on column ${iol_schema}.wind_bshareincome.less_claim_recb_reinsurer is '减:摊回赔付支出';
comment on column ${iol_schema}.wind_bshareincome.less_ins_rsrv_recb_reinsurer is '减:摊回保险责任准备金';
comment on column ${iol_schema}.wind_bshareincome.less_exp_recb_reinsurer is '减:摊回分保费用';
comment on column ${iol_schema}.wind_bshareincome.other_bus_cost is '其他业务成本';
comment on column ${iol_schema}.wind_bshareincome.oper_profit is '营业利润';
comment on column ${iol_schema}.wind_bshareincome.plus_non_oper_rev is '加:营业外收入';
comment on column ${iol_schema}.wind_bshareincome.less_non_oper_exp is '减:营业外支出';
comment on column ${iol_schema}.wind_bshareincome.il_net_loss_disp_noncur_asset is '其中:减:非流动资产处置净损失';
comment on column ${iol_schema}.wind_bshareincome.tot_profit is '利润总额';
comment on column ${iol_schema}.wind_bshareincome.inc_tax is '所得税';
comment on column ${iol_schema}.wind_bshareincome.unconfirmed_invest_loss is '未确认投资损失';
comment on column ${iol_schema}.wind_bshareincome.net_profit_incl_min_int_inc is '净利润(含少数股东损益)';
comment on column ${iol_schema}.wind_bshareincome.net_profit_excl_min_int_inc is '净利润(不含少数股东损益)';
comment on column ${iol_schema}.wind_bshareincome.minority_int_inc is '少数股东损益';
comment on column ${iol_schema}.wind_bshareincome.other_compreh_inc is '其他综合收益';
comment on column ${iol_schema}.wind_bshareincome.tot_compreh_inc is '综合收益总额';
comment on column ${iol_schema}.wind_bshareincome.tot_compreh_inc_parent_comp is '综合收益总额(母公司)';
comment on column ${iol_schema}.wind_bshareincome.tot_compreh_inc_min_shrhldr is '综合收益总额(少数股东)';
comment on column ${iol_schema}.wind_bshareincome.ebit is '息税前利润';
comment on column ${iol_schema}.wind_bshareincome.ebitda is '息税折旧摊销前利润';
comment on column ${iol_schema}.wind_bshareincome.net_profit_after_ded_nr_lp is '扣除非经常性损益后净利润';
comment on column ${iol_schema}.wind_bshareincome.net_profit_under_intl_acc_sta is '国际会计准则净利润';
comment on column ${iol_schema}.wind_bshareincome.comp_type_code is '公司类型代码';
comment on column ${iol_schema}.wind_bshareincome.s_fa_eps_basic is '基本每股收益';
comment on column ${iol_schema}.wind_bshareincome.s_fa_eps_diluted is '稀释每股收益';
comment on column ${iol_schema}.wind_bshareincome.other_income is '其他收益';
comment on column ${iol_schema}.wind_bshareincome.memo is '备注';
comment on column ${iol_schema}.wind_bshareincome.credit_impairment_loss is '信用减值损失';
comment on column ${iol_schema}.wind_bshareincome.net_exposure_hedging_benefits is '净敞口套期收益';
comment on column ${iol_schema}.wind_bshareincome.rd_expense is '研发费用';
comment on column ${iol_schema}.wind_bshareincome.stmnote_finexp is '财务费用:利息费用';
comment on column ${iol_schema}.wind_bshareincome.fin_exp_int_inc is '财务费用:利息收入';
comment on column ${iol_schema}.wind_bshareincome.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_bshareincome.etl_timestamp is 'ETL处理时间戳';
