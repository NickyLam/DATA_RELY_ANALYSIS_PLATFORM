: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_report_of_loss_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_report_of_loss_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,branch_id
,draft_id
,report_of_loss_reason
,report_of_loss_date
,report_of_loss_person
,operator_id
,txn_date
,unloss_reason
,unloss_date
,unloss_operator_id
,status
,last_upd_oper_id
,last_upd_time
from ${idl_schema}.odss_report_of_loss
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_report_of_loss_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes