: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_bu_mb_prod_label_info_f
CreateDate: 20251209
FileName:   ${iel_data_path}/ncbs_bu_mb_prod_label_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.label_key,chr(13),''),chr(10),'') as label_key
,replace(replace(t1.label_value,chr(13),''),chr(10),'') as label_value
,replace(replace(t1.label_value_desc,chr(13),''),chr(10),'') as label_value_desc
,replace(replace(t1.om_dept_id,chr(13),''),chr(10),'') as om_dept_id
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id

from ${iol_schema}.ncbs_bu_mb_prod_label_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_bu_mb_prod_label_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
