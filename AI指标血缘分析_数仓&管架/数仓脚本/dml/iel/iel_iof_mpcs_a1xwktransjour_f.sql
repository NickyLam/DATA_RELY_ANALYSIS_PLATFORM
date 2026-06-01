: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a1xwktransjour_f
CreateDate: 20250416
FileName:   ${iel_data_path}/mpcs_a1xwktransjour.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.fntdt,chr(13),''),chr(10),'') as fntdt
,replace(replace(t1.globalseq,chr(13),''),chr(10),'') as globalseq
,replace(replace(t1.transcode,chr(13),''),chr(10),'') as transcode
,replace(replace(t1.oldtranscode,chr(13),''),chr(10),'') as oldtranscode
,replace(replace(t1.txnno,chr(13),''),chr(10),'') as txnno
,replace(replace(t1.messageid,chr(13),''),chr(10),'') as messageid
,replace(replace(t1.orderid,chr(13),''),chr(10),'') as orderid
,replace(replace(t1.reforderid,chr(13),''),chr(10),'') as reforderid
,replace(replace(t1.txnamt,chr(13),''),chr(10),'') as txnamt
,replace(replace(t1.txnwkamt,chr(13),''),chr(10),'') as txnwkamt
,replace(replace(t1.feeamt,chr(13),''),chr(10),'') as feeamt
,replace(replace(t1.txnccy,chr(13),''),chr(10),'') as txnccy
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.acctprd,chr(13),''),chr(10),'') as acctprd
,replace(replace(t1.acctcvn,chr(13),''),chr(10),'') as acctcvn
,replace(replace(t1.phoneno,chr(13),''),chr(10),'') as phoneno
,replace(replace(t1.customid,chr(13),''),chr(10),'') as customid
,replace(replace(t1.baseacctno,chr(13),''),chr(10),'') as baseacctno
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t1.issinscode,chr(13),''),chr(10),'') as issinscode
,replace(replace(t1.merchantid,chr(13),''),chr(10),'') as merchantid
,replace(replace(t1.frncurcode,chr(13),''),chr(10),'') as frncurcode
,replace(replace(t1.frntxnamt,chr(13),''),chr(10),'') as frntxnamt
,replace(replace(t1.callbackurl,chr(13),''),chr(10),'') as callbackurl
,replace(replace(t1.authurl,chr(13),''),chr(10),'') as authurl
,replace(replace(t1.modetp,chr(13),''),chr(10),'') as modetp
,replace(replace(t1.synctype,chr(13),''),chr(10),'') as synctype
,replace(replace(t1.code,chr(13),''),chr(10),'') as code
,replace(replace(t1.rspdesc,chr(13),''),chr(10),'') as rspdesc
,replace(replace(t1.authcode,chr(13),''),chr(10),'') as authcode
,replace(replace(t1.retrievalnumber,chr(13),''),chr(10),'') as retrievalnumber
,replace(replace(t1.settldate,chr(13),''),chr(10),'') as settldate
,replace(replace(t1.brand,chr(13),''),chr(10),'') as brand
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.degree,chr(13),''),chr(10),'') as degree
,replace(replace(t1.busiseq,chr(13),''),chr(10),'') as busiseq
,replace(replace(t1.transeq,chr(13),''),chr(10),'') as transeq
,replace(replace(t1.hostnbr,chr(13),''),chr(10),'') as hostnbr
,replace(replace(t1.destrnseq,chr(13),''),chr(10),'') as destrnseq
,replace(replace(t1.rtitraceseqno,chr(13),''),chr(10),'') as rtitraceseqno
,inserttm
,updatetm
,callbacktm
,replace(replace(t1.hostchkflg,chr(13),''),chr(10),'') as hostchkflg
,replace(replace(t1.eci,chr(13),''),chr(10),'') as eci
,replace(replace(t1.av,chr(13),''),chr(10),'') as av
,replace(replace(t1.dstransactionid,chr(13),''),chr(10),'') as dstransactionid
,replace(replace(t1.transstatus,chr(13),''),chr(10),'') as transstatus
,replace(replace(t1.settleamt,chr(13),''),chr(10),'') as settleamt
,replace(replace(t1.settlecurrencycode,chr(13),''),chr(10),'') as settlecurrencycode
,replace(replace(t1.exchangedate,chr(13),''),chr(10),'') as exchangedate
,replace(replace(t1.exchangerate,chr(13),''),chr(10),'') as exchangerate
,replace(replace(t1.traceno,chr(13),''),chr(10),'') as traceno
,replace(replace(t1.tracetime,chr(13),''),chr(10),'') as tracetime
,replace(replace(t1.hostdate,chr(13),''),chr(10),'') as hostdate
,replace(replace(t1.queryid,chr(13),''),chr(10),'') as queryid
,replace(replace(t1.txntime,chr(13),''),chr(10),'') as txntime
,replace(replace(t1.bkstatus,chr(13),''),chr(10),'') as bkstatus
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.remark5,chr(13),''),chr(10),'') as remark5
,replace(replace(t1.remark6,chr(13),''),chr(10),'') as remark6
,replace(replace(t1.remark7,chr(13),''),chr(10),'') as remark7
,replace(replace(t1.remark8,chr(13),''),chr(10),'') as remark8

from ${iol_schema}.mpcs_a1xwktransjour t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1xwktransjour.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
