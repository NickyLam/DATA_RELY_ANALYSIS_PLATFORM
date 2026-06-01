: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_om_jobtype_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_om_jobtype.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.creationtime,chr(13),''),chr(10),'') as creationtime
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,t.dataoriginflag as dataoriginflag
    ,t.dr as dr
    ,t.enablestate as enablestate
    ,replace(replace(t.father_pk,chr(13),''),chr(10),'') as father_pk
    ,replace(replace(t.innercode,chr(13),''),chr(10),'') as innercode
    ,replace(replace(t.jobtypecode,chr(13),''),chr(10),'') as jobtypecode
    ,replace(replace(t.jobtypedesc,chr(13),''),chr(10),'') as jobtypedesc
    ,replace(replace(t.jobtypename,chr(13),''),chr(10),'') as jobtypename
    ,replace(replace(t.jobtypename2,chr(13),''),chr(10),'') as jobtypename2
    ,replace(replace(t.jobtypename3,chr(13),''),chr(10),'') as jobtypename3
    ,replace(replace(t.jobtypename4,chr(13),''),chr(10),'') as jobtypename4
    ,replace(replace(t.jobtypename5,chr(13),''),chr(10),'') as jobtypename5
    ,replace(replace(t.jobtypename6,chr(13),''),chr(10),'') as jobtypename6
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.originaldocid,chr(13),''),chr(10),'') as originaldocid
    ,replace(replace(t.pk_grade_source,chr(13),''),chr(10),'') as pk_grade_source
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_jobtype,chr(13),''),chr(10),'') as pk_jobtype
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.pvtjobgrade,chr(13),''),chr(10),'') as pvtjobgrade
    ,replace(replace(t.redefineflag,chr(13),''),chr(10),'') as redefineflag
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,t.type_level as type_level
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_om_jobtype t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_om_jobtype.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes