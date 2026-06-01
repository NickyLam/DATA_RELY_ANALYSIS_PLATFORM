: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_nhrs_bd_defdoc_f
CreateDate: 20260304
FileName:   ${iel_data_path}/nhrs_bd_defdoc.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dataoriginflag
,datatype
,dr
,enablestate
,replace(replace(t1.innercode,chr(13),''),chr(10),'') as innercode
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.mnecode,chr(13),''),chr(10),'') as mnecode
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.name2,chr(13),''),chr(10),'') as name2
,replace(replace(t1.name3,chr(13),''),chr(10),'') as name3
,replace(replace(t1.name4,chr(13),''),chr(10),'') as name4
,replace(replace(t1.name5,chr(13),''),chr(10),'') as name5
,replace(replace(t1.name6,chr(13),''),chr(10),'') as name6
,replace(replace(t1.pid,chr(13),''),chr(10),'') as pid
,replace(replace(t1.pk_defdoc,chr(13),''),chr(10),'') as pk_defdoc
,replace(replace(t1.pk_defdoclist,chr(13),''),chr(10),'') as pk_defdoclist
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.shortname,chr(13),''),chr(10),'') as shortname
,replace(replace(t1.shortname2,chr(13),''),chr(10),'') as shortname2
,replace(replace(t1.shortname3,chr(13),''),chr(10),'') as shortname3
,replace(replace(t1.shortname4,chr(13),''),chr(10),'') as shortname4
,replace(replace(t1.shortname5,chr(13),''),chr(10),'') as shortname5
,replace(replace(t1.shortname6,chr(13),''),chr(10),'') as shortname6
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.nhrs_bd_defdoc t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_bd_defdoc.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
