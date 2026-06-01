: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_evt_dpst_open_colse_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_evt_dpst_open_colse_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(trx_seq,chr(10),''),chr(13),'') as trx_seq
      ,replace(replace(global_chn_seq_num,chr(10),''),chr(13),'') as global_chn_seq_num
      ,txn_dt
      ,replace(replace(proc_status_cd,chr(10),''),chr(13),'') as proc_status_cd
      ,replace(replace(chn_typ_cd,chr(10),''),chr(13),'') as chn_typ_cd
      ,replace(replace(acct_org_id,chr(10),''),chr(13),'') as acct_org_id
      ,replace(replace(dpst_acct_id,chr(10),''),chr(13),'') as dpst_acct_id
      ,replace(replace(dpst_acct_num,chr(10),''),chr(13),'') as dpst_acct_num
      ,replace(replace(dacct_name,chr(10),''),chr(13),'') as dacct_name
      ,replace(replace(open_colse_flg,chr(10),''),chr(13),'') as open_colse_flg
      ,replace(replace(reve_flg,chr(10),''),chr(13),'') as reve_flg
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,replace(replace(cash_remit_ind_cd,chr(10),''),chr(13),'') as cash_remit_ind_cd
      ,replace(replace(dps_type_cd,chr(10),''),chr(13),'') as dps_type_cd
      ,replace(replace(peri_typ_cd,chr(10),''),chr(13),'') as peri_typ_cd
      ,replace(replace(open_vchr_typ_cd,chr(10),''),chr(13),'') as open_vchr_typ_cd
      ,replace(replace(open_vchr_id,chr(10),''),chr(13),'') as open_vchr_id
      ,etl_dt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,last_update_dt
      ,replace(replace(etl_task_name,chr(10),''),chr(13),'') as etl_task_name 
from idl.hdws_dul_d_rpts_evt_dpst_open_colse_dtl 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_evt_dpst_open_colse_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes