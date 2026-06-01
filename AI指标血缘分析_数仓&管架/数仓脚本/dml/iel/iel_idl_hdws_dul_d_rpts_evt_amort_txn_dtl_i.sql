: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_amort_txn_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_amort_txn_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.etl_dt as etl_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.amort_seq_num,chr(13),''),chr(10),'') as amort_seq_num
,t1.amort_dt as amort_dt
,t1.amort_amt as amort_amt
,replace(replace(t1.enter_acct_seq_num,chr(13),''),chr(10),'') as enter_acct_seq_num
,t1.posting_dt as posting_dt
,replace(replace(t1.chrg_id,chr(13),''),chr(10),'') as chrg_id
,replace(replace(t1.chrg_item_cd,chr(13),''),chr(10),'') as chrg_item_cd
from ${idl_schema}.hdws_dul_d_rpts_evt_amort_txn_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_amort_txn_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes