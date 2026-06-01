: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_trust_prod_f
CreateDate: 20221021
FileName:   ${iel_data_path}/prd_trust_prod.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(prod_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(belong_cate_cd,chr(13),''),chr(10),'')
,replace(replace(prod_tepla,chr(13),''),chr(10),'')
,replace(replace(prod_cate_cd,chr(13),''),chr(10),'')
,replace(replace(ta_cd,chr(13),''),chr(10),'')
,replace(replace(std_prod_id,chr(13),''),chr(10),'')
,replace(replace(init_prod_id,chr(13),''),chr(10),'')
,replace(replace(prod_name,chr(13),''),chr(10),'')
,replace(replace(prod_descb,chr(13),''),chr(10),'')
,prod_nv
,nv_dt
,nv_days
,prod_fac_val
,issue_price
,replace(replace(prod_sponsor_id,chr(13),''),chr(10),'')
,replace(replace(prod_trustee_id,chr(13),''),chr(10),'')
,replace(replace(prod_mger_id,chr(13),''),chr(10),'')
,replace(replace(prod_host_dept_id,chr(13),''),chr(10),'')
,replace(replace(prod_host_org_id,chr(13),''),chr(10),'')
,coll_start_dt
,coll_end_dt
,prod_found_dt
,prod_value_dt
,prod_end_dt
,int_closing_dt
,prft_exp_dt
,aft_coll_close_exp_dt
,actl_found_dt
,prod_lowt_coll_amt
,prod_higt_coll_amt
,prod_lowt_coll_lot
,prod_higt_coll_lot
,prod_actl_coll_amt
,prod_curr_size
,replace(replace(allow_divd_way_cd,chr(13),''),chr(10),'')
,replace(replace(deflt_divd_way_cd,chr(13),''),chr(10),'')
,replace(replace(sell_rg_ctrl_flg,chr(13),''),chr(10),'')
,replace(replace(lmt_ctrl_flg_cd,chr(13),''),chr(10),'')
,replace(replace(coll_term_acct_mode_cd,chr(13),''),chr(10),'')
,replace(replace(open_term_acct_mode_cd,chr(13),''),chr(10),'')
,replace(replace(chn_cd_comb,chr(13),''),chr(10),'')
,replace(replace(allow_cust_type_cd_comb,chr(13),''),chr(10),'')
,replace(replace(tepla_flg_cd,chr(13),''),chr(10),'')
,replace(replace(ctrl_flg_comb,chr(13),''),chr(10),'')
,replace(replace(bta_ctrl_flg_comb,chr(13),''),chr(10),'')
,replace(replace(charge_way_cd,chr(13),''),chr(10),'')
,replace(replace(out_charge_flg,chr(13),''),chr(10),'')
,replace(replace(subscr_export_mode_cd,chr(13),''),chr(10),'')
,replace(replace(prft_embody_way_cd,chr(13),''),chr(10),'')
,replace(replace(prod_attr_cd,chr(13),''),chr(10),'')
,replace(replace(risk_level_cd,chr(13),''),chr(10),'')
,replace(replace(estim_level_cd,chr(13),''),chr(10),'')
,replace(replace(status_cd,chr(13),''),chr(10),'')
,replace(replace(tran_flg_cd,chr(13),''),chr(10),'')
,prod_curr_tot_lot
,prod_acm_nv
,replace(replace(curr_cd,chr(13),''),chr(10),'')
,replace(replace(prft_curr_cd,chr(13),''),chr(10),'')
,replace(replace(ec_flg,chr(13),''),chr(10),'')
,replace(replace(discnt_way_cd,chr(13),''),chr(10),'')
,replace(replace(open_tm,chr(13),''),chr(10),'')
,replace(replace(close_tm,chr(13),''),chr(10),'')
,indv_min_buy_corp
,indv_fir_lowt_invest_amt
,indv_supp_lowt_invest_amt
,indv_lowt_aip_amt
,indv_lowt_hold_lot
,indv_sig_least_redem_lot
,indv_sig_max_redem_lot
,indv_redem_corp
,indv_lowt_fund_tran_lot
,indv_lowt_reg_redem_lot
,indv_sig_max_buy_amt
,indv_single_acct_amax_bamt
,replace(replace(coll_start_tm,chr(13),''),chr(10),'')
,aip_fail_cnt
,replace(replace(sp_acct_id,chr(13),''),chr(10),'')
,replace(replace(redem_acct_id,chr(13),''),chr(10),'')
,replace(replace(comm_fee_assign_acct_id,chr(13),''),chr(10),'')
,replace(replace(mgmt_fee_assign_acct_id,chr(13),''),chr(10),'')
,redem_cap_avl_days
,divd_cap_avl_days
,prod_exp_cap_avl_days
,issue_fail_refund_days
,prod_int_accr_base
,subscr_int_accr_base
,mgmt_fee_base_days
,expe_yld_rat
,ped_days
,replace(replace(tard_way_cd,chr(13),''),chr(10),'')
,replace(replace(prod_tepla_id,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.prd_trust_prod t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_trust_prod.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
