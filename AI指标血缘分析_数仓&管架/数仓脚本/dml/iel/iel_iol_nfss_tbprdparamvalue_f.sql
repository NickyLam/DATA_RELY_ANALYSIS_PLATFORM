: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nfss_tbprdparamvalue_f
CreateDate: 20220104
FileName:   ${iel_data_path}/nfss_tbprdparamvalue.f.${batch_date}.dat
IF_mark:    f
Logs:
       sundexin
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.table_name,chr(13),''),chr(10),'') as table_name
,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t.field_code,chr(13),''),chr(10),'') as field_code
,replace(replace(t.field_value,chr(13),''),chr(10),'') as field_value
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.nfss_tbprdparamvalue t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_tbprdparamvalue.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes