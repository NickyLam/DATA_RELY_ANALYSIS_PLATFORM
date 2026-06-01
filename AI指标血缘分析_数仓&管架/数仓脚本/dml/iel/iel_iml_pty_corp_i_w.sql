: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_corp_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_corp_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd 
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name 
,replace(replace(t1.corp_en_name,chr(13),''),chr(10),'') as corp_en_name 
,replace(replace(t1.soci_crdt_cd,chr(13),''),chr(10),'') as soci_crdt_cd 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,t1.rgst_cap as rgst_cap 
,replace(replace(t1.rgst_addr,chr(13),''),chr(10),'') as rgst_addr 
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd 
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd 
,replace(replace(t1.econ_char_cd,chr(13),''),chr(10),'') as econ_char_cd 
,replace(replace(t1.taxpayer_idtfy_num,chr(13),''),chr(10),'') as taxpayer_idtfy_num 
,replace(replace(t1.corp_type_cd,chr(13),''),chr(10),'') as corp_type_cd 
,replace(replace(t1.tax_stament_flg,chr(13),''),chr(10),'') as tax_stament_flg 
,replace(replace(t1.tax_org_cate_cd,chr(13),''),chr(10),'') as tax_org_cate_cd 
,replace(replace(t1.tax_resdnt_cty_cd,chr(13),''),chr(10),'') as tax_resdnt_cty_cd 
,replace(replace(t1.tax_resdnt_idti_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_cd 
,t1.emply_qtty as emply_qtty 
,replace(replace(t1.fin_subsidy_inco_src_cd,chr(13),''),chr(10),'') as fin_subsidy_inco_src_cd 
,replace(replace(t1.strategy_camp_cust_no,chr(13),''),chr(10),'') as strategy_camp_cust_no 
,replace(replace(t1.ins_adj_type_cd,chr(13),''),chr(10),'') as ins_adj_type_cd 
,t1.single_lmt as single_lmt 
,replace(replace(t1.single_lp_flg,chr(13),''),chr(10),'') as single_lp_flg 
,replace(replace(t1.high_new_tech_corp_flg,chr(13),''),chr(10),'') as high_new_tech_corp_flg 
,replace(replace(t1.itau_flg,chr(13),''),chr(10),'') as itau_flg 
,replace(replace(t1.rela_party_flg,chr(13),''),chr(10),'') as rela_party_flg 
,replace(replace(t1.rela_group_type_cd,chr(13),''),chr(10),'') as rela_group_type_cd 
,replace(replace(t1.org_type_cd,chr(13),''),chr(10),'') as org_type_cd 
,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'') as org_status_cd 
,replace(replace(t1.group_cust_flg,chr(13),''),chr(10),'') as group_cust_flg 
,replace(replace(t1.weight_risk_asset_cust_cls_cd,chr(13),''),chr(10),'') as weight_risk_asset_cust_cls_cd 
,replace(replace(t1.cbrc_sb_flg,chr(13),''),chr(10),'') as cbrc_sb_flg 
,replace(replace(t1.econ_type_cd,chr(13),''),chr(10),'') as econ_type_cd 
,replace(replace(t1.oper_range,chr(13),''),chr(10),'') as oper_range 
,replace(replace(t1.cust_sev_ugd_cls_cd,chr(13),''),chr(10),'') as cust_sev_ugd_cls_cd 
,replace(replace(t1.hold_type_cd,chr(13),''),chr(10),'') as hold_type_cd 
,replace(replace(t1.off_shore_cust_flg,chr(13),''),chr(10),'') as off_shore_cust_flg 
,replace(replace(t1.subj_org_name,chr(13),''),chr(10),'') as subj_org_name 
,replace(replace(t1.prit_etp_flg,chr(13),''),chr(10),'') as prit_etp_flg 
,replace(replace(t1.ctysd_corp_flg,chr(13),''),chr(10),'') as ctysd_corp_flg 
,t1.corp_found_dt as corp_found_dt 
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd 
,replace(replace(t1.corp_size_cd_intnal,chr(13),''),chr(10),'') as corp_size_cd_intnal 
,replace(replace(t1.ta_cust_size,chr(13),''),chr(10),'') as ta_cust_size 
,replace(replace(t1.ta_cust_indus_status,chr(13),''),chr(10),'') as ta_cust_indus_status 
,replace(replace(t1.list_corp_type_cd,chr(13),''),chr(10),'') as list_corp_type_cd 
,replace(replace(t1.list_corp_flg,chr(13),''),chr(10),'') as list_corp_flg 
,replace(replace(t1.crdt_strategy_cd,chr(13),''),chr(10),'') as crdt_strategy_cd 
,replace(replace(t1.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg 
,replace(replace(t1.bel_thi_flg,chr(13),''),chr(10),'') as bel_thi_flg 
,t1.rgst_dt as rgst_dt 
,replace(replace(t1.orgnz_type_cd,chr(13),''),chr(10),'') as orgnz_type_cd 
,replace(replace(t1.orgnz_type_subdv_cd,chr(13),''),chr(10),'') as orgnz_type_subdv_cd 
,replace(replace(t1.econ_orgnz_form_cd,chr(13),''),chr(10),'') as econ_orgnz_form_cd 
,replace(replace(t1.trast_tax_regi_cert_flg,chr(13),''),chr(10),'') as trast_tax_regi_cert_flg 
,replace(replace(t1.fin_stat_type_cd,chr(13),''),chr(10),'') as fin_stat_type_cd 
,t1.jnor_cog_over_number as jnor_cog_over_number 
,replace(replace(t1.cty_key_enterp_flg,chr(13),''),chr(10),'') as cty_key_enterp_flg 
,replace(replace(t1.natnal_econ_dept_type_cd,chr(13),''),chr(10),'') as natnal_econ_dept_type_cd 
,replace(replace(t1.indus_type_cd_level5_cls,chr(13),''),chr(10),'') as indus_type_cd_level5_cls 
,replace(replace(t1.indus_type_cd_crdt_rating,chr(13),''),chr(10),'') as indus_type_cd_crdt_rating 
,replace(replace(t1.org_subj,chr(13),''),chr(10),'') as org_subj 
,replace(replace(t1.group_corp_flg,chr(13),''),chr(10),'') as group_corp_flg 
,replace(replace(t1.group_cust_id,chr(13),''),chr(10),'') as group_cust_id 
,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg 
,t1.open_cap as open_cap 
,replace(replace(t1.cust_lev_cd,chr(13),''),chr(10),'') as cust_lev_cd 
,t1.retire_number as retire_number 
,replace(replace(t1.super_director_dept,chr(13),''),chr(10),'') as super_director_dept 
,replace(replace(t1.cause_lp_size_or_lev_cd,chr(13),''),chr(10),'') as cause_lp_size_or_lev_cd 
,replace(replace(t1.cause_lp_cust_type_cd,chr(13),''),chr(10),'') as cause_lp_cust_type_cd 
,replace(replace(t1.bal_pay_way_cd,chr(13),''),chr(10),'') as bal_pay_way_cd 
,replace(replace(t1.sys_in_cust_flg,chr(13),''),chr(10),'') as sys_in_cust_flg 
,replace(replace(t1.lmt_or_encrge_indus_cd,chr(13),''),chr(10),'') as lmt_or_encrge_indus_cd 
,t1.have_hxb_share_qtty as have_hxb_share_qtty 
,replace(replace(t1.have_bod_flg,chr(13),''),chr(10),'') as have_bod_flg 
,replace(replace(t1.budget_form_cd,chr(13),''),chr(10),'') as budget_form_cd 
,replace(replace(t1.green_crdt_cust_flg,chr(13),''),chr(10),'') as green_crdt_cust_flg 
,replace(replace(t1.araf_flg,chr(13),''),chr(10),'') as araf_flg 
,replace(replace(t1.corp_size_cd_cpes,chr(13),''),chr(10),'') as corp_size_cd_cpes 
,replace(replace(t1.indus_type_cd_cpes,chr(13),''),chr(10),'') as indus_type_cd_cpes 
,replace(replace(t1.orgnz_cd,chr(13),''),chr(10),'') as orgnz_cd 
,replace(replace(t1.corp_party_type_cd,chr(13),''),chr(10),'') as corp_party_type_cd 
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd 
,replace(replace(t1.indus_type_cd_crdtc,chr(13),''),chr(10),'') as indus_type_cd_crdtc 
,replace(replace(t1.indus_categy_cd_crdtc,chr(13),''),chr(10),'') as indus_categy_cd_crdtc 
,replace(replace(t1.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_corp t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_corp_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes