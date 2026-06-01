: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ifms_tbincome_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ifms_tbincome.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.etl_dt
,t1.cfm_date
,t1.asset_acc
,t1.ta_client
,t1.prd_code
,t1.share_class
,t1.seller_code
,t1.income
,t1.frozen_income
,t1.income_new
,t1.real_vol
,t1.frozen_vol
,t1.return_fee
,t1.return_fee_new
,t1.amt1
from ${idl_schema}.hdws_ifms_tbincome t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ifms_tbincome.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes