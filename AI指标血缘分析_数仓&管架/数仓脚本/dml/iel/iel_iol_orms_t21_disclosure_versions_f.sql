: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orms_t21_disclosure_versions_f
CreateDate: 20231107
FileName:   ${iel_data_path}/orms_t21_disclosure_versions.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.seq,chr(13),''),chr(10),'') as seq
,replace(replace(t1.deleteflag,chr(13),''),chr(10),'') as deleteflag
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.createdate,chr(13),''),chr(10),'') as createdate
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,replace(replace(t1.modifydate,chr(13),''),chr(10),'') as modifydate
,replace(replace(t1.amount,chr(13),''),chr(10),'') as amount
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate

from ${iol_schema}.orms_t21_disclosure_versions t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orms_t21_disclosure_versions.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
