: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_glms_gl_balances_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/glms_gl_balances_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(ledger_id,chr(10),''),chr(13),'') as ledger_id
,replace(replace(code_combination_id,chr(10),''),chr(13),'') as code_combination_id
,replace(replace(currency_code,chr(10),''),chr(13),'') as currency_code
,replace(replace(period_name,chr(10),''),chr(13),'') as period_name
,replace(replace(actual_flag,chr(10),''),chr(13),'') as actual_flag
,replace(replace(last_update_date,chr(10),''),chr(13),'') as last_update_date
,replace(replace(last_updated_by,chr(10),''),chr(13),'') as last_updated_by
,replace(replace(budget_version_id,chr(10),''),chr(13),'') as budget_version_id
,replace(replace(encumbrance_type_id,chr(10),''),chr(13),'') as encumbrance_type_id
,replace(replace(translated_flag,chr(10),''),chr(13),'') as translated_flag
,replace(replace(revaluation_status,chr(10),''),chr(13),'') as revaluation_status
,replace(replace(period_type,chr(10),''),chr(13),'') as period_type
,replace(replace(period_year,chr(10),''),chr(13),'') as period_year
,replace(replace(period_num,chr(10),''),chr(13),'') as period_num
,replace(replace(period_net_dr,chr(10),''),chr(13),'') as period_net_dr
,replace(replace(period_net_cr,chr(10),''),chr(13),'') as period_net_cr
,replace(replace(period_to_date_adb,chr(10),''),chr(13),'') as period_to_date_adb
,replace(replace(quarter_to_date_dr,chr(10),''),chr(13),'') as quarter_to_date_dr
,replace(replace(quarter_to_date_cr,chr(10),''),chr(13),'') as quarter_to_date_cr
,replace(replace(quarter_to_date_adb,chr(10),''),chr(13),'') as quarter_to_date_adb
,replace(replace(year_to_date_adb,chr(10),''),chr(13),'') as year_to_date_adb
,replace(replace(project_to_date_dr,chr(10),''),chr(13),'') as project_to_date_dr
,replace(replace(project_to_date_cr,chr(10),''),chr(13),'') as project_to_date_cr
,replace(replace(project_to_date_adb,chr(10),''),chr(13),'') as project_to_date_adb
,replace(replace(begin_balance_dr,chr(10),''),chr(13),'') as begin_balance_dr
,replace(replace(begin_balance_cr,chr(10),''),chr(13),'') as begin_balance_cr
,replace(replace(period_net_dr_beq,chr(10),''),chr(13),'') as period_net_dr_beq
,replace(replace(period_net_cr_beq,chr(10),''),chr(13),'') as period_net_cr_beq
,replace(replace(begin_balance_dr_beq,chr(10),''),chr(13),'') as begin_balance_dr_beq
,replace(replace(begin_balance_cr_beq,chr(10),''),chr(13),'') as begin_balance_cr_beq
,replace(replace(template_id,chr(10),''),chr(13),'') as template_id
,replace(replace(encumbrance_doc_id,chr(10),''),chr(13),'') as encumbrance_doc_id
,replace(replace(encumbrance_line_num,chr(10),''),chr(13),'') as encumbrance_line_num
,replace(replace(quarter_to_date_dr_beq,chr(10),''),chr(13),'') as quarter_to_date_dr_beq
,replace(replace(quarter_to_date_cr_beq,chr(10),''),chr(13),'') as quarter_to_date_cr_beq
,replace(replace(project_to_date_dr_beq,chr(10),''),chr(13),'') as project_to_date_dr_beq
,replace(replace(project_to_date_cr_beq,chr(10),''),chr(13),'') as project_to_date_cr_beq
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.glms_gl_balances
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/glms_gl_balances_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes