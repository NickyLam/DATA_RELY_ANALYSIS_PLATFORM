: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_cust_attach_info_f
CreateDate: 20260109
FileName:   ${iel_data_path}/cmm_corp_cust_attach_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.adv_man_indu_flg,chr(13),''),chr(10),'') as adv_man_indu_flg
,replace(replace(t1.spe_soph_unq_new_med_side_enter_flg,chr(13),''),chr(10),'') as spe_soph_unq_new_med_side_enter_flg
,replace(replace(t1.spe_soph_unq_new_lte_gnt_corp_flg,chr(13),''),chr(10),'') as spe_soph_unq_new_lte_gnt_corp_flg
,replace(replace(t1.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg
,replace(replace(t1.open_acct_lics_id,chr(13),''),chr(10),'') as open_acct_lics_id
,open_acct_lics_apprv_dt
,replace(replace(t1.bnft_owner_idtfy_status_cd,chr(13),''),chr(10),'') as bnft_owner_idtfy_status_cd
,replace(replace(t1.bnft_owner_type_cd,chr(13),''),chr(10),'') as bnft_owner_type_cd
,replace(replace(t1.latest_update_teller_id,chr(13),''),chr(10),'') as latest_update_teller_id
,replace(replace(t1.latest_update_org_id,chr(13),''),chr(10),'') as latest_update_org_id
,replace(replace(t1.latest_update_chn_cd,chr(13),''),chr(10),'') as latest_update_chn_cd
,latest_update_tm
,replace(replace(t1.only_public_market_bus_flg,chr(13),''),chr(10),'') as only_public_market_bus_flg
,replace(replace(t1.indust_park_corp_flg,chr(13),''),chr(10),'') as indust_park_corp_flg
,replace(replace(t1.agri_property_lead_enterp_flg,chr(13),''),chr(10),'') as agri_property_lead_enterp_flg
,replace(replace(t1.farm_and_new_agri_mang_main_loan_flg,chr(13),''),chr(10),'') as farm_and_new_agri_mang_main_loan_flg
,replace(replace(t1.invest_cust_flg,chr(13),''),chr(10),'') as invest_cust_flg
,asset_liab_ratio
,replace(replace(t1.major_foul_behav_flg,chr(13),''),chr(10),'') as major_foul_behav_flg
,replace(replace(t1.fin_data_update_flg,chr(13),''),chr(10),'') as fin_data_update_flg
,replace(replace(t1.fin_data_report_prd,chr(13),''),chr(10),'') as fin_data_report_prd
,replace(replace(t1.fin_data_rept_type_cd,chr(13),''),chr(10),'') as fin_data_rept_type_cd
,fin_stat_dt
,replace(replace(t1.risk_dist_cd,chr(13),''),chr(10),'') as risk_dist_cd
,replace(replace(t1.lei_id,chr(13),''),chr(10),'') as lei_id
,replace(replace(t1.sel_sup_cust_flg_cd,chr(13),''),chr(10),'') as sel_sup_cust_flg_cd
,replace(replace(t1.work_rg_dist_cd,chr(13),''),chr(10),'') as work_rg_dist_cd
,replace(replace(t1.basic_open_bank_no,chr(13),''),chr(10),'') as basic_open_bank_no
,replace(replace(t1.role_type_cd,chr(13),''),chr(10),'') as role_type_cd
,replace(replace(t1.digit_econ_type_cd,chr(13),''),chr(10),'') as digit_econ_type_cd
,mger_member_number
,replace(replace(t1.bnft_owner_attr_cd_comb,chr(13),''),chr(10),'') as bnft_owner_attr_cd_comb
,replace(replace(t1.non_rec_rs,chr(13),''),chr(10),'') as non_rec_rs
,replace(replace(t1.blklist_cust_flg,chr(13),''),chr(10),'') as blklist_cust_flg
,up_blklist_dt
,replace(replace(t1.up_blklist_rs,chr(13),''),chr(10),'') as up_blklist_rs
,replace(replace(t1.tax_auth_proof_descb,chr(13),''),chr(10),'') as tax_auth_proof_descb
,replace(replace(t1.cty_tech_inovt_corp_flg,chr(13),''),chr(10),'') as cty_tech_inovt_corp_flg
,replace(replace(t1.item_corp_flg,chr(13),''),chr(10),'') as item_corp_flg
,replace(replace(t1.inovt_med_side_enter_flg,chr(13),''),chr(10),'') as inovt_med_side_enter_flg
,replace(replace(t1.scen_tech_med_side_enter_flg,chr(13),''),chr(10),'') as scen_tech_med_side_enter_flg
,replace(replace(t1.cty_corp_tech_center_flg,chr(13),''),chr(10),'') as cty_corp_tech_center_flg
,replace(replace(t1.each_class_scen_tech_list_corp_flg,chr(13),''),chr(10),'') as each_class_scen_tech_list_corp_flg
,replace(replace(t1.cross_bor_cust_flg,chr(13),''),chr(10),'') as cross_bor_cust_flg
,replace(replace(t1.chain_proj_cust_flg,chr(13),''),chr(10),'') as chain_proj_cust_flg

from ${icl_schema}.cmm_corp_cust_attach_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_cust_attach_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
