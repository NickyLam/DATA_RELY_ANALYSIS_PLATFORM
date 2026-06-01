: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_kna_dpac_cntr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_kna_dpac_cntr.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.acctid
,t1.cntrno
,t1.acrdam
,t1.bgaldt
,t1.matudt
,t1.crinrt
,t1.cuinme
,t1.aprvno
,t1.apfllv
,t1.acmlbl
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_cbss_kna_dpac_cntr t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_kna_dpac_cntr.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes