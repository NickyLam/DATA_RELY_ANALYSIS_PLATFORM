: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a08plkhzhyd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a08plkhzhyd.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.ptkype,chr(13),''),chr(10),'') as ptkype
,replace(replace(t1.transseq,chr(13),''),chr(10),'') as transseq
,replace(replace(t1.orgtransseq,chr(13),''),chr(10),'') as orgtransseq
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
,replace(replace(t1.acctstatus,chr(13),''),chr(10),'') as acctstatus
,replace(replace(t1.idrslt,chr(13),''),chr(10),'') as idrslt
,replace(replace(t1.telrslt,chr(13),''),chr(10),'') as telrslt
,replace(replace(t1.acctopenbrn,chr(13),''),chr(10),'') as acctopenbrn
,replace(replace(t1.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t1.processcode,chr(13),''),chr(10),'') as processcode
,replace(replace(t1.iotype,chr(13),''),chr(10),'') as iotype
,replace(replace(t1.advest,chr(13),''),chr(10),'') as advest
,replace(replace(t1.rjctinf,chr(13),''),chr(10),'') as rjctinf
,replace(replace(t1.obaldt,chr(13),''),chr(10),'') as obaldt
,replace(replace(t1.prccd,chr(13),''),chr(10),'') as prccd
,replace(replace(t1.processcode1,chr(13),''),chr(10),'') as processcode1
,replace(replace(t1.rejectcode,chr(13),''),chr(10),'') as rejectcode
,replace(replace(t1.rejectinfo,chr(13),''),chr(10),'') as rejectinfo
,replace(replace(t1.osbtranseqno,chr(13),''),chr(10),'') as osbtranseqno
,replace(replace(t1.osbretcd,chr(13),''),chr(10),'') as osbretcd
,replace(replace(t1.osbretmsg,chr(13),''),chr(10),'') as osbretmsg
,replace(replace(t1.osbretst,chr(13),''),chr(10),'') as osbretst
 from iol.mpcs_a08plkhzhyd T1
where transdt='${batch_date}' and start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a08plkhzhyd.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes