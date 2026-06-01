: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_hi_psndoc_abroad_f
CreateDate: 20240205
FileName:   ${iel_data_path}/nhrs_hi_psndoc_abroad.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.abroadarea,chr(13),''),chr(10),'') as abroadarea
,replace(replace(t1.abroaddate,chr(13),''),chr(10),'') as abroaddate
,replace(replace(t1.abroadex,chr(13),''),chr(10),'') as abroadex
,replace(replace(t1.abroadgroup,chr(13),''),chr(10),'') as abroadgroup
,replace(replace(t1.abroadnumber,chr(13),''),chr(10),'') as abroadnumber
,replace(replace(t1.abroadout,chr(13),''),chr(10),'') as abroadout
,replace(replace(t1.abroadoutlay,chr(13),''),chr(10),'') as abroadoutlay
,replace(replace(t1.abroadpro,chr(13),''),chr(10),'') as abroadpro
,replace(replace(t1.abroadprodate,chr(13),''),chr(10),'') as abroadprodate
,replace(replace(t1.abroadreturn,chr(13),''),chr(10),'') as abroadreturn
,replace(replace(t1.abroadunit,chr(13),''),chr(10),'') as abroadunit
,replace(replace(t1.abroadway,chr(13),''),chr(10),'') as abroadway
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dr
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
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
,replace(replace(t1.glbdef5,chr(13),''),chr(10),'') as glbdef5
,replace(replace(t1.glbdef6,chr(13),''),chr(10),'') as glbdef6
,replace(replace(t1.glbdef7,chr(13),''),chr(10),'') as glbdef7
,replace(replace(t1.glbdef8,chr(13),''),chr(10),'') as glbdef8
,replace(replace(t1.glbdef9,chr(13),''),chr(10),'') as glbdef9
,replace(replace(t1.glbdef10,chr(13),''),chr(10),'') as glbdef10
,replace(replace(t1.glbdef11,chr(13),''),chr(10),'') as glbdef11
,replace(replace(t1.glbdef12,chr(13),''),chr(10),'') as glbdef12
,replace(replace(t1.glbdef13,chr(13),''),chr(10),'') as glbdef13
,replace(replace(t1.glbdef14,chr(13),''),chr(10),'') as glbdef14
,replace(replace(t1.glbdef15,chr(13),''),chr(10),'') as glbdef15
,replace(replace(t1.glbdef16,chr(13),''),chr(10),'') as glbdef16
,replace(replace(t1.glbdef17,chr(13),''),chr(10),'') as glbdef17
,replace(replace(t1.glbdef18,chr(13),''),chr(10),'') as glbdef18
,replace(replace(t1.glbdef19,chr(13),''),chr(10),'') as glbdef19

from ${iol_schema}.nhrs_hi_psndoc_abroad t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_hi_psndoc_abroad.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
