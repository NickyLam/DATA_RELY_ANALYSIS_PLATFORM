: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_event_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_event_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.txn_dt as txn_dt
,replace(replace(t1.txn_tm,chr(13),''),chr(10),'') as txn_tm
,replace(replace(t1.txn_org_id,chr(13),''),chr(10),'') as txn_org_id
,replace(replace(t1.txn_teller_id,chr(13),''),chr(10),'') as txn_teller_id
,replace(replace(t1.txn_acct_id,chr(13),''),chr(10),'') as txn_acct_id
,replace(replace(t1.txn_acct_name,chr(13),''),chr(10),'') as txn_acct_name
,replace(replace(t1.cntrpty_acct_num,chr(13),''),chr(10),'') as cntrpty_acct_num
,replace(replace(t1.cntrpty_name,chr(13),''),chr(10),'') as cntrpty_name
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,replace(replace(t1.evt_typ_cd,chr(13),''),chr(10),'') as evt_typ_cd
,replace(replace(t1.menuid,chr(13),''),chr(10),'') as menuid
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.txn_ccy_cd,chr(13),''),chr(10),'') as txn_ccy_cd
,t1.txn_amt as txn_amt
,replace(replace(t1.global_chn_seq_num,chr(13),''),chr(10),'') as global_chn_seq_num
,t1.etl_dt as etl_dt
,replace(replace(t1.combinationseqno,chr(13),''),chr(10),'') as combinationseqno
from ${idl_schema}.hdws_iml_evt_event_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_event_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes