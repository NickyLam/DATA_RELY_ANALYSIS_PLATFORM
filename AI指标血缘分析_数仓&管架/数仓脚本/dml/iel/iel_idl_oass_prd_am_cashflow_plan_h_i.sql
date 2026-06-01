: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_prd_am_cashflow_plan_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_prd_am_cashflow_plan_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cashflow_seq_num as cashflow_seq_num
,t1.cashflow_cate_cd as cashflow_cate_cd
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
,t1.pay_int_flg as pay_int_flg
,t1.plan_pay_amt as plan_pay_amt
,t1.cashflow_base as cashflow_base
,t1.base_corp_type_cd as base_corp_type_cd
,t1.year_pay_int_cnt as year_pay_int_cnt
,t1.fin_prod_id as fin_prod_id
,t1.prod_cate_cd as prod_cate_cd
,t1.brch_seq_num as brch_seq_num
,t1.pay_type_cd as pay_type_cd
,t1.intrv_net_yld_rat as intrv_net_yld_rat
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.cashflow_id as cashflow_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_prd_am_cashflow_plan_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_prd_am_cashflow_plan_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
