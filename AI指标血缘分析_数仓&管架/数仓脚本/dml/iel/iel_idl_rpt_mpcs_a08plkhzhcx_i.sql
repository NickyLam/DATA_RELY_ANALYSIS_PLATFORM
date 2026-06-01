: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a08plkhzhcx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a08plkhzhcx.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.ptkype,chr(13),''),chr(10),'') as ptkype
,replace(replace(t1.transseq,chr(13),''),chr(10),'') as transseq
,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t1.transtm,chr(13),''),chr(10),'') as transtm
,replace(replace(t1.transmitdt,chr(13),''),chr(10),'') as transmitdt
,replace(replace(t1.sndupbrn,chr(13),''),chr(10),'') as sndupbrn
,replace(replace(t1.sndbrn,chr(13),''),chr(10),'') as sndbrn
,replace(replace(t1.rcvupbrn,chr(13),''),chr(10),'') as rcvupbrn
,replace(replace(t1.rcvbrn,chr(13),''),chr(10),'') as rcvbrn
,replace(replace(t1.syscd,chr(13),''),chr(10),'') as syscd
,replace(replace(t1.note,chr(13),''),chr(10),'') as note
,replace(replace(t1.qryacctcnt,chr(13),''),chr(10),'') as qryacctcnt
,replace(replace(t1.no,chr(13),''),chr(10),'') as no
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.acctname,chr(13),''),chr(10),'') as acctname
,replace(replace(t1.acctopenbrn,chr(13),''),chr(10),'') as acctopenbrn
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.tel,chr(13),''),chr(10),'') as tel
,replace(replace(t1.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t1.accountstatus,chr(13),''),chr(10),'') as accountstatus
,replace(replace(t1.accountlevel,chr(13),''),chr(10),'') as accountlevel
,replace(replace(t1.contactcertificatetypeid,chr(13),''),chr(10),'') as contactcertificatetypeid
,replace(replace(t1.infostring,chr(13),''),chr(10),'') as infostring
,replace(replace(t1.mobilephone,chr(13),''),chr(10),'') as mobilephone
,replace(replace(t1.iotype,chr(13),''),chr(10),'') as iotype
,replace(replace(t1.processcode,chr(13),''),chr(10),'') as processcode
,replace(replace(t1.advest,chr(13),''),chr(10),'') as advest
,replace(replace(t1.rjctinf,chr(13),''),chr(10),'') as rjctinf
,replace(replace(t1.obaldt,chr(13),''),chr(10),'') as obaldt
,replace(replace(t1.prccd,chr(13),''),chr(10),'') as prccd
,replace(replace(t1.globalseqno,chr(13),''),chr(10),'') as globalseqno
,replace(replace(t1.channlid,chr(13),''),chr(10),'') as channlid
,replace(replace(t1.refmsgno,chr(13),''),chr(10),'') as refmsgno
,replace(replace(t1.openbrn,chr(13),''),chr(10),'') as openbrn
,replace(replace(t1.checkdept,chr(13),''),chr(10),'') as checkdept
,replace(replace(t1.srcsysid,chr(13),''),chr(10),'') as srcsysid
 from iol.mpcs_a08plkhzhcx T1
where transdt='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a08plkhzhcx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes