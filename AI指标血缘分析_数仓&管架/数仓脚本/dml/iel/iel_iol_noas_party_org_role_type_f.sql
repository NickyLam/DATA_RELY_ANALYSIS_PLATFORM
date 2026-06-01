: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_noas_party_org_role_type_f
CreateDate: 20180529
FileName:   ${iel_data_path}/noas_party_org_role_type.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.organ_code_key,chr(13),''),chr(10),'') as organ_code_key 
,replace(replace(t1.role_type_id,chr(13),''),chr(10),'') as role_type_id 
,t1.last_updated_stamp as last_updated_stamp 
,t1.last_updated_tx_stamp as last_updated_tx_stamp 
,t1.created_stamp as created_stamp 
,t1.created_tx_stamp as created_tx_stamp 
,t1.role_order_num as role_order_num 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.noas_party_org_role_type t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/noas_party_org_role_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes