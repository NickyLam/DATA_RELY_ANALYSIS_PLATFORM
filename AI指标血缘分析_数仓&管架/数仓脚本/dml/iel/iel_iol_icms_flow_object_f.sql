: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_flow_object_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_flow_object.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.phasetype,chr(13),''),chr(10),'') as phasetype
,replace(replace(t1.applytype,chr(13),''),chr(10),'') as applytype
,replace(replace(t1.flowno,chr(13),''),chr(10),'') as flowno
,replace(replace(t1.flowname,chr(13),''),chr(10),'') as flowname
,replace(replace(t1.phaseno,chr(13),''),chr(10),'') as phaseno
,replace(replace(t1.phasename,chr(13),''),chr(10),'') as phasename
,replace(replace(t1.objdescribe,chr(13),''),chr(10),'') as objdescribe
,replace(replace(t1.objattribute1,chr(13),''),chr(10),'') as objattribute1
,replace(replace(t1.objattribute2,chr(13),''),chr(10),'') as objattribute2
,replace(replace(t1.objattribute3,chr(13),''),chr(10),'') as objattribute3
,replace(replace(t1.objattribute4,chr(13),''),chr(10),'') as objattribute4
,replace(replace(t1.objattribute5,chr(13),''),chr(10),'') as objattribute5
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.orgname,chr(13),''),chr(10),'') as orgname
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,t1.inputdate as inputdate
,t1.archivetime as archivetime
,replace(replace(t1.applyno,chr(13),''),chr(10),'') as applyno
,replace(replace(t1.flowstate,chr(13),''),chr(10),'') as flowstate
,replace(replace(t1.processinstno,chr(13),''),chr(10),'') as processinstno
,replace(replace(t1.processtaskno,chr(13),''),chr(10),'') as processtaskno
,replace(replace(t1.relativetaskno,chr(13),''),chr(10),'') as relativetaskno
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.tasktype,chr(13),''),chr(10),'') as tasktype
,replace(replace(t1.version,chr(13),''),chr(10),'') as version
,replace(replace(t1.baseflowno,chr(13),''),chr(10),'') as baseflowno
,replace(replace(t1.archive,chr(13),''),chr(10),'') as archive
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.icms_flow_object t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_flow_object.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes