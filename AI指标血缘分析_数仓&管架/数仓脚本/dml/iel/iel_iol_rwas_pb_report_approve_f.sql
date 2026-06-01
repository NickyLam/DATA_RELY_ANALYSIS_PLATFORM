: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rwas_pb_report_approve_f
CreateDate: 20240929
FileName:   ${iel_data_path}/rwas_pb_report_approve.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.item_cd,chr(13),''),chr(10),'') as item_cd
,replace(replace(t1.item_name,chr(13),''),chr(10),'') as item_name
,replace(replace(t1.data_date,chr(13),''),chr(10),'') as data_date
,replace(replace(t1.solo_no,chr(13),''),chr(10),'') as solo_no
,replace(replace(t1.org_cd,chr(13),''),chr(10),'') as org_cd
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.version,chr(13),''),chr(10),'') as version
,version_status
,replace(replace(t1.operate_dt,chr(13),''),chr(10),'') as operate_dt
,replace(replace(t1.operate_id,chr(13),''),chr(10),'') as operate_id
,replace(replace(t1.operate_name,chr(13),''),chr(10),'') as operate_name
,replace(replace(t1.flow_starter_id,chr(13),''),chr(10),'') as flow_starter_id
,replace(replace(t1.flow_starter_name,chr(13),''),chr(10),'') as flow_starter_name
,replace(replace(t1.approve_remark,chr(13),''),chr(10),'') as approve_remark
,replace(replace(t1.catalog_id,chr(13),''),chr(10),'') as catalog_id

from ${iol_schema}.rwas_pb_report_approve t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rwas_pb_report_approve.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
