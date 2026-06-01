: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_self_chn_txn_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_self_chn_txn_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
biz_sys_evt_id
,global_chn_seq_num
,biz_seq_num
,evt_typ_cd
,txn_num
,txn_desc
,txn_resp_num
,txn_dt
,txn_start_tm
,txn_end_tm
,txn_ccy_cd
,txn_amt
,fee
,evt_status_cd
,chn_typ_cd
,txn_org_id
,txn_teller_id
,agt_id
,agt_id_name
,txn_occur_pla
,merch_id
,ovsea_flg
,crossb_flg
,cntrpty_acct_num_id
,cntrpty_acct_num
,cntrpty_merch_id
,bcs_txn_seq_num
,posting_dt
,posting_tm
,memo_cd
,memo
,pty_leg_typ_cd
,card_txn_typ_cd
,card_typ_cd
,data_src_cd
,etl_dt
,etl_task_name
,bnk_card_typ_cd
,bnk_card_liqdt_chn_cd
,txn_cty_par
,card_frame_ord_nbr
,txn_merch_typ_cd
,txn_merch_name
,merch_categ_num
,liqdt_amt
from ${idl_schema}.hdws_dul_d_rpts_evt_self_chn_txn_dtl 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_self_chn_txn_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes