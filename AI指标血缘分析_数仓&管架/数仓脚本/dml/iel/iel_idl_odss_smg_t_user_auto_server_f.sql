: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_smg_t_user_auto_server_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_smg_t_user_auto_server_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,user_code
,role_code
,br_code
,server_type
,bean_id
,center_code
,host_ip
,sleep_time
from ${idl_schema}.odss_smg_t_user_auto_server
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_smg_t_user_auto_server_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes