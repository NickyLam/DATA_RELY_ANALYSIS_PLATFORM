: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eass_party_f
CreateDate: 20180529
FileName:   ${iel_data_path}/eass_party.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.party_type_id,chr(13),''),chr(10),'') as party_type_id
,replace(replace(t.external_id,chr(13),''),chr(10),'') as external_id
,replace(replace(t.preferred_currency_uom_id,chr(13),''),chr(10),'') as preferred_currency_uom_id
,replace(replace(t.description,chr(13),''),chr(10),'') as description
,replace(replace(t.status_id,chr(13),''),chr(10),'') as status_id
,t.created_date as created_date
,replace(replace(t.created_by_user_login,chr(13),''),chr(10),'') as created_by_user_login
,t.last_modified_date as last_modified_date
,replace(replace(t.last_modified_by_user_login,chr(13),''),chr(10),'') as last_modified_by_user_login
,replace(replace(t.data_source_id,chr(13),''),chr(10),'') as data_source_id
,replace(replace(t.is_unread,chr(13),''),chr(10),'') as is_unread
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.eass_party t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eass_party.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes