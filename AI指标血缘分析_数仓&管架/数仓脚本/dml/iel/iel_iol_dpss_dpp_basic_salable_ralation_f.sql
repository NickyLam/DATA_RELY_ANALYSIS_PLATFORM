: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_dpss_dpp_basic_salable_ralation_f
CreateDate: 20180529
FileName:   ${iel_data_path}/dpss_dpp_basic_salable_ralation.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.basic_prodid,chr(13),''),chr(10),'') as basic_prodid
,replace(replace(t.salable_prodid,chr(13),''),chr(10),'') as salable_prodid
,replace(replace(t.prod_innerno,chr(13),''),chr(10),'') as prod_innerno
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,replace(replace(t.prod_custom_info,chr(13),''),chr(10),'') as prod_custom_info
,replace(replace(t.prod_info,chr(13),''),chr(10),'') as prod_info
,replace(replace(t.prod_org_info,chr(13),''),chr(10),'') as prod_org_info
,replace(replace(t.prod_channel_info,chr(13),''),chr(10),'') as prod_channel_info
,replace(replace(t.process_ins_id,chr(13),''),chr(10),'') as process_ins_id
,replace(replace(t.prod_status,chr(13),''),chr(10),'') as prod_status
,replace(replace(t.prod_message,chr(13),''),chr(10),'') as prod_message
,replace(replace(t.create_prod_person_name,chr(13),''),chr(10),'') as create_prod_person_name
,t.approve_date as approve_date
,replace(replace(t.product_name,chr(13),''),chr(10),'') as product_name
,replace(replace(t.is_delete,chr(13),''),chr(10),'') as is_delete
,replace(replace(t.znck_flow_sequence,chr(13),''),chr(10),'') as znck_flow_sequence
,replace(replace(t.send_prod_upper_msg,chr(13),''),chr(10),'') as send_prod_upper_msg
,replace(replace(t.send_cust_org_upper_msg,chr(13),''),chr(10),'') as send_cust_org_upper_msg
,replace(replace(t.receive_prod_upper_msg,chr(13),''),chr(10),'') as receive_prod_upper_msg
,replace(replace(t.receive_cust_org_upper_msg,chr(13),''),chr(10),'') as receive_cust_org_upper_msg
,replace(replace(t.prod_feature_info,chr(13),''),chr(10),'') as prod_feature_info
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.dpss_dpp_basic_salable_ralation t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/dpss_dpp_basic_salable_ralation.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes