: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_retl_loan_prod_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_retl_loan_prod.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd
,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t.valid_flg,chr(13),''),chr(10),'') as valid_flg
,replace(replace(t.guar_way_comb_cd,chr(13),''),chr(10),'') as guar_way_comb_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.prod_tenor_cd,chr(13),''),chr(10),'') as prod_tenor_cd
,t.min_mon_tenor as min_mon_tenor
,t.max_mon_tenor as max_mon_tenor
,t.sig_loan_amt_uplmi as sig_loan_amt_uplmi
,replace(replace(t.repay_way_comb_cd,chr(13),''),chr(10),'') as repay_way_comb_cd
,replace(replace(t.insuf_deduct_way_cd,chr(13),''),chr(10),'') as insuf_deduct_way_cd
,t.min_adv_repay_amt as min_adv_repay_amt
,t.min_adv_repay_tenor as min_adv_repay_tenor
,replace(replace(t.int_calc_way_cd,chr(13),''),chr(10),'') as int_calc_way_cd
,replace(replace(t.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,t.min_cu_int_rat_fl_rt as min_cu_int_rat_fl_rt
,t.max_cu_int_rat_fl_rt as max_cu_int_rat_fl_rt
,t.min_ovdue_pnlt_amt as min_ovdue_pnlt_amt
,replace(replace(t.comp_int_flg,chr(13),''),chr(10),'') as comp_int_flg
,t.min_pnlt_ratio as min_pnlt_ratio
,t.max_pnlt_ratio as max_pnlt_ratio
,replace(replace(t.int_sub_flg,chr(13),''),chr(10),'') as int_sub_flg
,replace(replace(t.int_sub_way_cd,chr(13),''),chr(10),'') as int_sub_way_cd
,replace(replace(t.int_sub_enter_way_cd,chr(13),''),chr(10),'') as int_sub_enter_way_cd
,t.int_sub_int_rat as int_sub_int_rat
,t.fix_int_sub_amt as fix_int_sub_amt
,t.max_int_sub_amt as max_int_sub_amt
,replace(replace(t.loan_bus_kind_cd,chr(13),''),chr(10),'') as loan_bus_kind_cd
,t.exec_year_int_rat as exec_year_int_rat
,replace(replace(t.circl_flg,chr(13),''),chr(10),'') as circl_flg
,t.max_lower_int_rat_fl_rt as max_lower_int_rat_fl_rt
,t.min_lower_int_rat_fl_rt as min_lower_int_rat_fl_rt
,replace(replace(t.int_accr_rule,chr(13),''),chr(10),'') as int_accr_rule
,replace(replace(t.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t.int_rat_ped_cd,chr(13),''),chr(10),'') as int_rat_ped_cd
,replace(replace(t.int_rat_adj_ped_comb_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_comb_cd
,replace(replace(t.int_rat_float_way_comb_cd,chr(13),''),chr(10),'') as int_rat_float_way_comb_cd
,t.int_rat_flo_val as int_rat_flo_val
,replace(replace(t.allow_dep_card_flg,chr(13),''),chr(10),'') as allow_dep_card_flg
,replace(replace(t.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t.comp_int_accr_flg,chr(13),''),chr(10),'') as comp_int_accr_flg
,replace(replace(t.ovdue_int_accr_way_cd,chr(13),''),chr(10),'') as ovdue_int_accr_way_cd
,replace(replace(t.ovdue_pnlt_float_way_cd,chr(13),''),chr(10),'') as ovdue_pnlt_float_way_cd
,t.ovdue_pnlt_flo_val as ovdue_pnlt_flo_val
,replace(replace(t.adv_repay_flg,chr(13),''),chr(10),'') as adv_repay_flg
,replace(replace(t.adv_repay_int_way_cd,chr(13),''),chr(10),'') as adv_repay_int_way_cd
,replace(replace(t.adv_repay_int_sub_flg,chr(13),''),chr(10),'') as adv_repay_int_sub_flg
,replace(replace(t.auto_deduct_flg,chr(13),''),chr(10),'') as auto_deduct_flg
,replace(replace(t.auto_payoff_loan_flg,chr(13),''),chr(10),'') as auto_payoff_loan_flg
,replace(replace(t.allow_loan_renew_flg,chr(13),''),chr(10),'') as allow_loan_renew_flg
,t.renew_max_cnt as renew_max_cnt
,replace(replace(t.blon_loan_flg,chr(13),''),chr(10),'') as blon_loan_flg
,replace(replace(t.borw_usage_type_comb_cd,chr(13),''),chr(10),'') as borw_usage_type_comb_cd
,replace(replace(t.nomal_int_rat_float_way_cd,chr(13),''),chr(10),'') as nomal_int_rat_float_way_cd
,t.nomal_int_rat_fl_rt as nomal_int_rat_fl_rt
,replace(replace(t.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,replace(replace(t.comp_flg,chr(13),''),chr(10),'') as comp_flg
,t.lowt_exec_int_rat as lowt_exec_int_rat
,t.higt_exec_int_rat as higt_exec_int_rat
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t.init_prod_id,chr(13),''),chr(10),'') as init_prod_id
from iml.prd_retl_loan_prod t
where t.create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_retl_loan_prod.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes