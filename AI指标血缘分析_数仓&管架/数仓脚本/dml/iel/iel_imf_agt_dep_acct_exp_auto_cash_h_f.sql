: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_dep_acct_exp_auto_cash_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_dep_acct_exp_auto_cash_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,open_acct_dt
,exp_dt
,tran_dt
,replace(replace(t1.core_tran_org_id,chr(13),''),chr(10),'') as core_tran_org_id
,int_amt
,pric_amt
,cash_redem_amt
,exec_year_int_rat
,replace(replace(t1.proc_cate_cd,chr(13),''),chr(10),'') as proc_cate_cd
,replace(replace(t1.pric_int_enter_acct_cust_id,chr(13),''),chr(10),'') as pric_int_enter_acct_cust_id
,replace(replace(t1.pric_int_enter_acct_cust_acct_num,chr(13),''),chr(10),'') as pric_int_enter_acct_cust_acct_num
,replace(replace(t1.pric_int_enter_acct_sub_acct_num,chr(13),''),chr(10),'') as pric_int_enter_acct_sub_acct_num
,replace(replace(t1.pric_int_enter_curr_cd,chr(13),''),chr(10),'') as pric_int_enter_curr_cd
,replace(replace(t1.pric_int_enter_prod_id,chr(13),''),chr(10),'') as pric_int_enter_prod_id
,replace(replace(t1.int_enter_name,chr(13),''),chr(10),'') as int_enter_name
,replace(replace(t1.pd_cd,chr(13),''),chr(10),'') as pd_cd
,replace(replace(t1.pd_prod_cate_cd,chr(13),''),chr(10),'') as pd_prod_cate_cd
,replace(replace(t1.rest_cd,chr(13),''),chr(10),'') as rest_cd

from ${iml_schema}.agt_dep_acct_exp_auto_cash_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_exp_auto_cash_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
