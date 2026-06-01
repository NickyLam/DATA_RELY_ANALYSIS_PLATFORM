: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_eass_party_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_eass_party.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.party_type_id,chr(13),''),chr(10),'') as party_type_id
,replace(replace(t1.external_id,chr(13),''),chr(10),'') as external_id
,replace(replace(t1.preferred_currency_uom_id,chr(13),''),chr(10),'') as preferred_currency_uom_id
,replace(replace(t1.description,chr(13),''),chr(10),'') as description
,replace(replace(t1.status_id,chr(13),''),chr(10),'') as status_id
,t1.created_date as created_date
,replace(replace(t1.created_by_user_login,chr(13),''),chr(10),'') as created_by_user_login
,t1.last_modified_date as last_modified_date
,replace(replace(t1.last_modified_by_user_login,chr(13),''),chr(10),'') as last_modified_by_user_login
,replace(replace(t1.data_source_id,chr(13),''),chr(10),'') as data_source_id
,replace(replace(t1.is_unread,chr(13),''),chr(10),'') as is_unread
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
 from iol.eass_party T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_eass_party.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes