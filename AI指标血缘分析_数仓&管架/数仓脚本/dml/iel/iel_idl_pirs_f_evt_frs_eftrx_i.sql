: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_f_evt_frs_eftrx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_f_evt_frs_eftrx_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select unotnbr
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
,inname from idl.pirs_f_evt_frs_eftrx where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_f_evt_frs_eftrx_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes