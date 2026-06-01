: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pbms_tbl_dic_param_f
CreateDate: 20260408
FileName:   ${iel_data_path}/pbms_tbl_dic_param.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,pk_dic_param
,replace(replace(t1.param_code,chr(13),''),chr(10),'') as param_code
,replace(replace(t1.param_name,chr(13),''),chr(10),'') as param_name
,replace(replace(t1.param_desc,chr(13),''),chr(10),'') as param_desc
,param_order
,replace(replace(t1.parent_code,chr(13),''),chr(10),'') as parent_code
,replace(replace(t1.field1,chr(13),''),chr(10),'') as field1
,replace(replace(t1.crt_time,chr(13),''),chr(10),'') as crt_time
,replace(replace(t1.upd_time,chr(13),''),chr(10),'') as upd_time
,obj_version
,replace(replace(t1.flag_enable,chr(13),''),chr(10),'') as flag_enable
,replace(replace(t1.usage_key,chr(13),''),chr(10),'') as usage_key
,replace(replace(t1.param_desc2,chr(13),''),chr(10),'') as param_desc2
,replace(replace(t1.param_desc3,chr(13),''),chr(10),'') as param_desc3
,replace(replace(t1.param_system,chr(13),''),chr(10),'') as param_system
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.del_flag,chr(13),''),chr(10),'') as del_flag
,replace(replace(t1.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t1.updated_by,chr(13),''),chr(10),'') as updated_by

from ${iol_schema}.pbms_tbl_dic_param t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbms_tbl_dic_param.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
