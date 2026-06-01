-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/cmm_clerk_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_clerk_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,clerk_id char(4000) nullif clerk_id=blanks 
    ,clerk_name char(4000) nullif clerk_name=blanks 
    ,teller_flg char(4000) nullif teller_flg=blanks 
    ,teller_id char(4000) nullif teller_id=blanks 
    ,region_acct_num char(4000) nullif region_acct_num=blanks 
    ,emply_type_cd char(4000) nullif emply_type_cd=blanks 
    ,cert_type_cd char(4000) nullif cert_type_cd=blanks 
    ,cert_no char(4000) nullif cert_no=blanks 
    ,gender_cd char(4000) nullif gender_cd=blanks 
    ,birth_dt date "yyyy-mm-dd hh24:mi:ss" nullif birth_dt=blanks 
    ,nationty_cd char(4000) nullif nationty_cd=blanks 
    ,politic_status_cd char(4000) nullif politic_status_cd=blanks 
    ,marriage_situ_cd char(4000) nullif marriage_situ_cd=blanks 
    ,edu_cd char(4000) nullif edu_cd=blanks 
    ,post_cd char(4000) nullif post_cd=blanks 
    ,title_cd char(4000) nullif title_cd=blanks 
    ,fir_work_dt date "yyyy-mm-dd hh24:mi:ss" nullif fir_work_dt=blanks 
    ,empyt_dt date "yyyy-mm-dd hh24:mi:ss" nullif empyt_dt=blanks 
    ,local_dept_id char(4000) nullif local_dept_id=blanks 
    ,dimission_dt date "yyyy-mm-dd hh24:mi:ss" nullif dimission_dt=blanks 
    ,emply_status_cd char(4000) nullif emply_status_cd=blanks 
    ,emply_sys_status_cd char(4000) nullif emply_sys_status_cd=blanks 
    ,belong_org_id char(4000) nullif belong_org_id=blanks 
    ,work_tel_inter_area_cd char(4000) nullif work_tel_inter_area_cd=blanks 
    ,work_tel_area_cd char(4000) nullif work_tel_area_cd=blanks 
    ,work_tel_num char(4000) nullif work_tel_num=blanks 
    ,fax_area_cd char(4000) nullif fax_area_cd=blanks 
    ,fax_num char(4000) nullif fax_num=blanks 
    ,mobile_phone_num char(4000) nullif mobile_phone_num=blanks 
    ,cty_cd char(4000) nullif cty_cd=blanks 
    ,dtl_addr char(4000) nullif dtl_addr=blanks 
    ,e_mail_addr char(4000) nullif e_mail_addr=blanks 
    ,ding_talk_user_id char(4000) nullif ding_talk_user_id=blanks 
    ,jobs_cd char(4000) nullif jobs_cd=blanks 
    ,jobs_cate char(4000) nullif jobs_cate=blanks 
    ,jobs_name char(4000) nullif jobs_name=blanks 
    ,cust_mgr_flg char(4000) nullif cust_mgr_flg=blanks 
    ,cust_mgr_lev char(4000) nullif cust_mgr_lev=blanks 
    ,teller_lev_cd char(4000) nullif teller_lev_cd=blanks 
    ,teller_director_id char(4000) nullif teller_director_id=blanks 
    ,vtual_accti_org_id char(4000) nullif vtual_accti_org_id=blanks 
    ,work_tel_ext_num char(4000) nullif work_tel_ext_num=blanks 
    ,fax_inter_area_cd char(4000) nullif fax_inter_area_cd=blanks 
    ,fax_ext_num char(4000) nullif fax_ext_num=blanks 
    ,resd_tel_inter_area_cd char(4000) nullif resd_tel_inter_area_cd=blanks 
    ,resd_tel_dom_area_cd char(4000) nullif resd_tel_dom_area_cd=blanks 
    ,resd_tel char(4000) nullif resd_tel=blanks 
    ,resd_tel_ext_num char(4000) nullif resd_tel_ext_num=blanks 
    ,mobile_phone_num_1 char(4000) nullif mobile_phone_num_1=blanks 
    ,mobile_phone_num_2 char(4000) nullif mobile_phone_num_2=blanks 
    ,mobile_phone_num_3 char(4000) nullif mobile_phone_num_3=blanks 
    ,zip_cd char(4000) nullif zip_cd=blanks 
    ,local_prov char(4000) nullif local_prov=blanks 
    ,site char(4000) nullif site=blanks 
    ,postn_cd char(4000) nullif postn_cd=blanks 
    ,post_cate_id char(4000) nullif post_cate_id=blanks 
    ,post_name char(4000) nullif post_name=blanks 
    ,jobs_id char(4000) nullif jobs_id=blanks 
    ,jobs_descb char(4000) nullif jobs_descb=blanks 
)