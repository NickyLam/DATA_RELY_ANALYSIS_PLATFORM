: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_ban_account_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_ban_account_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.vouch_subnum,chr(13),''),chr(10),'') as vouch_subnum
,replace(replace(t1.vouch_num,chr(13),''),chr(10),'') as vouch_num
,replace(replace(t1.bus_vouchsubnum,chr(13),''),chr(10),'') as bus_vouchsubnum
,t1.happen_date as happen_date
,replace(replace(t1.table_id,chr(13),''),chr(10),'') as table_id
,replace(replace(t1.cd_flag,chr(13),''),chr(10),'') as cd_flag
,replace(replace(t1.subject_no,chr(13),''),chr(10),'') as subject_no
,t1.happen_amt as happen_amt
,t1.happen_number as happen_number
,replace(replace(t1.busi_id,chr(13),''),chr(10),'') as busi_id
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.trade_id,chr(13),''),chr(10),'') as trade_id
,replace(replace(t1.detail_subject_no,chr(13),''),chr(10),'') as detail_subject_no
,replace(replace(t1.book_type,chr(13),''),chr(10),'') as book_type
,t1.b_happen_amt as b_happen_amt
,replace(replace(t1.b_ccy,chr(13),''),chr(10),'') as b_ccy
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,t1.create_time as create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,t1.update_time as update_time
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.fams_ban_account_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_ban_account_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes