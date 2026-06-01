: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_sp_draft_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_sp_draft_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.settle_flag,chr(13),''),chr(10),'') as settle_flag
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.jie_fu_date,chr(13),''),chr(10),'') as jie_fu_date
,replace(replace(t.account_date,chr(13),''),chr(10),'') as account_date
,replace(replace(t.jie_fu_time,chr(13),''),chr(10),'') as jie_fu_time
,replace(replace(t.accept_flag,chr(13),''),chr(10),'') as accept_flag
,replace(replace(t.discount_flag,chr(13),''),chr(10),'') as discount_flag
,replace(replace(t.maturity_date,chr(13),''),chr(10),'') as maturity_date
,replace(replace(t.payee_account,chr(13),''),chr(10),'') as payee_account
,replace(replace(t.acceptor_bank_id,chr(13),''),chr(10),'') as acceptor_bank_id
,replace(replace(t.inner_user_name,chr(13),''),chr(10),'') as inner_user_name
,replace(replace(t.acceptor_bank_name,chr(13),''),chr(10),'') as acceptor_bank_name
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.remit_date,chr(13),''),chr(10),'') as remit_date
,replace(replace(t.payee_bank_name,chr(13),''),chr(10),'') as payee_bank_name
,replace(replace(t.account_flag,chr(13),''),chr(10),'') as account_flag
,replace(replace(t.invoice_bank_name,chr(13),''),chr(10),'') as invoice_bank_name
,replace(replace(t.dcmttp_status,chr(13),''),chr(10),'') as dcmttp_status
,t.branch_id as branch_id
,replace(replace(t.remitter_name,chr(13),''),chr(10),'') as remitter_name
,replace(replace(t.inner_user_account,chr(13),''),chr(10),'') as inner_user_account
,replace(replace(t.remitter_bank_name,chr(13),''),chr(10),'') as remitter_bank_name
,replace(replace(t.invoice_account,chr(13),''),chr(10),'') as invoice_account
,t.face_amount as face_amount
,replace(replace(t.payee_name,chr(13),''),chr(10),'') as payee_name
,replace(replace(t.invoice_bank_id,chr(13),''),chr(10),'') as invoice_bank_id
,replace(replace(t.remitter_account,chr(13),''),chr(10),'') as remitter_account
,replace(replace(t.payee_bank_id,chr(13),''),chr(10),'') as payee_bank_id
,t.id as id
,replace(replace(t.invoice_name,chr(13),''),chr(10),'') as invoice_name
,replace(replace(t.draft_number,chr(13),''),chr(10),'') as draft_number
,replace(replace(t.remitter_bank_id,chr(13),''),chr(10),'') as remitter_bank_id
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_sp_draft_info t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_sp_draft_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes