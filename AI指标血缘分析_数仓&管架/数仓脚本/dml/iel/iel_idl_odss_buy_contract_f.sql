: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_buy_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_buy_contract_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,branch_id
,acct_branch_id
,task_type
,buy_type
,buybiz_type
,central_bankflg
,buy_sig_mk
,business_no
,draft_type
,draft_attr
,customer_id
,customer_custno
,customer_name
,customer_bank_no
,customer_account
,rate
,rate_type
,rerate
,rerate_type
,buy_date
,sttlm_mk
,postpone_type
,two_way_date
,buy_sell_date
,buy_back_begin_date
,buy_back_end_date
,inner_flag
,virtual_flag
,risk_scale
,pay_type
,inner_cust_flag
,payer_name
,payer_bank_name
,payer_account
,payer_scale
,agent_name
,manager_id
,depart_id
,discount_first_flag
,mend_flag
,add_last_date
,acturally_industy
,operator_id
,txn_date
,logic_check_status
,risk_check_status
,credit_check_status
,audit_status
,calc_status
,account_status
,maturity_status
,disaffirm_status
,interest_status
,agent_rate
,agent_rate_type
,profit_assign_status
,misc
,appno
,last_upd_oper_id
,last_upd_time
,core_account
,storageflage
,oner_brid
,main_assure_type
,is_zhuanrang
,is_agent_flag
,is_internal_settle
,internal_account
from ${idl_schema}.odss_buy_contract
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_buy_contract_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes