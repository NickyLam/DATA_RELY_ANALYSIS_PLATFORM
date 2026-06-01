: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_am_cashflow_plan_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_am_cashflow_plan_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.cashflow_id,chr(13),''),chr(10),'') as cashflow_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.cashflow_seq_num,chr(13),''),chr(10),'') as cashflow_seq_num 
,replace(replace(t1.cashflow_cate_cd,chr(13),''),chr(10),'') as cashflow_cate_cd 
,t1.nadj_calc_start_dt as nadj_calc_start_dt 
,t1.nadj_calc_end_dt as nadj_calc_end_dt 
,t1.nadj_plan_pay_dt as nadj_plan_pay_dt 
,t1.a_adjust_calc_start_dt as a_adjust_calc_start_dt 
,t1.a_adjust_calc_end_dt as a_adjust_calc_end_dt 
,t1.a_adjust_plan_pay_dt as a_adjust_plan_pay_dt 
,t1.calc_ped_days as calc_ped_days 
,t1.integy_ped_start_dt as integy_ped_start_dt 
,t1.integy_ped_end_dt as integy_ped_end_dt 
,t1.integy_ped_days as integy_ped_days 
,t1.plan_pay_pric as plan_pay_pric 
,t1.int_accr_pric as int_accr_pric 
,t1.plan_pay_int as plan_pay_int 
,replace(replace(t1.pay_int_flg,chr(13),''),chr(10),'') as pay_int_flg 
,t1.plan_pay_amt as plan_pay_amt 
,t1.cashflow_base as cashflow_base 
,replace(replace(t1.base_corp_type_cd,chr(13),''),chr(10),'') as base_corp_type_cd 
,t1.year_pay_int_cnt as year_pay_int_cnt 
,replace(replace(t1.fin_prod_id,chr(13),''),chr(10),'') as fin_prod_id 
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd 
,replace(replace(t1.brch_seq_num,chr(13),''),chr(10),'') as brch_seq_num 
,replace(replace(t1.pay_type_cd,chr(13),''),chr(10),'') as pay_type_cd 
,t1.intrv_net_yld_rat as intrv_net_yld_rat 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.prd_am_cashflow_plan_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_cashflow_plan_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes