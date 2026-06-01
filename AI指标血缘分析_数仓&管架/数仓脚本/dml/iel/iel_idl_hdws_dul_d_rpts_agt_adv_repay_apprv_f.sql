: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_adv_repay_apprv_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_adv_repay_apprv.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,t1.etl_dt as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.adv_repay_typ_cd,chr(13),''),chr(10),'') as adv_repay_typ_cd
,replace(replace(t1.adv_repay_mode_cd,chr(13),''),chr(10),'') as adv_repay_mode_cd
,replace(replace(t1.aprv_status_cd,chr(13),''),chr(10),'') as aprv_status_cd
,t1.appl_dt as appl_dt
,replace(replace(t1.reg_emp_id,chr(13),''),chr(10),'') as reg_emp_id
,replace(replace(t1.reg_org_id,chr(13),''),chr(10),'') as reg_org_id
,replace(replace(t1.aprv_emp_id,chr(13),''),chr(10),'') as aprv_emp_id
,t1.new_term as new_term
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.repay_total_amt as repay_total_amt
,t1.ghb_pnty as ghb_pnty
,t1.adv_repay_amt as adv_repay_amt
,t1.owe_liqdt_amt as owe_liqdt_amt
,t1.bil_non_prcp as bil_non_prcp
,t1.bil_non_int as bil_non_int
,t1.bil_non_cmpd_intr as bil_non_cmpd_intr
,t1.non_enter_acct_int as non_enter_acct_int
,t1.owe_prcp_pend_post_int as owe_prcp_pend_post_int
,t1.owe_int_pend_post_cmpd_intr as owe_int_pend_post_cmpd_intr
,t1.rema_norm_prcp as rema_norm_prcp
,replace(replace(t1.adv_repay_comm,chr(13),''),chr(10),'') as adv_repay_comm
,replace(replace(t1.repay_seq_num,chr(13),''),chr(10),'') as repay_seq_num
from ${idl_schema}.hdws_dul_d_rpts_agt_adv_repay_apprv t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_adv_repay_apprv.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes