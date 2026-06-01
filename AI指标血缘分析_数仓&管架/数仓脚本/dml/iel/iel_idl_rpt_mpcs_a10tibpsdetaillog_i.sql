: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a10tibpsdetaillog_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a10tibpsdetaillog.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.function,chr(13),''),chr(10),'') as function
,replace(replace(t1.function1,chr(13),''),chr(10),'') as function1
,replace(replace(t1.function2,chr(13),''),chr(10),'') as function2
,replace(replace(t1.businesstrace,chr(13),''),chr(10),'') as businesstrace
,replace(replace(t1.businessno,chr(13),''),chr(10),'') as businessno
,replace(replace(t1.hostretcode,chr(13),''),chr(10),'') as hostretcode
,replace(replace(t1.processcode,chr(13),''),chr(10),'') as processcode
,replace(replace(t1.rscode,chr(13),''),chr(10),'') as rscode
,replace(replace(t1.functype,chr(13),''),chr(10),'') as functype
,replace(replace(t1.businesskind,chr(13),''),chr(10),'') as businesskind
,replace(replace(t1.businesstype,chr(13),''),chr(10),'') as businesstype
,replace(replace(t1.batch,chr(13),''),chr(10),'') as batch
,replace(replace(t1.amount,chr(13),''),chr(10),'') as amount
,replace(replace(t1.kind,chr(13),''),chr(10),'') as kind
,replace(replace(t1.settlestat,chr(13),''),chr(10),'') as settlestat
,replace(replace(t1.trace,chr(13),''),chr(10),'') as trace
,replace(replace(t1.hosttrace,chr(13),''),chr(10),'') as hosttrace
,replace(replace(t1.ticket,chr(13),''),chr(10),'') as ticket
,replace(replace(t1.node,chr(13),''),chr(10),'') as node
,replace(replace(t1.operater,chr(13),''),chr(10),'') as operater
,replace(replace(t1.governor1,chr(13),''),chr(10),'') as governor1
,replace(replace(t1.governor2,chr(13),''),chr(10),'') as governor2
,replace(replace(t1.terminal,chr(13),''),chr(10),'') as terminal
,replace(replace(t1.printstat,chr(13),''),chr(10),'') as printstat
,replace(replace(t1.printstat1,chr(13),''),chr(10),'') as printstat1
,replace(replace(t1.printtime,chr(13),''),chr(10),'') as printtime
,replace(replace(t1.subj,chr(13),''),chr(10),'') as subj
,replace(replace(t1.vouchkind,chr(13),''),chr(10),'') as vouchkind
,replace(replace(t1.vouch,chr(13),''),chr(10),'') as vouch
,replace(replace(t1.billrecdate,chr(13),''),chr(10),'') as billrecdate
,replace(replace(t1.date0,chr(13),''),chr(10),'') as date0
,replace(replace(t1.date1,chr(13),''),chr(10),'') as date1
,replace(replace(t1.date2,chr(13),''),chr(10),'') as date2
,replace(replace(t1.dealdate,chr(13),''),chr(10),'') as dealdate
,replace(replace(t1.trantime,chr(13),''),chr(10),'') as trantime
,replace(replace(t1.sendtime,chr(13),''),chr(10),'') as sendtime
,replace(replace(t1.level0,chr(13),''),chr(10),'') as level0
,replace(replace(t1.flag1,chr(13),''),chr(10),'') as flag1
,replace(replace(t1.flag2,chr(13),''),chr(10),'') as flag2
,replace(replace(t1.flag3,chr(13),''),chr(10),'') as flag3
,replace(replace(t1.flag4,chr(13),''),chr(10),'') as flag4
,replace(replace(t1.acceptbank,chr(13),''),chr(10),'') as acceptbank
,replace(replace(t1.acceptbankname,chr(13),''),chr(10),'') as acceptbankname
,replace(replace(t1.acceptacct,chr(13),''),chr(10),'') as acceptacct
,replace(replace(t1.acceptname,chr(13),''),chr(10),'') as acceptname
,replace(replace(t1.acceptaccttype,chr(13),''),chr(10),'') as acceptaccttype
,replace(replace(t1.sendbank,chr(13),''),chr(10),'') as sendbank
,replace(replace(t1.sendbankname,chr(13),''),chr(10),'') as sendbankname
,replace(replace(t1.sendacct,chr(13),''),chr(10),'') as sendacct
,replace(replace(t1.sendname,chr(13),''),chr(10),'') as sendname
,replace(replace(t1.sendaccttype,chr(13),''),chr(10),'') as sendaccttype
,replace(replace(t1.msgoutbank,chr(13),''),chr(10),'') as msgoutbank
,replace(replace(t1.msginbank,chr(13),''),chr(10),'') as msginbank
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.counter,chr(13),''),chr(10),'') as counter
,replace(replace(t1.fill,chr(13),''),chr(10),'') as fill
,replace(replace(t1.rejectbank,chr(13),''),chr(10),'') as rejectbank
,replace(replace(t1.outsdficode,chr(13),''),chr(10),'') as outsdficode
,replace(replace(t1.insdficode,chr(13),''),chr(10),'') as insdficode
,replace(replace(t1.sendopenbank,chr(13),''),chr(10),'') as sendopenbank
,replace(replace(t1.acceptopenbank,chr(13),''),chr(10),'') as acceptopenbank
,replace(replace(t1.sendcitycode,chr(13),''),chr(10),'') as sendcitycode
,replace(replace(t1.acceptcitycode,chr(13),''),chr(10),'') as acceptcitycode
,replace(replace(t1.chargefee,chr(13),''),chr(10),'') as chargefee
,replace(replace(t1.postfee,chr(13),''),chr(10),'') as postfee
,replace(replace(t1.thirdchargefee,chr(13),''),chr(10),'') as thirdchargefee
,replace(replace(t1.settleamount,chr(13),''),chr(10),'') as settleamount
,replace(replace(t1.endtoendid,chr(13),''),chr(10),'') as endtoendid
,replace(replace(t1.authtype,chr(13),''),chr(10),'') as authtype
,replace(replace(t1.authinfo,chr(13),''),chr(10),'') as authinfo
,replace(replace(t1.authid,chr(13),''),chr(10),'') as authid
,replace(replace(t1.merchantcode,chr(13),''),chr(10),'') as merchantcode
,replace(replace(t1.merchantname,chr(13),''),chr(10),'') as merchantname
,replace(replace(t1.onlinetrantrace,chr(13),''),chr(10),'') as onlinetrantrace
,replace(replace(t1.onlinetrantime,chr(13),''),chr(10),'') as onlinetrantime
,replace(replace(t1.onlinetrandesc,chr(13),''),chr(10),'') as onlinetrandesc
,replace(replace(t1.opennode,chr(13),''),chr(10),'') as opennode
,replace(replace(t1.chmoment,chr(13),''),chr(10),'') as chmoment
,replace(replace(t1.coldate,chr(13),''),chr(10),'') as coldate
,replace(replace(t1.url,chr(13),''),chr(10),'') as url
,replace(replace(t1.dealcolflag,chr(13),''),chr(10),'') as dealcolflag
,replace(replace(t1.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t1.eaccflg,chr(13),''),chr(10),'') as eaccflg
,replace(replace(t1.transno,chr(13),''),chr(10),'') as transno
,replace(replace(t1.nextdayflag,chr(13),''),chr(10),'') as nextdayflag
,replace(replace(t1.bingflag,chr(13),''),chr(10),'') as bingflag
,replace(replace(t1.bingacct,chr(13),''),chr(10),'') as bingacct
,replace(replace(t1.bingacctnm,chr(13),''),chr(10),'') as bingacctnm
,replace(replace(t1.bingacctopeninst,chr(13),''),chr(10),'') as bingacctopeninst
,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype
,replace(replace(t1.opertype,chr(13),''),chr(10),'') as opertype
,replace(replace(t1.backflag,chr(13),''),chr(10),'') as backflag
,replace(replace(t1.orgnlmsgid,chr(13),''),chr(10),'') as orgnlmsgid
,replace(replace(t1.orgnlmmbid,chr(13),''),chr(10),'') as orgnlmmbid
,replace(replace(t1.abscde,chr(13),''),chr(10),'') as abscde
,replace(replace(t1.tacctp,chr(13),''),chr(10),'') as tacctp
,replace(replace(t1.handleflag,chr(13),''),chr(10),'') as handleflag
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.otpseqno,chr(13),''),chr(10),'') as otpseqno
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.sendidcode,chr(13),''),chr(10),'') as sendidcode
,replace(replace(t1.traceseqno,chr(13),''),chr(10),'') as traceseqno
,replace(replace(t1.limitorderid,chr(13),''),chr(10),'') as limitorderid
,replace(replace(t1.isbindcard,chr(13),''),chr(10),'') as isbindcard
,replace(replace(t1.globalseqno,chr(13),''),chr(10),'') as globalseqno
,replace(replace(t1.returncode,chr(13),''),chr(10),'') as returncode
,replace(replace(t1.returnmsg,chr(13),''),chr(10),'') as returnmsg
,replace(replace(t1.transseqno,chr(13),''),chr(10),'') as transseqno
,replace(replace(t1.finaccountid,chr(13),''),chr(10),'') as finaccountid
,replace(replace(t1.memocntt,chr(13),''),chr(10),'') as memocntt
,replace(replace(t1.backacctdt,chr(13),''),chr(10),'') as backacctdt
,replace(replace(t1.backacctseq,chr(13),''),chr(10),'') as backacctseq
 from iol.mpcs_a10tibpsdetaillog T1
where date2='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a10tibpsdetaillog.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes