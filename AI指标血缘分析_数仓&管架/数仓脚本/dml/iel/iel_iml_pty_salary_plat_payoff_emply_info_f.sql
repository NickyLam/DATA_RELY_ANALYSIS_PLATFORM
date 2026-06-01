: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_salary_plat_payoff_emply_info_f
CreateDate: 20250709
FileName:   ${iel_data_path}/pty_salary_plat_payoff_emply_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.emply_id,chr(13),''),chr(10),'') as emply_id
,replace(replace(t1.emply_name,chr(13),''),chr(10),'') as emply_name
,replace(replace(t1.postning_flg,chr(13),''),chr(10),'') as postning_flg
,replace(replace(t1.start_use_flg,chr(13),''),chr(10),'') as start_use_flg
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,replace(replace(t1.emply_type_cd,chr(13),''),chr(10),'') as emply_type_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.postn_id,chr(13),''),chr(10),'') as postn_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.post_id,chr(13),''),chr(10),'') as post_id
,empyt_dt
,replace(replace(t1.out_corp_flg,chr(13),''),chr(10),'') as out_corp_flg
,replace(replace(t1.dimission_status_cd,chr(13),''),chr(10),'') as dimission_status_cd
,replace(replace(t1.dimission_resume_flg,chr(13),''),chr(10),'') as dimission_resume_flg
,replace(replace(t1.jcm_stop_use_flg,chr(13),''),chr(10),'') as jcm_stop_use_flg
,batch_create_dt
,batch_update_dt

from ${iml_schema}.pty_salary_plat_payoff_emply_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_salary_plat_payoff_emply_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
