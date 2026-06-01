: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_lx_repayment_plan_f
CreateDate: 20250804
FileName:   ${iel_data_path}/icms_lx_repayment_plan.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.assetid,chr(13),''),chr(10),'') as assetid
,replace(replace(t1.capitalloanno,chr(13),''),chr(10),'') as capitalloanno
,replace(replace(t1.paydate,chr(13),''),chr(10),'') as paydate
,replace(replace(t1.payableday,chr(13),''),chr(10),'') as payableday
,replace(replace(t1.curstageno,chr(13),''),chr(10),'') as curstageno
,replace(replace(t1.repaypriamt,chr(13),''),chr(10),'') as repaypriamt
,replace(replace(t1.payint,chr(13),''),chr(10),'') as payint
,replace(replace(t1.guarantyfee,chr(13),''),chr(10),'') as guarantyfee
,replace(replace(t1.simulationfee,chr(13),''),chr(10),'') as simulationfee
,replace(replace(t1.creditassessfee,chr(13),''),chr(10),'') as creditassessfee
,replace(replace(t1.interest,chr(13),''),chr(10),'') as interest
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.lxbusinesssum,chr(13),''),chr(10),'') as lxbusinesssum
,replace(replace(t1.lxintamt,chr(13),''),chr(10),'') as lxintamt
,replace(replace(t1.realamounttotal,chr(13),''),chr(10),'') as realamounttotal
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.prinbal,chr(13),''),chr(10),'') as prinbal
,replace(replace(t1.intbal,chr(13),''),chr(10),'') as intbal
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.cleardate,chr(13),''),chr(10),'') as cleardate
,replace(replace(t1.loanterm,chr(13),''),chr(10),'') as loanterm
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.intedate,chr(13),''),chr(10),'') as intedate
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.periodpaydate,chr(13),''),chr(10),'') as periodpaydate

from ${iol_schema}.icms_lx_repayment_plan t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_lx_repayment_plan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
