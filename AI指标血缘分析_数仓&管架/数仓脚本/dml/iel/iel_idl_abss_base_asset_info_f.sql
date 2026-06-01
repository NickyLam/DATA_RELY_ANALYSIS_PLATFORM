: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_abss_base_asset_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/abss_base_asset_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,asset_src_cd
,asset_id
,contr_id
,asst_type_cd
,prod_id
,prod_name
,value_dt
,exp_dt
,loan_tenor_mon
,loan_tenor_day
,loan_tot_perds
,surp_perds
,repay_way_cd
,repay_ped_corp_cd
,curr_repaybl_dt
,curr_cd
,loan_amt
,loan_bal
,ovdue_pric_bal
,fir_ovdue_dt
,curr_ovdue_days
,int_ovdue_days
,curr_unexp_int
,in_bs_over_int_bal
,off_bs_over_int_bal
,pric_pnlt
,int_pnlt
,loan_level5_cls_cd
,int_rat_type_cd
,exec_int_rat
,int_rat_adj_way_cd
,base_rat_type_cd
,base_rat
,int_rat_float_way_cd
,int_rat_flo_val
,ovdue_int_rat_type_cd
,ovdue_int_rat
,bond_item_rating_cd
,loan_repay_num
,loan_acct_status_cd
,loan_proc_dt
,operr_id
,oper_org_id
,acct_instit_id
,acct_instit_name
,cust_type_cd
,cust_id
,cust_name
,cert_type_cd
,cert_no
,unify_soci_crdt_cd
,resdnt_addr
,brwer_crdt_lmt
,cust_ghb_loan_bal
,ot_bank_loan_ovdue_perds
,crdt_score
,cust_rating_cd
,gender_cd
,age
,nationty_cd
,birth_dt
,nation_cd
,brwer_city_cd
,brwer_prov_cd
,career_cd
,degree_cd
,edu_cd
,marriage_situ_cd
,family_addr
,work_unit_name
,corp_bl_induty_type_cd
,indv_anl_inco
,ghb_emply_flg
,orgnz_cd
,econ_char_cd
,indus_cls_cd
,corp_size_cd
,list_corp_flg
,cty_rg_cd
,rgst_addr
,group_cust_flg
,belong_group_name
,loan_happ_type_cd
,cont_text_id
,cont_begin_dt
,cont_tenor_mon
,cont_exp_dt
,pm_rat
,cont_amt
,actl_distrd_amt
,cont_bal
,cont_nomal_bal
,cont_ovdue_bal
,indus_dir_cd
,circl_flg
,brw_new_return_old_cnt
,main_guar_way_cd
,higt_lmt_guar_flg
,loan_usage_type_cd
,renew_cnt
,margin_ratio
,margin_amt
,dep_rcpt_amt
,tbond_amt
,finc_prod_amt
,asset_tran_status_cd
,pkg_bf_int_recvbl_bal
,pkg_post_int_recvbl_tot
,pkg_post_int_recvbl_bal
,rtn_pkg_post_int_recvbl
,tran_loan_int_tot
,int_recvbl
,unrepay_int_fee_bal

from ${idl_schema}.abss_base_asset_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/abss_base_asset_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes