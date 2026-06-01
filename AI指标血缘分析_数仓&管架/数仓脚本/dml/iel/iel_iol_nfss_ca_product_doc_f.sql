: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nfss_ca_product_doc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nfss_ca_product_doc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.prd_cd,chr(13),''),chr(10),'') as prd_cd
,replace(replace(t.doc_id,chr(13),''),chr(10),'') as doc_id
,replace(replace(t.doc_name,chr(13),''),chr(10),'') as doc_name
,replace(replace(t.doc_url,chr(13),''),chr(10),'') as doc_url
,replace(replace(t.file_id,chr(13),''),chr(10),'') as file_id
,replace(replace(t.file_type,chr(13),''),chr(10),'') as file_type
,t.created_time as created_time
,replace(replace(t.created_by,chr(13),''),chr(10),'') as created_by
,t.updated_time as updated_time
,replace(replace(t.updated_by,chr(13),''),chr(10),'') as updated_by
,replace(replace(t.sign_type,chr(13),''),chr(10),'') as sign_type
,replace(replace(t.parent_id,chr(13),''),chr(10),'') as parent_id
,replace(replace(t.sign_status,chr(13),''),chr(10),'') as sign_status
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.nfss_ca_product_doc t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_ca_product_doc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes