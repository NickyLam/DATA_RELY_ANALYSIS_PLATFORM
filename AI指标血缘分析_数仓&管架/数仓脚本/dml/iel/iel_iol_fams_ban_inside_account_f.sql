: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_ban_inside_account_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_ban_inside_account.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prodcode,chr(13),''),chr(10),'') as prodcode
,replace(replace(t1.orgcode,chr(13),''),chr(10),'') as orgcode
,replace(replace(t1.subject,chr(13),''),chr(10),'') as subject
,replace(replace(t1.acct_no,chr(13),''),chr(10),'') as acct_no
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.acct_type,chr(13),''),chr(10),'') as acct_type
,replace(replace(t1.saletarget,chr(13),''),chr(10),'') as saletarget
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.match_type,chr(13),''),chr(10),'') as match_type
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,t1.create_time as create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,t1.update_time as update_time
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.fams_ban_inside_account t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_ban_inside_account.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes