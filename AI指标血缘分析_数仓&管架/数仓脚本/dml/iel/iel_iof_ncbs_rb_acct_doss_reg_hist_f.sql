: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_acct_doss_reg_hist_f
CreateDate: 20221229
FileName:   ${iel_data_path}/ncbs_rb_acct_doss_reg_hist.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.doss_operate_type,chr(13),''),chr(10),'') as doss_operate_type
,replace(replace(t1.hand_flag,chr(13),''),chr(10),'') as hand_flag
,internal_key
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.amt_type,chr(13),''),chr(10),'') as amt_type
,balance
,int_amt
,por_int_tot
,tax_sc
,replace(replace(t1.waitdoss_branch,chr(13),''),chr(10),'') as waitdoss_branch
,replace(replace(t1.waitdoss_user_id,chr(13),''),chr(10),'') as waitdoss_user_id
,waitdoss_date
,waitout_date
,replace(replace(t1.waitout_user_id,chr(13),''),chr(10),'') as waitout_user_id
,withdrawal_date
,replace(replace(t1.withdrawal_branch,chr(13),''),chr(10),'') as withdrawal_branch
,replace(replace(t1.withdrawal_user_id,chr(13),''),chr(10),'') as withdrawal_user_id
,replace(replace(t1.withdrawal_reason,chr(13),''),chr(10),'') as withdrawal_reason
,replace(replace(t1.doss_status,chr(13),''),chr(10),'') as doss_status
,doss_date
,replace(replace(t1.doss_branch,chr(13),''),chr(10),'') as doss_branch
,replace(replace(t1.doss_user_id,chr(13),''),chr(10),'') as doss_user_id
,replace(replace(t1.todoss_reason,chr(13),''),chr(10),'') as todoss_reason
,active_date
,replace(replace(t1.active_branch,chr(13),''),chr(10),'') as active_branch
,replace(replace(t1.active_user_id,chr(13),''),chr(10),'') as active_user_id
,out_busi_date
,replace(replace(t1.out_busi_user_id,chr(13),''),chr(10),'') as out_busi_user_id
,replace(replace(t1.individual_flag,chr(13),''),chr(10),'') as individual_flag
,replace(replace(t1.non_transplant_flag,chr(13),''),chr(10),'') as non_transplant_flag
,replace(replace(t1.to_bank_ind,chr(13),''),chr(10),'') as to_bank_ind
,replace(replace(t1.to_base_acct_no,chr(13),''),chr(10),'') as to_base_acct_no
,replace(replace(t1.to_ccy,chr(13),''),chr(10),'') as to_ccy
,replace(replace(t1.to_acct_seq_no,chr(13),''),chr(10),'') as to_acct_seq_no
,replace(replace(t1.to_acct_name,chr(13),''),chr(10),'') as to_acct_name
,replace(replace(t1.to_acct_type,chr(13),''),chr(10),'') as to_acct_type
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,record_amt
,tran_date
,replace(replace(t1.branch,chr(13),''),chr(10),'') as branch
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,tran_amt
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.bond_version_num,chr(13),''),chr(10),'') as bond_version_num
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no

from ${iol_schema}.ncbs_rb_acct_doss_reg_hist t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_acct_doss_reg_hist.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
