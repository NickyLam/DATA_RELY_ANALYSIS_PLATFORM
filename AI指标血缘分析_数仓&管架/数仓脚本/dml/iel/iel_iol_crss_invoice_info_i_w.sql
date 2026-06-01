: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_invoice_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_invoice_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(invoiceno,chr(10),''),chr(13),'') as invoiceno
,replace(replace(invoicecurrency,chr(10),''),chr(13),'') as invoicecurrency
,replace(replace(invoicesum,chr(10),''),chr(13),'') as invoicesum
,replace(replace(purchaserid,chr(10),''),chr(13),'') as purchaserid
,replace(replace(purchasername,chr(10),''),chr(13),'') as purchasername
,replace(replace(bargainorid,chr(10),''),chr(13),'') as bargainorid
,replace(replace(bargainorname,chr(10),''),chr(13),'') as bargainorname
,replace(replace(makeoutdate,chr(10),''),chr(13),'') as makeoutdate
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(updatedate,chr(10),''),chr(13),'') as updatedate
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(tradetype,chr(10),''),chr(13),'') as tradetype
,replace(replace(tradeproduct,chr(10),''),chr(13),'') as tradeproduct
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_invoice_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_invoice_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes