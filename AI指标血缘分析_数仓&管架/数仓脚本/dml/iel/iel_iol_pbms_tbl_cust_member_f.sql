: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pbms_tbl_cust_member_f
CreateDate: 20260402
FileName:   ${iel_data_path}/pbms_tbl_cust_member.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,is_positive
,replace(replace(t1.member_code,chr(13),''),chr(10),'') as member_code
,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t1.start_time,chr(13),''),chr(10),'') as start_time
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,last_upgrade_time
,last_downgrade_time
,del_flag
,replace(replace(t1.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.updated_by,chr(13),''),chr(10),'') as updated_by
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time

from ${iol_schema}.pbms_tbl_cust_member t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pbms_tbl_cust_member.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
