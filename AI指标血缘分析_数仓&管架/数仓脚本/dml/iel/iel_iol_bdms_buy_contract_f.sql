: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_buy_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_buy_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.branch_id as branch_id
,t.acct_branch_id as acct_branch_id
,replace(replace(t.task_type,chr(13),''),chr(10),'') as task_type
,replace(replace(t.buy_type,chr(13),''),chr(10),'') as buy_type
,replace(replace(t.buybiz_type,chr(13),''),chr(10),'') as buybiz_type
,replace(replace(t.central_bankflg,chr(13),''),chr(10),'') as central_bankflg
,replace(replace(t.buy_sig_mk,chr(13),''),chr(10),'') as buy_sig_mk
,replace(replace(t.business_no,chr(13),''),chr(10),'') as business_no
,replace(replace(t.draft_type,chr(13),''),chr(10),'') as draft_type
,replace(replace(t.draft_attr,chr(13),''),chr(10),'') as draft_attr
,t.customer_id as customer_id
,replace(replace(t.customer_custno,chr(13),''),chr(10),'') as customer_custno
,replace(replace(t.customer_name,chr(13),''),chr(10),'') as customer_name
,t.customer_bank_no as customer_bank_no
,replace(replace(t.customer_account,chr(13),''),chr(10),'') as customer_account
,t.rate as rate
,replace(replace(t.rate_type,chr(13),''),chr(10),'') as rate_type
,t.rerate as rerate
,replace(replace(t.rerate_type,chr(13),''),chr(10),'') as rerate_type
,replace(replace(t.buy_date,chr(13),''),chr(10),'') as buy_date
,replace(replace(t.sttlm_mk,chr(13),''),chr(10),'') as sttlm_mk
,replace(replace(t.postpone_type,chr(13),''),chr(10),'') as postpone_type
,replace(replace(t.two_way_date,chr(13),''),chr(10),'') as two_way_date
,replace(replace(t.buy_sell_date,chr(13),''),chr(10),'') as buy_sell_date
,replace(replace(t.buy_back_begin_date,chr(13),''),chr(10),'') as buy_back_begin_date
,replace(replace(t.buy_back_end_date,chr(13),''),chr(10),'') as buy_back_end_date
,replace(replace(t.inner_flag,chr(13),''),chr(10),'') as inner_flag
,replace(replace(t.virtual_flag,chr(13),''),chr(10),'') as virtual_flag
,t.risk_scale as risk_scale
,replace(replace(t.pay_type,chr(13),''),chr(10),'') as pay_type
,replace(replace(t.inner_cust_flag,chr(13),''),chr(10),'') as inner_cust_flag
,replace(replace(t.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t.payer_bank_name,chr(13),''),chr(10),'') as payer_bank_name
,replace(replace(t.payer_account,chr(13),''),chr(10),'') as payer_account
,t.payer_scale as payer_scale
,replace(replace(t.agent_name,chr(13),''),chr(10),'') as agent_name
,t.manager_id as manager_id
,t.depart_id as depart_id
,replace(replace(t.discount_first_flag,chr(13),''),chr(10),'') as discount_first_flag
,replace(replace(t.mend_flag,chr(13),''),chr(10),'') as mend_flag
,replace(replace(t.add_last_date,chr(13),''),chr(10),'') as add_last_date
,replace(replace(t.acturally_industy,chr(13),''),chr(10),'') as acturally_industy
,t.operator_id as operator_id
,replace(replace(t.txn_date,chr(13),''),chr(10),'') as txn_date
,replace(replace(t.logic_check_status,chr(13),''),chr(10),'') as logic_check_status
,replace(replace(t.risk_check_status,chr(13),''),chr(10),'') as risk_check_status
,replace(replace(t.credit_check_status,chr(13),''),chr(10),'') as credit_check_status
,replace(replace(t.audit_status,chr(13),''),chr(10),'') as audit_status
,replace(replace(t.calc_status,chr(13),''),chr(10),'') as calc_status
,replace(replace(t.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t.maturity_status,chr(13),''),chr(10),'') as maturity_status
,replace(replace(t.disaffirm_status,chr(13),''),chr(10),'') as disaffirm_status
,replace(replace(t.interest_status,chr(13),''),chr(10),'') as interest_status
,t.agent_rate as agent_rate
,replace(replace(t.agent_rate_type,chr(13),''),chr(10),'') as agent_rate_type
,replace(replace(t.profit_assign_status,chr(13),''),chr(10),'') as profit_assign_status
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,replace(replace(t.appno,chr(13),''),chr(10),'') as appno
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.core_account,chr(13),''),chr(10),'') as core_account
,replace(replace(t.storageflage,chr(13),''),chr(10),'') as storageflage
,replace(replace(t.oner_brid,chr(13),''),chr(10),'') as oner_brid
,replace(replace(t.main_assure_type,chr(13),''),chr(10),'') as main_assure_type
,replace(replace(t.is_zhuanrang,chr(13),''),chr(10),'') as is_zhuanrang
,replace(replace(t.is_agent_flag,chr(13),''),chr(10),'') as is_agent_flag
,replace(replace(t.is_internal_settle,chr(13),''),chr(10),'') as is_internal_settle
,replace(replace(t.internal_account,chr(13),''),chr(10),'') as internal_account
,replace(replace(t.contract_date,chr(13),''),chr(10),'') as contract_date
,t.trans_amount as trans_amount
,replace(replace(t.authstatus,chr(13),''),chr(10),'') as authstatus
,replace(replace(t.trantype,chr(13),''),chr(10),'') as trantype
,replace(replace(t.srcsysseqno,chr(13),''),chr(10),'') as srcsysseqno
,replace(replace(t.isauth,chr(13),''),chr(10),'') as isauth
,replace(replace(t.discount_flag,chr(13),''),chr(10),'') as discount_flag
,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
,t.all_credit_exp as all_credit_exp
,t.total_use_credit_exp as total_use_credit_exp
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_id,chr(13),''),chr(10),'') as cert_id
,replace(replace(t.report_url,chr(13),''),chr(10),'') as report_url
,replace(replace(t.core_enterprise,chr(13),''),chr(10),'') as core_enterprise
,replace(replace(t.core_enterprise_cmoncd,chr(13),''),chr(10),'') as core_enterprise_cmoncd
,replace(replace(t.applock,chr(13),''),chr(10),'') as applock
,replace(replace(t.credit_aggreement,chr(13),''),chr(10),'') as credit_aggreement
,t.total_sum as total_sum
,t.used_total_sum as used_total_sum
,t.freeze_total_sum as freeze_total_sum
,t.total_ck_sum as total_ck_sum
,t.used_total_ck_sum as used_total_ck_sum
,replace(replace(t.i9_type,chr(13),''),chr(10),'') as i9_type
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_buy_contract t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_buy_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes