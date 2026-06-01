: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_pty_corp_party_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_pty_corp_party_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 pty_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,open_dt
,open_org_id
,open_teller_id
,setup_chn_typ_cd
,fst_create_cms_rela_year_mon
,blng_org_id
,blng_pty_mgr_num
,colse_dt
,colse_org_id
,colse_teller_id
,legal_name
,cn_fname
,cn_sname
,piny_name
,en_fname
,en_sname
,pty_typ_cd
,new_pty_risk_pty_typ_cd
,pty_org_typ_cd
,corp_hold_typ_cd
,pty_blng_indu_cd
,indu_typ_cd_gb
,indu_categ5_cd
,indu_crdt_rat_cd
,indu_typ_cd
,pty_level_cd
,owns_typ_cd
,pty_loc_cd
,non_resident_flg
,pty_status_cd
,estab_dt
,reg_cty_cd
,reg_prov_cd
,reg_city_cd
,reg_cuty_cd
,login_dtl_loc
,login_loc_pst_encd
,reg_cap_ccy_cd
,reg_cap
,rcved_cap_ccy_cd
,rcved_cap
,open_iden_typ_cd
,open_iden_num
,org_typ_cd
,economy_typ_cd
,nat_economy_dept_cd
,ghb_base_deposit_acct_flg
,base_deposit_acct_openbk_num
,base_deposit_acct_openbk_row_n
,base_acct_num
,legal_reps_name
,legal_rep_cust_num
,lp_rprs_proof_bk_id
,emp_cnt
,corp_size_gb_cd
,corp_size_hb_cd
,oper_scope
,mix_biz_range
,main_prd_situ
,oper_site_area
,oper_site_owns_cd
,ghb_shrholder_flg
,env_and_soci_risk_class_cd
,offic_loc_upda_dt
,csld_soci_crdt_cd
,cmc_aff_reg_cert_num
,org_org_cd
,oper_licence_num
,oper_licence_reg_dt
,oper_licence_due_dt
,year_check_due_day
,nation_tax_reg_cert_num
,local_tax_reg_cert_num
,open_lice_num
,org_crdt_cd
,loan_card_num
,pay_biz_lice_num
,forgn_invt_reg_cert_num
,im_ex_opr_rit_lice_num
,chrg_lice_num
,fin_org_ind_num
,fin_biz_lice_num
,insur_biz_lice_num
,secu_biz_lice_num
,peop_bank_fin_org_encd
,swift_num
,pay_sys_bank_num
,spec_org_cd
,fci_num
,iban_num
,aba_rout_num
,right_of_im_ex_flg
,grp_pty_flg
,spec_economy_zone_corp_flg
,ovsea_flg
,offsh_flg
,gov_fin_platf_flg
,ipo_corp_flg
,ipo_mrkt_cd
,ipo_dt
,stock_cd
,cap_stock_amt
,stock_stats_cd
,curr_shr
,cls_corp_flg
,treas_org_pty_flg
,lvlhd_doma_flg
,scf_fin_bcs_pty_flg
,crdt_pty_flg
,co_brand_pty_flg
,cty_imp_corp_flg
,occu_grp_pty_lmt_flg
,assoc_txn_flg
,anl_inc
,ast_total_amt
,net_ast_total_amt
,data_src_cd
,NVL2(t1.data_src_cd,'PTY_CORP_PARTY_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'PTY_CORP_PARTY_INFO_H') as etl_task_name
,self_cert_decl_flg
,rvn_resd_iden_cd
,rvn_org_typ_cd
,rvn_resd_en_name
,super_lp_org_pty_name
,non_onsit_regu_org_encd
,corp_typ_cd
,state_owned_corp_hold_flg
,pty_loc_old_cd
from ${idl_schema}.hdws_iml_pty_corp_party_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_pty_corp_party_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes