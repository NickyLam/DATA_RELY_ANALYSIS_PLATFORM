: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_rcd_ir_grade_a_score_result_f
CreateDate: 20241012
FileName:   ${iel_data_path}/rsts_rcd_ir_grade_a_score_result.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.data_time,chr(13),''),chr(10),'') as data_time
,replace(replace(t1.rist_level,chr(13),''),chr(10),'') as rist_level
,grade
,replace(replace(t1.mode_type,chr(13),''),chr(10),'') as mode_type
,replace(replace(t1.cus_name,chr(13),''),chr(10),'') as cus_name
,replace(replace(t1.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.input_br_id,chr(13),''),chr(10),'') as input_br_id
,replace(replace(t1.input_br_id_all,chr(13),''),chr(10),'') as input_br_id_all
,replace(replace(t1.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t1.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t1.rerun_flag,chr(13),''),chr(10),'') as rerun_flag

from ${iol_schema}.rsts_rcd_ir_grade_a_score_result t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_rcd_ir_grade_a_score_result.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
