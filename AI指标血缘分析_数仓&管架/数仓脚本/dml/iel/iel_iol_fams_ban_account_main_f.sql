: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_ban_account_main_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_ban_account_main.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.vouch_num,chr(13),''),chr(10),'') as vouch_num
,replace(replace(t1.bus_vouchnum,chr(13),''),chr(10),'') as bus_vouchnum
,replace(replace(t1.bookset_id,chr(13),''),chr(10),'') as bookset_id
,replace(replace(t1.trade_id,chr(13),''),chr(10),'') as trade_id
,t1.book_date as book_date
,replace(replace(t1.com_table_id,chr(13),''),chr(10),'') as com_table_id
,replace(replace(t1.vouch_remark,chr(13),''),chr(10),'') as vouch_remark
,replace(replace(t1.offset_flag,chr(13),''),chr(10),'') as offset_flag
,t1.vouch_year as vouch_year
,t1.vouch_month as vouch_month
,t1.num as num
,replace(replace(t1.book_type,chr(13),''),chr(10),'') as book_type
,replace(replace(t1.handle_user,chr(13),''),chr(10),'') as handle_user
,replace(replace(t1.approve_user,chr(13),''),chr(10),'') as approve_user
,replace(replace(t1.approve_status,chr(13),''),chr(10),'') as approve_status
,replace(replace(t1.send_user,chr(13),''),chr(10),'') as send_user
,replace(replace(t1.send_status,chr(13),''),chr(10),'') as send_status
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,t1.create_time as create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,t1.update_time as update_time
,replace(replace(t1.vouch_type,chr(13),''),chr(10),'') as vouch_type
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.fams_ban_account_main t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_ban_account_main.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes