: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_odss_fin_account_settlement_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_odss_fin_account_settlement_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
settlement_id
,fin_account_id
,fin_account_type_id
,organization_party_id
,settlement_type_id
,from_date
,thru_date
,settlement_date
,last_settle_date
,currency_uom_id
,interest_adjustment
,actual_balance
,amount
,tax_amount
,settlement_group_id
,payment_id
,tax_payment_id
,status_id
,comments
,create_by_user_login_id
,domain_code
,transaction_id
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
from ${idl_schema}.hdws_odss_fin_account_settlement
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_odss_fin_account_settlement_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes