: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_irr_repay_plan_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_irr_repay_plan_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.repay_plan_id,chr(13),''),chr(10),'') as repay_plan_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t1.curr_sub_plan_way_cd,chr(13),''),chr(10),'') as curr_sub_plan_way_cd
,effect_dt
,invalid_dt
,replace(replace(t1.freq_cd,chr(13),''),chr(10),'') as freq_cd
,next_proc_dt
,proc_day
,tot_amt
,perds
,prog_intrv_perds
,prog_amt
,prog_ratio
,replace(replace(t1.int_set_ped_cd,chr(13),''),chr(10),'') as int_set_ped_cd
,next_int_set_dt
,int_callbk_day
,blon_loan_calc_pd
,replace(replace(t1.grace_period_type_cd,chr(13),''),chr(10),'') as grace_period_type_cd
,grace_days
,sub_acct_fix_int_rat
,sub_acct_int_rat_float_ratio
,sub_acct_int_rat_float_point
,replace(replace(t1.agt_chg_way_cd,chr(13),''),chr(10),'') as agt_chg_way_cd

from ${iml_schema}.agt_irr_repay_plan_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_irr_repay_plan_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
