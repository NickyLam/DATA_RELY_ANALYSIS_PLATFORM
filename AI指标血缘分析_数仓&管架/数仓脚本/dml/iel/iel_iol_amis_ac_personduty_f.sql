: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amis_ac_personduty_f
CreateDate: 20240822
FileName:   ${iel_data_path}/amis_ac_personduty.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ac_personduty_uuid,chr(13),''),chr(10),'') as ac_personduty_uuid
,replace(replace(t1.ac_project_uuid,chr(13),''),chr(10),'') as ac_project_uuid
,replace(replace(t1.personduty_name,chr(13),''),chr(10),'') as personduty_name
,replace(replace(t1.active_code,chr(13),''),chr(10),'') as active_code
,replace(replace(t1.active_name,chr(13),''),chr(10),'') as active_name
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.old_orgname,chr(13),''),chr(10),'') as old_orgname
,replace(replace(t1.old_station,chr(13),''),chr(10),'') as old_station
,replace(replace(t1.level_code,chr(13),''),chr(10),'') as level_code
,replace(replace(t1.level_name,chr(13),''),chr(10),'') as level_name
,replace(replace(t1.curr_org_uuid,chr(13),''),chr(10),'') as curr_org_uuid
,replace(replace(t1.curr_org_name,chr(13),''),chr(10),'') as curr_org_name
,replace(replace(t1.curr_station,chr(13),''),chr(10),'') as curr_station
,replace(replace(t1.duty_code,chr(13),''),chr(10),'') as duty_code
,replace(replace(t1.duty_name,chr(13),''),chr(10),'') as duty_name
,replace(replace(t1.reason_desc,chr(13),''),chr(10),'') as reason_desc
,replace(replace(t1.create_person_uuid,chr(13),''),chr(10),'') as create_person_uuid
,replace(replace(t1.create_person_name,chr(13),''),chr(10),'') as create_person_name
,replace(replace(t1.create_org_name,chr(13),''),chr(10),'') as create_org_name
,create_time
,deleted
,replace(replace(t1.ac_project_code,chr(13),''),chr(10),'') as ac_project_code
,replace(replace(t1.ac_project_name,chr(13),''),chr(10),'') as ac_project_name
,replace(replace(t1.ext1,chr(13),''),chr(10),'') as ext1
,replace(replace(t1.ext2,chr(13),''),chr(10),'') as ext2

from ${iol_schema}.amis_ac_personduty t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amis_ac_personduty.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
