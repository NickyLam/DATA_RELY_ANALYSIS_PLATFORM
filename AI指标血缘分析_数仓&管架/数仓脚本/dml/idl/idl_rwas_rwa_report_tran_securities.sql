/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_rwas_rwa_report_tran_securities
CreateDate: 20240326
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.rwas_rwa_report_tran_securities drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.rwas_rwa_report_tran_securities add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.rwas_rwa_report_tran_securities (
etl_dt  --etl处理日期
,data_date  --数据日期
,loan_ref_id  --债项ID
,loan_ref_no  --借据号
,sec_no  --证券编号
,tradetypeid  --多空头标志
,asset_thd_cls_cd  --金融资产分类
,s_grade  --主体评级
,grade  --债券评级
,int_rat_adj_way_cd  --利率类别
,coupon  --债券利率
,start_date  --开始日期
,due_date  --到期日期
,next_reval_date  --下一重定价日期
,rema__reval_date  --剩余重定价期限(月)
,remainingmaturity  --剩余期限(月)
,org_cd  --入账机构
,cust_name  --发行人名称
,ccp_type_cd  --客户类型(引擎)
,sec_type_cd  --证券类型
,assettype_id  --资产类型(引擎)
,subject_cd  --本金科目代码
,interest_receive_subject_cd  --应收利息科目代码
,accrual_class_subject_cd  --应计科目代码
,interest_adjust_subject_cd  --利息调整科目代码
,fairvalue_changes_subject_cd  --公允价值变动科目代码
,provision_single_subject_cd  --准备金科目代码
,asset_balance  --资产余额(原币)
,ccy_cd  --币种代码
,asset_balance_hcurr  --资产余额(本币)
,receivable_int  --应收利息(本币)
,accrued_int  --应计利息(本币)
,int_adj  --利息调整(本币)
,fair_value_change  --公允价值变动(本币)
,provision  --计提准备金(本币)
,amt  --证券头寸金额(本币)
,rate_sec_type_cd  --特定利率风险债券类型
,specific_risk_ratio  --利率特定风险资本计提比率
,spec_risk_capital_amount  --利率特定风险资本
,coupon_flag  --年息票率大于等于3%标志
,mat_bucketid  --时段
,specific_risk_charge  --风险权重
,exposureamount  --一般市场风险的资本要求总额
,rwaamount  --RWA
,sec_name  --证券名称
,product_name  --交易品种
,general_risk_capital_amount  --一般利率风险资本

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,t1.data_date as data_date --数据日期
,t1.loan_ref_id as loan_ref_id --债项ID
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no --借据号
,replace(replace(t1.sec_no,chr(13),''),chr(10),'') as sec_no --证券编号
,replace(replace(t1.tradetypeid,chr(13),''),chr(10),'') as tradetypeid --多空头标志
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd --金融资产分类
,replace(replace(t1.s_grade,chr(13),''),chr(10),'') as s_grade --主体评级
,replace(replace(t1.grade,chr(13),''),chr(10),'') as grade --债券评级
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率类别
,replace(replace(t1.coupon,chr(13),''),chr(10),'') as coupon --债券利率
,t1.start_date as start_date --开始日期
,t1.due_date as due_date --到期日期
,t1.next_reval_date as next_reval_date --下一重定价日期
,t1.rema__reval_date as rema__reval_date --剩余重定价期限(月)
,t1.remainingmaturity as remainingmaturity --剩余期限(月)
,replace(replace(t1.org_cd,chr(13),''),chr(10),'') as org_cd --入账机构
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --发行人名称
,replace(replace(t1.ccp_type_cd,chr(13),''),chr(10),'') as ccp_type_cd --客户类型(引擎)
,replace(replace(t1.sec_type_cd,chr(13),''),chr(10),'') as sec_type_cd --证券类型
,replace(replace(t1.assettype_id,chr(13),''),chr(10),'') as assettype_id --资产类型(引擎)
,replace(replace(t1.subject_cd,chr(13),''),chr(10),'') as subject_cd --本金科目代码
,replace(replace(t1.interest_receive_subject_cd,chr(13),''),chr(10),'') as interest_receive_subject_cd --应收利息科目代码
,replace(replace(t1.accrual_class_subject_cd,chr(13),''),chr(10),'') as accrual_class_subject_cd --应计科目代码
,replace(replace(t1.interest_adjust_subject_cd,chr(13),''),chr(10),'') as interest_adjust_subject_cd --利息调整科目代码
,replace(replace(t1.fairvalue_changes_subject_cd,chr(13),''),chr(10),'') as fairvalue_changes_subject_cd --公允价值变动科目代码
,replace(replace(t1.provision_single_subject_cd,chr(13),''),chr(10),'') as provision_single_subject_cd --准备金科目代码
,t1.asset_balance as asset_balance --资产余额(原币)
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd --币种代码
,t1.asset_balance_hcurr as asset_balance_hcurr --资产余额(本币)
,t1.receivable_int as receivable_int --应收利息(本币)
,t1.accrued_int as accrued_int --应计利息(本币)
,t1.int_adj as int_adj --利息调整(本币)
,t1.fair_value_change as fair_value_change --公允价值变动(本币)
,t1.provision as provision --计提准备金(本币)
,t1.amt as amt --证券头寸金额(本币)
,replace(replace(t1.rate_sec_type_cd,chr(13),''),chr(10),'') as rate_sec_type_cd --特定利率风险债券类型
,t1.specific_risk_ratio as specific_risk_ratio --利率特定风险资本计提比率
,t1.spec_risk_capital_amount as spec_risk_capital_amount --利率特定风险资本
,replace(replace(t1.coupon_flag,chr(13),''),chr(10),'') as coupon_flag --年息票率大于等于3%标志
,replace(replace(t1.mat_bucketid,chr(13),''),chr(10),'') as mat_bucketid --时段
,replace(replace(t1.specific_risk_charge,chr(13),''),chr(10),'') as specific_risk_charge --风险权重
,t1.exposureamount as exposureamount --一般市场风险的资本要求总额
,t1.rwaamount as rwaamount --RWA
,replace(replace(t1.sec_name,chr(13),''),chr(10),'') as sec_name --证券名称
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name --交易品种
,t1.general_risk_capital_amount as general_risk_capital_amount --一般利率风险资本
from ${iol_schema}.rwas_rwa_report_tran_securities t1    --债项填报信息表
where start_dt <= to_date('${batch_date}','yyyymmdd')-1 and end_dt > to_date('${batch_date}','yyyymmdd')-1;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'rwas_rwa_report_tran_securities',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
