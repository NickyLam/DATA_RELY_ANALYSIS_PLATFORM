: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_gl_ledgers_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_gl_ledgers_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(ledger_id,chr(10),''),chr(13),'') as ledger_id
,replace(replace(name,chr(10),''),chr(13),'') as name
,replace(replace(short_name,chr(10),''),chr(13),'') as short_name
,replace(replace(description,chr(10),''),chr(13),'') as description
,replace(replace(ledger_category_code,chr(10),''),chr(13),'') as ledger_category_code
,replace(replace(alc_ledger_type_code,chr(10),''),chr(13),'') as alc_ledger_type_code
,replace(replace(object_type_code,chr(10),''),chr(13),'') as object_type_code
,replace(replace(le_ledger_type_code,chr(10),''),chr(13),'') as le_ledger_type_code
,replace(replace(completion_status_code,chr(10),''),chr(13),'') as completion_status_code
,replace(replace(configuration_id,chr(10),''),chr(13),'') as configuration_id
,replace(replace(chart_of_accounts_id,chr(10),''),chr(13),'') as chart_of_accounts_id
,replace(replace(currency_code,chr(10),''),chr(13),'') as currency_code
,replace(replace(period_set_name,chr(10),''),chr(13),'') as period_set_name
,replace(replace(accounted_period_type,chr(10),''),chr(13),'') as accounted_period_type
,replace(replace(first_ledger_period_name,chr(10),''),chr(13),'') as first_ledger_period_name
,replace(replace(ret_earn_code_combination_id,chr(10),''),chr(13),'') as ret_earn_code_combination_id
,replace(replace(suspense_allowed_flag,chr(10),''),chr(13),'') as suspense_allowed_flag
,replace(replace(allow_intercompany_post_flag,chr(10),''),chr(13),'') as allow_intercompany_post_flag
,replace(replace(track_rounding_imbalance_flag,chr(10),''),chr(13),'') as track_rounding_imbalance_flag
,replace(replace(enable_average_balances_flag,chr(10),''),chr(13),'') as enable_average_balances_flag
,replace(replace(cum_trans_code_combination_id,chr(10),''),chr(13),'') as cum_trans_code_combination_id
,replace(replace(res_encumb_code_combination_id,chr(10),''),chr(13),'') as res_encumb_code_combination_id
,replace(replace(net_income_code_combination_id,chr(10),''),chr(13),'') as net_income_code_combination_id
,replace(replace(rounding_code_combination_id,chr(10),''),chr(13),'') as rounding_code_combination_id
,replace(replace(enable_budgetary_control_flag,chr(10),''),chr(13),'') as enable_budgetary_control_flag
,replace(replace(require_budget_journals_flag,chr(10),''),chr(13),'') as require_budget_journals_flag
,replace(replace(enable_je_approval_flag,chr(10),''),chr(13),'') as enable_je_approval_flag
,replace(replace(enable_automatic_tax_flag,chr(10),''),chr(13),'') as enable_automatic_tax_flag
,replace(replace(consolidation_ledger_flag,chr(10),''),chr(13),'') as consolidation_ledger_flag
,replace(replace(translate_eod_flag,chr(10),''),chr(13),'') as translate_eod_flag
,replace(replace(translate_qatd_flag,chr(10),''),chr(13),'') as translate_qatd_flag
,replace(replace(translate_yatd_flag,chr(10),''),chr(13),'') as translate_yatd_flag
,replace(replace(transaction_calendar_id,chr(10),''),chr(13),'') as transaction_calendar_id
,replace(replace(daily_translation_rate_type,chr(10),''),chr(13),'') as daily_translation_rate_type
,replace(replace(automatically_created_flag,chr(10),''),chr(13),'') as automatically_created_flag
,replace(replace(bal_seg_value_option_code,chr(10),''),chr(13),'') as bal_seg_value_option_code
,replace(replace(bal_seg_column_name,chr(10),''),chr(13),'') as bal_seg_column_name
,replace(replace(mgt_seg_value_option_code,chr(10),''),chr(13),'') as mgt_seg_value_option_code
,replace(replace(mgt_seg_column_name,chr(10),''),chr(13),'') as mgt_seg_column_name
,replace(replace(bal_seg_value_set_id,chr(10),''),chr(13),'') as bal_seg_value_set_id
,replace(replace(mgt_seg_value_set_id,chr(10),''),chr(13),'') as mgt_seg_value_set_id
,replace(replace(implicit_access_set_id,chr(10),''),chr(13),'') as implicit_access_set_id
,replace(replace(criteria_set_id,chr(10),''),chr(13),'') as criteria_set_id
,replace(replace(future_enterable_periods_limit,chr(10),''),chr(13),'') as future_enterable_periods_limit
,replace(replace(ledger_attributes,chr(10),''),chr(13),'') as ledger_attributes
,replace(replace(implicit_ledger_set_id,chr(10),''),chr(13),'') as implicit_ledger_set_id
,replace(replace(latest_opened_period_name,chr(10),''),chr(13),'') as latest_opened_period_name
,replace(replace(latest_encumbrance_year,chr(10),''),chr(13),'') as latest_encumbrance_year
,replace(replace(period_average_rate_type,chr(10),''),chr(13),'') as period_average_rate_type
,replace(replace(period_end_rate_type,chr(10),''),chr(13),'') as period_end_rate_type
,replace(replace(budget_period_avg_rate_type,chr(10),''),chr(13),'') as budget_period_avg_rate_type
,replace(replace(budget_period_end_rate_type,chr(10),''),chr(13),'') as budget_period_end_rate_type
,replace(replace(sla_accounting_method_code,chr(10),''),chr(13),'') as sla_accounting_method_code
,replace(replace(sla_accounting_method_type,chr(10),''),chr(13),'') as sla_accounting_method_type
,replace(replace(sla_description_language,chr(10),''),chr(13),'') as sla_description_language
,replace(replace(sla_entered_cur_bal_sus_ccid,chr(10),''),chr(13),'') as sla_entered_cur_bal_sus_ccid
,replace(replace(sla_sequencing_flag,chr(10),''),chr(13),'') as sla_sequencing_flag
,replace(replace(sla_bal_by_ledger_curr_flag,chr(10),''),chr(13),'') as sla_bal_by_ledger_curr_flag
,replace(replace(sla_ledger_cur_bal_sus_ccid,chr(10),''),chr(13),'') as sla_ledger_cur_bal_sus_ccid
,replace(replace(enable_secondary_track_flag,chr(10),''),chr(13),'') as enable_secondary_track_flag
,replace(replace(enable_reval_ss_track_flag,chr(10),''),chr(13),'') as enable_reval_ss_track_flag
,replace(replace(last_update_date,chr(10),''),chr(13),'') as last_update_date
,replace(replace(last_updated_by,chr(10),''),chr(13),'') as last_updated_by
,replace(replace(creation_date,chr(10),''),chr(13),'') as creation_date
,replace(replace(created_by,chr(10),''),chr(13),'') as created_by
,replace(replace(last_update_login,chr(10),''),chr(13),'') as last_update_login
,replace(replace(context,chr(10),''),chr(13),'') as context
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
,replace(replace(enable_reconciliation_flag,chr(10),''),chr(13),'') as enable_reconciliation_flag
,replace(replace(create_je_flag,chr(10),''),chr(13),'') as create_je_flag
,replace(replace(sla_ledger_cash_basis_flag,chr(10),''),chr(13),'') as sla_ledger_cash_basis_flag
,replace(replace(complete_flag,chr(10),''),chr(13),'') as complete_flag
,replace(replace(commitment_budget_flag,chr(10),''),chr(13),'') as commitment_budget_flag
,replace(replace(net_closing_bal_flag,chr(10),''),chr(13),'') as net_closing_bal_flag
,replace(replace(automate_sec_jrnl_rev_flag,chr(10),''),chr(13),'') as automate_sec_jrnl_rev_flag
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.glms_gl_ledgers
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_gl_ledgers_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes