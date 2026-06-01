: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_flow_task_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_flow_task.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.relativeserialno,chr(13),''),chr(10),'') as relativeserialno
,replace(replace(t1.flowno,chr(13),''),chr(10),'') as flowno
,replace(replace(t1.flowname,chr(13),''),chr(10),'') as flowname
,replace(replace(t1.phaseno,chr(13),''),chr(10),'') as phaseno
,replace(replace(t1.phasename,chr(13),''),chr(10),'') as phasename
,replace(replace(t1.phasetype,chr(13),''),chr(10),'') as phasetype
,replace(replace(t1.applytype,chr(13),''),chr(10),'') as applytype
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.orgname,chr(13),''),chr(10),'') as orgname
,t1.begintime as begintime
,t1.endtime as endtime
,replace(replace(t1.phasechoice,chr(13),''),chr(10),'') as phasechoice
,replace(replace(t1.phaseaction,chr(13),''),chr(10),'') as phaseaction
,replace(replace(t1.phaseopinion1,chr(13),''),chr(10),'') as phaseopinion1
,replace(replace(t1.phaseopinion2,chr(13),''),chr(10),'') as phaseopinion2
,replace(replace(t1.phaseopinion3,chr(13),''),chr(10),'') as phaseopinion3
,replace(replace(t1.phaseopinion4,chr(13),''),chr(10),'') as phaseopinion4
,replace(replace(t1.checklistresult,chr(13),''),chr(10),'') as checklistresult
,replace(replace(t1.autodecision,chr(13),''),chr(10),'') as autodecision
,replace(replace(t1.riskscanresult,chr(13),''),chr(10),'') as riskscanresult
,t1.standardtime1 as standardtime1
,t1.standardtime2 as standardtime2
,replace(replace(t1.costlob,chr(13),''),chr(10),'') as costlob
,t1.clientx as clientx
,t1.clienty as clienty
,t1.width as width
,t1.heigth as heigth
,replace(replace(t1.relativeobjectno,chr(13),''),chr(10),'') as relativeobjectno
,replace(replace(t1.processinstno,chr(13),''),chr(10),'') as processinstno
,replace(replace(t1.processtaskno,chr(13),''),chr(10),'') as processtaskno
,replace(replace(t1.flowstate,chr(13),''),chr(10),'') as flowstate
,replace(replace(t1.assignedtaskno,chr(13),''),chr(10),'') as assignedtaskno
,replace(replace(t1.forkstate,chr(13),''),chr(10),'') as forkstate
,replace(replace(t1.taskstate,chr(13),''),chr(10),'') as taskstate
,replace(replace(t1.version,chr(13),''),chr(10),'') as version
,replace(replace(t1.baseflowno,chr(13),''),chr(10),'') as baseflowno
,replace(replace(t1.parentflowno,chr(13),''),chr(10),'') as parentflowno
,replace(replace(t1.forkno,chr(13),''),chr(10),'') as forkno
,replace(replace(t1.allforkno,chr(13),''),chr(10),'') as allforkno
,replace(replace(t1.relanoticeno,chr(13),''),chr(10),'') as relanoticeno
,replace(replace(t1.owner,chr(13),''),chr(10),'') as owner
,replace(replace(t1.phaseopinion,chr(13),''),chr(10),'') as phaseopinion
,replace(replace(t1.groupinfo,chr(13),''),chr(10),'') as groupinfo
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.icms_flow_task t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_flow_task.f.${batch_date}.dat" \
        charset=utf8
        safe=yes