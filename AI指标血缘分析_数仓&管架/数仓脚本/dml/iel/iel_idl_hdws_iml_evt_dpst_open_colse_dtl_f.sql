: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_evt_dpst_open_colse_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_evt_dpst_open_colse_dtlf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.trx_seq
,t.global_chn_seq_num
,t.txn_dt
,t.proc_status_cd
,t.chn_typ_cd
,t.acct_org_id
,t.txn_org_id
,t.dpst_acct_id
,t.dpst_acct_num
,t.dacct_name
,t.open_colse_flg
,t.reve_flg
,t.ccy_cd
,t.txn_amt
,t.cash_remit_ind_cd
,t.dps_type_cd
,t.peri_typ_cd
,t.open_vchr_typ_cd
,t.open_vchr_id
,t.etl_dt
,t.data_src_cd
,t.biz_seq_num
from idl.hdws_iml_evt_dpst_open_colse_dtl t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_evt_dpst_open_colse_dtlf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes