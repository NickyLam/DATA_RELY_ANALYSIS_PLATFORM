: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_flow_catalog_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_flow_catalog.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.flowno,chr(13),''),chr(10),'') as flowno
    ,replace(replace(t.flowname,chr(13),''),chr(10),'') as flowname
    ,replace(replace(t.flowtype,chr(13),''),chr(10),'') as flowtype
    ,replace(replace(t.flowdescribe,chr(13),''),chr(10),'') as flowdescribe
    ,replace(replace(t.initphase,chr(13),''),chr(10),'') as initphase
    ,replace(replace(t.aaenabled,chr(13),''),chr(10),'') as aaenabled
    ,replace(replace(t.aapolicy,chr(13),''),chr(10),'') as aapolicy
    ,replace(replace(t.viewfile,chr(13),''),chr(10),'') as viewfile
    ,t.viewfilelength as viewfilelength
    ,replace(replace(t.grouptitles,chr(13),''),chr(10),'') as grouptitles
from iol.crss_flow_catalog t
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_flow_catalog.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes