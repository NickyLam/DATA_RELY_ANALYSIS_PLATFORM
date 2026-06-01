: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_hkstockhsindustriesmembers_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_hkstockhsindustriesmembers.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.hs_ind_code,chr(13),''),chr(10),'') as hs_ind_code
,replace(replace(t1.entry_dt,chr(13),''),chr(10),'') as entry_dt
,replace(replace(t1.remove_dt,chr(13),''),chr(10),'') as remove_dt
,t1.cur_sign as cur_sign
,t1.opdate as opdate
,replace(replace(t1.opmode,chr(13),''),chr(10),'') as opmode
from ${iol_schema}.wind_hkstockhsindustriesmembers t1
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_hkstockhsindustriesmembers.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes