: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_eat_product_price_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_eat_product_price_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
product_id
,product_price_type_id
,product_price_purpose_id
,currency_uom_id
,product_store_group_id
,from_date
,thru_date
,price
,term_uom_id
,custom_price_calc_service
,created_date
,created_by_user_login
,last_modified_date
,last_modified_by_user_login
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
from ${idl_schema}.crms_eat_product_price
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_eat_product_price_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes