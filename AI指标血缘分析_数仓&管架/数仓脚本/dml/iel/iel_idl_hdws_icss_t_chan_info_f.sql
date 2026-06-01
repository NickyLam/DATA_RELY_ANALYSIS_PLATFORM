: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_icss_t_chan_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_icss_t_chan_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.channelid
,t1.contractno
,t1.channelname
,t1.managerid
,t1.trusteeid
,t1.controltype
,t1.hasrate
,t1.ratetype
,t1.raisesum
,t1.isnetvalue
,t1.ishierarchical
from ${idl_schema}.hdws_icss_t_chan_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_icss_t_chan_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes