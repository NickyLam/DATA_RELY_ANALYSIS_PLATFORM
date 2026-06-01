: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_pty_corp_party_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_pty_corp_party_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.etl_dt as etl_dt
,t1.open_dt as open_dt
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.open_teller_id,chr(13),''),chr(10),'') as open_teller_id
,replace(replace(t1.setup_chn_typ_cd,chr(13),''),chr(10),'') as setup_chn_typ_cd
,t1.fst_create_cms_rela_year_mon as fst_create_cms_rela_year_mon
,replace(replace(t1.blng_org_id,chr(13),''),chr(10),'') as blng_org_id
,replace(replace(t1.blng_pty_mgr_num,chr(13),''),chr(10),'') as blng_pty_mgr_num
,t1.colse_dt as colse_dt
,replace(replace(t1.colse_org_id,chr(13),''),chr(10),'') as colse_org_id
,replace(replace(t1.colse_teller_id,chr(13),''),chr(10),'') as colse_teller_id
,replace(replace(t1.legal_name,chr(13),''),chr(10),'') as legal_name
,replace(replace(t1.cn_fname,chr(13),''),chr(10),'') as cn_fname
,replace(replace(t1.cn_sname,chr(13),''),chr(10),'') as cn_sname
,replace(replace(t1.piny_name,chr(13),''),chr(10),'') as piny_name
,replace(replace(t1.en_fname,chr(13),''),chr(10),'') as en_fname
,replace(replace(t1.en_sname,chr(13),''),chr(10),'') as en_sname
,replace(replace(t1.pty_typ_cd,chr(13),''),chr(10),'') as pty_typ_cd
,replace(replace(t1.new_pty_risk_pty_typ_cd,chr(13),''),chr(10),'') as new_pty_risk_pty_typ_cd
,replace(replace(t1.pty_org_typ_cd,chr(13),''),chr(10),'') as pty_org_typ_cd
,replace(replace(t1.corp_hold_typ_cd,chr(13),''),chr(10),'') as corp_hold_typ_cd
,replace(replace(t1.pty_blng_indu_cd,chr(13),''),chr(10),'') as pty_blng_indu_cd
,replace(replace(t1.pty_loc_cd,chr(13),''),chr(10),'') as pty_loc_cd
,replace(replace(t1.non_resident_flg,chr(13),''),chr(10),'') as non_resident_flg
,replace(replace(t1.pty_status_cd,chr(13),''),chr(10),'') as pty_status_cd
,t1.estab_dt as estab_dt
,replace(replace(t1.reg_cty_cd,chr(13),''),chr(10),'') as reg_cty_cd
,replace(replace(t1.reg_prov_cd,chr(13),''),chr(10),'') as reg_prov_cd
,replace(replace(t1.reg_city_cd,chr(13),''),chr(10),'') as reg_city_cd
,replace(replace(t1.reg_cuty_cd,chr(13),''),chr(10),'') as reg_cuty_cd
,replace(replace(t1.login_dtl_loc,chr(13),''),chr(10),'') as login_dtl_loc
,replace(replace(t1.login_loc_pst_encd,chr(13),''),chr(10),'') as login_loc_pst_encd
,replace(replace(t1.reg_cap_ccy_cd,chr(13),''),chr(10),'') as reg_cap_ccy_cd
,replace(replace(t1.reg_cap,chr(13),''),chr(10),'') as reg_cap
,replace(replace(t1.rcved_cap_ccy_cd,chr(13),''),chr(10),'') as rcved_cap_ccy_cd
,replace(replace(t1.rcved_cap,chr(13),''),chr(10),'') as rcved_cap
,replace(replace(t1.open_iden_typ_cd,chr(13),''),chr(10),'') as open_iden_typ_cd
,replace(replace(t1.open_iden_num,chr(13),''),chr(10),'') as open_iden_num
,replace(replace(t1.org_typ_cd,chr(13),''),chr(10),'') as org_typ_cd
,replace(replace(t1.economy_typ_cd,chr(13),''),chr(10),'') as economy_typ_cd
,replace(replace(t1.nat_economy_dept_cd,chr(13),''),chr(10),'') as nat_economy_dept_cd
,replace(replace(t1.ghb_base_deposit_acct_flg,chr(13),''),chr(10),'') as ghb_base_deposit_acct_flg
,replace(replace(t1.base_deposit_acct_openbk_num,chr(13),''),chr(10),'') as base_deposit_acct_openbk_num
,replace(replace(t1.base_deposit_acct_openbk_row_n,chr(13),''),chr(10),'') as base_deposit_acct_openbk_row_n
,replace(replace(t1.base_acct_num,chr(13),''),chr(10),'') as base_acct_num
,replace(replace(t1.legal_reps_name,chr(13),''),chr(10),'') as legal_reps_name
,t1.emp_cnt as emp_cnt
,replace(replace(t1.corp_size_gb_cd,chr(13),''),chr(10),'') as corp_size_gb_cd
,replace(replace(t1.corp_size_hb_cd,chr(13),''),chr(10),'') as corp_size_hb_cd
,replace(replace(t1.oper_scope,chr(13),''),chr(10),'') as oper_scope
,replace(replace(t1.mix_biz_range,chr(13),''),chr(10),'') as mix_biz_range
,replace(replace(t1.main_prd_situ,chr(13),''),chr(10),'') as main_prd_situ
,replace(replace(t1.oper_site_area,chr(13),''),chr(10),'') as oper_site_area
,replace(replace(t1.oper_site_owns_cd,chr(13),''),chr(10),'') as oper_site_owns_cd
,replace(replace(t1.ghb_shrholder_flg,chr(13),''),chr(10),'') as ghb_shrholder_flg
,replace(replace(t1.env_and_soci_risk_class_cd,chr(13),''),chr(10),'') as env_and_soci_risk_class_cd
,t1.offic_loc_upda_dt as offic_loc_upda_dt
,replace(replace(t1.csld_soci_crdt_cd,chr(13),''),chr(10),'') as csld_soci_crdt_cd
,replace(replace(t1.cmc_aff_reg_cert_num,chr(13),''),chr(10),'') as cmc_aff_reg_cert_num
,replace(replace(t1.org_org_cd,chr(13),''),chr(10),'') as org_org_cd
,replace(replace(t1.oper_licence_num,chr(13),''),chr(10),'') as oper_licence_num
,t1.oper_licence_reg_dt as oper_licence_reg_dt
,t1.oper_licence_due_dt as oper_licence_due_dt
,replace(replace(t1.nation_tax_reg_cert_num,chr(13),''),chr(10),'') as nation_tax_reg_cert_num
,replace(replace(t1.local_tax_reg_cert_num,chr(13),''),chr(10),'') as local_tax_reg_cert_num
,replace(replace(t1.open_lice_num,chr(13),''),chr(10),'') as open_lice_num
,replace(replace(t1.org_crdt_cd,chr(13),''),chr(10),'') as org_crdt_cd
,replace(replace(t1.loan_card_num,chr(13),''),chr(10),'') as loan_card_num
,replace(replace(t1.pay_biz_lice_num,chr(13),''),chr(10),'') as pay_biz_lice_num
,replace(replace(t1.forgn_invt_reg_cert_num,chr(13),''),chr(10),'') as forgn_invt_reg_cert_num
,replace(replace(t1.im_ex_opr_rit_lice_num,chr(13),''),chr(10),'') as im_ex_opr_rit_lice_num
,replace(replace(t1.chrg_lice_num,chr(13),''),chr(10),'') as chrg_lice_num
,replace(replace(t1.fin_org_ind_num,chr(13),''),chr(10),'') as fin_org_ind_num
,replace(replace(t1.fin_biz_lice_num,chr(13),''),chr(10),'') as fin_biz_lice_num
,replace(replace(t1.insur_biz_lice_num,chr(13),''),chr(10),'') as insur_biz_lice_num
,replace(replace(t1.secu_biz_lice_num,chr(13),''),chr(10),'') as secu_biz_lice_num
,replace(replace(t1.peop_bank_fin_org_encd,chr(13),''),chr(10),'') as peop_bank_fin_org_encd
,replace(replace(t1.swift_num,chr(13),''),chr(10),'') as swift_num
,replace(replace(t1.pay_sys_bank_num,chr(13),''),chr(10),'') as pay_sys_bank_num
,replace(replace(t1.spec_org_cd,chr(13),''),chr(10),'') as spec_org_cd
,replace(replace(t1.fci_num,chr(13),''),chr(10),'') as fci_num
,replace(replace(t1.iban_num,chr(13),''),chr(10),'') as iban_num
,replace(replace(t1.aba_rout_num,chr(13),''),chr(10),'') as aba_rout_num
,replace(replace(t1.right_of_im_ex_flg,chr(13),''),chr(10),'') as right_of_im_ex_flg
,replace(replace(t1.grp_pty_flg,chr(13),''),chr(10),'') as grp_pty_flg
,replace(replace(t1.spec_economy_zone_corp_flg,chr(13),''),chr(10),'') as spec_economy_zone_corp_flg
,replace(replace(t1.ovsea_flg,chr(13),''),chr(10),'') as ovsea_flg
,replace(replace(t1.offsh_flg,chr(13),''),chr(10),'') as offsh_flg
,replace(replace(t1.gov_fin_platf_flg,chr(13),''),chr(10),'') as gov_fin_platf_flg
,replace(replace(t1.ipo_corp_flg,chr(13),''),chr(10),'') as ipo_corp_flg
,replace(replace(t1.cls_corp_flg,chr(13),''),chr(10),'') as cls_corp_flg
,replace(replace(t1.lp_rprs_cust_nbr,chr(13),''),chr(10),'') as lp_rprs_cust_nbr
,replace(replace(t1.fin_org_pty_ind,chr(13),''),chr(10),'') as fin_org_pty_ind
,replace(replace(t1.lvlhd_doma_list_insti_pty_ind,chr(13),''),chr(10),'') as lvlhd_doma_list_insti_pty_ind
,replace(replace(t1.scf_fin_bcs_pty_ind,chr(13),''),chr(10),'') as scf_fin_bcs_pty_ind
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.valid_flag,chr(13),''),chr(10),'') as valid_flag
from ${idl_schema}.hdws_dul_d_ccrm_pty_corp_party_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_pty_corp_party_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes