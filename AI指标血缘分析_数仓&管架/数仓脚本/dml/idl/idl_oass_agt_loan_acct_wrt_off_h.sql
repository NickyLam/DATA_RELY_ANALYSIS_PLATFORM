/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_loan_acct_wrt_off_h
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
alter table ${idl_schema}.oass_agt_loan_acct_wrt_off_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_loan_acct_wrt_off_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_loan_acct_wrt_off_h (
etl_dt  --数据日期
,wrt_off_seq_num  --核销序号
,acct_id  --账户编号
,cust_id  --客户编号
,wrt_off_dt  --核销日期
,wrt_off_pric  --核销本金
,ld_wrt_off_pric  --上日核销本金
,wrt_off_tm_point_amt  --核销时点金额
,wrt_off_nomal_int  --核销正常利息
,ld_wrt_off_nomal_int  --上日核销正常利息
,wrt_off_tm_point_int_amt  --核销时点利息金额
,wrt_off_comp_int_int  --核销复利利息
,ld_wrt_off_comp_int_int  --上日核销复利利息
,wrt_off_tm_point_comp_int_amt  --核销时点复利金额
,wrt_off_comp_int_comp_int  --核销复利的复利
,ld_wrt_off_comp_int_comp_int  --上日核销复利的复利
,wrt_off_tm_point_comp_int_comp_int_amt  --核销时点复利的复利金额
,wrt_off_pnlt_comp_int  --核销罚息的复利
,ld_wrt_off_pnlt_comp_int  --上日核销罚息的复利
,wrt_off_tm_point_pnlt_comp_int_amt  --核销时点罚息的复利金额
,wrt_off_pnlt_int  --核销罚息利息
,ld_wrt_off_pnlt_int  --上日核销罚息利息
,wrt_off_tm_point_pnlt_amt  --核销时点罚息金额
,wrt_off_type_cd  --核销类型代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.wrt_off_seq_num,chr(13),''),chr(10),'') as wrt_off_seq_num --核销序号
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id --账户编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,t1.wrt_off_dt as wrt_off_dt --核销日期
,t1.wrt_off_pric as wrt_off_pric --核销本金
,t1.ld_wrt_off_pric as ld_wrt_off_pric --上日核销本金
,t1.wrt_off_tm_point_amt as wrt_off_tm_point_amt --核销时点金额
,t1.wrt_off_nomal_int as wrt_off_nomal_int --核销正常利息
,t1.ld_wrt_off_nomal_int as ld_wrt_off_nomal_int --上日核销正常利息
,t1.wrt_off_tm_point_int_amt as wrt_off_tm_point_int_amt --核销时点利息金额
,t1.wrt_off_comp_int_int as wrt_off_comp_int_int --核销复利利息
,t1.ld_wrt_off_comp_int_int as ld_wrt_off_comp_int_int --上日核销复利利息
,t1.wrt_off_tm_point_comp_int_amt as wrt_off_tm_point_comp_int_amt --核销时点复利金额
,t1.wrt_off_comp_int_comp_int as wrt_off_comp_int_comp_int --核销复利的复利
,t1.ld_wrt_off_comp_int_comp_int as ld_wrt_off_comp_int_comp_int --上日核销复利的复利
,t1.wrt_off_tm_point_comp_int_comp_int_amt as wrt_off_tm_point_comp_int_comp_int_amt --核销时点复利的复利金额
,t1.wrt_off_pnlt_comp_int as wrt_off_pnlt_comp_int --核销罚息的复利
,t1.ld_wrt_off_pnlt_comp_int as ld_wrt_off_pnlt_comp_int --上日核销罚息的复利
,t1.wrt_off_tm_point_pnlt_comp_int_amt as wrt_off_tm_point_pnlt_comp_int_amt --核销时点罚息的复利金额
,t1.wrt_off_pnlt_int as wrt_off_pnlt_int --核销罚息利息
,t1.ld_wrt_off_pnlt_int as ld_wrt_off_pnlt_int --上日核销罚息利息
,t1.wrt_off_tm_point_pnlt_amt as wrt_off_tm_point_pnlt_amt --核销时点罚息金额
,replace(replace(t1.wrt_off_type_cd,chr(13),''),chr(10),'') as wrt_off_type_cd --核销类型代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_loan_acct_wrt_off_h t1    --贷款账户核销历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_loan_acct_wrt_off_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
