: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_neeqsdescription_f
CreateDate: 20230823
FileName:   ${iel_data_path}/wind_neeqsdescription.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.s_info_code,chr(13),''),chr(10),'') as s_info_code
,replace(replace(t1.s_info_name,chr(13),''),chr(10),'') as s_info_name
,replace(replace(t1.s_info_pinyin,chr(13),''),chr(10),'') as s_info_pinyin
,replace(replace(t1.s_info_exchmarket,chr(13),''),chr(10),'') as s_info_exchmarket
,replace(replace(t1.s_info_listboard,chr(13),''),chr(10),'') as s_info_listboard
,replace(replace(t1.s_info_listdate,chr(13),''),chr(10),'') as s_info_listdate
,replace(replace(t1.s_info_delistdate,chr(13),''),chr(10),'') as s_info_delistdate
,opdate
,replace(replace(t1.opmode,chr(13),''),chr(10),'') as opmode

from ${iol_schema}.wind_neeqsdescription t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_neeqsdescription.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
