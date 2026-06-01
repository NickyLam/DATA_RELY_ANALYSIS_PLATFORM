: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_eat_fin_account_trans_00_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_eat_fin_account_trans_00_${batch_date}_i.dat
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
,fund_order_id
,channel
,consumer_sys_id
,trans_ref_num
,status_id
,interest_balance
,parent_trans_id
,comments
,performed_by_party_id
,reason_enum_id
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,from_date
,thru_date
,deposit_period
from ${idl_schema}.odss_eat_fin_account_trans_00
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_eat_fin_account_trans_00_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes