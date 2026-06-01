/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_rwas_rpt_asset_securitization
CreateDate: 20241113
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.rwas_rpt_asset_securitization drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.rwas_rpt_asset_securitization add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.rwas_rpt_asset_securitization (
etl_dt  --etl处理日期
,data_date  --数据日期
,loan_ref_no  --债项编号
,sec_items_issue_no  --资产证券化发行编号
,sec_items_issue_name  --资产证券化发行产品名称
,items_tranche_no  --资产证券化档次编号
,items_tranche_name  --资产证券化档次名称
,on_off_id  --表内外资产标志：01 表内,02 表外
,sec_priority_rating_flag  --证券化优先档次标志：1 优先档，0 非优先档
,market_type_id  --市场类型代码
,org_cd  --账务机构
,org_name  --账务机构名称
,overdue_days  --逾期天数
,five_class_cd  --五级分类代码
,five_class_name  --五级分类名称
,product_no  --产品代码
,product_name  --产品名称
,sec_sp_rating_cd  --外部评级代码
,sec_rating_org_cd  --证券评级机构代码
,sec_rating_org_name  --证券评级机构名称
,sec_ecternal_rating_cd  --债券标普评级
,items_tranche_due_day  --持有档次的预期到期日
,items_seniority  --项目档次优先级：1 优先档，0 非优先档
,issue_amt_total  --产品当期总余额
,amt_cur  --产品当期总余额
,sec_stc_flag  --资产证券化简单透明可比标志：1 stc，0 非stc
,anew_asset_sec_flag  --再资产证券化标志：1 是，0 否
,sec_start_date  --证券起息日
,sec_end_date  --证券到期日
,sec_pool_a  --档次起始点a
,sec_pool_d  --档次分离点d
,sec_pool_t  --厚度t
,sec_pool_mr  --剩余有效期限
,sec_rating_floor_rw  --外部评级1年期权重
,sec_rating_ceil_rw  --外部评级5年期权重
,sec_orig_rw  --资产证券化原始权重
,sec_pool_rw  --资产池平均权重
,sec_rw  --资产证券化调整后权重
,sec_rw_adj  --资产证券化底线调整后的权重
,ccy_cd  --币种代码
,ccy_name  --币种名称
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
,balance  --本金余额（原币）
,balance_hcurr  --本金余额（本币）
,receivable_int  --应收利息(本币)
,accrued_receiv_int  --应收未收利息（本币）
,accrued_int  --应计利息(本币)
,int_adj  --利息调整(本币)
,fair_value_change  --公允价值变动(本币)
,provision  --计提准备金(本币)
,asset_balance  --资产余额(本币）
,ead_orig  --原始风险暴露(本币）
,ccf  --表外信用风险转换系数
,ead_afterccf  --转换后的风险暴露(本币）
,ead_afterpro  --扣减准备金后的风险暴露（本币）
,rwa  --风险加权资产
,after_miti_rwa  --缓释后的风险加权资产
,after_adj_rwa  --考虑监管上限调整后的风险加权资产
,report_no  --报表编号
,report_line_no  --报表栏位号
,load_date  --加载日期
,book_type_id  --账簿类型：bank_book 银行账簿，trade_book 交易账簿

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,t1.data_date as data_date --数据日期
,replace(replace(t1.loan_ref_no,chr(13),''),chr(10),'') as loan_ref_no --债项编号
,replace(replace(t1.sec_items_issue_no,chr(13),''),chr(10),'') as sec_items_issue_no --资产证券化发行编号
,replace(replace(t1.sec_items_issue_name,chr(13),''),chr(10),'') as sec_items_issue_name --资产证券化发行产品名称
,replace(replace(t1.items_tranche_no,chr(13),''),chr(10),'') as items_tranche_no --资产证券化档次编号
,replace(replace(t1.items_tranche_name,chr(13),''),chr(10),'') as items_tranche_name --资产证券化档次名称
,replace(replace(t1.on_off_id,chr(13),''),chr(10),'') as on_off_id --表内外资产标志：01 表内,02 表外
,replace(replace(t1.sec_priority_rating_flag,chr(13),''),chr(10),'') as sec_priority_rating_flag --证券化优先档次标志：1 优先档，0 非优先档
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id --市场类型代码
,replace(replace(t1.org_cd,chr(13),''),chr(10),'') as org_cd --账务机构
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name --账务机构名称
,t1.overdue_days as overdue_days --逾期天数
,replace(replace(t1.five_class_cd,chr(13),''),chr(10),'') as five_class_cd --五级分类代码
,replace(replace(t1.five_class_name,chr(13),''),chr(10),'') as five_class_name --五级分类名称
,replace(replace(t1.product_no,chr(13),''),chr(10),'') as product_no --产品代码
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name --产品名称
,replace(replace(t1.sec_sp_rating_cd,chr(13),''),chr(10),'') as sec_sp_rating_cd --外部评级代码
,replace(replace(t1.sec_rating_org_cd,chr(13),''),chr(10),'') as sec_rating_org_cd --证券评级机构代码
,replace(replace(t1.sec_rating_org_name,chr(13),''),chr(10),'') as sec_rating_org_name --证券评级机构名称
,replace(replace(t1.sec_ecternal_rating_cd,chr(13),''),chr(10),'') as sec_ecternal_rating_cd --债券标普评级
,t1.items_tranche_due_day as items_tranche_due_day --持有档次的预期到期日
,replace(replace(t1.items_seniority,chr(13),''),chr(10),'') as items_seniority --项目档次优先级：1 优先档，0 非优先档
,t1.issue_amt_total as issue_amt_total --产品当期总余额
,t1.amt_cur as amt_cur --产品当期总余额
,replace(replace(t1.sec_stc_flag,chr(13),''),chr(10),'') as sec_stc_flag --资产证券化简单透明可比标志：1 stc，0 非stc
,replace(replace(t1.anew_asset_sec_flag,chr(13),''),chr(10),'') as anew_asset_sec_flag --再资产证券化标志：1 是，0 否
,t1.sec_start_date as sec_start_date --证券起息日
,t1.sec_end_date as sec_end_date --证券到期日
,t1.sec_pool_a as sec_pool_a --档次起始点a
,t1.sec_pool_d as sec_pool_d --档次分离点d
,t1.sec_pool_t as sec_pool_t --厚度t
,t1.sec_pool_mr as sec_pool_mr --剩余有效期限
,t1.sec_rating_floor_rw as sec_rating_floor_rw --外部评级1年期权重
,t1.sec_rating_ceil_rw as sec_rating_ceil_rw --外部评级5年期权重
,t1.sec_orig_rw as sec_orig_rw --资产证券化原始权重
,t1.sec_pool_rw as sec_pool_rw --资产池平均权重
,t1.sec_rw as sec_rw --资产证券化调整后权重
,t1.sec_rw_adj as sec_rw_adj --资产证券化底线调整后的权重
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd --币种代码
,replace(replace(t1.ccy_name,chr(13),''),chr(10),'') as ccy_name --币种名称
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
,t1.balance as balance --本金余额（原币）
,t1.balance_hcurr as balance_hcurr --本金余额（本币）
,t1.receivable_int as receivable_int --应收利息(本币)
,t1.accrued_receiv_int as accrued_receiv_int --应收未收利息（本币）
,t1.accrued_int as accrued_int --应计利息(本币)
,t1.int_adj as int_adj --利息调整(本币)
,t1.fair_value_change as fair_value_change --公允价值变动(本币)
,t1.provision as provision --计提准备金(本币)
,t1.asset_balance as asset_balance --资产余额(本币）
,t1.ead_orig as ead_orig --原始风险暴露(本币）
,t1.ccf as ccf --表外信用风险转换系数
,t1.ead_afterccf as ead_afterccf --转换后的风险暴露(本币）
,t1.ead_afterpro as ead_afterpro --扣减准备金后的风险暴露（本币）
,t1.rwa as rwa --风险加权资产
,t1.after_miti_rwa as after_miti_rwa --缓释后的风险加权资产
,t1.after_adj_rwa as after_adj_rwa --考虑监管上限调整后的风险加权资产
,replace(replace(t1.report_no,chr(13),''),chr(10),'') as report_no --报表编号
,replace(replace(t1.report_line_no,chr(13),''),chr(10),'') as report_line_no --报表栏位号
,replace(replace(t1.load_date,chr(13),''),chr(10),'') as load_date --加载日期
,replace(replace(t1.book_type_id,chr(13),''),chr(10),'') as book_type_id --账簿类型：bank_book 银行账簿，trade_book 交易账簿
from ${iol_schema}.rwas_rpt_asset_securitization t1    --内部管理报表_资产证券化
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') - 1;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'rwas_rpt_asset_securitization',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
