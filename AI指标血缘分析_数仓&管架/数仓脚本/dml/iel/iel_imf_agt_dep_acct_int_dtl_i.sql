: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_dep_acct_int_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_dep_acct_int_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,replace(replace(t1.int_provi_ped,chr(13),''),chr(10),'') as int_provi_ped
,t1.next_provi_dt as next_provi_dt
,t1.last_provi_dt as last_provi_dt
,replace(replace(t1.int_set_flg,chr(13),''),chr(10),'') as int_set_flg
,replace(replace(t1.cap_flg,chr(13),''),chr(10),'') as cap_flg
,t1.next_int_set_dt as next_int_set_dt
,t1.last_int_set_dt as last_int_set_dt
,t1.last_real_int_set_dt as last_real_int_set_dt
,t1.day_bf_last_int_set_dt as day_bf_last_int_set_dt
,replace(replace(t1.int_set_freq_cd,chr(13),''),chr(10),'') as int_set_freq_cd
,t1.provi_day as provi_day
,t1.pay_int_day as pay_int_day
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t1.int_rat_effect_way_cd,chr(13),''),chr(10),'') as int_rat_effect_way_cd
,t1.bank_int_int_rat as bank_int_int_rat
,replace(replace(t1.int_rat_float_cate_cd,chr(13),''),chr(10),'') as int_rat_float_cate_cd
,t1.float_int_rat as float_int_rat
,t1.int_rat_float_ratio as int_rat_float_ratio
,t1.int_rat_float_point as int_rat_float_point
,t1.sub_acct_fix_int_rat as sub_acct_fix_int_rat
,t1.sub_acct_int_rat_float_ratio as sub_acct_int_rat_float_ratio
,t1.sub_acct_int_rat_float_point as sub_acct_int_rat_float_point
,t1.exec_int_rat as exec_int_rat
,t1.deflt_int_rat as deflt_int_rat
,replace(replace(t1.int_rat_seg_flg,chr(13),''),chr(10),'') as int_rat_seg_flg
,t1.exec_int_rat_lolmi as exec_int_rat_lolmi
,t1.exec_int_rat_uplmi as exec_int_rat_uplmi
,replace(replace(t1.mon_int_accr_base_cd,chr(13),''),chr(10),'') as mon_int_accr_base_cd
,replace(replace(t1.year_int_accr_base_cd,chr(13),''),chr(10),'') as year_int_accr_base_cd
,t1.acm_provi_int as acm_provi_int
,t1.accum as accum
,t1.provi_day_provi_actl_amt as provi_day_provi_actl_amt
,t1.provi_day_provi_int as provi_day_provi_int
,t1.provi_amt_bal as provi_amt_bal
,t1.ld_acm_provi_int as ld_acm_provi_int
,t1.dep_term_provi_acm_int as dep_term_provi_acm_int
,t1.int_adj_add_amt as int_adj_add_amt
,t1.provi_day_int_adj_amt as provi_day_int_adj_amt
,t1.ld_acm_int_adj_amt as ld_acm_int_adj_amt
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,t1.int_set_amt as int_set_amt
,t1.int_set_day_int_amt as int_set_day_int_amt
,t1.int_accr_surp_days as int_accr_surp_days
,t1.ld_bf_pay_int_amt as ld_bf_pay_int_amt
,t1.value_dt as value_dt
,t1.exp_dt as exp_dt
,replace(replace(t1.int_rat_start_use_way_cd,chr(13),''),chr(10),'') as int_rat_start_use_way_cd
,replace(replace(t1.last_int_rat_start_use_way_cd,chr(13),''),chr(10),'') as last_int_rat_start_use_way_cd
,t1.int_rat_modif_day as int_rat_modif_day
,t1.int_rat_modif_ped as int_rat_modif_ped
,replace(replace(t1.accrd_nomal_int_rat_float_flg,chr(13),''),chr(10),'') as accrd_nomal_int_rat_float_flg
,t1.last_int_rat_modif_dt as last_int_rat_modif_dt
,t1.next_int_rat_modif_dt as next_int_rat_modif_dt
,t1.provi_begin_day as provi_begin_day
,t1.currt_acm_int_accr_days as currt_acm_int_accr_days
,t1.currt_last_provi_dt as currt_last_provi_dt
,t1.agt_prefr_amt as agt_prefr_amt
,t1.int_amt as int_amt
,replace(replace(t1.tax_category_cd,chr(13),''),chr(10),'') as tax_category_cd
,t1.tax_rat as tax_rat
,t1.sub_acct_fix_tax_rat as sub_acct_fix_tax_rat
,t1.sub_acct_tax_rat_float_ratio as sub_acct_tax_rat_float_ratio
,t1.sub_acct_tax_rat_float_point as sub_acct_tax_rat_float_point
,t1.curr_int_tax_acm_amt as curr_int_tax_acm_amt
,t1.provi_day_int_tax_init_amt as provi_day_int_tax_init_amt
,t1.provi_day_int_tax as provi_day_int_tax
,t1.int_tax_bal as int_tax_bal
,t1.int_set_day_int_tax as int_set_day_int_tax
,t1.int_tax_acm_amt as int_tax_acm_amt
,t1.stock_int_tax as stock_int_tax
,replace(replace(t1.agt_chg_way_cd,chr(13),''),chr(10),'') as agt_chg_way_cd
,t1.agt_accum as agt_accum
,t1.agt_float_ratio as agt_float_ratio
,replace(replace(t1.sign_layered_int_rat_type_cd,chr(13),''),chr(10),'') as sign_layered_int_rat_type_cd
,t1.back_nature_day_days as back_nature_day_days
,t1.back_wd_days as back_wd_days
,replace(replace(t1.deduct_int_flg,chr(13),''),chr(10),'') as deduct_int_flg
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,t1.tran_tm as tran_tm
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
from ${iml_schema}.agt_dep_acct_int_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_int_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes