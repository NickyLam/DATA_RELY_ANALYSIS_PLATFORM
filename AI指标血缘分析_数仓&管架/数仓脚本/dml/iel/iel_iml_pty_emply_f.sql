: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_emply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_emply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.emply_id,chr(13),''),chr(10),'') as emply_id 
,replace(replace(t1.region_acct_num,chr(13),''),chr(10),'') as region_acct_num 
,replace(replace(t1.first_name,chr(13),''),chr(10),'') as first_name 
,replace(replace(t1.last_name,chr(13),''),chr(10),'') as last_name 
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd 
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no 
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd 
,t1.birth_dt as birth_dt 
,replace(replace(t1.nationty_cd,chr(13),''),chr(10),'') as nationty_cd 
,replace(replace(t1.politic_status_cd,chr(13),''),chr(10),'') as politic_status_cd 
,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd 
,replace(replace(t1.edu_cd,chr(13),''),chr(10),'') as edu_cd 
,t1.join_work_dt as join_work_dt 
,replace(replace(t1.teller_pic_name,chr(13),''),chr(10),'') as teller_pic_name 
,replace(replace(t1.emply_type_cd,chr(13),''),chr(10),'') as emply_type_cd 
,replace(replace(t1.belong_dept_id,chr(13),''),chr(10),'') as belong_dept_id 
,replace(replace(t1.postn_cd,chr(13),''),chr(10),'') as postn_cd 
,replace(replace(t1.teller_belong_org_id,chr(13),''),chr(10),'') as teller_belong_org_id 
,t1.empyt_dt as empyt_dt 
,t1.dimission_dt as dimission_dt 
,replace(replace(t1.emply_status_cd,chr(13),''),chr(10),'') as emply_status_cd 
,replace(replace(t1.emply_sys_status_cd,chr(13),''),chr(10),'') as emply_sys_status_cd 
,replace(replace(t1.fax_dom_area_cd,chr(13),''),chr(10),'') as fax_dom_area_cd 
,replace(replace(t1.fax_num,chr(13),''),chr(10),'') as fax_num 
,replace(replace(t1.work_tel_dom_area_cd,chr(13),''),chr(10),'') as work_tel_dom_area_cd 
,replace(replace(t1.work_tel_num,chr(13),''),chr(10),'') as work_tel_num 
,replace(replace(t1.mobile_phone_num,chr(13),''),chr(10),'') as mobile_phone_num 
,replace(replace(t1.mobile_phone_num_2,chr(13),''),chr(10),'') as mobile_phone_num_2 
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd 
,replace(replace(t1.resd_addr,chr(13),''),chr(10),'') as resd_addr 
,replace(replace(t1.e_mail,chr(13),''),chr(10),'') as e_mail 
,replace(replace(t1.salary_lev_cd,chr(13),''),chr(10),'') as salary_lev_cd 
,replace(replace(t1.dsply_seq_num,chr(13),''),chr(10),'') as dsply_seq_num 
,replace(replace(t1.vtual_accti_dept_id,chr(13),''),chr(10),'') as vtual_accti_dept_id 
,t1.modif_dt as modif_dt 
,t1.subsidy_distr_dt as subsidy_distr_dt 
,replace(replace(t1.ding_talk_user_id,chr(13),''),chr(10),'') as ding_talk_user_id 
,replace(replace(t1.post_cd,chr(13),''),chr(10),'') as post_cd 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.main_teller_id,chr(13),''),chr(10),'') as main_teller_id 
,replace(replace(t1.title_cd,chr(13),''),chr(10),'') as title_cd 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_emply t1 
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_emply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes