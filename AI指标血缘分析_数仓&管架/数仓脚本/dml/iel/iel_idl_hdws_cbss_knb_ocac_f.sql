: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_knb_ocac_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_knb_ocac.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.opendt
,t1.opiasq
,t1.opensq
,t1.opactp
,t1.opbrno
,t1.acctno
,t1.subsac
,t1.acctna
,t1.crcycd
,t1.closdt
,t1.clossq
,t1.clactp
from ${idl_schema}.hdws_cbss_knb_ocac t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_knb_ocac.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes