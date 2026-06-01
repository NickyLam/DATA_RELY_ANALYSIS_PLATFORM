: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_eass_product_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_eass_product.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.product_id
,t1.product_type_id
,t1.primary_product_category_id
,t1.manufacturer_party_id
,t1.facility_id
,t1.comments
,t1.product_name
,t1.description
,t1.config_id
,t1.created_date
,t1.created_by_user_login
,t1.last_modified_date
,t1.last_modified_by_user_login
,t1.in_shipping_box
,t1.default_shipment_box_type_id
,t1.requirement_method_enum_id
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
,t1.introduction_date
,t1.support_discontinuation_date
,t1.sales_discontinuation_date
,t1.sales_disc_when_not_avail
,t1.internal_name
,t1.brand_name
,t1.long_description
,t1.price_detail_text
,t1.small_image_url
,t1.medium_image_url
,t1.large_image_url
,t1.detail_image_url
,t1.original_image_url
,t1.detail_screen
,t1.inventory_message
,t1.require_inventory
,t1.quantity_uom_id
,t1.quantity_included
,t1.pieces_included
,t1.require_amount
,t1.fixed_amount
,t1.amount_uom_type_id
,t1.weight_uom_id
,t1.weight
,t1.height_uom_id
,t1.product_height
,t1.shipping_height
,t1.width_uom_id
,t1.product_width
,t1.shipping_width
,t1.depth_uom_id
,t1.product_depth
,t1.shipping_depth
,t1.product_rating
,t1.rating_type_enum
,t1.returnable
,t1.taxable
,t1.charge_shipping
,t1.auto_create_keywords
,t1.include_in_promotions
,t1.is_virtual
,t1.is_variant
,t1.virtual_variant_method_enum
,t1.origin_geo_id
,t1.bill_of_material_level
,t1.reserv_max_persons
,t1.reserv2nd_p_p_perc
,t1.reserv_nth_p_p_perc
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_eass_product t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_eass_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes