: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_atms_dev_responsor_table_f
CreateDate: 20250909
FileName:   ${iel_data_path}/atms_dev_responsor_table.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.logic_id,chr(13),''),chr(10),'') as logic_id
,replace(replace(t1.dev_no,chr(13),''),chr(10),'') as dev_no
,replace(replace(t1.catalog,chr(13),''),chr(10),'') as catalog
,replace(replace(t1.grade,chr(13),''),chr(10),'') as grade
,replace(replace(t1.responser_no,chr(13),''),chr(10),'') as responser_no

from ${iol_schema}.atms_dev_responsor_table t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/atms_dev_responsor_table.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
