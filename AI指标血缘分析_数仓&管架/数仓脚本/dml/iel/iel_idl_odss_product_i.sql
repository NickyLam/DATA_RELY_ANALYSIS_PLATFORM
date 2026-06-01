: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_product_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_product_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
product_id
,product_type_id
,primary_product_category_id
,manufacturer_party_id
,facility_id
,introduction_date
,support_discontinuation_date
,sales_discontinuation_date
,sales_disc_when_not_avail
,internal_name
,brand_name
,comments
,product_name
,description
,long_description
,price_detail_text
,small_image_url
,medium_image_url
,large_image_url
,detail_image_url
,original_image_url
,detail_screen
,inventory_message
,require_inventory
,quantity_uom_id
,quantity_included
,pieces_included
,require_amount
,fixed_amount
,amount_uom_type_id
,weight_uom_id
,weight
,height_uom_id
,product_height
,shipping_height
,width_uom_id
,product_width
,shipping_width
,depth_uom_id
,product_depth
,shipping_depth
,product_rating
,rating_type_enum
,returnable
,taxable
,charge_shipping
,auto_create_keywords
,include_in_promotions
,is_virtual
,is_variant
,virtual_variant_method_enum
,origin_geo_id
,requirement_method_enum_id
,bill_of_material_level
,reserv_max_persons
,reserv2nd_p_p_perc
,reserv_nth_p_p_perc
,config_id
,created_date
,created_by_user_login
,last_modified_date
,last_modified_by_user_login
,in_shipping_box
,default_shipment_box_type_id
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
from ${idl_schema}.odss_product
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_product_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes