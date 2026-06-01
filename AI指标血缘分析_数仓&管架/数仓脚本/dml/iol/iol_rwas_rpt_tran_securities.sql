/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rwas_rpt_tran_securities
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
drop table ${iol_schema}.rwas_rpt_tran_securities_ex purge;
alter table ${iol_schema}.rwas_rpt_tran_securities add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rwas_rpt_tran_securities truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rwas_rpt_tran_securities_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rwas_rpt_tran_securities where 0=1;

insert /*+ append */ into ${iol_schema}.rwas_rpt_tran_securities_ex(
    data_date -- 数据日期
    ,loan_ref_no -- 借据号
    ,sec_no -- 债券编号
    ,sec_name -- 债券名称
    ,product_no -- 标准产品编号
    ,product_name -- 标准产品名称
    ,loan_ref_desc -- 债项描述
    ,tradetypeid -- 多空头标志
    ,asset_thd_cls_cd -- 金融资产分类
    ,s_grade -- 主体评级
    ,grade -- 债券评级
    ,int_rat_adj_way_cd -- 利率类别
    ,coupon -- 债券利率
    ,start_date -- 起息日
    ,due_date -- 到期日期
    ,next_reval_date -- 下一重定价日期
    ,rema__reval_date -- 剩余重定价期限(月)
    ,remainingmaturity -- 剩余期限(月)
    ,org_cd -- 入账机构编号
    ,org_name -- 入账机构名称
    ,cust_no -- 发行人客户号
    ,cust_name -- 发行人名称
    ,ccp_type_cd -- 交易对手类型
    ,ccp_type_name -- 交易对手类型名称
    ,sec_type_cd -- 债券类型
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
    ,ccy_cd -- 币种代码
    ,ccy_name -- 币种名称
    ,balance -- 本金余额(原币)
    ,balance_hcurr -- 本金余额(本币)
    ,receivable_int -- 应收利息(本币)
    ,accrued_receiv_int -- 应收未收利息（本币）
    ,accrued_int -- 应计利息(本币)
    ,int_adj -- 利息调整(本币)
    ,fair_value_change -- 公允价值变动(本币)
    ,provision -- 计提准备金(本币)
    ,asset_balance -- 资产余额(本币）
    ,ead_orig -- 原始风险暴露（本币）
    ,rate_sec_type_cd -- 特定利率风险债券类型
    ,specific_risk_ratio -- 利率特定风险资本计提比率
    ,spec_risk_capital_amount -- 利率特定风险资本
    ,coupon_flag -- 年息票率大于等于3%标志
    ,mat_bucketid -- 时段
    ,specific_risk_charge -- 风险权重
    ,exposureamount -- 一般市场风险的资本要求总额
    ,general_risk_capital_amount -- 一般利率风险资本
    ,due_date_risk -- 到期日风险资本
    ,rwaamount -- RWA
    ,scra_rating -- SCRA评级
    ,orig_maturity -- 原始期限
    ,load_date -- 加载日期
    ,final_weight -- 最终风险权重
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_date -- 数据日期
    ,loan_ref_no -- 借据号
    ,sec_no -- 债券编号
    ,sec_name -- 债券名称
    ,product_no -- 标准产品编号
    ,product_name -- 标准产品名称
    ,loan_ref_desc -- 债项描述
    ,tradetypeid -- 多空头标志
    ,asset_thd_cls_cd -- 金融资产分类
    ,s_grade -- 主体评级
    ,grade -- 债券评级
    ,int_rat_adj_way_cd -- 利率类别
    ,coupon -- 债券利率
    ,start_date -- 起息日
    ,due_date -- 到期日期
    ,next_reval_date -- 下一重定价日期
    ,rema__reval_date -- 剩余重定价期限(月)
    ,remainingmaturity -- 剩余期限(月)
    ,org_cd -- 入账机构编号
    ,org_name -- 入账机构名称
    ,cust_no -- 发行人客户号
    ,cust_name -- 发行人名称
    ,ccp_type_cd -- 交易对手类型
    ,ccp_type_name -- 交易对手类型名称
    ,sec_type_cd -- 债券类型
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
    ,ccy_cd -- 币种代码
    ,ccy_name -- 币种名称
    ,balance -- 本金余额(原币)
    ,balance_hcurr -- 本金余额(本币)
    ,receivable_int -- 应收利息(本币)
    ,accrued_receiv_int -- 应收未收利息（本币）
    ,accrued_int -- 应计利息(本币)
    ,int_adj -- 利息调整(本币)
    ,fair_value_change -- 公允价值变动(本币)
    ,provision -- 计提准备金(本币)
    ,asset_balance -- 资产余额(本币）
    ,ead_orig -- 原始风险暴露（本币）
    ,rate_sec_type_cd -- 特定利率风险债券类型
    ,specific_risk_ratio -- 利率特定风险资本计提比率
    ,spec_risk_capital_amount -- 利率特定风险资本
    ,coupon_flag -- 年息票率大于等于3%标志
    ,mat_bucketid -- 时段
    ,specific_risk_charge -- 风险权重
    ,exposureamount -- 一般市场风险的资本要求总额
    ,general_risk_capital_amount -- 一般利率风险资本
    ,due_date_risk -- 到期日风险资本
    ,rwaamount -- RWA
    ,scra_rating -- SCRA评级
    ,orig_maturity -- 原始期限
    ,load_date -- 加载日期
    ,final_weight -- 最终风险权重
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rwas_rpt_tran_securities
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rwas_rpt_tran_securities exchange partition p_${batch_date} with table ${iol_schema}.rwas_rpt_tran_securities_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rwas_rpt_tran_securities to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rwas_rpt_tran_securities_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rwas_rpt_tran_securities',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);