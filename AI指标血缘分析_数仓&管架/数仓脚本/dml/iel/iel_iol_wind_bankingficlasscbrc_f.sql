: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_bankingficlasscbrc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_bankingficlasscbrc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id 
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode 
,replace(replace(t1.s_info_compname,chr(13),''),chr(10),'') as s_info_compname 
,replace(replace(t1.s_info_typecode,chr(13),''),chr(10),'') as s_info_typecode 
,replace(replace(t1.entry_dt,chr(13),''),chr(10),'') as entry_dt 
,replace(replace(t1.remove_dt,chr(13),''),chr(10),'') as remove_dt 
,replace(replace(t1.cur_sign,chr(13),''),chr(10),'') as cur_sign 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.wind_bankingficlasscbrc t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_bankingficlasscbrc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes