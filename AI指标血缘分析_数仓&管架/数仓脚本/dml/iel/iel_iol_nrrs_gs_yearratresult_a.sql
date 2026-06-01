: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nrrs_gs_yearratresult_a
CreateDate: 20230904
FileName:   ${iel_data_path}/nrrs_gs_yearratresult.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.start_dt as etl_dt
,replace(replace(t1.modelcode,chr(13),''),chr(10),'') as modelcode
,replace(replace(t1.index1,chr(13),''),chr(10),'') as index1
,replace(replace(t1.index2,chr(13),''),chr(10),'') as index2
,replace(replace(t1.index3,chr(13),''),chr(10),'') as index3
,replace(replace(t1.index4,chr(13),''),chr(10),'') as index4
,replace(replace(t1.index5,chr(13),''),chr(10),'') as index5
,replace(replace(t1.year,chr(13),''),chr(10),'') as year
,replace(replace(t1.snumberrat,chr(13),''),chr(10),'') as snumberrat
,replace(replace(t1.risklevel,chr(13),''),chr(10),'') as risklevel
,replace(replace(t1.wavelevel,chr(13),''),chr(10),'') as wavelevel
,replace(replace(t1.warnstate,chr(13),''),chr(10),'') as warnstate
,replace(replace(t1.policy,chr(13),''),chr(10),'') as policy
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,ratdate
,ratdateend
,pd
,loansugg
,replace(replace(t1.operatorid,chr(13),''),chr(10),'') as operatorid
,replace(replace(t1.reporttimes,chr(13),''),chr(10),'') as reporttimes
,replace(replace(t1.faud,chr(13),''),chr(10),'') as faud
,replace(replace(t1.custtype,chr(13),''),chr(10),'') as custtype
,replace(replace(t1.rattype,chr(13),''),chr(10),'') as rattype
,replace(replace(t1.ratcount,chr(13),''),chr(10),'') as ratcount
,replace(replace(t1.overturn,chr(13),''),chr(10),'') as overturn
,replace(replace(t1.overthing,chr(13),''),chr(10),'') as overthing
,replace(replace(t1.modelevel,chr(13),''),chr(10),'') as modelevel
,modelscore
,replace(replace(t1.gettype,chr(13),''),chr(10),'') as gettype
,replace(replace(t1.audittype,chr(13),''),chr(10),'') as audittype
,replace(replace(t1.finalresultlsh,chr(13),''),chr(10),'') as finalresultlsh
,modellsh
,replace(replace(t1.loanlevel,chr(13),''),chr(10),'') as loanlevel
,start_dt
,end_dt

from ${iol_schema}.nrrs_gs_yearratresult t1
where 1=1; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nrrs_gs_yearratresult.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
