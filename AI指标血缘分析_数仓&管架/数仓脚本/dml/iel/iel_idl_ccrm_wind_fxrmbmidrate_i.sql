: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_wind_fxrmbmidrate_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_wind_fxrmbmidrate.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,replace(replace(t1.trade_dt,chr(13),''),chr(10),'') as trade_dt
,t1.crncy_midrate as crncy_midrate
,to_date('${batch_date}','yyyymmdd') as opdate
,'' as opmode
from ${iol_schema}.wind_fxrmbmidrate t1
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_wind_fxrmbmidrate.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes