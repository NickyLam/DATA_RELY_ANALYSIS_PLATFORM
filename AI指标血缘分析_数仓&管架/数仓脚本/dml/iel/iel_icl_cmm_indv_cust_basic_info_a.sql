: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_indv_cust_basic_info_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_indv_cust_basic_info.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.etl_dt as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
,t.cert_exp_dt as cert_exp_dt
,replace(replace(t.cert_issue_org,chr(13),''),chr(10),'') as cert_issue_org
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.cust_en_name,chr(13),''),chr(10),'') as cust_en_name
,t.open_acct_dt as open_acct_dt
,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id
,replace(replace(t.gender_cd,chr(13),''),chr(10),'') as gender_cd
,replace(replace(t.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd
,t.birth_dt as birth_dt
,replace(replace(t.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd
,replace(replace(t.resd_status_cd,chr(13),''),chr(10),'') as resd_status_cd
,replace(replace(t.estate_val_cd,chr(13),''),chr(10),'') as estate_val_cd
,replace(replace(t.owner_type_cd,chr(13),''),chr(10),'') as owner_type_cd
,replace(replace(t.politic_status_cd,chr(13),''),chr(10),'') as politic_status_cd
,replace(replace(t.nation_cd,chr(13),''),chr(10),'') as nation_cd
,replace(replace(t.dist_cd,chr(13),''),chr(10),'') as dist_cd
,replace(replace(t.rg_cd,chr(13),''),chr(10),'') as rg_cd
,replace(replace(t.nationty_cd,chr(13),''),chr(10),'') as nationty_cd
,replace(replace(t.nati_place,chr(13),''),chr(10),'') as nati_place
,replace(replace(t.cust_status_cd,chr(13),''),chr(10),'') as cust_status_cd
,replace(replace(t.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd
,replace(replace(t.prov_pulation_type_cd,chr(13),''),chr(10),'') as prov_pulation_type_cd
,replace(replace(t.child_number_cd,chr(13),''),chr(10),'') as child_number_cd
,replace(replace(t.cont_num,chr(13),''),chr(10),'') as cont_num
,replace(replace(t.open_acct_rsrv_mobile_no,chr(13),''),chr(10),'') as open_acct_rsrv_mobile_no
,replace(replace(t.elec_mail_addr,chr(13),''),chr(10),'') as elec_mail_addr
,replace(replace(t.cust_lev_cd,chr(13),''),chr(10),'') as cust_lev_cd
,replace(replace(t.edu_cd,chr(13),''),chr(10),'') as edu_cd
,replace(replace(t.degree_cd,chr(13),''),chr(10),'') as degree_cd
,replace(replace(t.grad_sch,chr(13),''),chr(10),'') as grad_sch
,replace(replace(t.title_cd,chr(13),''),chr(10),'') as title_cd
,replace(replace(t.post_cd,chr(13),''),chr(10),'') as post_cd
,replace(replace(t.career_cd,chr(13),''),chr(10),'') as career_cd
,replace(replace(t.posta_addr,chr(13),''),chr(10),'') as posta_addr
,replace(replace(t.comm_zip_cd,chr(13),''),chr(10),'') as comm_zip_cd
,replace(replace(t.resdnt_addr,chr(13),''),chr(10),'') as resdnt_addr
,replace(replace(t.resdnt_zip_cd,chr(13),''),chr(10),'') as resdnt_zip_cd
,replace(replace(t.rpr_site,chr(13),''),chr(10),'') as rpr_site
,replace(replace(t.family_addr,chr(13),''),chr(10),'') as family_addr
,replace(replace(t.family_zip_cd,chr(13),''),chr(10),'') as family_zip_cd
,replace(replace(t.nome_phone_num,chr(13),''),chr(10),'') as nome_phone_num
,replace(replace(t.work_unit_name,chr(13),''),chr(10),'') as work_unit_name
,replace(replace(t.work_unit_addr,chr(13),''),chr(10),'') as work_unit_addr
,replace(replace(t.work_unit_tel,chr(13),''),chr(10),'') as work_unit_tel
,replace(replace(t.work_unit_zip_cd,chr(13),''),chr(10),'') as work_unit_zip_cd
,replace(replace(t.work_unit_char_cd,chr(13),''),chr(10),'') as work_unit_char_cd
,replace(replace(t.corp_bl_induty_type_cd,chr(13),''),chr(10),'') as corp_bl_induty_type_cd
,t.corp_work_years as corp_work_years
,t.indv_mon_inco as indv_mon_inco
,t.indv_anl_inco as indv_anl_inco
,t.family_mon_inco as family_mon_inco
,t.family_anl_inco as family_anl_inco
,replace(replace(t.tax_resdnt_idti_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_cd
,replace(replace(t.tax_red_cty_cd,chr(13),''),chr(10),'') as tax_red_cty_cd
,replace(replace(t.tax_num,chr(13),''),chr(10),'') as tax_num
,replace(replace(t.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb
,replace(replace(t.stament_flg,chr(13),''),chr(10),'') as stament_flg
,replace(replace(t.indv_bus_flg,chr(13),''),chr(10),'') as indv_bus_flg
,replace(replace(t.sm_bus_owner_flg,chr(13),''),chr(10),'') as sm_bus_owner_flg
,replace(replace(t.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg
,replace(replace(t.farm_flg,chr(13),''),chr(10),'') as farm_flg
,replace(replace(t.ghb_emply_flg,chr(13),''),chr(10),'') as ghb_emply_flg
,replace(replace(t.ghb_shard_flg,chr(13),''),chr(10),'') as ghb_shard_flg
,replace(replace(t.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg
,replace(replace(t.real_name_flg,chr(13),''),chr(10),'') as real_name_flg
,replace(replace(t.dom_overs_flg,chr(13),''),chr(10),'') as dom_overs_flg
,replace(replace(t.local_estate_flg,chr(13),''),chr(10),'') as local_estate_flg
,replace(replace(t.local_soci_secu_flg,chr(13),''),chr(10),'') as local_soci_secu_flg
,replace(replace(t.ctysd_contr_oper_acct_flg,chr(13),''),chr(10),'') as ctysd_contr_oper_acct_flg
,replace(replace(t.ghb_rela_peop_flg,chr(13),''),chr(10),'') as ghb_rela_peop_flg
,replace(replace(t.hxb_shard_flg,chr(13),''),chr(10),'') as hxb_shard_flg
,replace(replace(t.hxb_trast_inter_bus_flg,chr(13),''),chr(10),'') as hxb_trast_inter_bus_flg
,replace(replace(t.hxb_payoff_sal_acct_flg,chr(13),''),chr(10),'') as hxb_payoff_sal_acct_flg
,replace(replace(t.hxb_reg_cust_flg,chr(13),''),chr(10),'') as hxb_reg_cust_flg
,replace(replace(t.hxb_finc_cust_flg,chr(13),''),chr(10),'') as hxb_finc_cust_flg
,replace(replace(t.hxb_vip_cust_idf,chr(13),''),chr(10),'') as hxb_vip_cust_idf
,replace(replace(t.spouse_and_child_img_flg,chr(13),''),chr(10),'') as spouse_and_child_img_flg
,replace(replace(t.enjoy_cty_prefr_policy_flg,chr(13),''),chr(10),'') as enjoy_cty_prefr_policy_flg
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t.employ_type_cd,chr(13),''),chr(10),'') as employ_type_cd
,t.clos_acct_dt as clos_acct_dt
,replace(replace(t.clos_acct_org_id,chr(13),''),chr(10),'') as clos_acct_org_id
,replace(replace(t.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id
,replace(replace(t.have_car_flg,chr(13),''),chr(10),'') as have_car_flg
,replace(replace(t.salar_flg,chr(13),''),chr(10),'') as salar_flg
,replace(replace(t.civ_sert_flg,chr(13),''),chr(10),'') as civ_sert_flg
,replace(replace(t.tax_red_en_name,chr(13),''),chr(10),'') as tax_red_en_name
,replace(replace(t.other_career_info,chr(13),''),chr(10),'') as other_career_info
,t.curt_corp_empyt_dt as curt_corp_empyt_dt
from icl.cmm_indv_cust_basic_info t
where t.etl_dt >= to_date('20201201','yyyymmdd') and t.etl_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_indv_cust_basic_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes