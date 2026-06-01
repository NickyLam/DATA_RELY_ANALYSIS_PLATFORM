: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_flow_task_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_flow_task_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(relativeserialno,chr(10),''),chr(13),'') as relativeserialno
,replace(replace(flowno,chr(10),''),chr(13),'') as flowno
,replace(replace(flowname,chr(10),''),chr(13),'') as flowname
,replace(replace(phaseno,chr(10),''),chr(13),'') as phaseno
,replace(replace(phasename,chr(10),''),chr(13),'') as phasename
,replace(replace(phasetype,chr(10),''),chr(13),'') as phasetype
,replace(replace(applytype,chr(10),''),chr(13),'') as applytype
,replace(replace(userid,chr(10),''),chr(13),'') as userid
,replace(replace(username,chr(10),''),chr(13),'') as username
,replace(replace(orgid,chr(10),''),chr(13),'') as orgid
,replace(replace(orgname,chr(10),''),chr(13),'') as orgname
,replace(replace(begintime,chr(10),''),chr(13),'') as begintime
,replace(replace(endtime,chr(10),''),chr(13),'') as endtime
,replace(replace(phasechoice,chr(10),''),chr(13),'') as phasechoice
,replace(replace(phaseaction,chr(10),''),chr(13),'') as phaseaction
,replace(replace(phaseopinion,chr(10),''),chr(13),'') as phaseopinion
,replace(replace(phaseopinion1,chr(10),''),chr(13),'') as phaseopinion1
,replace(replace(phaseopinion2,chr(10),''),chr(13),'') as phaseopinion2
,replace(replace(phaseopinion3,chr(10),''),chr(13),'') as phaseopinion3
,replace(replace(phaseopinion4,chr(10),''),chr(13),'') as phaseopinion4
,replace(replace(checklistresult,chr(10),''),chr(13),'') as checklistresult
,replace(replace(autodecision,chr(10),''),chr(13),'') as autodecision
,replace(replace(riskscanresult,chr(10),''),chr(13),'') as riskscanresult
,replace(replace(standardtime1,chr(10),''),chr(13),'') as standardtime1
,replace(replace(standardtime2,chr(10),''),chr(13),'') as standardtime2
,replace(replace(costlob,chr(10),''),chr(13),'') as costlob
,replace(replace(clientx,chr(10),''),chr(13),'') as clientx
,replace(replace(clienty,chr(10),''),chr(13),'') as clienty
,replace(replace(width,chr(10),''),chr(13),'') as width
,replace(replace(heigth,chr(10),''),chr(13),'') as heigth
,replace(replace(groupinfo,chr(10),''),chr(13),'') as groupinfo
,replace(replace(actualbegintime,chr(10),''),chr(13),'') as actualbegintime
,replace(replace(untreadflag,chr(10),''),chr(13),'') as untreadflag
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_flow_task 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_flow_task_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes