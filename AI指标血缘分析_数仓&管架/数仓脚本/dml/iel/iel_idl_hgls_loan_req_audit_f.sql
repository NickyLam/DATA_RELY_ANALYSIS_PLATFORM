: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hgls_loan_req_audit_f
CreateDate: 20250619
FileName:   ${iel_data_path}/hgls_loan_req_audit.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.audit_id as audit_id
,t1.loan_id as loan_id
,t1.approver_user_id as approver_user_id
,t1.approver_user_name as approver_user_name
,t1.daily_rate as daily_rate
,t1.fnl_store as fnl_store
,t1.repayment_period as repayment_period
,t1.repayment_kind as repayment_kind
,t1.auth_money as auth_money
,t1.rank as rank
,t1.audit_status as audit_status
,t1.history_audit_status as history_audit_status
,t1.repulse_reason as repulse_reason
,t1.audit_date as audit_date
,t1.need_escort as need_escort
,t1.credit_guaranty as credit_guaranty
,t1.inquiry_way as inquiry_way
,t1.credit_company as credit_company
,t1.pledge_type as pledge_type
,t1.assess_price as assess_price
,t1.year_rate as year_rate
,t1.resolution as resolution
,t1.remark as remark
,t1.custom_capital as custom_capital
,t1.allow_one_sign as allow_one_sign
,t1.loan_proof as loan_proof
,t1.mark as mark
,t1.biz_type as biz_type
,t1.model_frequency as model_frequency

from ${idl_schema}.hgls_loan_req_audit t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hgls_loan_req_audit.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
