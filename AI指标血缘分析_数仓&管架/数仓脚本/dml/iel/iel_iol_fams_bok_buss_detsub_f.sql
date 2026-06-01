: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_buss_detsub_f
CreateDate: 20240118
FileName:   ${iel_data_path}/fams_bok_buss_detsub.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bookset_id,chr(13),''),chr(10),'') as bookset_id
,replace(replace(t1.detail_subject_no,chr(13),''),chr(10),'') as detail_subject_no
,replace(replace(t1.detail_subject_name,chr(13),''),chr(10),'') as detail_subject_name
,replace(replace(t1.fsubject_id,chr(13),''),chr(10),'') as fsubject_id
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.detail_subject_no_tail,chr(13),''),chr(10),'') as detail_subject_no_tail
,replace(replace(t1.detail_subname_tail,chr(13),''),chr(10),'') as detail_subname_tail

from ${iol_schema}.fams_bok_buss_detsub t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_buss_detsub.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
