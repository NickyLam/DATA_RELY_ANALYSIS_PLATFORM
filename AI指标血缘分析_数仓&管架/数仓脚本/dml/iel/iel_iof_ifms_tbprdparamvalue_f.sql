: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ifms_tbprdparamvalue_f
CreateDate: 20251222
FileName:   ${iel_data_path}/ifms_tbprdparamvalue.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.table_name,chr(13),''),chr(10),'') as table_name
,replace(replace(t1.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t1.field_code,chr(13),''),chr(10),'') as field_code
,replace(replace(t1.field_value,chr(13),''),chr(10),'') as field_value
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.ifms_tbprdparamvalue t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbprdparamvalue.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
