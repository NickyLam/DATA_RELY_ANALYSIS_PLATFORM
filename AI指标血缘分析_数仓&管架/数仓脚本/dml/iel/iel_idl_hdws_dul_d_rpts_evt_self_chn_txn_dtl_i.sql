: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_self_chn_txn_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_self_chn_txn_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.biz_sys_evt_id,chr(13),''),chr(10),'') as biz_sys_evt_id
,replace(replace(t1.global_chn_seq_num,chr(13),''),chr(10),'') as global_chn_seq_num
,replace(replace(t1.biz_seq_num,chr(13),''),chr(10),'') as biz_seq_num
,replace(replace(t1.evt_typ_cd,chr(13),''),chr(10),'') as evt_typ_cd
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,replace(replace(t1.txn_desc,chr(13),''),chr(10),'') as txn_desc
,replace(replace(t1.txn_resp_num,chr(13),''),chr(10),'') as txn_resp_num
,t1.txn_dt as txn_dt
,replace(replace(t1.txn_start_tm,chr(13),''),chr(10),'') as txn_start_tm
,replace(replace(t1.txn_end_tm,chr(13),''),chr(10),'') as txn_end_tm
,replace(replace(t1.txn_ccy_cd,chr(13),''),chr(10),'') as txn_ccy_cd
,t1.txn_amt as txn_amt
,t1.fee as fee
,replace(replace(t1.evt_status_cd,chr(13),''),chr(10),'') as evt_status_cd
,replace(replace(t1.chn_typ_cd,chr(13),''),chr(10),'') as chn_typ_cd
,replace(replace(t1.txn_org_id,chr(13),''),chr(10),'') as txn_org_id
,replace(replace(t1.txn_teller_id,chr(13),''),chr(10),'') as txn_teller_id
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.agt_id_name,chr(13),''),chr(10),'') as agt_id_name
,replace(replace(t1.txn_occur_pla,chr(13),''),chr(10),'') as txn_occur_pla
,replace(replace(t1.merch_id,chr(13),''),chr(10),'') as merch_id
,replace(replace(t1.ovsea_flg,chr(13),''),chr(10),'') as ovsea_flg
,replace(replace(t1.crossb_flg,chr(13),''),chr(10),'') as crossb_flg
,replace(replace(t1.cntrpty_acct_num_id,chr(13),''),chr(10),'') as cntrpty_acct_num_id
,replace(replace(t1.cntrpty_acct_num,chr(13),''),chr(10),'') as cntrpty_acct_num
,replace(replace(t1.cntrpty_merch_id,chr(13),''),chr(10),'') as cntrpty_merch_id
,replace(replace(t1.bcs_txn_seq_num,chr(13),''),chr(10),'') as bcs_txn_seq_num
,t1.posting_dt as posting_dt
,replace(replace(t1.posting_tm,chr(13),''),chr(10),'') as posting_tm
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.pty_leg_typ_cd,chr(13),''),chr(10),'') as pty_leg_typ_cd
,replace(replace(t1.card_txn_typ_cd,chr(13),''),chr(10),'') as card_txn_typ_cd
,replace(replace(t1.card_typ_cd,chr(13),''),chr(10),'') as card_typ_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,t1.etl_task_name as etl_task_name
,replace(replace(t1.bnk_card_typ_cd,chr(13),''),chr(10),'') as bnk_card_typ_cd
,replace(replace(t1.bnk_card_liqdt_chn_cd,chr(13),''),chr(10),'') as bnk_card_liqdt_chn_cd
,replace(replace(t1.txn_cty_par,chr(13),''),chr(10),'') as txn_cty_par
,replace(replace(t1.card_frame_ord_nbr,chr(13),''),chr(10),'') as card_frame_ord_nbr
,replace(replace(t1.txn_merch_typ_cd,chr(13),''),chr(10),'') as txn_merch_typ_cd
,replace(replace(t1.txn_merch_name,chr(13),''),chr(10),'') as txn_merch_name
,replace(replace(t1.merch_categ_num,chr(13),''),chr(10),'') as merch_categ_num
,t1.liqdt_amt as liqdt_amt
from ${idl_schema}.hdws_dul_d_rpts_evt_self_chn_txn_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_self_chn_txn_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes