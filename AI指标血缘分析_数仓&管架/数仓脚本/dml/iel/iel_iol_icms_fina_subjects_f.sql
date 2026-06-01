: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_fina_subjects_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_fina_subjects.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.subjectno,chr(13),''),chr(10),'') as subjectno
,replace(replace(t1.primaryclass,chr(13),''),chr(10),'') as primaryclass
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,t1.updatedate as updatedate
,replace(replace(t1.auxiliaryaccounting,chr(13),''),chr(10),'') as auxiliaryaccounting
,replace(replace(t1.available,chr(13),''),chr(10),'') as available
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.foreigncurrency,chr(13),''),chr(10),'') as foreigncurrency
,t1.inputdate as inputdate
,replace(replace(t1.valuetype,chr(13),''),chr(10),'') as valuetype
,replace(replace(t1.direction,chr(13),''),chr(10),'') as direction
,replace(replace(t1.secondaryclass,chr(13),''),chr(10),'') as secondaryclass
,replace(replace(t1.transferending,chr(13),''),chr(10),'') as transferending
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.subjectname,chr(13),''),chr(10),'') as subjectname
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.icms_fina_subjects t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_fina_subjects.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes