: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_loan_acct_pnlt_int_accr_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_acct_pnlt_int_accr_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,curr_pd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,last_int_set_dt
,next_int_set_dt
,value_dt
,last_provi_dt
,exp_dt
,int_amt
,provi_day_provi_actl_amt
,provi_amt_bal
,acm_int_adj_amt
,provi_day_provi_int
,ld_acm_provi_int
,int_set_day_int_amt
,provi_day_int_adj
,ld_acm_int_adj
,int_set_amt
,acm_provi_int
,int_set_day_int_tax
,tax_rat
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,int_tax_acm_amt
,wrt_off_pric

from ${iml_schema}.agt_loan_acct_pnlt_int_accr_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_acct_pnlt_int_accr_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
