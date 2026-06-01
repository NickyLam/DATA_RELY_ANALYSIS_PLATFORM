: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_loan_base_rat_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_loan_base_rat_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.base_rat_cd,chr(13),''),chr(10),'') as base_rat_cd
,t.effect_dt as effect_dt
,t.invalid_dt as invalid_dt
,t.year_int_rat as year_int_rat
,replace(replace(t.int_rat_status_cd,chr(13),''),chr(10),'') as int_rat_status_cd
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_loan_base_rat_h t 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_loan_base_rat_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes