: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nfss_tcs_tbclient_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nfss_tcs_tbclient.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.in_client_no,chr(13),''),chr(10),'') as in_client_no
    ,replace(replace(t.client_type,chr(13),''),chr(10),'') as client_type
    ,replace(replace(t.client_group,chr(13),''),chr(10),'') as client_group
    ,replace(replace(t.id_type,chr(13),''),chr(10),'') as id_type
    ,replace(replace(t.id_code,chr(13),''),chr(10),'') as id_code
    ,replace(replace(t.short_name,chr(13),''),chr(10),'') as short_name
    ,replace(replace(t.client_name,chr(13),''),chr(10),'') as client_name
    ,replace(replace(t.address,chr(13),''),chr(10),'') as address
    ,replace(replace(t.post_code,chr(13),''),chr(10),'') as post_code
    ,replace(replace(t.tel,chr(13),''),chr(10),'') as tel
    ,replace(replace(t.fax,chr(13),''),chr(10),'') as fax
    ,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
    ,replace(replace(t.email,chr(13),''),chr(10),'') as email
    ,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
    ,replace(replace(t.send_freq,chr(13),''),chr(10),'') as send_freq
    ,replace(replace(t.send_mode,chr(13),''),chr(10),'') as send_mode
    ,t.risk_level as risk_level
    ,t.risk_date as risk_date
    ,t.birthday as birthday
    ,t.id_code_date as id_code_date
    ,replace(replace(t.education,chr(13),''),chr(10),'') as education
    ,replace(replace(t.income,chr(13),''),chr(10),'') as income
    ,replace(replace(t.vocation,chr(13),''),chr(10),'') as vocation
    ,replace(replace(t.nationality,chr(13),''),chr(10),'') as nationality
    ,replace(replace(t.channels,chr(13),''),chr(10),'') as channels
    ,replace(replace(t.prd_types,chr(13),''),chr(10),'') as prd_types
    ,replace(replace(t.client_manager,chr(13),''),chr(10),'') as client_manager
    ,replace(replace(t.open_branch,chr(13),''),chr(10),'') as open_branch
    ,replace(replace(t.status,chr(13),''),chr(10),'') as status
    ,t.modi_date as modi_date
    ,t.modi_time as modi_time
    ,replace(replace(t.modify_info,chr(13),''),chr(10),'') as modify_info
    ,replace(replace(t.reserve1,chr(13),''),chr(10),'') as reserve1
    ,replace(replace(t.reserve2,chr(13),''),chr(10),'') as reserve2
    ,replace(replace(t.reserve3,chr(13),''),chr(10),'') as reserve3
    ,replace(replace(t.reserve4,chr(13),''),chr(10),'') as reserve4
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.nfss_tcs_tbclient t
  where start_dt <= to_date('${batch_date}','yyyymmdd')
    and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_tcs_tbclient.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes