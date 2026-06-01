: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_clerk_info_f
CreateDate: 20250910
FileName:   ${iel_data_path}/cmm_clerk_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.clerk_id,chr(13),''),chr(10),'') as clerk_id
,replace(replace(t1.clerk_name,chr(13),''),chr(10),'') as clerk_name
,replace(replace(t1.teller_flg,chr(13),''),chr(10),'') as teller_flg
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id
,replace(replace(t1.region_acct_num,chr(13),''),chr(10),'') as region_acct_num
,replace(replace(t1.emply_type_cd,chr(13),''),chr(10),'') as emply_type_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,birth_dt
,replace(replace(t1.nationty_cd,chr(13),''),chr(10),'') as nationty_cd
,replace(replace(t1.politic_status_cd,chr(13),''),chr(10),'') as politic_status_cd
,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd
,replace(replace(t1.edu_cd,chr(13),''),chr(10),'') as edu_cd
,replace(replace(t1.post_cd,chr(13),''),chr(10),'') as post_cd
,replace(replace(t1.title_cd,chr(13),''),chr(10),'') as title_cd
,fir_work_dt
,empyt_dt
,replace(replace(t1.local_dept_id,chr(13),''),chr(10),'') as local_dept_id
,dimission_dt
,replace(replace(t1.emply_status_cd,chr(13),''),chr(10),'') as emply_status_cd
,replace(replace(t1.emply_sys_status_cd,chr(13),''),chr(10),'') as emply_sys_status_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.work_tel_inter_area_cd,chr(13),''),chr(10),'') as work_tel_inter_area_cd
,replace(replace(t1.work_tel_area_cd,chr(13),''),chr(10),'') as work_tel_area_cd
,replace(replace(t1.work_tel_num,chr(13),''),chr(10),'') as work_tel_num
,replace(replace(t1.fax_area_cd,chr(13),''),chr(10),'') as fax_area_cd
,replace(replace(t1.fax_num,chr(13),''),chr(10),'') as fax_num
,replace(replace(t1.mobile_phone_num,chr(13),''),chr(10),'') as mobile_phone_num
,replace(replace(t1.cty_cd,chr(13),''),chr(10),'') as cty_cd
,replace(replace(t1.dtl_addr,chr(13),''),chr(10),'') as dtl_addr
,replace(replace(t1.e_mail_addr,chr(13),''),chr(10),'') as e_mail_addr
,replace(replace(t1.ding_talk_user_id,chr(13),''),chr(10),'') as ding_talk_user_id
,replace(replace(t1.jobs_cd,chr(13),''),chr(10),'') as jobs_cd
,replace(replace(t1.jobs_cate,chr(13),''),chr(10),'') as jobs_cate
,replace(replace(t1.jobs_name,chr(13),''),chr(10),'') as jobs_name
,replace(replace(t1.cust_mgr_flg,chr(13),''),chr(10),'') as cust_mgr_flg
,replace(replace(t1.cust_mgr_lev,chr(13),''),chr(10),'') as cust_mgr_lev
,replace(replace(t1.teller_lev_cd,chr(13),''),chr(10),'') as teller_lev_cd
,replace(replace(t1.teller_director_id,chr(13),''),chr(10),'') as teller_director_id
,replace(replace(t1.vtual_accti_org_id,chr(13),''),chr(10),'') as vtual_accti_org_id
,replace(replace(t1.work_tel_ext_num,chr(13),''),chr(10),'') as work_tel_ext_num
,replace(replace(t1.fax_inter_area_cd,chr(13),''),chr(10),'') as fax_inter_area_cd
,replace(replace(t1.fax_ext_num,chr(13),''),chr(10),'') as fax_ext_num
,replace(replace(t1.resd_tel_inter_area_cd,chr(13),''),chr(10),'') as resd_tel_inter_area_cd
,replace(replace(t1.resd_tel_dom_area_cd,chr(13),''),chr(10),'') as resd_tel_dom_area_cd
,replace(replace(t1.resd_tel,chr(13),''),chr(10),'') as resd_tel
,replace(replace(t1.resd_tel_ext_num,chr(13),''),chr(10),'') as resd_tel_ext_num
,replace(replace(t1.mobile_phone_num_1,chr(13),''),chr(10),'') as mobile_phone_num_1
,replace(replace(t1.mobile_phone_num_2,chr(13),''),chr(10),'') as mobile_phone_num_2
,replace(replace(t1.mobile_phone_num_3,chr(13),''),chr(10),'') as mobile_phone_num_3
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t1.local_prov,chr(13),''),chr(10),'') as local_prov
,replace(replace(t1.site,chr(13),''),chr(10),'') as site
,replace(replace(t1.postn_cd,chr(13),''),chr(10),'') as postn_cd
,replace(replace(t1.post_cate_id,chr(13),''),chr(10),'') as post_cate_id
,replace(replace(t1.post_name,chr(13),''),chr(10),'') as post_name
,replace(replace(t1.jobs_id,chr(13),''),chr(10),'') as jobs_id
,replace(replace(t1.jobs_descb,chr(13),''),chr(10),'') as jobs_descb

from ${icl_schema}.cmm_clerk_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_clerk_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
