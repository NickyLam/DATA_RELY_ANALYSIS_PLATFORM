: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_asharesecindustriesclass_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_asharesecindustriesclass.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.sec_ind_code,chr(13),''),chr(10),'') as sec_ind_code
,replace(replace(t1.entry_dt,chr(13),''),chr(10),'') as entry_dt
,replace(replace(t1.remove_dt,chr(13),''),chr(10),'') as remove_dt
,replace(replace(t1.cur_sign,chr(13),''),chr(10),'') as cur_sign
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_asharesecindustriesclass t1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_asharesecindustriesclass.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes