: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_smg_t_post_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_smg_t_post_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,post_name
,post_describe
,state
,post_code
,post_type
,post_safe_mode
,post_mng_type
from ${idl_schema}.odss_smg_t_post
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_smg_t_post_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes