: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_flow_model_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_flow_model.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.flowno,chr(13),''),chr(10),'') as flowno
,replace(replace(t1.phaseno,chr(13),''),chr(10),'') as phaseno
,replace(replace(t1.phasetype,chr(13),''),chr(10),'') as phasetype
,replace(replace(t1.phasename,chr(13),''),chr(10),'') as phasename
,replace(replace(t1.phasedescribe,chr(13),''),chr(10),'') as phasedescribe
,replace(replace(t1.phaseattribute,chr(13),''),chr(10),'') as phaseattribute
,replace(replace(t1.prescript,chr(13),''),chr(10),'') as prescript
,replace(replace(t1.initscript,chr(13),''),chr(10),'') as initscript
,replace(replace(t1.choicedescribe,chr(13),''),chr(10),'') as choicedescribe
,replace(replace(t1.choicescript,chr(13),''),chr(10),'') as choicescript
,replace(replace(t1.actiondescribe,chr(13),''),chr(10),'') as actiondescribe
,replace(replace(t1.actionscript,chr(13),''),chr(10),'') as actionscript
,replace(replace(t1.postscript,chr(13),''),chr(10),'') as postscript
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.attribute2,chr(13),''),chr(10),'') as attribute2
,replace(replace(t1.attribute3,chr(13),''),chr(10),'') as attribute3
,replace(replace(t1.attribute4,chr(13),''),chr(10),'') as attribute4
,replace(replace(t1.attribute5,chr(13),''),chr(10),'') as attribute5
,replace(replace(t1.attribute6,chr(13),''),chr(10),'') as attribute6
,replace(replace(t1.attribute7,chr(13),''),chr(10),'') as attribute7
,replace(replace(t1.attribute8,chr(13),''),chr(10),'') as attribute8
,replace(replace(t1.attribute9,chr(13),''),chr(10),'') as attribute9
,replace(replace(t1.attribute10,chr(13),''),chr(10),'') as attribute10
,replace(replace(t1.aaenabled,chr(13),''),chr(10),'') as aaenabled
,replace(replace(t1.aapointinitscript,chr(13),''),chr(10),'') as aapointinitscript
,replace(replace(t1.aapointcomp,chr(13),''),chr(10),'') as aapointcomp
,replace(replace(t1.aapointcompurl,chr(13),''),chr(10),'') as aapointcompurl
,t1.standardtime1 as standardtime1
,t1.standardtime2 as standardtime2
,replace(replace(t1.costlob,chr(13),''),chr(10),'') as costlob
,replace(replace(t1.strips,chr(13),''),chr(10),'') as strips
,replace(replace(t1.checklist,chr(13),''),chr(10),'') as checklist
,replace(replace(t1.decisionscript,chr(13),''),chr(10),'') as decisionscript
,replace(replace(t1.riskscanrule,chr(13),''),chr(10),'') as riskscanrule
,replace(replace(t1.buttonset2,chr(13),''),chr(10),'') as buttonset2
,replace(replace(t1.inputuser,chr(13),''),chr(10),'') as inputuser
,replace(replace(t1.inputtime,chr(13),''),chr(10),'') as inputtime
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,replace(replace(t1.updatetime,chr(13),''),chr(10),'') as updatetime
,replace(replace(t1.distributerule,chr(13),''),chr(10),'') as distributerule
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.xcoordinate,chr(13),''),chr(10),'') as xcoordinate
,replace(replace(t1.ycoordinate,chr(13),''),chr(10),'') as ycoordinate
,replace(replace(t1.width,chr(13),''),chr(10),'') as width
,replace(replace(t1.height,chr(13),''),chr(10),'') as height
,replace(replace(t1.version,chr(13),''),chr(10),'') as version
,replace(replace(t1.swimlane,chr(13),''),chr(10),'') as swimlane
,replace(replace(t1.flowphasecontext,chr(13),''),chr(10),'') as flowphasecontext
,replace(replace(t1.nodetype,chr(13),''),chr(10),'') as nodetype
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.continuecondition,chr(13),''),chr(10),'') as continuecondition
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.icms_flow_model t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_flow_model.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes