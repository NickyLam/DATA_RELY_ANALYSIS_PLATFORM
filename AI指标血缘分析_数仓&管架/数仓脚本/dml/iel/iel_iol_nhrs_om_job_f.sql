: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_om_job_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_om_job.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.creationtime,chr(13),''),chr(10),'') as creationtime
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,t.dataoriginflag as dataoriginflag
    ,replace(replace(t.defaultjobrank,chr(13),''),chr(10),'') as defaultjobrank
    ,t.dr as dr
    ,t.enablestate as enablestate
    ,replace(replace(t.jobcode,chr(13),''),chr(10),'') as jobcode
    ,replace(replace(t.jobdesc,chr(13),''),chr(10),'') as jobdesc
    ,replace(replace(t.jobname,chr(13),''),chr(10),'') as jobname
    ,replace(replace(t.jobname2,chr(13),''),chr(10),'') as jobname2
    ,replace(replace(t.jobname3,chr(13),''),chr(10),'') as jobname3
    ,replace(replace(t.jobname4,chr(13),''),chr(10),'') as jobname4
    ,replace(replace(t.jobname5,chr(13),''),chr(10),'') as jobname5
    ,replace(replace(t.jobname6,chr(13),''),chr(10),'') as jobname6
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.originaldocid,chr(13),''),chr(10),'') as originaldocid
    ,replace(replace(t.pk_grade_source,chr(13),''),chr(10),'') as pk_grade_source
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_job,chr(13),''),chr(10),'') as pk_job
    ,replace(replace(t.pk_jobtype,chr(13),''),chr(10),'') as pk_jobtype
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.pvtjobgrade,chr(13),''),chr(10),'') as pvtjobgrade
    ,replace(replace(t.redefineflag,chr(13),''),chr(10),'') as redefineflag
    ,replace(replace(t.reqedu,chr(13),''),chr(10),'') as reqedu
    ,replace(replace(t.reqexp,chr(13),''),chr(10),'') as reqexp
    ,replace(replace(t.reqother,chr(13),''),chr(10),'') as reqother
    ,replace(replace(t.reqpro,chr(13),''),chr(10),'') as reqpro
    ,replace(replace(t.reqsex,chr(13),''),chr(10),'') as reqsex
    ,replace(replace(t.reqtlimit,chr(13),''),chr(10),'') as reqtlimit
    ,replace(replace(t.reqyold,chr(13),''),chr(10),'') as reqyold
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,replace(replace(t.pk_jobrank,chr(13),''),chr(10),'') as pk_jobrank
    ,replace(replace(t.glbdef1,chr(13),''),chr(10),'') as glbdef1
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_om_job t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_om_job.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes