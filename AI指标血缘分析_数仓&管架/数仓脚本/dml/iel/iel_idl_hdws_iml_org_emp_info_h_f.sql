: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_org_emp_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_org_emp_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.emp_id,chr(13),''),chr(10),'') as emp_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.emp_name,chr(13),''),chr(10),'') as emp_name
,replace(replace(t1.emp_typ_cd,chr(13),''),chr(10),'') as emp_typ_cd
,replace(replace(t1.doma_user_name,chr(13),''),chr(10),'') as doma_user_name
,replace(replace(t1.teller_mgr_id,chr(13),''),chr(10),'') as teller_mgr_id
,replace(replace(t1.cust_mgr_flg,chr(13),''),chr(10),'') as cust_mgr_flg
,replace(replace(t1.cust_mgr_level,chr(13),''),chr(10),'') as cust_mgr_level
,replace(replace(t1.teller_flag,chr(13),''),chr(10),'') as teller_flag
,replace(replace(t1.teller_num,chr(13),''),chr(10),'') as teller_num
,replace(replace(t1.tell_lvl_cd,chr(13),''),chr(10),'') as tell_lvl_cd
,replace(replace(t1.iden_num,chr(13),''),chr(10),'') as iden_num
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,t1.birth_dt as birth_dt
,replace(replace(t1.ethnic_cd,chr(13),''),chr(10),'') as ethnic_cd
,replace(replace(t1.poli_face_cd,chr(13),''),chr(10),'') as poli_face_cd
,replace(replace(t1.marriage_status_cd,chr(13),''),chr(10),'') as marriage_status_cd
,replace(replace(t1.edu_degree_cd,chr(13),''),chr(10),'') as edu_degree_cd
,replace(replace(t1.degree_cd,chr(13),''),chr(10),'') as degree_cd
,replace(replace(t1.duty_cd,chr(13),''),chr(10),'') as duty_cd
,replace(replace(t1.profsn_title_cd,chr(13),''),chr(10),'') as profsn_title_cd
,t1.job_dt as job_dt
,t1.on_board_dt as on_board_dt
,replace(replace(t1.locate_dept_id,chr(13),''),chr(10),'') as locate_dept_id
,t1.off_board_dt as off_board_dt
,replace(replace(t1.emp_status_cd,chr(13),''),chr(10),'') as emp_status_cd
,replace(replace(t1.emp_sys_status_cd,chr(13),''),chr(10),'') as emp_sys_status_cd
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.comp_intl_phone_cty_cd,chr(13),''),chr(10),'') as comp_intl_phone_cty_cd
,replace(replace(t1.comp_dom_tel_area_cd,chr(13),''),chr(10),'') as comp_dom_tel_area_cd
,replace(replace(t1.comp_phone,chr(13),''),chr(10),'') as comp_phone
,replace(replace(t1.corp_tel_ext_num,chr(13),''),chr(10),'') as corp_tel_ext_num
,replace(replace(t1.fax_intl_phone_cty_cd,chr(13),''),chr(10),'') as fax_intl_phone_cty_cd
,replace(replace(t1.fax_dom_tel_area_cd,chr(13),''),chr(10),'') as fax_dom_tel_area_cd
,replace(replace(t1.fax_num,chr(13),''),chr(10),'') as fax_num
,replace(replace(t1.fax_extension_num,chr(13),''),chr(10),'') as fax_extension_num
,replace(replace(t1.home_intl_phone_cty_cd,chr(13),''),chr(10),'') as home_intl_phone_cty_cd
,replace(replace(t1.home_tel_area_cd,chr(13),''),chr(10),'') as home_tel_area_cd
,replace(replace(t1.home_phone,chr(13),''),chr(10),'') as home_phone
,replace(replace(t1.home_tel_ext_num,chr(13),''),chr(10),'') as home_tel_ext_num
,replace(replace(t1.mobile_phone,chr(13),''),chr(10),'') as mobile_phone
,replace(replace(t1.mobile_phone1,chr(13),''),chr(10),'') as mobile_phone1
,replace(replace(t1.mobile_phone2,chr(13),''),chr(10),'') as mobile_phone2
,replace(replace(t1.mobile_phone3,chr(13),''),chr(10),'') as mobile_phone3
,replace(replace(t1.zipcode,chr(13),''),chr(10),'') as zipcode
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.county_cd,chr(13),''),chr(10),'') as county_cd
,replace(replace(t1.physical_address,chr(13),''),chr(10),'') as physical_address
,replace(replace(t1.e_mail,chr(13),''),chr(10),'') as e_mail
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'ORG_EMP_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'ORG_EMP_INFO_H') as etl_task_name 
from ${idl_schema}.hdws_iml_org_emp_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_org_emp_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes