: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_contact_list_f
CreateDate: 20240328
FileName:   ${iel_data_path}/ncbs_rb_contact_list.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.document_id,chr(13),''),chr(10),'') as document_id
,replace(replace(t1.document_type,chr(13),''),chr(10),'') as document_type
,internal_key
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.contact_status,chr(13),''),chr(10),'') as contact_status
,replace(replace(t1.contact_type,chr(13),''),chr(10),'') as contact_type
,replace(replace(t1.linkman_desc,chr(13),''),chr(10),'') as linkman_desc
,replace(replace(t1.linkman_type,chr(13),''),chr(10),'') as linkman_type
,replace(replace(t1.phone_no1,chr(13),''),chr(10),'') as phone_no1
,replace(replace(t1.phone_no2,chr(13),''),chr(10),'') as phone_no2
,last_change_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,replace(replace(t1.linkman_name,chr(13),''),chr(10),'') as linkman_name
,replace(replace(t1.check_certificate_order,chr(13),''),chr(10),'') as check_certificate_order
,replace(replace(t1.contact_class,chr(13),''),chr(10),'') as contact_class
,replace(replace(t1.check_certificate_flag,chr(13),''),chr(10),'') as check_certificate_flag

from ${iol_schema}.ncbs_rb_contact_list t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_contact_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
