: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agent_dedu_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agent_dedu_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.init_pty_acct_blng_org,chr(13),''),chr(10),'') as init_pty_acct_blng_org
,replace(replace(t1.init_cust_nbr,chr(13),''),chr(10),'') as init_cust_nbr
,replace(replace(t1.init_pty_name,chr(13),''),chr(10),'') as init_pty_name
,replace(replace(t1.init_pty_acct_num,chr(13),''),chr(10),'') as init_pty_acct_num
,replace(replace(t1.rcv_pty_acct_blng_org,chr(13),''),chr(10),'') as rcv_pty_acct_blng_org
,replace(replace(t1.rcv_cust_nbr,chr(13),''),chr(10),'') as rcv_cust_nbr
,replace(replace(t1.rcv_pty_name,chr(13),''),chr(10),'') as rcv_pty_name
,replace(replace(t1.rcv_pty_acct_num,chr(13),''),chr(10),'') as rcv_pty_acct_num
,replace(replace(t1.txn_ccy_cd,chr(13),''),chr(10),'') as txn_ccy_cd
,t1.txn_amt as txn_amt
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.txn_typ,chr(13),''),chr(10),'') as txn_typ
from ${idl_schema}.hdws_dul_d_ccrm_agent_dedu_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agent_dedu_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes