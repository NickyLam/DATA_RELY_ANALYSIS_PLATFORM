: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_group_change_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_group_change_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(groupno,chr(10),''),chr(13),'') as groupno
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(changetype,chr(10),''),chr(13),'') as changetype
,replace(replace(oldname,chr(10),''),chr(13),'') as oldname
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(updateorgid,chr(10),''),chr(13),'') as updateorgid
,replace(replace(updateuserid,chr(10),''),chr(13),'') as updateuserid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(corp,chr(10),''),chr(13),'') as corp
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_group_change 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_group_change_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes