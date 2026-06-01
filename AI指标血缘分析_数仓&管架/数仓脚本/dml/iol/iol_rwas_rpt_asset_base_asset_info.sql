/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_rpt_asset_base_asset_info
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
drop table ${iol_schema}.rwas_rpt_asset_base_asset_info_ex purge;
alter table ${iol_schema}.rwas_rpt_asset_base_asset_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rwas_rpt_asset_base_asset_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rwas_rpt_asset_base_asset_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_rpt_asset_base_asset_info where 0=1;

insert /*+ append */ into ${iol_schema}.rwas_rpt_asset_base_asset_info_ex(
    data_date -- 数据日期
    ,pk_col -- PK_COL
    ,loan_ref_no -- 债项编号
    ,fund_cd -- 资产管理产品编号
    ,fund_name -- 资产管理产品名称
    ,base_loan_ref_no -- 基础资产债项编号
    ,base_product_cd -- 基础资产描述
    ,base_product_type -- 基础资产产品类型
    ,base_product_name -- 基础资产产品名称
    ,financial_asset_class -- 金融资产三分类
    ,ccy_cd -- 币种代码
    ,pric_bal -- 本金余额本币
    ,accrued_int -- 应计利息本币
    ,receivable_int -- 应收利息本币
    ,int_adj -- 利息调整本币
    ,fairvalue_changes -- 公允价值变动本币
    ,accrued_receiv_int -- 应收未收利息本币
    ,provision -- 准备金本币
    ,ead_orig -- 原始风险暴露本币
    ,asset_net_per -- 占资产比例%
    ,true_invest_ratio -- 投资比例
    ,min_invest_ratio -- 最小投资比例
    ,max_invest_ratio -- 最大投资比例
    ,authorized_by_third_party -- 定期报告是否经过第三方托管人确认
    ,risk_weight -- 权重
    ,fm_avg_rw -- 资管产品基础资产平均权重
    ,fm_alvg_rw -- 资管产品调整杠杆率后的权重
    ,base_sec_name -- 基础资产债券名称
    ,accorg_no -- 入账机构
    ,accorg_name -- 入账机构名称
    ,asset_type_name -- 资产大类名称
    ,report_line_no -- G4B_1报表栏位号
    ,report_line_name -- G4B_1栏位名称
    ,load_date -- 加载日期
    ,rwa_before_adj -- 调整前风险加权资产
    ,rwa_after_adj -- 调整后风险加权资产
    ,g4b_r_item_code -- G4B-5项目
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期
    ,pk_col -- PK_COL
    ,loan_ref_no -- 债项编号
    ,fund_cd -- 资产管理产品编号
    ,fund_name -- 资产管理产品名称
    ,base_loan_ref_no -- 基础资产债项编号
    ,base_product_cd -- 基础资产描述
    ,base_product_type -- 基础资产产品类型
    ,base_product_name -- 基础资产产品名称
    ,financial_asset_class -- 金融资产三分类
    ,ccy_cd -- 币种代码
    ,pric_bal -- 本金余额本币
    ,accrued_int -- 应计利息本币
    ,receivable_int -- 应收利息本币
    ,int_adj -- 利息调整本币
    ,fairvalue_changes -- 公允价值变动本币
    ,accrued_receiv_int -- 应收未收利息本币
    ,provision -- 准备金本币
    ,ead_orig -- 原始风险暴露本币
    ,asset_net_per -- 占资产比例%
    ,true_invest_ratio -- 投资比例
    ,min_invest_ratio -- 最小投资比例
    ,max_invest_ratio -- 最大投资比例
    ,authorized_by_third_party -- 定期报告是否经过第三方托管人确认
    ,risk_weight -- 权重
    ,fm_avg_rw -- 资管产品基础资产平均权重
    ,fm_alvg_rw -- 资管产品调整杠杆率后的权重
    ,base_sec_name -- 基础资产债券名称
    ,accorg_no -- 入账机构
    ,accorg_name -- 入账机构名称
    ,asset_type_name -- 资产大类名称
    ,report_line_no -- G4B_1报表栏位号
    ,report_line_name -- G4B_1栏位名称
    ,load_date -- 加载日期
    ,rwa_before_adj -- 调整前风险加权资产
    ,rwa_after_adj -- 调整后风险加权资产
    ,g4b_r_item_code -- G4B-5项目
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rwas_rpt_asset_base_asset_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rwas_rpt_asset_base_asset_info exchange partition p_${batch_date} with table ${iol_schema}.rwas_rpt_asset_base_asset_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_rpt_asset_base_asset_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rwas_rpt_asset_base_asset_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_rpt_asset_base_asset_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);