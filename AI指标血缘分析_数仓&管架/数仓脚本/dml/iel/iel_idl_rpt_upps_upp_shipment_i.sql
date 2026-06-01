: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_upps_upp_shipment_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_upps_upp_shipment.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.shipment_id,chr(13),''),chr(10),'') as shipment_id
,replace(replace(t1.shipment_type_id,chr(13),''),chr(10),'') as shipment_type_id
,replace(replace(t1.primary_order_id,chr(13),''),chr(10),'') as primary_order_id
,replace(replace(t1.primary_return_id,chr(13),''),chr(10),'') as primary_return_id
,replace(replace(t1.currency_uom_id,chr(13),''),chr(10),'') as currency_uom_id
,t1.quantity as quantity
,replace(replace(t1.party_id_from,chr(13),''),chr(10),'') as party_id_from
,replace(replace(t1.party_id_to,chr(13),''),chr(10),'') as party_id_to
,replace(replace(t1.product_id,chr(13),''),chr(10),'') as product_id
,replace(replace(t1.orig_shipment_id,chr(13),''),chr(10),'') as orig_shipment_id
,replace(replace(t1.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t1.shipment_box_type_id,chr(13),''),chr(10),'') as shipment_box_type_id
,replace(replace(t1.is_pre_authorization,chr(13),''),chr(10),'') as is_pre_authorization
,replace(replace(t1.payment_method_id,chr(13),''),chr(10),'') as payment_method_id
,replace(replace(t1.payment_method_party_id,chr(13),''),chr(10),'') as payment_method_party_id
,replace(replace(t1.shipment_method_type_id,chr(13),''),chr(10),'') as shipment_method_type_id
,t1.shipment_date as shipment_date
,t1.path_date as path_date
,replace(replace(t1.carrier_party_id,chr(13),''),chr(10),'') as carrier_party_id
,replace(replace(t1.transaction_id,chr(13),''),chr(10),'') as transaction_id
,replace(replace(t1.global_trans_id,chr(13),''),chr(10),'') as global_trans_id
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
 from iol.upps_upp_shipment T1
where to_char(created_tx_stamp,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_upps_upp_shipment.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes