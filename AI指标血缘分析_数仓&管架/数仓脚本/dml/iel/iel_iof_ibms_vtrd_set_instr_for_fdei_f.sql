: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ibms_vtrd_set_instr_for_fdei_f
CreateDate: 20250603
FileName:   ${iel_data_path}/ibms_vtrd_set_instr_for_fdei.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,inst_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.set_date,chr(13),''),chr(10),'') as set_date
,replace(replace(t1.core_customer_id,chr(13),''),chr(10),'') as core_customer_id
,replace(replace(t1.customer_name,chr(13),''),chr(10),'') as customer_name
,replace(replace(t1.source_system,chr(13),''),chr(10),'') as source_system
,replace(replace(t1.tax_item,chr(13),''),chr(10),'') as tax_item
,tax_exclu_amount
,tax_rate
,tax_amount
,tax_inclu_amount
,replace(replace(t1.accounting_subject,chr(13),''),chr(10),'') as accounting_subject

from ${iol_schema}.ibms_vtrd_set_instr_for_fdei t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_vtrd_set_instr_for_fdei.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
