: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_alss_am_accountability_details_f
CreateDate: 20250828
FileName:   ${iel_data_path}/alss_am_accountability_details.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.wthsa,chr(13),''),chr(10),'') as wthsa
,replace(replace(t1.cta_num,chr(13),''),chr(10),'') as cta_num
,replace(replace(t1.cta_m,chr(13),''),chr(10),'') as cta_m
,replace(replace(t1.cta_dfa,chr(13),''),chr(10),'') as cta_dfa
,replace(replace(t1.cta_user,chr(13),''),chr(10),'') as cta_user
,replace(replace(t1.cta_desc,chr(13),''),chr(10),'') as cta_desc
,replace(replace(t1.cta_doc_id,chr(13),''),chr(10),'') as cta_doc_id
,replace(replace(t1.data_release_id,chr(13),''),chr(10),'') as data_release_id
,replace(replace(t1.cta_doc_name,chr(13),''),chr(10),'') as cta_doc_name

from ${iol_schema}.alss_am_accountability_details t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_am_accountability_details.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
