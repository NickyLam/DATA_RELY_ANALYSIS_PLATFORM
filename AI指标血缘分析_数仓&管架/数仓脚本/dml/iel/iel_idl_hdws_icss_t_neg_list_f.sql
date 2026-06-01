: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_icss_t_neg_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_icss_t_neg_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.customerid
,t1.negativetype
,t1.inputtime
,t1.outlisttime
from ${idl_schema}.hdws_icss_t_neg_list t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_icss_t_neg_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes