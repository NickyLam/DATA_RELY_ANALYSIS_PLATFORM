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
infile '${data_path}/cmm_indv_cust_basic_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_indv_cust_basic_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,cust_type_cd char(4000) nullif cust_type_cd=blanks 
    ,cert_type_cd char(4000) nullif cert_type_cd=blanks 
    ,cert_no char(4000) nullif cert_no=blanks 
    ,cert_exp_dt date "yyyy-mm-dd hh24:mi:ss" nullif cert_exp_dt=blanks 
    ,cert_issue_org char(4000) nullif cert_issue_org=blanks 
    ,cust_name char(4000) nullif cust_name=blanks 
    ,cust_en_name char(4000) nullif cust_en_name=blanks 
    ,open_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif open_acct_dt=blanks 
    ,belong_org_id char(4000) nullif belong_org_id=blanks 
    ,open_acct_teller_id char(4000) nullif open_acct_teller_id=blanks 
    ,gender_cd char(4000) nullif gender_cd=blanks 
    ,open_acct_chn_cd char(4000) nullif open_acct_chn_cd=blanks 
    ,birth_dt date "yyyy-mm-dd hh24:mi:ss" nullif birth_dt=blanks 
    ,marriage_situ_cd char(4000) nullif marriage_situ_cd=blanks 
    ,resd_status_cd char(4000) nullif resd_status_cd=blanks 
    ,estate_val_cd char(4000) nullif estate_val_cd=blanks 
    ,owner_type_cd char(4000) nullif owner_type_cd=blanks 
    ,politic_status_cd char(4000) nullif politic_status_cd=blanks 
    ,nation_cd char(4000) nullif nation_cd=blanks 
    ,dist_cd char(4000) nullif dist_cd=blanks 
    ,rg_cd char(4000) nullif rg_cd=blanks 
    ,nationty_cd char(4000) nullif nationty_cd=blanks 
    ,nati_place char(4000) nullif nati_place=blanks 
    ,cust_status_cd char(4000) nullif cust_status_cd=blanks 
    ,depositr_cate_cd char(4000) nullif depositr_cate_cd=blanks 
    ,prov_pulation_type_cd char(4000) nullif prov_pulation_type_cd=blanks 
    ,child_number_cd char(4000) nullif child_number_cd=blanks 
    ,cont_num char(4000) nullif cont_num=blanks 
    ,open_acct_rsrv_mobile_no char(4000) nullif open_acct_rsrv_mobile_no=blanks 
    ,elec_mail_addr char(4000) nullif elec_mail_addr=blanks 
    ,cust_lev_cd char(4000) nullif cust_lev_cd=blanks 
    ,edu_cd char(4000) nullif edu_cd=blanks 
    ,degree_cd char(4000) nullif degree_cd=blanks 
    ,grad_sch char(4000) nullif grad_sch=blanks 
    ,title_cd char(4000) nullif title_cd=blanks 
    ,post_cd char(4000) nullif post_cd=blanks 
    ,career_cd char(4000) nullif career_cd=blanks 
    ,posta_addr char(4000) nullif posta_addr=blanks 
    ,comm_zip_cd char(4000) nullif comm_zip_cd=blanks 
    ,resdnt_addr char(4000) nullif resdnt_addr=blanks 
    ,resdnt_zip_cd char(4000) nullif resdnt_zip_cd=blanks 
    ,rpr_site char(4000) nullif rpr_site=blanks 
    ,family_addr char(4000) nullif family_addr=blanks 
    ,family_zip_cd char(4000) nullif family_zip_cd=blanks 
    ,nome_phone_num char(4000) nullif nome_phone_num=blanks 
    ,work_unit_name char(4000) nullif work_unit_name=blanks 
    ,work_unit_addr char(4000) nullif work_unit_addr=blanks 
    ,work_unit_tel char(4000) nullif work_unit_tel=blanks 
    ,work_unit_zip_cd char(4000) nullif work_unit_zip_cd=blanks 
    ,work_unit_char_cd char(4000) nullif work_unit_char_cd=blanks 
    ,corp_bl_induty_type_cd char(4000) nullif corp_bl_induty_type_cd=blanks 
    ,corp_work_years char(4000) nullif corp_work_years=blanks 
    ,indv_mon_inco char(4000) nullif indv_mon_inco=blanks 
    ,indv_anl_inco char(4000) nullif indv_anl_inco=blanks 
    ,family_mon_inco char(4000) nullif family_mon_inco=blanks 
    ,family_anl_inco char(4000) nullif family_anl_inco=blanks 
    ,tax_resdnt_idti_cd char(4000) nullif tax_resdnt_idti_cd=blanks 
    ,tax_red_cty_cd char(4000) nullif tax_red_cty_cd=blanks 
    ,tax_num char(4000) nullif tax_num=blanks 
    ,tax_num_null_rs_descb char(4000) nullif tax_num_null_rs_descb=blanks 
    ,stament_flg char(4000) nullif stament_flg=blanks 
    ,indv_bus_flg char(4000) nullif indv_bus_flg=blanks 
    ,sm_bus_owner_flg char(4000) nullif sm_bus_owner_flg=blanks 
    ,resdnt_flg char(4000) nullif resdnt_flg=blanks 
    ,farm_flg char(4000) nullif farm_flg=blanks 
    ,ghb_emply_flg char(4000) nullif ghb_emply_flg=blanks 
    ,ghb_shard_flg char(4000) nullif ghb_shard_flg=blanks 
    ,crdt_cust_flg char(4000) nullif crdt_cust_flg=blanks 
    ,real_name_flg char(4000) nullif real_name_flg=blanks 
    ,dom_overs_flg char(4000) nullif dom_overs_flg=blanks 
    ,local_estate_flg char(4000) nullif local_estate_flg=blanks 
    ,local_soci_secu_flg char(4000) nullif local_soci_secu_flg=blanks 
    ,ctysd_contr_oper_acct_flg char(4000) nullif ctysd_contr_oper_acct_flg=blanks 
    ,ghb_rela_peop_flg char(4000) nullif ghb_rela_peop_flg=blanks 
    ,hxb_shard_flg char(4000) nullif hxb_shard_flg=blanks 
    ,hxb_trast_inter_bus_flg char(4000) nullif hxb_trast_inter_bus_flg=blanks 
    ,hxb_payoff_sal_acct_flg char(4000) nullif hxb_payoff_sal_acct_flg=blanks 
    ,hxb_reg_cust_flg char(4000) nullif hxb_reg_cust_flg=blanks 
    ,hxb_finc_cust_flg char(4000) nullif hxb_finc_cust_flg=blanks 
    ,hxb_vip_cust_idf char(4000) nullif hxb_vip_cust_idf=blanks 
    ,spouse_and_child_img_flg char(4000) nullif spouse_and_child_img_flg=blanks 
    ,enjoy_cty_prefr_policy_flg char(4000) nullif enjoy_cty_prefr_policy_flg=blanks 
    ,cust_mgr_id char(4000) nullif cust_mgr_id=blanks 
    ,employ_type_cd char(4000) nullif employ_type_cd=blanks 
    ,clos_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif clos_acct_dt=blanks 
    ,clos_acct_org_id char(4000) nullif clos_acct_org_id=blanks 
    ,clos_acct_teller_id char(4000) nullif clos_acct_teller_id=blanks 
    ,have_car_flg char(4000) nullif have_car_flg=blanks 
    ,salar_flg char(4000) nullif salar_flg=blanks 
    ,civ_sert_flg char(4000) nullif civ_sert_flg=blanks 
    ,tax_red_en_name char(4000) nullif tax_red_en_name=blanks 
    ,other_career_info char(4000) nullif other_career_info=blanks 
    ,curt_corp_empyt_dt date "yyyy-mm-dd hh24:mi:ss" nullif curt_corp_empyt_dt=blanks 
    ,create_chn_cd char(4000) nullif create_chn_cd=blanks 
    ,cont_num_is_self_flg char(4000) nullif cont_num_is_self_flg=blanks 
    ,rela_tran_flg char(4000) nullif rela_tran_flg=blanks 
    ,cert_effect_dt date "yyyy-mm-dd hh24:mi:ss" nullif cert_effect_dt=blanks 
    ,dep_class_cust_flg char(4000) nullif dep_class_cust_flg=blanks 
    ,loan_class_cust_flg char(4000) nullif loan_class_cust_flg=blanks 
    ,guar_class_cust_flg char(4000) nullif guar_class_cust_flg=blanks 
    ,anti_mon_lau_belong_org_id char(4000) nullif anti_mon_lau_belong_org_id=blanks 
)