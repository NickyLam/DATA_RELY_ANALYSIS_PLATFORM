: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_flow_object_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_flow_object.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.objecttype,chr(13),''),chr(10),'') as objecttype
    ,replace(replace(t.objectno,chr(13),''),chr(10),'') as objectno
    ,replace(replace(t.phasetype,chr(13),''),chr(10),'') as phasetype
    ,replace(replace(t.applytype,chr(13),''),chr(10),'') as applytype
    ,replace(replace(t.flowno,chr(13),''),chr(10),'') as flowno
    ,replace(replace(t.flowname,chr(13),''),chr(10),'') as flowname
    ,replace(replace(t.phaseno,chr(13),''),chr(10),'') as phaseno
    ,replace(replace(t.phasename,chr(13),''),chr(10),'') as phasename
    ,replace(replace(t.objdescribe,chr(13),''),chr(10),'') as objdescribe
    ,replace(replace(t.objattribute1,chr(13),''),chr(10),'') as objattribute1
    ,replace(replace(t.objattribute2,chr(13),''),chr(10),'') as objattribute2
    ,replace(replace(t.objattribute3,chr(13),''),chr(10),'') as objattribute3
    ,replace(replace(t.objattribute4,chr(13),''),chr(10),'') as objattribute4
    ,replace(replace(t.objattribute5,chr(13),''),chr(10),'') as objattribute5
    ,replace(replace(t.orgid,chr(13),''),chr(10),'') as orgid
    ,replace(replace(t.orgname,chr(13),''),chr(10),'') as orgname
    ,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
    ,replace(replace(t.username,chr(13),''),chr(10),'') as username
    ,replace(replace(t.inputdate,chr(13),''),chr(10),'') as inputdate
    ,replace(replace(t.archivetime,chr(13),''),chr(10),'') as archivetime
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_flow_object t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_flow_object.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes