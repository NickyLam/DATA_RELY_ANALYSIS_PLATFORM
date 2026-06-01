: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_tb_par_value_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_tb_par_value.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.is_spall,chr(13),''),chr(10),'') as is_spall
,replace(replace(t1.par_desc,chr(13),''),chr(10),'') as par_desc
,replace(replace(t1.par_type,chr(13),''),chr(10),'') as par_type
,t1.par_value as par_value
,replace(replace(t1.par_value_id,chr(13),''),chr(10),'') as par_value_id
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,t1.update_date as update_date
,replace(replace(t1.spall_type,chr(13),''),chr(10),'') as spall_type
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ncbs_tb_par_value t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_tb_par_value.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes