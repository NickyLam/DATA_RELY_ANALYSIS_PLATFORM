: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_gl_je_headers_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_gl_je_headers_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(je_header_id,chr(10),''),chr(13),'') as je_header_id
,replace(replace(last_update_date,chr(10),''),chr(13),'') as last_update_date
,replace(replace(last_updated_by,chr(10),''),chr(13),'') as last_updated_by
,replace(replace(ledger_id,chr(10),''),chr(13),'') as ledger_id
,replace(replace(je_category,chr(10),''),chr(13),'') as je_category
,replace(replace(je_source,chr(10),''),chr(13),'') as je_source
,replace(replace(period_name,chr(10),''),chr(13),'') as period_name
,replace(replace(name,chr(10),''),chr(13),'') as name
,replace(replace(currency_code,chr(10),''),chr(13),'') as currency_code
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(date_created,chr(10),''),chr(13),'') as date_created
,replace(replace(accrual_rev_flag,chr(10),''),chr(13),'') as accrual_rev_flag
,replace(replace(multi_bal_seg_flag,chr(10),''),chr(13),'') as multi_bal_seg_flag
,replace(replace(actual_flag,chr(10),''),chr(13),'') as actual_flag
,replace(replace(default_effective_date,chr(10),''),chr(13),'') as default_effective_date
,replace(replace(tax_status_code,chr(10),''),chr(13),'') as tax_status_code
,replace(replace(conversion_flag,chr(10),''),chr(13),'') as conversion_flag
,replace(replace(creation_date,chr(10),''),chr(13),'') as creation_date
,replace(replace(created_by,chr(10),''),chr(13),'') as created_by
,replace(replace(last_update_login,chr(10),''),chr(13),'') as last_update_login
,replace(replace(encumbrance_type_id,chr(10),''),chr(13),'') as encumbrance_type_id
,replace(replace(budget_version_id,chr(10),''),chr(13),'') as budget_version_id
,replace(replace(balanced_je_flag,chr(10),''),chr(13),'') as balanced_je_flag
,replace(replace(balancing_segment_value,chr(10),''),chr(13),'') as balancing_segment_value
,replace(replace(je_batch_id,chr(10),''),chr(13),'') as je_batch_id
,replace(replace(from_recurring_header_id,chr(10),''),chr(13),'') as from_recurring_header_id
,replace(replace(unique_date,chr(10),''),chr(13),'') as unique_date
,replace(replace(earliest_postable_date,chr(10),''),chr(13),'') as earliest_postable_date
,replace(replace(posted_date,chr(10),''),chr(13),'') as posted_date
,replace(replace(accrual_rev_effective_date,chr(10),''),chr(13),'') as accrual_rev_effective_date
,replace(replace(accrual_rev_period_name,chr(10),''),chr(13),'') as accrual_rev_period_name
,replace(replace(accrual_rev_status,chr(10),''),chr(13),'') as accrual_rev_status
,replace(replace(accrual_rev_je_header_id,chr(10),''),chr(13),'') as accrual_rev_je_header_id
,replace(replace(accrual_rev_change_sign_flag,chr(10),''),chr(13),'') as accrual_rev_change_sign_flag
,replace(replace(description,chr(10),''),chr(13),'') as description
,replace(replace(control_total,chr(10),''),chr(13),'') as control_total
,replace(replace(running_total_dr,chr(10),''),chr(13),'') as running_total_dr
,replace(replace(running_total_cr,chr(10),''),chr(13),'') as running_total_cr
,replace(replace(running_total_accounted_dr,chr(10),''),chr(13),'') as running_total_accounted_dr
,replace(replace(running_total_accounted_cr,chr(10),''),chr(13),'') as running_total_accounted_cr
,replace(replace(currency_conversion_rate,chr(10),''),chr(13),'') as currency_conversion_rate
,replace(replace(currency_conversion_type,chr(10),''),chr(13),'') as currency_conversion_type
,replace(replace(currency_conversion_date,chr(10),''),chr(13),'') as currency_conversion_date
,replace(replace(external_reference,chr(10),''),chr(13),'') as external_reference
,replace(replace(parent_je_header_id,chr(10),''),chr(13),'') as parent_je_header_id
,replace(replace(reversed_je_header_id,chr(10),''),chr(13),'') as reversed_je_header_id
,replace(replace(originating_bal_seg_value,chr(10),''),chr(13),'') as originating_bal_seg_value
,replace(replace(intercompany_mode,chr(10),''),chr(13),'') as intercompany_mode
,replace(replace(dr_bal_seg_value,chr(10),''),chr(13),'') as dr_bal_seg_value
,replace(replace(cr_bal_seg_value,chr(10),''),chr(13),'') as cr_bal_seg_value
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
,replace(replace(ussgl_transaction_code,chr(10),''),chr(13),'') as ussgl_transaction_code
,replace(replace(context2,chr(10),''),chr(13),'') as context2
,replace(replace(doc_sequence_id,chr(10),''),chr(13),'') as doc_sequence_id
,replace(replace(doc_sequence_value,chr(10),''),chr(13),'') as doc_sequence_value
,replace(replace(jgzz_recon_context,chr(10),''),chr(13),'') as jgzz_recon_context
,replace(replace(jgzz_recon_ref,chr(10),''),chr(13),'') as jgzz_recon_ref
,replace(replace(reference_date,chr(10),''),chr(13),'') as reference_date
,replace(replace(local_doc_sequence_id,chr(10),''),chr(13),'') as local_doc_sequence_id
,replace(replace(local_doc_sequence_value,chr(10),''),chr(13),'') as local_doc_sequence_value
,replace(replace(display_alc_journal_flag,chr(10),''),chr(13),'') as display_alc_journal_flag
,replace(replace(je_from_sla_flag,chr(10),''),chr(13),'') as je_from_sla_flag
,replace(replace(posting_acct_seq_version_id,chr(10),''),chr(13),'') as posting_acct_seq_version_id
,replace(replace(posting_acct_seq_assign_id,chr(10),''),chr(13),'') as posting_acct_seq_assign_id
,replace(replace(posting_acct_seq_value,chr(10),''),chr(13),'') as posting_acct_seq_value
,replace(replace(close_acct_seq_version_id,chr(10),''),chr(13),'') as close_acct_seq_version_id
,replace(replace(close_acct_seq_assign_id,chr(10),''),chr(13),'') as close_acct_seq_assign_id
,replace(replace(close_acct_seq_value,chr(10),''),chr(13),'') as close_acct_seq_value
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.glms_gl_je_headers
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_gl_je_headers_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes