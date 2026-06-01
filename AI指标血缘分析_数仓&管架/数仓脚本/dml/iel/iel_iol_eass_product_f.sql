: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eass_product_f
CreateDate: 20180529
FileName:   ${iel_data_path}/eass_product.f.${batch_date}.dat
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
,t.introduction_date as introduction_date
,t.support_discontinuation_date as support_discontinuation_date
,t.sales_discontinuation_date as sales_discontinuation_date
,replace(replace(t.sales_disc_when_not_avail,chr(13),''),chr(10),'') as sales_disc_when_not_avail
,replace(replace(t.internal_name,chr(13),''),chr(10),'') as internal_name
,replace(replace(t.brand_name,chr(13),''),chr(10),'') as brand_name
,replace(replace(t.comments,chr(13),''),chr(10),'') as comments
,replace(replace(t.product_name,chr(13),''),chr(10),'') as product_name
,replace(replace(t.description,chr(13),''),chr(10),'') as description
,t.long_description as long_description
,replace(replace(t.price_detail_text,chr(13),''),chr(10),'') as price_detail_text
,replace(replace(t.small_image_url,chr(13),''),chr(10),'') as small_image_url
,replace(replace(t.medium_image_url,chr(13),''),chr(10),'') as medium_image_url
,replace(replace(t.large_image_url,chr(13),''),chr(10),'') as large_image_url
,replace(replace(t.detail_image_url,chr(13),''),chr(10),'') as detail_image_url
,replace(replace(t.original_image_url,chr(13),''),chr(10),'') as original_image_url
,replace(replace(t.detail_screen,chr(13),''),chr(10),'') as detail_screen
,replace(replace(t.inventory_message,chr(13),''),chr(10),'') as inventory_message
,replace(replace(t.require_inventory,chr(13),''),chr(10),'') as require_inventory
,replace(replace(t.quantity_uom_id,chr(13),''),chr(10),'') as quantity_uom_id
,t.quantity_included as quantity_included
,t.pieces_included as pieces_included
,replace(replace(t.require_amount,chr(13),''),chr(10),'') as require_amount
,t.fixed_amount as fixed_amount
,replace(replace(t.amount_uom_type_id,chr(13),''),chr(10),'') as amount_uom_type_id
,replace(replace(t.weight_uom_id,chr(13),''),chr(10),'') as weight_uom_id
,t.weight as weight
,replace(replace(t.height_uom_id,chr(13),''),chr(10),'') as height_uom_id
,t.product_height as product_height
,t.shipping_height as shipping_height
,replace(replace(t.width_uom_id,chr(13),''),chr(10),'') as width_uom_id
,t.product_width as product_width
,t.shipping_width as shipping_width
,replace(replace(t.depth_uom_id,chr(13),''),chr(10),'') as depth_uom_id
,t.product_depth as product_depth
,t.shipping_depth as shipping_depth
,t.product_rating as product_rating
,replace(replace(t.rating_type_enum,chr(13),''),chr(10),'') as rating_type_enum
,replace(replace(t.returnable,chr(13),''),chr(10),'') as returnable
,replace(replace(t.taxable,chr(13),''),chr(10),'') as taxable
,replace(replace(t.charge_shipping,chr(13),''),chr(10),'') as charge_shipping
,replace(replace(t.auto_create_keywords,chr(13),''),chr(10),'') as auto_create_keywords
,replace(replace(t.include_in_promotions,chr(13),''),chr(10),'') as include_in_promotions
,replace(replace(t.is_virtual,chr(13),''),chr(10),'') as is_virtual
,replace(replace(t.is_variant,chr(13),''),chr(10),'') as is_variant
,replace(replace(t.virtual_variant_method_enum,chr(13),''),chr(10),'') as virtual_variant_method_enum
,replace(replace(t.origin_geo_id,chr(13),''),chr(10),'') as origin_geo_id
,replace(replace(t.requirement_method_enum_id,chr(13),''),chr(10),'') as requirement_method_enum_id
,t.bill_of_material_level as bill_of_material_level
,t.reserv_max_persons as reserv_max_persons
,t.reserv2nd_p_p_perc as reserv2nd_p_p_perc
,t.reserv_nth_p_p_perc as reserv_nth_p_p_perc
,replace(replace(t.config_id,chr(13),''),chr(10),'') as config_id
,t.created_date as created_date
,replace(replace(t.created_by_user_login,chr(13),''),chr(10),'') as created_by_user_login
,t.last_modified_date as last_modified_date
,replace(replace(t.last_modified_by_user_login,chr(13),''),chr(10),'') as last_modified_by_user_login
,replace(replace(t.in_shipping_box,chr(13),''),chr(10),'') as in_shipping_box
,replace(replace(t.default_shipment_box_type_id,chr(13),''),chr(10),'') as default_shipment_box_type_id
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.eass_product t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eass_product.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes