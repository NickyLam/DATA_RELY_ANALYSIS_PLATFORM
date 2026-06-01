: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eifs_t01_per_cust_info_f
CreateDate: 20240328
FileName:   ${iel_data_path}/eifs_t01_per_cust_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.former_name,chr(13),''),chr(10),'') as former_name
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,replace(replace(t1.ethnic_cd,chr(13),''),chr(10),'') as ethnic_cd
,replace(replace(t1.birth_place_cd,chr(13),''),chr(10),'') as birth_place_cd
,replace(replace(t1.birth_dt,chr(13),''),chr(10),'') as birth_dt
,replace(replace(t1.birth_place,chr(13),''),chr(10),'') as birth_place
,replace(replace(t1.depositor_type_cd,chr(13),''),chr(10),'') as depositor_type_cd
,replace(replace(t1.poltc_stat_cd,chr(13),''),chr(10),'') as poltc_stat_cd
,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd
,replace(replace(t1.supr_edu_degree_cd,chr(13),''),chr(10),'') as supr_edu_degree_cd
,replace(replace(t1.supr_degree_cd,chr(13),''),chr(10),'') as supr_degree_cd
,replace(replace(t1.work_stat_cd,chr(13),''),chr(10),'') as work_stat_cd
,replace(replace(t1.career_cd,chr(13),''),chr(10),'') as career_cd
,replace(replace(t1.other_occupation,chr(13),''),chr(10),'') as other_occupation
,replace(replace(t1.title_cd,chr(13),''),chr(10),'') as title_cd
,replace(replace(t1.pos_level_cd,chr(13),''),chr(10),'') as pos_level_cd
,replace(replace(t1.emply_ind,chr(13),''),chr(10),'') as emply_ind
,replace(replace(t1.emply_num,chr(13),''),chr(10),'') as emply_num
,replace(replace(t1.create_te,chr(13),''),chr(10),'') as create_te
,replace(replace(t1.create_org,chr(13),''),chr(10),'') as create_org
,replace(replace(t1.init_system_id,chr(13),''),chr(10),'') as init_system_id
,init_created_ts
,created_ts
,updated_ts
,replace(replace(t1.last_updated_te,chr(13),''),chr(10),'') as last_updated_te
,replace(replace(t1.last_updated_org,chr(13),''),chr(10),'') as last_updated_org
,replace(replace(t1.last_system_id,chr(13),''),chr(10),'') as last_system_id
,last_updated_ts
,replace(replace(t1.src_sys_num,chr(13),''),chr(10),'') as src_sys_num
,replace(replace(t1.last_updated_src_sys_num,chr(13),''),chr(10),'') as last_updated_src_sys_num
,replace(replace(t1.loan_flag,chr(13),''),chr(10),'') as loan_flag
,replace(replace(t1.self_sup_flag,chr(13),''),chr(10),'') as self_sup_flag
,replace(replace(t1.career_desc_level1,chr(13),''),chr(10),'') as career_desc_level1
,replace(replace(t1.career_desc_level2,chr(13),''),chr(10),'') as career_desc_level2
,replace(replace(t1.guarantee_flag,chr(13),''),chr(10),'') as guarantee_flag
,replace(replace(t1.party_role,chr(13),''),chr(10),'') as party_role
,replace(replace(t1.aml_dep_flag,chr(13),''),chr(10),'') as aml_dep_flag
,replace(replace(t1.aml_loan_flag,chr(13),''),chr(10),'') as aml_loan_flag
,replace(replace(t1.aml_guar_flag,chr(13),''),chr(10),'') as aml_guar_flag

from ${iol_schema}.eifs_t01_per_cust_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eifs_t01_per_cust_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
