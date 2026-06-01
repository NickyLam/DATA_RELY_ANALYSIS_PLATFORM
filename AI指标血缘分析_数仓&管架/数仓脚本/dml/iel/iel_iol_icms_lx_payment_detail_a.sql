: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_lx_payment_detail_a
CreateDate: 20250804
FileName:   ${iel_data_path}/icms_lx_payment_detail.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.assetid,chr(13),''),chr(10),'') as assetid
,replace(replace(t1.capitalloanno,chr(13),''),chr(10),'') as capitalloanno
,replace(replace(t1.paydate,chr(13),''),chr(10),'') as paydate
,replace(replace(t1.paymentamount,chr(13),''),chr(10),'') as paymentamount
,replace(replace(t1.paymentterms,chr(13),''),chr(10),'') as paymentterms
,replace(replace(t1.paymentstatus,chr(13),''),chr(10),'') as paymentstatus
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate

from ${iol_schema}.icms_lx_payment_detail t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_lx_payment_detail.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
