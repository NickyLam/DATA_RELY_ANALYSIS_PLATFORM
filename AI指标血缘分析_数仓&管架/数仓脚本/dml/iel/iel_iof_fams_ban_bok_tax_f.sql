: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_fams_ban_bok_tax_f
CreateDate: 20231102
FileName:   ${iel_data_path}/fams_ban_bok_tax.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,cdate
,replace(replace(t1.org_no,chr(13),''),chr(10),'') as org_no
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.subject_no,chr(13),''),chr(10),'') as subject_no
,replace(replace(t1.subject_name,chr(13),''),chr(10),'') as subject_name
,replace(replace(t1.prod_code,chr(13),''),chr(10),'') as prod_code
,replace(replace(t1.business,chr(13),''),chr(10),'') as business
,replace(replace(t1.tax_type,chr(13),''),chr(10),'') as tax_type
,replace(replace(t1.tax_rate,chr(13),''),chr(10),'') as tax_rate
,replace(replace(t1.tax_nature,chr(13),''),chr(10),'') as tax_nature
,replace(replace(t1.tax_code,chr(13),''),chr(10),'') as tax_code
,amount
,amt
,replace(replace(t1.bill_no,chr(13),''),chr(10),'') as bill_no
,replace(replace(t1.busi_id,chr(13),''),chr(10),'') as busi_id
,replace(replace(t1.source,chr(13),''),chr(10),'') as source
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time

from ${iol_schema}.fams_ban_bok_tax t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_ban_bok_tax.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
