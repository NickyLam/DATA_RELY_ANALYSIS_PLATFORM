: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_asharesalessegment_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_asharesalessegment.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.report_period,chr(13),''),chr(10),'') as report_period
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,t1.s_segment_itemcode as s_segment_itemcode
,replace(replace(t1.s_segment_item,chr(13),''),chr(10),'') as s_segment_item
,t1.s_segment_sales as s_segment_sales
,t1.s_segment_profit as s_segment_profit
,t1.s_segment_cost as s_segment_cost
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_asharesalessegment t1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_asharesalessegment.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes