: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_dpst_rate_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_dpst_rate_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.aprv_id,chr(13),''),chr(10),'') as aprv_id
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.sign_chn_cd,chr(13),''),chr(10),'') as sign_chn_cd
,replace(replace(t1.sign_emp_id,chr(13),''),chr(10),'') as sign_emp_id
,t1.agt_eff_dt as agt_eff_dt
,t1.contr_due_dt as contr_due_dt
,replace(replace(t1.sign_acct_num,chr(13),''),chr(10),'') as sign_acct_num
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.pty_name,chr(13),''),chr(10),'') as pty_name
,replace(replace(t1.peri_typ_cd,chr(13),''),chr(10),'') as peri_typ_cd
,replace(replace(t1.rate_float_mode_cd,chr(13),''),chr(10),'') as rate_float_mode_cd
,t1.rate_float_val as rate_float_val
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.new_agt_flg,chr(13),''),chr(10),'') as new_agt_flg
from ${idl_schema}.hdws_dul_d_rpts_agt_dpst_rate_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_dpst_rate_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes