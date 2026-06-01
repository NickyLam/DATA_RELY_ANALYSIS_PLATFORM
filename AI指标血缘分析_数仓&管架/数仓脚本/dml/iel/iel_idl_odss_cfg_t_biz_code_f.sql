: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_cfg_t_biz_code_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_cfg_t_biz_code_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,biz_code
,biz_name
,eft_date
,biz_property
,is_auto_priority
,pre_setup_point
,pre_setup_priority
,time_len
,timeout_priority
,time_limit
,timelimit_priority
,kind_code
from ${idl_schema}.odss_cfg_t_biz_code
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_cfg_t_biz_code_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes