: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_dpst_contr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_dpst_contr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,replace(replace(t1.dpst_contr_id,chr(13),''),chr(10),'') as dpst_contr_id
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.contr_sign_acct,chr(13),''),chr(10),'') as contr_sign_acct
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,t1.ctr_sign_dt as ctr_sign_dt
,t1.ctr_eff_dt as ctr_eff_dt
,t1.ctr_expire_dt as ctr_expire_dt
,t1.contr_due_dt as contr_due_dt
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.sign_emp_id,chr(13),''),chr(10),'') as sign_emp_id
,replace(replace(t1.sign_chn_cd,chr(13),''),chr(10),'') as sign_chn_cd
,replace(replace(t1.contr_status_cd,chr(13),''),chr(10),'') as contr_status_cd
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.dpst_contr_amt as dpst_contr_amt
,t1.prd_int_start_dt as prd_int_start_dt
,t1.dpst_contr_rate as dpst_contr_rate
,replace(replace(t1.prcp_enter_acct,chr(13),''),chr(10),'') as prcp_enter_acct
,replace(replace(t1.int_enter_acct,chr(13),''),chr(10),'') as int_enter_acct
,replace(replace(t1.dpst_prd_acct_id,chr(13),''),chr(10),'') as dpst_prd_acct_id
from ${idl_schema}.hdws_dul_d_rpts_agt_dpst_contr_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_dpst_contr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes