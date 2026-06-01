/*
Purpose:    共性加工层-代理代销交易明细
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20200930 icl_cmm_agent_consmt_tran_dtl
CreateDate: 20200724
Logs:   
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;


whenever sqlerror continue none ;
create table ${icl_schema}.cmm_agent_consmt_tran_dtl_bak20240715
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_agent_consmt_tran_dtl where 1=1;



whenever sqlerror exit sql.sqlcode;
merge into icl.cmm_agent_consmt_tran_dtl t1 
using iml.evt_comb_prod_tran_cfm_evt t2
   on (t1.prod_id = t2.finc_prod_id
  and t1.ta_cfm_flow_num = t2.ta_cfm_flow_num
  and t2.cfm_dt = t1.etl_dt)
  when matched then update set t1.comb_sell_flag ='1',t1.comb_prod_id =t2.comb_prod_id
  where 1=1;
  
