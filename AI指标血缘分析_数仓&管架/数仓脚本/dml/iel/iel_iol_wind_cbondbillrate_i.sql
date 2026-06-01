: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondbillrate_i
CreateDate: 20230423
FileName:   ${iel_data_path}/wind_cbondbillrate.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.b_info_ratetype,chr(13),''),chr(10),'') as b_info_ratetype
,replace(replace(t1.trade_dt,chr(13),''),chr(10),'') as trade_dt
,b_info_rate

from ${iol_schema}.wind_cbondbillrate t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondbillrate.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
