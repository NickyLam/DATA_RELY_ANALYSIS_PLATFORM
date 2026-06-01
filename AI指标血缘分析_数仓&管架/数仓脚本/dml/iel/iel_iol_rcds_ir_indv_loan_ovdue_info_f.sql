: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_ir_indv_loan_ovdue_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_ir_indv_loan_ovdue_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.key_id,chr(13),''),chr(10),'') as key_id
    ,replace(replace(t.grade_key_id,chr(13),''),chr(10),'') as grade_key_id
    ,replace(replace(t.data_time,chr(13),''),chr(10),'') as data_time
    ,replace(replace(t.ovdue_rec_start_year_mon,chr(13),''),chr(10),'') as ovdue_rec_start_year_mon
    ,replace(replace(t.indv_loan_info_seq_num,chr(13),''),chr(10),'') as indv_loan_info_seq_num
    ,t.ovdue_amt as ovdue_amt
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcds_ir_indv_loan_ovdue_info t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_ir_indv_loan_ovdue_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes