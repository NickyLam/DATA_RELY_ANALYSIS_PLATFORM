: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_afa_comminfo_f
CreateDate: 20221021
FileName:   ${iel_data_path}/uuss_afa_comminfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(sendersysid,chr(13),''),chr(10),'')
,replace(replace(recversysid,chr(13),''),chr(10),'')
,replace(replace(itemname,chr(13),''),chr(10),'')
,replace(replace(serverip,chr(13),''),chr(10),'')
,replace(replace(serverport,chr(13),''),chr(10),'')
,replace(replace(conntimeout,chr(13),''),chr(10),'')
,replace(replace(transtimeout,chr(13),''),chr(10),'')
,replace(replace(encoding,chr(13),''),chr(10),'')
,replace(replace(remark,chr(13),''),chr(10),'')
,replace(replace(status,chr(13),''),chr(10),'')

from ${iol_schema}.uuss_afa_comminfo t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_afa_comminfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
