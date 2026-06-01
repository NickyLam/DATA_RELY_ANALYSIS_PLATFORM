: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nrrs_cr_ratrecord_f
CreateDate: 20230904
FileName:   ${iel_data_path}/nrrs_cr_ratrecord.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lsh,chr(13),''),chr(10),'') as lsh
,replace(replace(t1.custid,chr(13),''),chr(10),'') as custid
,replace(replace(t1.ratdate,chr(13),''),chr(10),'') as ratdate
,replace(replace(t1.operatorid,chr(13),''),chr(10),'') as operatorid
,replace(replace(t1.reportno,chr(13),''),chr(10),'') as reportno
,modelcode
,conmodelcode
,replace(replace(t1.modelselcond1,chr(13),''),chr(10),'') as modelselcond1
,replace(replace(t1.modelselcond2,chr(13),''),chr(10),'') as modelselcond2
,replace(replace(t1.modelselcond3,chr(13),''),chr(10),'') as modelselcond3
,modelselcond4
,modelselcond5
,modelselcond6
,replace(replace(t1.financelevel,chr(13),''),chr(10),'') as financelevel
,replace(replace(t1.nonfinancelevel,chr(13),''),chr(10),'') as nonfinancelevel
,replace(replace(t1.confirmlevel,chr(13),''),chr(10),'') as confirmlevel

from ${iol_schema}.nrrs_cr_ratrecord t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nrrs_cr_ratrecord.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
