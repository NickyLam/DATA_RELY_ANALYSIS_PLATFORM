: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_acct_auto_redt_agt_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_dep_acct_auto_redt_agt_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dep_agt_id,chr(13),''),chr(10),'') as dep_agt_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.plan_id,chr(13),''),chr(10),'') as plan_id
,replace(replace(t1.sign_agt_type_cd,chr(13),''),chr(10),'') as sign_agt_type_cd
,replace(replace(t1.sign_agt_status_cd,chr(13),''),chr(10),'') as sign_agt_status_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_prod_id,chr(13),''),chr(10),'') as acct_prod_id
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.acct_sub_acct_num,chr(13),''),chr(10),'') as acct_sub_acct_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,t1.sub_acct_fix_int_rat as sub_acct_fix_int_rat
,t1.sub_acct_int_rat_float_ratio as sub_acct_int_rat_float_ratio
,t1.sub_acct_int_rat_float_point as sub_acct_int_rat_float_point
,replace(replace(t1.dep_term_tenor,chr(13),''),chr(10),'') as dep_term_tenor
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,t1.lowt_redt_amt as lowt_redt_amt
,replace(replace(t1.redt_by_agt_way_cd,chr(13),''),chr(10),'') as redt_by_agt_way_cd
,replace(replace(t1.redt_mode_cd,chr(13),''),chr(10),'') as redt_mode_cd
,t1.tran_acct_mult as tran_acct_mult
,t1.tran_amt as tran_amt
,t1.bal_ratio as bal_ratio
,t1.acm_tran_acct_amt as acm_tran_acct_amt
,t1.tran_acct_base as tran_acct_base
,t1.mini_guart_amt as mini_guart_amt
,replace(replace(t1.redt_acct_type_cd,chr(13),''),chr(10),'') as redt_acct_type_cd
,t1.finc_fix_amt as finc_fix_amt
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num
,replace(replace(t1.cntpty_acct_prod_id,chr(13),''),chr(10),'') as cntpty_acct_prod_id
,replace(replace(t1.cntpty_acct_curr_cd,chr(13),''),chr(10),'') as cntpty_acct_curr_cd
,replace(replace(t1.cntpty_acct_sub_acct_num,chr(13),''),chr(10),'') as cntpty_acct_sub_acct_num
,replace(replace(t1.cntpty_bank_no,chr(13),''),chr(10),'') as cntpty_bank_no
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_acct_type_cd,chr(13),''),chr(10),'') as cntpty_acct_type_cd
,replace(replace(t1.pric_int_enter_sub_acct_num,chr(13),''),chr(10),'') as pric_int_enter_sub_acct_num
,replace(replace(t1.pric_int_enter_acct_cust_acct_num,chr(13),''),chr(10),'') as pric_int_enter_acct_cust_acct_num
,replace(replace(t1.pric_int_enter_curr_cd,chr(13),''),chr(10),'') as pric_int_enter_curr_cd
,replace(replace(t1.pric_int_enter_prod_id,chr(13),''),chr(10),'') as pric_int_enter_prod_id
,replace(replace(t1.stl_acct_curr_cd,chr(13),''),chr(10),'') as stl_acct_curr_cd
,replace(replace(t1.stl_acct_sub_acct_num,chr(13),''),chr(10),'') as stl_acct_sub_acct_num
,replace(replace(t1.stl_cust_acct_num,chr(13),''),chr(10),'') as stl_cust_acct_num
,replace(replace(t1.stl_acct_prod_id,chr(13),''),chr(10),'') as stl_acct_prod_id
,replace(replace(t1.loan_rs_cd,chr(13),''),chr(10),'') as loan_rs_cd
,replace(replace(t1.prior_level,chr(13),''),chr(10),'') as prior_level
,t1.acm_track_cnt as acm_track_cnt
,t1.acm_tran_acct_cnt as acm_tran_acct_cnt
,t1.subtn_tran_cnt as subtn_tran_cnt
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,t1.sign_dt as sign_dt
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
,replace(replace(t1.auto_payoff_flg,chr(13),''),chr(10),'') as auto_payoff_flg
,replace(replace(t1.open_cnt_type_cd,chr(13),''),chr(10),'') as open_cnt_type_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_dep_acct_auto_redt_agt_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_auto_redt_agt_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes