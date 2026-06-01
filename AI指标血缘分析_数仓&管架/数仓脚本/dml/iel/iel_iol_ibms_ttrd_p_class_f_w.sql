: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_p_class_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_p_class_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(id,chr(10),''),chr(13),'') as id
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(p_class,chr(10),''),chr(13),'') as p_class
,replace(replace(p_type,chr(10),''),chr(13),'') as p_type
,replace(replace(p_type_name,chr(10),''),chr(13),'') as p_type_name
,replace(replace(in_sys_process,chr(10),''),chr(13),'') as in_sys_process
,replace(replace(trdtype,chr(10),''),chr(13),'') as trdtype
,replace(replace(acting_type,chr(10),''),chr(13),'') as acting_type
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_p_class
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_p_class_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes