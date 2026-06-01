/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_ashareincome
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
drop table ${iol_schema}.wind_ashareincome_ex purge;
alter table ${iol_schema}.wind_ashareincome add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.wind_ashareincome truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.wind_ashareincome_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.wind_ashareincome where 0=1;

insert /*+ append */ into ${iol_schema}.wind_ashareincome_ex(
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,wind_code -- Wind代码
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,crncy_code -- 货币代码
    ,tot_oper_rev -- 营业总收入
    ,oper_rev -- 营业收入
    ,int_inc -- 利息收入
    ,net_int_inc -- 利息净收入
    ,insur_prem_unearned -- 已赚保费
    ,handling_chrg_comm_inc -- 手续费及佣金收入
    ,net_handling_chrg_comm_inc -- 手续费及佣金净收入
    ,net_inc_other_ops -- 其他经营净收益
    ,plus_net_inc_other_bus -- 加:其他业务净收益
    ,prem_inc -- 保费业务收入
    ,less_ceded_out_prem -- 减:分出保费
    ,chg_unearned_prem_res -- 提取未到期责任准备金
    ,incl_reinsurance_prem_inc -- 其中:分保费收入
    ,net_inc_sec_trading_brok_bus -- 代理买卖证券业务净收入
    ,net_inc_sec_uw_bus -- 证券承销业务净收入
    ,net_inc_ec_asset_mgmt_bus -- 受托客户资产管理业务净收入
    ,other_bus_inc -- 其他业务收入
    ,plus_net_gain_chg_fv -- 加:公允价值变动净收益
    ,plus_net_invest_inc -- 加:投资净收益
    ,incl_inc_invest_assoc_jv_entp -- 其中:对联营企业和合营企业的投资收益
    ,plus_net_gain_fx_trans -- 加:汇兑净收益
    ,tot_oper_cost -- 营业总成本
    ,less_oper_cost -- 减:营业成本
    ,less_int_exp -- 减:利息支出
    ,less_handling_chrg_comm_exp -- 减:手续费及佣金支出
    ,less_taxes_surcharges_ops -- 减:营业税金及附加
    ,less_selling_dist_exp -- 减:销售费用
    ,less_gerl_admin_exp -- 减:管理费用
    ,less_fin_exp -- 减:财务费用
    ,less_impair_loss_assets -- 减:资产减值损失
    ,prepay_surr -- 退保金
    ,tot_claim_exp -- 赔付总支出
    ,chg_insur_cont_rsrv -- 提取保险责任准备金
    ,dvd_exp_insured -- 保户红利支出
    ,reinsurance_exp -- 分保费用
    ,oper_exp -- 营业支出
    ,less_claim_recb_reinsurer -- 减:摊回赔付支出
    ,less_ins_rsrv_recb_reinsurer -- 减:摊回保险责任准备金
    ,less_exp_recb_reinsurer -- 减:摊回分保费用
    ,other_bus_cost -- 其他业务成本
    ,oper_profit -- 营业利润
    ,plus_non_oper_rev -- 加:营业外收入
    ,less_non_oper_exp -- 减:营业外支出
    ,il_net_loss_disp_noncur_asset -- 其中:减:非流动资产处置净损失
    ,tot_profit -- 利润总额
    ,inc_tax -- 所得税
    ,unconfirmed_invest_loss -- 未确认投资损失
    ,net_profit_incl_min_int_inc -- 净利润(含少数股东损益)
    ,net_profit_excl_min_int_inc -- 净利润(不含少数股东损益)
    ,minority_int_inc -- 少数股东损益
    ,other_compreh_inc -- 其他综合收益
    ,tot_compreh_inc -- 综合收益总额
    ,tot_compreh_inc_parent_comp -- 综合收益总额(母公司)
    ,tot_compreh_inc_min_shrhldr -- 综合收益总额(少数股东)
    ,ebit -- 息税前利润
    ,ebitda -- 息税折旧摊销前利润
    ,net_profit_after_ded_nr_lp -- 扣除非经常性损益后净利润（扣除少数股东损益）
    ,net_profit_under_intl_acc_sta -- 国际会计准则净利润
    ,comp_type_code -- 公司类型代码
    ,s_fa_eps_basic -- 基本每股收益
    ,s_fa_eps_diluted -- 稀释每股收益
    ,actual_ann_dt -- 实际公告日期
    ,insurance_expense -- 保险业务支出
    ,spe_bal_oper_profit -- 营业利润差额(特殊报表科目)
    ,tot_bal_oper_profit -- 营业利润差额(合计平衡项目)
    ,spe_bal_tot_profit -- 利润总额差额(特殊报表科目)
    ,tot_bal_tot_profit -- 利润总额差额(合计平衡项目)
    ,spe_bal_net_profit -- 净利润差额(特殊报表科目)
    ,tot_bal_net_profit -- 净利润差额(合计平衡项目)
    ,undistributed_profit -- 年初未分配利润
    ,adjlossgain_prevyear -- 调整以前年度损益
    ,transfer_from_surplusreserve -- 盈余公积转入
    ,transfer_from_housingimprest -- 住房周转金转入
    ,transfer_from_others -- 其他转入
    ,distributable_profit -- 可分配利润
    ,withdr_legalsurplus -- 提取法定盈余公积
    ,withdr_legalpubwelfunds -- 提取法定公益金
    ,workers_welfare -- 职工奖金福利
    ,withdr_buzexpwelfare -- 提取企业发展基金
    ,withdr_reservefund -- 提取储备基金
    ,distributable_profit_shrhder -- 可供股东分配的利润
    ,prfshare_dvd_payable -- 应付优先股股利
    ,withdr_othersurpreserve -- 提取任意盈余公积金
    ,comshare_dvd_payable -- 应付普通股股利
    ,capitalized_comstock_div -- 转作股本的普通股股利
    ,s_info_compcode -- 公司ID
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    object_id -- 对象ID
    ,s_info_windcode -- Wind代码
    ,wind_code -- Wind代码
    ,ann_dt -- 公告日期
    ,report_period -- 报告期
    ,statement_type -- 报表类型
    ,crncy_code -- 货币代码
    ,tot_oper_rev -- 营业总收入
    ,oper_rev -- 营业收入
    ,int_inc -- 利息收入
    ,net_int_inc -- 利息净收入
    ,insur_prem_unearned -- 已赚保费
    ,handling_chrg_comm_inc -- 手续费及佣金收入
    ,net_handling_chrg_comm_inc -- 手续费及佣金净收入
    ,net_inc_other_ops -- 其他经营净收益
    ,plus_net_inc_other_bus -- 加:其他业务净收益
    ,prem_inc -- 保费业务收入
    ,less_ceded_out_prem -- 减:分出保费
    ,chg_unearned_prem_res -- 提取未到期责任准备金
    ,incl_reinsurance_prem_inc -- 其中:分保费收入
    ,net_inc_sec_trading_brok_bus -- 代理买卖证券业务净收入
    ,net_inc_sec_uw_bus -- 证券承销业务净收入
    ,net_inc_ec_asset_mgmt_bus -- 受托客户资产管理业务净收入
    ,other_bus_inc -- 其他业务收入
    ,plus_net_gain_chg_fv -- 加:公允价值变动净收益
    ,plus_net_invest_inc -- 加:投资净收益
    ,incl_inc_invest_assoc_jv_entp -- 其中:对联营企业和合营企业的投资收益
    ,plus_net_gain_fx_trans -- 加:汇兑净收益
    ,tot_oper_cost -- 营业总成本
    ,less_oper_cost -- 减:营业成本
    ,less_int_exp -- 减:利息支出
    ,less_handling_chrg_comm_exp -- 减:手续费及佣金支出
    ,less_taxes_surcharges_ops -- 减:营业税金及附加
    ,less_selling_dist_exp -- 减:销售费用
    ,less_gerl_admin_exp -- 减:管理费用
    ,less_fin_exp -- 减:财务费用
    ,less_impair_loss_assets -- 减:资产减值损失
    ,prepay_surr -- 退保金
    ,tot_claim_exp -- 赔付总支出
    ,chg_insur_cont_rsrv -- 提取保险责任准备金
    ,dvd_exp_insured -- 保户红利支出
    ,reinsurance_exp -- 分保费用
    ,oper_exp -- 营业支出
    ,less_claim_recb_reinsurer -- 减:摊回赔付支出
    ,less_ins_rsrv_recb_reinsurer -- 减:摊回保险责任准备金
    ,less_exp_recb_reinsurer -- 减:摊回分保费用
    ,other_bus_cost -- 其他业务成本
    ,oper_profit -- 营业利润
    ,plus_non_oper_rev -- 加:营业外收入
    ,less_non_oper_exp -- 减:营业外支出
    ,il_net_loss_disp_noncur_asset -- 其中:减:非流动资产处置净损失
    ,tot_profit -- 利润总额
    ,inc_tax -- 所得税
    ,unconfirmed_invest_loss -- 未确认投资损失
    ,net_profit_incl_min_int_inc -- 净利润(含少数股东损益)
    ,net_profit_excl_min_int_inc -- 净利润(不含少数股东损益)
    ,minority_int_inc -- 少数股东损益
    ,other_compreh_inc -- 其他综合收益
    ,tot_compreh_inc -- 综合收益总额
    ,tot_compreh_inc_parent_comp -- 综合收益总额(母公司)
    ,tot_compreh_inc_min_shrhldr -- 综合收益总额(少数股东)
    ,ebit -- 息税前利润
    ,ebitda -- 息税折旧摊销前利润
    ,net_profit_after_ded_nr_lp -- 扣除非经常性损益后净利润（扣除少数股东损益）
    ,net_profit_under_intl_acc_sta -- 国际会计准则净利润
    ,comp_type_code -- 公司类型代码
    ,s_fa_eps_basic -- 基本每股收益
    ,s_fa_eps_diluted -- 稀释每股收益
    ,actual_ann_dt -- 实际公告日期
    ,insurance_expense -- 保险业务支出
    ,spe_bal_oper_profit -- 营业利润差额(特殊报表科目)
    ,tot_bal_oper_profit -- 营业利润差额(合计平衡项目)
    ,spe_bal_tot_profit -- 利润总额差额(特殊报表科目)
    ,tot_bal_tot_profit -- 利润总额差额(合计平衡项目)
    ,spe_bal_net_profit -- 净利润差额(特殊报表科目)
    ,tot_bal_net_profit -- 净利润差额(合计平衡项目)
    ,undistributed_profit -- 年初未分配利润
    ,adjlossgain_prevyear -- 调整以前年度损益
    ,transfer_from_surplusreserve -- 盈余公积转入
    ,transfer_from_housingimprest -- 住房周转金转入
    ,transfer_from_others -- 其他转入
    ,distributable_profit -- 可分配利润
    ,withdr_legalsurplus -- 提取法定盈余公积
    ,withdr_legalpubwelfunds -- 提取法定公益金
    ,workers_welfare -- 职工奖金福利
    ,withdr_buzexpwelfare -- 提取企业发展基金
    ,withdr_reservefund -- 提取储备基金
    ,distributable_profit_shrhder -- 可供股东分配的利润
    ,prfshare_dvd_payable -- 应付优先股股利
    ,withdr_othersurpreserve -- 提取任意盈余公积金
    ,comshare_dvd_payable -- 应付普通股股利
    ,capitalized_comstock_div -- 转作股本的普通股股利
    ,s_info_compcode -- 公司ID
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.wind_ashareincome
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.wind_ashareincome exchange partition p_${batch_date} with table ${iol_schema}.wind_ashareincome_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_ashareincome to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.wind_ashareincome_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_ashareincome',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);