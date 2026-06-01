: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_cpes_redsct_details_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_cpes_redsct_details.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.contract_id,chr(13),''),chr(10),'') as contract_id
,replace(replace(t.draft_id,chr(13),''),chr(10),'') as draft_id
,t.draft_amount as draft_amount
,replace(replace(t.maturity_date,chr(13),''),chr(10),'') as maturity_date
,replace(replace(t.real_due_date,chr(13),''),chr(10),'') as real_due_date
,t.tenor_days as tenor_days
,t.pay_interest as pay_interest
,t.settle_amt as settle_amt
,t.due_settle_amt as due_settle_amt
,replace(replace(t.credit_status,chr(13),''),chr(10),'') as credit_status
,replace(replace(t.details_status,chr(13),''),chr(10),'') as details_status
,replace(replace(t.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t.valid_flag,chr(13),''),chr(10),'') as valid_flag
,replace(replace(t.is_discount,chr(13),''),chr(10),'') as is_discount
,replace(replace(t.is_allopatric,chr(13),''),chr(10),'') as is_allopatric
,replace(replace(t.is_meet_policy,chr(13),''),chr(10),'') as is_meet_policy
,replace(replace(t.is_refuse,chr(13),''),chr(10),'') as is_refuse
,replace(replace(t.last_upd_opr,chr(13),''),chr(10),'') as last_upd_opr
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.misc,chr(13),''),chr(10),'') as misc
,replace(replace(t.reserver1,chr(13),''),chr(10),'') as reserver1
,replace(replace(t.reserver2,chr(13),''),chr(10),'') as reserver2
,replace(replace(t.process_code,chr(13),''),chr(10),'') as process_code
,replace(replace(t.process_msg,chr(13),''),chr(10),'') as process_msg
,replace(replace(t.cpes_lock_flag,chr(13),''),chr(10),'') as cpes_lock_flag
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_cpes_redsct_details t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_cpes_redsct_details.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes