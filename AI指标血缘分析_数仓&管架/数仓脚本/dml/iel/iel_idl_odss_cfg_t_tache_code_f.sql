: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_cfg_t_tache_code_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_cfg_t_tache_code_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,tache_code
,tache_name
,tache_timeout
,is_element_flag
,is_auto_flag
,role_id
,tache_group_id
,service_name
,is_stat
from ${idl_schema}.odss_cfg_t_tache_code
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_cfg_t_tache_code_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes