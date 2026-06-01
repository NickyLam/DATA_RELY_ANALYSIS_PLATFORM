: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_security_rating_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_security_rating_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(security_code,chr(10),''),chr(13),'') as security_code
,replace(replace(firm_id,chr(10),''),chr(13),'') as firm_id
,replace(replace(rating,chr(10),''),chr(13),'') as rating
,replace(replace(modify_time,chr(10),''),chr(13),'') as modify_time
,replace(replace(rating_date,chr(10),''),chr(13),'') as rating_date
,replace(replace(rating_category,chr(10),''),chr(13),'') as rating_category
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ctms_tbs_v_security_rating
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_security_rating_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes