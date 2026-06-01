: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_mds_serl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_mds_serl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t.servtp,chr(13),''),chr(10),'') as servtp
,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.otserv,chr(13),''),chr(10),'') as otserv
from ${iol_schema}.cbss_mds_serl t
where trandt = '${batch_date}'
and etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_mds_serl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes