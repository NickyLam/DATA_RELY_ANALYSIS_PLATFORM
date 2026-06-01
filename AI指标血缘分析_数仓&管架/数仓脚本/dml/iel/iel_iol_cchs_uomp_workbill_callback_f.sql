: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cchs_uomp_workbill_callback_f
CreateDate: 20240822
FileName:   ${iel_data_path}/cchs_uomp_workbill_callback.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.workbill_no,chr(13),''),chr(10),'') as workbill_no
,replace(replace(t1.return_visit_date,chr(13),''),chr(10),'') as return_visit_date
,replace(replace(t1.create_name,chr(13),''),chr(10),'') as create_name
,replace(replace(t1.return_visit_content,chr(13),''),chr(10),'') as return_visit_content

from ${iol_schema}.cchs_uomp_workbill_callback t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cchs_uomp_workbill_callback.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
