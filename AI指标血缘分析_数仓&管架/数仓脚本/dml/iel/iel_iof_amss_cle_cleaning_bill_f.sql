: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_amss_cle_cleaning_bill_f
CreateDate: 20250508
FileName:   ${iel_data_path}/amss_cle_cleaning_bill.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,cleaning_bill_id
,replace(replace(t1.acc_task_id,chr(13),''),chr(10),'') as acc_task_id
,cleaning_serial_number
,replace(replace(t1.accept_org_id,chr(13),''),chr(10),'') as accept_org_id
,acc_date
,cleaning_date
,replace(replace(t1.serial_number,chr(13),''),chr(10),'') as serial_number
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,pay_center_id
,pay_type_id
,replace(replace(t1.contact_line,chr(13),''),chr(10),'') as contact_line
,replace(replace(t1.remit_account_code,chr(13),''),chr(10),'') as remit_account_code
,replace(replace(t1.payee_account_code,chr(13),''),chr(10),'') as payee_account_code
,replace(replace(t1.payee_bank_name,chr(13),''),chr(10),'') as payee_bank_name
,replace(replace(t1.payee_account_name,chr(13),''),chr(10),'') as payee_account_name
,export_amount
,replace(replace(t1.fee_type,chr(13),''),chr(10),'') as fee_type
,replace(replace(t1.summary,chr(13),''),chr(10),'') as summary
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.data_sign,chr(13),''),chr(10),'') as data_sign
,replace(replace(t1.return_serial_number,chr(13),''),chr(10),'') as return_serial_number
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_msg,chr(13),''),chr(10),'') as return_msg
,cleaning_type
,cleaning_status
,physics_flag
,fld_n2
,create_time
,update_time
,account_type
,api_provider
,replace(replace(t1.bank_code,chr(13),''),chr(10),'') as bank_code
,cleaning_type_detail
,private_cleaning_bill_id
,org_properties
,cleaning_error_status
,cleaning_error_time
,cleaning_export_status
,cleaning_error_check_time
,modify_chfee_flag
,cleaning_process_time
,replace(replace(t1.pay_channel_type,chr(13),''),chr(10),'') as pay_channel_type
,replace(replace(t1.fee_code,chr(13),''),chr(10),'') as fee_code
,acc_way
,replace(replace(t1.parent_org_id,chr(13),''),chr(10),'') as parent_org_id
,negative_type
,negative_status
,replace(replace(t1.branch_org_id,chr(13),''),chr(10),'') as branch_org_id
,remit_status
,pay_account_type
,replace(replace(t1.remit_contact_line,chr(13),''),chr(10),'') as remit_contact_line
,replace(replace(t1.remit_org_id,chr(13),''),chr(10),'') as remit_org_id
,replace(replace(t1.remit_org_name,chr(13),''),chr(10),'') as remit_org_name
,replace(replace(t1.remit_account_name,chr(13),''),chr(10),'') as remit_account_name
,create_user
,replace(replace(t1.create_emp,chr(13),''),chr(10),'') as create_emp
,replace(replace(t1.account_id,chr(13),''),chr(10),'') as account_id
,replace(replace(t1.bookkeeping_code,chr(13),''),chr(10),'') as bookkeeping_code
,replace(replace(t1.remit_bank_channel_id,chr(13),''),chr(10),'') as remit_bank_channel_id
,replace(replace(t1.payee_bank_channel_id,chr(13),''),chr(10),'') as payee_bank_channel_id

from ${iol_schema}.amss_cle_cleaning_bill t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_cle_cleaning_bill.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
