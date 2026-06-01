: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_mpcs_evt_dacct_txn_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_mpcs_evt_dacct_txn_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.dpst_acct_num,chr(13),''),chr(10),'') as dpst_acct_num
,replace(replace(t1.txn_dt,chr(13),''),chr(10),'') as txn_dt
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,replace(replace(t1.type1,chr(13),''),chr(10),'') as type1
,t1.txn_amt as txn_amt
,t1.acct_bal as acct_bal
,replace(replace(t1.operate,chr(13),''),chr(10),'') as operate
,replace(replace(t1.txn_org_id,chr(13),''),chr(10),'') as txn_org_id
,replace(replace(t1.txn_teller_id,chr(13),''),chr(10),'') as txn_teller_id
from ${idl_schema}.hdws_dul_d_mpcs_evt_dacct_txn_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_mpcs_evt_dacct_txn_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes