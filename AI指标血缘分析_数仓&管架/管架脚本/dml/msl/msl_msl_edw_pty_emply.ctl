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
infile '${data_path}/pty_emply.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_pty_emply
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,emply_id char(4000) nullif emply_id=blanks 
    ,region_acct_num char(4000) nullif region_acct_num=blanks 
    ,first_name char(4000) nullif first_name=blanks 
    ,last_name char(4000) nullif last_name=blanks 
    ,cert_type_cd char(4000) nullif cert_type_cd=blanks 
    ,cert_no char(4000) nullif cert_no=blanks 
    ,gender_cd char(4000) nullif gender_cd=blanks 
    ,birth_dt date "yyyy-mm-dd hh24:mi:ss" nullif birth_dt=blanks 
    ,nationty_cd char(4000) nullif nationty_cd=blanks 
    ,politic_status_cd char(4000) nullif politic_status_cd=blanks 
    ,marriage_situ_cd char(4000) nullif marriage_situ_cd=blanks 
    ,edu_cd char(4000) nullif edu_cd=blanks 
    ,join_work_dt date "yyyy-mm-dd hh24:mi:ss" nullif join_work_dt=blanks 
    ,teller_pic_name char(4000) nullif teller_pic_name=blanks 
    ,emply_type_cd char(4000) nullif emply_type_cd=blanks 
    ,belong_dept_id char(4000) nullif belong_dept_id=blanks 
    ,postn_cd char(4000) nullif postn_cd=blanks 
    ,teller_belong_org_id char(4000) nullif teller_belong_org_id=blanks 
    ,empyt_dt date "yyyy-mm-dd hh24:mi:ss" nullif empyt_dt=blanks 
    ,dimission_dt date "yyyy-mm-dd hh24:mi:ss" nullif dimission_dt=blanks 
    ,emply_status_cd char(4000) nullif emply_status_cd=blanks 
    ,emply_sys_status_cd char(4000) nullif emply_sys_status_cd=blanks 
    ,fax_dom_area_cd char(4000) nullif fax_dom_area_cd=blanks 
    ,fax_num char(4000) nullif fax_num=blanks 
    ,work_tel_dom_area_cd char(4000) nullif work_tel_dom_area_cd=blanks 
    ,work_tel_num char(4000) nullif work_tel_num=blanks 
    ,mobile_phone_num char(4000) nullif mobile_phone_num=blanks 
    ,mobile_phone_num_2 char(4000) nullif mobile_phone_num_2=blanks 
    ,cty_cd char(4000) nullif cty_cd=blanks 
    ,resd_addr char(4000) nullif resd_addr=blanks 
    ,e_mail char(4000) nullif e_mail=blanks 
    ,salary_lev_cd char(4000) nullif salary_lev_cd=blanks 
    ,dsply_seq_num char(4000) nullif dsply_seq_num=blanks 
    ,vtual_accti_dept_id char(4000) nullif vtual_accti_dept_id=blanks 
    ,modif_dt date "yyyy-mm-dd hh24:mi:ss" nullif modif_dt=blanks 
    ,subsidy_distr_dt date "yyyy-mm-dd hh24:mi:ss" nullif subsidy_distr_dt=blanks 
    ,ding_talk_user_id char(4000) nullif ding_talk_user_id=blanks 
    ,post_cd char(4000) nullif post_cd=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,main_teller_id char(4000) nullif main_teller_id=blanks 
    ,title_cd char(4000) nullif title_cd=blanks 
    ,party_id char(4000) nullif party_id=blanks 
    ,create_dt date "yyyy-mm-dd hh24:mi:ss" nullif create_dt=blanks 
    ,update_dt date "yyyy-mm-dd hh24:mi:ss" nullif update_dt=blanks 
    ,id_mark char(4000) nullif id_mark=blanks 
)