: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbgoldcompdetail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbgoldcompdetail_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
serial_no
,bank_no
,trans_date
,trans_time
,gold_amt
,amt
,gold_bank_acc
,bank_acc
,gold_client_no
,b_gold_client_no
,gold_transfer_type
,transfer_type
,gold_curr_type
,curr_type
,status
,unequa_flag
,reserve1
,reserve2
,reserve3
from ${idl_schema}.crms_ifm_tbgoldcompdetail
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbgoldcompdetail_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes