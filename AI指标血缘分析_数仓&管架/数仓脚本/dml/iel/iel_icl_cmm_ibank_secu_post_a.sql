: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_ibank_secu_post_a
CreateDate: 20240424
FileName:   ${iel_data_path}/cmm_ibank_secu_post.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'') as intnal_secu_acct_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.tran_market_id,chr(13),''),chr(10),'') as tran_market_id
,replace(replace(t1.exchg_acct_id,chr(13),''),chr(10),'') as exchg_acct_id
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
,replace(replace(t1.stl_site_id,chr(13),''),chr(10),'') as stl_site_id
,replace(replace(t1.stl_site_name,chr(13),''),chr(10),'') as stl_site_name
,replace(replace(t1.tran_num,chr(13),''),chr(10),'') as tran_num
,replace(replace(t1.extra_dimen_cd,chr(13),''),chr(10),'') as extra_dimen_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
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
,replace(replace(t1.cap_type_cd,chr(13),''),chr(10),'') as cap_type_cd
,replace(replace(t1.asset_four_cls_cd,chr(13),''),chr(10),'') as asset_four_cls_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.comb_tran_num,chr(13),''),chr(10),'') as comb_tran_num
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.apv_form_num,chr(13),''),chr(10),'') as apv_form_num
,replace(replace(t1.int_subj_id,chr(13),''),chr(10),'') as int_subj_id
,replace(replace(t1.int_adj_subj_id,chr(13),''),chr(10),'') as int_adj_subj_id
,replace(replace(t1.acru_int_inco_subj_id,chr(13),''),chr(10),'') as acru_int_inco_subj_id
,replace(replace(t1.amort_int_income_subj_id,chr(13),''),chr(10),'') as amort_int_income_subj_id
,replace(replace(t1.evha_val_chag_pl_subj_id,chr(13),''),chr(10),'') as evha_val_chag_pl_subj_id
,replace(replace(t1.spd_pl_subj_id,chr(13),''),chr(10),'') as spd_pl_subj_id
,currt_bal
,int_recvbl
,td_nv
,fir_stl_dt
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
,tran_amt
,evha_val_chag_pl
,spd_pl
,acru_int_inco
,amort_int_inco
,replace(replace(t1.ftp_prop_cate,chr(13),''),chr(10),'') as ftp_prop_cate
,ftp_spread
,replace(replace(t1.ncds_issue_org_id,chr(13),''),chr(10),'') as ncds_issue_org_id
,replace(replace(t1.ncds_issue_org_name,chr(13),''),chr(10),'') as ncds_issue_org_name
,replace(replace(t1.ovdue_status,chr(13),''),chr(10),'') as ovdue_status
,replace(replace(t1.ovdue_flg,chr(13),''),chr(10),'') as ovdue_flg
,pric_ovdue_dt
,pric_ovdue_days
,int_ovdue_dt
,int_ovdue_days
,replace(replace(t1.evha_val_chag_subj_id,chr(13),''),chr(10),'') as evha_val_chag_subj_id
,replace(replace(t1.acru_int_inco_vat_subj_id,chr(13),''),chr(10),'') as acru_int_inco_vat_subj_id
,replace(replace(t1.amort_int_income_vat_subj_id,chr(13),''),chr(10),'') as amort_int_income_vat_subj_id
,replace(replace(t1.spd_pl_vat_subj_id,chr(13),''),chr(10),'') as spd_pl_vat_subj_id
,tran_dt
,value_dt
,exp_dt
,acru_int_inco_should_tax_flg
,amort_int_income_should_tax_flg
,spd_pl_should_tax_flg
,acru_int_inco_tax_rat
,amort_int_income_tax_rat
,spd_pl_tax_rat
,acru_int_inco_tax_lmt
,amort_int_income_tax_lmt
,spd_pl_tax_lmt
,replace(replace(t1.is_th_ssn_redem,chr(13),''),chr(10),'') as is_th_ssn_redem
,expe_redem_dt
,replace(replace(t1.tran_hold_idf,chr(13),''),chr(10),'') as tran_hold_idf
,replace(replace(t1.apot_tenor_dep_flg,chr(13),''),chr(10),'') as apot_tenor_dep_flg
,apot_tenor_start_dt
,apot_tenor_end_dt
,currt_acru_int
,replace(replace(t1.tran_cost_accti_method_cd,chr(13),''),chr(10),'') as tran_cost_accti_method_cd
,int_income
,replace(replace(t1.intnal_secu_acct_status_cd,chr(13),''),chr(10),'') as intnal_secu_acct_status_cd
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,curr_issue_build_up_pos_dt
,ref_int_rat
,apot_tenor_amt
,fac_val_int_rat
,replace(replace(t1.cross_bor_depo_takof_inter_flg,chr(13),''),chr(10),'') as cross_bor_depo_takof_inter_flg
,cross_bor_depo_takof_inter_sign_value_dt
,cross_bor_depo_takof_inter_sign_exp_dt
,replace(replace(t1.crdt_fin_instm_id,chr(13),''),chr(10),'') as crdt_fin_instm_id
,replace(replace(t1.asset_uniq_idf_id,chr(13),''),chr(10),'') as asset_uniq_idf_id
,replace(replace(t1.recvbl_uncol_int_subj_id,chr(13),''),chr(10),'') as recvbl_uncol_int_subj_id
,replace(replace(t1.intnal_secu_acct_acctnt_cls_cd,chr(13),''),chr(10),'') as intnal_secu_acct_acctnt_cls_cd
,replace(replace(t1.intnal_secu_acct_acctnt_cls_name,chr(13),''),chr(10),'') as intnal_secu_acct_acctnt_cls_name
,replace(replace(t1.sell_org_name_comb,chr(13),''),chr(10),'') as sell_org_name_comb
,replace(replace(t1.sell_org_pct_comnt,chr(13),''),chr(10),'') as sell_org_pct_comnt
,replace(replace(t1.belong_org_name_comb,chr(13),''),chr(10),'') as belong_org_name_comb
,replace(replace(t1.belong_org_pct_comnt,chr(13),''),chr(10),'') as belong_org_pct_comnt

from ${icl_schema}.cmm_ibank_secu_post t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('20240101','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ibank_secu_post.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
