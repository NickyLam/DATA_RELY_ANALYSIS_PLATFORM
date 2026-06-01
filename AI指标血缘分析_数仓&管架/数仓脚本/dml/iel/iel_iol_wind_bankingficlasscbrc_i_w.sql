: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_bankingficlasscbrc_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_bankingficlasscbrc_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(s_info_compcode,chr(10),''),chr(13),'') as s_info_compcode
,replace(replace(s_info_compname,chr(10),''),chr(13),'') as s_info_compname
,replace(replace(s_info_typecode,chr(10),''),chr(13),'') as s_info_typecode
,replace(replace(entry_dt,chr(10),''),chr(13),'') as entry_dt
,replace(replace(remove_dt,chr(10),''),chr(13),'') as remove_dt
,replace(replace(cur_sign,chr(10),''),chr(13),'') as cur_sign
,start_dt
,end_dt
,id_mark
,etl_timestamp
from  ${iol_schema}.wind_bankingficlasscbrc
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_bankingficlasscbrc_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes