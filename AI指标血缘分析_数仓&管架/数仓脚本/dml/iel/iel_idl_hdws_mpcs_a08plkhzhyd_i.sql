: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a08plkhzhyd_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a08plkhzhyd.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.ptkype
,t1.transseq
,t1.orgtransseq
,t1.transdt
,t1.transtm
,t1.transmitdt
,t1.sndupbrn
,t1.sndbrn
,t1.rcvupbrn
,t1.rcvbrn
,t1.syscd
,t1.note
,t1.qryacctcnt
,t1.no
,t1.acctno
,t1.acctname
,t1.acctstatus
,t1.idrslt
,t1.telrslt
,t1.acctopenbrn
,t1.transt
,t1.processcode
,t1.iotype
,t1.advest
,t1.rjctinf
,t1.obaldt
,t1.prccd
,t1.processcode1
,t1.rejectcode
,t1.rejectinfo
,t1.osbtranseqno
,t1.osbretcd
,t1.osbretmsg
,t1.osbretst
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_mpcs_a08plkhzhyd t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a08plkhzhyd.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes