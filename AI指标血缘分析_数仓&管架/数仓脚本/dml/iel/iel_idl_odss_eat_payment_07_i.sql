: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_eat_payment_07_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_eat_payment_07_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
payment_id
,payment_type_id
,party_id_from
,party_id_to
,parent_payment_id
,payment_method_type_id
,status_id
,trade_party_id
,effective_date
,payment_ref_num
,amount
,currency_uom_id
,comments
,fin_account_trans_id
,fin_account_id
,opp_account_num
,opp_account_name
,opp_bank_num
,opp_bank_name
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,override_gl_account_id
,actual_currency_amount
,acc_name
,payment_method_id
,summary_info
,postscript
,num
,re_type
,payment_gateway_response_id
,payment_preference_id
,all_receive_date
,role_type_id_to
,actual_currency_uom_id
from ${idl_schema}.odss_eat_payment_07
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_eat_payment_07_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes