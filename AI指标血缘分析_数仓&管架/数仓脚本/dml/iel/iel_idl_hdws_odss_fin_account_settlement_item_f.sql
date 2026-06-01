: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_odss_fin_account_settlement_item_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_odss_fin_account_settlement_item_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
settlement_id
,settlement_seq_id
,settlement_item_type_id
,from_date
,thru_date
,sett_item_rate
,sett_item_amount
,accumulation
,amount
,fin_account_id
,payment_id
,description
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
from ${idl_schema}.hdws_odss_fin_account_settlement_item
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_odss_fin_account_settlement_item_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes