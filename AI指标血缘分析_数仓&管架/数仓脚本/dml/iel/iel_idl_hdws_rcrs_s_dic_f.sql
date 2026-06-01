: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_rcrs_s_dic_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_rcrs_s_dic.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.enname
,t1.cnname
,t1.opttype
,t1.memo
,t1.flag
,t1.levels
,t1.orderid
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_rcrs_s_dic t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_rcrs_s_dic.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes