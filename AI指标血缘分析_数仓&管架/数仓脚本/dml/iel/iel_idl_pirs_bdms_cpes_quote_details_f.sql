: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_bdms_cpes_quote_details_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_bdms_cpes_quote_details.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.contract_id,chr(13),''),chr(10),'') as contract_id
,replace(replace(t1.draft_id,chr(13),''),chr(10),'') as draft_id
,t1.draft_amount as draft_amount
,replace(replace(t1.maturity_date,chr(13),''),chr(10),'') as maturity_date
,replace(replace(t1.real_due_date,chr(13),''),chr(10),'') as real_due_date
,t1.tenor_days as tenor_days
,t1.due_tenor_days as due_tenor_days
,t1.pay_interest as pay_interest
,t1.due_pay_interest as due_pay_interest
,t1.settle_amt as settle_amt
,t1.due_settle_amt as due_settle_amt
,replace(replace(t1.credit_status,chr(13),''),chr(10),'') as credit_status
,replace(replace(t1.details_status,chr(13),''),chr(10),'') as details_status
,replace(replace(t1.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t1.valid_flag,chr(13),''),chr(10),'') as valid_flag
,replace(replace(t1.last_upd_opr,chr(13),''),chr(10),'') as last_upd_opr
,replace(replace(t1.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t1.misc,chr(13),''),chr(10),'') as misc
,replace(replace(t1.reserver1,chr(13),''),chr(10),'') as reserver1
,replace(replace(t1.reserver2,chr(13),''),chr(10),'') as reserver2
,replace(replace(t1.cpes_lock_flag,chr(13),''),chr(10),'') as cpes_lock_flag
,'' as data_date
from ${iol_schema}.bdms_cpes_quote_details t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_bdms_cpes_quote_details.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes