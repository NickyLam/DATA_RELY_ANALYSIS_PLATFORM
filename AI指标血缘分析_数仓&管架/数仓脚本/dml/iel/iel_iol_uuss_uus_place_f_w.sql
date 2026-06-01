: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_place_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/uuss_uus_place_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(placecode,chr(10),''),chr(13),'') as placecode
,replace(replace(placename,chr(10),''),chr(13),'') as placename
,replace(replace(placetypecode,chr(10),''),chr(13),'') as placetypecode
,replace(replace(enablestate,chr(10),''),chr(13),'') as enablestate
,replace(replace(currdate,chr(10),''),chr(13),'') as currdate
,replace(replace(currtime,chr(10),''),chr(13),'') as currtime
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(updatetime,chr(10),''),chr(13),'') as updatetime
,replace(replace(createuser,chr(10),''),chr(13),'') as createuser
,replace(replace(updateuser,chr(10),''),chr(13),'') as updateuser
,start_dt
,end_dt
,id_mark
,etl_timestamp
from  ${iol_schema}.uuss_uus_place
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_place_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes