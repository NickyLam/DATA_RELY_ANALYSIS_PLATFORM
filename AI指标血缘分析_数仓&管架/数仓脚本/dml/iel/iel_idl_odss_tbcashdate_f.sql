: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbcashdate_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbcashdate_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
cash_date
,prd_code
,deal_status
,deal_date
,reserve1
from ${idl_schema}.odss_tbcashdate
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbcashdate_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes