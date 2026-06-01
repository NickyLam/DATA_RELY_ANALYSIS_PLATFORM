: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_mds_serl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_mds_serl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.dataid,chr(13),''),chr(10),'') as dataid 
,replace(replace(t1.servtp,chr(13),''),chr(10),'') as servtp 
,replace(replace(t1.trandt,chr(13),''),chr(10),'') as trandt 
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq 
,replace(replace(t1.otserv,chr(13),''),chr(10),'') as otserv 
from ${iol_schema}.cbss_mds_serl t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date(substr('${batch_date}',1,6)||'01','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_mds_serl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes