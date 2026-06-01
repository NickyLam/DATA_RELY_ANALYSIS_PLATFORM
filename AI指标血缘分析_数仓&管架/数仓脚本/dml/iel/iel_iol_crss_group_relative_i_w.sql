: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_group_relative_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_group_relative_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(relativeid,chr(10),''),chr(13),'') as relativeid
,replace(replace(relationship,chr(10),''),chr(13),'') as relationship
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(jtglrelativetype,chr(10),''),chr(13),'') as jtglrelativetype
,replace(replace(otherjtrelative,chr(10),''),chr(13),'') as otherjtrelative
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_group_relative 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_group_relative_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes