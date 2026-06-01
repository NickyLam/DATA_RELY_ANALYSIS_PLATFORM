: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_flow_task_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_flow_task.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
    ,replace(replace(t.objectno,chr(13),''),chr(10),'') as objectno
    ,replace(replace(t.objecttype,chr(13),''),chr(10),'') as objecttype
    ,replace(replace(t.relativeserialno,chr(13),''),chr(10),'') as relativeserialno
    ,replace(replace(t.flowno,chr(13),''),chr(10),'') as flowno
    ,replace(replace(t.flowname,chr(13),''),chr(10),'') as flowname
    ,replace(replace(t.phaseno,chr(13),''),chr(10),'') as phaseno
    ,replace(replace(t.phasename,chr(13),''),chr(10),'') as phasename
    ,replace(replace(t.phasetype,chr(13),''),chr(10),'') as phasetype
    ,replace(replace(t.applytype,chr(13),''),chr(10),'') as applytype
    ,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
    ,replace(replace(t.username,chr(13),''),chr(10),'') as username
    ,replace(replace(t.orgid,chr(13),''),chr(10),'') as orgid
    ,replace(replace(t.orgname,chr(13),''),chr(10),'') as orgname
    ,replace(replace(t.begintime,chr(13),''),chr(10),'') as begintime
    ,replace(replace(t.endtime,chr(13),''),chr(10),'') as endtime
    ,replace(replace(t.phasechoice,chr(13),''),chr(10),'') as phasechoice
    ,replace(replace(t.phaseaction,chr(13),''),chr(10),'') as phaseaction
    ,replace(replace(t.phaseopinion,chr(13),''),chr(10),'') as phaseopinion
    ,replace(replace(t.phaseopinion1,chr(13),''),chr(10),'') as phaseopinion1
    ,replace(replace(t.phaseopinion2,chr(13),''),chr(10),'') as phaseopinion2
    ,replace(replace(t.phaseopinion3,chr(13),''),chr(10),'') as phaseopinion3
    ,replace(replace(t.phaseopinion4,chr(13),''),chr(10),'') as phaseopinion4
    ,replace(replace(t.checklistresult,chr(13),''),chr(10),'') as checklistresult
    ,replace(replace(t.autodecision,chr(13),''),chr(10),'') as autodecision
    ,replace(replace(t.riskscanresult,chr(13),''),chr(10),'') as riskscanresult
    ,replace(replace(t.standardtime1,chr(13),''),chr(10),'') as standardtime1
    ,replace(replace(t.standardtime2,chr(13),''),chr(10),'') as standardtime2
    ,replace(replace(t.costlob,chr(13),''),chr(10),'') as costlob
    ,t.clientx as clientx
    ,t.clienty as clienty
    ,t.width as width
    ,t.heigth as heigth
    ,replace(replace(t.groupinfo,chr(13),''),chr(10),'') as groupinfo
    ,replace(replace(t.actualbegintime,chr(13),''),chr(10),'') as actualbegintime
    ,replace(replace(t.untreadflag,chr(13),''),chr(10),'') as untreadflag
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_flow_task t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_flow_task.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes