: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_e_chn_evt_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_e_chn_evt_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       etl_dt
      ,replace(replace(evt_id,chr(10),''),chr(13),'') as evt_id
      ,replace(replace(global_chn_seq_num,chr(10),''),chr(13),'') as global_chn_seq_num
      ,replace(replace(bcs_txn_seq_num,chr(10),''),chr(13),'') as bcs_txn_seq_num
      ,replace(replace(prev_evt_id,chr(10),''),chr(13),'') as prev_evt_id
      ,replace(replace(assoc_tim_task_id,chr(10),''),chr(13),'') as assoc_tim_task_id
      ,replace(replace(chn_typ_cd,chr(10),''),chr(13),'') as chn_typ_cd
      ,txn_dt
      ,bcs_txn_dt
      ,replace(replace(txn_num,chr(10),''),chr(13),'') as txn_num
      ,replace(replace(txn_status_cd,chr(10),''),chr(13),'') as txn_status_cd
      ,replace(replace(txn_resp_num,chr(10),''),chr(13),'') as txn_resp_num
      ,replace(replace(txn_acct_id,chr(10),''),chr(13),'') as txn_acct_id
      ,replace(replace(txn_acct_name,chr(10),''),chr(13),'') as txn_acct_name
      ,txn_amt
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,replace(replace(user_id,chr(10),''),chr(13),'') as user_id
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(termn_ip_loc,chr(10),''),chr(13),'') as termn_ip_loc
      ,fee
      ,replace(replace(termn_mac_loc,chr(10),''),chr(13),'') as termn_mac_loc
      ,replace(replace(termn_equip_model,chr(10),''),chr(13),'') as termn_equip_model
      ,replace(replace(termn_equip_id,chr(10),''),chr(13),'') as termn_equip_id
      ,replace(replace(cntrpty_acct_id,chr(10),''),chr(13),'') as cntrpty_acct_id
      ,replace(replace(cntrpty_acct_name,chr(10),''),chr(13),'') as cntrpty_acct_name
      ,replace(replace(cntrpty_acct_openbk_num,chr(10),''),chr(13),'') as cntrpty_acct_openbk_num
      ,replace(replace(cntrpty_acct_open_bk_name,chr(10),''),chr(13),'') as cntrpty_acct_open_bk_name
      ,replace(replace(cntrpty_acct_prov_cd,chr(10),''),chr(13),'') as cntrpty_acct_prov_cd
      ,replace(replace(cntrpty_acct_city_cd,chr(10),''),chr(13),'') as cntrpty_acct_city_cd
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(memo_cd,chr(10),''),chr(13),'') as memo_cd
      ,replace(replace(memo,chr(10),''),chr(13),'') as memo
      ,replace(replace(bat_num,chr(10),''),chr(13),'') as bat_num
      ,replace(replace(txn_org_id,chr(10),''),chr(13),'') as txn_org_id 
from idl.hdws_dul_d_rpts_evt_e_chn_evt_dtl 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_e_chn_evt_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes