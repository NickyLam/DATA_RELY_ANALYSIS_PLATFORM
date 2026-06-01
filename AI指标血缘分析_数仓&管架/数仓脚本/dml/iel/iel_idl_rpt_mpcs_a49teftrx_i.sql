: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a49teftrx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a49teftrx.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.ETL_DT
,t1.unotnbr
,t1.unotdate
,t1.unottime
,t1.hostnbr
,t1.hostdate
,t1.magbrn
,t1.oprtlr
,t1.oprbrn
,t1.auttlr
,t1.autbrn
,t1.oprchl
,t1.bthdate
,t1.bthseq
,t1.msgid
,t1.origmsgid
,t1.txntype
,t1.trantype
,t1.entrustdate
,t1.vouchno
,t1.msgno
,t1.pkgno
,t1.pkgdate
,t1.moneyflag
,t1.currencycd
,t1.amount
,t1.chargetype
,t1.feeamt1
,t1.feeamt2
,t1.feeamt3
,t1.bookcd
,t1.booknbr
,t1.sysid
,t1.sndzone
,t1.sendbank
,t1.payerbank
,t1.payeraccbank
,t1.payeracc
,t1.payername
,t1.payeraddr
,t1.rcvzone
,t1.payeebank
,t1.payeeaccbank
,t1.payeeacc
,t1.payeename
,t1.payeeaddr
,t1.txnid
,t1.txndate
,t1.txnround
,t1.origsendbank
,t1.origtxntype
,t1.origentrustdt
,t1.origvouchno
,t1.orighostnbr
,t1.orighostdate
,t1.secondtrack
,t1.thirdtrack
,t1.pin
,t1.entrymode
,t1.cashflag
,t1.privateflag
,t1.authzcd
,t1.outmid
,t1.outtime
,t1.cntrno
,t1.linkid
,t1.iotype
,t1.status
,t1.retcd
,t1.msgtext
,t1.remark
,t1.rcvbrnname
,t1.media
,t1.payerbankname
,t1.prtnum
,t1.colldate
,t1.identype
,t1.idennbr
,t1.isinout
,t1.inacct
,t1.inname
,t1.transdt
,t1.paymod
,t1.calfee
,t1.fronttrcd
,t1.rcvbrn
,t1.errcode
,t1.remark2
,t1.sendpathfilename
,t1.eaccflg
,t1.od_flag
,t1.od_ovtranam
,t1.opnwin
,t1.nextdayflag
,t1.autoflag
,t1.autocount
,t1.automsg
,t1.bindacct
,t1.bindacctnm
,t1.accttype
,t1.bindacctopnbrn
,t1.limitorderid
,t1.globalseqno
from ${idl_schema}.rpt_mpcs_a49teftrx t1 
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a49teftrx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes