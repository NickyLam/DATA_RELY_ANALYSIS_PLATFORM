/*
Purpose:    共性加工层
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20240412 icl_cmm_inter_bus_expns_dtl
CreateDate: 20200519
Logs:       

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_inter_bus_expns_dtl drop partition p_${retain_day};
create table ${icl_schema}.cmm_inter_bus_expns_dtl_bak20240816 as select * from ${icl_schema}.cmm_inter_bus_expns_dtl where job_cd ='1';
create table ${icl_schema}.cmm_inter_bus_inco_dtl_bak20240816 as select * from ${icl_schema}.cmm_inter_bus_inco_dtl where job_cd in ('1','2');


whenever sqlerror continue none ;
merge into ${icl_schema}.cmm_inter_bus_expns_dtl t1 
using iml.evt_inter_income_bus_tran_dtl t2
   on (t2.sob_id ='2'
  and t2.bus_sys_id=t1.sorc_sys_cd
  and t2.fin_dt=t1.acct_dt
  and t2.doc_id=t1.charge_doc_num
  and t2.tran_flow_num=t1.tran_flow_num
  and t2.etl_dt=t1.etl_dt)
when matched then update set t1.tran_amt=t2.ths_tm_amort_amt
where t1.job_cd ='1';
commit;


whenever sqlerror continue none ;
merge into ${icl_schema}.cmm_inter_bus_inco_dtl t1 
using iml.evt_inter_income_bus_tran_dtl t2
   on (t2.sob_id ='2'
  and t2.bus_sys_id=t1.sorc_sys_cd
  and t2.fin_dt=t1.acct_dt
  and t2.doc_id=t1.charge_doc_num
  and t2.tran_flow_num=t1.tran_flow_num
  and t2.etl_dt=t1.etl_dt)
when matched then update set t1.tran_amt=t2.ths_tm_amort_amt
where t1.job_cd in ('1','2');
commit;


