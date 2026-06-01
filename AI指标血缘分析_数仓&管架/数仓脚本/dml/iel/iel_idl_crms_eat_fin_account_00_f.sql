: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_eat_fin_account_00_f
CreateDate: 20180529
FileName:   ${iel_data_path}/EAT_FIN_ACCOUNT_00_${batch_date}_ALL.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
fin_account_id
,fin_account_type_id
,status_id
,fin_account_name
,fin_account_code
,fin_account_pin
,currency_uom_id
,organization_party_id
,owner_party_id
,post_to_gl_account_id
,from_date
,thru_date
,is_refundable
,replenish_payment_id
,replenish_level
,actual_balance
,available_balance
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,fund_account_id
,fund_id
,yesterday_balance
,effective_date
from idl.crms_eat_fin_account_00
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/EAT_FIN_ACCOUNT_00_${batch_date}_ALL.dat" \
        charset=zhs16gbk
        safe=yes