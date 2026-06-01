: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amis_ac_exe_punishment_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amis_ac_exe_punishment.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.ac_exe_punishment_uuid,chr(13),''),chr(10),'') as ac_exe_punishment_uuid
    ,replace(replace(t.ac_punishment_uuid,chr(13),''),chr(10),'') as ac_punishment_uuid
    ,replace(replace(t.exe_status_code,chr(13),''),chr(10),'') as exe_status_code
    ,replace(replace(t.exe_status_name,chr(13),''),chr(10),'') as exe_status_name
    ,t.exe_date as exe_date
    ,t.penalty_amount as penalty_amount
    ,replace(replace(t.create_person_uuid,chr(13),''),chr(10),'') as create_person_uuid
    ,replace(replace(t.create_person_name,chr(13),''),chr(10),'') as create_person_name
    ,t.create_date as create_date
    ,replace(replace(t.create_org_uuid,chr(13),''),chr(10),'') as create_org_uuid
    ,replace(replace(t.create_org_name,chr(13),''),chr(10),'') as create_org_name
    ,t.deleted as deleted
    ,replace(replace(t.exe_ext1,chr(13),''),chr(10),'') as exe_ext1
    ,replace(replace(t.exe_ext2,chr(13),''),chr(10),'') as exe_ext2
    ,replace(replace(t.exe_ext3,chr(13),''),chr(10),'') as exe_ext3
    ,replace(replace(t.exe_ext4,chr(13),''),chr(10),'') as exe_ext4
    ,replace(replace(t.exe_ext5,chr(13),''),chr(10),'') as exe_ext5
    ,t.status as status
    ,replace(replace(t.reason,chr(13),''),chr(10),'') as reason
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amis_ac_exe_punishment t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amis_ac_exe_punishment.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes