: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_osbs_ats_facverify_flow_f
CreateDate: 20230804
FileName:   ${iel_data_path}/osbs_ats_facverify_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.aff_flowno,chr(13),''),chr(10),'') as aff_flowno
,replace(replace(t1.aff_ecifno,chr(13),''),chr(10),'') as aff_ecifno
,replace(replace(t1.aff_state,chr(13),''),chr(10),'') as aff_state
,aff_verifycount
,replace(replace(t1.aff_createtime,chr(13),''),chr(10),'') as aff_createtime
,replace(replace(t1.aff_updatetime,chr(13),''),chr(10),'') as aff_updatetime
,replace(replace(t1.aff_channel,chr(13),''),chr(10),'') as aff_channel
,replace(replace(t1.aff_trantype,chr(13),''),chr(10),'') as aff_trantype

from ${iol_schema}.osbs_ats_facverify_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_ats_facverify_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
