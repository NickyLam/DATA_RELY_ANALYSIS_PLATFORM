: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_points_pool_input_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_points_pool_input.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.key_id,chr(13),''),chr(10),'') as key_id
    ,replace(replace(t.loan_no,chr(13),''),chr(10),'') as loan_no
    ,replace(replace(t.var0001,chr(13),''),chr(10),'') as var0001
    ,t.var0308 as var0308
    ,replace(replace(t.a_grade,chr(13),''),chr(10),'') as a_grade
    ,replace(replace(t.bc_grade,chr(13),''),chr(10),'') as bc_grade
    ,replace(replace(t.overdue_flag,chr(13),''),chr(10),'') as overdue_flag
    ,t.var0202 as var0202
    ,t.var0430 as var0430
    ,t.var0407 as var0407
    ,replace(replace(t.valid_gender_cd,chr(13),''),chr(10),'') as valid_gender_cd
    ,replace(replace(t.default_flag,chr(13),''),chr(10),'') as default_flag
    ,t.var0309 as var0309
    ,t.var0305 as var0305
    ,t.var0002 as var0002
    ,t.age as age
    ,replace(replace(t.ghb_emp_flg,chr(13),''),chr(10),'') as ghb_emp_flg
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.data_dt,chr(13),''),chr(10),'') as data_dt
    ,replace(replace(t.pool_type,chr(13),''),chr(10),'') as pool_type
    ,replace(replace(t.mode_type,chr(13),''),chr(10),'') as mode_type
    ,t.loan_total_bal as loan_total_bal
    ,t.pdsum as pdsum
    ,replace(replace(t.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
    ,replace(replace(t.loan_assis_flag,chr(13),''),chr(10),'') as loan_assis_flag
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_points_pool_input t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_points_pool_input.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes