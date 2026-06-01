/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondguaranteeincome
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondguaranteeincome
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondguaranteeincome purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondguaranteeincome(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,report_period varchar2(12) -- 报告期
    ,statement_type varchar2(15) -- 报表类型代码
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
    ,less_ceded_out_prem number(20,4) -- 减：分出保费
    ,chg_unearned_prem_res number(20,4) -- 提取未到期责任准备金
    ,incl_reinsurance_prem_inc number(20,4) -- 其中：分保费收入
    ,net_inc_sec_trading_brok_bus number(20,4) -- 代理买卖证券业务净收入
    ,net_inc_sec_uw_bus number(20,4) -- 证券承销业务净收入
    ,net_inc_ec_asset_mgmt_bus number(20,4) -- 受托客户资产管理业务净收入
    ,other_bus_inc number(20,4) -- 其他业务收入
    ,plus_net_gain_chg_fv number(20,4) -- 加:公允价值变动净收益
    ,plus_net_invest_inc number(20,4) -- 加:投资净收益
    ,incl_inc_invest_assoc_jv_entp number(20,4) -- 其中：对联营企业和合营企业的投资收益
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
    ,less_claim_recb_reinsurer number(20,4) -- 减：摊回赔付支出
    ,less_ins_rsrv_recb_reinsurer number(20,4) -- 减：摊回保险责任准备金
    ,less_exp_recb_reinsurer number(20,4) -- 减：摊回分保费用
    ,other_bus_cost number(20,4) -- 其他业务成本
    ,oper_profit number(20,4) -- 营业利润
    ,plus_non_oper_rev number(20,4) -- 加:营业外收入
    ,less_non_oper_exp number(20,4) -- 减：营业外支出
    ,il_net_loss_disp_noncur_asset number(20,4) -- 其中：减：非流动资产处置净损失
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
    ,ebit number(20,4) -- 项目金额
    ,ebitda number(20,4) -- 项目金额
    ,net_profit_after_ded_nr_lp number(20,4) -- 扣除非经常性损益后净利润
    ,net_profit_under_intl_acc_sta number(20,4) -- 国际会计准则净利润
    ,comp_type_code varchar2(3) -- 公司类型代码
    ,s_fa_eps_basic number(20,4) -- 基本每股收益
    ,s_fa_eps_diluted number(20,4) -- 稀释每股收益
    ,actual_ann_dt varchar2(12) -- [内部]实际公告日期
    ,insurance_expense number(20,4) -- 保险业务支出
    ,spe_bal_oper_profit number(20,4) -- 营业利润差额(特殊报表科目)
    ,tot_bal_oper_profit number(20,4) -- 营业利润差额(合计平衡项目)
    ,spe_bal_tot_profit number(20,4) -- 利润总额差额(特殊报表科目)
    ,tot_bal_tot_profit number(20,4) -- 利润总额差额(合计平衡项目)
    ,spe_bal_net_profit number(20,4) -- 净利润差额(特殊报表科目)
    ,tot_bal_net_profit number(20,4) -- 净利润差额(合计平衡项目)
    ,undistributed_profit number(20,4) -- 年初未分配利润
    ,adjlossgain_prevyear number(20,4) -- 调整以前年度损益
    ,transfer_from_surplusreserve number(20,4) -- 盈余公积转入
    ,transfer_from_housingimprest number(20,4) -- 住房周转金转入
    ,transfer_from_others number(20,4) -- 其他转入
    ,distributable_profit number(20,4) -- 可分配利润
    ,withdr_legalsurplus number(20,4) -- 提取法定盈余公积
    ,withdr_legalpubwelfunds number(20,4) -- 提取法定公益金
    ,workers_welfare number(20,4) -- 职工奖金福利
    ,withdr_buzexpwelfare number(20,4) -- 提取企业发展基金
    ,withdr_reservefund number(20,4) -- 提取储备基金
    ,distributable_profit_shrhder number(20,4) -- 可供股东分配的利润
    ,prfshare_dvd_payable number(20,4) -- 应付优先股股利
    ,withdr_othersurpreserve number(20,4) -- 提取任意盈余公积金
    ,comshare_dvd_payable number(20,4) -- 应付普通股股利
    ,capitalized_comstock_div number(20,4) -- 转作股本的普通股股利
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
grant select on ${iol_schema}.wind_cbondguaranteeincome to ${iml_schema};
grant select on ${iol_schema}.wind_cbondguaranteeincome to ${icl_schema};
grant select on ${iol_schema}.wind_cbondguaranteeincome to ${idl_schema};
grant select on ${iol_schema}.wind_cbondguaranteeincome to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondguaranteeincome is '中国债券担保人利润表';
comment on column ${iol_schema}.wind_cbondguaranteeincome.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondguaranteeincome.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_cbondguaranteeincome.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_cbondguaranteeincome.report_period is '报告期';
comment on column ${iol_schema}.wind_cbondguaranteeincome.statement_type is '报表类型代码';
comment on column ${iol_schema}.wind_cbondguaranteeincome.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_cbondguaranteeincome.tot_oper_rev is '营业总收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.oper_rev is '营业收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.int_inc is '利息收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.net_int_inc is '利息净收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.insur_prem_unearned is '已赚保费';
comment on column ${iol_schema}.wind_cbondguaranteeincome.handling_chrg_comm_inc is '手续费及佣金收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.net_handling_chrg_comm_inc is '手续费及佣金净收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.net_inc_other_ops is '其他经营净收益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.plus_net_inc_other_bus is '加:其他业务净收益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.prem_inc is '保费业务收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_ceded_out_prem is '减：分出保费';
comment on column ${iol_schema}.wind_cbondguaranteeincome.chg_unearned_prem_res is '提取未到期责任准备金';
comment on column ${iol_schema}.wind_cbondguaranteeincome.incl_reinsurance_prem_inc is '其中：分保费收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.net_inc_sec_trading_brok_bus is '代理买卖证券业务净收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.net_inc_sec_uw_bus is '证券承销业务净收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.net_inc_ec_asset_mgmt_bus is '受托客户资产管理业务净收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.other_bus_inc is '其他业务收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.plus_net_gain_chg_fv is '加:公允价值变动净收益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.plus_net_invest_inc is '加:投资净收益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.incl_inc_invest_assoc_jv_entp is '其中：对联营企业和合营企业的投资收益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.plus_net_gain_fx_trans is '加:汇兑净收益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.tot_oper_cost is '营业总成本';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_oper_cost is '减:营业成本';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_int_exp is '减:利息支出';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_handling_chrg_comm_exp is '减:手续费及佣金支出';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_taxes_surcharges_ops is '减:营业税金及附加';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_selling_dist_exp is '减:销售费用';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_gerl_admin_exp is '减:管理费用';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_fin_exp is '减:财务费用';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_impair_loss_assets is '减:资产减值损失';
comment on column ${iol_schema}.wind_cbondguaranteeincome.prepay_surr is '退保金';
comment on column ${iol_schema}.wind_cbondguaranteeincome.tot_claim_exp is '赔付总支出';
comment on column ${iol_schema}.wind_cbondguaranteeincome.chg_insur_cont_rsrv is '提取保险责任准备金';
comment on column ${iol_schema}.wind_cbondguaranteeincome.dvd_exp_insured is '保户红利支出';
comment on column ${iol_schema}.wind_cbondguaranteeincome.reinsurance_exp is '分保费用';
comment on column ${iol_schema}.wind_cbondguaranteeincome.oper_exp is '营业支出';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_claim_recb_reinsurer is '减：摊回赔付支出';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_ins_rsrv_recb_reinsurer is '减：摊回保险责任准备金';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_exp_recb_reinsurer is '减：摊回分保费用';
comment on column ${iol_schema}.wind_cbondguaranteeincome.other_bus_cost is '其他业务成本';
comment on column ${iol_schema}.wind_cbondguaranteeincome.oper_profit is '营业利润';
comment on column ${iol_schema}.wind_cbondguaranteeincome.plus_non_oper_rev is '加:营业外收入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.less_non_oper_exp is '减：营业外支出';
comment on column ${iol_schema}.wind_cbondguaranteeincome.il_net_loss_disp_noncur_asset is '其中：减：非流动资产处置净损失';
comment on column ${iol_schema}.wind_cbondguaranteeincome.tot_profit is '利润总额';
comment on column ${iol_schema}.wind_cbondguaranteeincome.inc_tax is '所得税';
comment on column ${iol_schema}.wind_cbondguaranteeincome.unconfirmed_invest_loss is '未确认投资损失';
comment on column ${iol_schema}.wind_cbondguaranteeincome.net_profit_incl_min_int_inc is '净利润(含少数股东损益)';
comment on column ${iol_schema}.wind_cbondguaranteeincome.net_profit_excl_min_int_inc is '净利润(不含少数股东损益)';
comment on column ${iol_schema}.wind_cbondguaranteeincome.minority_int_inc is '少数股东损益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.other_compreh_inc is '其他综合收益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.tot_compreh_inc is '综合收益总额';
comment on column ${iol_schema}.wind_cbondguaranteeincome.tot_compreh_inc_parent_comp is '综合收益总额(母公司)';
comment on column ${iol_schema}.wind_cbondguaranteeincome.tot_compreh_inc_min_shrhldr is '综合收益总额(少数股东)';
comment on column ${iol_schema}.wind_cbondguaranteeincome.ebit is '项目金额';
comment on column ${iol_schema}.wind_cbondguaranteeincome.ebitda is '项目金额';
comment on column ${iol_schema}.wind_cbondguaranteeincome.net_profit_after_ded_nr_lp is '扣除非经常性损益后净利润';
comment on column ${iol_schema}.wind_cbondguaranteeincome.net_profit_under_intl_acc_sta is '国际会计准则净利润';
comment on column ${iol_schema}.wind_cbondguaranteeincome.comp_type_code is '公司类型代码';
comment on column ${iol_schema}.wind_cbondguaranteeincome.s_fa_eps_basic is '基本每股收益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.s_fa_eps_diluted is '稀释每股收益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.actual_ann_dt is '[内部]实际公告日期';
comment on column ${iol_schema}.wind_cbondguaranteeincome.insurance_expense is '保险业务支出';
comment on column ${iol_schema}.wind_cbondguaranteeincome.spe_bal_oper_profit is '营业利润差额(特殊报表科目)';
comment on column ${iol_schema}.wind_cbondguaranteeincome.tot_bal_oper_profit is '营业利润差额(合计平衡项目)';
comment on column ${iol_schema}.wind_cbondguaranteeincome.spe_bal_tot_profit is '利润总额差额(特殊报表科目)';
comment on column ${iol_schema}.wind_cbondguaranteeincome.tot_bal_tot_profit is '利润总额差额(合计平衡项目)';
comment on column ${iol_schema}.wind_cbondguaranteeincome.spe_bal_net_profit is '净利润差额(特殊报表科目)';
comment on column ${iol_schema}.wind_cbondguaranteeincome.tot_bal_net_profit is '净利润差额(合计平衡项目)';
comment on column ${iol_schema}.wind_cbondguaranteeincome.undistributed_profit is '年初未分配利润';
comment on column ${iol_schema}.wind_cbondguaranteeincome.adjlossgain_prevyear is '调整以前年度损益';
comment on column ${iol_schema}.wind_cbondguaranteeincome.transfer_from_surplusreserve is '盈余公积转入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.transfer_from_housingimprest is '住房周转金转入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.transfer_from_others is '其他转入';
comment on column ${iol_schema}.wind_cbondguaranteeincome.distributable_profit is '可分配利润';
comment on column ${iol_schema}.wind_cbondguaranteeincome.withdr_legalsurplus is '提取法定盈余公积';
comment on column ${iol_schema}.wind_cbondguaranteeincome.withdr_legalpubwelfunds is '提取法定公益金';
comment on column ${iol_schema}.wind_cbondguaranteeincome.workers_welfare is '职工奖金福利';
comment on column ${iol_schema}.wind_cbondguaranteeincome.withdr_buzexpwelfare is '提取企业发展基金';
comment on column ${iol_schema}.wind_cbondguaranteeincome.withdr_reservefund is '提取储备基金';
comment on column ${iol_schema}.wind_cbondguaranteeincome.distributable_profit_shrhder is '可供股东分配的利润';
comment on column ${iol_schema}.wind_cbondguaranteeincome.prfshare_dvd_payable is '应付优先股股利';
comment on column ${iol_schema}.wind_cbondguaranteeincome.withdr_othersurpreserve is '提取任意盈余公积金';
comment on column ${iol_schema}.wind_cbondguaranteeincome.comshare_dvd_payable is '应付普通股股利';
comment on column ${iol_schema}.wind_cbondguaranteeincome.capitalized_comstock_div is '转作股本的普通股股利';
comment on column ${iol_schema}.wind_cbondguaranteeincome.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondguaranteeincome.etl_timestamp is 'ETL处理时间戳';
