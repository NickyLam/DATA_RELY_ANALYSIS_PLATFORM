: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tbnd_ext_rating_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_tbnd_ext_rating_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(b_grade,chr(10),''),chr(13),'') as b_grade
,replace(replace(b_rating_institution,chr(10),''),chr(13),'') as b_rating_institution
,replace(replace(beg_date,chr(10),''),chr(13),'') as beg_date
,replace(replace(end_date,chr(10),''),chr(13),'') as end_date
,replace(replace(rating_type,chr(10),''),chr(13),'') as rating_type
,replace(replace(imp_date,chr(10),''),chr(13),'') as imp_date
,replace(replace(pipe_id,chr(10),''),chr(13),'') as pipe_id
,replace(replace(b_id,chr(10),''),chr(13),'') as b_id
,replace(replace(outlook,chr(10),''),chr(13),'') as outlook
,replace(replace(shadow_grade,chr(10),''),chr(13),'') as shadow_grade
,replace(replace(b_rating_change,chr(10),''),chr(13),'') as b_rating_change
,etl_dt
,etl_timestamp
from iol.ibms_tbnd_ext_rating 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tbnd_ext_rating_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes