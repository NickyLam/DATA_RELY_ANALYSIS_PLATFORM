: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_nhrs_hi_psndoc_family_f
CreateDate: 20240205
FileName:   ${iel_data_path}/nhrs_hi_psndoc_family.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,approveflag
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dr
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.lastflag,chr(13),''),chr(10),'') as lastflag
,replace(replace(t1.mem_birthday,chr(13),''),chr(10),'') as mem_birthday
,replace(replace(t1.mem_corp,chr(13),''),chr(10),'') as mem_corp
,replace(replace(t1.mem_job,chr(13),''),chr(10),'') as mem_job
,replace(replace(t1.mem_name,chr(13),''),chr(10),'') as mem_name
,replace(replace(t1.mem_relation,chr(13),''),chr(10),'') as mem_relation
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.period,chr(13),''),chr(10),'') as period
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,replace(replace(t1.pk_psndoc_sub,chr(13),''),chr(10),'') as pk_psndoc_sub
,replace(replace(t1.politics,chr(13),''),chr(10),'') as politics
,replace(replace(t1.profession,chr(13),''),chr(10),'') as profession
,recordnum
,replace(replace(t1.relaaddr,chr(13),''),chr(10),'') as relaaddr
,replace(replace(t1.relaphone,chr(13),''),chr(10),'') as relaphone
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,glbdef1
,replace(replace(t1.glbdef2,chr(13),''),chr(10),'') as glbdef2
,replace(replace(t1.glbdef3,chr(13),''),chr(10),'') as glbdef3
,replace(replace(t1.glbdef4,chr(13),''),chr(10),'') as glbdef4
,replace(replace(t1.glbdef5,chr(13),''),chr(10),'') as glbdef5
,replace(replace(t1.glbdef7,chr(13),''),chr(10),'') as glbdef7
,replace(replace(t1.glbdef8,chr(13),''),chr(10),'') as glbdef8
,replace(replace(t1.glbdef6,chr(13),''),chr(10),'') as glbdef6
,replace(replace(t1.glbdef9,chr(13),''),chr(10),'') as glbdef9

from ${iol_schema}.nhrs_hi_psndoc_family t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_hi_psndoc_family.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
