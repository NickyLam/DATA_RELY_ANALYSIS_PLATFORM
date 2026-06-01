: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ods_a_d_cm_exrt_cvrt_dt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ods_a_d_cm_exrt_cvrt_dt_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
date_id
,curr_code
,curr_name
,cny_exrt
,usd_exrt
,usd_cvrt
from ${idl_schema}.crms_ods_a_d_cm_exrt_cvrt_dt
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ods_a_d_cm_exrt_cvrt_dt_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes