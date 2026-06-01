: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_hi_psnorg_f
CreateDate: 20251222
FileName:   ${iel_data_path}/nhrs_hi_psnorg.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dr
,replace(replace(t1.empforms,chr(13),''),chr(10),'') as empforms
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.endflag,chr(13),''),chr(10),'') as endflag
,indoc_source
,replace(replace(t1.indocflag,chr(13),''),chr(10),'') as indocflag
,replace(replace(t1.joinsysdate,chr(13),''),chr(10),'') as joinsysdate
,replace(replace(t1.lastflag,chr(13),''),chr(10),'') as lastflag
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,orgrelaid
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_hrorg,chr(13),''),chr(10),'') as pk_hrorg
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,replace(replace(t1.pk_psnorg,chr(13),''),chr(10),'') as pk_psnorg
,psntype
,replace(replace(t1.startpaydate,chr(13),''),chr(10),'') as startpaydate
,replace(replace(t1.stoppaydate,chr(13),''),chr(10),'') as stoppaydate
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,workage
,replace(replace(t1.orgglbdef1,chr(13),''),chr(10),'') as orgglbdef1
,replace(replace(t1.orgglbdef2,chr(13),''),chr(10),'') as orgglbdef2

from ${iol_schema}.nhrs_hi_psnorg t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_hi_psnorg.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
