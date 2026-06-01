: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_kdl_cnfx_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_kdl_cnfx.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.trandt
,t1.transq
,t1.status
,t1.dcmttp
,t1.dcmtno
,t1.dctpid
,t1.frozsq
,t1.oddctp
,t1.oddcno
,t1.acctno
,t1.recvdt
,t1.recvsq
,t1.oddcid
from ${idl_schema}.hdws_cbss_kdl_cnfx t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_kdl_cnfx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes