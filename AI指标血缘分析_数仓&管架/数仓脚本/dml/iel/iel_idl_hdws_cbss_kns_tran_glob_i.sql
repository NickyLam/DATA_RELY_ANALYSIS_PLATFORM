: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_kns_tran_glob_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_kns_tran_glob.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.trandt
,t1.transq
,t1.globsq
,t1.trsqno
from ${idl_schema}.hdws_cbss_kns_tran_glob t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_kns_tran_glob.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes