: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a08tbetotallog_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a08tbetotallog_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
pktype
,dtlcmtno
,sdclbk
,sendct
,rdclbk
,recvct
,date0
,trandt
,pkgbusinesstrace
,pksqno
,rstpwd
,deadline
,backdate
,totalnum
,totalamt
,succtotalnum
,succtotalamt
,failtotalnum
,failtotalamt
,crcycd
,obaltp
,obalod
,obaldt
,reissusflag
,clerdt
,node
,transstatus
,status
,iotype
,flag4
,orapkgtype
,orasdclbk
,oradate0
,orapkgbusinesstrace
,orapksqno
,diskno
,transq
,sdtrsq
,colstatus
,coldate
,note
,othercnapsver
from ${idl_schema}.odss_a08tbetotallog
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a08tbetotallog_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes