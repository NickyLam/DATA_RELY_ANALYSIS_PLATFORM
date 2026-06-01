: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_upl_account_apply_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_upl_account_apply_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(serialno,chr(10),''),chr(13),'') as serialno
,replace(replace(duebillno,chr(10),''),chr(13),'') as duebillno
,replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(customerid,chr(10),''),chr(13),'') as customerid
,replace(replace(customername,chr(10),''),chr(13),'') as customername
,replace(replace(accounttype,chr(10),''),chr(13),'') as accounttype
,replace(replace(businesscurrency,chr(10),''),chr(13),'') as businesscurrency
,replace(replace(businesssum,chr(10),''),chr(13),'') as businesssum
,replace(replace(balance,chr(10),''),chr(13),'') as balance
,replace(replace(applyexpain,chr(10),''),chr(13),'') as applyexpain
,replace(replace(inputuserid,chr(10),''),chr(13),'') as inputuserid
,replace(replace(inputorgid,chr(10),''),chr(13),'') as inputorgid
,replace(replace(inputdate,chr(10),''),chr(13),'') as inputdate
,replace(replace(flag,chr(10),''),chr(13),'') as flag
,replace(replace(meliquidatedsum,chr(10),''),chr(13),'') as meliquidatedsum
,replace(replace(corp_acct_no,chr(10),''),chr(13),'') as corp_acct_no
,replace(replace(togliquidatedsum,chr(10),''),chr(13),'') as togliquidatedsum
,replace(replace(backaccountno,chr(10),''),chr(13),'') as backaccountno
,replace(replace(newdate,chr(10),''),chr(13),'') as newdate
,replace(replace(putoutno,chr(10),''),chr(13),'') as putoutno
,replace(replace(corpcompanyid,chr(10),''),chr(13),'') as corpcompanyid
,replace(replace(corpcompanyname,chr(10),''),chr(13),'') as corpcompanyname
,replace(replace(businessno,chr(10),''),chr(13),'') as businessno
,replace(replace(businesstype,chr(10),''),chr(13),'') as businesstype
,replace(replace(boughtdealsum,chr(10),''),chr(13),'') as boughtdealsum
,replace(replace(account,chr(10),''),chr(13),'') as account
,replace(replace(applyway,chr(10),''),chr(13),'') as applyway
,replace(replace(repayprincipal,chr(10),''),chr(13),'') as repayprincipal
,replace(replace(repayinterest,chr(10),''),chr(13),'') as repayinterest
,replace(replace(repaydate,chr(10),''),chr(13),'') as repaydate
,replace(replace(interestsum,chr(10),''),chr(13),'') as interestsum
,replace(replace(poundagesum,chr(10),''),chr(13),'') as poundagesum
,replace(replace(boughtoutsum,chr(10),''),chr(13),'') as boughtoutsum
,replace(replace(boughtoutpoundagesum,chr(10),''),chr(13),'') as boughtoutpoundagesum
,replace(replace(returnsum,chr(10),''),chr(13),'') as returnsum
,replace(replace(accountname,chr(10),''),chr(13),'') as accountname
,replace(replace(oserialno,chr(10),''),chr(13),'') as oserialno
,replace(replace(hzserialno,chr(10),''),chr(13),'') as hzserialno
,replace(replace(accounttp,chr(10),''),chr(13),'') as accounttp
,replace(replace(isearlyrepayment,chr(10),''),chr(13),'') as isearlyrepayment
,replace(replace(repaymentname,chr(10),''),chr(13),'') as repaymentname
,replace(replace(repaymentbanknum,chr(10),''),chr(13),'') as repaymentbanknum
,replace(replace(repaymentsequence,chr(10),''),chr(13),'') as repaymentsequence
,replace(replace(transactiontype,chr(10),''),chr(13),'') as transactiontype
,replace(replace(advancereturnsum,chr(10),''),chr(13),'') as advancereturnsum
,replace(replace(replayobjecttype,chr(10),''),chr(13),'') as replayobjecttype
,replace(replace(paidcp,chr(10),''),chr(13),'') as paidcp
,replace(replace(paidin,chr(10),''),chr(13),'') as paidin
,replace(replace(paidci,chr(10),''),chr(13),'') as paidci
,replace(replace(totlpy,chr(10),''),chr(13),'') as totlpy
,replace(replace(acrvin,chr(10),''),chr(13),'') as acrvin
,replace(replace(acrvci,chr(10),''),chr(13),'') as acrvci
,replace(replace(tolnpy,chr(10),''),chr(13),'') as tolnpy
,replace(replace(otsdcp,chr(10),''),chr(13),'') as otsdcp
,replace(replace(otsdin,chr(10),''),chr(13),'') as otsdin
,replace(replace(otsdci,chr(10),''),chr(13),'') as otsdci
,replace(replace(tolots,chr(10),''),chr(13),'') as tolots
,replace(replace(totlam,chr(10),''),chr(13),'') as totlam
,replace(replace(ipcode,chr(10),''),chr(13),'') as ipcode
,replace(replace(hdintg,chr(10),''),chr(13),'') as hdintg
,replace(replace(reinst,chr(10),''),chr(13),'') as reinst
,replace(replace(qianbe,chr(10),''),chr(13),'') as qianbe
,replace(replace(nomlbe,chr(10),''),chr(13),'') as nomlbe
,replace(replace(advancereturnsum1,chr(10),''),chr(13),'') as advancereturnsum1
,replace(replace(trandt,chr(10),''),chr(13),'') as trandt
,replace(replace(lncfst,chr(10),''),chr(13),'') as lncfst
,replace(replace(oldretnfs,chr(10),''),chr(13),'') as oldretnfs
,replace(replace(returntype,chr(10),''),chr(13),'') as returntype
,replace(replace(newretnfs,chr(10),''),chr(13),'') as newretnfs
,replace(replace(oldpaycyc,chr(10),''),chr(13),'') as oldpaycyc
,replace(replace(mserialno,chr(10),''),chr(13),'') as mserialno
,replace(replace(adjustsumrate,chr(10),''),chr(13),'') as adjustsumrate
,replace(replace(adjustsum,chr(10),''),chr(13),'') as adjustsum
,replace(replace(sumrate,chr(10),''),chr(13),'') as sumrate
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_upl_account_apply 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_upl_account_apply_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes