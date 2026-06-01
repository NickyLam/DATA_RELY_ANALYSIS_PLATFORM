: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eass_party_attribute_f
CreateDate: 20180529
FileName:   ${iel_data_path}/eass_party_attribute.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.attr_name,chr(13),''),chr(10),'') as attr_name
,replace(replace(t.attr_value,chr(13),''),chr(10),'') as attr_value
,replace(replace(t.attr_desc,chr(13),''),chr(10),'') as attr_desc
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,replace(replace(t.attr_group,chr(13),''),chr(10),'') as attr_group
,replace(replace(t.attr_type,chr(13),''),chr(10),'') as attr_type
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.eass_party_attribute t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eass_party_attribute.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes