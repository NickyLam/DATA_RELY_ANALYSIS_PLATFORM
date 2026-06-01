: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_asharesecindustriesclass_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_asharesecindustriesclass.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t.sec_ind_code,chr(13),''),chr(10),'') as sec_ind_code
,replace(replace(t.entry_dt,chr(13),''),chr(10),'') as entry_dt
,replace(replace(t.remove_dt,chr(13),''),chr(10),'') as remove_dt
,replace(replace(t.cur_sign,chr(13),''),chr(10),'') as cur_sign
from iol.wind_asharesecindustriesclass t
where etl_dt =to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_asharesecindustriesclass.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes