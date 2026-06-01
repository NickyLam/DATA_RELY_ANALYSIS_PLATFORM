: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_corp_cust_senior_man_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/pty_corp_cust_senior_man_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.party_rela_type_cd,chr(13),''),chr(10),'') as party_rela_type_cd
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,birth_dt
,replace(replace(t1.edu_cd,chr(13),''),chr(10),'') as edu_cd
,replace(replace(t1.work_resume_descb,chr(13),''),chr(10),'') as work_resume_descb
,replace(replace(t1.phone_num,chr(13),''),chr(10),'') as phone_num
,serving_dt
,indus_obtain_emply_years
,replace(replace(t1.hold_stock_situ_descb,chr(13),''),chr(10),'') as hold_stock_situ_descb
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,rgst_dt
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,share_ratio
,replace(replace(t1.title_cd,chr(13),''),chr(10),'') as title_cd
,replace(replace(t1.work_tel_num,chr(13),''),chr(10),'') as work_tel_num
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd
,replace(replace(t1.corp_actl_ctrler_flg,chr(13),''),chr(10),'') as corp_actl_ctrler_flg
,replace(replace(t1.senior_man_type_cd,chr(13),''),chr(10),'') as senior_man_type_cd
,replace(replace(t1.senior_man_career_cd,chr(13),''),chr(10),'') as senior_man_career_cd

from ${iml_schema}.pty_corp_cust_senior_man_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_cust_senior_man_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
