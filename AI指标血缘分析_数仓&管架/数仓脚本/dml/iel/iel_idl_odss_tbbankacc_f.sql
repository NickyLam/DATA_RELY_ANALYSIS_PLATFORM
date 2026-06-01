: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbbankacc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbbankacc_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
bank_no
,bank_acc
,ta_client
,in_client_no
,client_type
,open_branch
,status
,trans_date
,signoff_date
,reserve1
,reserve2
,reserve3
from ${idl_schema}.odss_tbbankacc
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbbankacc_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes