: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_om_jobgrade_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_om_jobgrade.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.dataoriginflag as dataoriginflag
    ,t.dr as dr
    ,replace(replace(t.jobgradecode,chr(13),''),chr(10),'') as jobgradecode
    ,replace(replace(t.jobgradedesc,chr(13),''),chr(10),'') as jobgradedesc
    ,replace(replace(t.jobgradename,chr(13),''),chr(10),'') as jobgradename
    ,replace(replace(t.jobgradename2,chr(13),''),chr(10),'') as jobgradename2
    ,replace(replace(t.jobgradename3,chr(13),''),chr(10),'') as jobgradename3
    ,replace(replace(t.jobgradename4,chr(13),''),chr(10),'') as jobgradename4
    ,replace(replace(t.jobgradename5,chr(13),''),chr(10),'') as jobgradename5
    ,replace(replace(t.jobgradename6,chr(13),''),chr(10),'') as jobgradename6
    ,replace(replace(t.pk_job,chr(13),''),chr(10),'') as pk_job
    ,replace(replace(t.pk_jobgrade,chr(13),''),chr(10),'') as pk_jobgrade
    ,replace(replace(t.pk_jobrank,chr(13),''),chr(10),'') as pk_jobrank
    ,replace(replace(t.pk_jobtype,chr(13),''),chr(10),'') as pk_jobtype
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_om_jobgrade t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_om_jobgrade.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes