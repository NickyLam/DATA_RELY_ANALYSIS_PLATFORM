: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_loan_prod_info_f
CreateDate: 20221227
FileName:   ${iel_data_path}/cmm_loan_prod_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.super_prod_id,chr(13),''),chr(10),'') as super_prod_id
,replace(replace(t1.lmt_prod_flg,chr(13),''),chr(10),'') as lmt_prod_flg
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,replace(replace(t1.in_out_tab_attr_cd,chr(13),''),chr(10),'') as in_out_tab_attr_cd
,prod_effect_dt
,prod_invalid_dt
,replace(replace(t1.prod_edit_id,chr(13),''),chr(10),'') as prod_edit_id
,replace(replace(t1.cust_type_comb_cd,chr(13),''),chr(10),'') as cust_type_comb_cd
,replace(replace(t1.dom_overs_comb_cd,chr(13),''),chr(10),'') as dom_overs_comb_cd
,replace(replace(t1.curr_comb_cd,chr(13),''),chr(10),'') as curr_comb_cd
,replace(replace(t1.repay_way_comb_cd,chr(13),''),chr(10),'') as repay_way_comb_cd
,replace(replace(t1.guar_way_comb_cd,chr(13),''),chr(10),'') as guar_way_comb_cd
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.discnt_loan_type_cd,chr(13),''),chr(10),'') as discnt_loan_type_cd
,replace(replace(t1.repay_amt_ctrl_cd,chr(13),''),chr(10),'') as repay_amt_ctrl_cd
,replace(replace(t1.bf_col_int_flg,chr(13),''),chr(10),'') as bf_col_int_flg
,replace(replace(t1.lont_loan_tenor,chr(13),''),chr(10),'') as lont_loan_tenor
,replace(replace(t1.shortest_loan_tenor,chr(13),''),chr(10),'') as shortest_loan_tenor
,replace(replace(t1.subtn_deduct_flg,chr(13),''),chr(10),'') as subtn_deduct_flg
,replace(replace(t1.auto_callbk_flg,chr(13),''),chr(10),'') as auto_callbk_flg
,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg
,replace(replace(t1.bar_flg,chr(13),''),chr(10),'') as bar_flg
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t1.comp_int_flg,chr(13),''),chr(10),'') as comp_int_flg
,replace(replace(t1.pnlt_flg,chr(13),''),chr(10),'') as pnlt_flg
,replace(replace(t1.pnlt_comp_int_flg,chr(13),''),chr(10),'') as pnlt_comp_int_flg
,replace(replace(t1.comp_int_comp_int_flg,chr(13),''),chr(10),'') as comp_int_comp_int_flg
,replace(replace(t1.renew_flg,chr(13),''),chr(10),'') as renew_flg
,replace(replace(t1.max_renew_cnt,chr(13),''),chr(10),'') as max_renew_cnt
,replace(replace(t1.soterm_flg,chr(13),''),chr(10),'') as soterm_flg
,replace(replace(t1.max_soterm_cnt,chr(13),''),chr(10),'') as max_soterm_cnt
,replace(replace(t1.grace_period_corp_cd,chr(13),''),chr(10),'') as grace_period_corp_cd
,replace(replace(t1.grace_period,chr(13),''),chr(10),'') as grace_period
,replace(replace(t1.sig_distr_flg,chr(13),''),chr(10),'') as sig_distr_flg
,replace(replace(t1.sig_distr_amt_ctrl_flg,chr(13),''),chr(10),'') as sig_distr_amt_ctrl_flg
,replace(replace(t1.sig_distr_max_amt,chr(13),''),chr(10),'') as sig_distr_max_amt
,replace(replace(t1.sig_distr_min_amt,chr(13),''),chr(10),'') as sig_distr_min_amt
,replace(replace(t1.sel_sup_loan_flg,chr(13),''),chr(10),'') as sel_sup_loan_flg
,replace(replace(t1.syn_loan_char_cd,chr(13),''),chr(10),'') as syn_loan_char_cd
,replace(replace(t1.int_rat_ped_cd,chr(13),''),chr(10),'') as int_rat_ped_cd
,replace(replace(t1.lowt_exec_int_rat,chr(13),''),chr(10),'') as lowt_exec_int_rat
,replace(replace(t1.higt_exec_int_rat,chr(13),''),chr(10),'') as higt_exec_int_rat
,replace(replace(t1.ovdue_int_rat_float_way_cd,chr(13),''),chr(10),'') as ovdue_int_rat_float_way_cd
,replace(replace(t1.ovdue_int_rat_float_ratio,chr(13),''),chr(10),'') as ovdue_int_rat_float_ratio
,replace(replace(t1.crdtc_grace_period,chr(13),''),chr(10),'') as crdtc_grace_period

from ${icl_schema}.cmm_loan_prod_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_loan_prod_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
