: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_eass_product_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_eass_product.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.product_id,chr(13),''),chr(10),'') as product_id
,replace(replace(t1.product_type_id,chr(13),''),chr(10),'') as product_type_id
,replace(replace(t1.primary_product_category_id,chr(13),''),chr(10),'') as primary_product_category_id
,replace(replace(t1.manufacturer_party_id,chr(13),''),chr(10),'') as manufacturer_party_id
,replace(replace(t1.facility_id,chr(13),''),chr(10),'') as facility_id
,replace(replace(t1.comments,chr(13),''),chr(10),'') as comments
,replace(replace(t1.product_name,chr(13),''),chr(10),'') as product_name
,replace(replace(t1.description,chr(13),''),chr(10),'') as description
,replace(replace(t1.config_id,chr(13),''),chr(10),'') as config_id
,t1.created_date as created_date
,replace(replace(t1.created_by_user_login,chr(13),''),chr(10),'') as created_by_user_login
,t1.last_modified_date as last_modified_date
,replace(replace(t1.last_modified_by_user_login,chr(13),''),chr(10),'') as last_modified_by_user_login
,replace(replace(t1.in_shipping_box,chr(13),''),chr(10),'') as in_shipping_box
,replace(replace(t1.default_shipment_box_type_id,chr(13),''),chr(10),'') as default_shipment_box_type_id
,replace(replace(t1.requirement_method_enum_id,chr(13),''),chr(10),'') as requirement_method_enum_id
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
 from iol.eass_product T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_eass_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes