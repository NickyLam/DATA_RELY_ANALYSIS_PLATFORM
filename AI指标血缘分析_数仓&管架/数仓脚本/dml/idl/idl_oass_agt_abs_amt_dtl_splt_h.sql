/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_abs_amt_dtl_splt_h
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
alter table ${idl_schema}.oass_agt_abs_amt_dtl_splt_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_abs_amt_dtl_splt_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_abs_amt_dtl_splt_h (
etl_dt  --数据日期
,agt_id  --协议编号
,lp_id  --法人编号
,asset_amt_dtl_seq_num  --资产金额明细序号
,asset_bag_cont_dtl_seq_num  --资产包合同明细序号
,cust_id  --客户编号
,amt_type_cd  --金额类型代码
,paybl_bank_int_amt  --应付行内金额
,loan_surp_amt  --贷款剩余金额
,redem_paybl_cntpty_int  --赎回应付对手利息
,redem_surp_cntpty_int  --赎回剩余对手利息
,pkg_tran_in_suspd_crdt_acct_amt  --封包转入暂收款账户金额
,final_modif_dt  --最后修改日期
,tran_tm  --交易时间
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.asset_amt_dtl_seq_num,chr(13),''),chr(10),'') as asset_amt_dtl_seq_num --资产金额明细序号
,replace(replace(t1.asset_bag_cont_dtl_seq_num,chr(13),''),chr(10),'') as asset_bag_cont_dtl_seq_num --资产包合同明细序号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd --金额类型代码
,t1.paybl_bank_int_amt as paybl_bank_int_amt --应付行内金额
,t1.loan_surp_amt as loan_surp_amt --贷款剩余金额
,t1.redem_paybl_cntpty_int as redem_paybl_cntpty_int --赎回应付对手利息
,t1.redem_surp_cntpty_int as redem_surp_cntpty_int --赎回剩余对手利息
,t1.pkg_tran_in_suspd_crdt_acct_amt as pkg_tran_in_suspd_crdt_acct_amt --封包转入暂收款账户金额
,t1.final_modif_dt as final_modif_dt --最后修改日期
,t1.tran_tm as tran_tm --交易时间
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
from ${iml_schema}.agt_abs_amt_dtl_splt_h t1    --资产转让金额明细拆分历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_abs_amt_dtl_splt_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
