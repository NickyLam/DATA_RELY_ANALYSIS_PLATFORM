: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_gl_je_lines_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_gl_je_lines_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(je_header_id,chr(10),''),chr(13),'') as je_header_id
,replace(replace(je_line_num,chr(10),''),chr(13),'') as je_line_num
,replace(replace(last_update_date,chr(10),''),chr(13),'') as last_update_date
,replace(replace(last_updated_by,chr(10),''),chr(13),'') as last_updated_by
,replace(replace(ledger_id,chr(10),''),chr(13),'') as ledger_id
,replace(replace(code_combination_id,chr(10),''),chr(13),'') as code_combination_id
,replace(replace(period_name,chr(10),''),chr(13),'') as period_name
,replace(replace(effective_date,chr(10),''),chr(13),'') as effective_date
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(creation_date,chr(10),''),chr(13),'') as creation_date
,replace(replace(created_by,chr(10),''),chr(13),'') as created_by
,replace(replace(last_update_login,chr(10),''),chr(13),'') as last_update_login
,replace(replace(entered_dr,chr(10),''),chr(13),'') as entered_dr
,replace(replace(entered_cr,chr(10),''),chr(13),'') as entered_cr
,replace(replace(accounted_dr,chr(10),''),chr(13),'') as accounted_dr
,replace(replace(accounted_cr,chr(10),''),chr(13),'') as accounted_cr
,replace(replace(description,chr(10),''),chr(13),'') as description
,replace(replace(line_type_code,chr(10),''),chr(13),'') as line_type_code
,replace(replace(reference_1,chr(10),''),chr(13),'') as reference_1
,replace(replace(reference_2,chr(10),''),chr(13),'') as reference_2
,replace(replace(reference_3,chr(10),''),chr(13),'') as reference_3
,replace(replace(reference_4,chr(10),''),chr(13),'') as reference_4
,replace(replace(reference_5,chr(10),''),chr(13),'') as reference_5
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
,replace(replace(attribute11,chr(10),''),chr(13),'') as attribute11
,replace(replace(attribute12,chr(10),''),chr(13),'') as attribute12
,replace(replace(attribute13,chr(10),''),chr(13),'') as attribute13
,replace(replace(attribute14,chr(10),''),chr(13),'') as attribute14
,replace(replace(attribute15,chr(10),''),chr(13),'') as attribute15
,replace(replace(attribute16,chr(10),''),chr(13),'') as attribute16
,replace(replace(attribute17,chr(10),''),chr(13),'') as attribute17
,replace(replace(attribute18,chr(10),''),chr(13),'') as attribute18
,replace(replace(attribute19,chr(10),''),chr(13),'') as attribute19
,replace(replace(attribute20,chr(10),''),chr(13),'') as attribute20
,replace(replace(context,chr(10),''),chr(13),'') as context
,replace(replace(context2,chr(10),''),chr(13),'') as context2
,replace(replace(invoice_date,chr(10),''),chr(13),'') as invoice_date
,replace(replace(tax_code,chr(10),''),chr(13),'') as tax_code
,replace(replace(invoice_identifier,chr(10),''),chr(13),'') as invoice_identifier
,replace(replace(invoice_amount,chr(10),''),chr(13),'') as invoice_amount
,replace(replace(no1,chr(10),''),chr(13),'') as no1
,replace(replace(stat_amount,chr(10),''),chr(13),'') as stat_amount
,replace(replace(ignore_rate_flag,chr(10),''),chr(13),'') as ignore_rate_flag
,replace(replace(context3,chr(10),''),chr(13),'') as context3
,replace(replace(ussgl_transaction_code,chr(10),''),chr(13),'') as ussgl_transaction_code
,replace(replace(subledger_doc_sequence_id,chr(10),''),chr(13),'') as subledger_doc_sequence_id
,replace(replace(context4,chr(10),''),chr(13),'') as context4
,replace(replace(subledger_doc_sequence_value,chr(10),''),chr(13),'') as subledger_doc_sequence_value
,replace(replace(reference_6,chr(10),''),chr(13),'') as reference_6
,replace(replace(reference_7,chr(10),''),chr(13),'') as reference_7
,replace(replace(gl_sl_link_id,chr(10),''),chr(13),'') as gl_sl_link_id
,replace(replace(gl_sl_link_table,chr(10),''),chr(13),'') as gl_sl_link_table
,replace(replace(reference_8,chr(10),''),chr(13),'') as reference_8
,replace(replace(reference_9,chr(10),''),chr(13),'') as reference_9
,replace(replace(reference_10,chr(10),''),chr(13),'') as reference_10
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
,replace(replace(jgzz_recon_status_11i,chr(10),''),chr(13),'') as jgzz_recon_status_11i
,replace(replace(jgzz_recon_date_11i,chr(10),''),chr(13),'') as jgzz_recon_date_11i
,replace(replace(jgzz_recon_id_11i,chr(10),''),chr(13),'') as jgzz_recon_id_11i
,replace(replace(jgzz_recon_ref_11i,chr(10),''),chr(13),'') as jgzz_recon_ref_11i
,replace(replace(jgzz_recon_context_11i,chr(10),''),chr(13),'') as jgzz_recon_context_11i
,replace(replace(taxable_line_flag,chr(10),''),chr(13),'') as taxable_line_flag
,replace(replace(tax_type_code,chr(10),''),chr(13),'') as tax_type_code
,replace(replace(tax_code_id,chr(10),''),chr(13),'') as tax_code_id
,replace(replace(tax_rounding_rule_code,chr(10),''),chr(13),'') as tax_rounding_rule_code
,replace(replace(amount_includes_tax_flag,chr(10),''),chr(13),'') as amount_includes_tax_flag
,replace(replace(tax_document_identifier,chr(10),''),chr(13),'') as tax_document_identifier
,replace(replace(tax_document_date,chr(10),''),chr(13),'') as tax_document_date
,replace(replace(tax_customer_name,chr(10),''),chr(13),'') as tax_customer_name
,replace(replace(tax_customer_reference,chr(10),''),chr(13),'') as tax_customer_reference
,replace(replace(tax_registration_number,chr(10),''),chr(13),'') as tax_registration_number
,replace(replace(tax_line_flag,chr(10),''),chr(13),'') as tax_line_flag
,replace(replace(tax_group_id,chr(10),''),chr(13),'') as tax_group_id
,replace(replace(co_third_party,chr(10),''),chr(13),'') as co_third_party
,replace(replace(co_processed_flag,chr(10),''),chr(13),'') as co_processed_flag
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.glms_gl_je_lines
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_gl_je_lines_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes