: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_rcd_ir_grade_a_score_result_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_rcd_ir_grade_a_score_result.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.serialno,chr(13),''),chr(10),'') as serialno
    ,replace(replace(t.data_time,chr(13),''),chr(10),'') as data_time
    ,replace(replace(t.rist_level,chr(13),''),chr(10),'') as rist_level
    ,t.grade as grade
    ,replace(replace(t.mode_type,chr(13),''),chr(10),'') as mode_type
    ,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
    ,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
    ,replace(replace(t.customerid,chr(13),''),chr(10),'') as customerid
    ,replace(replace(t.input_br_id,chr(13),''),chr(10),'') as input_br_id
    ,replace(replace(t.input_br_id_all,chr(13),''),chr(10),'') as input_br_id_all
    ,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
    ,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_rcd_ir_grade_a_score_result t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_rcd_ir_grade_a_score_result.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes