: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_hdw_evt_dpst_open_colse_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_hdw_evt_dpst_open_colse_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.trx_seq,chr(13),''),chr(10),'') as trx_seq
,replace(replace(t1.global_chn_seq_num,chr(13),''),chr(10),'') as global_chn_seq_num
,t1.txn_dt as txn_dt
,replace(replace(t1.proc_status_cd,chr(13),''),chr(10),'') as proc_status_cd
,replace(replace(t1.chn_typ_cd,chr(13),''),chr(10),'') as chn_typ_cd
,replace(replace(t1.acct_org_id,chr(13),''),chr(10),'') as acct_org_id
,replace(replace(t1.txn_org_id,chr(13),''),chr(10),'') as txn_org_id
,replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id
,replace(replace(t1.dpst_acct_num,chr(13),''),chr(10),'') as dpst_acct_num
,replace(replace(t1.dacct_name,chr(13),''),chr(10),'') as dacct_name
,replace(replace(t1.open_colse_flg,chr(13),''),chr(10),'') as open_colse_flg
,replace(replace(t1.reve_flg,chr(13),''),chr(10),'') as reve_flg
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.txn_amt as txn_amt
,replace(replace(t1.cash_remit_ind_cd,chr(13),''),chr(10),'') as cash_remit_ind_cd
,replace(replace(t1.dps_type_cd,chr(13),''),chr(10),'') as dps_type_cd
,replace(replace(t1.peri_typ_cd,chr(13),''),chr(10),'') as peri_typ_cd
,replace(replace(t1.open_vchr_typ_cd,chr(13),''),chr(10),'') as open_vchr_typ_cd
,replace(replace(t1.open_vchr_id,chr(13),''),chr(10),'') as open_vchr_id
,t1.etl_dt as etl_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.biz_seq_num,chr(13),''),chr(10),'') as biz_seq_num
,NVL2(t1.data_src_cd,'HDW_EVT_DPST_OPEN_COLSE_DTL'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'HDW_EVT_DPST_OPEN_COLSE_DTL') as etl_task_name 
from ${idl_schema}.hdws_iml_hdw_evt_dpst_open_colse_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd') ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_hdw_evt_dpst_open_colse_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes