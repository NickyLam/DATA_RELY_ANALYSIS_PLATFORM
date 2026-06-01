: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_uxds_trust_corp_index_f
CreateDate: 20251105
FileName:   ${iel_data_path}/uxds_trust_corp_index.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,seq
,ctime
,mtime
,rtime
,replace(replace(t1.trust_company_code,chr(13),''),chr(10),'') as trust_company_code
,ed
,total_use_of_trust_assets
,total_trust_income
,total_trust_fees
,trust_gains_and_losses
,return_on_capital
,trust_rate_of_return
,profit_per_capita
,replace(replace(t1.trust_company_name,chr(13),''),chr(10),'') as trust_company_name
,operating_fee
,operating_taxes_and_surcharge
,isvalid

from ${iol_schema}.uxds_trust_corp_index t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/uxds_trust_corp_index.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
