: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_hi_psndoc_linkman_f
CreateDate: 20240205
FileName:   ${iel_data_path}/nhrs_hi_psndoc_linkman.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dr
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t1.homephone,chr(13),''),chr(10),'') as homephone
,replace(replace(t1.ismain,chr(13),''),chr(10),'') as ismain
,replace(replace(t1.lastflag,chr(13),''),chr(10),'') as lastflag
,replace(replace(t1.linkaddr,chr(13),''),chr(10),'') as linkaddr
,replace(replace(t1.linkman,chr(13),''),chr(10),'') as linkman
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.officephone,chr(13),''),chr(10),'') as officephone
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,replace(replace(t1.pk_psndoc_sub,chr(13),''),chr(10),'') as pk_psndoc_sub
,replace(replace(t1.pk_psnorg,chr(13),''),chr(10),'') as pk_psnorg
,replace(replace(t1.postalcode,chr(13),''),chr(10),'') as postalcode
,recordnum
,replace(replace(t1.relation,chr(13),''),chr(10),'') as relation
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts

from ${iol_schema}.nhrs_hi_psndoc_linkman t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_hi_psndoc_linkman.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
