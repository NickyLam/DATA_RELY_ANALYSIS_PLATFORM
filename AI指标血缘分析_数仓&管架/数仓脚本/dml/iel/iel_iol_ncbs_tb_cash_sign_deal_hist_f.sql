: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_tb_cash_sign_deal_hist_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_tb_cash_sign_deal_hist.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.acct_seq_no,chr(13),''),chr(10),'') as acct_seq_no
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.document_id,chr(13),''),chr(10),'') as document_id
,replace(replace(t1.document_type,chr(13),''),chr(10),'') as document_type
,replace(replace(t1.prod_type,chr(13),''),chr(10),'') as prod_type
,replace(replace(t1.reference,chr(13),''),chr(10),'') as reference
,replace(replace(t1.tran_type,chr(13),''),chr(10),'') as tran_type
,replace(replace(t1.cash_from_to,chr(13),''),chr(10),'') as cash_from_to
,replace(replace(t1.cash_item,chr(13),''),chr(10),'') as cash_item
,replace(replace(t1.cash_sign_type,chr(13),''),chr(10),'') as cash_sign_type
,replace(replace(t1.cash_sign_id,chr(13),''),chr(10),'') as cash_sign_id
,replace(replace(t1.cash_sign_no,chr(13),''),chr(10),'') as cash_sign_no
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.narrative,chr(13),''),chr(10),'') as narrative
,replace(replace(t1.cash_sign_deal_no,chr(13),''),chr(10),'') as cash_sign_deal_no
,replace(replace(t1.reserve_flag,chr(13),''),chr(10),'') as reserve_flag
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,t1.effect_date as effect_date
,t1.cash_sign_deal_date as cash_sign_deal_date
,t1.reversal_date as reversal_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,replace(replace(t1.acct_ccy,chr(13),''),chr(10),'') as acct_ccy
,replace(replace(t1.auth_user_id,chr(13),''),chr(10),'') as auth_user_id
,replace(replace(t1.cash_sign_deal_branch,chr(13),''),chr(10),'') as cash_sign_deal_branch
,replace(replace(t1.cash_sign_deal_user,chr(13),''),chr(10),'') as cash_sign_deal_user
,replace(replace(t1.reversal_auth_user_id,chr(13),''),chr(10),'') as reversal_auth_user_id
,replace(replace(t1.reversal_user_id,chr(13),''),chr(10),'') as reversal_user_id
,t1.tran_amt as tran_amt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ncbs_tb_cash_sign_deal_hist t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_tb_cash_sign_deal_hist.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes