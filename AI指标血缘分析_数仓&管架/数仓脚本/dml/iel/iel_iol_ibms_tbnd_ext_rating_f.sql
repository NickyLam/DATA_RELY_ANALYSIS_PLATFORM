: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tbnd_ext_rating_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_tbnd_ext_rating.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.b_grade,chr(13),''),chr(10),'') as b_grade
,replace(replace(t1.b_rating_institution,chr(13),''),chr(10),'') as b_rating_institution
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.rating_type,chr(13),''),chr(10),'') as rating_type
,replace(replace(t1.imp_date,chr(13),''),chr(10),'') as imp_date
,t1.pipe_id as pipe_id
,t1.b_id as b_id
,replace(replace(t1.outlook,chr(13),''),chr(10),'') as outlook
,replace(replace(t1.shadow_grade,chr(13),''),chr(10),'') as shadow_grade
,replace(replace(t1.b_rating_change,chr(13),''),chr(10),'') as b_rating_change

from ${iol_schema}.ibms_tbnd_ext_rating t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tbnd_ext_rating.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
