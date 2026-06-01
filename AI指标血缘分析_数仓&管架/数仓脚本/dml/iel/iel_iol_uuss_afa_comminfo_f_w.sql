: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uuss_afa_comminfo_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/uuss_afa_comminfo_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(sendersysid,chr(10),''),chr(13),'') as sendersysid
,replace(replace(recversysid,chr(10),''),chr(13),'') as recversysid
,replace(replace(itemname,chr(10),''),chr(13),'') as itemname
,replace(replace(serverip,chr(10),''),chr(13),'') as serverip
,replace(replace(serverport,chr(10),''),chr(13),'') as serverport
,replace(replace(conntimeout,chr(10),''),chr(13),'') as conntimeout
,replace(replace(transtimeout,chr(10),''),chr(13),'') as transtimeout
,replace(replace(encoding,chr(10),''),chr(13),'') as encoding
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(status,chr(10),''),chr(13),'') as status
,start_dt
,end_dt
,id_mark
,etl_timestamp
from  ${iol_schema}.uuss_afa_comminfo
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uuss_afa_comminfo_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes