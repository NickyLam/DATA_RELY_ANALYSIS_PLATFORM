: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_hi_psndoc_enc_f
CreateDate: 20240205
FileName:   ${iel_data_path}/nhrs_hi_psndoc_enc.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dr
,replace(replace(t1.encourdate,chr(13),''),chr(10),'') as encourdate
,replace(replace(t1.encourmatter,chr(13),''),chr(10),'') as encourmatter
,replace(replace(t1.encourmeas,chr(13),''),chr(10),'') as encourmeas
,replace(replace(t1.encourorg,chr(13),''),chr(10),'') as encourorg
,replace(replace(t1.encourrank,chr(13),''),chr(10),'') as encourrank
,replace(replace(t1.encourtype,chr(13),''),chr(10),'') as encourtype
,replace(replace(t1.lastflag,chr(13),''),chr(10),'') as lastflag
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,replace(replace(t1.pk_psndoc_sub,chr(13),''),chr(10),'') as pk_psndoc_sub
,recordnum
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.glbdef1,chr(13),''),chr(10),'') as glbdef1
,replace(replace(t1.glbdef2,chr(13),''),chr(10),'') as glbdef2
,replace(replace(t1.glbdef3,chr(13),''),chr(10),'') as glbdef3
,replace(replace(t1.glbdef4,chr(13),''),chr(10),'') as glbdef4

from ${iol_schema}.nhrs_hi_psndoc_enc t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_hi_psndoc_enc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
