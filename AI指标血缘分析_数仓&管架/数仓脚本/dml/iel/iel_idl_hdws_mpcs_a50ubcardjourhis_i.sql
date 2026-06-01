: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a50ubcardjourhis_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a50ubcardjourhis.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.acqinstid
,t1.fwdinstid
,t1.systrace
,t1.transtime
,t1.transcode
,t1.transdate
,t1.tlrnbr
,t1.brnnbr
,t1.trantype
,t1.channels
,t1.msgtype
,t1.priacct
,t1.procecode
,t1.workcode
,t1.transamt
,t1.onlnbl
,t1.avalbl
,t1.cravbl
,t1.trxfee
,t1.localtime
,t1.localdate
,t1.exprdate
,t1.settlmtdate
,t1.mchnttype
,t1.posentrymode
,t1.servicecode
,t1.trackdata2
,t1.trackdata3
,t1.retrivarefnum
,t1.authridresp
,t1.respcode
,t1.acptermnlid
,t1.accptrid
,t1.accttrnameloc
,t1.addtnlrespcd
,t1.privatedate
,t1.currcycode
,t1.pindata
,t1.reserve
,t1.rcvinstid
,t1.cupsreserve
,t1.oldacqinstid
,t1.oldfwdinstid
,t1.oldsystrace
,t1.oldtranstime
,t1.inputdata
,t1.outputdata
,t1.outacctnbr
,t1.inacctnbr
,t1.atmctrace
,t1.linkid
,t1.headinfo
,t1.status
,t1.errcode
,t1.errmsg
,t1.tertype
,t1.promty
,t1.acqinstctrycd
,t1.cardholdamt
,t1.cardholdrate
,t1.settlmtamt
,t1.newfwdinstid
,t1.channeltp
,t1.cardseq
,t1.inpbocelem
,t1.outpbocelem
,t1.atmcrust
,t1.trncd
,t1.foriegnbl
,t1.acctype
,t1.openbrch
,t1.fee
,t1.card_type
,t1.card_trn_typ
,t1.scene
,t1.cross_flag
,t1.fallback_fg
,t1.petty_flag
,t1.respcode_s
,t1.memo_cd
,t1.memo_det
,t1.global_seq
,t1.trn_seq
,t1.old_trn_seq
,t1.upp_status
,t1.host_nbr
,t1.host_date
,t1.dly_trn_id
,t1.dly_trn_dt
,t1.dly_yl_stu
,t1.dly_status
,t1.cust_termid
,t1.cust_ip
,t1.client_sim
,t1.client_gps
,t1.mobile
,t1.cust_no
,t1.cust_name
,t1.trn_time
,t1.back_acct_date
,t1.oldtranscode
from ${idl_schema}.hdws_mpcs_a50ubcardjourhis t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a50ubcardjourhis.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes