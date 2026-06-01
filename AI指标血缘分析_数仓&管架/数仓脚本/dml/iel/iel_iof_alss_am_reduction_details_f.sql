: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_alss_am_reduction_details_f
CreateDate: 20250828
FileName:   ${iel_data_path}/alss_am_reduction_details.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.wtafr,chr(13),''),chr(10),'') as wtafr
,replace(replace(t1.adfr_date,chr(13),''),chr(10),'') as adfr_date
,replace(replace(t1.wtris,chr(13),''),chr(10),'') as wtris
,replace(replace(t1.var_type,chr(13),''),chr(10),'') as var_type
,replace(replace(t1.wticl,chr(13),''),chr(10),'') as wticl
,replace(replace(t1.doc_l_name,chr(13),''),chr(10),'') as doc_l_name
,replace(replace(t1.var_doc_id,chr(13),''),chr(10),'') as var_doc_id
,replace(replace(t1.data_release_id,chr(13),''),chr(10),'') as data_release_id
,replace(replace(t1.var_doc_name,chr(13),''),chr(10),'') as var_doc_name

from ${iol_schema}.alss_am_reduction_details t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_am_reduction_details.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
