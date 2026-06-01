: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a10tibpsdetaillog_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a10tibpsdetaillog.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.function
,t1.function1
,t1.function2
,t1.businesstrace
,t1.businessno
,t1.hostretcode
,t1.processcode
,t1.rscode
,t1.functype
,t1.businesskind
,t1.businesstype
,t1.batch
,t1.amount
,t1.kind
,t1.settlestat
,t1.trace
,t1.hosttrace
,t1.ticket
,t1.node
,t1.operater
,t1.governor1
,t1.governor2
,t1.terminal
,t1.printstat
,t1.printstat1
,t1.printtime
,t1.subj
,t1.vouchkind
,t1.vouch
,t1.billrecdate
,t1.date0
,t1.date1
,t1.date2
,t1.dealdate
,t1.trantime
,t1.sendtime
,t1.level0
,t1.flag1
,t1.flag2
,t1.flag3
,t1.flag4
,t1.acceptbank
,t1.acceptbankname
,t1.acceptacct
,t1.acceptname
,t1.acceptaccttype
,t1.sendbank
,t1.sendbankname
,t1.sendacct
,t1.sendname
,t1.sendaccttype
,t1.msgoutbank
,t1.msginbank
,t1.status
,t1.counter
,t1.fill
,t1.rejectbank
,t1.outsdficode
,t1.insdficode
,t1.sendopenbank
,t1.acceptopenbank
,t1.sendcitycode
,t1.acceptcitycode
,t1.chargefee
,t1.postfee
,t1.thirdchargefee
,t1.settleamount
,t1.endtoendid
,t1.authtype
,t1.authinfo
,t1.authid
,t1.merchantcode
,t1.merchantname
,t1.onlinetrantrace
,t1.onlinetrantime
,t1.onlinetrandesc
,t1.opennode
,t1.chmoment
,t1.coldate
,t1.url
,t1.dealcolflag
,t1.dataid
,t1.eaccflg
,t1.transno
,t1.nextdayflag
,t1.bingflag
,t1.bingacct
,t1.bingacctnm
,t1.bingacctopeninst
,t1.accttype
,t1.opertype
,t1.backflag
,t1.orgnlmsgid
,t1.orgnlmmbid
,t1.abscde
,t1.tacctp
,t1.handleflag
,t1.custno
,t1.otpseqno
,t1.mobile
,t1.sendidcode
,t1.traceseqno
,t1.limitorderid
,t1.isbindcard
,t1.globalseqno
,t1.returncode
,t1.returnmsg
,t1.transseqno
,t1.finaccountid
,t1.memocntt
,t1.backacctdt
,t1.backacctseq
from ${idl_schema}.hdws_mpcs_a10tibpsdetaillog t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a10tibpsdetaillog.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes