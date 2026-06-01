: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_kna_slep_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_kna_slep.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.acctno
,t1.acctid
,t1.acctna
,t1.brchno
,t1.crcycd
,t1.custno
,t1.idtftp
,t1.idtfno
,t1.opendt
,t1.opentm
,t1.lstrdt
,t1.acctst
,t1.onlnbl
,t1.accst2
,t1.trandt
,t1.transt
,t1.rttrdt
,t1.rttrsq
,t1.erortx
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_cbss_kna_slep t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_kna_slep.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes