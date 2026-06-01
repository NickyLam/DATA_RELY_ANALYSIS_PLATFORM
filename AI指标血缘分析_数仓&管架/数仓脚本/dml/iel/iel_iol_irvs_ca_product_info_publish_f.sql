: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_irvs_ca_product_info_publish_f
CreateDate: 20220916
FileName:   ${iel_data_path}/irvs_ca_product_info_publish.f.${batch_date}.dat
IF_mark:    f
Logs:
   Sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.prd_cd,chr(13),''),chr(10),'') as prd_cd
    ,replace(replace(t.title,chr(13),''),chr(10),'') as title
    ,replace(replace(t.content,chr(13),''),chr(10),'') as content
    ,replace(replace(t.doc_id,chr(13),''),chr(10),'') as doc_id
    ,replace(replace(t.doc_name,chr(13),''),chr(10),'') as doc_name
    ,replace(replace(t.doc_url,chr(13),''),chr(10),'') as doc_url
    ,t.created_time as created_time
    ,replace(replace(t.created_by,chr(13),''),chr(10),'') as created_by
    ,t.updated_time as updated_time
    ,replace(replace(t.updated_by,chr(13),''),chr(10),'') as updated_by
    ,replace(replace(t.report_period,chr(13),''),chr(10),'') as report_period
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.irvs_ca_product_info_publish t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/irvs_ca_product_info_publish.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes