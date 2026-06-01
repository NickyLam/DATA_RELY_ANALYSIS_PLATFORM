: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_dacct_txn_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_dacct_txn_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(evt_id,chr(10),''),chr(13),'') as evt_id
      ,replace(replace(global_chn_seq_num,chr(10),''),chr(13),'') as global_chn_seq_num
      ,replace(replace(trx_seq,chr(10),''),chr(13),'') as trx_seq
      ,txn_dt
      ,replace(replace(chn_typ_cd,chr(10),''),chr(13),'') as chn_typ_cd
      ,replace(replace(acct_org_id,chr(10),''),chr(13),'') as acct_org_id
      ,replace(replace(dpst_acct_id,chr(10),''),chr(13),'') as dpst_acct_id
      ,replace(replace(dpst_acct_num,chr(10),''),chr(13),'') as dpst_acct_num
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(txn_vchr_typ,chr(10),''),chr(13),'') as txn_vchr_typ
      ,replace(replace(txn_vchr_id,chr(10),''),chr(13),'') as txn_vchr_id
      ,replace(replace(txn_num,chr(10),''),chr(13),'') as txn_num
      ,replace(replace(txn_desc,chr(10),''),chr(13),'') as txn_desc
      ,replace(replace(db_cr_flg,chr(10),''),chr(13),'') as db_cr_flg
      ,replace(replace(txn_ccy_cd,chr(10),''),chr(13),'') as txn_ccy_cd
      ,txn_amt
      ,acct_bal
      ,replace(replace(txn_org_id,chr(10),''),chr(13),'') as txn_org_id
      ,replace(replace(cntrpty_acct_num,chr(10),''),chr(13),'') as cntrpty_acct_num
      ,replace(replace(cntrpty_sub_acct_num,chr(10),''),chr(13),'') as cntrpty_sub_acct_num
      ,replace(replace(cntrpty_acct_name,chr(10),''),chr(13),'') as cntrpty_acct_name
      ,replace(replace(txn_teller_id,chr(10),''),chr(13),'') as txn_teller_id
      ,replace(replace(chk_teller_id,chr(10),''),chr(13),'') as chk_teller_id
      ,replace(replace(strike_off_flg,chr(10),''),chr(13),'') as strike_off_flg
      ,replace(replace(reve_flg,chr(10),''),chr(13),'') as reve_flg
      ,replace(replace(memo_cntt,chr(10),''),chr(13),'') as memo_cntt
      ,etl_dt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,last_update_dt
      ,replace(replace(etl_task_name,chr(10),''),chr(13),'') as etl_task_name
      ,replace(replace(evt_typ_cd,chr(10),''),chr(13),'') as evt_typ_cd
      ,replace(replace(txn_tm,chr(10),''),chr(13),'') as txn_tm
      ,replace(replace(cntrpty_acct_openbk_num,chr(10),''),chr(13),'') as cntrpty_acct_openbk_num
      ,replace(replace(cntrpty_acct_openbk_name,chr(10),''),chr(13),'') as cntrpty_acct_openbk_name
      ,replace(replace(auth_teller_id,chr(10),''),chr(13),'') as auth_teller_id
      ,replace(replace(cash_tfr_flg,chr(10),''),chr(13),'') as cash_tfr_flg
      ,replace(replace(unexp_draw_flg,chr(10),''),chr(13),'') as unexp_draw_flg
      ,replace(replace(memo_cd,chr(10),''),chr(13),'') as memo_cd 
from idl.hdws_dul_d_rpts_evt_dacct_txn_dtl 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_dacct_txn_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes