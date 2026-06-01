/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_income_statement_ns
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_income_statement_ns
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_income_statement_ns purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_income_statement_ns(
    seq number(28,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录通讯到用户端时间
    ,org_id varchar2(60) -- 机构id@关联到corp_basic_info.org_id
    ,org_name varchar2(600) -- 机构名称
    ,sd date -- 起始日期
    ,ed date -- 截止日期
    ,statement_type_code varchar2(36) -- 报表类型编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=524
    ,statement_type varchar2(120) -- 报表类型@合并报表、母公司报表、合并报表(调整)、母公司报表(调整)
    ,chg_seq number(3,0) -- 变动序号@012…，0为最新
    ,statement_format_code varchar2(36) -- 报表格式编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=594
    ,statement_format varchar2(120) -- 报表格式@一般企业、商业银行、保险公司、证券公司
    ,sas_code varchar2(36) -- 报表会计准则编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=595
    ,sas varchar2(120) -- 报表会计准则@新会计准则、旧会计准则
    ,announ_seq number(20,0) -- 公告序号@用于确定同一公告公布的数据
    ,data_source_code varchar2(36) -- 数据来源代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=593
    ,data_source varchar2(120) -- 数据来源@招股说明书、上市公司定期报告、招股说明书申报稿、债券招募说明书、其他定期报告、更正公告、追溯调整公告、其它
    ,statement_source_explain varchar2(300) -- 报表来源说明@代码+公告名称，方便查看数据来源
    ,is_statement_complete number(1,0) -- 报表是否完整@0：简表（简表只有几个主要科目，可能不适用报表平衡公式）；1：详表
    ,currency_code varchar2(36) -- 货币代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=518
    ,is_audited number(1,0) -- 是否审计@0为未审计；1：已审计
    ,announcement_date date -- 公告日期
    ,total_revenue number(18,4) -- 一、营业总收入@元
    ,revenue number(18,4) -- 营业收入@元
    ,interest_net_income number(18,4) -- 利息净收入@元
    ,interest_income number(18,4) -- 利息收入@元
    ,interest_payout number(18,4) -- 利息支出@元
    ,commi_net_income number(18,4) -- 手续费及佣金净收入@元
    ,fee_and_commi_income number(18,4) -- 手续费及佣金收入@元
    ,charge_and_commi_expenses number(18,4) -- 手续费及佣金支出@元
    ,othr_income number(18,4) -- 其他业务收入@元
    ,earned_premium number(18,4) -- 已赚保费@元
    ,insurance_income number(18,4) -- 保险业务收入@元
    ,rein_premium_income number(18,4) -- 其中：分保费收入@元
    ,ceded_out_premium number(18,4) -- 减：分出保费@元
    ,draw_undueduty_deposit number(18,4) -- 提取未到期责任准备金@元
    ,net_income_from_brokerage number(18,4) -- 其中：经纪业务手续费净收入@元
    ,net_income_from_invest_banking number(18,4) -- 投资银行业务手续费净收入@元
    ,asset_manage_service_charge_ni number(18,4) -- 资产管理业务手续费净收入@元
    ,operating_total_revenue_si number(18,4) -- 营业总收入特殊科目@元；用于存放标准格式以外科目，例如利息收入
    ,operating_costs number(18,4) -- 二、营业总成本@元
    ,operating_cost number(18,4) -- 其中：营业成本@元
    ,operating_taxes_and_surcharge number(18,4) -- 营业税金及附加@元
    ,sales_fee number(18,4) -- 销售费用@元
    ,manage_fee number(18,4) -- 管理费用@元
    ,financing_expenses number(18,4) -- 财务费用@元
    ,asset_impairment_loss number(18,4) -- 资产减值损失@元
    ,operating_payout number(18,4) -- 营业支出@元
    ,business_and_manage_fee number(18,4) -- 业务及管理费@元
    ,othr_business_costs number(18,4) -- 其他业务成本@元
    ,refunded_premium number(18,4) -- 退保金@元
    ,compen_payout number(18,4) -- 赔付支出@元
    ,compen_expense number(18,4) -- 减：摊回赔付支出@元
    ,draw_duty_deposit number(18,4) -- 提取保险责任准备金@元
    ,amortized_deposit_for_duty number(18,4) -- 减：摊回保险责任准备金@元
    ,commi_on_insurance_policy number(18,4) -- 保单红利支出@元
    ,rein_expenditure number(18,4) -- 分保费用@元
    ,amortized_rein_expenditure number(18,4) -- 减：摊回分保费用@元
    ,operating_total_cost_si number(18,4) -- 营业总成本特殊科目@元；用于存放标准格式以外科目，例如利息支出
    ,income_from_chg_in_fv number(18,4) -- 加：公允价值变动收益@元
    ,invest_income number(18,4) -- 投资收益@元
    ,invest_incomes_from_rr number(18,4) -- 其中：对联营企业和合营企业的投资收益@元
    ,exchg_gain number(18,4) -- 汇兑收益@元
    ,op number(18,4) -- 三、营业利润@元
    ,non_operating_income number(18,4) -- 加：营业外收入@元
    ,non_operating_payout number(18,4) -- 减：营业外支出@元
    ,noncurrent_asset_disposal_loss number(18,4) -- 其中：非流动资产处置损失@元
    ,profit_total_amt number(18,4) -- 四、利润总额@元
    ,income_tax_expenses number(18,4) -- 减：所得税费用@元
    ,net_profit number(18,4) -- 五、净利润@元
    ,net_profit_atsopc number(18,4) -- 归属于母公司股东的净利润@元
    ,minority_gal number(18,4) -- 少数股东损益@元
    ,othr_compre_income number(18,4) -- 其他综合收益@元
    ,total_compre_income number(18,4) -- 综合收益总额@元
    ,total_compre_income_atsopc number(18,4) -- 归属于母公司股东的综合收益总额@元
    ,total_compre_income_atms number(18,4) -- 归属于少数股东的综合收益总额@元
    ,is_statement_released_values number(1,0) -- 报表是否公布值@0：非公布值；1：公布值
    ,operating_total_revenue_bi number(18,4) -- 营业总收入平衡科目@单位：元
    ,operating_total_cost_bi number(18,4) -- 营业总成本平衡科目@单位：元
    ,op_si number(18,4) -- 营业利润特殊科目@单位：元
    ,op_bi number(18,4) -- 营业利润平衡科目@单位：元
    ,total_profit_si number(18,4) -- 利润总额特殊科目@单位：元
    ,total_profit_bi number(18,4) -- 利润总额平衡科目@单位：元
    ,net_profit_si number(18,4) -- 净利润特殊科目@单位：元
    ,net_profit_bi number(18,4) -- 净利润平衡科目@单位：元
    ,basic_eps number(18,4) -- 基本每股收益@单位：元
    ,dlt_earnings_per_share number(18,4) -- 稀释每股收益@单位：元
    ,special_explain varchar2(4000) -- 特殊情况说明@简要描述特殊情况及处理说明
    ,noncurrent_assets_dispose_gain number(24,4) -- 其中：非流动资产处置利得@单位：元
    ,othr_compre_income_atoopc number(24,4) -- 归属母公司所有者的其他综合收益@单位：元
    ,othr_ci_nonreclassi_into_gal number(24,4) -- （一）以后不能重分类进损益的其他综合收益@单位：元
    ,net_debt_or_na_chg_reclac number(24,4) -- 1.重新计量设定受益计划净负债或净资产的变动@单位：元
    ,can_not_be_reclassi_em number(24,4) -- 2.权益法下在被投资单位不能重分类进损益的其他综合收益中享有的份额@单位：元
    ,othr_ci_to_reclassi_into_gal number(24,4) -- （二）以后将重分类进损益的其他综合收益@单位：元
    ,will_reclassi_equity_method number(24,4) -- 1.权益法下在被投资单位以后将重分类进损益的其他综合收益中享有的份额@单位：元
    ,salable_fnncl_asset_fvc_gal number(24,4) -- 2.可供出售金融资产公允价值变动损益@单位：元
    ,htm_salable_fnncl_asset_gal number(24,4) -- 3.持有至到期投资重分类为可供出售金融资产损益@单位：元
    ,cash_flow_gal_valid_part number(24,4) -- 4.现金流量套期损益的有效部分@单位：元
    ,frgn_currency_statement_diff number(24,4) -- 5.外币财务报表折算差额@单位：元
    ,other_reclassi number(24,4) -- 6.其他@单位：元
    ,othr_compre_income_atms number(24,4) -- 归属于少数股东的其他综合收益@单位：元
    ,other_not_reclassi number(24,4) -- 3.其他@单位：元
    ,other_income number(18,4) -- 其他收益@单位：元
    ,asset_disposal_income number(18,4) -- 资产处置收益@单位：元
    ,stop_operating_np number(18,4) -- （二）终止经营净利润@单位：元
    ,continous_operating_np number(18,4) -- （一）持续经营净利润@单位：元
    ,cash_flow_hedging_reserve number(24,4) -- 10.现金流量套期储备@单元：元
    ,other_eq_ins_invest_fv_chg number(24,4) -- 4.其他权益工具投资公允价值变动@单元：元
    ,credit_risk_fv_chg number(24,4) -- 5.企业自身信用风险公允价值变动@单元：元
    ,other_debt_invest_fv_chg number(24,4) -- 7.其他债权投资公允价值变动@单元：元
    ,fnncl_assets_rec_other_income number(24,4) -- 8.金融资产重分类计入其他综合收益的金额@单元：元
    ,other_debt_invest_credit_loss number(24,4) -- 9.其他债权投资信用减值准备@单元：元
    ,credit_impairment_loss number(24,4) -- 信用减值损失@单元：元
    ,finance_cost_interest_fee number(24,4) -- 财务费用：利息费用@单元：元
    ,net_exposure_hedging_benefits number(24,4) -- 净敞口套期收益@单元：元
    ,finance_cost_interest_income number(24,4) -- 财务费用：利息收入@单元：元
    ,rad_cost number(24,4) -- 研发费用@单元：元
    ,general_corp_operating_cost_pf number(2,0) -- 一般企业营业总成本公布格式@空值或1：营业总成本包含资产减值损失和信用减值损失，2：营业总成本不包含资产减值损失和信用减值损失
    ,amortized_cost_fnncl_asset_tce number(24,4) -- 以摊余成本计量的金融资产终止确认收益@单位：元
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_income_statement_ns to ${iml_schema};
grant select on ${iol_schema}.uxds_income_statement_ns to ${icl_schema};
grant select on ${iol_schema}.uxds_income_statement_ns to ${idl_schema};
grant select on ${iol_schema}.uxds_income_statement_ns to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_income_statement_ns is '利润表(新准则)';
comment on column ${iol_schema}.uxds_income_statement_ns.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_income_statement_ns.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_income_statement_ns.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_income_statement_ns.rtime is '记录通讯到用户端时间';
comment on column ${iol_schema}.uxds_income_statement_ns.org_id is '机构id@关联到corp_basic_info.org_id';
comment on column ${iol_schema}.uxds_income_statement_ns.org_name is '机构名称';
comment on column ${iol_schema}.uxds_income_statement_ns.sd is '起始日期';
comment on column ${iol_schema}.uxds_income_statement_ns.ed is '截止日期';
comment on column ${iol_schema}.uxds_income_statement_ns.statement_type_code is '报表类型编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=524';
comment on column ${iol_schema}.uxds_income_statement_ns.statement_type is '报表类型@合并报表、母公司报表、合并报表(调整)、母公司报表(调整)';
comment on column ${iol_schema}.uxds_income_statement_ns.chg_seq is '变动序号@012…，0为最新';
comment on column ${iol_schema}.uxds_income_statement_ns.statement_format_code is '报表格式编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=594';
comment on column ${iol_schema}.uxds_income_statement_ns.statement_format is '报表格式@一般企业、商业银行、保险公司、证券公司';
comment on column ${iol_schema}.uxds_income_statement_ns.sas_code is '报表会计准则编码@关联到public_code_table.ctgry_code，public_code_table.class_encode=595';
comment on column ${iol_schema}.uxds_income_statement_ns.sas is '报表会计准则@新会计准则、旧会计准则';
comment on column ${iol_schema}.uxds_income_statement_ns.announ_seq is '公告序号@用于确定同一公告公布的数据';
comment on column ${iol_schema}.uxds_income_statement_ns.data_source_code is '数据来源代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=593';
comment on column ${iol_schema}.uxds_income_statement_ns.data_source is '数据来源@招股说明书、上市公司定期报告、招股说明书申报稿、债券招募说明书、其他定期报告、更正公告、追溯调整公告、其它';
comment on column ${iol_schema}.uxds_income_statement_ns.statement_source_explain is '报表来源说明@代码+公告名称，方便查看数据来源';
comment on column ${iol_schema}.uxds_income_statement_ns.is_statement_complete is '报表是否完整@0：简表（简表只有几个主要科目，可能不适用报表平衡公式）；1：详表';
comment on column ${iol_schema}.uxds_income_statement_ns.currency_code is '货币代码@关联到public_code_table.ctgry_code，public_code_table.class_encode=518';
comment on column ${iol_schema}.uxds_income_statement_ns.is_audited is '是否审计@0为未审计；1：已审计';
comment on column ${iol_schema}.uxds_income_statement_ns.announcement_date is '公告日期';
comment on column ${iol_schema}.uxds_income_statement_ns.total_revenue is '一、营业总收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.revenue is '营业收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.interest_net_income is '利息净收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.interest_income is '利息收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.interest_payout is '利息支出@元';
comment on column ${iol_schema}.uxds_income_statement_ns.commi_net_income is '手续费及佣金净收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.fee_and_commi_income is '手续费及佣金收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.charge_and_commi_expenses is '手续费及佣金支出@元';
comment on column ${iol_schema}.uxds_income_statement_ns.othr_income is '其他业务收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.earned_premium is '已赚保费@元';
comment on column ${iol_schema}.uxds_income_statement_ns.insurance_income is '保险业务收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.rein_premium_income is '其中：分保费收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.ceded_out_premium is '减：分出保费@元';
comment on column ${iol_schema}.uxds_income_statement_ns.draw_undueduty_deposit is '提取未到期责任准备金@元';
comment on column ${iol_schema}.uxds_income_statement_ns.net_income_from_brokerage is '其中：经纪业务手续费净收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.net_income_from_invest_banking is '投资银行业务手续费净收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.asset_manage_service_charge_ni is '资产管理业务手续费净收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.operating_total_revenue_si is '营业总收入特殊科目@元；用于存放标准格式以外科目，例如利息收入';
comment on column ${iol_schema}.uxds_income_statement_ns.operating_costs is '二、营业总成本@元';
comment on column ${iol_schema}.uxds_income_statement_ns.operating_cost is '其中：营业成本@元';
comment on column ${iol_schema}.uxds_income_statement_ns.operating_taxes_and_surcharge is '营业税金及附加@元';
comment on column ${iol_schema}.uxds_income_statement_ns.sales_fee is '销售费用@元';
comment on column ${iol_schema}.uxds_income_statement_ns.manage_fee is '管理费用@元';
comment on column ${iol_schema}.uxds_income_statement_ns.financing_expenses is '财务费用@元';
comment on column ${iol_schema}.uxds_income_statement_ns.asset_impairment_loss is '资产减值损失@元';
comment on column ${iol_schema}.uxds_income_statement_ns.operating_payout is '营业支出@元';
comment on column ${iol_schema}.uxds_income_statement_ns.business_and_manage_fee is '业务及管理费@元';
comment on column ${iol_schema}.uxds_income_statement_ns.othr_business_costs is '其他业务成本@元';
comment on column ${iol_schema}.uxds_income_statement_ns.refunded_premium is '退保金@元';
comment on column ${iol_schema}.uxds_income_statement_ns.compen_payout is '赔付支出@元';
comment on column ${iol_schema}.uxds_income_statement_ns.compen_expense is '减：摊回赔付支出@元';
comment on column ${iol_schema}.uxds_income_statement_ns.draw_duty_deposit is '提取保险责任准备金@元';
comment on column ${iol_schema}.uxds_income_statement_ns.amortized_deposit_for_duty is '减：摊回保险责任准备金@元';
comment on column ${iol_schema}.uxds_income_statement_ns.commi_on_insurance_policy is '保单红利支出@元';
comment on column ${iol_schema}.uxds_income_statement_ns.rein_expenditure is '分保费用@元';
comment on column ${iol_schema}.uxds_income_statement_ns.amortized_rein_expenditure is '减：摊回分保费用@元';
comment on column ${iol_schema}.uxds_income_statement_ns.operating_total_cost_si is '营业总成本特殊科目@元；用于存放标准格式以外科目，例如利息支出';
comment on column ${iol_schema}.uxds_income_statement_ns.income_from_chg_in_fv is '加：公允价值变动收益@元';
comment on column ${iol_schema}.uxds_income_statement_ns.invest_income is '投资收益@元';
comment on column ${iol_schema}.uxds_income_statement_ns.invest_incomes_from_rr is '其中：对联营企业和合营企业的投资收益@元';
comment on column ${iol_schema}.uxds_income_statement_ns.exchg_gain is '汇兑收益@元';
comment on column ${iol_schema}.uxds_income_statement_ns.op is '三、营业利润@元';
comment on column ${iol_schema}.uxds_income_statement_ns.non_operating_income is '加：营业外收入@元';
comment on column ${iol_schema}.uxds_income_statement_ns.non_operating_payout is '减：营业外支出@元';
comment on column ${iol_schema}.uxds_income_statement_ns.noncurrent_asset_disposal_loss is '其中：非流动资产处置损失@元';
comment on column ${iol_schema}.uxds_income_statement_ns.profit_total_amt is '四、利润总额@元';
comment on column ${iol_schema}.uxds_income_statement_ns.income_tax_expenses is '减：所得税费用@元';
comment on column ${iol_schema}.uxds_income_statement_ns.net_profit is '五、净利润@元';
comment on column ${iol_schema}.uxds_income_statement_ns.net_profit_atsopc is '归属于母公司股东的净利润@元';
comment on column ${iol_schema}.uxds_income_statement_ns.minority_gal is '少数股东损益@元';
comment on column ${iol_schema}.uxds_income_statement_ns.othr_compre_income is '其他综合收益@元';
comment on column ${iol_schema}.uxds_income_statement_ns.total_compre_income is '综合收益总额@元';
comment on column ${iol_schema}.uxds_income_statement_ns.total_compre_income_atsopc is '归属于母公司股东的综合收益总额@元';
comment on column ${iol_schema}.uxds_income_statement_ns.total_compre_income_atms is '归属于少数股东的综合收益总额@元';
comment on column ${iol_schema}.uxds_income_statement_ns.is_statement_released_values is '报表是否公布值@0：非公布值；1：公布值';
comment on column ${iol_schema}.uxds_income_statement_ns.operating_total_revenue_bi is '营业总收入平衡科目@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.operating_total_cost_bi is '营业总成本平衡科目@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.op_si is '营业利润特殊科目@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.op_bi is '营业利润平衡科目@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.total_profit_si is '利润总额特殊科目@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.total_profit_bi is '利润总额平衡科目@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.net_profit_si is '净利润特殊科目@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.net_profit_bi is '净利润平衡科目@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.basic_eps is '基本每股收益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.dlt_earnings_per_share is '稀释每股收益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.special_explain is '特殊情况说明@简要描述特殊情况及处理说明';
comment on column ${iol_schema}.uxds_income_statement_ns.noncurrent_assets_dispose_gain is '其中：非流动资产处置利得@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.othr_compre_income_atoopc is '归属母公司所有者的其他综合收益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.othr_ci_nonreclassi_into_gal is '（一）以后不能重分类进损益的其他综合收益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.net_debt_or_na_chg_reclac is '1.重新计量设定受益计划净负债或净资产的变动@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.can_not_be_reclassi_em is '2.权益法下在被投资单位不能重分类进损益的其他综合收益中享有的份额@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.othr_ci_to_reclassi_into_gal is '（二）以后将重分类进损益的其他综合收益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.will_reclassi_equity_method is '1.权益法下在被投资单位以后将重分类进损益的其他综合收益中享有的份额@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.salable_fnncl_asset_fvc_gal is '2.可供出售金融资产公允价值变动损益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.htm_salable_fnncl_asset_gal is '3.持有至到期投资重分类为可供出售金融资产损益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.cash_flow_gal_valid_part is '4.现金流量套期损益的有效部分@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.frgn_currency_statement_diff is '5.外币财务报表折算差额@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.other_reclassi is '6.其他@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.othr_compre_income_atms is '归属于少数股东的其他综合收益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.other_not_reclassi is '3.其他@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.other_income is '其他收益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.asset_disposal_income is '资产处置收益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.stop_operating_np is '（二）终止经营净利润@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.continous_operating_np is '（一）持续经营净利润@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.cash_flow_hedging_reserve is '10.现金流量套期储备@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.other_eq_ins_invest_fv_chg is '4.其他权益工具投资公允价值变动@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.credit_risk_fv_chg is '5.企业自身信用风险公允价值变动@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.other_debt_invest_fv_chg is '7.其他债权投资公允价值变动@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.fnncl_assets_rec_other_income is '8.金融资产重分类计入其他综合收益的金额@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.other_debt_invest_credit_loss is '9.其他债权投资信用减值准备@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.credit_impairment_loss is '信用减值损失@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.finance_cost_interest_fee is '财务费用：利息费用@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.net_exposure_hedging_benefits is '净敞口套期收益@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.finance_cost_interest_income is '财务费用：利息收入@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.rad_cost is '研发费用@单元：元';
comment on column ${iol_schema}.uxds_income_statement_ns.general_corp_operating_cost_pf is '一般企业营业总成本公布格式@空值或1：营业总成本包含资产减值损失和信用减值损失，2：营业总成本不包含资产减值损失和信用减值损失';
comment on column ${iol_schema}.uxds_income_statement_ns.amortized_cost_fnncl_asset_tce is '以摊余成本计量的金融资产终止确认收益@单位：元';
comment on column ${iol_schema}.uxds_income_statement_ns.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_income_statement_ns.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_income_statement_ns.etl_timestamp is 'ETL处理时间戳';
