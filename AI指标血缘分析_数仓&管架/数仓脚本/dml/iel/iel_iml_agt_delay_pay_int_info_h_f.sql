: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_delay_pay_int_info_h_f
CreateDate: 20230831
FileName:   ${iel_data_path}/agt_delay_pay_int_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.apv_form_id,chr(13),''),chr(10),'') as apv_form_id
,replace(replace(t1.sub_acct_num,chr(13),''),chr(10),'') as sub_acct_num
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,min_init_amt
,min_init_tenor
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,effect_dt
,invalid_dt
,replace(replace(t1.tm_type_cd,chr(13),''),chr(10),'') as tm_type_cd
,pay_int_spec_day
,int_accr_days
,max_int_accr_acct_bal
,delay_pay_int_int
,replace(replace(t1.merge_int_set_flg_cd,chr(13),''),chr(10),'') as merge_int_set_flg_cd
,acm_amt
,int_paybl
,acm_paid_int
,int_float_point
,yd_today_val_bal
,td_acm_amt
,next_int_set_day
,last_int_set_day
,spec_yld_rat
,replace(replace(t1.int_enter_acct_id,chr(13),''),chr(10),'') as int_enter_acct_id
,replace(replace(t1.int_enter_acct_cust_acct_num,chr(13),''),chr(10),'') as int_enter_acct_cust_acct_num
,replace(replace(t1.int_enter_acct_prod_id,chr(13),''),chr(10),'') as int_enter_acct_prod_id
,replace(replace(t1.int_enter_acct_sub_acct_num,chr(13),''),chr(10),'') as int_enter_acct_sub_acct_num
,replace(replace(t1.int_enter_acct_curr_cd,chr(13),''),chr(10),'') as int_enter_acct_curr_cd
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.core_tran_org_id,chr(13),''),chr(10),'') as core_tran_org_id

from ${iml_schema}.agt_delay_pay_int_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_delay_pay_int_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
