: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_bill_bus_code_subj_rela_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ref_bill_bus_code_subj_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(subj_id,chr(13),''),chr(10),'')
,replace(replace(subj_name,chr(13),''),chr(10),'')
,replace(replace(bus_code,chr(13),''),chr(10),'')
,replace(replace(amt_type_cd,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.ref_bill_bus_code_subj_rela t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_bill_bus_code_subj_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
