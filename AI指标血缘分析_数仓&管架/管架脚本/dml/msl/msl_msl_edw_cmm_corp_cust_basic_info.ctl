-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/cmm_corp_cust_basic_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_corp_cust_basic_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,cust_name char(4000) nullif cust_name=blanks 
    ,cust_en_name char(4000) nullif cust_en_name=blanks 
    ,cust_kind_cd char(4000) nullif cust_kind_cd=blanks 
    ,open_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif open_acct_dt=blanks 
    ,belong_org_id char(4000) nullif belong_org_id=blanks 
    ,open_acct_org_id char(4000) nullif open_acct_org_id=blanks 
    ,open_acct_teller_id char(4000) nullif open_acct_teller_id=blanks 
    ,open_acct_chn_cd char(4000) nullif open_acct_chn_cd=blanks 
    ,create_chn_cd char(4000) nullif create_chn_cd=blanks 
    ,cust_mgr_id char(4000) nullif cust_mgr_id=blanks 
    ,cust_type_cd char(4000) nullif cust_type_cd=blanks 
    ,crdt_cust_type_cd char(4000) nullif crdt_cust_type_cd=blanks 
    ,cust_lev_cd char(4000) nullif cust_lev_cd=blanks 
    ,depositr_cate_cd char(4000) nullif depositr_cate_cd=blanks 
    ,bal_pay_way_cd char(4000) nullif bal_pay_way_cd=blanks 
    ,cust_status_cd char(4000) nullif cust_status_cd=blanks 
    ,corp_anl_inco char(4000) nullif corp_anl_inco=blanks 
    ,corp_year_bus_lmt char(4000) nullif corp_year_bus_lmt=blanks 
    ,corp_found_dt date "yyyy-mm-dd hh24:mi:ss" nullif corp_found_dt=blanks 
    ,corp_size_cd char(4000) nullif corp_size_cd=blanks 
    ,indus_categy_cd char(4000) nullif indus_categy_cd=blanks 
    ,indus_type_cd char(4000) nullif indus_type_cd=blanks 
    ,indus_type_cd_crdtc char(4000) nullif indus_type_cd_crdtc=blanks 
    ,phone_crdtc char(4000) nullif phone_crdtc=blanks 
    ,corp_type_cd char(4000) nullif corp_type_cd=blanks 
    ,cty_rg_cd char(4000) nullif cty_rg_cd=blanks 
    ,rg_cd char(4000) nullif rg_cd=blanks 
    ,econ_char_cd char(4000) nullif econ_char_cd=blanks 
    ,econ_type_cd char(4000) nullif econ_type_cd=blanks 
    ,orgnz_cd char(4000) nullif orgnz_cd=blanks 
    ,orgnz_type_cd char(4000) nullif orgnz_type_cd=blanks 
    ,natnal_econ_dept_type_cd char(4000) nullif natnal_econ_dept_type_cd=blanks 
    ,indus_level5_cls_cd char(4000) nullif indus_level5_cls_cd=blanks 
    ,indus_crdt_rating_cd char(4000) nullif indus_crdt_rating_cd=blanks 
    ,soci_crdt_cd char(4000) nullif soci_crdt_cd=blanks 
    ,bus_lics_num char(4000) nullif bus_lics_num=blanks 
    ,bus_lics_exp_dt date "yyyy-mm-dd hh24:mi:ss" nullif bus_lics_exp_dt=blanks 
    ,nation_tax_rgst_cert_num char(4000) nullif nation_tax_rgst_cert_num=blanks 
    ,local_tax_rgst_cert_num char(4000) nullif local_tax_rgst_cert_num=blanks 
    ,fin_lics_num char(4000) nullif fin_lics_num=blanks 
    ,pbc_pay_bank_no char(4000) nullif pbc_pay_bank_no=blanks 
    ,econ_orgnz_form_cd char(4000) nullif econ_orgnz_form_cd=blanks 
    ,loan_card_no char(4000) nullif loan_card_no=blanks 
    ,oper_range char(4000) nullif oper_range=blanks 
    ,emply_qtty char(4000) nullif emply_qtty=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,rgst_cap char(4000) nullif rgst_cap=blanks 
    ,rgst_addr char(4000) nullif rgst_addr=blanks 
    ,rgst_dt date "yyyy-mm-dd hh24:mi:ss" nullif rgst_dt=blanks 
    ,rgstion_cd char(4000) nullif rgstion_cd=blanks 
    ,mang_field_prop_cd char(4000) nullif mang_field_prop_cd=blanks 
    ,corp_rgstion_type char(4000) nullif corp_rgstion_type=blanks 
    ,paid_in_capital char(4000) nullif paid_in_capital=blanks 
    ,paid_in_capital_curr_cd char(4000) nullif paid_in_capital_curr_cd=blanks 
    ,invtor_cty_cd char(4000) nullif invtor_cty_cd=blanks 
    ,mang_field_area char(4000) nullif mang_field_area=blanks 
    ,asset_tot char(4000) nullif asset_tot=blanks 
    ,net_asset_tot char(4000) nullif net_asset_tot=blanks 
    ,single_lp_flg char(4000) nullif single_lp_flg=blanks 
    ,high_new_tech_corp_flg char(4000) nullif high_new_tech_corp_flg=blanks 
    ,rela_party_flg char(4000) nullif rela_party_flg=blanks 
    ,rela_group_type_cd char(4000) nullif rela_group_type_cd=blanks 
    ,lp_org_name char(4000) nullif lp_org_name=blanks 
    ,lp_org_type_cd char(4000) nullif lp_org_type_cd=blanks 
    ,lp_org_cust_id char(4000) nullif lp_org_cust_id=blanks 
    ,group_cust_flg char(4000) nullif group_cust_flg=blanks 
    ,cbrc_sb_flg char(4000) nullif cbrc_sb_flg=blanks 
    ,labor_inte_flg char(4000) nullif labor_inte_flg=blanks 
    ,hold_type_cd char(4000) nullif hold_type_cd=blanks 
    ,off_shore_cust_flg char(4000) nullif off_shore_cust_flg=blanks 
    ,prit_etp_flg char(4000) nullif prit_etp_flg=blanks 
    ,ctysd_corp_flg char(4000) nullif ctysd_corp_flg=blanks 
    ,corp_grow_stage_cd char(4000) nullif corp_grow_stage_cd=blanks 
    ,list_corp_type_cd char(4000) nullif list_corp_type_cd=blanks 
    ,strate_new_indus_cls_cd char(4000) nullif strate_new_indus_cls_cd=blanks 
    ,list_corp_flg char(4000) nullif list_corp_flg=blanks 
    ,strtg_cust_flg char(4000) nullif strtg_cust_flg=blanks 
    ,open_cap char(4000) nullif open_cap=blanks 
    ,crdt_cust_flg char(4000) nullif crdt_cust_flg=blanks 
    ,stament_flg char(4000) nullif stament_flg=blanks 
    ,tax_org_cate_cd char(4000) nullif tax_org_cate_cd=blanks 
    ,tax_resdnt_cty_cd char(4000) nullif tax_resdnt_cty_cd=blanks 
    ,tax_resdnt_idti_cd char(4000) nullif tax_resdnt_idti_cd=blanks 
    ,basic_acct_open_bank_name char(4000) nullif basic_acct_open_bank_name=blanks 
    ,basic_acct_acct_num char(4000) nullif basic_acct_acct_num=blanks 
    ,tax_num char(4000) nullif tax_num=blanks 
    ,tax_num_null_rs_descb char(4000) nullif tax_num_null_rs_descb=blanks 
    ,bel_thi_flg char(4000) nullif bel_thi_flg=blanks 
    ,trast_tax_regi_cert_flg char(4000) nullif trast_tax_regi_cert_flg=blanks 
    ,cty_key_enterp_flg char(4000) nullif cty_key_enterp_flg=blanks 
    ,group_corp_flg char(4000) nullif group_corp_flg=blanks 
    ,group_cust_id char(4000) nullif group_cust_id=blanks 
    ,group_parent_corp_id char(4000) nullif group_parent_corp_id=blanks 
    ,lmt_or_encrge_indus_cd char(4000) nullif lmt_or_encrge_indus_cd=blanks 
    ,have_bod_flg char(4000) nullif have_bod_flg=blanks 
    ,green_crdt_cust_flg char(4000) nullif green_crdt_cust_flg=blanks 
    ,green_crdt_cls_cd char(4000) nullif green_crdt_cls_cd=blanks 
    ,sci_tech_corp_cls_cd char(4000) nullif sci_tech_corp_cls_cd=blanks 
    ,sci_tech_corp_idtfy_dt date "yyyy-mm-dd hh24:mi:ss" nullif sci_tech_corp_idtfy_dt=blanks 
    ,edu_hea_flg char(4000) nullif edu_hea_flg=blanks 
    ,inc_flg char(4000) nullif inc_flg=blanks 
    ,araf_flg char(4000) nullif araf_flg=blanks 
    ,is_mx_mgmt_righ_flg char(4000) nullif is_mx_mgmt_righ_flg=blanks 
    ,escp_debt_corp_flg char(4000) nullif escp_debt_corp_flg=blanks 
    ,is_mx_oper_item_flg char(4000) nullif is_mx_oper_item_flg=blanks 
    ,resdnt_flg char(4000) nullif resdnt_flg=blanks 
    ,dom_overs_flg char(4000) nullif dom_overs_flg=blanks 
    ,work_addr char(4000) nullif work_addr=blanks 
    ,work_addr_zip_cd char(4000) nullif work_addr_zip_cd=blanks 
    ,posta_addr char(4000) nullif posta_addr=blanks 
    ,posta_addr_zip_cd char(4000) nullif posta_addr_zip_cd=blanks 
    ,prod_mang_addr char(4000) nullif prod_mang_addr=blanks 
    ,prod_mang_addr_zip_cd char(4000) nullif prod_mang_addr_zip_cd=blanks 
    ,mang_site_cd char(4000) nullif mang_site_cd=blanks 
    ,crdt_cust_risk_rating_cd char(4000) nullif crdt_cust_risk_rating_cd=blanks 
    ,crdt_cust_risk_rating_start_dt date "yyyy-mm-dd hh24:mi:ss" nullif crdt_cust_risk_rating_start_dt=blanks 
    ,crdt_cust_risk_rating_exp_dt date "yyyy-mm-dd hh24:mi:ss" nullif crdt_cust_risk_rating_exp_dt=blanks 
    ,ownsp_type_cd char(4000) nullif ownsp_type_cd=blanks 
    ,corp_close_flg char(4000) nullif corp_close_flg=blanks 
    ,gover_fin_plat_flg char(4000) nullif gover_fin_plat_flg=blanks 
    ,short_check_blklist_flg char(4000) nullif short_check_blklist_flg=blanks 
    ,fir_lon_dt date "yyyy-mm-dd hh24:mi:ss" nullif fir_lon_dt=blanks 
    ,orgnz_surviv_status_cd char(4000) nullif orgnz_surviv_status_cd=blanks 
    ,corp_idti_idf_type_cd char(4000) nullif corp_idti_idf_type_cd=blanks 
    ,major_contrior_cnt char(4000) nullif major_contrior_cnt=blanks 
    ,actl_ctrler_cnt char(4000) nullif actl_ctrler_cnt=blanks 
    ,fin_dept_phone char(4000) nullif fin_dept_phone=blanks 
    ,group_type_cd char(4000) nullif group_type_cd=blanks 
    ,green_bond_proj_flg char(4000) nullif green_bond_proj_flg=blanks 
    ,stock_cd char(4000) nullif stock_cd=blanks 
    ,dep_class_cust_flg char(4000) nullif dep_class_cust_flg=blanks 
    ,loan_class_cust_flg char(4000) nullif loan_class_cust_flg=blanks 
    ,guar_class_cust_flg char(4000) nullif guar_class_cust_flg=blanks 
    ,anti_mon_lau_belong_org_id char(4000) nullif anti_mon_lau_belong_org_id=blanks 
)