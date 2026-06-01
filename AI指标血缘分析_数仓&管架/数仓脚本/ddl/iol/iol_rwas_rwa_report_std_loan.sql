/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rwa_report_std_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rwa_report_std_loan
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rwa_report_std_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rwa_report_std_loan(
    data_date date -- 数据日期
    ,loan_ref_id number(9) -- 债项ID
    ,loan_ref_no varchar2(100) -- 借据号
    ,sec_no varchar2(100) -- 证券编号
    ,asset_thd_cls_cd varchar2(30) -- 金融资产分类
    ,seniority_id varchar2(20) -- 优先债权标志.110：优先债权 130：次级债权
    ,s_grade varchar2(20) -- 债券评级
    ,grade varchar2(20) -- 主体评级
    ,src_system_id varchar2(20) -- 来源系统
    ,product_name varchar2(40) -- 业务类型(债券类型)
    ,start_date date -- 开始日期
    ,due_date date -- 到期日期
    ,org_cd varchar2(60) -- 入账机构
    ,cust_no varchar2(100) -- 发行人客户号
    ,cust_name varchar2(200) -- 发行人名称
    ,reg_country_cd varchar2(40) -- 发行人注册国
    ,rating_cd varchar2(60) -- 发行人注册国评级
    ,ccp_type_cd varchar2(10) -- 客户类型(引擎)
    ,assettype_id varchar2(10) -- 资产类型(引擎)
    ,subject_cd varchar2(60) -- 本金科目代码
    ,interest_receive_subject_cd varchar2(60) -- 应收利息科目代码
    ,accrual_class_subject_cd varchar2(60) -- 应计科目代码
    ,interest_adjust_subject_cd varchar2(60) -- 利息调整科目代码
    ,fairvalue_changes_subject_cd varchar2(60) -- 公允价值变动科目代码
    ,provision_single_subject_cd varchar2(60) -- 准备金科目代码
    ,ccy_name varchar2(1000) -- 币种代码
    ,asset_balance number(22,2) -- 资产余额(原币)
    ,asset_balance_hcurr number(22,6) -- 资产余额(本币)
    ,receivable_int number(22,6) -- 应收利息(本币)
    ,accrued_int number(22,6) -- 应计利息(本币)
    ,int_adj number(22,6) -- 利息调整(本币)
    ,fair_value_change number(22,6) -- 公允价值变动(本币)
    ,provision number(22,6) -- 计提准备金(本币)
    ,ead_orig number(22,6) -- 原始风险暴露(本币)
    ,ead_provision number(22,6) -- 扣减准备金后的风险暴露(本币)
    ,portfoliotypedesc varchar2(200) -- 填报项目
    ,rwbandid number(18,3) -- 债项权重
    ,rwaamount number(18,2) -- RWA
    ,crm_cash_amt number(18,2) -- 现金类资产0%
    ,crm_government_amt number(18,2) -- 我国中央政府0%
    ,crm_pbc_mat number(18,2) -- 中国人民银行0%
    ,crm_policy_bank_amt number(18,2) -- 我国政策性银行0%
    ,crm_pse_sov_amt number(18,2) -- 我国公共部门实体20%
    ,crm_bank_amt number(18,2) -- 我国商业银行25%
    ,crm_bonds_issued_amt number(18,2) -- 金融资产管理公司为收购国有银行不良贷款而定向发行的债券0%
    ,crm_governments_aa_amt number(18,2) -- 评级AA-以上（含AA-）的国家和地区的中央政府和中央银行0%
    ,crm_governments_a_amt number(18,2) -- 评级AA-以下，A-（含A-）以上的国家和地区的中央政府和中央银行20%
    ,crm_governments_bbb_amt number(18,2) -- 评级A-以下，BBB-（含BBB-）以上的国家和地区的中央政府和中央银行50%
    ,crm_pses_aa_amt number(18,2) -- 评级AA-及以上国家和地区注册的商业银行和公共部门实体25%
    ,crm_pses_a_amt number(18,2) -- 评级AA-以下，A-（含A-）以上国家和地区注册的商业银行和公共部门实体50%
    ,crm_mdbs_biss_imfs_amt number(18,2) -- 多边开发银行、国际清算银行及国际货币基金组织0%
    ,first_org_cd varchar2(60) -- 首次贴现机构
    ,first_cust_name varchar2(500) -- 首次贴现交易对手名称
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
grant select on ${iol_schema}.rwas_rwa_report_std_loan to ${iml_schema};
grant select on ${iol_schema}.rwas_rwa_report_std_loan to ${icl_schema};
grant select on ${iol_schema}.rwas_rwa_report_std_loan to ${idl_schema};
grant select on ${iol_schema}.rwas_rwa_report_std_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rwa_report_std_loan is '债项填报信息表-标准债权';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.data_date is '数据日期';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.loan_ref_id is '债项ID';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.loan_ref_no is '借据号';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.sec_no is '证券编号';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.asset_thd_cls_cd is '金融资产分类';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.seniority_id is '优先债权标志.110：优先债权 130：次级债权';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.s_grade is '债券评级';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.grade is '主体评级';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.src_system_id is '来源系统';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.product_name is '业务类型(债券类型)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.start_date is '开始日期';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.due_date is '到期日期';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.org_cd is '入账机构';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.cust_no is '发行人客户号';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.cust_name is '发行人名称';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.reg_country_cd is '发行人注册国';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.rating_cd is '发行人注册国评级';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.ccp_type_cd is '客户类型(引擎)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.assettype_id is '资产类型(引擎)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.subject_cd is '本金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.interest_receive_subject_cd is '应收利息科目代码';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.accrual_class_subject_cd is '应计科目代码';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.interest_adjust_subject_cd is '利息调整科目代码';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.fairvalue_changes_subject_cd is '公允价值变动科目代码';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.provision_single_subject_cd is '准备金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.ccy_name is '币种代码';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.asset_balance is '资产余额(原币)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.asset_balance_hcurr is '资产余额(本币)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.receivable_int is '应收利息(本币)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.accrued_int is '应计利息(本币)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.int_adj is '利息调整(本币)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.fair_value_change is '公允价值变动(本币)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.provision is '计提准备金(本币)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.ead_orig is '原始风险暴露(本币)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.ead_provision is '扣减准备金后的风险暴露(本币)';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.portfoliotypedesc is '填报项目';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.rwbandid is '债项权重';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.rwaamount is 'RWA';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_cash_amt is '现金类资产0%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_government_amt is '我国中央政府0%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_pbc_mat is '中国人民银行0%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_policy_bank_amt is '我国政策性银行0%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_pse_sov_amt is '我国公共部门实体20%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_bank_amt is '我国商业银行25%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_bonds_issued_amt is '金融资产管理公司为收购国有银行不良贷款而定向发行的债券0%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_governments_aa_amt is '评级AA-以上（含AA-）的国家和地区的中央政府和中央银行0%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_governments_a_amt is '评级AA-以下，A-（含A-）以上的国家和地区的中央政府和中央银行20%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_governments_bbb_amt is '评级A-以下，BBB-（含BBB-）以上的国家和地区的中央政府和中央银行50%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_pses_aa_amt is '评级AA-及以上国家和地区注册的商业银行和公共部门实体25%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_pses_a_amt is '评级AA-以下，A-（含A-）以上国家和地区注册的商业银行和公共部门实体50%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.crm_mdbs_biss_imfs_amt is '多边开发银行、国际清算银行及国际货币基金组织0%';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.first_org_cd is '首次贴现机构';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.first_cust_name is '首次贴现交易对手名称';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_rwa_report_std_loan.etl_timestamp is 'ETL处理时间戳';
