: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_dacct_txn_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_dacct_txn_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.global_chn_seq_num,chr(13),''),chr(10),'') as global_chn_seq_num
,replace(replace(t1.trx_seq,chr(13),''),chr(10),'') as trx_seq
,t1.txn_dt as txn_dt
,replace(replace(t1.chn_typ_cd,chr(13),''),chr(10),'') as chn_typ_cd
,replace(replace(t1.acct_org_id,chr(13),''),chr(10),'') as acct_org_id
,replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id
,replace(replace(t1.dpst_acct_num,chr(13),''),chr(10),'') as dpst_acct_num
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.txn_vchr_typ,chr(13),''),chr(10),'') as txn_vchr_typ
,replace(replace(t1.txn_vchr_id,chr(13),''),chr(10),'') as txn_vchr_id
,replace(replace(t1.txn_num,chr(13),''),chr(10),'') as txn_num
,replace(replace(t1.txn_desc,chr(13),''),chr(10),'') as txn_desc
,replace(replace(t1.db_cr_flg,chr(13),''),chr(10),'') as db_cr_flg
,replace(replace(t1.txn_ccy_cd,chr(13),''),chr(10),'') as txn_ccy_cd
,t1.txn_amt as txn_amt
,t1.acct_bal as acct_bal
,replace(replace(t1.txn_org_id,chr(13),''),chr(10),'') as txn_org_id
,replace(replace(t1.cntrpty_acct_num,chr(13),''),chr(10),'') as cntrpty_acct_num
,replace(replace(t1.cntrpty_sub_acct_num,chr(13),''),chr(10),'') as cntrpty_sub_acct_num
,replace(replace(t1.cntrpty_acct_name,chr(13),''),chr(10),'') as cntrpty_acct_name
,replace(replace(t1.txn_teller_id,chr(13),''),chr(10),'') as txn_teller_id
,replace(replace(t1.chk_teller_id,chr(13),''),chr(10),'') as chk_teller_id
,replace(replace(t1.strike_off_flg,chr(13),''),chr(10),'') as strike_off_flg
,replace(replace(t1.reve_flg,chr(13),''),chr(10),'') as reve_flg
,replace(replace(t1.memo_cntt,chr(13),''),chr(10),'') as memo_cntt
,t1.etl_dt as etl_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.last_update_dt as last_update_dt
,NVL2(t1.data_src_cd,'EVT_DACCT_TXN_DTL'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'EVT_DACCT_TXN_DTL') as etl_task_name 
,replace(replace(t1.txn_tm,chr(13),''),chr(10),'') as txn_tm
,replace(replace(t1.cntrpty_acct_openbk_num,chr(13),''),chr(10),'') as cntrpty_acct_openbk_num
,replace(replace(t1.cntrpty_acct_openbk_name,chr(13),''),chr(10),'') as cntrpty_acct_openbk_name
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.cash_tfr_flg,chr(13),''),chr(10),'') as cash_tfr_flg
,replace(replace(t1.unexp_draw_flg,chr(13),''),chr(10),'') as unexp_draw_flg
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t1.evt_typ_cd,chr(13),''),chr(10),'') as evt_typ_cd
,replace(replace(t1.cntrpty_subj_id,chr(13),''),chr(10),'') as cntrpty_subj_id
,replace(replace(t1.cntrpty_subj_name,chr(13),''),chr(10),'') as cntrpty_subj_name
,replace(replace(t1.tell_seq_num,chr(13),''),chr(10),'') as tell_seq_num
from ${idl_schema}.hdws_iml_evt_dacct_txn_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd') ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_dacct_txn_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes