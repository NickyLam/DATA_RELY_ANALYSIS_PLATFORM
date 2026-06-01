: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_om_postseries_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_om_postseries.f.${batch_date}.dat
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
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.pk_postseries,chr(13),''),chr(10),'') as pk_postseries
    ,replace(replace(t.postseriescode,chr(13),''),chr(10),'') as postseriescode
    ,replace(replace(t.postseriesdesc,chr(13),''),chr(10),'') as postseriesdesc
    ,replace(replace(t.postseriesname,chr(13),''),chr(10),'') as postseriesname
    ,replace(replace(t.postseriesname2,chr(13),''),chr(10),'') as postseriesname2
    ,replace(replace(t.postseriesname3,chr(13),''),chr(10),'') as postseriesname3
    ,replace(replace(t.postseriesname4,chr(13),''),chr(10),'') as postseriesname4
    ,replace(replace(t.postseriesname5,chr(13),''),chr(10),'') as postseriesname5
    ,replace(replace(t.postseriesname6,chr(13),''),chr(10),'') as postseriesname6
    ,replace(replace(t.seq,chr(13),''),chr(10),'') as seq
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_om_postseries t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_om_postseries.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes