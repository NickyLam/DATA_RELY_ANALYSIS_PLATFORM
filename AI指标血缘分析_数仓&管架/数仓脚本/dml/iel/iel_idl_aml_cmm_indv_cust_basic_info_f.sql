: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_indv_cust_basic_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_indv_cust_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,cust_id
,cust_type_cd
,cert_type_cd
,cert_no
,cert_exp_dt
,cert_issue_org
,cust_name
,cust_en_name
,open_acct_dt
,belong_org_id
,open_acct_teller_id
,gender_cd
,open_acct_chn_cd
,birth_dt
,marriage_situ_cd
,resd_status_cd
,estate_val_cd
,owner_type_cd
,politic_status_cd
,nation_cd
,dist_cd
,rg_cd
,nationty_cd
,nati_place
,cust_status_cd
,depositr_cate_cd
,prov_pulation_type_cd
,child_number_cd
,cont_num
,open_acct_rsrv_mobile_no
,elec_mail_addr
,cust_lev_cd
,edu_cd
,degree_cd
,grad_sch
,title_cd
,post_cd
,career_cd
,posta_addr
,comm_zip_cd
,resdnt_addr
,resdnt_zip_cd
,rpr_site
,family_addr
,family_zip_cd
,nome_phone_num
,work_unit_name
,work_unit_addr
,work_unit_tel
,work_unit_zip_cd
,work_unit_char_cd
,corp_bl_induty_type_cd
,corp_work_years
,indv_mon_inco
,indv_anl_inco
,family_mon_inco
,family_anl_inco
,tax_resdnt_idti_cd
,tax_red_cty_cd
,tax_num
,tax_num_null_rs_descb
,stament_flg
,indv_bus_flg
,sm_bus_owner_flg
,resdnt_flg
,farm_flg
,ghb_emply_flg
,ghb_shard_flg
,crdt_cust_flg
,real_name_flg
,dom_overs_flg
,local_estate_flg
,local_soci_secu_flg
,ctysd_contr_oper_acct_flg
,ghb_rela_peop_flg
,hxb_shard_flg
,hxb_trast_inter_bus_flg
,hxb_payoff_sal_acct_flg
,hxb_reg_cust_flg
,hxb_finc_cust_flg
,hxb_vip_cust_idf
,spouse_and_child_img_flg
,enjoy_cty_prefr_policy_flg
,cust_mgr_id
,employ_type_cd
,clos_acct_dt
,clos_acct_org_id
,clos_acct_teller_id
,have_car_flg
,salar_flg
,civ_sert_flg
,tax_red_en_name
,other_career_info
,curt_corp_empyt_dt
,create_chn_cd
,cont_num_is_self_flg
,sel_sup_cust_flg_cd
,crdt_cust_flg_cd
,guar_cust_flg_cd
,rela_tran_flg
,anti_mon_lau_belong_org_id
from ${idl_schema}.aml_cmm_indv_cust_basic_info   
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_indv_cust_basic_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes