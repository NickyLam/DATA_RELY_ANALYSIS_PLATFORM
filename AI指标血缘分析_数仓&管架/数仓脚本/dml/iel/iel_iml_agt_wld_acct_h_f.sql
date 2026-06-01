: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_wld_acct_h_f
CreateDate: 20230602
FileName:   ${iel_data_path}/agt_wld_acct_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,replace(replace(t1.cust_lmt_id,chr(13),''),chr(10),'') as cust_lmt_id
,replace(replace(t1.loan_prod_id,chr(13),''),chr(10),'') as loan_prod_id
,replace(replace(t1.syn_id,chr(13),''),chr(10),'') as syn_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,lmt
,curr_bal
,pric_bal
,last_exp_day_bal
,duf_mons
,unbd_debit_amt
,unbd_crdt_amt
,replace(replace(t1.apot_repay_type_cd,chr(13),''),chr(10),'') as apot_repay_type_cd
,replace(replace(t1.apot_repay_bank_name,chr(13),''),chr(10),'') as apot_repay_bank_name
,replace(replace(t1.apot_repay_open_bank_num,chr(13),''),chr(10),'') as apot_repay_open_bank_num
,replace(replace(t1.apot_repay_deduct_acct_num,chr(13),''),chr(10),'') as apot_repay_deduct_acct_num
,replace(replace(t1.apot_repay_deduct_acct_name,chr(13),''),chr(10),'') as apot_repay_deduct_acct_name
,replace(replace(t1.repay_day,chr(13),''),chr(10),'') as repay_day
,last_enter_acct_batch_dt
,prev_repay_dt
,prev_exp_repay_dt
,prev_ovdue_repay_dt
,prev_ovdue_mons_promt_dt
,in_coll_dt
,out_coll_que_dt
,next_exp_repay_dt
,exp_repay_dt
,apot_repay_dt
,grace_dt_term
,fir_exp_repay_dt
,clos_acct_dt
,tran_bad_debt_acct_dt
,last_repay_amt
,currt_consm_amt
,currt_consm_cnt
,currt_repay_amt
,currt_repay_cnt
,currt_debit_adj_amt
,currt_debit_adj_cnt
,currt_crdt_adj_amt
,currt_crdt_adj_cnt
,currt_fee_amt
,currt_fee_cnt
,currt_int_amt
,currt_int_cnt
,th_mon_consm_amt
,th_mon_consm_cnt
,th_year_consm_amt
,th_year_consm_cnt
,curr_mon_repay_amt
,curr_mon_repay_cnt
,th_year_repay_amt
,th_year_repay_cnt
,h_repay_amt
,h_repay_cnt
,bank_contri_ratio

from ${iml_schema}.agt_wld_acct_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd')-1 and end_dt > to_date('${batch_date}','yyyymmdd')-1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wld_acct_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
