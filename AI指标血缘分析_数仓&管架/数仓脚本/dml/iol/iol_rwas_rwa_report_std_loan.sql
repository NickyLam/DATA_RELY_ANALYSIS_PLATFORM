/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_rwa_report_std_loan
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
drop table ${iol_schema}.rwas_rwa_report_std_loan_ex purge;
alter table ${iol_schema}.rwas_rwa_report_std_loan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rwas_rwa_report_std_loan truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rwas_rwa_report_std_loan_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_rwa_report_std_loan where 0=1;

insert /*+ append */ into ${iol_schema}.rwas_rwa_report_std_loan_ex(
    data_date -- 数据日期
    ,loan_ref_id -- 债项ID
    ,loan_ref_no -- 借据号
    ,sec_no -- 证券编号
    ,asset_thd_cls_cd -- 金融资产分类
    ,seniority_id -- 优先债权标志.110：优先债权 130：次级债权
    ,s_grade -- 债券评级
    ,grade -- 主体评级
    ,src_system_id -- 来源系统
    ,product_name -- 业务类型(债券类型)
    ,start_date -- 开始日期
    ,due_date -- 到期日期
    ,org_cd -- 入账机构
    ,cust_no -- 发行人客户号
    ,cust_name -- 发行人名称
    ,reg_country_cd -- 发行人注册国
    ,rating_cd -- 发行人注册国评级
    ,ccp_type_cd -- 客户类型(引擎)
    ,assettype_id -- 资产类型(引擎)
    ,subject_cd -- 本金科目代码
    ,interest_receive_subject_cd -- 应收利息科目代码
    ,accrual_class_subject_cd -- 应计科目代码
    ,interest_adjust_subject_cd -- 利息调整科目代码
    ,fairvalue_changes_subject_cd -- 公允价值变动科目代码
    ,provision_single_subject_cd -- 准备金科目代码
    ,ccy_name -- 币种代码
    ,asset_balance -- 资产余额(原币)
    ,asset_balance_hcurr -- 资产余额(本币)
    ,receivable_int -- 应收利息(本币)
    ,accrued_int -- 应计利息(本币)
    ,int_adj -- 利息调整(本币)
    ,fair_value_change -- 公允价值变动(本币)
    ,provision -- 计提准备金(本币)
    ,ead_orig -- 原始风险暴露(本币)
    ,ead_provision -- 扣减准备金后的风险暴露(本币)
    ,portfoliotypedesc -- 填报项目
    ,rwbandid -- 债项权重
    ,rwaamount -- RWA
    ,crm_cash_amt -- 现金类资产0%
    ,crm_government_amt -- 我国中央政府0%
    ,crm_pbc_mat -- 中国人民银行0%
    ,crm_policy_bank_amt -- 我国政策性银行0%
    ,crm_pse_sov_amt -- 我国公共部门实体20%
    ,crm_bank_amt -- 我国商业银行25%
    ,crm_bonds_issued_amt -- 金融资产管理公司为收购国有银行不良贷款而定向发行的债券0%
    ,crm_governments_aa_amt -- 评级AA-以上（含AA-）的国家和地区的中央政府和中央银行0%
    ,crm_governments_a_amt -- 评级AA-以下，A-（含A-）以上的国家和地区的中央政府和中央银行20%
    ,crm_governments_bbb_amt -- 评级A-以下，BBB-（含BBB-）以上的国家和地区的中央政府和中央银行50%
    ,crm_pses_aa_amt -- 评级AA-及以上国家和地区注册的商业银行和公共部门实体25%
    ,crm_pses_a_amt -- 评级AA-以下，A-（含A-）以上国家和地区注册的商业银行和公共部门实体50%
    ,crm_mdbs_biss_imfs_amt -- 多边开发银行、国际清算银行及国际货币基金组织0%
    ,first_org_cd -- 首次贴现机构
    ,first_cust_name -- 首次贴现交易对手名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期
    ,loan_ref_id -- 债项ID
    ,loan_ref_no -- 借据号
    ,sec_no -- 证券编号
    ,asset_thd_cls_cd -- 金融资产分类
    ,seniority_id -- 优先债权标志.110：优先债权 130：次级债权
    ,s_grade -- 债券评级
    ,grade -- 主体评级
    ,src_system_id -- 来源系统
    ,product_name -- 业务类型(债券类型)
    ,start_date -- 开始日期
    ,due_date -- 到期日期
    ,org_cd -- 入账机构
    ,cust_no -- 发行人客户号
    ,cust_name -- 发行人名称
    ,reg_country_cd -- 发行人注册国
    ,rating_cd -- 发行人注册国评级
    ,ccp_type_cd -- 客户类型(引擎)
    ,assettype_id -- 资产类型(引擎)
    ,subject_cd -- 本金科目代码
    ,interest_receive_subject_cd -- 应收利息科目代码
    ,accrual_class_subject_cd -- 应计科目代码
    ,interest_adjust_subject_cd -- 利息调整科目代码
    ,fairvalue_changes_subject_cd -- 公允价值变动科目代码
    ,provision_single_subject_cd -- 准备金科目代码
    ,ccy_name -- 币种代码
    ,asset_balance -- 资产余额(原币)
    ,asset_balance_hcurr -- 资产余额(本币)
    ,receivable_int -- 应收利息(本币)
    ,accrued_int -- 应计利息(本币)
    ,int_adj -- 利息调整(本币)
    ,fair_value_change -- 公允价值变动(本币)
    ,provision -- 计提准备金(本币)
    ,ead_orig -- 原始风险暴露(本币)
    ,ead_provision -- 扣减准备金后的风险暴露(本币)
    ,portfoliotypedesc -- 填报项目
    ,rwbandid -- 债项权重
    ,rwaamount -- RWA
    ,crm_cash_amt -- 现金类资产0%
    ,crm_government_amt -- 我国中央政府0%
    ,crm_pbc_mat -- 中国人民银行0%
    ,crm_policy_bank_amt -- 我国政策性银行0%
    ,crm_pse_sov_amt -- 我国公共部门实体20%
    ,crm_bank_amt -- 我国商业银行25%
    ,crm_bonds_issued_amt -- 金融资产管理公司为收购国有银行不良贷款而定向发行的债券0%
    ,crm_governments_aa_amt -- 评级AA-以上（含AA-）的国家和地区的中央政府和中央银行0%
    ,crm_governments_a_amt -- 评级AA-以下，A-（含A-）以上的国家和地区的中央政府和中央银行20%
    ,crm_governments_bbb_amt -- 评级A-以下，BBB-（含BBB-）以上的国家和地区的中央政府和中央银行50%
    ,crm_pses_aa_amt -- 评级AA-及以上国家和地区注册的商业银行和公共部门实体25%
    ,crm_pses_a_amt -- 评级AA-以下，A-（含A-）以上国家和地区注册的商业银行和公共部门实体50%
    ,crm_mdbs_biss_imfs_amt -- 多边开发银行、国际清算银行及国际货币基金组织0%
    ,first_org_cd -- 首次贴现机构
    ,first_cust_name -- 首次贴现交易对手名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rwas_rwa_report_std_loan
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rwas_rwa_report_std_loan exchange partition p_${batch_date} with table ${iol_schema}.rwas_rwa_report_std_loan_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_rwa_report_std_loan to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rwas_rwa_report_std_loan_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_rwa_report_std_loan',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);