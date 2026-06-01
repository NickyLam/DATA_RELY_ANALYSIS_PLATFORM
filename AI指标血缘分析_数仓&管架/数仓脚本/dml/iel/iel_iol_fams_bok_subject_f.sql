: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_subject_f
CreateDate: 20240129
FileName:   ${iel_data_path}/fams_bok_subject.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bookset_id,chr(13),''),chr(10),'') as bookset_id
,replace(replace(t1.subject_no,chr(13),''),chr(10),'') as subject_no
,replace(replace(t1.subject_name,chr(13),''),chr(10),'') as subject_name
,replace(replace(t1.fsubject_id,chr(13),''),chr(10),'') as fsubject_id
,replace(replace(t1.bal_flag,chr(13),''),chr(10),'') as bal_flag
,replace(replace(t1.subject_type,chr(13),''),chr(10),'') as subject_type
,subject_level
,replace(replace(t1.acc_qua_flag,chr(13),''),chr(10),'') as acc_qua_flag
,replace(replace(t1.acc_int_flag,chr(13),''),chr(10),'') as acc_int_flag
,replace(replace(t1.overdrawn_flag,chr(13),''),chr(10),'') as overdrawn_flag
,replace(replace(t1.gen_detsub_flag,chr(13),''),chr(10),'') as gen_detsub_flag
,replace(replace(t1.base_subject_nature,chr(13),''),chr(10),'') as base_subject_nature
,replace(replace(t1.inv_aim,chr(13),''),chr(10),'') as inv_aim
,replace(replace(t1.sec_manage_acct_id,chr(13),''),chr(10),'') as sec_manage_acct_id
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,start_dt
,end_dt

from ${iol_schema}.fams_bok_subject t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_subject.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
