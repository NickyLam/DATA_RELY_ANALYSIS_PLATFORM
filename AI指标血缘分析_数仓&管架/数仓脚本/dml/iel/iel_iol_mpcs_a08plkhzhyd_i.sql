: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a08plkhzhyd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a08plkhzhyd.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.ptkype,chr(13),''),chr(10),'') as ptkype
,replace(replace(t.transseq,chr(13),''),chr(10),'') as transseq
,replace(replace(t.orgtransseq,chr(13),''),chr(10),'') as orgtransseq
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
,replace(replace(t.acctstatus,chr(13),''),chr(10),'') as acctstatus
,replace(replace(t.idrslt,chr(13),''),chr(10),'') as idrslt
,replace(replace(t.telrslt,chr(13),''),chr(10),'') as telrslt
,replace(replace(t.acctopenbrn,chr(13),''),chr(10),'') as acctopenbrn
,replace(replace(t.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t.processcode,chr(13),''),chr(10),'') as processcode
,replace(replace(t.iotype,chr(13),''),chr(10),'') as iotype
,replace(replace(t.advest,chr(13),''),chr(10),'') as advest
,replace(replace(t.rjctinf,chr(13),''),chr(10),'') as rjctinf
,replace(replace(t.obaldt,chr(13),''),chr(10),'') as obaldt
,replace(replace(t.prccd,chr(13),''),chr(10),'') as prccd
,replace(replace(t.processcode1,chr(13),''),chr(10),'') as processcode1
,replace(replace(t.rejectcode,chr(13),''),chr(10),'') as rejectcode
,replace(replace(t.rejectinfo,chr(13),''),chr(10),'') as rejectinfo
,replace(replace(t.osbtranseqno,chr(13),''),chr(10),'') as osbtranseqno
,replace(replace(t.osbretcd,chr(13),''),chr(10),'') as osbretcd
,replace(replace(t.osbretmsg,chr(13),''),chr(10),'') as osbretmsg
,replace(replace(t.osbretst,chr(13),''),chr(10),'') as osbretst
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.MPCS_A08PLKHZHYD t 
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')
and TRANSDT='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a08plkhzhyd.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes