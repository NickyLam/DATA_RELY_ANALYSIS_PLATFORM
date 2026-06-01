/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_rwa_report_fb_invest
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
drop table ${iol_schema}.rwas_rwa_report_fb_invest_ex purge;
alter table ${iol_schema}.rwas_rwa_report_fb_invest add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rwas_rwa_report_fb_invest truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rwas_rwa_report_fb_invest_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_rwa_report_fb_invest where 0=1;

insert /*+ append */ into ${iol_schema}.rwas_rwa_report_fb_invest_ex(
    data_date -- 数据日期
    ,loan_ref_id -- 债项ID
    ,loan_ref_no -- 借据号
    ,i_code -- 金融工具代码
    ,i_code_name -- 金融工具名称
    ,product_type -- 产品分类
    ,asset_thd_cls_cd -- 金融资产分类
    ,product_name -- 业务类型
    ,start_date -- 开始日期
    ,due_date -- 到期日期
    ,sourceid -- 所属条线
    ,org_cd -- 入账机构
    ,subject_cd -- 本金科目代码
    ,interest_receive_subject_cd -- 应收利息科目代码
    ,accrual_class_subject_cd -- 应计科目代码
    ,interest_adjust_subject_cd -- 利息调整科目代码
    ,fairvalue_changes_subject_cd -- 公允价值变动科目代码
    ,provision_single_subject_cd -- 准备金科目代码
    ,asset_balance -- 资产余额(原币)
    ,ccy_name -- 币种代码
    ,asset_balance_hcurr -- 资产余额(本币)
    ,receivable_int -- 应收利息(本币)
    ,accrued_int -- 应计利息(本币)
    ,int_adj -- 利息调整(本币)
    ,fair_value_change -- 公允价值变动(本币)
    ,provision -- 计提准备金(本币)
    ,spv_cust_no -- 交易对手客户号
    ,spv_cust_name -- 交易对手
    ,spv_cust_type -- 客户分类
    ,cust_name -- 实际融资主体客户名称
    ,uder_actl_finer_cust_char -- 实际融资客户性质
    ,ccp_type_cd -- 实际融资主体客户类型(引擎)
    ,ead_orig -- 原始风险暴露(本币)
    ,ead_provision -- 扣减准备金后的风险暴露(本币)
    ,portfoliotypedesc -- 填报项目
    ,rwbandid -- 债项权重
    ,allocatedcrm -- 缓释品金额(本币)
    ,crm_rwbandid_wtd -- 缓释品加权权重
    ,crm_cover_rwaamount -- 缓释未覆盖部分RWA
    ,crm_ncover_rwaamount -- 缓释覆盖部分RWA
    ,rwaamount -- RWA
    ,register_date -- 缓释录入日
    ,crm_cash_amt -- 保证金金额
    ,crm_deposit_amt -- 存单金额
    ,crm_national_debt_amt -- 国债金额
    ,crm_policy_bank_amt -- 我国政策性银行
    ,crm_bank_amt -- 我国商业银行
    ,crm_pse_sov_amt -- 我国公共部门实体
    ,crm_oth_amt -- 其他缓释
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期
    ,loan_ref_id -- 债项ID
    ,loan_ref_no -- 借据号
    ,i_code -- 金融工具代码
    ,i_code_name -- 金融工具名称
    ,product_type -- 产品分类
    ,asset_thd_cls_cd -- 金融资产分类
    ,product_name -- 业务类型
    ,start_date -- 开始日期
    ,due_date -- 到期日期
    ,sourceid -- 所属条线
    ,org_cd -- 入账机构
    ,subject_cd -- 本金科目代码
    ,interest_receive_subject_cd -- 应收利息科目代码
    ,accrual_class_subject_cd -- 应计科目代码
    ,interest_adjust_subject_cd -- 利息调整科目代码
    ,fairvalue_changes_subject_cd -- 公允价值变动科目代码
    ,provision_single_subject_cd -- 准备金科目代码
    ,asset_balance -- 资产余额(原币)
    ,ccy_name -- 币种代码
    ,asset_balance_hcurr -- 资产余额(本币)
    ,receivable_int -- 应收利息(本币)
    ,accrued_int -- 应计利息(本币)
    ,int_adj -- 利息调整(本币)
    ,fair_value_change -- 公允价值变动(本币)
    ,provision -- 计提准备金(本币)
    ,spv_cust_no -- 交易对手客户号
    ,spv_cust_name -- 交易对手
    ,spv_cust_type -- 客户分类
    ,cust_name -- 实际融资主体客户名称
    ,uder_actl_finer_cust_char -- 实际融资客户性质
    ,ccp_type_cd -- 实际融资主体客户类型(引擎)
    ,ead_orig -- 原始风险暴露(本币)
    ,ead_provision -- 扣减准备金后的风险暴露(本币)
    ,portfoliotypedesc -- 填报项目
    ,rwbandid -- 债项权重
    ,allocatedcrm -- 缓释品金额(本币)
    ,crm_rwbandid_wtd -- 缓释品加权权重
    ,crm_cover_rwaamount -- 缓释未覆盖部分RWA
    ,crm_ncover_rwaamount -- 缓释覆盖部分RWA
    ,rwaamount -- RWA
    ,register_date -- 缓释录入日
    ,crm_cash_amt -- 保证金金额
    ,crm_deposit_amt -- 存单金额
    ,crm_national_debt_amt -- 国债金额
    ,crm_policy_bank_amt -- 我国政策性银行
    ,crm_bank_amt -- 我国商业银行
    ,crm_pse_sov_amt -- 我国公共部门实体
    ,crm_oth_amt -- 其他缓释
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rwas_rwa_report_fb_invest
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rwas_rwa_report_fb_invest exchange partition p_${batch_date} with table ${iol_schema}.rwas_rwa_report_fb_invest_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_rwa_report_fb_invest to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rwas_rwa_report_fb_invest_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_rwa_report_fb_invest',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);