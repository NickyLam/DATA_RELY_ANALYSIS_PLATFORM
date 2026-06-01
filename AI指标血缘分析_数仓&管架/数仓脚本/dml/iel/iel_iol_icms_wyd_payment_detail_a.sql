: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_payment_detail_a
CreateDate: 20250305
FileName:   ${iel_data_path}/icms_wyd_payment_detail.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.operorg,chr(13),''),chr(10),'') as operorg
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.lendingref,chr(13),''),chr(10),'') as lendingref
,replace(replace(t1.refno,chr(13),''),chr(10),'') as refno
,ppay
,ipay
,pppay
,feerepay
,replace(replace(t1.type,chr(13),''),chr(10),'') as type
,replace(replace(t1.insurancepaymentflag,chr(13),''),chr(10),'') as insurancepaymentflag
,replace(replace(t1.insurancepaymentdate,chr(13),''),chr(10),'') as insurancepaymentdate
,replace(replace(t1.transdate,chr(13),''),chr(10),'') as transdate
,fundprincipal
,fundinterest
,fundpenalty
,fundfee
,billprincipal
,billinterest
,billpenalty
,billfee
,ipaybn
,fpaybn
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult

from ${iol_schema}.icms_wyd_payment_detail t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_payment_detail.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
