: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_cpes_quote_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_cpes_quote_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.top_branch_no,chr(13),''),chr(10),'') as top_branch_no
,replace(replace(t.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
,replace(replace(t.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t.cust_pro_no,chr(13),''),chr(10),'') as cust_pro_no
,replace(replace(t.cust_pro_name,chr(13),''),chr(10),'') as cust_pro_name
,replace(replace(t.busi_date,chr(13),''),chr(10),'') as busi_date
,replace(replace(t.quote_no,chr(13),''),chr(10),'') as quote_no
,replace(replace(t.busi_type,chr(13),''),chr(10),'') as busi_type
,replace(replace(t.inner_flag,chr(13),''),chr(10),'') as inner_flag
,replace(replace(t.is_send,chr(13),''),chr(10),'') as is_send
,replace(replace(t.quote_mode,chr(13),''),chr(10),'') as quote_mode
,replace(replace(t.deal_id,chr(13),''),chr(10),'') as deal_id
,replace(replace(t.trade_direct,chr(13),''),chr(10),'') as trade_direct
,replace(replace(t.busi_branch_no,chr(13),''),chr(10),'') as busi_branch_no
,replace(replace(t.branch_acct,chr(13),''),chr(10),'') as branch_acct
,replace(replace(t.acct_branch_no,chr(13),''),chr(10),'') as acct_branch_no
,replace(replace(t.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t.facct_no,chr(13),''),chr(10),'') as facct_no
,replace(replace(t.manager_no,chr(13),''),chr(10),'') as manager_no
,replace(replace(t.department_no,chr(13),''),chr(10),'') as department_no
,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t.cust_user_id,chr(13),''),chr(10),'') as cust_user_id
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.cust_acct,chr(13),''),chr(10),'') as cust_acct
,replace(replace(t.cust_bank_no,chr(13),''),chr(10),'') as cust_bank_no
,replace(replace(t.cust_brh_no,chr(13),''),chr(10),'') as cust_brh_no
,replace(replace(t.draft_type,chr(13),''),chr(10),'') as draft_type
,replace(replace(t.draft_attr,chr(13),''),chr(10),'') as draft_attr
,t.sum_count as sum_count
,t.sum_amount as sum_amount
,t.buy_back_amt as buy_back_amt
,t.tenor_days as tenor_days
,replace(replace(t.sub_deal_flag,chr(13),''),chr(10),'') as sub_deal_flag
,replace(replace(t.quote_valid_tm,chr(13),''),chr(10),'') as quote_valid_tm
,replace(replace(t.clear_speed,chr(13),''),chr(10),'') as clear_speed
,replace(replace(t.clear_type,chr(13),''),chr(10),'') as clear_type
,replace(replace(t.settle_time,chr(13),''),chr(10),'') as settle_time
,replace(replace(t.settle_mode,chr(13),''),chr(10),'') as settle_mode
,t.settle_amt as settle_amt
,t.due_settle_amt as due_settle_amt
,replace(replace(t.settle_date,chr(13),''),chr(10),'') as settle_date
,replace(replace(t.due_settle_date,chr(13),''),chr(10),'') as due_settle_date
,t.rate as rate
,t.due_rate as due_rate
,t.pay_interest as pay_interest
,t.due_pay_interest as due_pay_interest
,t.yield_rate as yield_rate
,replace(replace(t.select_type,chr(13),''),chr(10),'') as select_type
,replace(replace(t.package_no,chr(13),''),chr(10),'') as package_no
,replace(replace(t.check_status,chr(13),''),chr(10),'') as check_status
,replace(replace(t.credit_check_status,chr(13),''),chr(10),'') as credit_check_status
,replace(replace(t.credit_no,chr(13),''),chr(10),'') as credit_no
,replace(replace(t.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t.message_status,chr(13),''),chr(10),'') as message_status
,replace(replace(t.settle_status,chr(13),''),chr(10),'') as settle_status
,replace(replace(t.last_upd_opr,chr(13),''),chr(10),'') as last_upd_opr
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,replace(replace(t.reserver1,chr(13),''),chr(10),'') as reserver1
,replace(replace(t.reserver2,chr(13),''),chr(10),'') as reserver2
,replace(replace(t.contract_status,chr(13),''),chr(10),'') as contract_status
,replace(replace(t.modify_flag,chr(13),''),chr(10),'') as modify_flag
,replace(replace(t.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t.i9_type,chr(13),''),chr(10),'') as i9_type
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_cpes_quote_contract t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_cpes_quote_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes