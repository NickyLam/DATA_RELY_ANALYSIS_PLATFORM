: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_acct_comp_int_int_accr_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_acct_comp_int_int_accr_h.f.${batch_date}.dat
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
,last_provi_dt
,last_int_set_dt
,next_int_set_dt
,value_dt
,exp_dt
,int_amt
,acm_int_adj_amt
,provi_day_int_adj
,provi_day_provi_actl_amt
,provi_day_provi_int
,acm_provi_int
,provi_amt_bal
,int_set_amt
,int_set_day_int_amt
,ld_acm_provi_int
,ld_acm_int_adj
,int_tax_acm_amt
,int_set_day_int_tax
,tax_rat
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,wrt_off_pric

from ${iml_schema}.agt_loan_acct_comp_int_int_accr_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_acct_comp_int_int_accr_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
