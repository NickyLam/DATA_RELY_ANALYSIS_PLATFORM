: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_dep_rcpt_inpwn_info_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_dep_rcpt_inpwn_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dep_rcpt_type_cd,chr(13),''),chr(10),'') as dep_rcpt_type_cd
,dep_rcpt_amt
,dep_rcpt_int_rat
,dep_term
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.subscr_acct_id,chr(13),''),chr(10),'') as subscr_acct_id
,replace(replace(t1.stop_pay_acct_id,chr(13),''),chr(10),'') as stop_pay_acct_id
,replace(replace(t1.liab_acct_id,chr(13),''),chr(10),'') as liab_acct_id
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,value_dt
,exp_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt
,effect_dt
,aval_amt

from ${iml_schema}.ast_col_dep_rcpt_inpwn_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_dep_rcpt_inpwn_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
