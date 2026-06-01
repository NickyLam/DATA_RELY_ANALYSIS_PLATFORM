: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_asharepledgeproportion_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_asharepledgeproportion.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
    ,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
    ,replace(replace(t.s_enddate,chr(13),''),chr(10),'') as s_enddate
    ,t.s_pledge_num as s_pledge_num
    ,t.s_share_unrestricted_num as s_share_unrestricted_num
    ,t.s_share_restricted_num as s_share_restricted_num
    ,t.s_tot_shr as s_tot_shr
    ,t.s_pledge_ratio as s_pledge_ratio
from iol.wind_asharepledgeproportion t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_asharepledgeproportion.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes