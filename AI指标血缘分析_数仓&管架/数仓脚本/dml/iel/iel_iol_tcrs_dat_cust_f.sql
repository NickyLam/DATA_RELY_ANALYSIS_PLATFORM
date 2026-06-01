: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tcrs_dat_cust_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tcrs_dat_cust.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.cust_code,chr(13),''),chr(10),'') as cust_code
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.en_name,chr(13),''),chr(10),'') as en_name
,replace(replace(t.type,chr(13),''),chr(10),'') as type
,replace(replace(t.identity_type,chr(13),''),chr(10),'') as identity_type
,replace(replace(t.identity_code,chr(13),''),chr(10),'') as identity_code
,t.open_date as open_date
,replace(replace(t.open_group_code,chr(13),''),chr(10),'') as open_group_code
,t.birthday as birthday
,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t.native_place,chr(13),''),chr(10),'') as native_place
,replace(replace(t.nation,chr(13),''),chr(10),'') as nation
,replace(replace(t.inner_system,chr(13),''),chr(10),'') as inner_system
,replace(replace(t.cred_level,chr(13),''),chr(10),'') as cred_level
,t.cred_limit as cred_limit
,replace(replace(t.issue_group_code,chr(13),''),chr(10),'') as issue_group_code
,replace(replace(t.create_channel,chr(13),''),chr(10),'') as create_channel
,t.ctime as ctime
,replace(replace(t.cust_mobile,chr(13),''),chr(10),'') as cust_mobile
,replace(replace(t.cust_level,chr(13),''),chr(10),'') as cust_level
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.tcrs_dat_cust t
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tcrs_dat_cust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes