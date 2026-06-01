: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_org_emp_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_org_emp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
emp_id
,etl_dt
,last_update_dt
,emp_name
,emp_typ_cd
,doma_user_name
,teller_mgr_id
,cust_mgr_flg
,cust_mgr_level
,teller_flag
,teller_num
,tell_lvl_cd
,iden_num
,gender_cd
,birth_dt
,ethnic_cd
,poli_face_cd
,marriage_status_cd
,edu_degree_cd
,degree_cd
,duty_cd
,profsn_title_cd
,job_dt
,on_board_dt
,locate_dept_id
,off_board_dt
,emp_status_cd
,emp_sys_status_cd
,blng_org_id
,comp_intl_phone_cty_cd
,comp_dom_tel_area_cd
,comp_phone
,corp_tel_ext_num
,fax_intl_phone_cty_cd
,fax_dom_tel_area_cd
,fax_num
,fax_extension_num
,home_intl_phone_cty_cd
,home_tel_area_cd
,home_phone
,home_tel_ext_num
,mobile_phone
,mobile_phone1
,mobile_phone2
,mobile_phone3
,zipcode
,country
,province
,city
,county_cd
,physical_address
,e_mail
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_org_emp_info
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_org_emp_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes