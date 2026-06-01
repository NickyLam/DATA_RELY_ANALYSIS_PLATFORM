: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_lpss_event_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_lpss_event_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.biz_sys_evt_id,chr(13),''),chr(10),'') as biz_sys_evt_id
,replace(replace(t1.global_chn_seq_num,chr(13),''),chr(10),'') as global_chn_seq_num
,replace(replace(t1.prev_global_chn_seq_num,chr(13),''),chr(10),'') as prev_global_chn_seq_num
,replace(replace(t1.prev_evt_id,chr(13),''),chr(10),'') as prev_evt_id
,replace(replace(t1.evt_typ_cd,chr(13),''),chr(10),'') as evt_typ_cd
,replace(replace(t1.menuid,chr(13),''),chr(10),'') as menuid
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,replace(replace(t1.txn_desc,chr(13),''),chr(10),'') as txn_desc
,t1.txn_dt as txn_dt
,replace(replace(t1.txn_tm,chr(13),''),chr(10),'') as txn_tm
,replace(replace(t1.txn_ccy_cd,chr(13),''),chr(10),'') as txn_ccy_cd
,t1.txn_amt as txn_amt
,t1.acct_bal as acct_bal
,replace(replace(t1.cost_typ_cd,chr(13),''),chr(10),'') as cost_typ_cd
,t1.fee_amt as fee_amt
,replace(replace(t1.evt_status_cd,chr(13),''),chr(10),'') as evt_status_cd
,replace(replace(t1.evt_reverse_typ_cd,chr(13),''),chr(10),'') as evt_reverse_typ_cd
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.agt_id_name,chr(13),''),chr(10),'') as agt_id_name
,replace(replace(t1.agt_blng_acct_num,chr(13),''),chr(10),'') as agt_blng_acct_num
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.txn_org_id,chr(13),''),chr(10),'') as txn_org_id
,replace(replace(t1.txn_teller_id,chr(13),''),chr(10),'') as txn_teller_id
,replace(replace(t1.chk_teller_id,chr(13),''),chr(10),'') as chk_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.chn_typ_cd,chr(13),''),chr(10),'') as chn_typ_cd
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.pay_chnl_typ_cd,chr(13),''),chr(10),'') as pay_chnl_typ_cd
,replace(replace(t1.cntrpty_id,chr(13),''),chr(10),'') as cntrpty_id
,replace(replace(t1.cntrpty_name,chr(13),''),chr(10),'') as cntrpty_name
,replace(replace(t1.cntrpty_acct_openbk_num,chr(13),''),chr(10),'') as cntrpty_acct_openbk_num
,replace(replace(t1.cntrpty_acct_openbk_name,chr(13),''),chr(10),'') as cntrpty_acct_openbk_name
,replace(replace(t1.cntrpty_acct_num_id,chr(13),''),chr(10),'') as cntrpty_acct_num_id
,replace(replace(t1.cntrpty_acct_num,chr(13),''),chr(10),'') as cntrpty_acct_num
,replace(replace(t1.cntrpty_org_id,chr(13),''),chr(10),'') as cntrpty_org_id
,replace(replace(t1.cntrpty_org_name,chr(13),''),chr(10),'') as cntrpty_org_name
,t1.posting_dt as posting_dt
,replace(replace(t1.posting_tm,chr(13),''),chr(10),'') as posting_tm
,replace(replace(t1.posting_org_id,chr(13),''),chr(10),'') as posting_org_id
,replace(replace(t1.posting_teller_id,chr(13),''),chr(10),'') as posting_teller_id
,replace(replace(t1.posting_ccy_cd,chr(13),''),chr(10),'') as posting_ccy_cd
,t1.posting_amt as posting_amt
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.db_cr_dir_cd,chr(13),''),chr(10),'') as db_cr_dir_cd
,replace(replace(t1.city_flg,chr(13),''),chr(10),'') as city_flg
,replace(replace(t1.crossb_flg,chr(13),''),chr(10),'') as crossb_flg
,replace(replace(t1.ovsea_flg,chr(13),''),chr(10),'') as ovsea_flg
,replace(replace(t1.cash_tfr_flg,chr(13),''),chr(10),'') as cash_tfr_flg
,replace(replace(t1.initor_typ_cd,chr(13),''),chr(10),'') as initor_typ_cd
,replace(replace(t1.prim_vchr_type_cd,chr(13),''),chr(10),'') as prim_vchr_type_cd
,replace(replace(t1.prim_vchr_num,chr(13),''),chr(10),'') as prim_vchr_num
,replace(replace(t1.scd_vchr_type_cd,chr(13),''),chr(10),'') as scd_vchr_type_cd
,replace(replace(t1.scd_vchr_num,chr(13),''),chr(10),'') as scd_vchr_num
,replace(replace(t1.assoc_bcs_evt_id,chr(13),''),chr(10),'') as assoc_bcs_evt_id
,replace(replace(t1.reverse_evt_id,chr(13),''),chr(10),'') as reverse_evt_id
,replace(replace(t1.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t1.assoc_coll_id,chr(13),''),chr(10),'') as assoc_coll_id
,replace(replace(t1.nostro_flg,chr(13),''),chr(10),'') as nostro_flg
,replace(replace(t1.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t1.bal_typ_cd,chr(13),''),chr(10),'') as bal_typ_cd
,replace(replace(t1.txn_med_name,chr(13),''),chr(10),'') as txn_med_name
,replace(replace(t1.txn_med_id,chr(13),''),chr(10),'') as txn_med_id
,replace(replace(t1.biz_typ_cd,chr(13),''),chr(10),'') as biz_typ_cd
,replace(replace(t1.biz_cate_cd,chr(13),''),chr(10),'') as biz_cate_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'EVT_LPSS_EVENT_DTL'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'EVT_LPSS_EVENT_DTL') as etl_task_name 
,t1.etl_dt as etl_dt
,replace(replace(t1.agt_blng_acct_num2,chr(13),''),chr(10),'') as agt_blng_acct_num2
,replace(replace(t1.agt_blng_acct_num3,chr(13),''),chr(10),'') as agt_blng_acct_num3
,replace(replace(t1.biz_seq_num,chr(13),''),chr(10),'') as biz_seq_num
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.ghb_init_flg,chr(13),''),chr(10),'') as ghb_init_flg
,replace(replace(t1.old_vchr_num,chr(13),''),chr(10),'') as old_vchr_num
,replace(replace(t1.tell_seq_num,chr(13),''),chr(10),'') as tell_seq_num
,replace(replace(t1.txn_deal_status_cd,chr(13),''),chr(10),'') as txn_deal_status_cd
from ${idl_schema}.hdws_iml_evt_lpss_event_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd') ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_lpss_event_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes