: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_iers_fip_docview_f
CreateDate: 20230130
FileName:   ${iel_data_path}/iers_fip_docview.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.desdocid,chr(13),''),chr(10),'') as desdocid
,dr
,replace(replace(t1.explanation,chr(13),''),chr(10),'') as explanation
,replace(replace(t1.explanation2,chr(13),''),chr(10),'') as explanation2
,replace(replace(t1.explanation3,chr(13),''),chr(10),'') as explanation3
,replace(replace(t1.explanation4,chr(13),''),chr(10),'') as explanation4
,replace(replace(t1.explanation5,chr(13),''),chr(10),'') as explanation5
,replace(replace(t1.explanation6,chr(13),''),chr(10),'') as explanation6
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.orgtype,chr(13),''),chr(10),'') as orgtype
,replace(replace(t1.pk_classview,chr(13),''),chr(10),'') as pk_classview
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_setorg1,chr(13),''),chr(10),'') as pk_setorg1
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.viewcode,chr(13),''),chr(10),'') as viewcode
,replace(replace(t1.viewname,chr(13),''),chr(10),'') as viewname
,replace(replace(t1.viewname2,chr(13),''),chr(10),'') as viewname2
,replace(replace(t1.viewname3,chr(13),''),chr(10),'') as viewname3
,replace(replace(t1.viewname4,chr(13),''),chr(10),'') as viewname4
,replace(replace(t1.viewname5,chr(13),''),chr(10),'') as viewname5
,replace(replace(t1.viewname6,chr(13),''),chr(10),'') as viewname6
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_fip_docview t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_fip_docview.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
