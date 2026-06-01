/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_rwas_rpt_tran_securities
CreateDate: 20241128
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.rwas_rpt_tran_securities drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.rwas_rpt_tran_securities add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.rwas_rpt_tran_securities (
etl_dt  --etl处理日期
,data_date  --数据日期
,loan_ref_no  --借据号
,sec_no  --债券编号
,sec_name  --债券名称
,product_no  --标准产品编号
,product_name  --标准产品名称
,loan_ref_desc  --债项描述
,tradetypeid  --多空头标志
,asset_thd_cls_cd  --金融资产分类
,s_grade  --主体评级
,grade  --债券评级
,int_rat_adj_way_cd  --利率类别
,coupon  --债券利率
,start_date  --起息日
,due_date  --到期日期
,next_reval_date  --下一重定价日期
,rema__reval_date  --剩余重定价期限(月)
,remainingmaturity  --剩余期限(月)
,org_cd  --入账机构编号
,org_name  --入账机构名称
,cust_no  --发行人客户号
,cust_name  --发行人名称
,ccp_type_cd  --交易对手类型
,ccp_type_name  --交易对手类型名称
,sec_type_cd  --债券类型
,subject_cd  --本金科目代码
,subject_name  --本金科目名称
,accrued_subject_cd  --应计利息科目
,accrued_subject_name  --应计利息科目名称
,receivable_subject_cd  --应收利息科目
,receivable_subject_name  --应收利息科目名称
,accrued_receiv_subject_cd  --应收未收利息科目
,accrued_receiv_subject_name  --应收未收利息名称
,intadj_subject_cd  --利息调整科目
,intadj_subject_name  --利息调整科目名称
,fairchange_subject_cd  --公允价值变动科目
,fairchange_subject_name  --公允价值变动科目名称
,provision_subject_cd  --准备金科目代码
,provision_subject_name  --准备金科目名称
,ccy_cd  --币种代码
,ccy_name  --币种名称
,balance  --本金余额(原币)
,balance_hcurr  --本金余额(本币)
,receivable_int  --应收利息(本币)
,accrued_receiv_int  --应收未收利息（本币）
,accrued_int  --应计利息(本币)
,int_adj  --利息调整(本币)
,fair_value_change  --公允价值变动(本币)
,provision  --计提准备金(本币)
,asset_balance  --资产余额(本币）
,ead_orig  --原始风险暴露（本币）
,rate_sec_type_cd  --特定利率风险债券类型
,specific_risk_ratio  --利率特定风险资本计提比率
,spec_risk_capital_amount  --利率特定风险资本
,coupon_flag  --年息票率大于等于3%标志
,mat_bucketid  --时段
,specific_risk_charge  --风险权重
,exposureamount  --一般市场风险的资本要求总额
,general_risk_capital_amount  --一般利率风险资本
,due_date_risk  --到期日风险资本
,rwaamount  --rwa
,scra_rating  --scra评级
,orig_maturity  --原始期限
,load_date  --加载日期

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,t1.data_date as data_date --数据日期
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no --借据号
,replace(replace(t1.sec_no,chr(13),''),chr(10),'') as sec_no --债券编号
,replace(replace(t1.sec_name,chr(13),''),chr(10),'') as sec_name --债券名称
,replace(replace(t1.product_no,chr(13),''),chr(10),'') as product_no --标准产品编号
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name --标准产品名称
,replace(replace(t1.loan_ref_desc,chr(13),''),chr(10),'') as loan_ref_desc --债项描述
,replace(replace(t1.tradetypeid,chr(13),''),chr(10),'') as tradetypeid --多空头标志
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd --金融资产分类
,replace(replace(t1.s_grade,chr(13),''),chr(10),'') as s_grade --主体评级
,replace(replace(t1.grade,chr(13),''),chr(10),'') as grade --债券评级
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd --利率类别
,replace(replace(t1.coupon,chr(13),''),chr(10),'') as coupon --债券利率
,t1.start_date as start_date --起息日
,t1.due_date as due_date --到期日期
,t1.next_reval_date as next_reval_date --下一重定价日期
,t1.rema__reval_date as rema__reval_date --剩余重定价期限(月)
,t1.remainingmaturity as remainingmaturity --剩余期限(月)
,replace(replace(t1.org_cd,chr(13),''),chr(10),'') as org_cd --入账机构编号
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name --入账机构名称
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no --发行人客户号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --发行人名称
,replace(replace(t1.ccp_type_cd,chr(13),''),chr(10),'') as ccp_type_cd --交易对手类型
,replace(replace(t1.ccp_type_name,chr(13),''),chr(10),'') as ccp_type_name --交易对手类型名称
,replace(replace(t1.sec_type_cd,chr(13),''),chr(10),'') as sec_type_cd --债券类型
,replace(replace(t1.subject_cd,chr(13),''),chr(10),'') as subject_cd --本金科目代码
,replace(replace(t1.subject_name,chr(13),''),chr(10),'') as subject_name --本金科目名称
,replace(replace(t1.accrued_subject_cd,chr(13),''),chr(10),'') as accrued_subject_cd --应计利息科目
,replace(replace(t1.accrued_subject_name,chr(13),''),chr(10),'') as accrued_subject_name --应计利息科目名称
,replace(replace(t1.receivable_subject_cd,chr(13),''),chr(10),'') as receivable_subject_cd --应收利息科目
,replace(replace(t1.receivable_subject_name,chr(13),''),chr(10),'') as receivable_subject_name --应收利息科目名称
,replace(replace(t1.accrued_receiv_subject_cd,chr(13),''),chr(10),'') as accrued_receiv_subject_cd --应收未收利息科目
,replace(replace(t1.accrued_receiv_subject_name,chr(13),''),chr(10),'') as accrued_receiv_subject_name --应收未收利息名称
,replace(replace(t1.intadj_subject_cd,chr(13),''),chr(10),'') as intadj_subject_cd --利息调整科目
,replace(replace(t1.intadj_subject_name,chr(13),''),chr(10),'') as intadj_subject_name --利息调整科目名称
,replace(replace(t1.fairchange_subject_cd,chr(13),''),chr(10),'') as fairchange_subject_cd --公允价值变动科目
,replace(replace(t1.fairchange_subject_name,chr(13),''),chr(10),'') as fairchange_subject_name --公允价值变动科目名称
,replace(replace(t1.provision_subject_cd,chr(13),''),chr(10),'') as provision_subject_cd --准备金科目代码
,replace(replace(t1.provision_subject_name,chr(13),''),chr(10),'') as provision_subject_name --准备金科目名称
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd --币种代码
,replace(replace(t1.ccy_name,chr(13),''),chr(10),'') as ccy_name --币种名称
,t1.balance as balance --本金余额(原币)
,t1.balance_hcurr as balance_hcurr --本金余额(本币)
,t1.receivable_int as receivable_int --应收利息(本币)
,t1.accrued_receiv_int as accrued_receiv_int --应收未收利息（本币）
,t1.accrued_int as accrued_int --应计利息(本币)
,t1.int_adj as int_adj --利息调整(本币)
,t1.fair_value_change as fair_value_change --公允价值变动(本币)
,t1.provision as provision --计提准备金(本币)
,t1.asset_balance as asset_balance --资产余额(本币）
,t1.ead_orig as ead_orig --原始风险暴露（本币）
,replace(replace(t1.rate_sec_type_cd,chr(13),''),chr(10),'') as rate_sec_type_cd --特定利率风险债券类型
,replace(replace(t1.specific_risk_ratio,chr(13),''),chr(10),'') as specific_risk_ratio --利率特定风险资本计提比率
,t1.spec_risk_capital_amount as spec_risk_capital_amount --利率特定风险资本
,replace(replace(t1.coupon_flag,chr(13),''),chr(10),'') as coupon_flag --年息票率大于等于3%标志
,replace(replace(t1.mat_bucketid,chr(13),''),chr(10),'') as mat_bucketid --时段
,replace(replace(t1.specific_risk_charge,chr(13),''),chr(10),'') as specific_risk_charge --风险权重
,t1.exposureamount as exposureamount --一般市场风险的资本要求总额
,t1.general_risk_capital_amount as general_risk_capital_amount --一般利率风险资本
,t1.due_date_risk as due_date_risk --到期日风险资本
,t1.rwaamount as rwaamount --rwa
,replace(replace(t1.scra_rating,chr(13),''),chr(10),'') as scra_rating --scra评级
,t1.orig_maturity as orig_maturity --原始期限
,replace(replace(t1.load_date,chr(13),''),chr(10),'') as load_date --加载日期
from ${iol_schema}.rwas_rpt_tran_securities t1    --内部管理报表_交易债券
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') - 1;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'rwas_rpt_tran_securities',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
