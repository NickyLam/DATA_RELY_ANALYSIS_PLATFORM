: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_dc_stage_int_matrix_f
CreateDate: 20230130
FileName:   ${iel_data_path}/ncbs_rb_dc_stage_int_matrix.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.matrix_no,chr(13),''),chr(10),'') as matrix_no
,replace(replace(t1.stage_code,chr(13),''),chr(10),'') as stage_code
,replace(replace(t1.int_type,chr(13),''),chr(10),'') as int_type
,replace(replace(t1.year_basis,chr(13),''),chr(10),'') as year_basis
,effect_date
,replace(replace(t1.period_freq,chr(13),''),chr(10),'') as period_freq
,day_num
,real_rate
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.ncbs_rb_dc_stage_int_matrix t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_dc_stage_int_matrix.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
