: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_pty_emply_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_pty_emply.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select emply_id
,region_acct_num
,first_name
,last_name
,cert_type_cd
,cert_no
,gender_cd
,birth_dt
,nationty_cd
,politic_status_cd
,marriage_situ_cd
,edu_cd
,join_work_dt
,teller_pic_name
,emply_type_cd
,belong_dept_id
,postn_cd
,teller_belong_org_id
,empyt_dt
,dimission_dt
,emply_status_cd
,emply_sys_status_cd
,fax_dom_area_cd
,fax_num
,work_tel_dom_area_cd
,work_tel_num
,mobile_phone_num
,mobile_phone_num_2
,cty_cd
,resd_addr
,e_mail
,salary_lev_cd
,dsply_seq_num
,vtual_accti_dept_id
,modif_dt
,subsidy_distr_dt
,ding_talk_user_id
,post_cd
,etl_dt
,job_cd from idl.icrm_pty_emply where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_pty_emply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes