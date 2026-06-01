: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amis_ac_dispatch_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amis_ac_dispatch.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.ac_dispatch_uuid,chr(13),''),chr(10),'') as ac_dispatch_uuid
    ,replace(replace(t.dispatch_no,chr(13),''),chr(10),'') as dispatch_no
    ,replace(replace(t.dispatch_title,chr(13),''),chr(10),'') as dispatch_title
    ,replace(replace(t.dispatch_deaprtment_uuid,chr(13),''),chr(10),'') as dispatch_deaprtment_uuid
    ,replace(replace(t.dispatch_deaprtment_name,chr(13),''),chr(10),'') as dispatch_deaprtment_name
    ,t.dispath_time as dispath_time
    ,replace(replace(t.pm_asset_uuid,chr(13),''),chr(10),'') as pm_asset_uuid
    ,replace(replace(t.pm_asset_name,chr(13),''),chr(10),'') as pm_asset_name
    ,replace(replace(t.pm_problem_uuid,chr(13),''),chr(10),'') as pm_problem_uuid
    ,replace(replace(t.pm_problem_name,chr(13),''),chr(10),'') as pm_problem_name
    ,replace(replace(t.entry_person_uuid,chr(13),''),chr(10),'') as entry_person_uuid
    ,replace(replace(t.entry_person_name,chr(13),''),chr(10),'') as entry_person_name
    ,replace(replace(t.entry_org_uuid,chr(13),''),chr(10),'') as entry_org_uuid
    ,replace(replace(t.entry_org_name,chr(13),''),chr(10),'') as entry_org_name
    ,t.deleted as deleted
    ,replace(replace(t.ac_project_uuid,chr(13),''),chr(10),'') as ac_project_uuid
    ,t.create_time as create_time
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amis_ac_dispatch t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amis_ac_dispatch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes