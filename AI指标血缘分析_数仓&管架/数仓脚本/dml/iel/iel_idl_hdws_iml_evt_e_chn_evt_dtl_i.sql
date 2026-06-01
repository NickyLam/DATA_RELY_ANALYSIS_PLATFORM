: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_e_chn_evt_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_e_chn_evt_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.global_chn_seq_num,chr(13),''),chr(10),'') as global_chn_seq_num
,replace(replace(t1.bcs_txn_seq_num,chr(13),''),chr(10),'') as bcs_txn_seq_num
,replace(replace(t1.prev_evt_id,chr(13),''),chr(10),'') as prev_evt_id
,replace(replace(t1.assoc_tim_task_id,chr(13),''),chr(10),'') as assoc_tim_task_id
,replace(replace(t1.chn_typ_cd,chr(13),''),chr(10),'') as chn_typ_cd
,t1.txn_dt as txn_dt
,t1.bcs_txn_dt as bcs_txn_dt
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,replace(replace(t1.txn_status_cd,chr(13),''),chr(10),'') as txn_status_cd
,replace(replace(t1.txn_resp_num,chr(13),''),chr(10),'') as txn_resp_num
,replace(replace(t1.txn_acct_id,chr(13),''),chr(10),'') as txn_acct_id
,replace(replace(t1.txn_acct_name,chr(13),''),chr(10),'') as txn_acct_name
,t1.txn_amt as txn_amt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.termn_ip_loc,chr(13),''),chr(10),'') as termn_ip_loc
,t1.fee as fee
,replace(replace(t1.termn_mac_loc,chr(13),''),chr(10),'') as termn_mac_loc
,replace(replace(t1.termn_equip_model,chr(13),''),chr(10),'') as termn_equip_model
,replace(replace(t1.termn_equip_id,chr(13),''),chr(10),'') as termn_equip_id
,replace(replace(t1.cntrpty_acct_id,chr(13),''),chr(10),'') as cntrpty_acct_id
,replace(replace(t1.cntrpty_acct_name,chr(13),''),chr(10),'') as cntrpty_acct_name
,replace(replace(t1.cntrpty_acct_openbk_num,chr(13),''),chr(10),'') as cntrpty_acct_openbk_num
,replace(replace(t1.cntrpty_acct_open_bk_name,chr(13),''),chr(10),'') as cntrpty_acct_open_bk_name
,replace(replace(t1.cntrpty_acct_prov_cd,chr(13),''),chr(10),'') as cntrpty_acct_prov_cd
,replace(replace(t1.cntrpty_acct_city_cd,chr(13),''),chr(10),'') as cntrpty_acct_city_cd
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,t1.last_update_dt as last_update_dt
,NVL2(t1.data_src_cd,'EVT_E_CHN_EVT_DTL'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'EVT_E_CHN_EVT_DTL') as etl_task_name
,replace(replace(t1.bat_num,chr(13),''),chr(10),'') as bat_num
,replace(replace(t1.txn_org_id,chr(13),''),chr(10),'') as txn_org_id
,replace(replace(t1.camp_emp_id,chr(13),''),chr(10),'') as camp_emp_id
,replace(replace(t1.txn_tm,chr(13),''),chr(10),'') as txn_tm
,replace(replace(t1.trx_seq,chr(13),''),chr(10),'') as trx_seq
from ${idl_schema}.hdws_iml_evt_e_chn_evt_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_e_chn_evt_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes