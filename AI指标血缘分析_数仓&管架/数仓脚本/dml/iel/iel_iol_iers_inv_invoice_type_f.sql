: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_inv_invoice_type_f
CreateDate: 20230130
FileName:   ${iel_data_path}/iers_inv_invoice_type.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pk_inv_invoice_type,chr(13),''),chr(10),'') as pk_inv_invoice_type
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.category,chr(13),''),chr(10),'') as category
,replace(replace(t1.e_flag,chr(13),''),chr(10),'') as e_flag
,replace(replace(t1.vat_flag,chr(13),''),chr(10),'') as vat_flag
,replace(replace(t1.special_flag,chr(13),''),chr(10),'') as special_flag
,replace(replace(t1.dr,chr(13),''),chr(10),'') as dr
,replace(replace(t1.revision,chr(13),''),chr(10),'') as revision
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.last_modified_user,chr(13),''),chr(10),'') as last_modified_user
,replace(replace(t1.last_modified_time,chr(13),''),chr(10),'') as last_modified_time
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_inv_invoice_type t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_inv_invoice_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
