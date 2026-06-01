: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t1p_other_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t1p_other.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.type_id,chr(13),''),chr(10),'') as type_id
    ,replace(replace(t.type_name,chr(13),''),chr(10),'') as type_name
    ,replace(replace(t.code_id,chr(13),''),chr(10),'') as code_id
    ,replace(replace(t.code_name,chr(13),''),chr(10),'') as code_name
    ,replace(replace(t.code_desc,chr(13),''),chr(10),'') as code_desc
    ,replace(replace(t.is_valid,chr(13),''),chr(10),'') as is_valid
    ,replace(replace(t.create_tm,chr(13),''),chr(10),'') as create_tm
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,replace(replace(t.modify_tm,chr(13),''),chr(10),'') as modify_tm
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from iol.amls_t1p_other t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t1p_other.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes