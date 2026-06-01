: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_comn_loan_int_set_way_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_comn_loan_int_set_way_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.int_set_way_id,chr(13),''),chr(10),'') as int_set_way_id
    ,replace(replace(t.int_set_way_name,chr(13),''),chr(10),'') as int_set_way_name
    ,replace(replace(t.int_set_type_cd,chr(13),''),chr(10),'') as int_set_type_cd
    ,t.int_set_freq as int_set_freq
    ,replace(replace(t.int_set_day_type_cd,chr(13),''),chr(10),'') as int_set_day_type_cd
    ,replace(replace(t.spec_int_set_day,chr(13),''),chr(10),'') as spec_int_set_day
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.ref_comn_loan_int_set_way_para t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_comn_loan_int_set_way_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes