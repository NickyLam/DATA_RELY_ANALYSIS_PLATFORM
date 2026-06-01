: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eass_v_product_f
CreateDate: 20180529
FileName:   ${iel_data_path}/eass_v_product.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.product_id,chr(13),''),chr(10),'') as product_id
,replace(replace(t.product_type_id,chr(13),''),chr(10),'') as product_type_id
,replace(replace(t.primary_product_category_id,chr(13),''),chr(10),'') as primary_product_category_id
,replace(replace(t.manufacturer_party_id,chr(13),''),chr(10),'') as manufacturer_party_id
,replace(replace(t.facility_id,chr(13),''),chr(10),'') as facility_id
,replace(replace(t.comments,chr(13),''),chr(10),'') as comments
,replace(replace(t.product_name,chr(13),''),chr(10),'') as product_name
,replace(replace(t.description,chr(13),''),chr(10),'') as description
,replace(replace(t.config_id,chr(13),''),chr(10),'') as config_id
,t.created_date as created_date
,replace(replace(t.created_by_user_login,chr(13),''),chr(10),'') as created_by_user_login
,t.last_modified_date as last_modified_date
,replace(replace(t.last_modified_by_user_login,chr(13),''),chr(10),'') as last_modified_by_user_login
,replace(replace(t.in_shipping_box,chr(13),''),chr(10),'') as in_shipping_box
,replace(replace(t.default_shipment_box_type_id,chr(13),''),chr(10),'') as default_shipment_box_type_id
,replace(replace(t.requirement_method_enum_id,chr(13),''),chr(10),'') as requirement_method_enum_id
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.eass_product t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eass_v_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes