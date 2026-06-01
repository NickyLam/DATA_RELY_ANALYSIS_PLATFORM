: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a68tcontractinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a68tcontractinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t1.transtm,chr(13),''),chr(10),'') as transtm
,replace(replace(t1.corprtnid,chr(13),''),chr(10),'') as corprtnid
,replace(replace(t1.pmtid,chr(13),''),chr(10),'') as pmtid
,replace(replace(t1.reqid,chr(13),''),chr(10),'') as reqid
,replace(replace(t1.pmtitmcd,chr(13),''),chr(10),'') as pmtitmcd
,replace(replace(t1.pmtitmnm,chr(13),''),chr(10),'') as pmtitmnm
,replace(replace(t1.cstmrid,chr(13),''),chr(10),'') as cstmrid
,replace(replace(t1.cstmrnm,chr(13),''),chr(10),'') as cstmrnm
,replace(replace(t1.issr,chr(13),''),chr(10),'') as issr
,replace(replace(t1.issrnm,chr(13),''),chr(10),'') as issrnm
,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype
,replace(replace(t1.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.oncddctnlmt,chr(13),''),chr(10),'') as oncddctnlmt
,replace(replace(t1.cycddctnnumlmt,chr(13),''),chr(10),'') as cycddctnnumlmt
,replace(replace(t1.ctrctduedt,chr(13),''),chr(10),'') as ctrctduedt
,replace(replace(t1.ctrctsgndt,chr(13),''),chr(10),'') as ctrctsgndt
,replace(replace(t1.ectdt,chr(13),''),chr(10),'') as ectdt
,replace(replace(t1.paypersna,chr(13),''),chr(10),'') as paypersna
,replace(replace(t1.paypersidtp,chr(13),''),chr(10),'') as paypersidtp
,replace(replace(t1.paypersid,chr(13),''),chr(10),'') as paypersid
,replace(replace(t1.tel,chr(13),''),chr(10),'') as tel
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.authmodel,chr(13),''),chr(10),'') as authmodel
,replace(replace(t1.timeunit,chr(13),''),chr(10),'') as timeunit
,replace(replace(t1.timestep,chr(13),''),chr(10),'') as timestep
,replace(replace(t1.timedesc,chr(13),''),chr(10),'') as timedesc
,replace(replace(t1.moneylimit,chr(13),''),chr(10),'') as moneylimit
,replace(replace(t1.authcode,chr(13),''),chr(10),'') as authcode
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.errmsg,chr(13),''),chr(10),'') as errmsg
,replace(replace(t1.dealinfo,chr(13),''),chr(10),'') as dealinfo
,replace(replace(t1.authtlr,chr(13),''),chr(10),'') as authtlr
,replace(replace(t1.authdt,chr(13),''),chr(10),'') as authdt
,replace(replace(t1.authseqno,chr(13),''),chr(10),'') as authseqno
,replace(replace(t1.authpmtid,chr(13),''),chr(10),'') as authpmtid
,replace(replace(t1.sendmsgflag,chr(13),''),chr(10),'') as sendmsgflag
,replace(replace(t1.otpseqno,chr(13),''),chr(10),'') as otpseqno
,replace(replace(t1.uptm,chr(13),''),chr(10),'') as uptm
,replace(replace(t1.authchl,chr(13),''),chr(10),'') as authchl
,replace(replace(t1.margbrn,chr(13),''),chr(10),'') as margbrn
,replace(replace(t1.openbrnnm,chr(13),''),chr(10),'') as openbrnnm
,replace(replace(t1.uptransdt,chr(13),''),chr(10),'') as uptransdt
,replace(replace(t1.uptranstm,chr(13),''),chr(10),'') as uptranstm
,replace(replace(t1.upreqid,chr(13),''),chr(10),'') as upreqid
,replace(replace(t1.upctrctduedt,chr(13),''),chr(10),'') as upctrctduedt
,replace(replace(t1.upauthmodel,chr(13),''),chr(10),'') as upauthmodel
,replace(replace(t1.upotpseqno,chr(13),''),chr(10),'') as upotpseqno
,replace(replace(t1.upstatus,chr(13),''),chr(10),'') as upstatus
,replace(replace(t1.uperrmsg,chr(13),''),chr(10),'') as uperrmsg
,replace(replace(t1.upauthdt,chr(13),''),chr(10),'') as upauthdt
,replace(replace(t1.upauthseqno,chr(13),''),chr(10),'') as upauthseqno
,replace(replace(t1.upauthtlr,chr(13),''),chr(10),'') as upauthtlr
,replace(replace(t1.upauthchl,chr(13),''),chr(10),'') as upauthchl
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.mpcs_a68tcontractinfo t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a68tcontractinfo.f.${batch_date}.dat" \
        charset=utf8
        safe=yes