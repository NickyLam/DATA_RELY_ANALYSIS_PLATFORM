/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_rwa_report_debt_info
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
drop table ${iol_schema}.rwas_rwa_report_debt_info_ex purge;
alter table ${iol_schema}.rwas_rwa_report_debt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rwas_rwa_report_debt_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rwas_rwa_report_debt_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_rwa_report_debt_info where 0=1;

insert /*+ append */ into ${iol_schema}.rwas_rwa_report_debt_info_ex(
    data_date -- 数据日期
    ,loan_ref_id -- 债项ID
    ,src_loan_ref_no -- 借据号
    ,accountrefcd -- 合同号
    ,product_name -- 业务类型
    ,start_date -- 开始日期
    ,due_date -- 到期日期
    ,org_cd -- 入账机构
    ,ccy_cd -- 币种代码
    ,cust_name -- 客户名称
    ,ccp_type_cd -- 客户类型(引擎)
    ,assettype_id -- 资产类型(引擎)
    ,subject_cd -- 本金科目代码
    ,interest_receive_subject_cd -- 应收利息科目代码
    ,accrual_class_subject_cd -- 应计科目代码
    ,interest_adjust_subject_cd -- 利息调整科目代码
    ,fairvalue_changes_subject_cd -- 公允价值变动科目代码
    ,depre_amortizat_subject_cd -- 折旧科目代码
    ,provision_single_subject_cd -- 准备金科目代码
    ,asset_balance -- 资产余额(原币)
    ,asset_balance_hcurr -- 资产余额(本币)
    ,receivable_int -- 应收利息(本币)
    ,accrued_int -- 应计利息(本币)
    ,int_adj -- 利息调整(本币)
    ,fair_value_change -- 公允价值变动(本币)
    ,depre_amortizat_assets -- 固定资产折旧(本币)
    ,provision -- 计提准备金(本币)
    ,ead_orig -- 原始风险暴露(本币)
    ,ccf -- 
    ,ccf_ead -- CCF转换后风险暴露
    ,ead_provision -- 扣减准备金后的风险暴露(本币)
    ,portfoliotypedesc -- 填报项目
    ,rwbandid -- 债项权重
    ,ccy_mismatch -- 缓释币种错配系数
    ,allocatedcrm -- 缓释品金额(折本币)
    ,crm_rwbandid_wtd -- 缓释品加权权重
    ,crm_ncover_rwaamount -- 缓释未覆盖部分RWA
    ,crm_cover_rwaamount -- 缓释覆盖部分RWA
    ,rwaamount -- RWA
    ,on_off_id -- 表内外标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期
    ,loan_ref_id -- 债项ID
    ,src_loan_ref_no -- 借据号
    ,accountrefcd -- 合同号
    ,product_name -- 业务类型
    ,start_date -- 开始日期
    ,due_date -- 到期日期
    ,org_cd -- 入账机构
    ,ccy_cd -- 币种代码
    ,cust_name -- 客户名称
    ,ccp_type_cd -- 客户类型(引擎)
    ,assettype_id -- 资产类型(引擎)
    ,subject_cd -- 本金科目代码
    ,interest_receive_subject_cd -- 应收利息科目代码
    ,accrual_class_subject_cd -- 应计科目代码
    ,interest_adjust_subject_cd -- 利息调整科目代码
    ,fairvalue_changes_subject_cd -- 公允价值变动科目代码
    ,depre_amortizat_subject_cd -- 折旧科目代码
    ,provision_single_subject_cd -- 准备金科目代码
    ,asset_balance -- 资产余额(原币)
    ,asset_balance_hcurr -- 资产余额(本币)
    ,receivable_int -- 应收利息(本币)
    ,accrued_int -- 应计利息(本币)
    ,int_adj -- 利息调整(本币)
    ,fair_value_change -- 公允价值变动(本币)
    ,depre_amortizat_assets -- 固定资产折旧(本币)
    ,provision -- 计提准备金(本币)
    ,ead_orig -- 原始风险暴露(本币)
    ,ccf -- 
    ,ccf_ead -- CCF转换后风险暴露
    ,ead_provision -- 扣减准备金后的风险暴露(本币)
    ,portfoliotypedesc -- 填报项目
    ,rwbandid -- 债项权重
    ,ccy_mismatch -- 缓释币种错配系数
    ,allocatedcrm -- 缓释品金额(折本币)
    ,crm_rwbandid_wtd -- 缓释品加权权重
    ,crm_ncover_rwaamount -- 缓释未覆盖部分RWA
    ,crm_cover_rwaamount -- 缓释覆盖部分RWA
    ,rwaamount -- RWA
    ,on_off_id -- 表内外标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rwas_rwa_report_debt_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rwas_rwa_report_debt_info exchange partition p_${batch_date} with table ${iol_schema}.rwas_rwa_report_debt_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_rwa_report_debt_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rwas_rwa_report_debt_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_rwa_report_debt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);