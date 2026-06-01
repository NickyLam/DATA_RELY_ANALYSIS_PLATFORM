: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amis_ac_project_punishment_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amis_ac_project_punishment.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.ac_project_punishment_uuid,chr(13),''),chr(10),'') as ac_project_punishment_uuid
    ,replace(replace(t.nishment_code,chr(13),''),chr(10),'') as nishment_code
    ,replace(replace(t.ac_project_uuid,chr(13),''),chr(10),'') as ac_project_uuid
    ,replace(replace(t.personduty_name,chr(13),''),chr(10),'') as personduty_name
    ,replace(replace(t.ac_personduty_uuid,chr(13),''),chr(10),'') as ac_personduty_uuid
    ,replace(replace(t.old_orgname,chr(13),''),chr(10),'') as old_orgname
    ,replace(replace(t.old_station,chr(13),''),chr(10),'') as old_station
    ,replace(replace(t.curr_org_uuid,chr(13),''),chr(10),'') as curr_org_uuid
    ,replace(replace(t.curr_org_name,chr(13),''),chr(10),'') as curr_org_name
    ,replace(replace(t.curr_station,chr(13),''),chr(10),'') as curr_station
    ,replace(replace(t.ac_project_name,chr(13),''),chr(10),'') as ac_project_name
    ,replace(replace(t.account_number,chr(13),''),chr(10),'') as account_number
    ,replace(replace(t.dispatch_uuid,chr(13),''),chr(10),'') as dispatch_uuid
    ,replace(replace(t.dispatch_name,chr(13),''),chr(10),'') as dispatch_name
    ,replace(replace(t.dispatch_org,chr(13),''),chr(10),'') as dispatch_org
    ,t.dispatch_time as dispatch_time
    ,replace(replace(t.punishment_type,chr(13),''),chr(10),'') as punishment_type
    ,replace(replace(t.disciplinary_punishment,chr(13),''),chr(10),'') as disciplinary_punishment
    ,replace(replace(t.economic_punishment,chr(13),''),chr(10),'') as economic_punishment
    ,replace(replace(t.organization_punishment,chr(13),''),chr(10),'') as organization_punishment
    ,replace(replace(t.other_punishment,chr(13),''),chr(10),'') as other_punishment
    ,replace(replace(t.exemption_punishment,chr(13),''),chr(10),'') as exemption_punishment
    ,replace(replace(t.punishment_reason,chr(13),''),chr(10),'') as punishment_reason
    ,replace(replace(t.exe_org_uuid,chr(13),''),chr(10),'') as exe_org_uuid
    ,replace(replace(t.exe_org_name,chr(13),''),chr(10),'') as exe_org_name
    ,replace(replace(t.create_person_uuid,chr(13),''),chr(10),'') as create_person_uuid
    ,replace(replace(t.create_person_name,chr(13),''),chr(10),'') as create_person_name
    ,t.create_date as create_date
    ,t.exe_date as exe_date
    ,replace(replace(t.create_org_uuid,chr(13),''),chr(10),'') as create_org_uuid
    ,replace(replace(t.create_org_name,chr(13),''),chr(10),'') as create_org_name
    ,t.deleted as deleted
    ,replace(replace(t.punishment_ext1,chr(13),''),chr(10),'') as punishment_ext1
    ,replace(replace(t.punishment_ext2,chr(13),''),chr(10),'') as punishment_ext2
    ,replace(replace(t.punishment_type_code,chr(13),''),chr(10),'') as punishment_type_code
    ,replace(replace(t.punishment_ext3,chr(13),''),chr(10),'') as punishment_ext3
    ,replace(replace(t.punishment_ext4,chr(13),''),chr(10),'') as punishment_ext4
    ,replace(replace(t.punishment_ext5,chr(13),''),chr(10),'') as punishment_ext5
    ,t.status as status
    ,replace(replace(t.disciplinary_punishment_code,chr(13),''),chr(10),'') as disciplinary_punishment_code
    ,replace(replace(t.organization_punishment_code,chr(13),''),chr(10),'') as organization_punishment_code
    ,replace(replace(t.other_punishment_code,chr(13),''),chr(10),'') as other_punishment_code
    ,replace(replace(t.punishment_accordance,chr(13),''),chr(10),'') as punishment_accordance
    ,replace(replace(t.disciplinary_punishment_deadline,chr(13),''),chr(10),'') as disciplinary_punishment_deadline
    ,t.disciplinary_punishment_start_time as disciplinary_punishment_start_time
    ,t.disciplinary_punishment_end_time as disciplinary_punishment_end_time
    ,replace(replace(t.organization_punishment_deadline,chr(13),''),chr(10),'') as organization_punishment_deadline
    ,t.organization_punishment_start_time as organization_punishment_start_time
    ,t.organization_punishment_end_time as organization_punishment_end_time
    ,replace(replace(t.other_punishment_desc,chr(13),''),chr(10),'') as other_punishment_desc
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amis_ac_project_punishment t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amis_ac_project_punishment.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes