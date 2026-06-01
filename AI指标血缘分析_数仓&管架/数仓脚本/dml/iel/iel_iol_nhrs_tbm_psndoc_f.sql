: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_tbm_psndoc_f
CreateDate: 20240205
FileName:   ${iel_data_path}/nhrs_tbm_psndoc.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dr
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.pk_adminorg,chr(13),''),chr(10),'') as pk_adminorg
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_place,chr(13),''),chr(10),'') as pk_place
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,replace(replace(t1.pk_psnjob,chr(13),''),chr(10),'') as pk_psnjob
,replace(replace(t1.pk_psnorg,chr(13),''),chr(10),'') as pk_psnorg
,replace(replace(t1.pk_tbm_psndoc,chr(13),''),chr(10),'') as pk_tbm_psndoc
,replace(replace(t1.pk_team,chr(13),''),chr(10),'') as pk_team
,replace(replace(t1.secondcardid,chr(13),''),chr(10),'') as secondcardid
,tbm_prop
,replace(replace(t1.timecardid,chr(13),''),chr(10),'') as timecardid
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts

from ${iol_schema}.nhrs_tbm_psndoc t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_tbm_psndoc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
