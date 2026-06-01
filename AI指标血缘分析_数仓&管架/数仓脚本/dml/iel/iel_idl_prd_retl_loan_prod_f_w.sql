: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_prd_retl_loan_prod_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_retl_loan_prod_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt 
,t1.prod_id as prod_id 
,t1.lp_id as lp_id 
,t1.prod_cate_cd as prod_cate_cd 
,t1.prod_name as prod_name 
,t1.valid_flg as valid_flg 
,t1.guar_way_comb_cd as guar_way_comb_cd 
,t1.curr_cd as curr_cd 
,t1.prod_tenor_cd as prod_tenor_cd 
,t1.min_mon_tenor as min_mon_tenor 
,t1.max_mon_tenor as max_mon_tenor 
,t1.sig_loan_amt_uplmi as sig_loan_amt_uplmi 
,t1.repay_way_comb_cd as repay_way_comb_cd 
,t1.insuf_deduct_way_cd as insuf_deduct_way_cd 
,t1.min_adv_repay_amt as min_adv_repay_amt 
,t1.min_adv_repay_tenor as min_adv_repay_tenor 
,t1.int_calc_way_cd as int_calc_way_cd 
,t1.int_rat_adj_way_cd as int_rat_adj_way_cd 
,t1.min_cu_int_rat_fl_rt as min_cu_int_rat_fl_rt 
,t1.max_cu_int_rat_fl_rt as max_cu_int_rat_fl_rt 
,t1.min_ovdue_pnlt_amt as min_ovdue_pnlt_amt 
,t1.comp_int_flg as comp_int_flg 
,t1.min_pnlt_ratio as min_pnlt_ratio 
,t1.max_pnlt_ratio as max_pnlt_ratio 
,t1.int_sub_flg as int_sub_flg 
,t1.int_sub_way_cd as int_sub_way_cd 
,t1.int_sub_enter_way_cd as int_sub_enter_way_cd 
,t1.int_sub_int_rat as int_sub_int_rat 
,t1.fix_int_sub_amt as fix_int_sub_amt 
,t1.max_int_sub_amt as max_int_sub_amt 
,t1.loan_bus_kind_cd as loan_bus_kind_cd 
,t1.exec_year_int_rat as exec_year_int_rat 
,t1.circl_flg as circl_flg 
,t1.max_lower_int_rat_fl_rt as max_lower_int_rat_fl_rt 
,t1.min_lower_int_rat_fl_rt as min_lower_int_rat_fl_rt 
,t1.int_accr_rule as int_accr_rule 
,t1.int_rat_type_cd as int_rat_type_cd 
,t1.int_rat_ped_cd as int_rat_ped_cd 
,t1.int_rat_adj_ped_comb_cd as int_rat_adj_ped_comb_cd 
,t1.int_rat_float_way_comb_cd as int_rat_float_way_comb_cd 
,t1.int_rat_flo_val as int_rat_flo_val 
,t1.allow_dep_card_flg as allow_dep_card_flg 
,t1.int_accr_flg as int_accr_flg 
,t1.comp_int_accr_flg as comp_int_accr_flg 
,t1.ovdue_int_accr_way_cd as ovdue_int_accr_way_cd 
,t1.ovdue_pnlt_float_way_cd as ovdue_pnlt_float_way_cd 
,t1.ovdue_pnlt_flo_val as ovdue_pnlt_flo_val 
,t1.adv_repay_flg as adv_repay_flg 
,t1.adv_repay_int_way_cd as adv_repay_int_way_cd 
,t1.adv_repay_int_sub_flg as adv_repay_int_sub_flg 
,t1.auto_deduct_flg as auto_deduct_flg 
,t1.auto_payoff_loan_flg as auto_payoff_loan_flg 
,t1.allow_loan_renew_flg as allow_loan_renew_flg 
,t1.renew_max_cnt as renew_max_cnt 
,t1.blon_loan_flg as blon_loan_flg 
,t1.borw_usage_type_comb_cd as borw_usage_type_comb_cd 
,t1.nomal_int_rat_float_way_cd as nomal_int_rat_float_way_cd 
,t1.nomal_int_rat_fl_rt as nomal_int_rat_fl_rt 
,t1.asset_thd_cls_cd as asset_thd_cls_cd 
,t1.comp_flg as comp_flg 
,t1.lowt_exec_int_rat as lowt_exec_int_rat 
,t1.higt_exec_int_rat as higt_exec_int_rat 
,t1.create_dt as create_dt 
,t1.update_dt as update_dt 
,t1.id_mark as id_mark 
,t1.init_prod_id as init_prod_id 
,t1.job_cd
from ${idl_schema}.prd_retl_loan_prod t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_retl_loan_prod_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes