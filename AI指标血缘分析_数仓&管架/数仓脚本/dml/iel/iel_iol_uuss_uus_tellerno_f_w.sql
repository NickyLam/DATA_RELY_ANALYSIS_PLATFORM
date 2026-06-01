: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_tellerno_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/uuss_uus_tellerno_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(employeeid,chr(10),''),chr(13),'') as employeeid
,replace(replace(tellermanagerid,chr(10),''),chr(13),'') as tellermanagerid
,replace(replace(attachorgan,chr(10),''),chr(13),'') as attachorgan
,replace(replace(tellerno,chr(10),''),chr(13),'') as tellerno
,replace(replace(tellerlevel,chr(10),''),chr(13),'') as tellerlevel
,replace(replace(organcode,chr(10),''),chr(13),'') as organcode
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(userna,chr(10),''),chr(13),'') as userna
,replace(replace(ussatg,chr(10),''),chr(13),'') as ussatg
,replace(replace(lastlg,chr(10),''),chr(13),'') as lastlg
,replace(replace(lstrdt,chr(10),''),chr(13),'') as lstrdt
,replace(replace(usertp,chr(10),''),chr(13),'') as usertp
,replace(replace(menugp,chr(10),''),chr(13),'') as menugp
,start_dt
,end_dt
,id_mark
,etl_timestamp
from  ${iol_schema}.uuss_uus_tellerno
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_tellerno_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes