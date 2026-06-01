: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_gl_je_batches_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_gl_je_batches_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(je_batch_id,chr(10),''),chr(13),'') as je_batch_id
,replace(replace(last_update_date,chr(10),''),chr(13),'') as last_update_date
,replace(replace(last_updated_by,chr(10),''),chr(13),'') as last_updated_by
,replace(replace(set_of_books_id_11i,chr(10),''),chr(13),'') as set_of_books_id_11i
,replace(replace(name,chr(10),''),chr(13),'') as name
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(status_verified,chr(10),''),chr(13),'') as status_verified
,replace(replace(actual_flag,chr(10),''),chr(13),'') as actual_flag
,replace(replace(default_effective_date,chr(10),''),chr(13),'') as default_effective_date
,replace(replace(average_journal_flag,chr(10),''),chr(13),'') as average_journal_flag
,replace(replace(budgetary_control_status,chr(10),''),chr(13),'') as budgetary_control_status
,replace(replace(approval_status_code,chr(10),''),chr(13),'') as approval_status_code
,replace(replace(creation_date,chr(10),''),chr(13),'') as creation_date
,replace(replace(created_by,chr(10),''),chr(13),'') as created_by
,replace(replace(last_update_login,chr(10),''),chr(13),'') as last_update_login
,replace(replace(status_reset_flag,chr(10),''),chr(13),'') as status_reset_flag
,replace(replace(default_period_name,chr(10),''),chr(13),'') as default_period_name
,replace(replace(unique_date,chr(10),''),chr(13),'') as unique_date
,replace(replace(earliest_postable_date,chr(10),''),chr(13),'') as earliest_postable_date
,replace(replace(posted_date,chr(10),''),chr(13),'') as posted_date
,replace(replace(date_created,chr(10),''),chr(13),'') as date_created
,replace(replace(description,chr(10),''),chr(13),'') as description
,replace(replace(control_total,chr(10),''),chr(13),'') as control_total
,replace(replace(running_total_dr,chr(10),''),chr(13),'') as running_total_dr
,replace(replace(running_total_cr,chr(10),''),chr(13),'') as running_total_cr
,replace(replace(running_total_accounted_dr,chr(10),''),chr(13),'') as running_total_accounted_dr
,replace(replace(running_total_accounted_cr,chr(10),''),chr(13),'') as running_total_accounted_cr
,replace(replace(parent_je_batch_id,chr(10),''),chr(13),'') as parent_je_batch_id
,replace(replace(attribute1,chr(10),''),chr(13),'') as attribute1
,replace(replace(attribute2,chr(10),''),chr(13),'') as attribute2
,replace(replace(attribute3,chr(10),''),chr(13),'') as attribute3
,replace(replace(attribute4,chr(10),''),chr(13),'') as attribute4
,replace(replace(attribute5,chr(10),''),chr(13),'') as attribute5
,replace(replace(attribute6,chr(10),''),chr(13),'') as attribute6
,replace(replace(attribute7,chr(10),''),chr(13),'') as attribute7
,replace(replace(attribute8,chr(10),''),chr(13),'') as attribute8
,replace(replace(attribute9,chr(10),''),chr(13),'') as attribute9
,replace(replace(attribute10,chr(10),''),chr(13),'') as attribute10
,replace(replace(context,chr(10),''),chr(13),'') as context
,replace(replace(unreservation_packet_id,chr(10),''),chr(13),'') as unreservation_packet_id
,replace(replace(packet_id,chr(10),''),chr(13),'') as packet_id
,replace(replace(ussgl_transaction_code,chr(10),''),chr(13),'') as ussgl_transaction_code
,replace(replace(context2,chr(10),''),chr(13),'') as context2
,replace(replace(posting_run_id,chr(10),''),chr(13),'') as posting_run_id
,replace(replace(request_id,chr(10),''),chr(13),'') as request_id
,replace(replace(org_id,chr(10),''),chr(13),'') as org_id
,replace(replace(posted_by,chr(10),''),chr(13),'') as posted_by
,replace(replace(chart_of_accounts_id,chr(10),''),chr(13),'') as chart_of_accounts_id
,replace(replace(period_set_name,chr(10),''),chr(13),'') as period_set_name
,replace(replace(accounted_period_type,chr(10),''),chr(13),'') as accounted_period_type
,replace(replace(group_id,chr(10),''),chr(13),'') as group_id
,replace(replace(approver_employee_id,chr(10),''),chr(13),'') as approver_employee_id
,replace(replace(global_attribute_category,chr(10),''),chr(13),'') as global_attribute_category
,replace(replace(global_attribute1,chr(10),''),chr(13),'') as global_attribute1
,replace(replace(global_attribute2,chr(10),''),chr(13),'') as global_attribute2
,replace(replace(global_attribute3,chr(10),''),chr(13),'') as global_attribute3
,replace(replace(global_attribute4,chr(10),''),chr(13),'') as global_attribute4
,replace(replace(global_attribute5,chr(10),''),chr(13),'') as global_attribute5
,replace(replace(global_attribute6,chr(10),''),chr(13),'') as global_attribute6
,replace(replace(global_attribute7,chr(10),''),chr(13),'') as global_attribute7
,replace(replace(global_attribute8,chr(10),''),chr(13),'') as global_attribute8
,replace(replace(global_attribute9,chr(10),''),chr(13),'') as global_attribute9
,replace(replace(global_attribute10,chr(10),''),chr(13),'') as global_attribute10
,replace(replace(global_attribute11,chr(10),''),chr(13),'') as global_attribute11
,replace(replace(global_attribute12,chr(10),''),chr(13),'') as global_attribute12
,replace(replace(global_attribute13,chr(10),''),chr(13),'') as global_attribute13
,replace(replace(global_attribute14,chr(10),''),chr(13),'') as global_attribute14
,replace(replace(global_attribute15,chr(10),''),chr(13),'') as global_attribute15
,replace(replace(global_attribute16,chr(10),''),chr(13),'') as global_attribute16
,replace(replace(global_attribute17,chr(10),''),chr(13),'') as global_attribute17
,replace(replace(global_attribute18,chr(10),''),chr(13),'') as global_attribute18
,replace(replace(global_attribute19,chr(10),''),chr(13),'') as global_attribute19
,replace(replace(global_attribute20,chr(10),''),chr(13),'') as global_attribute20
,start_dt
,end_dt
,id_mark
,etl_timestamp 
from iol.glms_gl_je_batches where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_gl_je_batches_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes