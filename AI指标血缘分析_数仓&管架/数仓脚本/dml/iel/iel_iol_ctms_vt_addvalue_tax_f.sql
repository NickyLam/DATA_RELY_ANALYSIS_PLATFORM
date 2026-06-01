: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_vt_addvalue_tax_f
CreateDate: 20230901
FileName:   ${iel_data_path}/ctms_vt_addvalue_tax.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.accentry2id,chr(13),''),chr(10),'') as accentry2id
,replace(replace(t1.accountingcode,chr(13),''),chr(10),'') as accountingcode
,replace(replace(t1.accountingdesc,chr(13),''),chr(10),'') as accountingdesc
,replace(replace(t1.productcode,chr(13),''),chr(10),'') as productcode
,replace(replace(t1.business,chr(13),''),chr(10),'') as business
,replace(replace(t1.taxtype,chr(13),''),chr(10),'') as taxtype
,rate
,replace(replace(t1.taxcode,chr(13),''),chr(10),'') as taxcode
,replace(replace(t1.feecode,chr(13),''),chr(10),'') as feecode
,countnm
,replace(replace(t1.amount,chr(13),''),chr(10),'') as amount
,replace(replace(t1.fee,chr(13),''),chr(10),'') as fee
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.settledate,chr(13),''),chr(10),'') as settledate
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.source,chr(13),''),chr(10),'') as source
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.bundlecode,chr(13),''),chr(10),'') as bundlecode

from ${iol_schema}.ctms_vt_addvalue_tax t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_vt_addvalue_tax.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
