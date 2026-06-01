: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_upps_upp_shipment_i
CreateDate: 20180529
FileName:   ${iel_data_path}/upps_upp_shipment.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.shipment_id,chr(13),''),chr(10),'') as shipment_id
,replace(replace(t.shipment_type_id,chr(13),''),chr(10),'') as shipment_type_id
,replace(replace(t.primary_order_id,chr(13),''),chr(10),'') as primary_order_id
,replace(replace(t.primary_return_id,chr(13),''),chr(10),'') as primary_return_id
,replace(replace(t.currency_uom_id,chr(13),''),chr(10),'') as currency_uom_id
,t.quantity as quantity
,replace(replace(t.party_id_from,chr(13),''),chr(10),'') as party_id_from
,replace(replace(t.party_id_to,chr(13),''),chr(10),'') as party_id_to
,replace(replace(t.product_id,chr(13),''),chr(10),'') as product_id
,replace(replace(t.orig_shipment_id,chr(13),''),chr(10),'') as orig_shipment_id
,replace(replace(t.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t.shipment_box_type_id,chr(13),''),chr(10),'') as shipment_box_type_id
,replace(replace(t.is_pre_authorization,chr(13),''),chr(10),'') as is_pre_authorization
,replace(replace(t.payment_method_id,chr(13),''),chr(10),'') as payment_method_id
,replace(replace(t.payment_method_party_id,chr(13),''),chr(10),'') as payment_method_party_id
,replace(replace(t.shipment_method_type_id,chr(13),''),chr(10),'') as shipment_method_type_id
,t.shipment_date as shipment_date
,t.path_date as path_date
,replace(replace(t.carrier_party_id,chr(13),''),chr(10),'') as carrier_party_id
,replace(replace(t.transaction_id,chr(13),''),chr(10),'') as transaction_id
,replace(replace(t.global_trans_id,chr(13),''),chr(10),'') as global_trans_id
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
from iol.upps_upp_shipment t
where to_char(created_tx_stamp,'yyyymmdd')='${batch_date}';
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/upps_upp_shipment.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes