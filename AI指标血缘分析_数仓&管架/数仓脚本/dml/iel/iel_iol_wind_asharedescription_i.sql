: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_asharedescription_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_asharedescription.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t.s_info_code,chr(13),''),chr(10),'') as s_info_code
,replace(replace(t.s_info_name,chr(13),''),chr(10),'') as s_info_name
,replace(replace(t.s_info_compname,chr(13),''),chr(10),'') as s_info_compname
,replace(replace(t.s_info_compnameeng,chr(13),''),chr(10),'') as s_info_compnameeng
,replace(replace(t.s_info_isincode,chr(13),''),chr(10),'') as s_info_isincode
,replace(replace(t.s_info_exchmarket,chr(13),''),chr(10),'') as s_info_exchmarket
,replace(replace(t.s_info_listboard,chr(13),''),chr(10),'') as s_info_listboard
,replace(replace(t.s_info_listdate,chr(13),''),chr(10),'') as s_info_listdate
,replace(replace(t.s_info_delistdate,chr(13),''),chr(10),'') as s_info_delistdate
,replace(replace(t.s_info_sedolcode,chr(13),''),chr(10),'') as s_info_sedolcode
,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
,replace(replace(t.s_info_pinyin,chr(13),''),chr(10),'') as s_info_pinyin
,replace(replace(t.s_info_listboardname,chr(13),''),chr(10),'') as s_info_listboardname
,t.is_shsc as is_shsc
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.wind_asharedescription t
where start_dt =to_date('${batch_date}','yyyymmdd') ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_asharedescription.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes