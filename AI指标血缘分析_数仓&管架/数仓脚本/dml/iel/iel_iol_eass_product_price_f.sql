: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eass_product_price_f
CreateDate: 20180529
FileName:   ${iel_data_path}/eass_product_price.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.product_id,chr(13),''),chr(10),'') as product_id
    ,replace(replace(t.product_price_type_id,chr(13),''),chr(10),'') as product_price_type_id
    ,replace(replace(t.product_price_purpose_id,chr(13),''),chr(10),'') as product_price_purpose_id
    ,replace(replace(t.currency_uom_id,chr(13),''),chr(10),'') as currency_uom_id
    ,replace(replace(t.product_store_group_id,chr(13),''),chr(10),'') as product_store_group_id
    ,t.from_date as from_date
    ,t.thru_date as thru_date
    ,t.price as price
    ,replace(replace(t.term_uom_id,chr(13),''),chr(10),'') as term_uom_id
    ,replace(replace(t.custom_price_calc_service,chr(13),''),chr(10),'') as custom_price_calc_service
    ,t.created_date as created_date
    ,replace(replace(t.created_by_user_login,chr(13),''),chr(10),'') as created_by_user_login
    ,t.last_modified_date as last_modified_date
    ,replace(replace(t.last_modified_by_user_login,chr(13),''),chr(10),'') as last_modified_by_user_login
    ,t.last_updated_stamp as last_updated_stamp
    ,t.last_updated_tx_stamp as last_updated_tx_stamp
    ,t.created_stamp as created_stamp
    ,t.created_tx_stamp as created_tx_stamp
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.eass_product_price t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eass_product_price.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes