: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifms_tbincome_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ifms_tbincome.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,t.cfm_date as cfm_date
,replace(replace(t.asset_acc,chr(13),''),chr(10),'') as asset_acc
,replace(replace(t.ta_client,chr(13),''),chr(10),'') as ta_client
,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t.share_class,chr(13),''),chr(10),'') as share_class
,replace(replace(t.seller_code,chr(13),''),chr(10),'') as seller_code
,t.income as income
,t.frozen_income as frozen_income
,t.income_new as income_new
,t.real_vol as real_vol
,t.frozen_vol as frozen_vol
,t.return_fee as return_fee
,t.return_fee_new as return_fee_new
,t.amt1 as amt1
from ${iol_schema}.IFMS_tbincome t 
where CFM_DATE>to_char(to_date('${batch_date}','yyyymmdd')-30,'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbincome.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes