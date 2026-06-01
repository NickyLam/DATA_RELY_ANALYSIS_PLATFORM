: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_flow_catalog_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_flow_catalog.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.flowno,chr(13),''),chr(10),'') as flowno
,replace(replace(t1.flowname,chr(13),''),chr(10),'') as flowname
,replace(replace(t1.flowtype,chr(13),''),chr(10),'') as flowtype
,replace(replace(t1.flowdescribe,chr(13),''),chr(10),'') as flowdescribe
,replace(replace(t1.initphase,chr(13),''),chr(10),'') as initphase
,replace(replace(t1.aaenabled,chr(13),''),chr(10),'') as aaenabled
,replace(replace(t1.aapolicy,chr(13),''),chr(10),'') as aapolicy
,t1.viewfilelength as viewfilelength
,replace(replace(t1.metaflowno,chr(13),''),chr(10),'') as metaflowno
,replace(replace(t1.isinuse,chr(13),''),chr(10),'') as isinuse
,replace(replace(t1.version,chr(13),''),chr(10),'') as version
,replace(replace(t1.baseflowno,chr(13),''),chr(10),'') as baseflowno
,replace(replace(t1.baseflowname,chr(13),''),chr(10),'') as baseflowname
,replace(replace(t1.grouptitles,chr(13),''),chr(10),'') as grouptitles
,replace(replace(t1.viewfile,chr(13),''),chr(10),'') as viewfile
,replace(replace(t1.flowbuttonset,chr(13),''),chr(10),'') as flowbuttonset
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,t1.updatedate as updatedate
,t1.inputdate as inputdate
from ${iol_schema}.icms_flow_catalog t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_flow_catalog.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes