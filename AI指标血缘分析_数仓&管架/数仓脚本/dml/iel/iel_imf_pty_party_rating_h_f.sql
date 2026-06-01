: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_party_rating_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_rating_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
,replace(replace(t1.party_rating_type_cd,chr(13),''),chr(10),'') as party_rating_type_cd
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,t1.start_dt as start_dt
,replace(replace(t1.rating_org_id,chr(13),''),chr(10),'') as rating_org_id
,replace(replace(t1.rating_org_name,chr(13),''),chr(10),'') as rating_org_name
,t1.rating_dt as rating_dt
,t1.rating_score_val as rating_score_val
,t1.rating_effect_dt as rating_effect_dt
,t1.rating_invalid_dt as rating_invalid_dt
,replace(replace(t1.rating_result_cd,chr(13),''),chr(10),'') as rating_result_cd
,replace(replace(t1.irs_task_flow_num,chr(13),''),chr(10),'') as irs_task_flow_num
,replace(replace(t1.rating_level_cd,chr(13),''),chr(10),'') as rating_level_cd
,t1.lmt as lmt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.pty_party_rating_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_rating_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes