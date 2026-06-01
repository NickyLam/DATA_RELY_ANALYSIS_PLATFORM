: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_tk_management_params_f
CreateDate: 20250724
FileName:   ${iel_data_path}/icms_tk_management_params.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.messagetype,chr(13),''),chr(10),'') as messagetype
,replace(replace(t1.paramtype,chr(13),''),chr(10),'') as paramtype
,replace(replace(t1.paramkey,chr(13),''),chr(10),'') as paramkey
,replace(replace(t1.paramvalue,chr(13),''),chr(10),'') as paramvalue

from ${iol_schema}.icms_tk_management_params t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_tk_management_params.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
