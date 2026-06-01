: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_emply_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_emply.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.first_name as first_name
,t1.last_name as last_name
,t1.cert_type_cd as cert_type_cd
,t1.cert_no as cert_no
,t1.gender_cd as gender_cd
,t1.birth_dt as birth_dt
,t1.nationty_cd as nationty_cd
,t1.politic_status_cd as politic_status_cd
,t1.marriage_situ_cd as marriage_situ_cd
,t1.edu_cd as edu_cd
,t1.join_work_dt as join_work_dt
,t1.teller_pic_name as teller_pic_name
,t1.emply_type_cd as emply_type_cd
,t1.belong_dept_id as belong_dept_id
,t1.postn_cd as postn_cd
,t1.teller_belong_org_id as teller_belong_org_id
,t1.empyt_dt as empyt_dt
,t1.dimission_dt as dimission_dt
,t1.emply_status_cd as emply_status_cd
,t1.emply_sys_status_cd as emply_sys_status_cd
,t1.fax_dom_area_cd as fax_dom_area_cd
,t1.fax_num as fax_num
,t1.work_tel_dom_area_cd as work_tel_dom_area_cd
,t1.work_tel_num as work_tel_num
,t1.mobile_phone_num as mobile_phone_num
,t1.mobile_phone_num_2 as mobile_phone_num_2
,t1.cty_cd as cty_cd
,t1.resd_addr as resd_addr
,t1.e_mail as e_mail
,t1.salary_lev_cd as salary_lev_cd
,t1.dsply_seq_num as dsply_seq_num
,t1.vtual_accti_dept_id as vtual_accti_dept_id
,t1.modif_dt as modif_dt
,t1.subsidy_distr_dt as subsidy_distr_dt
,t1.ding_talk_user_id as ding_talk_user_id
,t1.post_cd as post_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.lp_id as lp_id
,t1.main_teller_id as main_teller_id
,t1.title_cd as title_cd
,t1.party_id as party_id
,t1.work_tel_inter_area_cd as work_tel_inter_area_cd
,t1.emply_id as emply_id
,t1.region_acct_num as region_acct_num

from ${idl_schema}.oass_pty_emply t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_emply.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
