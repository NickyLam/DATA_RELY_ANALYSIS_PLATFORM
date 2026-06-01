: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a1xdztransjour_i
CreateDate: 20260407
FileName:   ${iel_data_path}/mpcs_a1xdztransjour.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.transdate,chr(13),''),chr(10),'') as transdate
,replace(replace(t1.keyid,chr(13),''),chr(10),'') as keyid
,replace(replace(t1.acqinstid,chr(13),''),chr(10),'') as acqinstid
,replace(replace(t1.fwdinstid,chr(13),''),chr(10),'') as fwdinstid
,replace(replace(t1.systrace,chr(13),''),chr(10),'') as systrace
,replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.priacct,chr(13),''),chr(10),'') as priacct
,replace(replace(t1.transamt,chr(13),''),chr(10),'') as transamt
,replace(replace(t1.acceptamt,chr(13),''),chr(10),'') as acceptamt
,replace(replace(t1.handfee,chr(13),''),chr(10),'') as handfee
,replace(replace(t1.msgtype,chr(13),''),chr(10),'') as msgtype
,replace(replace(t1.procecode,chr(13),''),chr(10),'') as procecode
,replace(replace(t1.mchnttype,chr(13),''),chr(10),'') as mchnttype
,replace(replace(t1.acptermnlid,chr(13),''),chr(10),'') as acptermnlid
,replace(replace(t1.accptrid,chr(13),''),chr(10),'') as accptrid
,replace(replace(t1.accttrnameloc,chr(13),''),chr(10),'') as accttrnameloc
,replace(replace(t1.retrivarefnum,chr(13),''),chr(10),'') as retrivarefnum
,replace(replace(t1.servicecode,chr(13),''),chr(10),'') as servicecode
,replace(replace(t1.authridresp,chr(13),''),chr(10),'') as authridresp
,replace(replace(t1.rcvinstid,chr(13),''),chr(10),'') as rcvinstid
,replace(replace(t1.oldsystrace,chr(13),''),chr(10),'') as oldsystrace
,replace(replace(t1.respcode,chr(13),''),chr(10),'') as respcode
,replace(replace(t1.tranccy,chr(13),''),chr(10),'') as tranccy
,replace(replace(t1.posentrymode,chr(13),''),chr(10),'') as posentrymode
,replace(replace(t1.settccy,chr(13),''),chr(10),'') as settccy
,replace(replace(t1.settamt,chr(13),''),chr(10),'') as settamt
,replace(replace(t1.rate,chr(13),''),chr(10),'') as rate
,replace(replace(t1.settdate,chr(13),''),chr(10),'') as settdate
,replace(replace(t1.ratedate,chr(13),''),chr(10),'') as ratedate
,replace(replace(t1.cardholdccy,chr(13),''),chr(10),'') as cardholdccy
,replace(replace(t1.cardholdamt,chr(13),''),chr(10),'') as cardholdamt
,replace(replace(t1.cardholdrate,chr(13),''),chr(10),'') as cardholdrate
,replace(replace(t1.rcvtranfee,chr(13),''),chr(10),'') as rcvtranfee
,replace(replace(t1.paytranfee,chr(13),''),chr(10),'') as paytranfee
,replace(replace(t1.rcvsettfee,chr(13),''),chr(10),'') as rcvsettfee
,replace(replace(t1.paysettfee,chr(13),''),chr(10),'') as paysettfee
,replace(replace(t1.covfee,chr(13),''),chr(10),'') as covfee
,replace(replace(t1.backfee,chr(13),''),chr(10),'') as backfee
,replace(replace(t1.sindouchflg,chr(13),''),chr(10),'') as sindouchflg
,replace(replace(t1.cardseq,chr(13),''),chr(10),'') as cardseq
,replace(replace(t1.termable,chr(13),''),chr(10),'') as termable
,replace(replace(t1.iccode,chr(13),''),chr(10),'') as iccode
,replace(replace(t1.oldtranstime,chr(13),''),chr(10),'') as oldtranstime
,replace(replace(t1.issurinstid,chr(13),''),chr(10),'') as issurinstid
,replace(replace(t1.transarea,chr(13),''),chr(10),'') as transarea
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype
,replace(replace(t1.instflg,chr(13),''),chr(10),'') as instflg
,replace(replace(t1.ectflg,chr(13),''),chr(10),'') as ectflg
,replace(replace(t1.addfee,chr(13),''),chr(10),'') as addfee
,replace(replace(t1.reserve,chr(13),''),chr(10),'') as reserve
,replace(replace(t1.orderid,chr(13),''),chr(10),'') as orderid
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.remark5,chr(13),''),chr(10),'') as remark5

from ${iol_schema}.mpcs_a1xdztransjour t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1xdztransjour.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
