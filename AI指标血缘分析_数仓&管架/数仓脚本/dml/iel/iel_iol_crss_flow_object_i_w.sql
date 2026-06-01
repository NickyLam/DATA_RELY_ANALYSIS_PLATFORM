: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_flow_object_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_flow_object_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(phasetype,chr(10),''),chr(13),'') as phasetype
,replace(replace(applytype,chr(10),''),chr(13),'') as applytype
,replace(replace(flowno,chr(10),''),chr(13),'') as flowno
,replace(replace(flowname,chr(10),''),chr(13),'') as flowname
,replace(replace(phaseno,chr(10),''),chr(13),'') as phaseno
,replace(replace(phasename,chr(10),''),chr(13),'') as phasename
,replace(replace(objdescribe,chr(10),''),chr(13),'') as objdescribe
,replace(replace(objattribute1,chr(10),''),chr(13),'') as objattribute1
,replace(replace(objattribute2,chr(10),''),chr(13),'') as objattribute2
,replace(replace(objattribute3,chr(10),''),chr(13),'') as objattribute3
,replace(replace(objattribute4,chr(10),''),chr(13),'') as objattribute4
,replace(replace(objattribute5,chr(10),''),chr(13),'') as objattribute5
,replace(replace(orgid,chr(10),''),chr(13),'') as orgid
,replace(replace(orgname,chr(10),''),chr(13),'') as orgname
,replace(replace(userid,chr(10),''),chr(13),'') as userid
,replace(replace(username,chr(10),''),chr(13),'') as username
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(archivetime,chr(10),''),chr(13),'') as archivetime
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_flow_object 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_flow_object_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes