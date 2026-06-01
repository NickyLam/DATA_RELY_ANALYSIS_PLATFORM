: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_bus_chn_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_bus_chn_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd
    ,replace(replace(t.chn_attr_group_id,chr(13),''),chr(10),'') as chn_attr_group_id
    ,replace(replace(t.chn_name,chr(13),''),chr(10),'') as chn_name
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.ref_bus_chn_para t
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_bus_chn_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes