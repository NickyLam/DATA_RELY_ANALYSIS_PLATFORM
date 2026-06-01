: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_prd_finc_f
CreateDate: 20251222
FileName:   ${iel_data_path}/prd_finc.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,replace(replace(t1.prod_belong_cate_cd,chr(13),''),chr(10),'') as prod_belong_cate_cd
,replace(replace(t1.ref_yld_rat_comnt,chr(13),''),chr(10),'') as ref_yld_rat_comnt
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.prod_alias,chr(13),''),chr(10),'') as prod_alias
,prod_nv
,prod_fac_val
,issue_price
,replace(replace(t1.prod_sponsor_cd,chr(13),''),chr(10),'') as prod_sponsor_cd
,replace(replace(t1.prod_trustee_cd,chr(13),''),chr(10),'') as prod_trustee_cd
,replace(replace(t1.prod_mger_cd,chr(13),''),chr(10),'') as prod_mger_cd
,replace(replace(t1.prod_host_org_id,chr(13),''),chr(10),'') as prod_host_org_id
,coll_start_dt
,coll_end_dt
,prod_found_dt
,prod_value_dt
,prod_end_dt
,prft_exp_dt
,coll_fail_dt
,coll_post_close_exp_day
,actl_found_dt
,prod_lowt_coll_amt
,prod_higt_coll_amt
,prod_lowt_coll_lot
,prod_higt_coll_lot
,prod_actl_coll_amt
,curr_size
,replace(replace(t1.allow_divd_way_cd,chr(13),''),chr(10),'') as allow_divd_way_cd
,replace(replace(t1.deflt_divd_way_cd,chr(13),''),chr(10),'') as deflt_divd_way_cd
,replace(replace(t1.sell_rg_ctrl_flg,chr(13),''),chr(10),'') as sell_rg_ctrl_flg
,replace(replace(t1.lmt_ctrl_flg,chr(13),''),chr(10),'') as lmt_ctrl_flg
,replace(replace(t1.coll_term_acct_mode_cd,chr(13),''),chr(10),'') as coll_term_acct_mode_cd
,replace(replace(t1.open_term_acct_mode_cd,chr(13),''),chr(10),'') as open_term_acct_mode_cd
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t1.allow_cust_group_list,chr(13),''),chr(10),'') as allow_cust_group_list
,replace(replace(t1.ctrl_flg,chr(13),''),chr(10),'') as ctrl_flg
,replace(replace(t1.bta_ctrl_flg,chr(13),''),chr(10),'') as bta_ctrl_flg
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,replace(replace(t1.prft_embody_way_cd,chr(13),''),chr(10),'') as prft_embody_way_cd
,replace(replace(t1.prod_attr_cd,chr(13),''),chr(10),'') as prod_attr_cd
,replace(replace(t1.risk_level_cd,chr(13),''),chr(10),'') as risk_level_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.tran_flg,chr(13),''),chr(10),'') as tran_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t1.open_tm,chr(13),''),chr(10),'') as open_tm
,replace(replace(t1.close_tm,chr(13),''),chr(10),'') as close_tm
,indv_min_buy_corp
,indv_fir_lowt_invest_amt
,indv_supp_lowt_invest_amt
,indv_lowt_aip_amt
,indv_lowt_hold_lot
,indv_sig_least_redem_lot
,indv_sig_max_redem_lot
,indv_redem_corp
,indv_lowt_fund_tran_lot
,indv_sig_max_buy_amt
,indv_single_acct_amax_bamt
,org_min_buy_corp
,org_fir_lowt_invest_amt
,org_supp_lowt_invest_amt
,org_lowt_aip_amt
,org_lowt_hold_lot
,org_sig_min_redem_lot
,org_sig_max_redem_lot
,org_redem_corp
,org_lowt_fund_tran_lot
,org_sig_max_buy_amt
,org_single_acct_amax_bamt
,replace(replace(t1.coll_start_tm,chr(13),''),chr(10),'') as coll_start_tm
,replace(replace(t1.buy_acct_id,chr(13),''),chr(10),'') as buy_acct_id
,replace(replace(t1.redem_acct_id,chr(13),''),chr(10),'') as redem_acct_id
,replace(replace(t1.realtm_redem_adv_exp_acct_id,chr(13),''),chr(10),'') as realtm_redem_adv_exp_acct_id
,redem_cap_avl_days
,divd_cap_avl_days
,prod_exp_cap_avl_days
,huge_redem_ratio
,prod_int_accr_base
,subscr_int_accr_base
,mgmt_fee_base_days
,expe_yld_rat
,ped_days
,replace(replace(t1.tard_way_cd,chr(13),''),chr(10),'') as tard_way_cd
,replace(replace(t1.prod_tepla_id,chr(13),''),chr(10),'') as prod_tepla_id
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.supt_buy_way_cd,chr(13),''),chr(10),'') as supt_buy_way_cd
,replace(replace(t1.prod_cbond_id,chr(13),''),chr(10),'') as prod_cbond_id
from ${iml_schema}.prd_finc t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_finc.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
