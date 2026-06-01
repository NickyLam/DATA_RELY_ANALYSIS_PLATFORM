: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_control_type_def_f
CreateDate: 20240930
FileName:   ${iel_data_path}/ncbs_rb_control_type_def.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.manual_un_ctrl_flag,chr(13),''),chr(10),'') as manual_un_ctrl_flag
,replace(replace(t1.manual_ctrl_flag,chr(13),''),chr(10),'') as manual_ctrl_flag
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.control_type,chr(13),''),chr(10),'') as control_type
,replace(replace(t1.forbid_channels,chr(13),''),chr(10),'') as forbid_channels
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.control_class,chr(13),''),chr(10),'') as control_class
,replace(replace(t1.control_type_desc,chr(13),''),chr(10),'') as control_type_desc

from ${iol_schema}.ncbs_rb_control_type_def t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_control_type_def.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
