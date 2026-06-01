: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_accounting_entry_def_f
CreateDate: 20221105
FileName:   ${iel_data_path}/ibms_ttrd_accounting_entry_def.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.as_id,chr(13),''),chr(10),'') as as_id
    ,replace(replace(t.acting_entry_name_1,chr(13),''),chr(10),'') as acting_entry_name_1
    ,replace(replace(t.acting_entry_name_2,chr(13),''),chr(10),'') as acting_entry_name_2
    ,replace(replace(t.acting_entry_name_3,chr(13),''),chr(10),'') as acting_entry_name_3
    ,replace(replace(t.acting_code,chr(13),''),chr(10),'') as acting_code
    ,replace(replace(t.property,chr(13),''),chr(10),'') as property
    ,replace(replace(t.entry_direction,chr(13),''),chr(10),'') as entry_direction
    ,replace(replace(t.acting_entry_code_1,chr(13),''),chr(10),'') as acting_entry_code_1
    ,replace(replace(t.acting_entry_code_2,chr(13),''),chr(10),'') as acting_entry_code_2
    ,replace(replace(t.acting_entry_code_3,chr(13),''),chr(10),'') as acting_entry_code_3
    ,replace(replace(t.entry_type_3,chr(13),''),chr(10),'') as entry_type_3
    ,replace(replace(t.entry_type,chr(13),''),chr(10),'') as entry_type
    ,replace(replace(t.entry_type_1,chr(13),''),chr(10),'') as entry_type_1
    ,replace(replace(t.entry_type_2,chr(13),''),chr(10),'') as entry_type_2
    ,replace(replace(t.entry_type_4,chr(13),''),chr(10),'') as entry_type_4
    ,replace(replace(t.entry_type_5,chr(13),''),chr(10),'') as entry_type_5
    ,replace(replace(t.gzb_type,chr(13),''),chr(10),'') as gzb_type
    ,replace(replace(t.acting_entry_name_4,chr(13),''),chr(10),'') as acting_entry_name_4
    ,replace(replace(t.acting_entry_name_5,chr(13),''),chr(10),'') as acting_entry_name_5
    ,replace(replace(t.acting_entry_code_4,chr(13),''),chr(10),'') as acting_entry_code_4
    ,replace(replace(t.acting_entry_code_5,chr(13),''),chr(10),'') as acting_entry_code_5
    ,replace(replace(t.entry_type_6,chr(13),''),chr(10),'') as entry_type_6
    ,replace(replace(t.entry_type_7,chr(13),''),chr(10),'') as entry_type_7
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ibms_ttrd_accounting_entry_def t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_accounting_entry_def.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes