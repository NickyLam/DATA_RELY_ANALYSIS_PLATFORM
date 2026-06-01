: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_corp_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_pty_corp.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.depositr_cate_cd as depositr_cate_cd
,t1.corp_name as corp_name
,t1.corp_en_name as corp_en_name
,t1.soci_crdt_cd as soci_crdt_cd
,t1.curr_cd as curr_cd
,t1.rgst_cap as rgst_cap
,t1.rgst_addr as rgst_addr
,t1.cty_rg_cd as cty_rg_cd
,t1.indus_type_cd as indus_type_cd
,t1.econ_char_cd as econ_char_cd
,t1.taxpayer_idtfy_num as taxpayer_idtfy_num
,t1.corp_type_cd as corp_type_cd
,t1.tax_stament_flg as tax_stament_flg
,t1.tax_org_cate_cd as tax_org_cate_cd
,t1.tax_resdnt_cty_cd as tax_resdnt_cty_cd
,t1.tax_resdnt_idti_cd as tax_resdnt_idti_cd
,t1.emply_qtty as emply_qtty
,t1.fin_subsidy_inco_src_cd as fin_subsidy_inco_src_cd
,t1.strategy_camp_cust_no as strategy_camp_cust_no
,t1.ins_adj_type_cd as ins_adj_type_cd
,t1.single_lmt as single_lmt
,t1.single_lp_flg as single_lp_flg
,t1.high_new_tech_corp_flg as high_new_tech_corp_flg
,t1.itau_flg as itau_flg
,t1.rela_party_flg as rela_party_flg
,t1.rela_group_type_cd as rela_group_type_cd
,t1.org_type_cd as org_type_cd
,t1.org_status_cd as org_status_cd
,t1.group_cust_flg as group_cust_flg
,t1.weight_risk_asset_cust_cls_cd as weight_risk_asset_cust_cls_cd
,t1.cbrc_sb_flg as cbrc_sb_flg
,t1.econ_type_cd as econ_type_cd
,t1.oper_range as oper_range
,t1.cust_sev_ugd_cls_cd as cust_sev_ugd_cls_cd
,t1.hold_type_cd as hold_type_cd
,t1.off_shore_cust_flg as off_shore_cust_flg
,t1.subj_org_name as subj_org_name
,t1.prit_etp_flg as prit_etp_flg
,t1.ctysd_corp_flg as ctysd_corp_flg
,t1.corp_found_dt as corp_found_dt
,t1.corp_size_cd as corp_size_cd
,t1.corp_size_cd_intnal as corp_size_cd_intnal
,t1.ta_cust_size as ta_cust_size
,t1.ta_cust_indus_status as ta_cust_indus_status
,t1.list_corp_type_cd as list_corp_type_cd
,t1.list_corp_flg as list_corp_flg
,t1.crdt_strategy_cd as crdt_strategy_cd
,t1.crdt_cust_flg as crdt_cust_flg
,t1.bel_thi_flg as bel_thi_flg
,t1.rgst_dt as rgst_dt
,t1.orgnz_type_cd as orgnz_type_cd
,t1.orgnz_type_subdv_cd as orgnz_type_subdv_cd
,t1.econ_orgnz_form_cd as econ_orgnz_form_cd
,t1.trast_tax_regi_cert_flg as trast_tax_regi_cert_flg
,t1.fin_stat_type_cd as fin_stat_type_cd
,t1.jnor_cog_over_number as jnor_cog_over_number
,t1.cty_key_enterp_flg as cty_key_enterp_flg
,t1.natnal_econ_dept_type_cd as natnal_econ_dept_type_cd
,t1.indus_type_cd_level5_cls as indus_type_cd_level5_cls
,t1.indus_type_cd_crdt_rating as indus_type_cd_crdt_rating
,t1.org_subj as org_subj
,t1.group_corp_flg as group_corp_flg
,t1.group_cust_id as group_cust_id
,t1.resdnt_flg as resdnt_flg
,t1.open_cap as open_cap
,t1.cust_lev_cd as cust_lev_cd
,t1.retire_number as retire_number
,t1.super_director_dept as super_director_dept
,t1.cause_lp_size_or_lev_cd as cause_lp_size_or_lev_cd
,t1.cause_lp_cust_type_cd as cause_lp_cust_type_cd
,t1.bal_pay_way_cd as bal_pay_way_cd
,t1.sys_in_cust_flg as sys_in_cust_flg
,t1.lmt_or_encrge_indus_cd as lmt_or_encrge_indus_cd
,t1.have_hxb_share_qtty as have_hxb_share_qtty
,t1.have_bod_flg as have_bod_flg
,t1.budget_form_cd as budget_form_cd
,t1.green_crdt_cust_flg as green_crdt_cust_flg
,t1.araf_flg as araf_flg
,t1.corp_size_cd_cpes as corp_size_cd_cpes
,t1.indus_type_cd_cpes as indus_type_cd_cpes
,t1.orgnz_cd as orgnz_cd
,t1.corp_party_type_cd as corp_party_type_cd
,t1.rg_cd as rg_cd
,t1.indus_type_cd_crdtc as indus_type_cd_crdtc
,t1.indus_categy_cd_crdtc as indus_categy_cd_crdtc
,t1.tax_num_null_rs_descb as tax_num_null_rs_descb
,t1.non_rec_rs as non_rec_rs
,t1.blklist_cust_flg as blklist_cust_flg
,t1.blklist_rgst_dt as blklist_rgst_dt
,t1.blklist_rs as blklist_rs
,t1.loan_card_no as loan_card_no
,t1.stock_cd as stock_cd
,t1.citizen_treat_flg as citizen_treat_flg
,t1.fir_setup_crdt_rela_dt as fir_setup_crdt_rela_dt
,t1.mger_member_number as mger_member_number
,t1.digit_econ_indus_cd as digit_econ_indus_cd
,t1.strtg_new_indus_type_cd as strtg_new_indus_type_cd
,t1.share_ratio as share_ratio
,t1.super_orgnz_cd as super_orgnz_cd
,t1.super_unify_soci_crdt_cd as super_unify_soci_crdt_cd
,t1.director_corp_rgst_curr_cd as director_corp_rgst_curr_cd
,t1.director_corp_rgst_amt as director_corp_rgst_amt
,t1.shard_type_cd as shard_type_cd
,t1.ctrler_type_cd as ctrler_type_cd
,t1.property_type_cd as property_type_cd
,t1.role_type_cd as role_type_cd
,t1.lp_org_name as lp_org_name
,t1.lp_org_type_cd as lp_org_type_cd
,t1.lp_org_cust_id as lp_org_cust_id
,t1.super_org_cust_id as super_org_cust_id
,t1.open_acct_chn_cd as open_acct_chn_cd
,t1.cust_ownsp_type_cd as cust_ownsp_type_cd
,t1.mang_site_dist_cd as mang_site_dist_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_corp t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_corp.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
