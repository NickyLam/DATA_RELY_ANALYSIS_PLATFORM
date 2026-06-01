: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_send_collection_batch_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_send_collection_batch_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,branch_id
,draft_attr
,draft_type
,collection_date
,ubank_id
,ems_no
,status
,sttlm_mk
,account_status
,audit_status
,appno
,operator_id
,txn_date
,last_upd_oper_id
,last_upd_time
,src_type
from ${idl_schema}.odss_send_collection_batch
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_send_collection_batch_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes