: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_kub_wkst_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_kub_wkst.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.wkstcd
,t1.wkstna
,t1.csbxno
,t1.brchno
,t1.curtus
,t1.wktpcd
,t1.handus
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_cbss_kub_wkst t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_kub_wkst.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes