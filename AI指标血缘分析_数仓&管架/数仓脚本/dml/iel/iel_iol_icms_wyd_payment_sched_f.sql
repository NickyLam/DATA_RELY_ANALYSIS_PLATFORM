: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_payment_sched_f
CreateDate: 20250224
FileName:   ${iel_data_path}/icms_wyd_payment_sched.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.lendingref,chr(13),''),chr(10),'') as lendingref
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.pmaturitydate,chr(13),''),chr(10),'') as pmaturitydate
,prepay
,prepayact
,replace(replace(t1.imaturitydate,chr(13),''),chr(10),'') as imaturitydate
,irepay
,irepayact
,poverdueamt
,remainingmaturitym
,remainingmaturityd
,remainingmaturitymi
,remainingmaturitydi
,replace(replace(t1.scheduleaction,chr(13),''),chr(10),'') as scheduleaction
,replace(replace(t1.insurancepaymentflag,chr(13),''),chr(10),'') as insurancepaymentflag
,replace(replace(t1.insurancepaymentdate,chr(13),''),chr(10),'') as insurancepaymentdate
,replace(replace(t1.intedate,chr(13),''),chr(10),'') as intedate
,prepayadv
,delayinterest
,payinterestamt
,payprincipalpenaltyamt
,payinterestpenaltyamt
,actualpayinterestamt
,actualpayprincipalpenaltyamt
,actualpayinterestpenaltyamt
,replace(replace(t1.pstatus,chr(13),''),chr(10),'') as pstatus
,replace(replace(t1.dstatus,chr(13),''),chr(10),'') as dstatus
,replace(replace(t1.finishdate,chr(13),''),chr(10),'') as finishdate
,waiveprincipalamt
,waiveinterestamt
,waivepenaltyamt
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult
,replace(replace(t1.prinovddate,chr(13),''),chr(10),'') as prinovddate
,replace(replace(t1.intovddate,chr(13),''),chr(10),'') as intovddate
,replace(replace(t1.capitaloverdays,chr(13),''),chr(10),'') as capitaloverdays
,replace(replace(t1.intovddays,chr(13),''),chr(10),'') as intovddays
,replace(replace(t1.dateofvalue,chr(13),''),chr(10),'') as dateofvalue

from ${iol_schema}.icms_wyd_payment_sched t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_payment_sched.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
