: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_resell_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_resell_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.branch_id as branch_id
,t.acct_branch_id as acct_branch_id
,replace(replace(t.resell_type,chr(13),''),chr(10),'') as resell_type
,replace(replace(t.business_no,chr(13),''),chr(10),'') as business_no
,replace(replace(t.central_bankflg,chr(13),''),chr(10),'') as central_bankflg
,replace(replace(t.draft_type,chr(13),''),chr(10),'') as draft_type
,replace(replace(t.draft_attr,chr(13),''),chr(10),'') as draft_attr
,replace(replace(t.customer_type,chr(13),''),chr(10),'') as customer_type
,t.customer_union_bank_no as customer_union_bank_no
,replace(replace(t.customer_brch_code,chr(13),''),chr(10),'') as customer_brch_code
,replace(replace(t.buy_back_begin_date,chr(13),''),chr(10),'') as buy_back_begin_date
,replace(replace(t.buy_back_end_date,chr(13),''),chr(10),'') as buy_back_end_date
,t.customer_id as customer_id
,replace(replace(t.come_and_go_acct,chr(13),''),chr(10),'') as come_and_go_acct
,replace(replace(t.resell_date,chr(13),''),chr(10),'') as resell_date
,replace(replace(t.repurchase_date,chr(13),''),chr(10),'') as repurchase_date
,t.resell_rate as resell_rate
,replace(replace(t.resell_rate_type,chr(13),''),chr(10),'') as resell_rate_type
,t.buy_back_rate as buy_back_rate
,replace(replace(t.rate_calculate_type,chr(13),''),chr(10),'') as rate_calculate_type
,replace(replace(t.imitate_sell_flag,chr(13),''),chr(10),'') as imitate_sell_flag
,replace(replace(t.inner_flag,chr(13),''),chr(10),'') as inner_flag
,replace(replace(t.two_way_flag,chr(13),''),chr(10),'') as two_way_flag
,replace(replace(t.two_way_date,chr(13),''),chr(10),'') as two_way_date
,replace(replace(t.sttlm_mk,chr(13),''),chr(10),'') as sttlm_mk
,t.operator_id as operator_id
,replace(replace(t.txn_date,chr(13),''),chr(10),'') as txn_date
,t.manager_id as manager_id
,t.depart_id as depart_id
,replace(replace(t.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t.audit_status,chr(13),''),chr(10),'') as audit_status
,replace(replace(t.maturity_status,chr(13),''),chr(10),'') as maturity_status
,replace(replace(t.calc_status,chr(13),''),chr(10),'') as calc_status
,replace(replace(t.logic_check_status,chr(13),''),chr(10),'') as logic_check_status
,replace(replace(t.rate_audit,chr(13),''),chr(10),'') as rate_audit
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,replace(replace(t.appno,chr(13),''),chr(10),'') as appno
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.customer_account,chr(13),''),chr(10),'') as customer_account
,replace(replace(t.core_account,chr(13),''),chr(10),'') as core_account
,replace(replace(t.repurchase_flag,chr(13),''),chr(10),'') as repurchase_flag
,replace(replace(t.applock,chr(13),''),chr(10),'') as applock
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_resell_contract t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_resell_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes