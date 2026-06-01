: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amis_sm_dict_param_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amis_sm_dict_param.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.sm_dict_param_uuid,chr(13),''),chr(10),'') as sm_dict_param_uuid
    ,replace(replace(t.sm_dict_uuid,chr(13),''),chr(10),'') as sm_dict_uuid
    ,replace(replace(t.dict_param_code,chr(13),''),chr(10),'') as dict_param_code
    ,replace(replace(t.dict_param_name,chr(13),''),chr(10),'') as dict_param_name
    ,replace(replace(t.dict_param_desc,chr(13),''),chr(10),'') as dict_param_desc
    ,t.dict_param_seq as dict_param_seq
    ,t.edit as edit
    ,t.del_flag as del_flag
    ,replace(replace(t.dict_param_ext1,chr(13),''),chr(10),'') as dict_param_ext1
    ,replace(replace(t.parent_uuid,chr(13),''),chr(10),'') as parent_uuid
    ,replace(replace(t.create_person_uuid,chr(13),''),chr(10),'') as create_person_uuid
    ,replace(replace(t.create_person_name,chr(13),''),chr(10),'') as create_person_name
    ,replace(replace(t.create_org_name,chr(13),''),chr(10),'') as create_org_name
    ,t.create_time as create_time
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amis_sm_dict_param t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amis_sm_dict_param.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes