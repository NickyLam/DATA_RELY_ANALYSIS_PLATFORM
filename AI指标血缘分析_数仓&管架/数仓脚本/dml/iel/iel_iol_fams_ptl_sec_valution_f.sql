: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_ptl_sec_valution_f
CreateDate: 20240702
FileName:   ${iel_data_path}/fams_ptl_sec_valution.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,cdate
,replace(replace(t1.portfolio_id,chr(13),''),chr(10),'') as portfolio_id
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,replace(replace(t1.inv_aim,chr(13),''),chr(10),'') as inv_aim
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,share_amt
,tdy_float_ingpl
,dsc_cost_amt
,dsc_clean_price
,tdy_intincexp
,buy_cost_amt
,buy_clean_price
,market_value
,market_clean_price
,tdy_dscincexp_add
,tdy_intincexp_add
,tdy_dscloss_add
,tdy_float_ingpl_add
,tdy_fee_add
,accu_net_value
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,act_d_yield
,replace(replace(t1.sec_acct_id,chr(13),''),chr(10),'') as sec_acct_id
,delay_pay_amt
,replace(replace(t1.b_ccy,chr(13),''),chr(10),'') as b_ccy
,tdy_float_ingpl_b
,dsc_cost_amt_b
,dsc_clean_price_b
,delay_pay_amt_b
,tdy_intincexp_b
,in_tdy_intincexp
,out_tdy_intincexp
,end_days_1
,end_days_2
,int_rate
,tdy_dscloss_add_b
,replace(replace(t1.gen_type,chr(13),''),chr(10),'') as gen_type

from ${iol_schema}.fams_ptl_sec_valution t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_ptl_sec_valution.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
