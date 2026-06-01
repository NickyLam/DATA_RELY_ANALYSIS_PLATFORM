: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_gzfh_evt_bil_acct_txn_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_gzfh_evt_bil_acct_txn_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(evt_id,chr(10),''),chr(13),'') as evt_id
      ,replace(replace(global_chn_seq_num,chr(10),''),chr(13),'') as global_chn_seq_num
      ,replace(replace(biz_seq_num,chr(10),''),chr(13),'') as biz_seq_num
      ,replace(replace(evt_typ_cd,chr(10),''),chr(13),'') as evt_typ_cd
      ,replace(replace(evt_status_cd,chr(10),''),chr(13),'') as evt_status_cd
      ,replace(replace(chn_typ_cd,chr(10),''),chr(13),'') as chn_typ_cd
      ,replace(replace(txn_num,chr(10),''),chr(13),'') as txn_num
      ,replace(replace(txn_desc,chr(10),''),chr(13),'') as txn_desc
      ,txn_dt
      ,replace(replace(txn_tm,chr(10),''),chr(13),'') as txn_tm
      ,replace(replace(txn_ccy_cd,chr(10),''),chr(13),'') as txn_ccy_cd
      ,txn_amt
      ,fee
      ,posting_dt
      ,replace(replace(posting_tm,chr(10),''),chr(13),'') as posting_tm
      ,replace(replace(posting_org_id,chr(10),''),chr(13),'') as posting_org_id
      ,replace(replace(posting_teller_id,chr(10),''),chr(13),'') as posting_teller_id
      ,replace(replace(posting_ccy_cd,chr(10),''),chr(13),'') as posting_ccy_cd
      ,posting_amt
      ,replace(replace(bil_id,chr(10),''),chr(13),'') as bil_id
      ,replace(replace(bil_num,chr(10),''),chr(13),'') as bil_num
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(txn_org_id,chr(10),''),chr(13),'') as txn_org_id
      ,replace(replace(txn_teller_id,chr(10),''),chr(13),'') as txn_teller_id
      ,replace(replace(pty_mgr_id,chr(10),''),chr(13),'') as pty_mgr_id
      ,replace(replace(crossb_flg,chr(10),''),chr(13),'') as crossb_flg
      ,replace(replace(cntrpty_acct_num,chr(10),''),chr(13),'') as cntrpty_acct_num
      ,replace(replace(cntrpty_name,chr(10),''),chr(13),'') as cntrpty_name
      ,replace(replace(cntrpty_cust_nbr,chr(10),''),chr(13),'') as cntrpty_cust_nbr
      ,replace(replace(cntrpty_acct_openbk_num,chr(10),''),chr(13),'') as cntrpty_acct_openbk_num
      ,replace(replace(cntrpty_acct_openbk_name,chr(10),''),chr(13),'') as cntrpty_acct_openbk_name
      ,replace(replace(memo_cd,chr(10),''),chr(13),'') as memo_cd
      ,replace(replace(memo,chr(10),''),chr(13),'') as memo
      ,replace(replace(etl_task_name,chr(10),''),chr(13),'') as etl_task_name 
from idl.hdws_dul_d_gzfh_evt_bil_acct_txn_dtl 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_gzfh_evt_bil_acct_txn_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes