: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_eass_party_attribute_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_eass_party_attribute.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.party_id
,t1.attr_name
,t1.attr_value
,t1.attr_desc
,t1.last_updated_stamp
,t1.last_updated_tx_stamp
,t1.created_stamp
,t1.created_tx_stamp
,t1.attr_group
,t1.attr_type
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_eass_party_attribute t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_eass_party_attribute.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes