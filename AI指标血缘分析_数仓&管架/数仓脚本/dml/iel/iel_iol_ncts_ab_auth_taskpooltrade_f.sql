: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncts_ab_auth_taskpooltrade_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncts_ab_auth_taskpooltrade.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.authorgno,chr(13),''),chr(10),'') as authorgno 
,replace(replace(t1.taskpoolid,chr(13),''),chr(10),'') as taskpoolid 
,replace(replace(t1.channelcode,chr(13),''),chr(10),'') as channelcode 
,replace(replace(t1.tradecode,chr(13),''),chr(10),'') as tradecode 
from ${iol_schema}.ncts_ab_auth_taskpooltrade t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncts_ab_auth_taskpooltrade.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes