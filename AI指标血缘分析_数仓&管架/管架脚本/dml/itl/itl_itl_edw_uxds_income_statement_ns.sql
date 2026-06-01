/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_uxds_income_statement_ns
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
--alter table ${itl_schema}.itl_edw_uxds_income_statement_ns drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_uxds_income_statement_ns drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_uxds_income_statement_ns add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_uxds_income_statement_ns partition for (to_date('${batch_date}','yyyymmdd')) (
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录通讯到用户端时间
    ,org_id -- 机构id@关联到corp_basic_info.org_id
    ,org_name -- 机构名称
    ,sd -- 起始日期
    ,ed -- 截止日期
    ,statement_type_code -- 报表类型编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=524
    ,statement_type -- 报表类型@合并报表、母公司报表、合并报表(调整)、母公司报表(调整)
    ,chg_seq -- 变动序号@012…，0为最新
    ,statement_format_code -- 报表格式编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=594
    ,statement_format -- 报表格式@一般企业、商业银行、保险公司、证券公司
    ,sas_code -- 报表会计准则编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=595
    ,sas -- 报表会计准则@新会计准则、旧会计准则
    ,announ_seq -- 公告序号@用于确定同一公告公布的数据
    ,data_source_code -- 数据来源代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=593
    ,data_source -- 数据来源@招股说明书、上市公司定期报告、招股说明书申报稿、债券招募说明书、其他定期报告、更正公告、追溯调整公告、其它
    ,statement_source_explain -- 报表来源说明@代码+公告名称，方便查看数据来源
    ,is_statement_complete -- 报表是否完整@0：简表（简表只有几个主要科目，可能不适用报表平衡公式）；1：详表
    ,currency_code -- 货币代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=518
    ,is_audited -- 是否审计@0为未审计；1：已审计
    ,announcement_date -- 公告日期
    ,total_revenue -- 一、营业总收入@元
    ,revenue -- 营业收入@元
    ,interest_net_income -- 利息净收入@元
    ,interest_income -- 利息收入@元
    ,interest_payout -- 利息支出@元
    ,commi_net_income -- 手续费及佣金净收入@元
    ,fee_and_commi_income -- 手续费及佣金收入@元
    ,charge_and_commi_expenses -- 手续费及佣金支出@元
    ,othr_income -- 其他业务收入@元
    ,earned_premium -- 已赚保费@元
    ,insurance_income -- 保险业务收入@元
    ,rein_premium_income -- 其中：分保费收入@元
    ,ceded_out_premium -- 减：分出保费@元
    ,draw_undueduty_deposit -- 提取未到期责任准备金@元
    ,net_income_from_brokerage -- 其中：经纪业务手续费净收入@元
    ,net_income_from_invest_banking -- 投资银行业务手续费净收入@元
    ,asset_manage_service_charge_ni -- 资产管理业务手续费净收入@元
    ,operating_total_revenue_si -- 营业总收入特殊科目@元；用于存放标准格式以外科目，例如利息收入
    ,operating_costs -- 二、营业总成本@元
    ,operating_cost -- 其中：营业成本@元
    ,operating_taxes_and_surcharge -- 营业税金及附加@元
    ,sales_fee -- 销售费用@元
    ,manage_fee -- 管理费用@元
    ,financing_expenses -- 财务费用@元
    ,asset_impairment_loss -- 资产减值损失@元
    ,operating_payout -- 营业支出@元
    ,business_and_manage_fee -- 业务及管理费@元
    ,othr_business_costs -- 其他业务成本@元
    ,refunded_premium -- 退保金@元
    ,compen_payout -- 赔付支出@元
    ,compen_expense -- 减：摊回赔付支出@元
    ,draw_duty_deposit -- 提取保险责任准备金@元
    ,amortized_deposit_for_duty -- 减：摊回保险责任准备金@元
    ,commi_on_insurance_policy -- 保单红利支出@元
    ,rein_expenditure -- 分保费用@元
    ,amortized_rein_expenditure -- 减：摊回分保费用@元
    ,operating_total_cost_si -- 营业总成本特殊科目@元；用于存放标准格式以外科目，例如利息支出
    ,income_from_chg_in_fv -- 加：公允价值变动收益@元
    ,invest_income -- 投资收益@元
    ,invest_incomes_from_rr -- 其中：对联营企业和合营企业的投资收益@元
    ,exchg_gain -- 汇兑收益@元
    ,op -- 三、营业利润@元
    ,non_operating_income -- 加：营业外收入@元
    ,non_operating_payout -- 减：营业外支出@元
    ,noncurrent_asset_disposal_loss -- 其中：非流动资产处置损失@元
    ,profit_total_amt -- 四、利润总额@元
    ,income_tax_expenses -- 减：所得税费用@元
    ,net_profit -- 五、净利润@元
    ,net_profit_atsopc -- 归属于母公司股东的净利润@元
    ,minority_gal -- 少数股东损益@元
    ,othr_compre_income -- 其他综合收益@元
    ,total_compre_income -- 综合收益总额@元
    ,total_compre_income_atsopc -- 归属于母公司股东的综合收益总额@元
    ,total_compre_income_atms -- 归属于少数股东的综合收益总额@元
    ,is_statement_released_values -- 报表是否公布值@0：非公布值；1：公布值
    ,operating_total_revenue_bi -- 营业总收入平衡科目@单位：元
    ,operating_total_cost_bi -- 营业总成本平衡科目@单位：元
    ,op_si -- 营业利润特殊科目@单位：元
    ,op_bi -- 营业利润平衡科目@单位：元
    ,total_profit_si -- 利润总额特殊科目@单位：元
    ,total_profit_bi -- 利润总额平衡科目@单位：元
    ,net_profit_si -- 净利润特殊科目@单位：元
    ,net_profit_bi -- 净利润平衡科目@单位：元
    ,basic_eps -- 基本每股收益@单位：元
    ,dlt_earnings_per_share -- 稀释每股收益@单位：元
    ,special_explain -- 特殊情况说明@简要描述特殊情况及处理说明
    ,noncurrent_assets_dispose_gain -- 其中：非流动资产处置利得@单位：元
    ,othr_compre_income_atoopc -- 归属母公司所有者的其他综合收益@单位：元
    ,othr_ci_nonreclassi_into_gal -- （一）以后不能重分类进损益的其他综合收益@单位：元
    ,net_debt_or_na_chg_reclac -- 1.重新计量设定受益计划净负债或净资产的变动@单位：元
    ,can_not_be_reclassi_em -- 2.权益法下在被投资单位不能重分类进损益的其他综合收益中享有的份额@单位：元
    ,othr_ci_to_reclassi_into_gal -- （二）以后将重分类进损益的其他综合收益@单位：元
    ,will_reclassi_equity_method -- 1.权益法下在被投资单位以后将重分类进损益的其他综合收益中享有的份额@单位：元
    ,salable_fnncl_asset_fvc_gal -- 2.可供出售金融资产公允价值变动损益@单位：元
    ,htm_salable_fnncl_asset_gal -- 3.持有至到期投资重分类为可供出售金融资产损益@单位：元
    ,cash_flow_gal_valid_part -- 4.现金流量套期损益的有效部分@单位：元
    ,frgn_currency_statement_diff -- 5.外币财务报表折算差额@单位：元
    ,other_reclassi -- 6.其他@单位：元
    ,othr_compre_income_atms -- 归属于少数股东的其他综合收益@单位：元
    ,other_not_reclassi -- 3.其他@单位：元
    ,other_income -- 其他收益@单位：元
    ,asset_disposal_income -- 资产处置收益@单位：元
    ,stop_operating_np -- （二）终止经营净利润@单位：元
    ,continous_operating_np -- （一）持续经营净利润@单位：元
    ,cash_flow_hedging_reserve -- 10.现金流量套期储备@单元：元
    ,other_eq_ins_invest_fv_chg -- 4.其他权益工具投资公允价值变动@单元：元
    ,credit_risk_fv_chg -- 5.企业自身信用风险公允价值变动@单元：元
    ,other_debt_invest_fv_chg -- 7.其他债权投资公允价值变动@单元：元
    ,fnncl_assets_rec_other_income -- 8.金融资产重分类计入其他综合收益的金额@单元：元
    ,other_debt_invest_credit_loss -- 9.其他债权投资信用减值准备@单元：元
    ,credit_impairment_loss -- 信用减值损失@单元：元
    ,finance_cost_interest_fee -- 财务费用：利息费用@单元：元
    ,net_exposure_hedging_benefits -- 净敞口套期收益@单元：元
    ,finance_cost_interest_income -- 财务费用：利息收入@单元：元
    ,rad_cost -- 研发费用@单元：元
    ,general_corp_operating_cost_pf -- 一般企业营业总成本公布格式@空值或1：营业总成本包含资产减值损失和信用减值损失，2：营业总成本不包含资产减值损失和信用减值损失
    ,amortized_cost_fnncl_asset_tce -- 以摊余成本计量的金融资产终止确认收益@单位：元
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(seq), 0) as seq -- 记录唯一标识
    ,nvl(ctime, to_date('00010101', 'yyyymmdd')) as ctime -- 记录创建时间
    ,nvl(mtime, to_date('00010101', 'yyyymmdd')) as mtime -- 记录修改时间
    ,nvl(rtime, to_date('00010101', 'yyyymmdd')) as rtime -- 记录通讯到用户端时间
    ,nvl(trim(org_id), ' ') as org_id -- 机构id@关联到corp_basic_info.org_id
    ,nvl(trim(org_name), ' ') as org_name -- 机构名称
    ,nvl(sd, to_date('00010101', 'yyyymmdd')) as sd -- 起始日期
    ,nvl(ed, to_date('00010101', 'yyyymmdd')) as ed -- 截止日期
    ,nvl(trim(statement_type_code), ' ') as statement_type_code -- 报表类型编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=524
    ,nvl(trim(statement_type), ' ') as statement_type -- 报表类型@合并报表、母公司报表、合并报表(调整)、母公司报表(调整)
    ,nvl(trim(chg_seq), 0) as chg_seq -- 变动序号@012…，0为最新
    ,nvl(trim(statement_format_code), ' ') as statement_format_code -- 报表格式编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=594
    ,nvl(trim(statement_format), ' ') as statement_format -- 报表格式@一般企业、商业银行、保险公司、证券公司
    ,nvl(trim(sas_code), ' ') as sas_code -- 报表会计准则编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=595
    ,nvl(trim(sas), ' ') as sas -- 报表会计准则@新会计准则、旧会计准则
    ,nvl(trim(announ_seq), 0) as announ_seq -- 公告序号@用于确定同一公告公布的数据
    ,nvl(trim(data_source_code), ' ') as data_source_code -- 数据来源代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=593
    ,nvl(trim(data_source), ' ') as data_source -- 数据来源@招股说明书、上市公司定期报告、招股说明书申报稿、债券招募说明书、其他定期报告、更正公告、追溯调整公告、其它
    ,nvl(trim(statement_source_explain), ' ') as statement_source_explain -- 报表来源说明@代码+公告名称，方便查看数据来源
    ,nvl(trim(is_statement_complete), 0) as is_statement_complete -- 报表是否完整@0：简表（简表只有几个主要科目，可能不适用报表平衡公式）；1：详表
    ,nvl(trim(currency_code), ' ') as currency_code -- 货币代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=518
    ,nvl(trim(is_audited), 0) as is_audited -- 是否审计@0为未审计；1：已审计
    ,nvl(announcement_date, to_date('00010101', 'yyyymmdd')) as announcement_date -- 公告日期
    ,nvl(trim(total_revenue), 0) as total_revenue -- 一、营业总收入@元
    ,nvl(trim(revenue), 0) as revenue -- 营业收入@元
    ,nvl(trim(interest_net_income), 0) as interest_net_income -- 利息净收入@元
    ,nvl(trim(interest_income), 0) as interest_income -- 利息收入@元
    ,nvl(trim(interest_payout), 0) as interest_payout -- 利息支出@元
    ,nvl(trim(commi_net_income), 0) as commi_net_income -- 手续费及佣金净收入@元
    ,nvl(trim(fee_and_commi_income), 0) as fee_and_commi_income -- 手续费及佣金收入@元
    ,nvl(trim(charge_and_commi_expenses), 0) as charge_and_commi_expenses -- 手续费及佣金支出@元
    ,nvl(trim(othr_income), 0) as othr_income -- 其他业务收入@元
    ,nvl(trim(earned_premium), 0) as earned_premium -- 已赚保费@元
    ,nvl(trim(insurance_income), 0) as insurance_income -- 保险业务收入@元
    ,nvl(trim(rein_premium_income), 0) as rein_premium_income -- 其中：分保费收入@元
    ,nvl(trim(ceded_out_premium), 0) as ceded_out_premium -- 减：分出保费@元
    ,nvl(trim(draw_undueduty_deposit), 0) as draw_undueduty_deposit -- 提取未到期责任准备金@元
    ,nvl(trim(net_income_from_brokerage), 0) as net_income_from_brokerage -- 其中：经纪业务手续费净收入@元
    ,nvl(trim(net_income_from_invest_banking), 0) as net_income_from_invest_banking -- 投资银行业务手续费净收入@元
    ,nvl(trim(asset_manage_service_charge_ni), 0) as asset_manage_service_charge_ni -- 资产管理业务手续费净收入@元
    ,nvl(trim(operating_total_revenue_si), 0) as operating_total_revenue_si -- 营业总收入特殊科目@元；用于存放标准格式以外科目，例如利息收入
    ,nvl(trim(operating_costs), 0) as operating_costs -- 二、营业总成本@元
    ,nvl(trim(operating_cost), 0) as operating_cost -- 其中：营业成本@元
    ,nvl(trim(operating_taxes_and_surcharge), 0) as operating_taxes_and_surcharge -- 营业税金及附加@元
    ,nvl(trim(sales_fee), 0) as sales_fee -- 销售费用@元
    ,nvl(trim(manage_fee), 0) as manage_fee -- 管理费用@元
    ,nvl(trim(financing_expenses), 0) as financing_expenses -- 财务费用@元
    ,nvl(trim(asset_impairment_loss), 0) as asset_impairment_loss -- 资产减值损失@元
    ,nvl(trim(operating_payout), 0) as operating_payout -- 营业支出@元
    ,nvl(trim(business_and_manage_fee), 0) as business_and_manage_fee -- 业务及管理费@元
    ,nvl(trim(othr_business_costs), 0) as othr_business_costs -- 其他业务成本@元
    ,nvl(trim(refunded_premium), 0) as refunded_premium -- 退保金@元
    ,nvl(trim(compen_payout), 0) as compen_payout -- 赔付支出@元
    ,nvl(trim(compen_expense), 0) as compen_expense -- 减：摊回赔付支出@元
    ,nvl(trim(draw_duty_deposit), 0) as draw_duty_deposit -- 提取保险责任准备金@元
    ,nvl(trim(amortized_deposit_for_duty), 0) as amortized_deposit_for_duty -- 减：摊回保险责任准备金@元
    ,nvl(trim(commi_on_insurance_policy), 0) as commi_on_insurance_policy -- 保单红利支出@元
    ,nvl(trim(rein_expenditure), 0) as rein_expenditure -- 分保费用@元
    ,nvl(trim(amortized_rein_expenditure), 0) as amortized_rein_expenditure -- 减：摊回分保费用@元
    ,nvl(trim(operating_total_cost_si), 0) as operating_total_cost_si -- 营业总成本特殊科目@元；用于存放标准格式以外科目，例如利息支出
    ,nvl(trim(income_from_chg_in_fv), 0) as income_from_chg_in_fv -- 加：公允价值变动收益@元
    ,nvl(trim(invest_income), 0) as invest_income -- 投资收益@元
    ,nvl(trim(invest_incomes_from_rr), 0) as invest_incomes_from_rr -- 其中：对联营企业和合营企业的投资收益@元
    ,nvl(trim(exchg_gain), 0) as exchg_gain -- 汇兑收益@元
    ,nvl(trim(op), 0) as op -- 三、营业利润@元
    ,nvl(trim(non_operating_income), 0) as non_operating_income -- 加：营业外收入@元
    ,nvl(trim(non_operating_payout), 0) as non_operating_payout -- 减：营业外支出@元
    ,nvl(trim(noncurrent_asset_disposal_loss), 0) as noncurrent_asset_disposal_loss -- 其中：非流动资产处置损失@元
    ,nvl(trim(profit_total_amt), 0) as profit_total_amt -- 四、利润总额@元
    ,nvl(trim(income_tax_expenses), 0) as income_tax_expenses -- 减：所得税费用@元
    ,nvl(trim(net_profit), 0) as net_profit -- 五、净利润@元
    ,nvl(trim(net_profit_atsopc), 0) as net_profit_atsopc -- 归属于母公司股东的净利润@元
    ,nvl(trim(minority_gal), 0) as minority_gal -- 少数股东损益@元
    ,nvl(trim(othr_compre_income), 0) as othr_compre_income -- 其他综合收益@元
    ,nvl(trim(total_compre_income), 0) as total_compre_income -- 综合收益总额@元
    ,nvl(trim(total_compre_income_atsopc), 0) as total_compre_income_atsopc -- 归属于母公司股东的综合收益总额@元
    ,nvl(trim(total_compre_income_atms), 0) as total_compre_income_atms -- 归属于少数股东的综合收益总额@元
    ,nvl(trim(is_statement_released_values), 0) as is_statement_released_values -- 报表是否公布值@0：非公布值；1：公布值
    ,nvl(trim(operating_total_revenue_bi), 0) as operating_total_revenue_bi -- 营业总收入平衡科目@单位：元
    ,nvl(trim(operating_total_cost_bi), 0) as operating_total_cost_bi -- 营业总成本平衡科目@单位：元
    ,nvl(trim(op_si), 0) as op_si -- 营业利润特殊科目@单位：元
    ,nvl(trim(op_bi), 0) as op_bi -- 营业利润平衡科目@单位：元
    ,nvl(trim(total_profit_si), 0) as total_profit_si -- 利润总额特殊科目@单位：元
    ,nvl(trim(total_profit_bi), 0) as total_profit_bi -- 利润总额平衡科目@单位：元
    ,nvl(trim(net_profit_si), 0) as net_profit_si -- 净利润特殊科目@单位：元
    ,nvl(trim(net_profit_bi), 0) as net_profit_bi -- 净利润平衡科目@单位：元
    ,nvl(trim(basic_eps), 0) as basic_eps -- 基本每股收益@单位：元
    ,nvl(trim(dlt_earnings_per_share), 0) as dlt_earnings_per_share -- 稀释每股收益@单位：元
    ,nvl(trim(special_explain), ' ') as special_explain -- 特殊情况说明@简要描述特殊情况及处理说明
    ,nvl(trim(noncurrent_assets_dispose_gain), 0) as noncurrent_assets_dispose_gain -- 其中：非流动资产处置利得@单位：元
    ,nvl(trim(othr_compre_income_atoopc), 0) as othr_compre_income_atoopc -- 归属母公司所有者的其他综合收益@单位：元
    ,nvl(trim(othr_ci_nonreclassi_into_gal), 0) as othr_ci_nonreclassi_into_gal -- （一）以后不能重分类进损益的其他综合收益@单位：元
    ,nvl(trim(net_debt_or_na_chg_reclac), 0) as net_debt_or_na_chg_reclac -- 1.重新计量设定受益计划净负债或净资产的变动@单位：元
    ,nvl(trim(can_not_be_reclassi_em), 0) as can_not_be_reclassi_em -- 2.权益法下在被投资单位不能重分类进损益的其他综合收益中享有的份额@单位：元
    ,nvl(trim(othr_ci_to_reclassi_into_gal), 0) as othr_ci_to_reclassi_into_gal -- （二）以后将重分类进损益的其他综合收益@单位：元
    ,nvl(trim(will_reclassi_equity_method), 0) as will_reclassi_equity_method -- 1.权益法下在被投资单位以后将重分类进损益的其他综合收益中享有的份额@单位：元
    ,nvl(trim(salable_fnncl_asset_fvc_gal), 0) as salable_fnncl_asset_fvc_gal -- 2.可供出售金融资产公允价值变动损益@单位：元
    ,nvl(trim(htm_salable_fnncl_asset_gal), 0) as htm_salable_fnncl_asset_gal -- 3.持有至到期投资重分类为可供出售金融资产损益@单位：元
    ,nvl(trim(cash_flow_gal_valid_part), 0) as cash_flow_gal_valid_part -- 4.现金流量套期损益的有效部分@单位：元
    ,nvl(trim(frgn_currency_statement_diff), 0) as frgn_currency_statement_diff -- 5.外币财务报表折算差额@单位：元
    ,nvl(trim(other_reclassi), 0) as other_reclassi -- 6.其他@单位：元
    ,nvl(trim(othr_compre_income_atms), 0) as othr_compre_income_atms -- 归属于少数股东的其他综合收益@单位：元
    ,nvl(trim(other_not_reclassi), 0) as other_not_reclassi -- 3.其他@单位：元
    ,nvl(trim(other_income), 0) as other_income -- 其他收益@单位：元
    ,nvl(trim(asset_disposal_income), 0) as asset_disposal_income -- 资产处置收益@单位：元
    ,nvl(trim(stop_operating_np), 0) as stop_operating_np -- （二）终止经营净利润@单位：元
    ,nvl(trim(continous_operating_np), 0) as continous_operating_np -- （一）持续经营净利润@单位：元
    ,nvl(trim(cash_flow_hedging_reserve), 0) as cash_flow_hedging_reserve -- 10.现金流量套期储备@单元：元
    ,nvl(trim(other_eq_ins_invest_fv_chg), 0) as other_eq_ins_invest_fv_chg -- 4.其他权益工具投资公允价值变动@单元：元
    ,nvl(trim(credit_risk_fv_chg), 0) as credit_risk_fv_chg -- 5.企业自身信用风险公允价值变动@单元：元
    ,nvl(trim(other_debt_invest_fv_chg), 0) as other_debt_invest_fv_chg -- 7.其他债权投资公允价值变动@单元：元
    ,nvl(trim(fnncl_assets_rec_other_income), 0) as fnncl_assets_rec_other_income -- 8.金融资产重分类计入其他综合收益的金额@单元：元
    ,nvl(trim(other_debt_invest_credit_loss), 0) as other_debt_invest_credit_loss -- 9.其他债权投资信用减值准备@单元：元
    ,nvl(trim(credit_impairment_loss), 0) as credit_impairment_loss -- 信用减值损失@单元：元
    ,nvl(trim(finance_cost_interest_fee), 0) as finance_cost_interest_fee -- 财务费用：利息费用@单元：元
    ,nvl(trim(net_exposure_hedging_benefits), 0) as net_exposure_hedging_benefits -- 净敞口套期收益@单元：元
    ,nvl(trim(finance_cost_interest_income), 0) as finance_cost_interest_income -- 财务费用：利息收入@单元：元
    ,nvl(trim(rad_cost), 0) as rad_cost -- 研发费用@单元：元
    ,nvl(trim(general_corp_operating_cost_pf), 0) as general_corp_operating_cost_pf -- 一般企业营业总成本公布格式@空值或1：营业总成本包含资产减值损失和信用减值损失，2：营业总成本不包含资产减值损失和信用减值损失
    ,nvl(trim(amortized_cost_fnncl_asset_tce), 0) as amortized_cost_fnncl_asset_tce -- 以摊余成本计量的金融资产终止确认收益@单位：元
    ,nvl(trim(isvalid), 0) as isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_uxds_income_statement_ns
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_uxds_income_statement_ns to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_uxds_income_statement_ns',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);