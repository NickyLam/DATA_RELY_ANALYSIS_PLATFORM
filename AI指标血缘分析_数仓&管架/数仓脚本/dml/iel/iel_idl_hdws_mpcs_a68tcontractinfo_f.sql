: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a68tcontractinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a68tcontractinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.transdt
,t1.transtm
,t1.corprtnid
,t1.pmtid
,t1.reqid
,t1.pmtitmcd
,t1.pmtitmnm
,t1.cstmrid
,t1.cstmrnm
,t1.issr
,t1.issrnm
,t1.accttype
,t1.acctid
,t1.ccy
,t1.oncddctnlmt
,t1.cycddctnnumlmt
,t1.ctrctduedt
,t1.ctrctsgndt
,t1.ectdt
,t1.paypersna
,t1.paypersidtp
,t1.paypersid
,t1.tel
,t1.address
,t1.remark
,t1.authmodel
,t1.timeunit
,t1.timestep
,t1.timedesc
,t1.moneylimit
,t1.authcode
,t1.status
,t1.errmsg
,t1.dealinfo
,t1.authtlr
,t1.authdt
,t1.authseqno
,t1.authpmtid
,t1.sendmsgflag
,t1.otpseqno
,t1.uptm
,t1.authchl
,t1.margbrn
,t1.openbrnnm
,t1.uptransdt
,t1.uptranstm
,t1.upreqid
,t1.upctrctduedt
,t1.upauthmodel
,t1.upotpseqno
,t1.upstatus
,t1.uperrmsg
,t1.upauthdt
,t1.upauthseqno
,t1.upauthtlr
,t1.upauthchl
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_mpcs_a68tcontractinfo t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a68tcontractinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes