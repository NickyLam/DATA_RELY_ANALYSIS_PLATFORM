: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_collztn_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_collztn_contract_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,batch_type
,cont_type
,contract_id
,collztn_no
,collztn_type
,status
,customer_id
,bail_account
,draft_attr
,draft_type
,txn_date
,credit_custid
,other_account
,counter_no
,account_no
,sub_cont_start_date
,sub_cont_end_date
,draft_sum
,account_draft_sum
,uncollztn_draft_sum
,sub_cont_date
,collztn_account_flag
,collztn_account_date
,collztn_audit_flag
,collztn_tlrcd
,collztn_branch_id
,collztn_appno
,uncollztn_date
,uncollztn_account_flag
,uncollztn_account_date
,uncollztn_audit_flag
,uncollztn_tlrcd
,uncollztn_branch_id
,uncollztn_appno
,collztn_due_flag
,manager_id
,depart_id
,misc
,last_upd_oper_id
,last_upd_time
from ${idl_schema}.odss_collztn_contract
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_collztn_contract_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes