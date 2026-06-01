: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_khdx_zblb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_khdx_zblb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.zbdh as zbdh 
,replace(replace(t1.ywlb,chr(13),''),chr(10),'') as ywlb 
,t1.qsrq as qsrq 
,t1.jsrq as jsrq 
,replace(replace(t1.sfxs,chr(13),''),chr(10),'') as sfxs 
,replace(replace(t1.zbzt,chr(13),''),chr(10),'') as zbzt 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.pams_khdx_zblb t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khdx_zblb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes