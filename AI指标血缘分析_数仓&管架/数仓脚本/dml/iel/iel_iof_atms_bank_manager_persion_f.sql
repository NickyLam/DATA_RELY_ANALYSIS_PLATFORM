: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_atms_bank_manager_persion_f
CreateDate: 20250909
FileName:   ${iel_data_path}/atms_bank_manager_persion.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.no,chr(13),''),chr(10),'') as no
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.org_no,chr(13),''),chr(10),'') as org_no
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.is_leader,chr(13),''),chr(10),'') as is_leader
,replace(replace(t1.is_lobbymanager,chr(13),''),chr(10),'') as is_lobbymanager
,replace(replace(t1.is_devmanager,chr(13),''),chr(10),'') as is_devmanager
,replace(replace(t1.is_deskmanager,chr(13),''),chr(10),'') as is_deskmanager

from ${iol_schema}.atms_bank_manager_persion t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/atms_bank_manager_persion.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
