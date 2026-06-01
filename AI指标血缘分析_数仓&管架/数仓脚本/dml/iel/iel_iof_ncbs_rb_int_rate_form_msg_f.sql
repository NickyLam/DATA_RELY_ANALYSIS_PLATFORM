: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_rb_int_rate_form_msg_f
CreateDate: 20230606
FileName:   ${iel_data_path}/ncbs_rb_int_rate_form_msg.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.client_name,chr(13),''),chr(10),'') as client_name
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.reason,chr(13),''),chr(10),'') as reason
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,last_change_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,valid_from_date
,valid_thru_date
,disc_base_rate
,float_point
,real_rate
,replace(replace(t1.int_rate_term,chr(13),''),chr(10),'') as int_rate_term
,replace(replace(t1.add_agreement_flag,chr(13),''),chr(10),'') as add_agreement_flag
,replace(replace(t1.pre_int_rate_form_no,chr(13),''),chr(10),'') as pre_int_rate_form_no
,replace(replace(t1.auth_client_flag,chr(13),''),chr(10),'') as auth_client_flag
,pri_amt_limit
,int_valid_from_date
,int_valid_thru_date
,replace(replace(t1.int_agreement_status,chr(13),''),chr(10),'') as int_agreement_status
,replace(replace(t1.int_rate_form_apply_type,chr(13),''),chr(10),'') as int_rate_form_apply_type
,auth_client_payment
,replace(replace(t1.new_acct_no_flag,chr(13),''),chr(10),'') as new_acct_no_flag
,replace(replace(t1.rb_prod_term,chr(13),''),chr(10),'') as rb_prod_term
,replace(replace(t1.int_rate_rb_prod_type,chr(13),''),chr(10),'') as int_rate_rb_prod_type
,replace(replace(t1.int_rate_form_no,chr(13),''),chr(10),'') as int_rate_form_no
,internal_key

from ${iol_schema}.ncbs_rb_int_rate_form_msg t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_rb_int_rate_form_msg.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
