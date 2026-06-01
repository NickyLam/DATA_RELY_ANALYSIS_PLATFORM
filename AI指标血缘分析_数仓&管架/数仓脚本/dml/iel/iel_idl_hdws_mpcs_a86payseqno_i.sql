: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a86payseqno_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a86payseqno.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.transtime
,t1.aleseqno
,t1.paysys
,t1.transtype
,t1.interfaceversion
,t1.transtimesource
,t1.transtimedestination
,t1.transnosource
,t1.transnodestination
,t1.source
,t1.destination
,t1.custno
,t1.seid
,t1.span
,t1.newspan
,t1.spanid
,t1.mpan
,t1.mpanid
,t1.mstpan
,t1.mstpanid
,t1.mappingstatus
,t1.mpanpersoresult
,t1.setype
,t1.seissuer
,t1.instanceaid
,t1.expirydate
,t1.cvn2
,t1.pin
,t1.custname
,t1.idtype
,t1.idno
,t1.phone
,t1.initquota
,t1.cardartid
,t1.invaluedate
,t1.applychannel
,t1.bankchanneldata
,t1.termandconditionid
,t1.termandconditionaccepteddate
,t1.accountscore
,t1.devicescore
,t1.sourcelp
,t1.color
,t1.reasoncodes
,t1.devicetype
,t1.devicename
,t1.devicenumber
,t1.fulldevicenumber
,t1.phonenumberscore
,t1.accountidhash
,t1.devicelocation
,t1.extensivedevicelocation
,t1.billingaddress
,t1.billingzip
,t1.colorstandardsversion
,t1.cardholdername
,t1.itunesemaillife
,t1.capturemethod
,t1.casdcertinfo
,t1.statuscode
,t1.statusdescription
,t1.storeidentifier
,t1.applicationid
,t1.otptype
,t1.otpresolutionvalue
,t1.otpresolutionid
,t1.otpsourceaddress
,t1.otp
,t1.operationchannelid
,t1.operationreason
,t1.applyexceptionresult
,t1.exceptionresultreason
,t1.taskid
,t1.ecashbalance
,t1.blacklistcategory
,t1.blackinvalidtime
,t1.blackoperationtype
,t1.transactionid
,t1.transactiontype
,t1.transactiondate
,t1.currencycode
,t1.transactionamount
,t1.transactionstatus
,t1.merchantname
,t1.rawmerchantname
,t1.industrycategory
,t1.industrycode
,t1.geolocation
,t1.paninputmode
,t1.mac
,t1.notflag
,t1.notnum
,t1.remark1
,t1.remark2
,t1.remark3
,t1.remark4
,t1.idecheck
,t1.srcseqno
,t1.operationresult
,t1.blackpan
from ${idl_schema}.hdws_mpcs_a86payseqno t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a86payseqno.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes