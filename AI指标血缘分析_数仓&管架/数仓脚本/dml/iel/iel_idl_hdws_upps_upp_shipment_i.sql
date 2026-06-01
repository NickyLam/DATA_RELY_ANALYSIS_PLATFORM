: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_upps_upp_shipment_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_upps_upp_shipment.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.shipment_id
,t1.shipment_type_id
,t1.primary_order_id
,t1.primary_return_id
,t1.currency_uom_id
,t1.quantity
,t1.party_id_from
,t1.party_id_to
,t1.product_id
,t1.orig_shipment_id
,t1.status_id
,t1.shipment_box_type_id
,t1.is_pre_authorization
,t1.payment_method_id
,t1.payment_method_party_id
,t1.shipment_method_type_id
,t1.shipment_date
,t1.path_date
,t1.carrier_party_id
,t1.transaction_id
,t1.global_trans_id
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
from ${idl_schema}.hdws_upps_upp_shipment t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_upps_upp_shipment.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes