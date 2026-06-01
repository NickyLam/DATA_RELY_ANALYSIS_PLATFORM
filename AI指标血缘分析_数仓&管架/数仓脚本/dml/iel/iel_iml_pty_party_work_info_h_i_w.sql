: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_work_info_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_work_info_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
,replace(replace(t.corp_bl_induty_type_cd,chr(13),''),chr(10),'') as corp_bl_induty_type_cd
,replace(replace(t.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t.work_unit_addr,chr(13),''),chr(10),'') as work_unit_addr
,replace(replace(t.work_unit_name,chr(13),''),chr(10),'') as work_unit_name
,replace(replace(t.work_unit_char_cd,chr(13),''),chr(10),'') as work_unit_char_cd
,t.work_mon_inco as work_mon_inco
,t.anl_inco as anl_inco
,t.employ_year_cnt as employ_year_cnt
,replace(replace(t.emply_status_cd,chr(13),''),chr(10),'') as emply_status_cd
,t.dimission_dt as dimission_dt
,t.empyt_dt as empyt_dt
,replace(replace(t.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t.title_cd,chr(13),''),chr(10),'') as title_cd
,replace(replace(t.post_cd,chr(13),''),chr(10),'') as post_cd
,replace(replace(t.career_cd,chr(13),''),chr(10),'') as career_cd
,t.corp_work_start_year as corp_work_start_year
,replace(replace(t.corp_iac_que_rest_cd,chr(13),''),chr(10),'') as corp_iac_que_rest_cd
,t.corp_rgst_dt as corp_rgst_dt
,t.corp_rgst_cap_gold as corp_rgst_cap_gold
,replace(replace(t.work_unit_sspf_flg,chr(13),''),chr(10),'') as work_unit_sspf_flg
,replace(replace(t.work_record_cd,chr(13),''),chr(10),'') as work_record_cd
,replace(replace(t.work_char_cd,chr(13),''),chr(10),'') as work_char_cd
,replace(replace(t.employ_type_cd,chr(13),''),chr(10),'') as employ_type_cd
,replace(replace(t.indus_risk_cate_cd,chr(13),''),chr(10),'') as indus_risk_cate_cd
,replace(replace(t.trading_corp_flg,chr(13),''),chr(10),'') as trading_corp_flg
,t.curr_indus_obtain_emply_years as curr_indus_obtain_emply_years
,t.serving_years as serving_years
,replace(replace(t.local_dept,chr(13),''),chr(10),'') as local_dept
,replace(replace(t.other_career,chr(13),''),chr(10),'') as other_career
,t.now_corp_work_years as now_corp_work_years
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.pty_party_work_info_h t 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_work_info_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes