/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_repay_plan_dtl_h
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_agt_loan_repay_plan_dtl_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_repay_plan_dtl_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_repay_plan_dtl_h (
etl_dt  --数据日期
,repay_plan_id  --还款计划编号
,acct_id  --账户编号
,cust_id  --客户编号
,curr_pd  --当前期次
,amt_type_cd  --金额类型代码
,value_dt  --起息日期
,int_set_dt  --结息日期
,plan_repay_amt  --计划还款金额
,aldy_paid_amt  --已还金额
,pric_amt  --本金金额
,iss_flg  --出单标志
,advise_odd_no  --通知单号
,iss_int_rat  --出单利率
,iss_amt  --出单金额
,doc_bal  --单据余额
,doc_exp_dt  --单据到期日期
,grace_dt  --宽限日期
,tran_dt  --交易日期
,stl_dt  --结算日期
,full_amt_callbk_flg  --全额回收标志
,doc_create_way_cd  --单据生成方式代码
,tran_ref_no  --交易参考号
,tax_category_cd  --税种代码
,tax_rat  --税率
,tax_amt  --税金
,doc_ld_unpaid_amt  --单据上日未还金额
,ld_bal_update_dt  --上日余额更新日期
,delay_pay_int_flg  --延期付息标志
,wrt_off_pric  --核销本金
,tran_teller_id  --交易柜员编号
,final_modif_dt  --最后修改日期
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.repay_plan_id,chr(13),''),chr(10),'') as repay_plan_id --还款计划编号
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,t1.curr_pd as curr_pd --当前期次
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd --金额类型代码
,t1.value_dt as value_dt --起息日期
,t1.int_set_dt as int_set_dt --结息日期
,t1.plan_repay_amt as plan_repay_amt --计划还款金额
,t1.aldy_paid_amt as aldy_paid_amt --已还金额
,t1.pric_amt as pric_amt --本金金额
,replace(replace(t1.iss_flg,chr(13),''),chr(10),'') as iss_flg --出单标志
,replace(replace(t1.advise_odd_no,chr(13),''),chr(10),'') as advise_odd_no --通知单号
,t1.iss_int_rat as iss_int_rat --出单利率
,t1.iss_amt as iss_amt --出单金额
,t1.doc_bal as doc_bal --单据余额
,t1.doc_exp_dt as doc_exp_dt --单据到期日期
,t1.grace_dt as grace_dt --宽限日期
,t1.tran_dt as tran_dt --交易日期
,t1.stl_dt as stl_dt --结算日期
,replace(replace(t1.full_amt_callbk_flg,chr(13),''),chr(10),'') as full_amt_callbk_flg --全额回收标志
,replace(replace(t1.doc_create_way_cd,chr(13),''),chr(10),'') as doc_create_way_cd --单据生成方式代码
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no --交易参考号
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd --税种代码
,t1.tax_rat as tax_rat --税率
,t1.tax_amt as tax_amt --税金
,t1.doc_ld_unpaid_amt as doc_ld_unpaid_amt --单据上日未还金额
,t1.ld_bal_update_dt as ld_bal_update_dt --上日余额更新日期
,replace(replace(t1.delay_pay_int_flg,chr(13),''),chr(10),'') as delay_pay_int_flg --延期付息标志
,t1.wrt_off_pric as wrt_off_pric --核销本金
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id --交易柜员编号
,t1.final_modif_dt as final_modif_dt --最后修改日期
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_loan_repay_plan_dtl_h t1    --贷款还款计划明细历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_repay_plan_dtl_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
