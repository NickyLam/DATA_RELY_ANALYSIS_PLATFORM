: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_am_cashflow_plan_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/prd_am_cashflow_plan_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(cashflow_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(cashflow_seq_num,chr(13),''),chr(10),'')
,replace(replace(cashflow_cate_cd,chr(13),''),chr(10),'')
,nadj_calc_start_dt
,nadj_calc_end_dt
,nadj_plan_pay_dt
,a_adjust_calc_start_dt
,a_adjust_calc_end_dt
,a_adjust_plan_pay_dt
,calc_ped_days
,integy_ped_start_dt
,integy_ped_end_dt
,integy_ped_days
,plan_pay_pric
,int_accr_pric
,plan_pay_int
,replace(replace(pay_int_flg,chr(13),''),chr(10),'')
,plan_pay_amt
,cashflow_base
,replace(replace(base_corp_type_cd,chr(13),''),chr(10),'')
,year_pay_int_cnt
,replace(replace(fin_prod_id,chr(13),''),chr(10),'')
,replace(replace(prod_cate_cd,chr(13),''),chr(10),'')
,replace(replace(brch_seq_num,chr(13),''),chr(10),'')
,replace(replace(pay_type_cd,chr(13),''),chr(10),'')
,intrv_net_yld_rat
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.prd_am_cashflow_plan_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_cashflow_plan_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
