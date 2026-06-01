: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_accept_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_accept_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.branch_id as branch_id
,replace(replace(t.accept_protocol_no,chr(13),''),chr(10),'') as accept_protocol_no
,t.webbank_contract_id as webbank_contract_id
,replace(replace(t.task_type,chr(13),''),chr(10),'') as task_type
,replace(replace(t.draft_attr,chr(13),''),chr(10),'') as draft_attr
,replace(replace(t.draft_type,chr(13),''),chr(10),'') as draft_type
,t.remitter_cust_id as remitter_cust_id
,t.apply_accept_amount as apply_accept_amount
,replace(replace(t.apply_remit_date,chr(13),''),chr(10),'') as apply_remit_date
,replace(replace(t.maturity_date,chr(13),''),chr(10),'') as maturity_date
,replace(replace(t.apply_reason,chr(13),''),chr(10),'') as apply_reason
,replace(replace(t.first_repayment_acct,chr(13),''),chr(10),'') as first_repayment_acct
,replace(replace(t.second_repayment_acct,chr(13),''),chr(10),'') as second_repayment_acct
,t.credit_fee_scale as credit_fee_scale
,t.bail_scale as bail_scale
,t.charge_scale as charge_scale
,t.trans_amount as trans_amount
,t.drawee_bank_id as drawee_bank_id
,t.manager_id as manager_id
,t.depart_id as depart_id
,t.operator_id as operator_id
,replace(replace(t.txn_date,chr(13),''),chr(10),'') as txn_date
,replace(replace(t.contract_status,chr(13),''),chr(10),'') as contract_status
,replace(replace(t.logic_check_status,chr(13),''),chr(10),'') as logic_check_status
,replace(replace(t.audit_status,chr(13),''),chr(10),'') as audit_status
,replace(replace(t.credit_check_status,chr(13),''),chr(10),'') as credit_check_status
,replace(replace(t.data_source_type,chr(13),''),chr(10),'') as data_source_type
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,replace(replace(t.appno,chr(13),''),chr(10),'') as appno
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.bankaccount,chr(13),''),chr(10),'') as bankaccount
,replace(replace(t.openbank,chr(13),''),chr(10),'') as openbank
,replace(replace(t.real_use_biness,chr(13),''),chr(10),'') as real_use_biness
,replace(replace(t.main_assure_type,chr(13),''),chr(10),'') as main_assure_type
,replace(replace(t.acct_branch_id,chr(13),''),chr(10),'') as acct_branch_id
,t.accept_fee as accept_fee
,t.manage_fee as manage_fee
,replace(replace(t.contract_date,chr(13),''),chr(10),'') as contract_date
,t.acct_amount as acct_amount
,replace(replace(t.group_name,chr(13),''),chr(10),'') as group_name
,replace(replace(t.group_no,chr(13),''),chr(10),'') as group_no
,replace(replace(t.isgroup_type,chr(13),''),chr(10),'') as isgroup_type
,replace(replace(t.group_cust_name,chr(13),''),chr(10),'') as group_cust_name
,replace(replace(t.group_cust_no,chr(13),''),chr(10),'') as group_cust_no
,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
,t.all_credit_exp as all_credit_exp
,t.total_use_credit_exp as total_use_credit_exp
,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t.cert_id,chr(13),''),chr(10),'') as cert_id
,replace(replace(t.report_url,chr(13),''),chr(10),'') as report_url
,replace(replace(t.core_enterprise,chr(13),''),chr(10),'') as core_enterprise
,replace(replace(t.core_enterprise_cmoncd,chr(13),''),chr(10),'') as core_enterprise_cmoncd
,replace(replace(t.batch_no,chr(13),''),chr(10),'') as batch_no
,t.business_exp as business_exp
,replace(replace(t.low_risk,chr(13),''),chr(10),'') as low_risk
,t.ratio_exp as ratio_exp
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_accept_contract t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_accept_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes