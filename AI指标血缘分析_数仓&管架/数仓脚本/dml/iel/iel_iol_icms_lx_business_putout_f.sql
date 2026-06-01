: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_lx_business_putout_f
CreateDate: 20250804
FileName:   ${iel_data_path}/icms_lx_business_putout.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.contractserialno,chr(13),''),chr(10),'') as contractserialno
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.applyid,chr(13),''),chr(10),'') as applyid
,replace(replace(t1.partnercode,chr(13),''),chr(10),'') as partnercode
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.creditno,chr(13),''),chr(10),'') as creditno
,replace(replace(t1.ordertype,chr(13),''),chr(10),'') as ordertype
,businesssum
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,startdate
,maturity
,replace(replace(t1.fixedbillday,chr(13),''),chr(10),'') as fixedbillday
,replace(replace(t1.fixedrepayday,chr(13),''),chr(10),'') as fixedrepayday
,loanterm
,annualrate
,replace(replace(t1.loanuse,chr(13),''),chr(10),'') as loanuse
,replace(replace(t1.mobileno,chr(13),''),chr(10),'') as mobileno
,replace(replace(t1.debitaccountname,chr(13),''),chr(10),'') as debitaccountname
,replace(replace(t1.debitopenaccountbank,chr(13),''),chr(10),'') as debitopenaccountbank
,replace(replace(t1.debitaccountno,chr(13),''),chr(10),'') as debitaccountno
,replace(replace(t1.debitcnaps,chr(13),''),chr(10),'') as debitcnaps
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,replace(replace(t1.unionguaranteeflag,chr(13),''),chr(10),'') as unionguaranteeflag
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.hxfkstatus,chr(13),''),chr(10),'') as hxfkstatus
,replace(replace(t1.hxfkmessage,chr(13),''),chr(10),'') as hxfkmessage
,replace(replace(t1.hwzzstatus,chr(13),''),chr(10),'') as hwzzstatus
,replace(replace(t1.hwzzmessage,chr(13),''),chr(10),'') as hwzzmessage
,replace(replace(t1.hxczstatus,chr(13),''),chr(10),'') as hxczstatus
,replace(replace(t1.hxczmessage,chr(13),''),chr(10),'') as hxczmessage
,inputdate
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,updatedate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,paymenttime
,replace(replace(t1.capitalloanno,chr(13),''),chr(10),'') as capitalloanno
,replace(replace(t1.hxfkseqnum,chr(13),''),chr(10),'') as hxfkseqnum
,replace(replace(t1.gxzseqnum,chr(13),''),chr(10),'') as gxzseqnum
,replace(replace(t1.stzfseqnum,chr(13),''),chr(10),'') as stzfseqnum

from ${iol_schema}.icms_lx_business_putout t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_lx_business_putout.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
