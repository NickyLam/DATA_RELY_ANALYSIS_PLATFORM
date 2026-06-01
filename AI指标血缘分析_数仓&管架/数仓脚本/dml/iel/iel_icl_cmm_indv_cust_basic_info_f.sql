: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_indv_cust_basic_info_f
CreateDate: 20221121
FileName:   ${iel_data_path}/cmm_indv_cust_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,cert_exp_dt
,replace(replace(t1.cert_issue_org,chr(13),''),chr(10),'') as cert_issue_org
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_en_name,chr(13),''),chr(10),'') as cust_en_name
,open_acct_dt
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd
,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd
,birth_dt
,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd
,replace(replace(t1.resd_status_cd,chr(13),''),chr(10),'') as resd_status_cd
,replace(replace(t1.estate_val_cd,chr(13),''),chr(10),'') as estate_val_cd
,replace(replace(t1.owner_type_cd,chr(13),''),chr(10),'') as owner_type_cd
,replace(replace(t1.politic_status_cd,chr(13),''),chr(10),'') as politic_status_cd
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd
,replace(replace(t1.nationty_cd,chr(13),''),chr(10),'') as nationty_cd
,replace(replace(t1.nati_place,chr(13),''),chr(10),'') as nati_place
,replace(replace(t1.cust_status_cd,chr(13),''),chr(10),'') as cust_status_cd
,replace(replace(t1.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd
,replace(replace(t1.prov_pulation_type_cd,chr(13),''),chr(10),'') as prov_pulation_type_cd
,replace(replace(t1.child_number_cd,chr(13),''),chr(10),'') as child_number_cd
,replace(replace(t1.cont_num,chr(13),''),chr(10),'') as cont_num
,replace(replace(t1.open_acct_rsrv_mobile_no,chr(13),''),chr(10),'') as open_acct_rsrv_mobile_no
,replace(replace(t1.elec_mail_addr,chr(13),''),chr(10),'') as elec_mail_addr
,replace(replace(t1.cust_lev_cd,chr(13),''),chr(10),'') as cust_lev_cd
,replace(replace(t1.edu_cd,chr(13),''),chr(10),'') as edu_cd
,replace(replace(t1.degree_cd,chr(13),''),chr(10),'') as degree_cd
,replace(replace(t1.grad_sch,chr(13),''),chr(10),'') as grad_sch
,replace(replace(t1.title_cd,chr(13),''),chr(10),'') as title_cd
,replace(replace(t1.post_cd,chr(13),''),chr(10),'') as post_cd
,replace(replace(t1.career_cd,chr(13),''),chr(10),'') as career_cd
,replace(replace(t1.posta_addr,chr(13),''),chr(10),'') as posta_addr
,replace(replace(t1.comm_zip_cd,chr(13),''),chr(10),'') as comm_zip_cd
,replace(replace(t1.resdnt_addr,chr(13),''),chr(10),'') as resdnt_addr
,replace(replace(t1.resdnt_zip_cd,chr(13),''),chr(10),'') as resdnt_zip_cd
,replace(replace(t1.rpr_site,chr(13),''),chr(10),'') as rpr_site
,replace(replace(t1.family_addr,chr(13),''),chr(10),'') as family_addr
,replace(replace(t1.family_zip_cd,chr(13),''),chr(10),'') as family_zip_cd
,replace(replace(t1.nome_phone_num,chr(13),''),chr(10),'') as nome_phone_num
,replace(replace(t1.work_unit_name,chr(13),''),chr(10),'') as work_unit_name
,replace(replace(t1.work_unit_addr,chr(13),''),chr(10),'') as work_unit_addr
,replace(replace(t1.work_unit_tel,chr(13),''),chr(10),'') as work_unit_tel
,replace(replace(t1.work_unit_zip_cd,chr(13),''),chr(10),'') as work_unit_zip_cd
,replace(replace(t1.work_unit_char_cd,chr(13),''),chr(10),'') as work_unit_char_cd
,replace(replace(t1.corp_bl_induty_type_cd,chr(13),''),chr(10),'') as corp_bl_induty_type_cd
,corp_work_years
,indv_mon_inco
,indv_anl_inco
,family_mon_inco
,family_anl_inco
,replace(replace(t1.tax_resdnt_idti_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_cd
,replace(replace(t1.tax_red_cty_cd,chr(13),''),chr(10),'') as tax_red_cty_cd
,replace(replace(t1.tax_num,chr(13),''),chr(10),'') as tax_num
,replace(replace(t1.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb
,replace(replace(t1.stament_flg,chr(13),''),chr(10),'') as stament_flg
,replace(replace(t1.indv_bus_flg,chr(13),''),chr(10),'') as indv_bus_flg
,replace(replace(t1.sm_bus_owner_flg,chr(13),''),chr(10),'') as sm_bus_owner_flg
,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg
,replace(replace(t1.farm_flg,chr(13),''),chr(10),'') as farm_flg
,replace(replace(t1.ghb_emply_flg,chr(13),''),chr(10),'') as ghb_emply_flg
,replace(replace(t1.ghb_shard_flg,chr(13),''),chr(10),'') as ghb_shard_flg
,replace(replace(t1.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg
,replace(replace(t1.real_name_flg,chr(13),''),chr(10),'') as real_name_flg
,replace(replace(t1.dom_overs_flg,chr(13),''),chr(10),'') as dom_overs_flg
,replace(replace(t1.local_estate_flg,chr(13),''),chr(10),'') as local_estate_flg
,replace(replace(t1.local_soci_secu_flg,chr(13),''),chr(10),'') as local_soci_secu_flg
,replace(replace(t1.ctysd_contr_oper_acct_flg,chr(13),''),chr(10),'') as ctysd_contr_oper_acct_flg
,replace(replace(t1.ghb_rela_peop_flg,chr(13),''),chr(10),'') as ghb_rela_peop_flg
,replace(replace(t1.hxb_shard_flg,chr(13),''),chr(10),'') as hxb_shard_flg
,replace(replace(t1.hxb_trast_inter_bus_flg,chr(13),''),chr(10),'') as hxb_trast_inter_bus_flg
,replace(replace(t1.hxb_payoff_sal_acct_flg,chr(13),''),chr(10),'') as hxb_payoff_sal_acct_flg
,replace(replace(t1.hxb_reg_cust_flg,chr(13),''),chr(10),'') as hxb_reg_cust_flg
,replace(replace(t1.hxb_finc_cust_flg,chr(13),''),chr(10),'') as hxb_finc_cust_flg
,replace(replace(t1.hxb_vip_cust_idf,chr(13),''),chr(10),'') as hxb_vip_cust_idf
,replace(replace(t1.spouse_and_child_img_flg,chr(13),''),chr(10),'') as spouse_and_child_img_flg
,replace(replace(t1.enjoy_cty_prefr_policy_flg,chr(13),''),chr(10),'') as enjoy_cty_prefr_policy_flg
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.employ_type_cd,chr(13),''),chr(10),'') as employ_type_cd
,clos_acct_dt
,replace(replace(t1.clos_acct_org_id,chr(13),''),chr(10),'') as clos_acct_org_id
,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id
,replace(replace(t1.have_car_flg,chr(13),''),chr(10),'') as have_car_flg
,replace(replace(t1.salar_flg,chr(13),''),chr(10),'') as salar_flg
,replace(replace(t1.civ_sert_flg,chr(13),''),chr(10),'') as civ_sert_flg
,replace(replace(t1.tax_red_en_name,chr(13),''),chr(10),'') as tax_red_en_name
,replace(replace(t1.other_career_info,chr(13),''),chr(10),'') as other_career_info
,curt_corp_empyt_dt
,replace(replace(t1.create_chn_cd,chr(13),''),chr(10),'') as create_chn_cd
,replace(replace(t1.cont_num_is_self_flg,chr(13),''),chr(10),'') as cont_num_is_self_flg
,replace(replace(t1.rela_tran_flg,chr(13),''),chr(10),'') as rela_tran_flg
,cert_effect_dt
,replace(replace(t1.dep_class_cust_flg,chr(13),''),chr(10),'') as dep_class_cust_flg
,replace(replace(t1.loan_class_cust_flg,chr(13),''),chr(10),'') as loan_class_cust_flg
,replace(replace(t1.guar_class_cust_flg,chr(13),''),chr(10),'') as guar_class_cust_flg
,replace(replace(t1.anti_mon_lau_belong_org_id,chr(13),''),chr(10),'') as anti_mon_lau_belong_org_id

from ${icl_schema}.cmm_indv_cust_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_indv_cust_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
