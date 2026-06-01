: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_bank_int_ladr_h_f
CreateDate: 20221020
FileName:   ${iel_data_path}/ref_bank_int_ladr_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.ladr_seq_num,chr(13),''),chr(10),'') as ladr_seq_num
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,replace(replace(t.bank_int_int_rat_type_cd,chr(13),''),chr(10),'') as bank_int_int_rat_type_cd
    ,t.year_base_days as year_base_days
    ,t.effect_dt as effect_dt
    ,t.invalid_dt as invalid_dt
    ,replace(replace(t.base_rat_type_id,chr(13),''),chr(10),'') as base_rat_type_id
    ,replace(replace(t.base_exch_rat,chr(13),''),chr(10),'') as base_exch_rat
    ,replace(replace(t.ped_freq_cd,chr(13),''),chr(10),'') as ped_freq_cd
    ,t.eh_issue_days as eh_issue_days
    ,t.ladr_amt as ladr_amt
    ,t.bank_int_int_rat as bank_int_int_rat
    ,t.int_rat_discnt as int_rat_discnt
    ,t.float_ratio as float_ratio
    ,t.float_point as float_point
    ,t.max_cu_ratio as max_cu_ratio
    ,t.min_cu_ratio as min_cu_ratio
    ,t.min_int_rat as min_int_rat
    ,t.max_int_rat as max_int_rat
    ,t.max_float_point as max_float_point
    ,t.min_float_point as min_float_point
    ,t.max_float_ratio as max_float_ratio
    ,t.min_float_ratio as min_float_ratio
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_bank_int_ladr_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_bank_int_ladr_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
