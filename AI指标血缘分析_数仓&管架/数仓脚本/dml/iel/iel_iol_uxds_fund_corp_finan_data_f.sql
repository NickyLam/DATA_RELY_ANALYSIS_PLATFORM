: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_fund_corp_finan_data_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_fund_corp_finan_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,replace(replace(t1.corp_code,chr(13),''),chr(10),'') as corp_code
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,ed
,revenue
,op
,total_profit
,net_profit
,total_assets
,net_assets
,isvalid

from ${iol_schema}.uxds_fund_corp_finan_data t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_fund_corp_finan_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
