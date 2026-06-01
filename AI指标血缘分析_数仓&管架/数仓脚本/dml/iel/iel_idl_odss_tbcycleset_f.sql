: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbcycleset_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbcycleset_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
prd_code
,cycle_date
,deal_status
,deal_date
,all_income
,froze_income
,all_fee
,manage_fee
,reserve1
,reserve2
,reserve3
from ${idl_schema}.odss_tbcycleset
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbcycleset_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes