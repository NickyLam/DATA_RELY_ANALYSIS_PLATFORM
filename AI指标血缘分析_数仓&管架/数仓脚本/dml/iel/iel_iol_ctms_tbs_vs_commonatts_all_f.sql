: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_vs_commonatts_all_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_vs_commonatts_all.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.commonatts_id as commonatts_id
,t1.aspclient_id as aspclient_id
,replace(replace(t1.singleormulti,chr(13),''),chr(10),'') as singleormulti
,replace(replace(t1.commonatts_shortname,chr(13),''),chr(10),'') as commonatts_shortname
,replace(replace(t1.commonatts_desc,chr(13),''),chr(10),'') as commonatts_desc
,t1.commonatts_id_parent as commonatts_id_parent
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,t1.lastmodified as lastmodified
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.ctms_tbs_vs_commonatts_all t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_vs_commonatts_all.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes