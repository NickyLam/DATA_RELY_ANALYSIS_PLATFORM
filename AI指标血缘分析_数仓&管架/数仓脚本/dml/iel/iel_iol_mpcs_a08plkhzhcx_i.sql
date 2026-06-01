: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a08plkhzhcx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a08plkhzhcx.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.ptkype,chr(13),''),chr(10),'') as ptkype
,replace(replace(t.transseq,chr(13),''),chr(10),'') as transseq
,replace(replace(t.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t.transtm,chr(13),''),chr(10),'') as transtm
,replace(replace(t.transmitdt,chr(13),''),chr(10),'') as transmitdt
,replace(replace(t.sndupbrn,chr(13),''),chr(10),'') as sndupbrn
,replace(replace(t.sndbrn,chr(13),''),chr(10),'') as sndbrn
,replace(replace(t.rcvupbrn,chr(13),''),chr(10),'') as rcvupbrn
,replace(replace(t.rcvbrn,chr(13),''),chr(10),'') as rcvbrn
,replace(replace(t.syscd,chr(13),''),chr(10),'') as syscd
,replace(replace(t.note,chr(13),''),chr(10),'') as note
,replace(replace(t.qryacctcnt,chr(13),''),chr(10),'') as qryacctcnt
,replace(replace(t.no,chr(13),''),chr(10),'') as no
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.acctname,chr(13),''),chr(10),'') as acctname
,replace(replace(t.acctopenbrn,chr(13),''),chr(10),'') as acctopenbrn
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.tel,chr(13),''),chr(10),'') as tel
,replace(replace(t.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t.accountstatus,chr(13),''),chr(10),'') as accountstatus
,replace(replace(t.accountlevel,chr(13),''),chr(10),'') as accountlevel
,replace(replace(t.contactcertificatetypeid,chr(13),''),chr(10),'') as contactcertificatetypeid
,replace(replace(t.infostring,chr(13),''),chr(10),'') as infostring
,replace(replace(t.mobilephone,chr(13),''),chr(10),'') as mobilephone
,replace(replace(t.iotype,chr(13),''),chr(10),'') as iotype
,replace(replace(t.processcode,chr(13),''),chr(10),'') as processcode
,replace(replace(t.advest,chr(13),''),chr(10),'') as advest
,replace(replace(t.rjctinf,chr(13),''),chr(10),'') as rjctinf
,replace(replace(t.obaldt,chr(13),''),chr(10),'') as obaldt
,replace(replace(t.prccd,chr(13),''),chr(10),'') as prccd
,replace(replace(t.globalseqno,chr(13),''),chr(10),'') as globalseqno
,replace(replace(t.channlid,chr(13),''),chr(10),'') as channlid
,replace(replace(t.refmsgno,chr(13),''),chr(10),'') as refmsgno
,replace(replace(t.openbrn,chr(13),''),chr(10),'') as openbrn
,replace(replace(t.checkdept,chr(13),''),chr(10),'') as checkdept
,replace(replace(t.srcsysid,chr(13),''),chr(10),'') as srcsysid
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.MPCS_A08PLKHZHCX t 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
and TRANSDT='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a08plkhzhcx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes