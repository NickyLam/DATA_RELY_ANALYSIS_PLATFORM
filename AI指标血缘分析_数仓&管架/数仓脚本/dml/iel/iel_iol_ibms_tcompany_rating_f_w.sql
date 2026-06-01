: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_tcompany_rating_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_tcompany_rating_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(comp_name,chr(10),''),chr(13),'') as comp_name
,replace(replace(rating_type,chr(10),''),chr(13),'') as rating_type
,replace(replace(grade,chr(10),''),chr(13),'') as grade
,replace(replace(rating_institution,chr(10),''),chr(13),'') as rating_institution
,replace(replace(beg_date,chr(10),''),chr(13),'') as beg_date
,replace(replace(end_date,chr(10),''),chr(13),'') as end_date
,replace(replace(imp_date,chr(10),''),chr(13),'') as imp_date
,replace(replace(pipe_id,chr(10),''),chr(13),'') as pipe_id
,replace(replace(comp_code,chr(10),''),chr(13),'') as comp_code
,replace(replace(outlook,chr(10),''),chr(13),'') as outlook
,etl_dt
,etl_timestamp
from iol.ibms_tcompany_rating 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_tcompany_rating_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes