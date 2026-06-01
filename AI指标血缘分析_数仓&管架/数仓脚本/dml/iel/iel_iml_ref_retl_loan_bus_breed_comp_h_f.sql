: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_retl_loan_bus_breed_comp_h_f
CreateDate: 20220819
FileName:   ${iel_data_path}/ref_retl_loan_bus_breed_comp_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.prod_cd,chr(13),''),chr(10),'') as prod_cd
    ,replace(replace(t.prod_field_en_name,chr(13),''),chr(10),'') as prod_field_en_name
    ,replace(replace(t.prod_field_cn_name,chr(13),''),chr(10),'') as prod_field_cn_name
    ,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name
    ,replace(replace(t.loan_bus_breed_field_name,chr(13),''),chr(10),'') as loan_bus_breed_field_name
    ,replace(replace(t.loan_bus_breed_cd,chr(13),''),chr(10),'') as loan_bus_breed_cd
    ,replace(replace(t.loan_bus_breed_name,chr(13),''),chr(10),'') as loan_bus_breed_name
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.ref_retl_loan_bus_breed_comp_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_retl_loan_bus_breed_comp_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes