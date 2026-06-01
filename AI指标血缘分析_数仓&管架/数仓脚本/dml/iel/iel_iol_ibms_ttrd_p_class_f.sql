: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_p_class_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_p_class.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.id as id
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,replace(replace(t1.p_type,chr(13),''),chr(10),'') as p_type
,replace(replace(t1.p_type_name,chr(13),''),chr(10),'') as p_type_name
,t1.in_sys_process as in_sys_process
,replace(replace(t1.trdtype,chr(13),''),chr(10),'') as trdtype
,replace(replace(t1.acting_type,chr(13),''),chr(10),'') as acting_type
,replace(replace(t1.p_class_code,chr(13),''),chr(10),'') as p_class_code

from ${iol_schema}.ibms_ttrd_p_class t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_p_class.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
