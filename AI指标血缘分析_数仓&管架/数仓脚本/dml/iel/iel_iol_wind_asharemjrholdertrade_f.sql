: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_asharemjrholdertrade_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_asharemjrholdertrade.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
    ,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
    ,replace(replace(t.ann_dt,chr(13),''),chr(10),'') as ann_dt
    ,replace(replace(t.transact_startdate,chr(13),''),chr(10),'') as transact_startdate
    ,replace(replace(t.transact_enddate,chr(13),''),chr(10),'') as transact_enddate
    ,replace(replace(t.holder_name,chr(13),''),chr(10),'') as holder_name
    ,replace(replace(t.holder_type,chr(13),''),chr(10),'') as holder_type
    ,replace(replace(t.transact_type,chr(13),''),chr(10),'') as transact_type
    ,t.transact_quantity as transact_quantity
    ,t.transact_quantity_ratio as transact_quantity_ratio
    ,t.holder_quantity_new as holder_quantity_new
    ,t.holder_quantity_new_ratio as holder_quantity_new_ratio
    ,t.avg_price as avg_price
    ,t.whether_agreed_repur_trans as whether_agreed_repur_trans
    ,t.blocktrade_quantity as blocktrade_quantity
    ,t.opdate as opdate
    ,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.wind_asharemjrholdertrade t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_asharemjrholdertrade.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes