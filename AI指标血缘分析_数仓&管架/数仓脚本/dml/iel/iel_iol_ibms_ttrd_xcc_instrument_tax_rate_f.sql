: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_xcc_instrument_tax_rate_f
CreateDate: 20221105
FileName:   ${iel_data_path}/ibms_ttrd_xcc_instrument_tax_rate.f.${batch_date}.dat
IF_mark:    f
Logs:
   sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.rate_id as rate_id
    ,replace(replace(t.p_class,chr(13),''),chr(10),'') as p_class
    ,t.tax_calc_type as tax_calc_type
    ,t.tax_output_type as tax_output_type
    ,replace(replace(t.tax_rate_field,chr(13),''),chr(10),'') as tax_rate_field
    ,t.tax_rate as tax_rate
    ,replace(replace(t.p_type,chr(13),''),chr(10),'') as p_type
    ,replace(replace(t.tax_item,chr(13),''),chr(10),'') as tax_item
    ,t.tax_billreq as tax_billreq
    ,t.tax_methodcal as tax_methodcal
    ,replace(replace(t.updatetime,chr(13),''),chr(10),'') as updatetime
    ,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
    ,t.tax_type_rate as tax_type_rate
    ,t.status as status
    ,replace(replace(t.beg_date,chr(13),''),chr(10),'') as beg_date
    ,replace(replace(t.end_date,chr(13),''),chr(10),'') as end_date
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ibms_ttrd_xcc_instrument_tax_rate t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_xcc_instrument_tax_rate.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes