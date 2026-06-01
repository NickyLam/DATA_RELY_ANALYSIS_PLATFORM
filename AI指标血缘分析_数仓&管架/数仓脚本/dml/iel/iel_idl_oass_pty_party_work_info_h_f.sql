: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_work_info_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_pty_party_work_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.sorc_sys_cd as sorc_sys_cd
,t1.corp_bl_induty_type_cd as corp_bl_induty_type_cd
,t1.tel_num as tel_num
,t1.work_unit_addr as work_unit_addr
,t1.work_unit_name as work_unit_name
,t1.work_unit_char_cd as work_unit_char_cd
,t1.work_mon_inco as work_mon_inco
,t1.anl_inco as anl_inco
,t1.employ_year_cnt as employ_year_cnt
,t1.emply_status_cd as emply_status_cd
,t1.dimission_dt as dimission_dt
,t1.empyt_dt as empyt_dt
,t1.zip_cd as zip_cd
,t1.title_cd as title_cd
,t1.post_cd as post_cd
,t1.career_cd as career_cd
,t1.corp_work_start_year as corp_work_start_year
,t1.corp_iac_que_rest_cd as corp_iac_que_rest_cd
,t1.corp_rgst_dt as corp_rgst_dt
,t1.corp_rgst_cap_gold as corp_rgst_cap_gold
,t1.work_unit_sspf_flg as work_unit_sspf_flg
,t1.work_record_cd as work_record_cd
,t1.work_char_cd as work_char_cd
,t1.employ_type_cd as employ_type_cd
,t1.indus_risk_cate_cd as indus_risk_cate_cd
,t1.trading_corp_flg as trading_corp_flg
,t1.curr_indus_obtain_emply_years as curr_indus_obtain_emply_years
,t1.serving_years as serving_years
,t1.local_dept as local_dept
,t1.other_career as other_career
,t1.now_corp_work_years as now_corp_work_years
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_party_work_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party_work_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
