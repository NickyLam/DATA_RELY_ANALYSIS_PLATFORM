: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_manage_change_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_manage_change_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(changetype,chr(10),''),chr(13),'') as changetype
,replace(replace(oldorgid,chr(10),''),chr(13),'') as oldorgid
,replace(replace(oldorgname,chr(10),''),chr(13),'') as oldorgname
,replace(replace(olduserid,chr(10),''),chr(13),'') as olduserid
,replace(replace(oldusername,chr(10),''),chr(13),'') as oldusername
,replace(replace(neworgid,chr(10),''),chr(13),'') as neworgid
,replace(replace(neworgname,chr(10),''),chr(13),'') as neworgname
,replace(replace(newuserid,chr(10),''),chr(13),'') as newuserid
,replace(replace(newusername,chr(10),''),chr(13),'') as newusername
,replace(replace(changereason,chr(10),''),chr(13),'') as changereason
,replace(replace(changeorgid,chr(10),''),chr(13),'') as changeorgid
,replace(replace(changeuserid,chr(10),''),chr(13),'') as changeuserid
,replace(replace(changetime,chr(10),''),chr(13),'') as changetime
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_manage_change 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_manage_change_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes