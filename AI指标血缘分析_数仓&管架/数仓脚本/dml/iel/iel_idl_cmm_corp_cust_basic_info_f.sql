: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cmm_corp_cust_basic_info_f
CreateDate: 20221121
FileName:   ${iel_data_path}/cmm_corp_cust_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lp_id as lp_id
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.cust_en_name as cust_en_name
,t1.cust_kind_cd as cust_kind_cd
,t1.open_acct_dt as open_acct_dt
,t1.belong_org_id as belong_org_id
,t1.open_acct_org_id as open_acct_org_id
,t1.open_acct_teller_id as open_acct_teller_id
,t1.open_acct_chn_cd as open_acct_chn_cd
,t1.create_chn_cd as create_chn_cd
,t1.cust_mgr_id as cust_mgr_id
,t1.cust_type_cd as cust_type_cd
,t1.crdt_cust_type_cd as crdt_cust_type_cd
,t1.cust_lev_cd as cust_lev_cd
,t1.depositr_cate_cd as depositr_cate_cd
,t1.bal_pay_way_cd as bal_pay_way_cd
,t1.cust_status_cd as cust_status_cd
,t1.corp_anl_inco as corp_anl_inco
,t1.corp_year_bus_lmt as corp_year_bus_lmt
,t1.corp_found_dt as corp_found_dt
,t1.corp_size_cd as corp_size_cd
,t1.indus_categy_cd as indus_categy_cd
,t1.indus_type_cd as indus_type_cd
,t1.indus_type_cd_crdtc as indus_type_cd_crdtc
,t1.phone_crdtc as phone_crdtc
,t1.corp_type_cd as corp_type_cd
,t1.cty_rg_cd as cty_rg_cd
,t1.rg_cd as rg_cd
,t1.econ_char_cd as econ_char_cd
,t1.econ_type_cd as econ_type_cd
,t1.orgnz_cd as orgnz_cd
,t1.orgnz_type_cd as orgnz_type_cd
,t1.natnal_econ_dept_type_cd as natnal_econ_dept_type_cd
,t1.indus_level5_cls_cd as indus_level5_cls_cd
,t1.indus_crdt_rating_cd as indus_crdt_rating_cd
,t1.soci_crdt_cd as soci_crdt_cd
,t1.bus_lics_num as bus_lics_num
,t1.bus_lics_exp_dt as bus_lics_exp_dt
,t1.nation_tax_rgst_cert_num as nation_tax_rgst_cert_num
,t1.local_tax_rgst_cert_num as local_tax_rgst_cert_num
,t1.fin_lics_num as fin_lics_num
,t1.pbc_pay_bank_no as pbc_pay_bank_no
,t1.econ_orgnz_form_cd as econ_orgnz_form_cd
,t1.loan_card_no as loan_card_no
,t1.oper_range as oper_range
,t1.emply_qtty as emply_qtty
,t1.curr_cd as curr_cd
,t1.rgst_cap as rgst_cap
,t1.rgst_addr as rgst_addr
,t1.rgst_dt as rgst_dt
,t1.rgstion_cd as rgstion_cd
,t1.mang_field_prop_cd as mang_field_prop_cd
,t1.corp_rgstion_type as corp_rgstion_type
,t1.paid_in_capital as paid_in_capital
,t1.paid_in_capital_curr_cd as paid_in_capital_curr_cd
,t1.invtor_cty_cd as invtor_cty_cd
,t1.mang_field_area as mang_field_area
,t1.asset_tot as asset_tot
,t1.net_asset_tot as net_asset_tot
,t1.single_lp_flg as single_lp_flg
,t1.high_new_tech_corp_flg as high_new_tech_corp_flg
,t1.rela_party_flg as rela_party_flg
,t1.rela_group_type_cd as rela_group_type_cd
,t1.lp_org_name as lp_org_name
,t1.lp_org_type_cd as lp_org_type_cd
,t1.lp_org_cust_id as lp_org_cust_id
,t1.group_cust_flg as group_cust_flg
,t1.cbrc_sb_flg as cbrc_sb_flg
,t1.labor_inte_flg as labor_inte_flg
,t1.hold_type_cd as hold_type_cd
,t1.off_shore_cust_flg as off_shore_cust_flg
,t1.prit_etp_flg as prit_etp_flg
,t1.ctysd_corp_flg as ctysd_corp_flg
,t1.corp_grow_stage_cd as corp_grow_stage_cd
,t1.list_corp_type_cd as list_corp_type_cd
,t1.strate_new_indus_cls_cd as strate_new_indus_cls_cd
,t1.list_corp_flg as list_corp_flg
,t1.strtg_cust_flg as strtg_cust_flg
,t1.open_cap as open_cap
,t1.crdt_cust_flg as crdt_cust_flg
,t1.stament_flg as stament_flg
,t1.tax_org_cate_cd as tax_org_cate_cd
,t1.tax_resdnt_cty_cd as tax_resdnt_cty_cd
,t1.tax_resdnt_idti_cd as tax_resdnt_idti_cd
,t1.basic_acct_open_bank_name as basic_acct_open_bank_name
,t1.basic_acct_acct_num as basic_acct_acct_num
,t1.tax_num as tax_num
,t1.tax_num_null_rs_descb as tax_num_null_rs_descb
,t1.bel_thi_flg as bel_thi_flg
,t1.trast_tax_regi_cert_flg as trast_tax_regi_cert_flg
,t1.cty_key_enterp_flg as cty_key_enterp_flg
,t1.group_corp_flg as group_corp_flg
,t1.group_cust_id as group_cust_id
,t1.group_parent_corp_id as group_parent_corp_id
,t1.lmt_or_encrge_indus_cd as lmt_or_encrge_indus_cd
,t1.have_bod_flg as have_bod_flg
,t1.green_crdt_cust_flg as green_crdt_cust_flg
,t1.green_crdt_cls_cd as green_crdt_cls_cd
,t1.sci_tech_corp_cls_cd as sci_tech_corp_cls_cd
,t1.sci_tech_corp_idtfy_dt as sci_tech_corp_idtfy_dt
,t1.edu_hea_flg as edu_hea_flg
,t1.inc_flg as inc_flg
,t1.araf_flg as araf_flg
,t1.is_mx_mgmt_righ_flg as is_mx_mgmt_righ_flg
,t1.escp_debt_corp_flg as escp_debt_corp_flg
,t1.is_mx_oper_item_flg as is_mx_oper_item_flg
,t1.resdnt_flg as resdnt_flg
,t1.dom_overs_flg as dom_overs_flg
,t1.work_addr as work_addr
,t1.work_addr_zip_cd as work_addr_zip_cd
,t1.posta_addr as posta_addr
,t1.posta_addr_zip_cd as posta_addr_zip_cd
,t1.prod_mang_addr as prod_mang_addr
,t1.prod_mang_addr_zip_cd as prod_mang_addr_zip_cd
,t1.mang_site_cd as mang_site_cd
,t1.crdt_cust_risk_rating_cd as crdt_cust_risk_rating_cd
,t1.crdt_cust_risk_rating_start_dt as crdt_cust_risk_rating_start_dt
,t1.crdt_cust_risk_rating_exp_dt as crdt_cust_risk_rating_exp_dt
,t1.ownsp_type_cd as ownsp_type_cd
,t1.corp_close_flg as corp_close_flg
,t1.gover_fin_plat_flg as gover_fin_plat_flg
,t1.short_check_blklist_flg as short_check_blklist_flg
,t1.fir_lon_dt as fir_lon_dt
,t1.orgnz_surviv_status_cd as orgnz_surviv_status_cd
,t1.corp_idti_idf_type_cd as corp_idti_idf_type_cd
,t1.major_contrior_cnt as major_contrior_cnt
,t1.actl_ctrler_cnt as actl_ctrler_cnt
,t1.fin_dept_phone as fin_dept_phone
,t1.group_type_cd as group_type_cd
,t1.green_bond_proj_flg as green_bond_proj_flg
,t1.stock_cd as stock_cd
,t1.dep_class_cust_flg as dep_class_cust_flg
,t1.loan_class_cust_flg as loan_class_cust_flg
,t1.guar_class_cust_flg as guar_class_cust_flg
,t1.anti_mon_lau_belong_org_id as anti_mon_lau_belong_org_id

from ${idl_schema}.cmm_corp_cust_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_cust_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
