: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_khdx_zb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pams_khdx_zb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,t1.zbdh as zbdh 
,replace(replace(t1.zbmc,chr(13),''),chr(10),'') as zbmc 
,replace(replace(t1.zbdw,chr(13),''),chr(10),'') as zbdw 
,replace(replace(t1.zbjb,chr(13),''),chr(10),'') as zbjb 
,replace(replace(t1.whfs,chr(13),''),chr(10),'') as whfs 
,replace(replace(t1.sfxs,chr(13),''),chr(10),'') as sfxs 
,t1.ddsx as ddsx 
,t1.zbpx as zbpx 
,replace(replace(t1.zbcc,chr(13),''),chr(10),'') as zbcc 
,replace(replace(t1.ddlb,chr(13),''),chr(10),'') as ddlb 
,replace(replace(t1.jspl,chr(13),''),chr(10),'') as jspl 
,t1.sjzb as sjzb 
,replace(replace(t1.zbzt,chr(13),''),chr(10),'') as zbzt 
,replace(replace(t1.dlbz,chr(13),''),chr(10),'') as dlbz 
,t1.xszbdh as xszbdh 
,replace(replace(t1.kzlx,chr(13),''),chr(10),'') as kzlx 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.pams_khdx_zb t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_khdx_zb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes