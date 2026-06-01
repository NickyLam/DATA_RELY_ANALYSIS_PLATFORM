: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbclientseller_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbclientseller_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
in_client_no
,bank_no
,client_no
,seller_code
,open_date
,close_date
,ta_client
,status
,reserve1
,reserve2
from ${idl_schema}.odss_tbclientseller
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbclientseller_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes