: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_credit_deal_log_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_credit_deal_log_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,branch_id
,credit_id
,credit_real_id
,txn_dt
,txn_time
,txn_type
,busi_type
,txn_amt
,txn_status
,contract_id
,draft_id
,draft_no
,detail_id
,orig_id
,last_upd_oper_id
,last_upd_time
from ${idl_schema}.odss_credit_deal_log
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_credit_deal_log_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes