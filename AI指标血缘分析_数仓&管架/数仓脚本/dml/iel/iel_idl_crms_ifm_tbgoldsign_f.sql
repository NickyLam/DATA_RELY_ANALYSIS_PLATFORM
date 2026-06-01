: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbgoldsign_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbgoldsign_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
in_client_no
,bank_acc
,gold_client_no
,center_code
,bank_no
,client_no
,client_name
,id_type
,id_code
,curr_type
,status
,open_date
,close_date
,modify_date
,reserve1
,reserve2
from ${idl_schema}.crms_ifm_tbgoldsign
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbgoldsign_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes