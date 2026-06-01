: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_lmis_hae_journal_entry_f
CreateDate: 20250605
FileName:   ${iel_data_path}/lmis_hae_journal_entry.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,replace(replace(t1.source_flag,chr(13),''),chr(10),'') as source_flag
,replace(replace(t1.target_flag,chr(13),''),chr(10),'') as target_flag
,replace(replace(t1.error_message,chr(13),''),chr(10),'') as error_message
,replace(replace(t1.ledger_code,chr(13),''),chr(10),'') as ledger_code
,replace(replace(t1.company_code,chr(13),''),chr(10),'') as company_code
,replace(replace(t1.department_code,chr(13),''),chr(10),'') as department_code
,replace(replace(t1.period_name,chr(13),''),chr(10),'') as period_name
,replace(replace(t1.accounting_date,chr(13),''),chr(10),'') as accounting_date
,replace(replace(t1.account_code,chr(13),''),chr(10),'') as account_code
,replace(replace(t1.account_detail,chr(13),''),chr(10),'') as account_detail
,replace(replace(t1.currency_code,chr(13),''),chr(10),'') as currency_code
,replace(replace(t1.exchange_type,chr(13),''),chr(10),'') as exchange_type
,replace(replace(t1.exchange_date,chr(13),''),chr(10),'') as exchange_date
,replace(replace(t1.exchange_rate,chr(13),''),chr(10),'') as exchange_rate
,entered_amount_dr
,entered_amount_cr
,functional_amount_dr
,functional_amount_cr
,replace(replace(t1.cashflow_category,chr(13),''),chr(10),'') as cashflow_category
,replace(replace(t1.cashflow_direction,chr(13),''),chr(10),'') as cashflow_direction
,replace(replace(t1.dimension1,chr(13),''),chr(10),'') as dimension1
,replace(replace(t1.dimension2,chr(13),''),chr(10),'') as dimension2
,replace(replace(t1.dimension3,chr(13),''),chr(10),'') as dimension3
,replace(replace(t1.dimension4,chr(13),''),chr(10),'') as dimension4
,replace(replace(t1.dimension5,chr(13),''),chr(10),'') as dimension5
,replace(replace(t1.dimension6,chr(13),''),chr(10),'') as dimension6
,replace(replace(t1.dimension7,chr(13),''),chr(10),'') as dimension7
,replace(replace(t1.dimension8,chr(13),''),chr(10),'') as dimension8
,replace(replace(t1.dimension9,chr(13),''),chr(10),'') as dimension9
,replace(replace(t1.dimension10,chr(13),''),chr(10),'') as dimension10
,replace(replace(t1.dimension11,chr(13),''),chr(10),'') as dimension11
,replace(replace(t1.dimension12,chr(13),''),chr(10),'') as dimension12
,replace(replace(t1.dimension13,chr(13),''),chr(10),'') as dimension13
,replace(replace(t1.dimension14,chr(13),''),chr(10),'') as dimension14
,replace(replace(t1.dimension15,chr(13),''),chr(10),'') as dimension15
,replace(replace(t1.journal_number,chr(13),''),chr(10),'') as journal_number
,subtype_id
,event_id
,replace(replace(t1.transaction_type,chr(13),''),chr(10),'') as transaction_type
,transaction_ins_id
,replace(replace(t1.transaction_number,chr(13),''),chr(10),'') as transaction_number
,replace(replace(t1.transaction_line_type,chr(13),''),chr(10),'') as transaction_line_type
,transaction_line_id
,replace(replace(t1.attribute1,chr(13),''),chr(10),'') as attribute1
,replace(replace(t1.attribute2,chr(13),''),chr(10),'') as attribute2
,replace(replace(t1.attribute3,chr(13),''),chr(10),'') as attribute3
,replace(replace(t1.attribute4,chr(13),''),chr(10),'') as attribute4
,replace(replace(t1.attribute5,chr(13),''),chr(10),'') as attribute5
,created_date
,created_by
,last_updated_date
,last_updated_by
,version_number
,replace(replace(t1.dimension16,chr(13),''),chr(10),'') as dimension16
,replace(replace(t1.dimension17,chr(13),''),chr(10),'') as dimension17
,replace(replace(t1.dimension18,chr(13),''),chr(10),'') as dimension18
,replace(replace(t1.dimension19,chr(13),''),chr(10),'') as dimension19
,replace(replace(t1.dimension20,chr(13),''),chr(10),'') as dimension20
,replace(replace(t1.dimension21,chr(13),''),chr(10),'') as dimension21
,replace(replace(t1.dimension22,chr(13),''),chr(10),'') as dimension22
,replace(replace(t1.dimension23,chr(13),''),chr(10),'') as dimension23
,replace(replace(t1.dimension24,chr(13),''),chr(10),'') as dimension24
,replace(replace(t1.dimension25,chr(13),''),chr(10),'') as dimension25
,replace(replace(t1.dimension26,chr(13),''),chr(10),'') as dimension26
,replace(replace(t1.dimension27,chr(13),''),chr(10),'') as dimension27
,replace(replace(t1.dimension28,chr(13),''),chr(10),'') as dimension28
,replace(replace(t1.dimension29,chr(13),''),chr(10),'') as dimension29
,replace(replace(t1.dimension30,chr(13),''),chr(10),'') as dimension30
,tenant_id
,replace(replace(t1.batch_number,chr(13),''),chr(10),'') as batch_number

from ${iol_schema}.lmis_hae_journal_entry t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/lmis_hae_journal_entry.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
