: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_eat_fin_account_trans_04_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_eat_fin_account_trans_04_${batch_date}_f.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
fin_account_trans_id
,fin_account_trans_type_id
,fin_account_id
,party_id
,transaction_date
,entry_date
,amount
,payment_id
,order_id
,order_item_seq_id
,performed_by_party_id
,reason_enum_id
,comments
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,fund_order_id
,status_id
,interest_balance
,parent_trans_id
,from_date
,thru_date
,deposit_period
,channel
,consumer_sys_id
,trans_ref_num
from ${idl_schema}.crms_eat_fin_account_trans_04
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_eat_fin_account_trans_04_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes