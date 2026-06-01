: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_bank_int_int_rat_type_para_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_bank_int_int_rat_type_para_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bank_int_int_rat_type_id,chr(13),''),chr(10),'') as bank_int_int_rat_type_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.int_rat_type_descb,chr(13),''),chr(10),'') as int_rat_type_descb
,replace(replace(t1.core_prod_group_cd,chr(13),''),chr(10),'') as core_prod_group_cd
,replace(replace(t1.int_rat_attr_cd,chr(13),''),chr(10),'') as int_rat_attr_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_bank_int_int_rat_type_para_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_bank_int_int_rat_type_para_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes