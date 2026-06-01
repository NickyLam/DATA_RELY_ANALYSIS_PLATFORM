: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_dacct_txn_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_dacct_txn_dtlf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.evt_id
,t.global_chn_seq_num
,t.trx_seq
,t.txn_dt
,t.txn_tm
,t.evt_typ_cd
,t.chn_typ_cd
,t.acct_org_id
,t.dpst_acct_id
,t.dpst_acct_num
,t.pty_id
,t.txn_vchr_typ
,t.txn_vchr_id
,t.txn_num
,t.txn_desc
,t.db_cr_flg
,t.txn_ccy_cd
,t.txn_amt
,t.acct_bal
,t.txn_org_id
,t.cntrpty_acct_num
,t.cntrpty_sub_acct_num
,t.cntrpty_acct_name
,t.cntrpty_acct_openbk_num
,t.cntrpty_acct_openbk_name
,t.cntrpty_subj_id
,t.cntrpty_subj_name
,t.txn_teller_id
,t.chk_teller_id
,t.auth_teller_id
,t.tell_seq_num
,t.strike_off_flg
,t.reve_flg
,t.cash_tfr_flg
,t.unexp_draw_flg
,t.memo_cd
,t.memo_cntt
,t.etl_dt
,t.data_src_cd
from idl.hdws_iml_evt_dacct_txn_dtl t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_dacct_txn_dtlf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes