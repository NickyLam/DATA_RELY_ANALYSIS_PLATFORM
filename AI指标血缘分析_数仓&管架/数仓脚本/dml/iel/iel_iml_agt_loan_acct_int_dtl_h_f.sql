: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_acct_int_dtl_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_acct_int_dtl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,next_int_set_dt
,last_int_set_dt
,last_real_int_set_dt
,provi_day_provi_int
,curr_acm_provi_int
,ld_acm_provi_int
,provi_day_int_adj_amt
,acm_int_adj_amt
,ld_acm_int_adj_amt
,int_set_day_int_amt
,int_set_amt
,ovdue_int
,ld_ovdue_int
,int_cap_amt
,last_int_provi_dt
,unrliz_int
,replace(replace(t1.discnt_int_flg,chr(13),''),chr(10),'') as discnt_int_flg
,discnt_pay_int
,discnt_pnlt_amt
,discnt_int
,ld_bf_pay_int_amt
,value_dt
,exp_dt
,int_accr_surp_days
,provi_day_int_tax
,currt_int_tax_acm_amt
,int_set_day_int_tax
,int_tax_acm_amt
,day_cut_bf_last_int_set_dt
,next_provi_dt
,provi_accum
,agt_accum
,provi_actl_amt
,provi_amt_bal
,int_amt
,int_tax_lmt
,int_tax_bal
,currt_acm_int_accr_days
,currt_acm_amorted_provi_amt
,last_provi_dt
,back_nature_day_days
,back_wd_days
,acct_stl_dt
,stock_int_tax
,provi_begin_day
,agt_prefr_amt
,agt_int
,last_int_calc_dt

from ${iml_schema}.agt_loan_acct_int_dtl_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_acct_int_dtl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
