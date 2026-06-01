: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_flow_model_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_flow_model.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.flowno,chr(13),''),chr(10),'') as flowno
    ,replace(replace(t.phaseno,chr(13),''),chr(10),'') as phaseno
    ,replace(replace(t.phasetype,chr(13),''),chr(10),'') as phasetype
    ,replace(replace(t.phasename,chr(13),''),chr(10),'') as phasename
    ,replace(replace(t.phasedescribe,chr(13),''),chr(10),'') as phasedescribe
    ,replace(replace(t.phaseattribute,chr(13),''),chr(10),'') as phaseattribute
    ,replace(replace(t.prescript,chr(13),''),chr(10),'') as prescript
    ,replace(replace(t.initscript,chr(13),''),chr(10),'') as initscript
    ,replace(replace(t.choicedescribe,chr(13),''),chr(10),'') as choicedescribe
    ,replace(replace(t.choicescript,chr(13),''),chr(10),'') as choicescript
    ,replace(replace(t.actiondescribe,chr(13),''),chr(10),'') as actiondescribe
    ,replace(replace(t.actionscript,chr(13),''),chr(10),'') as actionscript
    ,replace(replace(t.postscript,chr(13),''),chr(10),'') as postscript
    ,replace(replace(t.attribute1,chr(13),''),chr(10),'') as attribute1
    ,replace(replace(t.attribute2,chr(13),''),chr(10),'') as attribute2
    ,replace(replace(t.attribute3,chr(13),''),chr(10),'') as attribute3
    ,replace(replace(t.attribute4,chr(13),''),chr(10),'') as attribute4
    ,replace(replace(t.attribute5,chr(13),''),chr(10),'') as attribute5
    ,replace(replace(t.attribute6,chr(13),''),chr(10),'') as attribute6
    ,replace(replace(t.attribute7,chr(13),''),chr(10),'') as attribute7
    ,replace(replace(t.attribute8,chr(13),''),chr(10),'') as attribute8
    ,replace(replace(t.attribute9,chr(13),''),chr(10),'') as attribute9
    ,replace(replace(t.attribute10,chr(13),''),chr(10),'') as attribute10
    ,replace(replace(t.aaenabled,chr(13),''),chr(10),'') as aaenabled
    ,replace(replace(t.aapointinitscript,chr(13),''),chr(10),'') as aapointinitscript
    ,replace(replace(t.aapointcomp,chr(13),''),chr(10),'') as aapointcomp
    ,replace(replace(t.aapointcompurl,chr(13),''),chr(10),'') as aapointcompurl
    ,t.standardtime1 as standardtime1
    ,t.standardtime2 as standardtime2
    ,replace(replace(t.costlob,chr(13),''),chr(10),'') as costlob
    ,replace(replace(t.strips,chr(13),''),chr(10),'') as strips
    ,replace(replace(t.checklist,chr(13),''),chr(10),'') as checklist
    ,replace(replace(t.decisionscript,chr(13),''),chr(10),'') as decisionscript
    ,replace(replace(t.riskscanrule,chr(13),''),chr(10),'') as riskscanrule
    ,replace(replace(t.buttonset2,chr(13),''),chr(10),'') as buttonset2
    ,replace(replace(t.inputuser,chr(13),''),chr(10),'') as inputuser
    ,replace(replace(t.inputtime,chr(13),''),chr(10),'') as inputtime
    ,replace(replace(t.updateuser,chr(13),''),chr(10),'') as updateuser
    ,replace(replace(t.updatetime,chr(13),''),chr(10),'') as updatetime
    ,replace(replace(t.distributerule,chr(13),''),chr(10),'') as distributerule
    ,replace(replace(t.buttonset,chr(13),''),chr(10),'') as buttonset
    ,replace(replace(t.strips2,chr(13),''),chr(10),'') as strips2
    ,replace(replace(t.rightofevaluatemodel,chr(13),''),chr(10),'') as rightofevaluatemodel
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_flow_model t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_flow_model.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes