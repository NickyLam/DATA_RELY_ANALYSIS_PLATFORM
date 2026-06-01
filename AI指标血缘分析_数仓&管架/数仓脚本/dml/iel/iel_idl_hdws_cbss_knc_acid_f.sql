: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_knc_acid_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_knc_acid.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.custno
,t1.datatp
,t1.datavl
,t1.datast
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_cbss_knc_acid t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_knc_acid.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes