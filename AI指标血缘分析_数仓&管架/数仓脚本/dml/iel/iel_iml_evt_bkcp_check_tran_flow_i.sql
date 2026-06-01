: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_bkcp_check_tran_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_bkcp_check_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.check_entry_flow_num,chr(13),''),chr(10),'') as check_entry_flow_num 
,t1.check_entry_dt as check_entry_dt 
,replace(replace(t1.acct_bill_id,chr(13),''),chr(10),'') as acct_bill_id 
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id 
,replace(replace(t1.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id 
,t1.acct_bal as acct_bal 
,replace(replace(t1.brch_id,chr(13),''),chr(10),'') as brch_id 
,replace(replace(t1.subrch_id,chr(13),''),chr(10),'') as subrch_id 
,replace(replace(t1.brac_id,chr(13),''),chr(10),'') as brac_id 
,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd 
,t1.tran_dt as tran_dt 
,t1.tran_amt as tran_amt 
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id 
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name 
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo 
,t1.check_dt as check_dt 
,replace(replace(t1.check_status_cd,chr(13),''),chr(10),'') as check_status_cd 
from ${iml_schema}.evt_bkcp_check_tran_flow t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bkcp_check_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes