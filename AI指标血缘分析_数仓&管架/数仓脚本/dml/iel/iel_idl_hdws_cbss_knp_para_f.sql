: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_cbss_knp_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_cbss_knp_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.parmcd
,t1.pmkey1
,t1.pmkey2
,t1.pmkey3
,t1.pmval1
,t1.pmval2
,t1.pmval3
,t1.pmval4
,t1.pmval5
,t1.vermod
,t1.module
,t1.projcd
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_cbss_knp_para t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_cbss_knp_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes