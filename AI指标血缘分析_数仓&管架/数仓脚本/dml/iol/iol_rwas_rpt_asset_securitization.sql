/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_rpt_asset_securitization
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
drop table ${iol_schema}.rwas_rpt_asset_securitization_ex purge;
alter table ${iol_schema}.rwas_rpt_asset_securitization add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rwas_rpt_asset_securitization truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rwas_rpt_asset_securitization_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_rpt_asset_securitization where 0=1;

insert /*+ append */ into ${iol_schema}.rwas_rpt_asset_securitization_ex(
    data_date -- 数据日期
    ,loan_ref_no -- 债项编号
    ,sec_items_issue_no -- 资产证券化发行编号
    ,sec_items_issue_name -- 资产证券化发行产品名称
    ,items_tranche_no -- 资产证券化档次编号
    ,items_tranche_name -- 资产证券化档次名称
    ,on_off_id -- 表内外资产标志：01 表内,02 表外
    ,sec_priority_rating_flag -- 证券化优先档次标志：1 优先档，0 非优先档
    ,market_type_id -- 市场类型代码
    ,org_cd -- 账务机构
    ,org_name -- 账务机构名称
    ,overdue_days -- 逾期天数
    ,five_class_cd -- 五级分类代码
    ,five_class_name -- 五级分类名称
    ,product_no -- 产品代码
    ,product_name -- 产品名称
    ,sec_sp_rating_cd -- 外部评级代码
    ,sec_rating_org_cd -- 证券评级机构代码
    ,sec_rating_org_name -- 证券评级机构名称
    ,sec_ecternal_rating_cd -- 债券标普评级
    ,items_tranche_due_day -- 持有档次的预期到期日
    ,items_seniority -- 项目档次优先级：1 优先档，0 非优先档
    ,issue_amt_total -- 产品当期总余额
    ,amt_cur -- 产品当期总余额
    ,sec_stc_flag -- 资产证券化简单透明可比标志：1 STC，0 非STC
    ,anew_asset_sec_flag -- 再资产证券化标志：1 是，0 否
    ,sec_start_date -- 证券起息日
    ,sec_end_date -- 证券到期日
    ,sec_pool_a -- 档次起始点A
    ,sec_pool_d -- 档次分离点D
    ,sec_pool_t -- 厚度T
    ,sec_pool_mr -- 剩余有效期限
    ,sec_rating_floor_rw -- 外部评级1年期权重
    ,sec_rating_ceil_rw -- 外部评级5年期权重
    ,sec_orig_rw -- 资产证券化原始权重
    ,sec_pool_rw -- 资产池平均权重
    ,sec_rw -- 资产证券化调整后权重
    ,sec_rw_adj -- 资产证券化底线调整后的权重
    ,ccy_cd -- 币种代码
    ,ccy_name -- 币种名称
    ,subject_cd -- 本金科目代码
    ,subject_name -- 本金科目名称
    ,accrued_subject_cd -- 应计利息科目
    ,accrued_subject_name -- 应计利息科目名称
    ,receivable_subject_cd -- 应收利息科目
    ,receivable_subject_name -- 应收利息科目名称
    ,accrued_receiv_subject_cd -- 应收未收利息科目
    ,accrued_receiv_subject_name -- 应收未收利息名称
    ,intadj_subject_cd -- 利息调整科目
    ,intadj_subject_name -- 利息调整科目名称
    ,fairchange_subject_cd -- 公允价值变动科目
    ,fairchange_subject_name -- 公允价值变动科目名称
    ,provision_subject_cd -- 准备金科目代码
    ,provision_subject_name -- 准备金科目名称
    ,balance -- 本金余额（原币）
    ,balance_hcurr -- 本金余额（本币）
    ,receivable_int -- 应收利息(本币)
    ,accrued_receiv_int -- 应收未收利息（本币）
    ,accrued_int -- 应计利息(本币)
    ,int_adj -- 利息调整(本币)
    ,fair_value_change -- 公允价值变动(本币)
    ,provision -- 计提准备金(本币)
    ,asset_balance -- 资产余额(本币）
    ,ead_orig -- 原始风险暴露(本币）
    ,ccf -- 表外信用风险转换系数
    ,ead_afterccf -- 转换后的风险暴露(本币）
    ,ead_afterpro -- 扣减准备金后的风险暴露（本币）
    ,rwa -- 风险加权资产
    ,after_miti_rwa -- 缓释后的风险加权资产
    ,after_adj_rwa -- 考虑监管上限调整后的风险加权资产
    ,report_no -- 报表编号
    ,report_line_no -- 报表栏位号
    ,load_date -- 加载日期
    ,book_type_id -- 账簿类型：BANK_BOOK 银行账簿，TRADE_BOOK 交易账簿
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期
    ,loan_ref_no -- 债项编号
    ,sec_items_issue_no -- 资产证券化发行编号
    ,sec_items_issue_name -- 资产证券化发行产品名称
    ,items_tranche_no -- 资产证券化档次编号
    ,items_tranche_name -- 资产证券化档次名称
    ,on_off_id -- 表内外资产标志：01 表内,02 表外
    ,sec_priority_rating_flag -- 证券化优先档次标志：1 优先档，0 非优先档
    ,market_type_id -- 市场类型代码
    ,org_cd -- 账务机构
    ,org_name -- 账务机构名称
    ,overdue_days -- 逾期天数
    ,five_class_cd -- 五级分类代码
    ,five_class_name -- 五级分类名称
    ,product_no -- 产品代码
    ,product_name -- 产品名称
    ,sec_sp_rating_cd -- 外部评级代码
    ,sec_rating_org_cd -- 证券评级机构代码
    ,sec_rating_org_name -- 证券评级机构名称
    ,sec_ecternal_rating_cd -- 债券标普评级
    ,items_tranche_due_day -- 持有档次的预期到期日
    ,items_seniority -- 项目档次优先级：1 优先档，0 非优先档
    ,issue_amt_total -- 产品当期总余额
    ,amt_cur -- 产品当期总余额
    ,sec_stc_flag -- 资产证券化简单透明可比标志：1 STC，0 非STC
    ,anew_asset_sec_flag -- 再资产证券化标志：1 是，0 否
    ,sec_start_date -- 证券起息日
    ,sec_end_date -- 证券到期日
    ,sec_pool_a -- 档次起始点A
    ,sec_pool_d -- 档次分离点D
    ,sec_pool_t -- 厚度T
    ,sec_pool_mr -- 剩余有效期限
    ,sec_rating_floor_rw -- 外部评级1年期权重
    ,sec_rating_ceil_rw -- 外部评级5年期权重
    ,sec_orig_rw -- 资产证券化原始权重
    ,sec_pool_rw -- 资产池平均权重
    ,sec_rw -- 资产证券化调整后权重
    ,sec_rw_adj -- 资产证券化底线调整后的权重
    ,ccy_cd -- 币种代码
    ,ccy_name -- 币种名称
    ,subject_cd -- 本金科目代码
    ,subject_name -- 本金科目名称
    ,accrued_subject_cd -- 应计利息科目
    ,accrued_subject_name -- 应计利息科目名称
    ,receivable_subject_cd -- 应收利息科目
    ,receivable_subject_name -- 应收利息科目名称
    ,accrued_receiv_subject_cd -- 应收未收利息科目
    ,accrued_receiv_subject_name -- 应收未收利息名称
    ,intadj_subject_cd -- 利息调整科目
    ,intadj_subject_name -- 利息调整科目名称
    ,fairchange_subject_cd -- 公允价值变动科目
    ,fairchange_subject_name -- 公允价值变动科目名称
    ,provision_subject_cd -- 准备金科目代码
    ,provision_subject_name -- 准备金科目名称
    ,balance -- 本金余额（原币）
    ,balance_hcurr -- 本金余额（本币）
    ,receivable_int -- 应收利息(本币)
    ,accrued_receiv_int -- 应收未收利息（本币）
    ,accrued_int -- 应计利息(本币)
    ,int_adj -- 利息调整(本币)
    ,fair_value_change -- 公允价值变动(本币)
    ,provision -- 计提准备金(本币)
    ,asset_balance -- 资产余额(本币）
    ,ead_orig -- 原始风险暴露(本币）
    ,ccf -- 表外信用风险转换系数
    ,ead_afterccf -- 转换后的风险暴露(本币）
    ,ead_afterpro -- 扣减准备金后的风险暴露（本币）
    ,rwa -- 风险加权资产
    ,after_miti_rwa -- 缓释后的风险加权资产
    ,after_adj_rwa -- 考虑监管上限调整后的风险加权资产
    ,report_no -- 报表编号
    ,report_line_no -- 报表栏位号
    ,load_date -- 加载日期
    ,book_type_id -- 账簿类型：BANK_BOOK 银行账簿，TRADE_BOOK 交易账簿
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rwas_rpt_asset_securitization
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rwas_rpt_asset_securitization exchange partition p_${batch_date} with table ${iol_schema}.rwas_rpt_asset_securitization_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_rpt_asset_securitization to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rwas_rpt_asset_securitization_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_rpt_asset_securitization',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);