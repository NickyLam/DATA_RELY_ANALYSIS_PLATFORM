: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_eass_party_attribute_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_eass_party_attribute.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.attr_name,chr(13),''),chr(10),'') as attr_name
,replace(replace(t1.attr_value,chr(13),''),chr(10),'') as attr_value
,replace(replace(t1.attr_desc,chr(13),''),chr(10),'') as attr_desc
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
,replace(replace(t1.attr_group,chr(13),''),chr(10),'') as attr_group
,replace(replace(t1.attr_type,chr(13),''),chr(10),'') as attr_type
 from iol.eass_party_attribute T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_eass_party_attribute.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes