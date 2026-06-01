: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_dpst_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_dpst_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id
,t1.etl_dt as etl_dt
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.dpst_acct_num,chr(13),''),chr(10),'') as dpst_acct_num
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.dacct_typ_cd,chr(13),''),chr(10),'') as dacct_typ_cd
,t1.open_dt as open_dt
,replace(replace(t1.open_tm,chr(13),''),chr(10),'') as open_tm
,t1.int_start_dt as int_start_dt
,t1.due_dt as due_dt
,t1.prev_acti_acct_dt as prev_acti_acct_dt
,t1.colse_dt as colse_dt
,replace(replace(t1.acct_stats_cd,chr(13),''),chr(10),'') as acct_stats_cd
,replace(replace(t1.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.colse_org_id,chr(13),''),chr(10),'') as colse_org_id
,replace(replace(t1.open_teller_id,chr(13),''),chr(10),'') as open_teller_id
,replace(replace(t1.colse_teller_id,chr(13),''),chr(10),'') as colse_teller_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.cash_remit_ind_cd,chr(13),''),chr(10),'') as cash_remit_ind_cd
,replace(replace(t1.dps_type_cd,chr(13),''),chr(10),'') as dps_type_cd
,replace(replace(t1.usw_flg,chr(13),''),chr(10),'') as usw_flg
,replace(replace(t1.sleep_flg,chr(13),''),chr(10),'') as sleep_flg
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.acct_bal as acct_bal
,t1.usable_bal as usable_bal
,t1.dacct_acct_frz_amt as dacct_acct_frz_amt
,t1.stop_pay_amt as stop_pay_amt
,replace(replace(t1.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
,t1.rate_base_val as rate_base_val
,replace(replace(t1.float_rate_flg,chr(13),''),chr(10),'') as float_rate_flg
,replace(replace(t1.rate_float_mode_cd,chr(13),''),chr(10),'') as rate_float_mode_cd
,t1.rate_float_val as rate_float_val
,t1.exec_rate as exec_rate
,t1.rcva_int as rcva_int
,t1.day_accr_int as day_accr_int
,replace(replace(t1.dacct_stl_mode_cd,chr(13),''),chr(10),'') as dacct_stl_mode_cd
,replace(replace(t1.dacct_intr_mth_cd,chr(13),''),chr(10),'') as dacct_intr_mth_cd
,replace(replace(t1.merch_id,chr(13),''),chr(10),'') as merch_id
,replace(replace(t1.merch_name,chr(13),''),chr(10),'') as merch_name
,t1.merch_up_line_dt as merch_up_line_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.last_update_dt as last_update_dt
,NVL2(t1.data_src_cd,'D_RPTS_AGT_DPST_ACCT_INFO'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'D_RPTS_AGT_DPST_ACCT_INFO') as etl_task_name
,replace(replace(t1.sub_num,chr(13),''),chr(10),'') as sub_num
,replace(replace(t1.int_base_cd,chr(13),''),chr(10),'') as int_base_cd
,t1.expt_highest_yld as expt_highest_yld
,replace(replace(t1.contr_id,chr(13),''),chr(10),'') as contr_id
,t1.contr_due_dt as contr_due_dt
,replace(replace(t1.co_org_name,chr(13),''),chr(10),'') as co_org_name
,replace(replace(t1.issue_dpst_proof_bk_flg,chr(13),''),chr(10),'') as issue_dpst_proof_bk_flg
from ${idl_schema}.hdws_dul_d_rpts_agt_dpst_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_dpst_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes