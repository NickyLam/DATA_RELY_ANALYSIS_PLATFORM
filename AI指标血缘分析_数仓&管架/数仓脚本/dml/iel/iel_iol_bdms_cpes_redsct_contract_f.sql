: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_cpes_redsct_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_cpes_redsct_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.contract_no,chr(13),''),chr(10),'') as contract_no
,replace(replace(t.product_no,chr(13),''),chr(10),'') as product_no
,replace(replace(t.deal_no,chr(13),''),chr(10),'') as deal_no
,replace(replace(t.quote_no,chr(13),''),chr(10),'') as quote_no
,replace(replace(t.ref_apply_no,chr(13),''),chr(10),'') as ref_apply_no
,replace(replace(t.top_branch_no,chr(13),''),chr(10),'') as top_branch_no
,replace(replace(t.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t.recept_brh_id,chr(13),''),chr(10),'') as recept_brh_id
,replace(replace(t.apply_date,chr(13),''),chr(10),'') as apply_date
,replace(replace(t.busi_type,chr(13),''),chr(10),'') as busi_type
,replace(replace(t.trader_id,chr(13),''),chr(10),'') as trader_id
,replace(replace(t.cfm_trader_id,chr(13),''),chr(10),'') as cfm_trader_id
,replace(replace(t.pbc_brh_no,chr(13),''),chr(10),'') as pbc_brh_no
,replace(replace(t.acpt_user_id,chr(13),''),chr(10),'') as acpt_user_id
,replace(replace(t.acpt_user_name,chr(13),''),chr(10),'') as acpt_user_name
,replace(replace(t.acpt_user_note,chr(13),''),chr(10),'') as acpt_user_note
,replace(replace(t.complete_user_id,chr(13),''),chr(10),'') as complete_user_id
,replace(replace(t.complete_user_name,chr(13),''),chr(10),'') as complete_user_name
,replace(replace(t.complete_user_note,chr(13),''),chr(10),'') as complete_user_note
,replace(replace(t.approval_user_id,chr(13),''),chr(10),'') as approval_user_id
,replace(replace(t.approval_user_name,chr(13),''),chr(10),'') as approval_user_name
,replace(replace(t.approval_user_note,chr(13),''),chr(10),'') as approval_user_note
,replace(replace(t.draft_type,chr(13),''),chr(10),'') as draft_type
,replace(replace(t.draft_attr,chr(13),''),chr(10),'') as draft_attr
,t.sum_count as sum_count
,t.sum_amount as sum_amount
,t.buy_back_amt as buy_back_amt
,t.tenor_days as tenor_days
,replace(replace(t.clear_speed,chr(13),''),chr(10),'') as clear_speed
,replace(replace(t.clear_type,chr(13),''),chr(10),'') as clear_type
,replace(replace(t.settle_mode,chr(13),''),chr(10),'') as settle_mode
,t.settle_amt as settle_amt
,t.due_settle_amt as due_settle_amt
,replace(replace(t.settle_date,chr(13),''),chr(10),'') as settle_date
,replace(replace(t.due_settle_date,chr(13),''),chr(10),'') as due_settle_date
,t.rate as rate
,t.pay_interest as pay_interest
,replace(replace(t.department_no,chr(13),''),chr(10),'') as department_no
,replace(replace(t.manager_no,chr(13),''),chr(10),'') as manager_no
,replace(replace(t.approve_result,chr(13),''),chr(10),'') as approve_result
,replace(replace(t.contract_status,chr(13),''),chr(10),'') as contract_status
,replace(replace(t.message_status,chr(13),''),chr(10),'') as message_status
,replace(replace(t.settle_status,chr(13),''),chr(10),'') as settle_status
,replace(replace(t.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t.created_by,chr(13),''),chr(10),'') as created_by
,replace(replace(t.last_upd_opr,chr(13),''),chr(10),'') as last_upd_opr
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_cpes_redsct_contract t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_cpes_redsct_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes