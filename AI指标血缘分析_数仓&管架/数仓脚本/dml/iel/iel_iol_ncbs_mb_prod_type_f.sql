: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_mb_prod_type_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_mb_prod_type.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.gl_merge_type_flag,chr(13),''),chr(10),'') as gl_merge_type_flag
,replace(replace(t1.prod_desc,chr(13),''),chr(10),'') as prod_desc
,replace(replace(t1.prod_group_flag,chr(13),''),chr(10),'') as prod_group_flag
,replace(replace(t1.prod_range,chr(13),''),chr(10),'') as prod_range
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.prod_class,chr(13),''),chr(10),'') as prod_class
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.base_prod_type,chr(13),''),chr(10),'') as base_prod_type
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ncbs_mb_prod_type t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_mb_prod_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes