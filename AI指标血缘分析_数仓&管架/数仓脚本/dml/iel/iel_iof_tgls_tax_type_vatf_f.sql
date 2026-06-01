: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_tgls_tax_type_vatf_f
CreateDate: 20250210
FileName:   ${iel_data_path}/tgls_tax_type_vatf.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.stacid,chr(13),''),chr(10),'') as stacid
,replace(replace(t1.taxscd,chr(13),''),chr(10),'') as taxscd
,replace(replace(t1.deptcd,chr(13),''),chr(10),'') as deptcd
,vatxrt
,replace(replace(t1.begndt,chr(13),''),chr(10),'') as begndt
,replace(replace(t1.endddt,chr(13),''),chr(10),'') as endddt
,replace(replace(t1.smrytx,chr(13),''),chr(10),'') as smrytx
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.attribute2,chr(13),''),chr(10),'') as attribute2
,replace(replace(t1.attribute3,chr(13),''),chr(10),'') as attribute3
,replace(replace(t1.attribute4,chr(13),''),chr(10),'') as attribute4

from ${iol_schema}.tgls_tax_type_vatf t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tgls_tax_type_vatf.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
