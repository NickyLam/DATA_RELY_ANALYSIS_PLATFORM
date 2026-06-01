: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_eass_party_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_eass_party.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.party_id
,t1.party_type_id
,t1.external_id
,t1.preferred_currency_uom_id
,t1.description
,t1.status_id
,t1.created_date
,t1.created_by_user_login
,t1.last_modified_date
,t1.last_modified_by_user_login
,t1.data_source_id
,t1.is_unread
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_eass_party t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_eass_party.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes