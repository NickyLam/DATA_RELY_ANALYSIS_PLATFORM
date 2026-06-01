: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_cust_basic_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_corp_cust_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id 
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name 
,replace(replace(t1.cust_en_name,chr(13),''),chr(10),'') as cust_en_name 
,replace(replace(t1.cust_kind_cd,chr(13),''),chr(10),'') as cust_kind_cd 
,t1.open_acct_dt as open_acct_dt 
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id 
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id 
,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd 
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id 
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd 
,replace(replace(t1.cust_lev_cd,chr(13),''),chr(10),'') as cust_lev_cd 
,replace(replace(t1.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd 
,replace(replace(t1.bal_pay_way_cd,chr(13),''),chr(10),'') as bal_pay_way_cd 
,replace(replace(t1.cust_status_cd,chr(13),''),chr(10),'') as cust_status_cd 
,t1.corp_anl_inco as corp_anl_inco 
,t1.corp_year_bus_lmt as corp_year_bus_lmt 
,t1.corp_found_dt as corp_found_dt 
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd 
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd 
,replace(replace(t1.indus_type_cd_crdtc,chr(13),''),chr(10),'') as indus_type_cd_crdtc 
,replace(replace(t1.phone_crdtc,chr(13),''),chr(10),'') as phone_crdtc 
,replace(replace(t1.corp_type_cd,chr(13),''),chr(10),'') as corp_type_cd 
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd 
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd 
,replace(replace(t1.econ_char_cd,chr(13),''),chr(10),'') as econ_char_cd 
,replace(replace(t1.econ_type_cd,chr(13),''),chr(10),'') as econ_type_cd 
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd 
,replace(replace(t1.orgnz_type_cd,chr(13),''),chr(10),'') as orgnz_type_cd 
,replace(replace(t1.natnal_econ_dept_type_cd,chr(13),''),chr(10),'') as natnal_econ_dept_type_cd 
,replace(replace(t1.indus_level5_cls_cd,chr(13),''),chr(10),'') as indus_level5_cls_cd 
,replace(replace(t1.indus_crdt_rating_cd,chr(13),''),chr(10),'') as indus_crdt_rating_cd 
,replace(replace(t1.soci_crdt_cd,chr(13),''),chr(10),'') as soci_crdt_cd 
,replace(replace(t1.bus_lics_num,chr(13),''),chr(10),'') as bus_lics_num 
,t1.bus_lics_exp_dt as bus_lics_exp_dt 
,replace(replace(t1.nation_tax_rgst_cert_num,chr(13),''),chr(10),'') as nation_tax_rgst_cert_num 
,replace(replace(t1.local_tax_rgst_cert_num,chr(13),''),chr(10),'') as local_tax_rgst_cert_num 
,replace(replace(t1.fin_lics_num,chr(13),''),chr(10),'') as fin_lics_num 
,replace(replace(t1.econ_orgnz_form_cd,chr(13),''),chr(10),'') as econ_orgnz_form_cd 
,replace(replace(t1.oper_range,chr(13),''),chr(10),'') as oper_range 
,t1.emply_qtty as emply_qtty 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,t1.rgst_cap as rgst_cap 
,replace(replace(t1.rgst_addr,chr(13),''),chr(10),'') as rgst_addr 
,t1.rgst_dt as rgst_dt 
,replace(replace(t1.rgstion_cd,chr(13),''),chr(10),'') as rgstion_cd 
,replace(replace(t1.mang_field_prop_cd,chr(13),''),chr(10),'') as mang_field_prop_cd 
,replace(replace(t1.corp_rgstion_type,chr(13),''),chr(10),'') as corp_rgstion_type 
,t1.paid_in_capital as paid_in_capital 
,replace(replace(t1.paid_in_capital_curr_cd,chr(13),''),chr(10),'') as paid_in_capital_curr_cd 
,replace(replace(t1.invtor_cty_cd,chr(13),''),chr(10),'') as invtor_cty_cd 
,t1.mang_field_area as mang_field_area 
,t1.asset_tot as asset_tot 
,t1.net_asset_tot as net_asset_tot 
,replace(replace(t1.single_lp_flg,chr(13),''),chr(10),'') as single_lp_flg 
,replace(replace(t1.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg 
,replace(replace(t1.rela_party_flg,chr(13),''),chr(10),'') as rela_party_flg 
,replace(replace(t1.rela_group_type_cd,chr(13),''),chr(10),'') as rela_group_type_cd 
,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg 
,replace(replace(t1.cbrc_sb_flg,chr(13),''),chr(10),'') as cbrc_sb_flg 
,replace(replace(t1.hold_type_cd,chr(13),''),chr(10),'') as hold_type_cd 
,replace(replace(t1.off_shore_cust_flg,chr(13),''),chr(10),'') as off_shore_cust_flg 
,replace(replace(t1.prit_etp_flg,chr(13),''),chr(10),'') as prit_etp_flg 
,replace(replace(t1.ctysd_corp_flg,chr(13),''),chr(10),'') as ctysd_corp_flg 
,replace(replace(t1.list_corp_type_cd,chr(13),''),chr(10),'') as list_corp_type_cd 
,replace(replace(t1.list_corp_flg,chr(13),''),chr(10),'') as list_corp_flg 
,t1.open_cap as open_cap 
,replace(replace(t1.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg 
,replace(replace(t1.stament_flg,chr(13),''),chr(10),'') as stament_flg 
,replace(replace(t1.tax_org_cate_cd,chr(13),''),chr(10),'') as tax_org_cate_cd 
,replace(replace(t1.tax_resdnt_cty_cd,chr(13),''),chr(10),'') as tax_resdnt_cty_cd 
,replace(replace(t1.tax_resdnt_idti_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_cd 
,replace(replace(t1.tax_num,chr(13),''),chr(10),'') as tax_num 
,replace(replace(t1.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb 
,replace(replace(t1.bel_thi_flg,chr(13),''),chr(10),'') as bel_thi_flg 
,replace(replace(t1.trast_tax_regi_cert_flg,chr(13),''),chr(10),'') as trast_tax_regi_cert_flg 
,replace(replace(t1.cty_key_enterp_flg,chr(13),''),chr(10),'') as cty_key_enterp_flg 
,replace(replace(t1.group_corp_flg,chr(13),''),chr(10),'') as group_corp_flg 
,replace(replace(t1.group_cust_id,chr(13),''),chr(10),'') as group_cust_id 
,replace(replace(t1.group_parent_corp_id,chr(13),''),chr(10),'') as group_parent_corp_id 
,replace(replace(t1.lmt_or_encrge_indus_cd,chr(13),''),chr(10),'') as lmt_or_encrge_indus_cd 
,replace(replace(t1.have_bod_flg,chr(13),''),chr(10),'') as have_bod_flg 
,replace(replace(t1.green_crdt_cust_flg,chr(13),''),chr(10),'') as green_crdt_cust_flg 
,replace(replace(t1.araf_flg,chr(13),''),chr(10),'') as araf_flg 
,replace(replace(t1.is_mx_mgmt_righ_flg,chr(13),''),chr(10),'') as is_mx_mgmt_righ_flg 
,replace(replace(t1.escp_debt_corp_flg,chr(13),''),chr(10),'') as escp_debt_corp_flg 
,replace(replace(t1.is_mx_oper_item_flg,chr(13),''),chr(10),'') as is_mx_oper_item_flg 
,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg 
,replace(replace(t1.work_addr,chr(13),''),chr(10),'') as work_addr 
,replace(replace(t1.work_addr_zip_cd,chr(13),''),chr(10),'') as work_addr_zip_cd 
,replace(replace(t1.posta_addr,chr(13),''),chr(10),'') as posta_addr 
,replace(replace(t1.posta_addr_zip_cd,chr(13),''),chr(10),'') as posta_addr_zip_cd 
,replace(replace(t1.crdt_cust_risk_rating_cd,chr(13),''),chr(10),'') as crdt_cust_risk_rating_cd 
,t1.crdt_cust_risk_rating_start_dt as crdt_cust_risk_rating_start_dt 
,t1.crdt_cust_risk_rating_exp_dt as crdt_cust_risk_rating_exp_dt 
,replace(replace(t1.ownsp_type_cd,chr(13),''),chr(10),'') as ownsp_type_cd 
,replace(replace(t1.corp_close_flg,chr(13),''),chr(10),'') as corp_close_flg 
,replace(replace(t1.pbc_pay_bank_no,chr(13),''),chr(10),'') as pbc_pay_bank_no 
,replace(replace(t1.crdt_cust_type_cd,chr(13),''),chr(10),'') as crdt_cust_type_cd 
,replace(replace(t1.indus_categy_cd,chr(13),''),chr(10),'') as indus_categy_cd 
,replace(replace(t1.gover_fin_plat_flg,chr(13),''),chr(10),'') as gover_fin_plat_flg 
,replace(replace(t1.labor_inte_flg,chr(13),''),chr(10),'') as labor_inte_flg 
,replace(replace(t1.corp_grow_stage_cd,chr(13),''),chr(10),'') as corp_grow_stage_cd 
,replace(replace(t1.edu_hea_flg,chr(13),''),chr(10),'') as edu_hea_flg 
,replace(replace(t1.inc_flg,chr(13),''),chr(10),'') as inc_flg 
,replace(replace(t1.short_check_blklist_flg,chr(13),''),chr(10),'') as short_check_blklist_flg 
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id 
,replace(replace(t1.loan_card_no,chr(13),''),chr(10),'') as loan_card_no 
,t1.fir_lon_dt as fir_lon_dt 
from ${icl_schema}.cmm_corp_cust_basic_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_cust_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes