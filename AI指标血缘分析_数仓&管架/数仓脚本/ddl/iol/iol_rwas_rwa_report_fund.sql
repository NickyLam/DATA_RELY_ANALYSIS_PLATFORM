/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rwa_report_fund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rwa_report_fund
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rwa_report_fund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rwa_report_fund(
    data_date date -- 数据日期
    ,loan_ref_id number(9) -- 债项ID
    ,loan_ref_no varchar2(100) -- 借据号
    ,i_code varchar2(100) -- 基金编号
    ,asset_thd_cls_cd varchar2(30) -- 金融资产分类
    ,product_name varchar2(40) -- 业务类型
    ,start_date date -- 开始日期
    ,due_date date -- 到期日期
    ,org_cd varchar2(60) -- 入账机构
    ,ccy_name varchar2(1000) -- 币种代码
    ,cust_name varchar2(200) -- 发行人名称
    ,subject_cd varchar2(60) -- 本金科目代码
    ,interest_receive_subject_cd varchar2(60) -- 应收利息科目代码
    ,accrual_class_subject_cd varchar2(60) -- 应计科目代码
    ,interest_adjust_subject_cd varchar2(60) -- 利息调整科目代码
    ,fairvalue_changes_subject_cd varchar2(60) -- 公允价值变动科目代码
    ,provision_single_subject_cd varchar2(60) -- 准备金科目代码
    ,asset_balance_hcurr number(22,6) -- 资产余额(本币）
    ,receivable_int number(18,2) -- 应收利息(本币）
    ,accrued_int number(22,6) -- 应计利息(本币）
    ,int_adj number(22,6) -- 利息调整(本币）
    ,fair_value_change number(22,2) -- 公允价值变动(本币）
    ,provision number(22,6) -- 计提准备金(本币）
    ,ead_orig number(22,6) -- 原始风险暴露(本币)
    ,ead_provision number(22,6) -- 扣减准备金后的风险暴露(本币)
    ,invest_cash_amt number(22,2) -- 现金(0%)
    ,invest_mof_amt number(22,2) -- 对我国中央政府的债权(0%)
    ,invest_cen_bank_amt number(22,2) -- 对中国人民银行的债权(0%)
    ,invest_pse_sov_amt number(22,2) -- 我国公共部门发行的债券(含铁道债)(20%)
    ,invest_pse_rglt_amt number(22,2) -- 我国省级（直辖区、自治区）以及计划单列市人民政府的债权(20%)
    ,invest_policy_sen_amt number(22,2) -- 对我国政策性银行的债权(0%)
    ,invest_policy_sub_amt number(22,2) -- 对我国政策性银行的次级债权（未扣除部分）(100%)
    ,invest_bank_short_amt number(22,2) -- 对我国商业银行的短期债权比例
    ,invest_bank_long_amt number(22,2) -- 对我国商业银行的长期债权比例
    ,invest_bank_sub_amt number(22,2) -- 我国商业银行的次级债权(100%)
    ,invest_othfin_amt number(22,2) -- 我国其他金融机构的债权(100%)
    ,invest_corp_amt number(22,2) -- 一般企（事）业的债权(100%)
    ,invest_oth_assets_twamt number(22,2) -- 资产支持证券（20%）
    ,invest_oth_assets_ohamt number(22,2) -- 适用100%风险权重的资产
    ,rwaamount number(18,2) -- RWA
    ,register_date date -- 缓释录入日期
    ,fund_name varchar2(500) -- 基金名称
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
grant select on ${iol_schema}.rwas_rwa_report_fund to ${iml_schema};
grant select on ${iol_schema}.rwas_rwa_report_fund to ${icl_schema};
grant select on ${iol_schema}.rwas_rwa_report_fund to ${idl_schema};
grant select on ${iol_schema}.rwas_rwa_report_fund to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rwa_report_fund is '债项填报信息表-基金投资';
comment on column ${iol_schema}.rwas_rwa_report_fund.data_date is '数据日期';
comment on column ${iol_schema}.rwas_rwa_report_fund.loan_ref_id is '债项ID';
comment on column ${iol_schema}.rwas_rwa_report_fund.loan_ref_no is '借据号';
comment on column ${iol_schema}.rwas_rwa_report_fund.i_code is '基金编号';
comment on column ${iol_schema}.rwas_rwa_report_fund.asset_thd_cls_cd is '金融资产分类';
comment on column ${iol_schema}.rwas_rwa_report_fund.product_name is '业务类型';
comment on column ${iol_schema}.rwas_rwa_report_fund.start_date is '开始日期';
comment on column ${iol_schema}.rwas_rwa_report_fund.due_date is '到期日期';
comment on column ${iol_schema}.rwas_rwa_report_fund.org_cd is '入账机构';
comment on column ${iol_schema}.rwas_rwa_report_fund.ccy_name is '币种代码';
comment on column ${iol_schema}.rwas_rwa_report_fund.cust_name is '发行人名称';
comment on column ${iol_schema}.rwas_rwa_report_fund.subject_cd is '本金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fund.interest_receive_subject_cd is '应收利息科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fund.accrual_class_subject_cd is '应计科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fund.interest_adjust_subject_cd is '利息调整科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fund.fairvalue_changes_subject_cd is '公允价值变动科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fund.provision_single_subject_cd is '准备金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fund.asset_balance_hcurr is '资产余额(本币）';
comment on column ${iol_schema}.rwas_rwa_report_fund.receivable_int is '应收利息(本币）';
comment on column ${iol_schema}.rwas_rwa_report_fund.accrued_int is '应计利息(本币）';
comment on column ${iol_schema}.rwas_rwa_report_fund.int_adj is '利息调整(本币）';
comment on column ${iol_schema}.rwas_rwa_report_fund.fair_value_change is '公允价值变动(本币）';
comment on column ${iol_schema}.rwas_rwa_report_fund.provision is '计提准备金(本币）';
comment on column ${iol_schema}.rwas_rwa_report_fund.ead_orig is '原始风险暴露(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fund.ead_provision is '扣减准备金后的风险暴露(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_cash_amt is '现金(0%)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_mof_amt is '对我国中央政府的债权(0%)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_cen_bank_amt is '对中国人民银行的债权(0%)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_pse_sov_amt is '我国公共部门发行的债券(含铁道债)(20%)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_pse_rglt_amt is '我国省级（直辖区、自治区）以及计划单列市人民政府的债权(20%)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_policy_sen_amt is '对我国政策性银行的债权(0%)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_policy_sub_amt is '对我国政策性银行的次级债权（未扣除部分）(100%)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_bank_short_amt is '对我国商业银行的短期债权比例';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_bank_long_amt is '对我国商业银行的长期债权比例';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_bank_sub_amt is '我国商业银行的次级债权(100%)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_othfin_amt is '我国其他金融机构的债权(100%)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_corp_amt is '一般企（事）业的债权(100%)';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_oth_assets_twamt is '资产支持证券（20%）';
comment on column ${iol_schema}.rwas_rwa_report_fund.invest_oth_assets_ohamt is '适用100%风险权重的资产';
comment on column ${iol_schema}.rwas_rwa_report_fund.rwaamount is 'RWA';
comment on column ${iol_schema}.rwas_rwa_report_fund.register_date is '缓释录入日期';
comment on column ${iol_schema}.rwas_rwa_report_fund.fund_name is '基金名称';
comment on column ${iol_schema}.rwas_rwa_report_fund.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_rwa_report_fund.etl_timestamp is 'ETL处理时间戳';
