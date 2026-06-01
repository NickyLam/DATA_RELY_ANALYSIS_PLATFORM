: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a50ubcardjour_i_m
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a50ubcardjour.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.acqinstid,chr(13),''),chr(10),'') as acqinstid
,replace(replace(t.fwdinstid,chr(13),''),chr(10),'') as fwdinstid
,replace(replace(t.systrace,chr(13),''),chr(10),'') as systrace
,replace(replace(t.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t.transcode,chr(13),''),chr(10),'') as transcode
,replace(replace(t.transdate,chr(13),''),chr(10),'') as transdate
,replace(replace(t.tlrnbr,chr(13),''),chr(10),'') as tlrnbr
,replace(replace(t.brnnbr,chr(13),''),chr(10),'') as brnnbr
,replace(replace(t.trantype,chr(13),''),chr(10),'') as trantype
,replace(replace(t.channels,chr(13),''),chr(10),'') as channels
,replace(replace(t.msgtype,chr(13),''),chr(10),'') as msgtype
,replace(replace(t.priacct,chr(13),''),chr(10),'') as priacct
,replace(replace(t.procecode,chr(13),''),chr(10),'') as procecode
,replace(replace(t.workcode,chr(13),''),chr(10),'') as workcode
,t.transamt as transamt
,t.onlnbl as onlnbl
,t.avalbl as avalbl
,t.cravbl as cravbl
,replace(replace(t.trxfee,chr(13),''),chr(10),'') as trxfee
,replace(replace(t.localtime,chr(13),''),chr(10),'') as localtime
,replace(replace(t.localdate,chr(13),''),chr(10),'') as localdate
,replace(replace(t.exprdate,chr(13),''),chr(10),'') as exprdate
,replace(replace(t.settlmtdate,chr(13),''),chr(10),'') as settlmtdate
,replace(replace(t.mchnttype,chr(13),''),chr(10),'') as mchnttype
,replace(replace(t.posentrymode,chr(13),''),chr(10),'') as posentrymode
,replace(replace(t.servicecode,chr(13),''),chr(10),'') as servicecode
,replace(replace(t.trackdata2,chr(13),''),chr(10),'') as trackdata2
,replace(replace(t.trackdata3,chr(13),''),chr(10),'') as trackdata3
,replace(replace(t.retrivarefnum,chr(13),''),chr(10),'') as retrivarefnum
,replace(replace(t.authridresp,chr(13),''),chr(10),'') as authridresp
,replace(replace(t.respcode,chr(13),''),chr(10),'') as respcode
,replace(replace(t.acptermnlid,chr(13),''),chr(10),'') as acptermnlid
,replace(replace(t.accptrid,chr(13),''),chr(10),'') as accptrid
,replace(replace(t.accttrnameloc,chr(13),''),chr(10),'') as accttrnameloc
,replace(replace(t.addtnlrespcd,chr(13),''),chr(10),'') as addtnlrespcd
,replace(replace(t.privatedate,chr(13),''),chr(10),'') as privatedate
,replace(replace(t.currcycode,chr(13),''),chr(10),'') as currcycode
,replace(replace(t.pindata,chr(13),''),chr(10),'') as pindata
,replace(replace(t.reserve,chr(13),''),chr(10),'') as reserve
,replace(replace(t.rcvinstid,chr(13),''),chr(10),'') as rcvinstid
,replace(replace(t.cupsreserve,chr(13),''),chr(10),'') as cupsreserve
,replace(replace(t.oldacqinstid,chr(13),''),chr(10),'') as oldacqinstid
,replace(replace(t.oldfwdinstid,chr(13),''),chr(10),'') as oldfwdinstid
,replace(replace(t.oldsystrace,chr(13),''),chr(10),'') as oldsystrace
,replace(replace(t.oldtranstime,chr(13),''),chr(10),'') as oldtranstime
,replace(replace(t.inputdata,chr(13),''),chr(10),'') as inputdata
,replace(replace(t.outputdata,chr(13),''),chr(10),'') as outputdata
,replace(replace(t.outacctnbr,chr(13),''),chr(10),'') as outacctnbr
,replace(replace(t.inacctnbr,chr(13),''),chr(10),'') as inacctnbr
,replace(replace(t.atmctrace,chr(13),''),chr(10),'') as atmctrace
,t.linkid as linkid
,replace(replace(t.headinfo,chr(13),''),chr(10),'') as headinfo
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.errcode,chr(13),''),chr(10),'') as errcode
,replace(replace(t.errmsg,chr(13),''),chr(10),'') as errmsg
,replace(replace(t.tertype,chr(13),''),chr(10),'') as tertype
,replace(replace(t.promty,chr(13),''),chr(10),'') as promty
,replace(replace(t.acqinstctrycd,chr(13),''),chr(10),'') as acqinstctrycd
,t.cardholdamt as cardholdamt
,replace(replace(t.cardholdrate,chr(13),''),chr(10),'') as cardholdrate
,t.settlmtamt as settlmtamt
,replace(replace(t.newfwdinstid,chr(13),''),chr(10),'') as newfwdinstid
,replace(replace(t.channeltp,chr(13),''),chr(10),'') as channeltp
,replace(replace(t.cardseq,chr(13),''),chr(10),'') as cardseq
,replace(replace(t.inpbocelem,chr(13),''),chr(10),'') as inpbocelem
,replace(replace(t.outpbocelem,chr(13),''),chr(10),'') as outpbocelem
,replace(replace(t.atmcrust,chr(13),''),chr(10),'') as atmcrust
,replace(replace(t.trncd,chr(13),''),chr(10),'') as trncd
,t.foriegnbl as foriegnbl
,replace(replace(t.acctype,chr(13),''),chr(10),'') as acctype
,replace(replace(t.openbrch,chr(13),''),chr(10),'') as openbrch
,t.fee as fee
,replace(replace(t.card_type,chr(13),''),chr(10),'') as card_type
,replace(replace(t.card_trn_typ,chr(13),''),chr(10),'') as card_trn_typ
,replace(replace(t.scene,chr(13),''),chr(10),'') as scene
,replace(replace(t.cross_flag,chr(13),''),chr(10),'') as cross_flag
,replace(replace(t.fallback_fg,chr(13),''),chr(10),'') as fallback_fg
,replace(replace(t.petty_flag,chr(13),''),chr(10),'') as petty_flag
,replace(replace(t.respcode_s,chr(13),''),chr(10),'') as respcode_s
,replace(replace(t.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t.memo_det,chr(13),''),chr(10),'') as memo_det
,replace(replace(t.global_seq,chr(13),''),chr(10),'') as global_seq
,replace(replace(t.trn_seq,chr(13),''),chr(10),'') as trn_seq
,replace(replace(t.old_trn_seq,chr(13),''),chr(10),'') as old_trn_seq
,replace(replace(t.upp_status,chr(13),''),chr(10),'') as upp_status
,replace(replace(t.host_nbr,chr(13),''),chr(10),'') as host_nbr
,replace(replace(t.host_date,chr(13),''),chr(10),'') as host_date
,replace(replace(t.dly_trn_id,chr(13),''),chr(10),'') as dly_trn_id
,replace(replace(t.dly_trn_dt,chr(13),''),chr(10),'') as dly_trn_dt
,replace(replace(t.dly_yl_stu,chr(13),''),chr(10),'') as dly_yl_stu
,replace(replace(t.dly_status,chr(13),''),chr(10),'') as dly_status
,replace(replace(t.cust_termid,chr(13),''),chr(10),'') as cust_termid
,replace(replace(t.cust_ip,chr(13),''),chr(10),'') as cust_ip
,replace(replace(t.client_sim,chr(13),''),chr(10),'') as client_sim
,replace(replace(t.client_gps,chr(13),''),chr(10),'') as client_gps
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.trn_time,chr(13),''),chr(10),'') as trn_time
,replace(replace(t.back_acct_date,chr(13),''),chr(10),'') as back_acct_date
,replace(replace(t.oldtranscode,chr(13),''),chr(10),'') as oldtranscode
from ${iol_schema}.mpcs_a50ubcardjour t
where t.transdate >= to_char(trunc(to_date('${batch_date}','yyyymmdd'),'month'),'yyyymmdd')
and t.transdate <= to_char(to_date('${batch_date}','yyyymmdd'),'yyyymmdd') and t.etl_dt >= trunc(to_date('${batch_date}','yyyymmdd'),'month')
and t.etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a50ubcardjour.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes