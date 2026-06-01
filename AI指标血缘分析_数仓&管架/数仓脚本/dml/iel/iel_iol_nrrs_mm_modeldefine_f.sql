: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nrrs_mm_modeldefine_f
CreateDate: 20230829
FileName:   ${iel_data_path}/nrrs_mm_modeldefine.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,lsh
,replace(replace(t1.modelcode,chr(13),''),chr(10),'') as modelcode
,replace(replace(t1.modelname,chr(13),''),chr(10),'') as modelname
,replace(replace(t1.version,chr(13),''),chr(10),'') as version
,replace(replace(t1.modelstate,chr(13),''),chr(10),'') as modelstate
,replace(replace(t1.operatorid,chr(13),''),chr(10),'') as operatorid
,replace(replace(t1.createdate,chr(13),''),chr(10),'') as createdate
,replace(replace(t1.issuedate,chr(13),''),chr(10),'') as issuedate
,replace(replace(t1.adjustflag,chr(13),''),chr(10),'') as adjustflag
,replace(replace(t1.constraintflag,chr(13),''),chr(10),'') as constraintflag
,replace(replace(t1.modeltype,chr(13),''),chr(10),'') as modeltype
,replace(replace(t1.reportid,chr(13),''),chr(10),'') as reportid
,replace(replace(t1.adjustmodelcode,chr(13),''),chr(10),'') as adjustmodelcode
,replace(replace(t1.mark,chr(13),''),chr(10),'') as mark

from ${iol_schema}.nrrs_mm_modeldefine t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nrrs_mm_modeldefine.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
