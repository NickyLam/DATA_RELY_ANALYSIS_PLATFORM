: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbpriceset_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbpriceset_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
serial_no
,prd_code
,valid_date
,price_mode
,seller_code
,client_group
,client_type
,seller_type
,channel
,hold_days
,min_hold_days
,max_hold_days
,min_hold_amt
,max_hold_amt
,client_ratio
,bank_ratio
,min_income
,max_income
,default_flag
,amt1
,ratio1
,ratio2
,reserve1
,reserve2
,reserve3
from ${idl_schema}.odss_tbpriceset
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbpriceset_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes