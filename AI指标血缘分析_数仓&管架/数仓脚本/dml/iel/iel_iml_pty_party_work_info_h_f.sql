: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_work_info_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/pty_party_work_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(party_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(sorc_sys_cd,chr(13),''),chr(10),'')
,replace(replace(corp_bl_induty_type_cd,chr(13),''),chr(10),'')
,replace(replace(tel_num,chr(13),''),chr(10),'')
,replace(replace(work_unit_addr,chr(13),''),chr(10),'')
,replace(replace(work_unit_name,chr(13),''),chr(10),'')
,replace(replace(work_unit_char_cd,chr(13),''),chr(10),'')
,work_mon_inco
,anl_inco
,employ_year_cnt
,replace(replace(emply_status_cd,chr(13),''),chr(10),'')
,dimission_dt
,empyt_dt
,replace(replace(zip_cd,chr(13),''),chr(10),'')
,replace(replace(title_cd,chr(13),''),chr(10),'')
,replace(replace(post_cd,chr(13),''),chr(10),'')
,replace(replace(career_cd,chr(13),''),chr(10),'')
,corp_work_start_year
,replace(replace(corp_iac_que_rest_cd,chr(13),''),chr(10),'')
,corp_rgst_dt
,corp_rgst_cap_gold
,replace(replace(work_unit_sspf_flg,chr(13),''),chr(10),'')
,replace(replace(work_record_cd,chr(13),''),chr(10),'')
,replace(replace(work_char_cd,chr(13),''),chr(10),'')
,replace(replace(employ_type_cd,chr(13),''),chr(10),'')
,replace(replace(indus_risk_cate_cd,chr(13),''),chr(10),'')
,replace(replace(trading_corp_flg,chr(13),''),chr(10),'')
,curr_indus_obtain_emply_years
,serving_years
,replace(replace(local_dept,chr(13),''),chr(10),'')
,replace(replace(other_career,chr(13),''),chr(10),'')
,now_corp_work_years
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.pty_party_work_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_work_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
