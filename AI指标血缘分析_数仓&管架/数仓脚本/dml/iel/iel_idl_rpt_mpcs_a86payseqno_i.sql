: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a86payseqno_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a86payseqno.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.aleseqno,chr(13),''),chr(10),'') as aleseqno
,replace(replace(t1.paysys,chr(13),''),chr(10),'') as paysys
,replace(replace(t1.transtype,chr(13),''),chr(10),'') as transtype
,replace(replace(t1.interfaceversion,chr(13),''),chr(10),'') as interfaceversion
,replace(replace(t1.transtimesource,chr(13),''),chr(10),'') as transtimesource
,replace(replace(t1.transtimedestination,chr(13),''),chr(10),'') as transtimedestination
,replace(replace(t1.transnosource,chr(13),''),chr(10),'') as transnosource
,replace(replace(t1.transnodestination,chr(13),''),chr(10),'') as transnodestination
,replace(replace(t1.source,chr(13),''),chr(10),'') as source
,replace(replace(t1.destination,chr(13),''),chr(10),'') as destination
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.seid,chr(13),''),chr(10),'') as seid
,replace(replace(t1.span,chr(13),''),chr(10),'') as span
,replace(replace(t1.newspan,chr(13),''),chr(10),'') as newspan
,replace(replace(t1.spanid,chr(13),''),chr(10),'') as spanid
,replace(replace(t1.mpan,chr(13),''),chr(10),'') as mpan
,replace(replace(t1.mpanid,chr(13),''),chr(10),'') as mpanid
,replace(replace(t1.mstpan,chr(13),''),chr(10),'') as mstpan
,replace(replace(t1.mstpanid,chr(13),''),chr(10),'') as mstpanid
,replace(replace(t1.mappingstatus,chr(13),''),chr(10),'') as mappingstatus
,replace(replace(t1.mpanpersoresult,chr(13),''),chr(10),'') as mpanpersoresult
,replace(replace(t1.setype,chr(13),''),chr(10),'') as setype
,replace(replace(t1.seissuer,chr(13),''),chr(10),'') as seissuer
,replace(replace(t1.instanceaid,chr(13),''),chr(10),'') as instanceaid
,replace(replace(t1.expirydate,chr(13),''),chr(10),'') as expirydate
,replace(replace(t1.cvn2,chr(13),''),chr(10),'') as cvn2
,replace(replace(t1.pin,chr(13),''),chr(10),'') as pin
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idno,chr(13),''),chr(10),'') as idno
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.initquota,chr(13),''),chr(10),'') as initquota
,replace(replace(t1.cardartid,chr(13),''),chr(10),'') as cardartid
,replace(replace(t1.invaluedate,chr(13),''),chr(10),'') as invaluedate
,replace(replace(t1.applychannel,chr(13),''),chr(10),'') as applychannel
,replace(replace(t1.bankchanneldata,chr(13),''),chr(10),'') as bankchanneldata
,replace(replace(t1.termandconditionid,chr(13),''),chr(10),'') as termandconditionid
,replace(replace(t1.termandconditionaccepteddate,chr(13),''),chr(10),'') as termandconditionaccepteddate
,replace(replace(t1.accountscore,chr(13),''),chr(10),'') as accountscore
,replace(replace(t1.devicescore,chr(13),''),chr(10),'') as devicescore
,replace(replace(t1.sourcelp,chr(13),''),chr(10),'') as sourcelp
,replace(replace(t1.color,chr(13),''),chr(10),'') as color
,replace(replace(t1.reasoncodes,chr(13),''),chr(10),'') as reasoncodes
,replace(replace(t1.devicetype,chr(13),''),chr(10),'') as devicetype
,replace(replace(t1.devicename,chr(13),''),chr(10),'') as devicename
,replace(replace(t1.devicenumber,chr(13),''),chr(10),'') as devicenumber
,replace(replace(t1.fulldevicenumber,chr(13),''),chr(10),'') as fulldevicenumber
,replace(replace(t1.phonenumberscore,chr(13),''),chr(10),'') as phonenumberscore
,replace(replace(t1.accountidhash,chr(13),''),chr(10),'') as accountidhash
,replace(replace(t1.devicelocation,chr(13),''),chr(10),'') as devicelocation
,replace(replace(t1.extensivedevicelocation,chr(13),''),chr(10),'') as extensivedevicelocation
,replace(replace(t1.billingaddress,chr(13),''),chr(10),'') as billingaddress
,replace(replace(t1.billingzip,chr(13),''),chr(10),'') as billingzip
,replace(replace(t1.colorstandardsversion,chr(13),''),chr(10),'') as colorstandardsversion
,replace(replace(t1.cardholdername,chr(13),''),chr(10),'') as cardholdername
,replace(replace(t1.itunesemaillife,chr(13),''),chr(10),'') as itunesemaillife
,replace(replace(t1.capturemethod,chr(13),''),chr(10),'') as capturemethod
,replace(replace(t1.casdcertinfo,chr(13),''),chr(10),'') as casdcertinfo
,replace(replace(t1.statuscode,chr(13),''),chr(10),'') as statuscode
,replace(replace(t1.statusdescription,chr(13),''),chr(10),'') as statusdescription
,replace(replace(t1.storeidentifier,chr(13),''),chr(10),'') as storeidentifier
,replace(replace(t1.applicationid,chr(13),''),chr(10),'') as applicationid
,replace(replace(t1.otptype,chr(13),''),chr(10),'') as otptype
,replace(replace(t1.otpresolutionvalue,chr(13),''),chr(10),'') as otpresolutionvalue
,replace(replace(t1.otpresolutionid,chr(13),''),chr(10),'') as otpresolutionid
,replace(replace(t1.otpsourceaddress,chr(13),''),chr(10),'') as otpsourceaddress
,replace(replace(t1.otp,chr(13),''),chr(10),'') as otp
,replace(replace(t1.operationchannelid,chr(13),''),chr(10),'') as operationchannelid
,replace(replace(t1.operationreason,chr(13),''),chr(10),'') as operationreason
,replace(replace(t1.applyexceptionresult,chr(13),''),chr(10),'') as applyexceptionresult
,replace(replace(t1.exceptionresultreason,chr(13),''),chr(10),'') as exceptionresultreason
,replace(replace(t1.taskid,chr(13),''),chr(10),'') as taskid
,replace(replace(t1.ecashbalance,chr(13),''),chr(10),'') as ecashbalance
,replace(replace(t1.blacklistcategory,chr(13),''),chr(10),'') as blacklistcategory
,replace(replace(t1.blackinvalidtime,chr(13),''),chr(10),'') as blackinvalidtime
,replace(replace(t1.blackoperationtype,chr(13),''),chr(10),'') as blackoperationtype
,replace(replace(t1.transactionid,chr(13),''),chr(10),'') as transactionid
,replace(replace(t1.transactiontype,chr(13),''),chr(10),'') as transactiontype
,replace(replace(t1.transactiondate,chr(13),''),chr(10),'') as transactiondate
,replace(replace(t1.currencycode,chr(13),''),chr(10),'') as currencycode
,replace(replace(t1.transactionamount,chr(13),''),chr(10),'') as transactionamount
,replace(replace(t1.transactionstatus,chr(13),''),chr(10),'') as transactionstatus
,replace(replace(t1.merchantname,chr(13),''),chr(10),'') as merchantname
,replace(replace(t1.rawmerchantname,chr(13),''),chr(10),'') as rawmerchantname
,replace(replace(t1.industrycategory,chr(13),''),chr(10),'') as industrycategory
,replace(replace(t1.industrycode,chr(13),''),chr(10),'') as industrycode
,replace(replace(t1.geolocation,chr(13),''),chr(10),'') as geolocation
,replace(replace(t1.paninputmode,chr(13),''),chr(10),'') as paninputmode
,replace(replace(t1.mac,chr(13),''),chr(10),'') as mac
,replace(replace(t1.notflag,chr(13),''),chr(10),'') as notflag
,replace(replace(t1.notnum,chr(13),''),chr(10),'') as notnum
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.idecheck,chr(13),''),chr(10),'') as idecheck
,replace(replace(t1.srcseqno,chr(13),''),chr(10),'') as srcseqno
,replace(replace(t1.operationresult,chr(13),''),chr(10),'') as operationresult
,replace(replace(t1.blackpan,chr(13),''),chr(10),'') as blackpan
 from iol.mpcs_a86payseqno T1
where substr(transtime,1,8)= '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a86payseqno.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes