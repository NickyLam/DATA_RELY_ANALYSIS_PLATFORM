: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_agt_dacct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_agt_dacct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(dpst_acct_id,chr(10),''),chr(13),'') as dpst_acct_id
      ,etl_dt
      ,replace(replace(blng_pty_id,chr(10),''),chr(13),'') as blng_pty_id
      ,replace(replace(acct_name,chr(10),''),chr(13),'') as acct_name
      ,replace(replace(dacct_typ_cd,chr(10),''),chr(13),'') as dacct_typ_cd
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,replace(replace(accting_coa_id,chr(10),''),chr(13),'') as accting_coa_id
      ,open_dt
      ,int_start_dt
      ,due_dt
      ,prev_acti_acct_dt
      ,colse_dt
      ,replace(replace(acct_stats_cd,chr(10),''),chr(13),'') as acct_stats_cd
      ,replace(replace(stop_pay_status_cd,chr(10),''),chr(13),'') as stop_pay_status_cd
      ,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
      ,replace(replace(mgmt_org_id,chr(10),''),chr(13),'') as mgmt_org_id
      ,replace(replace(colse_org_id,chr(10),''),chr(13),'') as colse_org_id
      ,replace(replace(open_teller_id,chr(10),''),chr(13),'') as open_teller_id
      ,replace(replace(colse_teller_id,chr(10),''),chr(13),'') as colse_teller_id
      ,replace(replace(pty_mgr_id,chr(10),''),chr(13),'') as pty_mgr_id
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,replace(replace(cash_remit_ind_cd,chr(10),''),chr(13),'') as cash_remit_ind_cd
      ,replace(replace(dps_type_cd,chr(10),''),chr(13),'') as dps_type_cd
      ,replace(replace(int_flg,chr(10),''),chr(13),'') as int_flg
      ,replace(replace(usw_flg,chr(10),''),chr(13),'') as usw_flg
      ,replace(replace(dacct_acct_frz_flg,chr(10),''),chr(13),'') as dacct_acct_frz_flg
      ,replace(replace(sleep_flg,chr(10),''),chr(13),'') as sleep_flg
      ,replace(replace(time_dep_flg,chr(10),''),chr(13),'') as time_dep_flg
      ,replace(replace(agt_dpst_flg,chr(10),''),chr(13),'') as agt_dpst_flg
      ,replace(replace(redep_mode_typ_cd,chr(10),''),chr(13),'') as redep_mode_typ_cd
      ,replace(replace(peri_typ_cd,chr(10),''),chr(13),'') as peri_typ_cd
      ,replace(replace(rate_base_typ_cd,chr(10),''),chr(13),'') as rate_base_typ_cd
      ,rate_base_val
      ,replace(replace(float_rate_flg,chr(10),''),chr(13),'') as float_rate_flg
      ,replace(replace(rate_float_mode_cd,chr(10),''),chr(13),'') as rate_float_mode_cd
      ,rate_float_val
      ,exec_rate
      ,replace(replace(dacct_stl_mode_cd,chr(10),''),chr(13),'') as dacct_stl_mode_cd
      ,replace(replace(dacct_intr_mth_cd,chr(10),''),chr(13),'') as dacct_intr_mth_cd
      ,final_trx_dt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd 
from idl.hdws_dul_d_opr_agt_dacct_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_agt_dacct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes