: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbassetacc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbassetacc_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
in_client_no
,ta_code
,asset_acc
,open_branch
,ta_client
,client_manager
,open_flag
,send_freq
,send_mode
,client_type
,prd_type
,status
,open_date
,reserve1
,reserve2
from ${idl_schema}.odss_tbassetacc
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbassetacc_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes