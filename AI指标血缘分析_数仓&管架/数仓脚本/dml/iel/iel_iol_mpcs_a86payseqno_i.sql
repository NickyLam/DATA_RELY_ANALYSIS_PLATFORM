: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a86payseqno_i
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a86payseqno.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t.aleseqno,chr(13),''),chr(10),'') as aleseqno
,replace(replace(t.paysys,chr(13),''),chr(10),'') as paysys
,replace(replace(t.transtype,chr(13),''),chr(10),'') as transtype
,replace(replace(t.interfaceversion,chr(13),''),chr(10),'') as interfaceversion
,replace(replace(t.transtimesource,chr(13),''),chr(10),'') as transtimesource
,replace(replace(t.transtimedestination,chr(13),''),chr(10),'') as transtimedestination
,replace(replace(t.transnosource,chr(13),''),chr(10),'') as transnosource
,replace(replace(t.transnodestination,chr(13),''),chr(10),'') as transnodestination
,replace(replace(t.source,chr(13),''),chr(10),'') as source
,replace(replace(t.destination,chr(13),''),chr(10),'') as destination
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.seid,chr(13),''),chr(10),'') as seid
,replace(replace(t.span,chr(13),''),chr(10),'') as span
,replace(replace(t.newspan,chr(13),''),chr(10),'') as newspan
,replace(replace(t.spanid,chr(13),''),chr(10),'') as spanid
,replace(replace(t.mpan,chr(13),''),chr(10),'') as mpan
,replace(replace(t.mpanid,chr(13),''),chr(10),'') as mpanid
,replace(replace(t.mstpan,chr(13),''),chr(10),'') as mstpan
,replace(replace(t.mstpanid,chr(13),''),chr(10),'') as mstpanid
,replace(replace(t.mappingstatus,chr(13),''),chr(10),'') as mappingstatus
,replace(replace(t.mpanpersoresult,chr(13),''),chr(10),'') as mpanpersoresult
,replace(replace(t.setype,chr(13),''),chr(10),'') as setype
,replace(replace(t.seissuer,chr(13),''),chr(10),'') as seissuer
,replace(replace(t.instanceaid,chr(13),''),chr(10),'') as instanceaid
,replace(replace(t.expirydate,chr(13),''),chr(10),'') as expirydate
,replace(replace(t.cvn2,chr(13),''),chr(10),'') as cvn2
,replace(replace(t.pin,chr(13),''),chr(10),'') as pin
,replace(replace(t.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t.idno,chr(13),''),chr(10),'') as idno
,replace(replace(t.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t.initquota,chr(13),''),chr(10),'') as initquota
,replace(replace(t.cardartid,chr(13),''),chr(10),'') as cardartid
,replace(replace(t.invaluedate,chr(13),''),chr(10),'') as invaluedate
,replace(replace(t.applychannel,chr(13),''),chr(10),'') as applychannel
,replace(replace(t.bankchanneldata,chr(13),''),chr(10),'') as bankchanneldata
,replace(replace(t.termandconditionid,chr(13),''),chr(10),'') as termandconditionid
,replace(replace(t.termandconditionaccepteddate,chr(13),''),chr(10),'') as termandconditionaccepteddate
,replace(replace(t.accountscore,chr(13),''),chr(10),'') as accountscore
,replace(replace(t.devicescore,chr(13),''),chr(10),'') as devicescore
,replace(replace(t.sourcelp,chr(13),''),chr(10),'') as sourcelp
,replace(replace(t.color,chr(13),''),chr(10),'') as color
,replace(replace(t.reasoncodes,chr(13),''),chr(10),'') as reasoncodes
,replace(replace(t.devicetype,chr(13),''),chr(10),'') as devicetype
,replace(replace(t.devicename,chr(13),''),chr(10),'') as devicename
,replace(replace(t.devicenumber,chr(13),''),chr(10),'') as devicenumber
,replace(replace(t.fulldevicenumber,chr(13),''),chr(10),'') as fulldevicenumber
,replace(replace(t.phonenumberscore,chr(13),''),chr(10),'') as phonenumberscore
,replace(replace(t.accountidhash,chr(13),''),chr(10),'') as accountidhash
,replace(replace(t.devicelocation,chr(13),''),chr(10),'') as devicelocation
,replace(replace(t.extensivedevicelocation,chr(13),''),chr(10),'') as extensivedevicelocation
,replace(replace(t.billingaddress,chr(13),''),chr(10),'') as billingaddress
,replace(replace(t.billingzip,chr(13),''),chr(10),'') as billingzip
,replace(replace(t.colorstandardsversion,chr(13),''),chr(10),'') as colorstandardsversion
,replace(replace(t.cardholdername,chr(13),''),chr(10),'') as cardholdername
,replace(replace(t.itunesemaillife,chr(13),''),chr(10),'') as itunesemaillife
,replace(replace(t.capturemethod,chr(13),''),chr(10),'') as capturemethod
,replace(replace(t.casdcertinfo,chr(13),''),chr(10),'') as casdcertinfo
,replace(replace(t.statuscode,chr(13),''),chr(10),'') as statuscode
,replace(replace(t.statusdescription,chr(13),''),chr(10),'') as statusdescription
,replace(replace(t.storeidentifier,chr(13),''),chr(10),'') as storeidentifier
,replace(replace(t.applicationid,chr(13),''),chr(10),'') as applicationid
,replace(replace(t.otptype,chr(13),''),chr(10),'') as otptype
,replace(replace(t.otpresolutionvalue,chr(13),''),chr(10),'') as otpresolutionvalue
,replace(replace(t.otpresolutionid,chr(13),''),chr(10),'') as otpresolutionid
,replace(replace(t.otpsourceaddress,chr(13),''),chr(10),'') as otpsourceaddress
,replace(replace(t.otp,chr(13),''),chr(10),'') as otp
,replace(replace(t.operationchannelid,chr(13),''),chr(10),'') as operationchannelid
,replace(replace(t.operationreason,chr(13),''),chr(10),'') as operationreason
,replace(replace(t.applyexceptionresult,chr(13),''),chr(10),'') as applyexceptionresult
,replace(replace(t.exceptionresultreason,chr(13),''),chr(10),'') as exceptionresultreason
,replace(replace(t.taskid,chr(13),''),chr(10),'') as taskid
,replace(replace(t.ecashbalance,chr(13),''),chr(10),'') as ecashbalance
,replace(replace(t.blacklistcategory,chr(13),''),chr(10),'') as blacklistcategory
,replace(replace(t.blackinvalidtime,chr(13),''),chr(10),'') as blackinvalidtime
,replace(replace(t.blackoperationtype,chr(13),''),chr(10),'') as blackoperationtype
,replace(replace(t.transactionid,chr(13),''),chr(10),'') as transactionid
,replace(replace(t.transactiontype,chr(13),''),chr(10),'') as transactiontype
,replace(replace(t.transactiondate,chr(13),''),chr(10),'') as transactiondate
,replace(replace(t.currencycode,chr(13),''),chr(10),'') as currencycode
,replace(replace(t.transactionamount,chr(13),''),chr(10),'') as transactionamount
,replace(replace(t.transactionstatus,chr(13),''),chr(10),'') as transactionstatus
,replace(replace(t.merchantname,chr(13),''),chr(10),'') as merchantname
,replace(replace(t.rawmerchantname,chr(13),''),chr(10),'') as rawmerchantname
,replace(replace(t.industrycategory,chr(13),''),chr(10),'') as industrycategory
,replace(replace(t.industrycode,chr(13),''),chr(10),'') as industrycode
,replace(replace(t.geolocation,chr(13),''),chr(10),'') as geolocation
,replace(replace(t.paninputmode,chr(13),''),chr(10),'') as paninputmode
,replace(replace(t.mac,chr(13),''),chr(10),'') as mac
,replace(replace(t.notflag,chr(13),''),chr(10),'') as notflag
,replace(replace(t.notnum,chr(13),''),chr(10),'') as notnum
,replace(replace(t.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t.idecheck,chr(13),''),chr(10),'') as idecheck
,replace(replace(t.srcseqno,chr(13),''),chr(10),'') as srcseqno
,replace(replace(t.operationresult,chr(13),''),chr(10),'') as operationresult
,replace(replace(t.blackpan,chr(13),''),chr(10),'') as blackpan
from ${iol_schema}.MPCS_A86PAYSEQNO t 
where SUBSTR(TRANSTIME,1,8)='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a86payseqno.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes