: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_liborprices_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_liborprices_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(s_info_windcode,chr(10),''),chr(13),'') as s_info_windcode
,replace(replace(trade_dt,chr(10),''),chr(13),'') as trade_dt
,replace(replace(b_info_rate,chr(10),''),chr(13),'') as b_info_rate
,replace(replace(crncy_code,chr(10),''),chr(13),'') as crncy_code
,etl_dt
,etl_timestamp
from ${iol_schema}.wind_liborprices where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_liborprices_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes