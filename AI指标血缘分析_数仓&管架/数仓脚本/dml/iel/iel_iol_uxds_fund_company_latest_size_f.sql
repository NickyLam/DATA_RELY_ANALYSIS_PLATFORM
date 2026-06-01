: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_fund_company_latest_size_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_fund_company_latest_size.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,report_date
,stat_type
,total_net_asset_value
,asset_size
,total_shares
,ed
,number_of_funds
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,isvalid

from ${iol_schema}.uxds_fund_company_latest_size t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_fund_company_latest_size.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
