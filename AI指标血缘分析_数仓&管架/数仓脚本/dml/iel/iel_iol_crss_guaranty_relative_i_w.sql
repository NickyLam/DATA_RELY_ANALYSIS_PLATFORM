: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_guaranty_relative_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_guaranty_relative_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(contractno,chr(10),''),chr(13),'') as contractno
,replace(replace(guarantyid,chr(10),''),chr(13),'') as guarantyid
,replace(replace(channel,chr(10),''),chr(13),'') as channel
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(othersrightid,chr(10),''),chr(13),'') as othersrightid
,replace(replace(guarantysum,chr(10),''),chr(13),'') as guarantysum
,replace(replace(describe,chr(10),''),chr(13),'') as describe
,replace(replace(payorder,chr(10),''),chr(13),'') as payorder
,replace(replace(type,chr(10),''),chr(13),'') as type
,replace(replace(relationstatus,chr(10),''),chr(13),'') as relationstatus
,replace(replace(isinuse,chr(10),''),chr(13),'') as isinuse
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_guaranty_relative 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_guaranty_relative_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes