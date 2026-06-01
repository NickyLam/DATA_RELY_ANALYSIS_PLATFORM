: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_pty_corp_party_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_pty_corp_party_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
,etl_dt
,open_dt
,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
,replace(replace(open_teller_id,chr(10),''),chr(13),'') as open_teller_id
,replace(replace(setup_chn_typ_cd,chr(10),''),chr(13),'') as setup_chn_typ_cd
,fst_create_cms_rela_year_mon
,replace(replace(blng_org_id,chr(10),''),chr(13),'') as blng_org_id
,replace(replace(blng_pty_mgr_num,chr(10),''),chr(13),'') as blng_pty_mgr_num
,colse_dt
,replace(replace(colse_org_id,chr(10),''),chr(13),'') as colse_org_id
,replace(replace(colse_teller_id,chr(10),''),chr(13),'') as colse_teller_id
,replace(replace(legal_name,chr(10),''),chr(13),'') as legal_name
,replace(replace(cn_fname,chr(10),''),chr(13),'') as cn_fname
,replace(replace(cn_sname,chr(10),''),chr(13),'') as cn_sname
,replace(replace(piny_name,chr(10),''),chr(13),'') as piny_name
,replace(replace(en_fname,chr(10),''),chr(13),'') as en_fname
,replace(replace(en_sname,chr(10),''),chr(13),'') as en_sname
,replace(replace(pty_typ_cd,chr(10),''),chr(13),'') as pty_typ_cd
,replace(replace(new_pty_risk_pty_typ_cd,chr(10),''),chr(13),'') as new_pty_risk_pty_typ_cd
,replace(replace(pty_org_typ_cd,chr(10),''),chr(13),'') as pty_org_typ_cd
,replace(replace(corp_hold_typ_cd,chr(10),''),chr(13),'') as corp_hold_typ_cd
,replace(replace(pty_blng_indu_cd,chr(10),''),chr(13),'') as pty_blng_indu_cd
,replace(replace(indu_typ_cd_gb,chr(10),''),chr(13),'') as indu_typ_cd_gb
,replace(replace(indu_categ5_cd,chr(10),''),chr(13),'') as indu_categ5_cd
,replace(replace(indu_crdt_rat_cd,chr(10),''),chr(13),'') as indu_crdt_rat_cd
,replace(replace(indu_typ_cd,chr(10),''),chr(13),'') as indu_typ_cd
,replace(replace(pty_level_cd,chr(10),''),chr(13),'') as pty_level_cd
,replace(replace(owns_typ_cd,chr(10),''),chr(13),'') as owns_typ_cd
,replace(replace(pty_loc_cd,chr(10),''),chr(13),'') as pty_loc_cd
,replace(replace(non_resident_flg,chr(10),''),chr(13),'') as non_resident_flg
,replace(replace(pty_status_cd,chr(10),''),chr(13),'') as pty_status_cd
,estab_dt
,replace(replace(reg_cty_cd,chr(10),''),chr(13),'') as reg_cty_cd
,replace(replace(reg_prov_cd,chr(10),''),chr(13),'') as reg_prov_cd
,replace(replace(reg_city_cd,chr(10),''),chr(13),'') as reg_city_cd
,replace(replace(reg_cuty_cd,chr(10),''),chr(13),'') as reg_cuty_cd
,replace(replace(login_dtl_loc,chr(10),''),chr(13),'') as login_dtl_loc
,replace(replace(login_loc_pst_encd,chr(10),''),chr(13),'') as login_loc_pst_encd
,replace(replace(reg_cap_ccy_cd,chr(10),''),chr(13),'') as reg_cap_ccy_cd
,replace(replace(reg_cap,chr(10),''),chr(13),'') as reg_cap
,replace(replace(rcved_cap_ccy_cd,chr(10),''),chr(13),'') as rcved_cap_ccy_cd
,replace(replace(rcved_cap,chr(10),''),chr(13),'') as rcved_cap
,replace(replace(open_iden_typ_cd,chr(10),''),chr(13),'') as open_iden_typ_cd
,replace(replace(open_iden_num,chr(10),''),chr(13),'') as open_iden_num
,replace(replace(org_typ_cd,chr(10),''),chr(13),'') as org_typ_cd
,replace(replace(economy_typ_cd,chr(10),''),chr(13),'') as economy_typ_cd
,replace(replace(nat_economy_dept_cd,chr(10),''),chr(13),'') as nat_economy_dept_cd
,replace(replace(ghb_base_deposit_acct_flg,chr(10),''),chr(13),'') as ghb_base_deposit_acct_flg
,replace(replace(base_deposit_acct_openbk_num,chr(10),''),chr(13),'') as base_deposit_acct_openbk_num
,replace(replace(base_deposit_acct_openbk_row_n,chr(10),''),chr(13),'') as base_deposit_acct_openbk_row_n
,replace(replace(base_acct_num,chr(10),''),chr(13),'') as base_acct_num
,replace(replace(legal_reps_name,chr(10),''),chr(13),'') as legal_reps_name
,replace(replace(legal_rep_cust_num,chr(10),''),chr(13),'') as legal_rep_cust_num
,replace(replace(lp_rprs_proof_bk_id,chr(10),''),chr(13),'') as lp_rprs_proof_bk_id
,emp_cnt
,replace(replace(corp_size_gb_cd,chr(10),''),chr(13),'') as corp_size_gb_cd
,replace(replace(corp_size_hb_cd,chr(10),''),chr(13),'') as corp_size_hb_cd
,replace(replace(oper_scope,chr(10),''),chr(13),'') as oper_scope
,replace(replace(mix_biz_range,chr(10),''),chr(13),'') as mix_biz_range
,replace(replace(main_prd_situ,chr(10),''),chr(13),'') as main_prd_situ
,replace(replace(oper_site_area,chr(10),''),chr(13),'') as oper_site_area
,replace(replace(oper_site_owns_cd,chr(10),''),chr(13),'') as oper_site_owns_cd
,replace(replace(ghb_shrholder_flg,chr(10),''),chr(13),'') as ghb_shrholder_flg
,replace(replace(env_and_soci_risk_class_cd,chr(10),''),chr(13),'') as env_and_soci_risk_class_cd
,offic_loc_upda_dt
,replace(replace(csld_soci_crdt_cd,chr(10),''),chr(13),'') as csld_soci_crdt_cd
,replace(replace(cmc_aff_reg_cert_num,chr(10),''),chr(13),'') as cmc_aff_reg_cert_num
,replace(replace(org_org_cd,chr(10),''),chr(13),'') as org_org_cd
,replace(replace(oper_licence_num,chr(10),''),chr(13),'') as oper_licence_num
,oper_licence_reg_dt
,oper_licence_due_dt
,year_check_due_day
,replace(replace(nation_tax_reg_cert_num,chr(10),''),chr(13),'') as nation_tax_reg_cert_num
,replace(replace(local_tax_reg_cert_num,chr(10),''),chr(13),'') as local_tax_reg_cert_num
,replace(replace(open_lice_num,chr(10),''),chr(13),'') as open_lice_num
,replace(replace(org_crdt_cd,chr(10),''),chr(13),'') as org_crdt_cd
,replace(replace(loan_card_num,chr(10),''),chr(13),'') as loan_card_num
,replace(replace(pay_biz_lice_num,chr(10),''),chr(13),'') as pay_biz_lice_num
,replace(replace(forgn_invt_reg_cert_num,chr(10),''),chr(13),'') as forgn_invt_reg_cert_num
,replace(replace(im_ex_opr_rit_lice_num,chr(10),''),chr(13),'') as im_ex_opr_rit_lice_num
,replace(replace(chrg_lice_num,chr(10),''),chr(13),'') as chrg_lice_num
,replace(replace(fin_org_ind_num,chr(10),''),chr(13),'') as fin_org_ind_num
,replace(replace(fin_biz_lice_num,chr(10),''),chr(13),'') as fin_biz_lice_num
,replace(replace(insur_biz_lice_num,chr(10),''),chr(13),'') as insur_biz_lice_num
,replace(replace(secu_biz_lice_num,chr(10),''),chr(13),'') as secu_biz_lice_num
,replace(replace(peop_bank_fin_org_encd,chr(10),''),chr(13),'') as peop_bank_fin_org_encd
,replace(replace(swift_num,chr(10),''),chr(13),'') as swift_num
,replace(replace(pay_sys_bank_num,chr(10),''),chr(13),'') as pay_sys_bank_num
,replace(replace(spec_org_cd,chr(10),''),chr(13),'') as spec_org_cd
,replace(replace(fci_num,chr(10),''),chr(13),'') as fci_num
,replace(replace(iban_num,chr(10),''),chr(13),'') as iban_num
,replace(replace(aba_rout_num,chr(10),''),chr(13),'') as aba_rout_num
,replace(replace(right_of_im_ex_flg,chr(10),''),chr(13),'') as right_of_im_ex_flg
,replace(replace(grp_pty_flg,chr(10),''),chr(13),'') as grp_pty_flg
,replace(replace(spec_economy_zone_corp_flg,chr(10),''),chr(13),'') as spec_economy_zone_corp_flg
,replace(replace(ovsea_flg,chr(10),''),chr(13),'') as ovsea_flg
,replace(replace(offsh_flg,chr(10),''),chr(13),'') as offsh_flg
,replace(replace(gov_fin_platf_flg,chr(10),''),chr(13),'') as gov_fin_platf_flg
,replace(replace(ipo_corp_flg,chr(10),''),chr(13),'') as ipo_corp_flg
,replace(replace(ipo_mrkt_cd,chr(10),''),chr(13),'') as ipo_mrkt_cd
,ipo_dt
,replace(replace(stock_cd,chr(10),''),chr(13),'') as stock_cd
,cap_stock_amt
,replace(replace(stock_stats_cd,chr(10),''),chr(13),'') as stock_stats_cd
,curr_shr
,replace(replace(cls_corp_flg,chr(10),''),chr(13),'') as cls_corp_flg
,replace(replace(treas_org_pty_flg,chr(10),''),chr(13),'') as treas_org_pty_flg
,replace(replace(lvlhd_doma_flg,chr(10),''),chr(13),'') as lvlhd_doma_flg
,replace(replace(scf_fin_bcs_pty_flg,chr(10),''),chr(13),'') as scf_fin_bcs_pty_flg
,replace(replace(crdt_pty_flg,chr(10),''),chr(13),'') as crdt_pty_flg
,replace(replace(co_brand_pty_flg,chr(10),''),chr(13),'') as co_brand_pty_flg
,replace(replace(cty_imp_corp_flg,chr(10),''),chr(13),'') as cty_imp_corp_flg
,replace(replace(occu_grp_pty_lmt_flg,chr(10),''),chr(13),'') as occu_grp_pty_lmt_flg
,replace(replace(assoc_txn_flg,chr(10),''),chr(13),'') as assoc_txn_flg
,anl_inc
,ast_total_amt
,net_ast_total_amt
,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd 
from idl.hdws_dul_d_opr_pty_corp_party_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_pty_corp_party_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes