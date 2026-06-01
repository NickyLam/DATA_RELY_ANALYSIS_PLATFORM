/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_acct_bal_h
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
alter table ${idl_schema}.oass_agt_loan_acct_bal_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_acct_bal_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_acct_bal_h (
etl_dt  --数据日期
,acct_id  --账户编号
,cust_id  --客户编号
,distr_amt  --发放金额
,ld_distr_amt  --上日发放金额
,nomal_pric  --正常本金
,ld_nomal_pric  --上日正常本金
,ovdue_pric  --逾期本金
,ld_ovdue_pric  --上日逾期本金
,ovdue_int  --逾期利息
,ld_ovdue_int  --上日逾期利息
,ovdue_pnlt  --逾期罚息
,ld_ovdue_pnlt  --上日逾期罚息
,ovdue_comp_int  --逾期复利
,ld_ovdue_comp_int  --上日逾期复利
,grace_period_pric  --宽限期本金
,ld_grace_period_pric  --上日宽限期本金
,grace_period_int  --宽限期利息
,ld_grace_period_int  --上日宽限期利息
,grace_period_pnlt  --宽限期罚息
,ld_grace_period_pnlt  --上日宽限期罚息
,grace_period_comp_int  --宽限期复利
,ld_grace_period_comp_int  --上日宽限期复利
,last_activ_acct_dt  --上一动户日期
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,t1.distr_amt as distr_amt --发放金额
,t1.ld_distr_amt as ld_distr_amt --上日发放金额
,t1.nomal_pric as nomal_pric --正常本金
,t1.ld_nomal_pric as ld_nomal_pric --上日正常本金
,t1.ovdue_pric as ovdue_pric --逾期本金
,t1.ld_ovdue_pric as ld_ovdue_pric --上日逾期本金
,t1.ovdue_int as ovdue_int --逾期利息
,t1.ld_ovdue_int as ld_ovdue_int --上日逾期利息
,t1.ovdue_pnlt as ovdue_pnlt --逾期罚息
,t1.ld_ovdue_pnlt as ld_ovdue_pnlt --上日逾期罚息
,t1.ovdue_comp_int as ovdue_comp_int --逾期复利
,t1.ld_ovdue_comp_int as ld_ovdue_comp_int --上日逾期复利
,t1.grace_period_pric as grace_period_pric --宽限期本金
,t1.ld_grace_period_pric as ld_grace_period_pric --上日宽限期本金
,t1.grace_period_int as grace_period_int --宽限期利息
,t1.ld_grace_period_int as ld_grace_period_int --上日宽限期利息
,t1.grace_period_pnlt as grace_period_pnlt --宽限期罚息
,t1.ld_grace_period_pnlt as ld_grace_period_pnlt --上日宽限期罚息
,t1.grace_period_comp_int as grace_period_comp_int --宽限期复利
,t1.ld_grace_period_comp_int as ld_grace_period_comp_int --上日宽限期复利
,t1.last_activ_acct_dt as last_activ_acct_dt --上一动户日期
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_loan_acct_bal_h t1    --贷款账户余额历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_acct_bal_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
