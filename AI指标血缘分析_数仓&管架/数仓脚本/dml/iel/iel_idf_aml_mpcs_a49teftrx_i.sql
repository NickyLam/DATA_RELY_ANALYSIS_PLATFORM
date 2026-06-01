: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_mpcs_a49teftrx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_mpcs_a49teftrx.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,unotnbr
,unotdate
,unottime
,hostnbr
,hostdate
,magbrn
,oprtlr
,oprbrn
,auttlr
,autbrn
,oprchl
,bthdate
,bthseq
,msgid
,origmsgid
,txntype
,trantype
,entrustdate
,vouchno
,msgno
,pkgno
,pkgdate
,moneyflag
,currencycd
,amount
,chargetype
,feeamt1
,feeamt2
,feeamt3
,bookcd
,booknbr
,sysid
,sndzone
,sendbank
,payerbank
,payeraccbank
,payeracc
,payername
,payeraddr
,rcvzone
,payeebank
,payeeaccbank
,payeeacc
,payeename
,payeeaddr
,txnid
,txndate
,txnround
,origsendbank
,origtxntype
,origentrustdt
,origvouchno
,orighostnbr
,orighostdate
,secondtrack
,thirdtrack
,pin
,entrymode
,cashflag
,privateflag
,authzcd
,outmid
,outtime
,cntrno
,linkid
,iotype
,status
,retcd
,msgtext
,remark
,rcvbrnname
,media
,payerbankname
,prtnum
,colldate
,identype
,idennbr
,isinout
,inacct
,inname
,transdt
,paymod
,calfee
,fronttrcd
,rcvbrn
,errcode
,remark2
,sendpathfilename
,eaccflg
,od_flag
,od_ovtranam
,opnwin
,nextdayflag
,autoflag
,autocount
,automsg
,bindacct
,bindacctnm
,accttype
,bindacctopnbrn
,limitorderid
,globalseqno from idl.aml_mpcs_a49teftrx where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_mpcs_a49teftrx.i.${batch_date}.dat" \
        charset=utf8
        safe=yes