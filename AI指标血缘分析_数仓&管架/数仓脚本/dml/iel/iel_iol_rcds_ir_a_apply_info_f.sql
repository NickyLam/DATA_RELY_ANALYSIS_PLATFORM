: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_a_apply_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_a_apply_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.application_num,chr(13),''),chr(10),'') as application_num
    ,replace(replace(t.data_time,chr(13),''),chr(10),'') as data_time
    ,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
    ,t.loan_amt_raw as loan_amt_raw
    ,replace(replace(t.loan_cur,chr(13),''),chr(10),'') as loan_cur
    ,replace(replace(t.loan_cur_std,chr(13),''),chr(10),'') as loan_cur_std
    ,replace(replace(t.repay_mode,chr(13),''),chr(10),'') as repay_mode
    ,replace(replace(t.repay_mode_std,chr(13),''),chr(10),'') as repay_mode_std
    ,replace(replace(t.loan_purpose,chr(13),''),chr(10),'') as loan_purpose
    ,replace(replace(t.loan_purpose_desc,chr(13),''),chr(10),'') as loan_purpose_desc
    ,t.original_loan_term_raw as original_loan_term_raw
    ,replace(replace(t.prod_type_raw,chr(13),''),chr(10),'') as prod_type_raw
    ,replace(replace(t.prod_type_raw_std,chr(13),''),chr(10),'') as prod_type_raw_std
    ,replace(replace(t.cus_manager,chr(13),''),chr(10),'') as cus_manager
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_a_apply_info t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_a_apply_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes