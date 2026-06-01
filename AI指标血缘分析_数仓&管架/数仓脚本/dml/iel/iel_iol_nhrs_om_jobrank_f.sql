: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_om_jobrank_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_om_jobrank.f.${batch_date}.dat
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
    ,replace(replace(t.jobrankcode,chr(13),''),chr(10),'') as jobrankcode
    ,replace(replace(t.jobrankdesc,chr(13),''),chr(10),'') as jobrankdesc
    ,replace(replace(t.jobrankname,chr(13),''),chr(10),'') as jobrankname
    ,replace(replace(t.jobrankname2,chr(13),''),chr(10),'') as jobrankname2
    ,replace(replace(t.jobrankname3,chr(13),''),chr(10),'') as jobrankname3
    ,replace(replace(t.jobrankname4,chr(13),''),chr(10),'') as jobrankname4
    ,replace(replace(t.jobrankname5,chr(13),''),chr(10),'') as jobrankname5
    ,replace(replace(t.jobrankname6,chr(13),''),chr(10),'') as jobrankname6
    ,t.jobrankorder as jobrankorder
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_jobrank,chr(13),''),chr(10),'') as pk_jobrank
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.sealflag,chr(13),''),chr(10),'') as sealflag
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,replace(replace(t.usedflag,chr(13),''),chr(10),'') as usedflag
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_om_jobrank t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_om_jobrank.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes