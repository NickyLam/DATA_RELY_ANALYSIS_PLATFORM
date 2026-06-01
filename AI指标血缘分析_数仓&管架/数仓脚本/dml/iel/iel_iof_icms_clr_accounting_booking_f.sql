: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_clr_accounting_booking_f
CreateDate: 20251107
FileName:   ${iel_data_path}/icms_clr_accounting_booking.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.clientno,chr(13),''),chr(10),'') as clientno
,replace(replace(t1.clrid,chr(13),''),chr(10),'') as clrid
,replace(replace(t1.registertype,chr(13),''),chr(10),'') as registertype
,replace(replace(t1.collattype,chr(13),''),chr(10),'') as collattype
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,collatamount
,replace(replace(t1.paymentdirection,chr(13),''),chr(10),'') as paymentdirection
,replace(replace(t1.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.prodtype,chr(13),''),chr(10),'') as prodtype
,replace(replace(t1.globalno,chr(13),''),chr(10),'') as globalno
,replace(replace(t1.transeqno,chr(13),''),chr(10),'') as transeqno
,replace(replace(t1.trandate,chr(13),''),chr(10),'') as trandate
,replace(replace(t1.trantimestamp,chr(13),''),chr(10),'') as trantimestamp
,replace(replace(t1.transtatus,chr(13),''),chr(10),'') as transtatus
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iol_schema}.icms_clr_accounting_booking t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_clr_accounting_booking.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
