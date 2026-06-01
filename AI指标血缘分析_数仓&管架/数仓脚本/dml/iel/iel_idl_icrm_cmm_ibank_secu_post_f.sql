: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_cmm_ibank_secu_post_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_cmm_ibank_secu_post.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,lp_id
    ,ext_secu_acct_id
    ,intnal_secu_acct_id
    ,fin_instm_id
    ,asset_type_id
    ,market_type_id
    ,bus_id
    ,prod_type_cd
    ,asset_type_name
    ,level5_cls_cd
    ,subj_id
    ,acct_name
    ,tran_market_id
    ,exchg_acct_id
    ,issuer_id
    ,issuer_name
    ,stl_site_id
    ,stl_site_name
    ,tran_num
    ,extra_dimen_cd
    ,curr_cd
    ,actl_qtty
    ,actl_bal
    ,net_price_cost
    ,acru_int
    ,int_cost
    ,evha_val_chag
    ,recvbl_uncol_bal
    ,recvbl_uncol_net_price_cost
    ,recvbl_uncol_acru_int
    ,int_adj_amt
    ,actl_int_rat
    ,invest_yld_rat
    ,open_yld_rat
    ,amort_dt
    ,stl_dt
    ,open_dt
    ,last_update_dt
    ,cap_type_cd
    ,asset_four_cls_cd
    ,belong_org_id
    ,std_prod_id
    ,comb_tran_num
    ,obj_id
    ,apv_form_num
    ,int_subj_id
    ,int_adj_subj_id
    ,acru_int_inco_subj_id
    ,amort_int_income_subj_id
    ,evha_val_chag_pl_subj_id
    ,spd_pl_subj_id
    ,currt_bal
    ,int_recvbl
    ,td_nv
    ,fir_stl_dt
    ,asset_thd_cls_cd
    ,tran_amt
    ,evha_val_chag_pl
    ,spd_pl
    ,acru_int_inco
    ,amort_int_inco
    ,ftp_prop_cate
    ,ftp_spread
    ,ncds_issue_org_id
    ,ncds_issue_org_name
    ,ovdue_status
    ,ovdue_flg
    ,pric_ovdue_dt
    ,pric_ovdue_days
    ,int_ovdue_dt
    ,int_ovdue_days
    ,intnal_secu_acct_status_cd
    ,cntpty_acct_id
    ,evha_val_chag_subj_id
    ,acru_int_inco_vat_subj_id
    ,amort_int_income_vat_subj_id
    ,spd_pl_vat_subj_id
    ,currt_acru_int
    ,ref_int_rat
    ,fac_val_int_rat
    ,tran_dt
    ,value_dt
    ,exp_dt
    ,int_income
    ,acru_int_inco_should_tax_flg
    ,amort_int_income_should_tax_flg
    ,spd_pl_should_tax_flg
    ,acru_int_inco_tax_rat
    ,amort_int_income_tax_rat
    ,spd_pl_tax_rat
    ,acru_int_inco_tax_lmt
    ,amort_int_income_tax_lmt
    ,spd_pl_tax_lmt
    ,is_th_ssn_redem
    ,curr_issue_build_up_pos_dt
    ,expe_redem_dt
    ,tran_hold_idf
    ,apot_tenor_dep_flg
    ,apot_tenor_start_dt
    ,apot_tenor_end_dt
    ,apot_tenor_amt
    ,tran_cost_accti_method_cd
    ,cross_bor_depo_takof_inter_flg
    ,cross_bor_depo_takof_inter_sign_value_dt
    ,cross_bor_depo_takof_inter_sign_exp_dt
from idl.icrm_cmm_ibank_secu_post 
  where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_cmm_ibank_secu_post.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes