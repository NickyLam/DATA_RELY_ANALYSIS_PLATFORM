: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_uus_tellerno_f
CreateDate: 20221021
FileName:   ${iel_data_path}/uuss_uus_tellerno.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(employeeid,chr(13),''),chr(10),'')
,replace(replace(tellermanagerid,chr(13),''),chr(10),'')
,replace(replace(attachorgan,chr(13),''),chr(10),'')
,replace(replace(tellerno,chr(13),''),chr(10),'')
,replace(replace(tellerlevel,chr(13),''),chr(10),'')
,replace(replace(organcode,chr(13),''),chr(10),'')
,replace(replace(status,chr(13),''),chr(10),'')
,replace(replace(userna,chr(13),''),chr(10),'')
,replace(replace(ussatg,chr(13),''),chr(10),'')
,replace(replace(lastlg,chr(13),''),chr(10),'')
,replace(replace(lstrdt,chr(13),''),chr(10),'')
,replace(replace(usertp,chr(13),''),chr(10),'')
,replace(replace(menugp,chr(13),''),chr(10),'')

from ${iol_schema}.uuss_uus_tellerno t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_uus_tellerno.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
