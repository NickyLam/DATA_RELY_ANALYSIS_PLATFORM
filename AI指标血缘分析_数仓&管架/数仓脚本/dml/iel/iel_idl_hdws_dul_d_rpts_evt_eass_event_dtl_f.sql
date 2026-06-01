: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_eass_event_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_eass_event_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(evt_id,chr(10),''),chr(13),'') as evt_id
      ,replace(replace(global_chn_seq_num,chr(10),''),chr(13),'') as global_chn_seq_num
      ,replace(replace(prev_global_chn_seq_num,chr(10),''),chr(13),'') as prev_global_chn_seq_num
      ,replace(replace(prev_evt_id,chr(10),''),chr(13),'') as prev_evt_id
      ,replace(replace(evt_typ_cd,chr(10),''),chr(13),'') as evt_typ_cd
      ,replace(replace(menuid,chr(10),''),chr(13),'') as menuid
      ,replace(replace(txn_num,chr(10),''),chr(13),'') as txn_num
      ,txn_dt
      ,replace(replace(txn_tm,chr(10),''),chr(13),'') as txn_tm
      ,replace(replace(txn_ccy_cd,chr(10),''),chr(13),'') as txn_ccy_cd
      ,txn_amt
      ,acct_bal
      ,replace(replace(cost_typ_cd,chr(10),''),chr(13),'') as cost_typ_cd
      ,fee_amt
      ,replace(replace(evt_status_cd,chr(10),''),chr(13),'') as evt_status_cd
      ,replace(replace(evt_reverse_typ_cd,chr(10),''),chr(13),'') as evt_reverse_typ_cd
      ,replace(replace(agt_id,chr(10),''),chr(13),'') as agt_id
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(txn_org_id,chr(10),''),chr(13),'') as txn_org_id
      ,replace(replace(txn_teller_id,chr(10),''),chr(13),'') as txn_teller_id
      ,replace(replace(chk_teller_id,chr(10),''),chr(13),'') as chk_teller_id
      ,replace(replace(auth_teller_id,chr(10),''),chr(13),'') as auth_teller_id
      ,replace(replace(pty_mgr_id,chr(10),''),chr(13),'') as pty_mgr_id
      ,replace(replace(chn_typ_cd,chr(10),''),chr(13),'') as chn_typ_cd
      ,replace(replace(chn_id,chr(10),''),chr(13),'') as chn_id
      ,replace(replace(cntrpty_id,chr(10),''),chr(13),'') as cntrpty_id
      ,replace(replace(cntrpty_name,chr(10),''),chr(13),'') as cntrpty_name
      ,replace(replace(cntrpty_acct_openbk_num,chr(10),''),chr(13),'') as cntrpty_acct_openbk_num
      ,replace(replace(cntrpty_acct_openbk_name,chr(10),''),chr(13),'') as cntrpty_acct_openbk_name
      ,replace(replace(cntrpty_acct_num,chr(10),''),chr(13),'') as cntrpty_acct_num
      ,replace(replace(cntrpty_org_id,chr(10),''),chr(13),'') as cntrpty_org_id
      ,replace(replace(cntrpty_org_name,chr(10),''),chr(13),'') as cntrpty_org_name
      ,posting_dt
      ,replace(replace(posting_tm,chr(10),''),chr(13),'') as posting_tm
      ,replace(replace(posting_org_id,chr(10),''),chr(13),'') as posting_org_id
      ,replace(replace(posting_teller_id,chr(10),''),chr(13),'') as posting_teller_id
      ,replace(replace(posting_ccy_cd,chr(10),''),chr(13),'') as posting_ccy_cd
      ,posting_amt
      ,replace(replace(memo_cd,chr(10),''),chr(13),'') as memo_cd
      ,replace(replace(memo,chr(10),''),chr(13),'') as memo
      ,replace(replace(db_cr_dir_cd,chr(10),''),chr(13),'') as db_cr_dir_cd
      ,replace(replace(city_flg,chr(10),''),chr(13),'') as city_flg
      ,replace(replace(crossb_flg,chr(10),''),chr(13),'') as crossb_flg
      ,replace(replace(ovsea_flg,chr(10),''),chr(13),'') as ovsea_flg
      ,replace(replace(cash_tfr_flg,chr(10),''),chr(13),'') as cash_tfr_flg
      ,replace(replace(initor_typ_cd,chr(10),''),chr(13),'') as initor_typ_cd
      ,replace(replace(prim_vchr_type_cd,chr(10),''),chr(13),'') as prim_vchr_type_cd
      ,replace(replace(prim_vchr_num,chr(10),''),chr(13),'') as prim_vchr_num
      ,replace(replace(scd_vchr_type_cd,chr(10),''),chr(13),'') as scd_vchr_type_cd
      ,replace(replace(scd_vchr_num,chr(10),''),chr(13),'') as scd_vchr_num
      ,replace(replace(assoc_bcs_evt_id,chr(10),''),chr(13),'') as assoc_bcs_evt_id
      ,replace(replace(reverse_evt_id,chr(10),''),chr(13),'') as reverse_evt_id
      ,replace(replace(flow_id,chr(10),''),chr(13),'') as flow_id
      ,replace(replace(assoc_coll_id,chr(10),''),chr(13),'') as assoc_coll_id
      ,replace(replace(nostro_flg,chr(10),''),chr(13),'') as nostro_flg
      ,replace(replace(bal_dir_cd,chr(10),''),chr(13),'') as bal_dir_cd
      ,replace(replace(txn_med_name,chr(10),''),chr(13),'') as txn_med_name
      ,replace(replace(txn_med_id,chr(10),''),chr(13),'') as txn_med_id
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,etl_dt 
from idl.hdws_dul_d_rpts_evt_eass_event_dtl 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_eass_event_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes