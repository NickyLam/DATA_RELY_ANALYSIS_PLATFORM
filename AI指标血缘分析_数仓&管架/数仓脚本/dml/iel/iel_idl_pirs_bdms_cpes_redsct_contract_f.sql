: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_bdms_cpes_redsct_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_bdms_cpes_redsct_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t1.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t1.deal_no,chr(13),''),chr(10),'') as deal_no
,replace(replace(t1.quote_no,chr(13),''),chr(10),'') as quote_no
,replace(replace(t1.ref_apply_no,chr(13),''),chr(10),'') as ref_apply_no
,replace(replace(t1.top_branch_no,chr(13),''),chr(10),'') as top_branch_no
,replace(replace(t1.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t1.recept_brh_id,chr(13),''),chr(10),'') as recept_brh_id
,replace(replace(t1.apply_date,chr(13),''),chr(10),'') as apply_date
,replace(replace(t1.busi_type,chr(13),''),chr(10),'') as busi_type
,replace(replace(t1.trader_id,chr(13),''),chr(10),'') as trader_id
,replace(replace(t1.cfm_trader_id,chr(13),''),chr(10),'') as cfm_trader_id
,replace(replace(t1.pbc_brh_no,chr(13),''),chr(10),'') as pbc_brh_no
,replace(replace(t1.acpt_user_id,chr(13),''),chr(10),'') as acpt_user_id
,replace(replace(t1.acpt_user_name,chr(13),''),chr(10),'') as acpt_user_name
,replace(replace(t1.acpt_user_note,chr(13),''),chr(10),'') as acpt_user_note
,replace(replace(t1.complete_user_id,chr(13),''),chr(10),'') as complete_user_id
,replace(replace(t1.complete_user_name,chr(13),''),chr(10),'') as complete_user_name
,replace(replace(t1.complete_user_note,chr(13),''),chr(10),'') as complete_user_note
,replace(replace(t1.approval_user_id,chr(13),''),chr(10),'') as approval_user_id
,replace(replace(t1.approval_user_name,chr(13),''),chr(10),'') as approval_user_name
,replace(replace(t1.approval_user_note,chr(13),''),chr(10),'') as approval_user_note
,replace(replace(t1.draft_type,chr(13),''),chr(10),'') as draft_type
,replace(replace(t1.draft_attr,chr(13),''),chr(10),'') as draft_attr
,t1.sum_count as sum_count
,t1.sum_amount as sum_amount
,t1.buy_back_amt as buy_back_amt
,t1.tenor_days as tenor_days
,replace(replace(t1.clear_speed,chr(13),''),chr(10),'') as clear_speed
,replace(replace(t1.clear_type,chr(13),''),chr(10),'') as clear_type
,replace(replace(t1.settle_mode,chr(13),''),chr(10),'') as settle_mode
,t1.settle_amt as settle_amt
,t1.due_settle_amt as due_settle_amt
,replace(replace(t1.settle_date,chr(13),''),chr(10),'') as settle_date
,replace(replace(t1.due_settle_date,chr(13),''),chr(10),'') as due_settle_date
,t1.rate as rate
,t1.pay_interest as pay_interest
,replace(replace(t1.department_no,chr(13),''),chr(10),'') as department_no
,replace(replace(t1.manager_no,chr(13),''),chr(10),'') as manager_no
,replace(replace(t1.approve_result,chr(13),''),chr(10),'') as approve_result
,replace(replace(t1.contract_status,chr(13),''),chr(10),'') as contract_status
,replace(replace(t1.message_status,chr(13),''),chr(10),'') as message_status
,replace(replace(t1.settle_status,chr(13),''),chr(10),'') as settle_status
,replace(replace(t1.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t1.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t1.last_upd_opr,chr(13),''),chr(10),'') as last_upd_opr
,replace(replace(t1.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t1.misc,chr(13),''),chr(10),'') as misc
,'' as data_date
from ${iol_schema}.bdms_cpes_redsct_contract t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_bdms_cpes_redsct_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes