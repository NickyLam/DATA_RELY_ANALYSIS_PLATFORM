: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_ashare_broker_monthly_report_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_ashare_broker_monthly_report.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,replace(replace(t1.broker_id,chr(13),''),chr(10),'') as broker_id
,net_asset
,monthly_revenue
,replace(replace(t1.broker_name,chr(13),''),chr(10),'') as broker_name
,mnth
,monthly_net_profit
,isvalid

from ${iol_schema}.uxds_ashare_broker_monthly_report t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_ashare_broker_monthly_report.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
