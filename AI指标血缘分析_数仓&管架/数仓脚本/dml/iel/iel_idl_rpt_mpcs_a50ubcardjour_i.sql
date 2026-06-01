: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a50ubcardjour_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a50ubcardjour.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.acqinstid,chr(13),''),chr(10),'') as acqinstid
,replace(replace(t1.fwdinstid,chr(13),''),chr(10),'') as fwdinstid
,replace(replace(t1.systrace,chr(13),''),chr(10),'') as systrace
,replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.transcode,chr(13),''),chr(10),'') as transcode
,replace(replace(t1.transdate,chr(13),''),chr(10),'') as transdate
,replace(replace(t1.tlrnbr,chr(13),''),chr(10),'') as tlrnbr
,replace(replace(t1.brnnbr,chr(13),''),chr(10),'') as brnnbr
,replace(replace(t1.trantype,chr(13),''),chr(10),'') as trantype
,replace(replace(t1.channels,chr(13),''),chr(10),'') as channels
,replace(replace(t1.msgtype,chr(13),''),chr(10),'') as msgtype
,replace(replace(t1.priacct,chr(13),''),chr(10),'') as priacct
,replace(replace(t1.procecode,chr(13),''),chr(10),'') as procecode
,replace(replace(t1.workcode,chr(13),''),chr(10),'') as workcode
,t1.transamt as transamt
,t1.onlnbl as onlnbl
,t1.avalbl as avalbl
,t1.cravbl as cravbl
,replace(replace(t1.trxfee,chr(13),''),chr(10),'') as trxfee
,replace(replace(t1.localtime,chr(13),''),chr(10),'') as localtime
,replace(replace(t1.localdate,chr(13),''),chr(10),'') as localdate
,replace(replace(t1.exprdate,chr(13),''),chr(10),'') as exprdate
,replace(replace(t1.settlmtdate,chr(13),''),chr(10),'') as settlmtdate
,replace(replace(t1.mchnttype,chr(13),''),chr(10),'') as mchnttype
,replace(replace(t1.posentrymode,chr(13),''),chr(10),'') as posentrymode
,replace(replace(t1.servicecode,chr(13),''),chr(10),'') as servicecode
,replace(replace(t1.trackdata2,chr(13),''),chr(10),'') as trackdata2
,replace(replace(t1.trackdata3,chr(13),''),chr(10),'') as trackdata3
,replace(replace(t1.retrivarefnum,chr(13),''),chr(10),'') as retrivarefnum
,replace(replace(t1.authridresp,chr(13),''),chr(10),'') as authridresp
,replace(replace(t1.respcode,chr(13),''),chr(10),'') as respcode
,replace(replace(t1.acptermnlid,chr(13),''),chr(10),'') as acptermnlid
,replace(replace(t1.accptrid,chr(13),''),chr(10),'') as accptrid
,replace(replace(t1.accttrnameloc,chr(13),''),chr(10),'') as accttrnameloc
,replace(replace(t1.addtnlrespcd,chr(13),''),chr(10),'') as addtnlrespcd
,replace(replace(t1.privatedate,chr(13),''),chr(10),'') as privatedate
,replace(replace(t1.currcycode,chr(13),''),chr(10),'') as currcycode
,replace(replace(t1.pindata,chr(13),''),chr(10),'') as pindata
,replace(replace(t1.reserve,chr(13),''),chr(10),'') as reserve
,replace(replace(t1.rcvinstid,chr(13),''),chr(10),'') as rcvinstid
,replace(replace(t1.cupsreserve,chr(13),''),chr(10),'') as cupsreserve
,replace(replace(t1.oldacqinstid,chr(13),''),chr(10),'') as oldacqinstid
,replace(replace(t1.oldfwdinstid,chr(13),''),chr(10),'') as oldfwdinstid
,replace(replace(t1.oldsystrace,chr(13),''),chr(10),'') as oldsystrace
,replace(replace(t1.oldtranstime,chr(13),''),chr(10),'') as oldtranstime
,replace(replace(replace(replace(t1.inputdata,chr(13),''),chr(10),''),chr(9),''),chr(27),'') as inputdata
,replace(replace(t1.outputdata,chr(13),''),chr(10),'') as outputdata
,replace(replace(t1.outacctnbr,chr(13),''),chr(10),'') as outacctnbr
,replace(replace(t1.inacctnbr,chr(13),''),chr(10),'') as inacctnbr
,replace(replace(t1.atmctrace,chr(13),''),chr(10),'') as atmctrace
,t1.linkid as linkid
,replace(replace(t1.headinfo,chr(13),''),chr(10),'') as headinfo
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.errcode,chr(13),''),chr(10),'') as errcode
,replace(replace(t1.errmsg,chr(13),''),chr(10),'') as errmsg
,replace(replace(t1.tertype,chr(13),''),chr(10),'') as tertype
,replace(replace(t1.promty,chr(13),''),chr(10),'') as promty
,replace(replace(t1.acqinstctrycd,chr(13),''),chr(10),'') as acqinstctrycd
,t1.cardholdamt as cardholdamt
,replace(replace(t1.cardholdrate,chr(13),''),chr(10),'') as cardholdrate
,t1.settlmtamt as settlmtamt
,replace(replace(t1.newfwdinstid,chr(13),''),chr(10),'') as newfwdinstid
,replace(replace(t1.channeltp,chr(13),''),chr(10),'') as channeltp
,replace(replace(t1.cardseq,chr(13),''),chr(10),'') as cardseq
,replace(replace(t1.inpbocelem,chr(13),''),chr(10),'') as inpbocelem
,replace(replace(t1.outpbocelem,chr(13),''),chr(10),'') as outpbocelem
,replace(replace(t1.atmcrust,chr(13),''),chr(10),'') as atmcrust
,replace(replace(t1.trncd,chr(13),''),chr(10),'') as trncd
,t1.foriegnbl as foriegnbl
,replace(replace(t1.acctype,chr(13),''),chr(10),'') as acctype
,replace(replace(t1.openbrch,chr(13),''),chr(10),'') as openbrch
,t1.fee as fee
,replace(replace(t1.card_type,chr(13),''),chr(10),'') as card_type
,replace(replace(t1.card_trn_typ,chr(13),''),chr(10),'') as card_trn_typ
,replace(replace(t1.scene,chr(13),''),chr(10),'') as scene
,replace(replace(t1.cross_flag,chr(13),''),chr(10),'') as cross_flag
,replace(replace(t1.fallback_fg,chr(13),''),chr(10),'') as fallback_fg
,replace(replace(t1.petty_flag,chr(13),''),chr(10),'') as petty_flag
,replace(replace(t1.respcode_s,chr(13),''),chr(10),'') as respcode_s
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t1.memo_det,chr(13),''),chr(10),'') as memo_det
,replace(replace(t1.global_seq,chr(13),''),chr(10),'') as global_seq
,replace(replace(t1.trn_seq,chr(13),''),chr(10),'') as trn_seq
,replace(replace(t1.old_trn_seq,chr(13),''),chr(10),'') as old_trn_seq
,replace(replace(t1.upp_status,chr(13),''),chr(10),'') as upp_status
,replace(replace(t1.host_nbr,chr(13),''),chr(10),'') as host_nbr
,replace(replace(t1.host_date,chr(13),''),chr(10),'') as host_date
,replace(replace(t1.dly_trn_id,chr(13),''),chr(10),'') as dly_trn_id
,replace(replace(t1.dly_trn_dt,chr(13),''),chr(10),'') as dly_trn_dt
,replace(replace(t1.dly_yl_stu,chr(13),''),chr(10),'') as dly_yl_stu
,replace(replace(t1.dly_status,chr(13),''),chr(10),'') as dly_status
,replace(replace(t1.cust_termid,chr(13),''),chr(10),'') as cust_termid
,replace(replace(t1.cust_ip,chr(13),''),chr(10),'') as cust_ip
,replace(replace(t1.client_sim,chr(13),''),chr(10),'') as client_sim
,replace(replace(t1.client_gps,chr(13),''),chr(10),'') as client_gps
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.trn_time,chr(13),''),chr(10),'') as trn_time
,replace(replace(t1.back_acct_date,chr(13),''),chr(10),'') as back_acct_date
,replace(replace(t1.oldtranscode,chr(13),''),chr(10),'') as oldtranscode
 from iol.mpcs_a50ubcardjourhis T1
where transdate=to_char(to_date('${batch_date}','yyyymmdd') -1,'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a50ubcardjour.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes