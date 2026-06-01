: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_misc_hist_a
CreateDate: 20250514
FileName:   ${iel_data_path}/ncbs_rb_misc_hist.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.amt_type,chr(13),''),chr(10),'') as amt_type
,replace(replace(t1.business_unit,chr(13),''),chr(10),'') as business_unit
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.client_name,chr(13),''),chr(10),'') as client_name
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.doc_type,chr(13),''),chr(10),'') as doc_type
,replace(replace(t1.document_id,chr(13),''),chr(10),'') as document_id
,replace(replace(t1.document_type,chr(13),''),chr(10),'') as document_type
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.profit_center,chr(13),''),chr(10),'') as profit_center
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.tran_type,chr(13),''),chr(10),'') as tran_type
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.voucher_no,chr(13),''),chr(10),'') as voucher_no
,replace(replace(t1.bank_seq_no,chr(13),''),chr(10),'') as bank_seq_no
,replace(replace(t1.br_seq_no,chr(13),''),chr(10),'') as br_seq_no
,replace(replace(t1.cash_item,chr(13),''),chr(10),'') as cash_item
,replace(replace(t1.channel_seq_no,chr(13),''),chr(10),'') as channel_seq_no
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.conv_base,chr(13),''),chr(10),'') as conv_base
,replace(replace(t1.cr_dr_ind,chr(13),''),chr(10),'') as cr_dr_ind
,replace(replace(t1.dept_code,chr(13),''),chr(10),'') as dept_code
,replace(replace(t1.gl_posted_flag,chr(13),''),chr(10),'') as gl_posted_flag
,replace(replace(t1.main_seq_no,chr(13),''),chr(10),'') as main_seq_no
,replace(replace(t1.medium_flag,chr(13),''),chr(10),'') as medium_flag
,replace(replace(t1.medium_type,chr(13),''),chr(10),'') as medium_type
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.oth_acct_desc,chr(13),''),chr(10),'') as oth_acct_desc
,replace(replace(t1.oth_branch_regionalism_code,chr(13),''),chr(10),'') as oth_branch_regionalism_code
,replace(replace(t1.oth_real_branch_region_code,chr(13),''),chr(10),'') as oth_real_branch_region_code
,replace(replace(t1.oth_seq_no,chr(13),''),chr(10),'') as oth_seq_no
,replace(replace(t1.prefix,chr(13),''),chr(10),'') as prefix
,replace(replace(t1.primary_event_type,chr(13),''),chr(10),'') as primary_event_type
,replace(replace(t1.primary_tran_seq_no,chr(13),''),chr(10),'') as primary_tran_seq_no
,print_cnt
,replace(replace(t1.rate_type,chr(13),''),chr(10),'') as rate_type
,replace(replace(t1.rec_pay_flag,chr(13),''),chr(10),'') as rec_pay_flag
,replace(replace(t1.reversal_flag,chr(13),''),chr(10),'') as reversal_flag
,replace(replace(t1.reversal_tran_type,chr(13),''),chr(10),'') as reversal_tran_type
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.serv_charge,chr(13),''),chr(10),'') as serv_charge
,replace(replace(t1.source_module,chr(13),''),chr(10),'') as source_module
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.sub_seq_no,chr(13),''),chr(10),'') as sub_seq_no
,replace(replace(t1.system_id,chr(13),''),chr(10),'') as system_id
,replace(replace(t1.tae_sub_seq_no,chr(13),''),chr(10),'') as tae_sub_seq_no
,replace(replace(t1.terminal_id,chr(13),''),chr(10),'') as terminal_id
,replace(replace(t1.trace_id,chr(13),''),chr(10),'') as trace_id
,replace(replace(t1.tran_desc,chr(13),''),chr(10),'') as tran_desc
,replace(replace(t1.tran_hist_seq_no,chr(13),''),chr(10),'') as tran_hist_seq_no
,replace(replace(t1.tran_note,chr(13),''),chr(10),'') as tran_note
,replace(replace(t1.tran_status,chr(13),''),chr(10),'') as tran_status
,replace(replace(t1.accounting_status,chr(13),''),chr(10),'') as accounting_status
,channel_date
,effect_date
,post_date
,reversal_tran_date
,settlement_date
,tran_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,base_equiv_amt
,replace(replace(t1.contra_acct_ccy,chr(13),''),chr(10),'') as contra_acct_ccy
,contra_equiv_amt
,replace(replace(t1.credit_card_no,chr(13),''),chr(10),'') as credit_card_no
,cross_rate
,replace(replace(t1.d2_reference,chr(13),''),chr(10),'') as d2_reference
,float_days
,replace(replace(t1.oth_acct_ccy,chr(13),''),chr(10),'') as oth_acct_ccy
,replace(replace(t1.oth_acct_seq_no,chr(13),''),chr(10),'') as oth_acct_seq_no
,replace(replace(t1.oth_bank_code,chr(13),''),chr(10),'') as oth_bank_code
,replace(replace(t1.oth_bank_name,chr(13),''),chr(10),'') as oth_bank_name
,replace(replace(t1.oth_base_acct_no,chr(13),''),chr(10),'') as oth_base_acct_no
,replace(replace(t1.oth_branch,chr(13),''),chr(10),'') as oth_branch
,replace(replace(t1.oth_document_id,chr(13),''),chr(10),'') as oth_document_id
,replace(replace(t1.oth_document_type,chr(13),''),chr(10),'') as oth_document_type
,oth_internal_key
,replace(replace(t1.oth_prod_type,chr(13),''),chr(10),'') as oth_prod_type
,replace(replace(t1.oth_real_bank_code,chr(13),''),chr(10),'') as oth_real_bank_code
,replace(replace(t1.oth_real_bank_name,chr(13),''),chr(10),'') as oth_real_bank_name
,replace(replace(t1.oth_real_base_acct_no,chr(13),''),chr(10),'') as oth_real_base_acct_no
,replace(replace(t1.oth_real_document_id,chr(13),''),chr(10),'') as oth_real_document_id
,replace(replace(t1.oth_real_document_type,chr(13),''),chr(10),'') as oth_real_document_type
,replace(replace(t1.oth_real_tran_addr,chr(13),''),chr(10),'') as oth_real_tran_addr
,replace(replace(t1.oth_real_tran_name,chr(13),''),chr(10),'') as oth_real_tran_name
,replace(replace(t1.oth_reference,chr(13),''),chr(10),'') as oth_reference
,replace(replace(t1.oth_tran_addr,chr(13),''),chr(10),'') as oth_tran_addr
,replace(replace(t1.oth_tran_name,chr(13),''),chr(10),'') as oth_tran_name
,spread_percent
,replace(replace(t1.tfr_branch,chr(13),''),chr(10),'') as tfr_branch
,tran_amt
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,flat_rate
,replace(replace(t1.reaccount_cd,chr(13),''),chr(10),'') as reaccount_cd
,replace(replace(t1.bus_seq_no,chr(13),''),chr(10),'') as bus_seq_no

from ${iol_schema}.ncbs_rb_misc_hist t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_misc_hist.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
