: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_rb_restraints_f
CreateDate: 20240401
FileName:   ${iel_data_path}/ncbs_rb_restraints.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.doc_type,chr(13),''),chr(10),'') as doc_type
,internal_key
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.restraint_type,chr(13),''),chr(10),'') as restraint_type
,replace(replace(t1.tran_type,chr(13),''),chr(10),'') as tran_type
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.term,chr(13),''),chr(10),'') as term
,replace(replace(t1.term_type,chr(13),''),chr(10),'') as term_type
,replace(replace(t1.appr_flag,chr(13),''),chr(10),'') as appr_flag
,replace(replace(t1.channel_seq_no,chr(13),''),chr(10),'') as channel_seq_no
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.deduction_law_no,chr(13),''),chr(10),'') as deduction_law_no
,replace(replace(t1.full_freeze_ind,chr(13),''),chr(10),'') as full_freeze_ind
,replace(replace(t1.help_option,chr(13),''),chr(10),'') as help_option
,replace(replace(t1.interrupt_flag,chr(13),''),chr(10),'') as interrupt_flag
,replace(replace(t1.is_frozen,chr(13),''),chr(10),'') as is_frozen
,replace(replace(t1.maintain_type,chr(13),''),chr(10),'') as maintain_type
,replace(replace(t1.msg_bank,chr(13),''),chr(10),'') as msg_bank
,replace(replace(t1.msg_client,chr(13),''),chr(10),'') as msg_client
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,no_of_payment
,replace(replace(t1.oth_acct_desc,chr(13),''),chr(10),'') as oth_acct_desc
,payment_made
,replace(replace(t1.prefix,chr(13),''),chr(10),'') as prefix
,replace(replace(t1.program_id,chr(13),''),chr(10),'') as program_id
,replace(replace(t1.release_law_no,chr(13),''),chr(10),'') as release_law_no
,replace(replace(t1.res_acct_range,chr(13),''),chr(10),'') as res_acct_range
,replace(replace(t1.res_law_no,chr(13),''),chr(10),'') as res_law_no
,replace(replace(t1.res_priority,chr(13),''),chr(10),'') as res_priority
,replace(replace(t1.res_seq_no,chr(13),''),chr(10),'') as res_seq_no
,replace(replace(t1.restraint_judiciary_name,chr(13),''),chr(10),'') as restraint_judiciary_name
,replace(replace(t1.restraints_status,chr(13),''),chr(10),'') as restraints_status
,replace(replace(t1.source_module,chr(13),''),chr(10),'') as source_module
,replace(replace(t1.spec_code,chr(13),''),chr(10),'') as spec_code
,replace(replace(t1.start_cheque_no,chr(13),''),chr(10),'') as start_cheque_no
,replace(replace(t1.stl_seq_no,chr(13),''),chr(10),'') as stl_seq_no
,replace(replace(t1.sub_restraint_class,chr(13),''),chr(10),'') as sub_restraint_class
,replace(replace(t1.thaw_officer_name,chr(13),''),chr(10),'') as thaw_officer_name
,replace(replace(t1.thaw_oth_officer_name,chr(13),''),chr(10),'') as thaw_oth_officer_name
,replace(replace(t1.under_lien,chr(13),''),chr(10),'') as under_lien
,replace(replace(t1.wait_seq,chr(13),''),chr(10),'') as wait_seq
,approval_date
,channel_date
,end_date
,last_change_date
,start_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.appr_user_id,chr(13),''),chr(10),'') as appr_user_id
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.deduction_judiciary_name,chr(13),''),chr(10),'') as deduction_judiciary_name
,end_amt
,replace(replace(t1.end_cheque_no,chr(13),''),chr(10),'') as end_cheque_no
,replace(replace(t1.judiciary_document_id,chr(13),''),chr(10),'') as judiciary_document_id
,replace(replace(t1.judiciary_document_id2,chr(13),''),chr(10),'') as judiciary_document_id2
,replace(replace(t1.judiciary_document_type,chr(13),''),chr(10),'') as judiciary_document_type
,replace(replace(t1.judiciary_document_type2,chr(13),''),chr(10),'') as judiciary_document_type2
,replace(replace(t1.judiciary_officer_name,chr(13),''),chr(10),'') as judiciary_officer_name
,replace(replace(t1.judiciary_oth_document_id,chr(13),''),chr(10),'') as judiciary_oth_document_id
,replace(replace(t1.judiciary_oth_document_id2,chr(13),''),chr(10),'') as judiciary_oth_document_id2
,replace(replace(t1.judiciary_oth_document_type,chr(13),''),chr(10),'') as judiciary_oth_document_type
,replace(replace(t1.judiciary_oth_document_type2,chr(13),''),chr(10),'') as judiciary_oth_document_type2
,replace(replace(t1.judiciary_oth_officer_name,chr(13),''),chr(10),'') as judiciary_oth_officer_name
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,replace(replace(t1.oth_acct_ccy,chr(13),''),chr(10),'') as oth_acct_ccy
,replace(replace(t1.oth_acct_no,chr(13),''),chr(10),'') as oth_acct_no
,replace(replace(t1.oth_bank_code,chr(13),''),chr(10),'') as oth_bank_code
,replace(replace(t1.oth_base_acct_no,chr(13),''),chr(10),'') as oth_base_acct_no
,replace(replace(t1.oth_prod_type,chr(13),''),chr(10),'') as oth_prod_type
,paid_amt
,replace(replace(t1.pledged_acct_ccy,chr(13),''),chr(10),'') as pledged_acct_ccy
,replace(replace(t1.pledged_acct_no,chr(13),''),chr(10),'') as pledged_acct_no
,replace(replace(t1.pledged_acct_type,chr(13),''),chr(10),'') as pledged_acct_type
,pledged_amt
,replace(replace(t1.pledged_base_acct_no,chr(13),''),chr(10),'') as pledged_base_acct_no
,real_restraint_amt
,replace(replace(t1.release_judiciary_name,chr(13),''),chr(10),'') as release_judiciary_name
,start_amt
,replace(replace(t1.thaw_document_id,chr(13),''),chr(10),'') as thaw_document_id
,replace(replace(t1.thaw_document_id2,chr(13),''),chr(10),'') as thaw_document_id2
,replace(replace(t1.thaw_document_type,chr(13),''),chr(10),'') as thaw_document_type
,replace(replace(t1.thaw_oth_document_id,chr(13),''),chr(10),'') as thaw_oth_document_id
,replace(replace(t1.thaw_oth_document_id2,chr(13),''),chr(10),'') as thaw_oth_document_id2
,replace(replace(t1.thaw_oth_document_type,chr(13),''),chr(10),'') as thaw_oth_document_type
,replace(replace(t1.thaw_oth_document_type2,chr(13),''),chr(10),'') as thaw_oth_document_type2
,to_pay_amt
,tran_amt
,replace(replace(t1.tran_branch,chr(13),''),chr(10),'') as tran_branch
,replace(replace(t1.thaw_document_type2,chr(13),''),chr(10),'') as thaw_document_type2
,replace(replace(t1.reaccount_cd,chr(13),''),chr(10),'') as reaccount_cd
,replace(replace(t1.reserve,chr(13),''),chr(10),'') as reserve
,replace(replace(t1.deduction_law_type,chr(13),''),chr(10),'') as deduction_law_type
,replace(replace(t1.out_sign_user_id,chr(13),''),chr(10),'') as out_sign_user_id
,replace(replace(t1.unlost_time,chr(13),''),chr(10),'') as unlost_time

from ${iol_schema}.ncbs_rb_restraints t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_restraints.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
