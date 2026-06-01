: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_vs_keepfolder_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_vs_keepfolder.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.keepfolder_id as keepfolder_id
,t1.aspclient_id as aspclient_id
,replace(replace(t1.keepfolder_code,chr(13),''),chr(10),'') as keepfolder_code
,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'') as keepfolder_shortname
,t1.lastmodified as lastmodified
,replace(replace(t1.costmethod,chr(13),''),chr(10),'') as costmethod
,t1.calcdayenddate1 as calcdayenddate1
,t1.calcdayenddate2 as calcdayenddate2
,replace(replace(t1.controlfactor,chr(13),''),chr(10),'') as controlfactor
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.ctms_tbs_vs_keepfolder t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_vs_keepfolder.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes