: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_accept_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_accept_contract_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,branch_id
,accept_protocol_no
,webbank_contract_id
,task_type
,draft_attr
,draft_type
,remitter_cust_id
,apply_accept_amount
,apply_remit_date
,maturity_date
,apply_reason
,first_repayment_acct
,second_repayment_acct
,credit_fee_scale
,bail_scale
,charge_scale
,trans_amount
,drawee_bank_id
,manager_id
,depart_id
,operator_id
,txn_date
,contract_status
,logic_check_status
,audit_status
,credit_check_status
,data_source_type
,misc
,appno
,last_upd_oper_id
,last_upd_time
,bankaccount
,openbank
,real_use_biness
,main_assure_type
,acct_branch_id
,accept_fee
,manage_fee
from ${idl_schema}.odss_accept_contract
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_accept_contract_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes