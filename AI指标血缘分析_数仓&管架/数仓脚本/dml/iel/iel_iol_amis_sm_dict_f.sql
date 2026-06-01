: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amis_sm_dict_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amis_sm_dict.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.sm_dict_uuid,chr(13),''),chr(10),'') as sm_dict_uuid
    ,replace(replace(t.dict_code,chr(13),''),chr(10),'') as dict_code
    ,replace(replace(t.dict_name,chr(13),''),chr(10),'') as dict_name
    ,replace(replace(t.dict_desc,chr(13),''),chr(10),'') as dict_desc
    ,t.edit as edit
    ,t.del_flag as del_flag
    ,replace(replace(t.create_person_uuid,chr(13),''),chr(10),'') as create_person_uuid
    ,replace(replace(t.create_person_name,chr(13),''),chr(10),'') as create_person_name
    ,replace(replace(t.create_org_name,chr(13),''),chr(10),'') as create_org_name
    ,t.create_time as create_time
    ,replace(replace(t.edit_desc,chr(13),''),chr(10),'') as edit_desc
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amis_sm_dict t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amis_sm_dict.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes