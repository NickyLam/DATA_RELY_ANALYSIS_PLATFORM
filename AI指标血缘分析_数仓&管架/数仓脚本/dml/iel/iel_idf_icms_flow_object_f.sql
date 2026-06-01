: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_icms_flow_object_f
CreateDate: 20250514
FileName:   ${iel_data_path}/icms_flow_object.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.objecttype as objecttype
,t1.objectno as objectno
,t1.userid as userid
,t1.relativetaskno as relativetaskno
,t1.flowname as flowname
,t1.orgname as orgname
,t1.processinstno as processinstno
,t1.phasename as phasename
,t1.objattribute2 as objattribute2
,t1.applyno as applyno
,t1.baseflowno as baseflowno
,t1.flowno as flowno
,t1.objattribute5 as objattribute5
,t1.archivetime as archivetime
,t1.objattribute4 as objattribute4
,t1.username as username
,t1.orgid as orgid
,t1.objattribute1 as objattribute1
,t1.objattribute3 as objattribute3
,t1.flowstate as flowstate
,t1.processtaskno as processtaskno
,t1.serialno as serialno
,t1.phaseno as phaseno
,t1.objdescribe as objdescribe
,t1.applytype as applytype
,t1.tasktype as tasktype
,t1.migtflag as migtflag
,t1.phasetype as phasetype
,t1.archive as archive
,t1.version as version
,t1.inputdate as inputdate

from ${idl_schema}.icms_flow_object t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_flow_object.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
