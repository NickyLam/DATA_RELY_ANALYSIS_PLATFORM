: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_dpst_rate_apprv_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_dpst_rate_apprv.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,replace(replace(t1.aprv_id,chr(13),''),chr(10),'') as aprv_id
,replace(replace(t1.apprv_typ_cd,chr(13),''),chr(10),'') as apprv_typ_cd
,replace(replace(t1.aprv_status_cd,chr(13),''),chr(10),'') as aprv_status_cd
,replace(replace(t1.app_categ_cd,chr(13),''),chr(10),'') as app_categ_cd
,replace(replace(t1.app_rate_acct,chr(13),''),chr(10),'') as app_rate_acct
,replace(replace(t1.new_acct_flg,chr(13),''),chr(10),'') as new_acct_flg
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.app_amt_ceil as app_amt_ceil
,t1.base_rate_val as base_rate_val
,t1.rate_float_val as rate_float_val
,t1.exec_rate as exec_rate
,replace(replace(t1.new_agt_flg,chr(13),''),chr(10),'') as new_agt_flg
,replace(replace(t1.ori_apprv_id,chr(13),''),chr(10),'') as ori_apprv_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.pty_name,chr(13),''),chr(10),'') as pty_name
,replace(replace(t1.crdt_pty_flg,chr(13),''),chr(10),'') as crdt_pty_flg
,replace(replace(t1.crdt_pty_syn_income_situ,chr(13),''),chr(10),'') as crdt_pty_syn_income_situ
,replace(replace(t1.dpst_breed_cd,chr(13),''),chr(10),'') as dpst_breed_cd
,replace(replace(t1.peri_typ_cd,chr(13),''),chr(10),'') as peri_typ_cd
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,t1.contr_due_dt as contr_due_dt
,t1.apprv_start_dt as apprv_start_dt
,t1.apprv_end_dt as apprv_end_dt
,t1.apprv_due_dt as apprv_due_dt
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.app_emp_id,chr(13),''),chr(10),'') as app_emp_id
,replace(replace(t1.final_aprv_emp_id,chr(13),''),chr(10),'') as final_aprv_emp_id
,replace(replace(t1.app_reas_situ_intro,chr(13),''),chr(10),'') as app_reas_situ_intro
,replace(replace(t1.dpst_prd_acct_id,chr(13),''),chr(10),'') as dpst_prd_acct_id
from ${idl_schema}.hdws_dul_d_rpts_agt_dpst_rate_apprv t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_dpst_rate_apprv.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes