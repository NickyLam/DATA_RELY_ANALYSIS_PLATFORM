: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_hi_psndoc_glbdef5_f
CreateDate: 20240311
FileName:   ${iel_data_path}/nhrs_hi_psndoc_glbdef5.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pk_psndoc_sub,chr(13),''),chr(10),'') as pk_psndoc_sub
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,recordnum
,replace(replace(t1.lastflag,chr(13),''),chr(10),'') as lastflag
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.glbdef1,chr(13),''),chr(10),'') as glbdef1
,replace(replace(t1.glbdef2,chr(13),''),chr(10),'') as glbdef2
,replace(replace(t1.glbdef3,chr(13),''),chr(10),'') as glbdef3
,replace(replace(t1.glbdef4,chr(13),''),chr(10),'') as glbdef4
,replace(replace(t1.glbdef5,chr(13),''),chr(10),'') as glbdef5
,replace(replace(t1.glbdef6,chr(13),''),chr(10),'') as glbdef6
,replace(replace(t1.glbdef7,chr(13),''),chr(10),'') as glbdef7
,replace(replace(t1.glbdef9,chr(13),''),chr(10),'') as glbdef9
,replace(replace(t1.glbdef10,chr(13),''),chr(10),'') as glbdef10
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,dr
,replace(replace(t1.glbdef8,chr(13),''),chr(10),'') as glbdef8

from ${iol_schema}.nhrs_hi_psndoc_glbdef5 t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_hi_psndoc_glbdef5.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
