: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fems_em_orging_mapping_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fems_em_orging_mapping.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.maping_id,chr(13),''),chr(10),'') as maping_id
,replace(replace(t1.org_code,chr(13),''),chr(10),'') as org_code
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.fpm_org_code,chr(13),''),chr(10),'') as fpm_org_code
,replace(replace(t1.fpm_dept_code,chr(13),''),chr(10),'') as fpm_dept_code
,t1.create_date as create_date
,t1.update_date as update_date
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.fems_em_orging_mapping t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fems_em_orging_mapping.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes