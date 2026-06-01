: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_cont_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_corp_loan_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,lp_id
      ,cont_id
      ,cust_id
      ,lmt_cont_id
      ,apv_flow_num
      ,manu_cont_id
      ,bus_breed_id
      ,bus_sub_type_cd
      ,loan_happ_type_cd
      ,cont_type_cd
      ,strtg_new_indus_type_cd
      ,prod_type_cd
      ,valid_flg_cd
      ,dir_indus_cd
      ,surp_indus_cd
      ,sub_guar_way_cd
      ,guar_type_cd
      ,major_guar_way_cd
      ,crdt_type_cd
      ,appl_way_cd
      ,loan_fin_supt_way_cd
      ,invest_way_cd
      ,mgmt_mode_cd
      ,loan_level5_cls_cd
      ,loan_level10_cls_cd
      ,tenor_type_cd
      ,pric_repay_way_cd
      ,int_rat_float_way_cd
      ,charge_way_cd
      ,draw_way_cd
      ,cap_src_cd
      ,int_rat_adj_way_cd
      ,curr_cd
      ,sup_chain_fin_bus_prod_cls_cd
      ,sup_chain_fin_bus_flg
      ,agent_patip_loan_flg
      ,lmt_circl_flg
      ,circl_flg
      ,temp_store_flg
      ,froz_flg
      ,turn_crdt_flg
      ,remote_loan_flg
      ,other_guar_way_flg
      ,imp_proj_loan_flg
      ,cty_lmt_indus_flg
      ,gover_crdt_flg
      ,cdb_crdt_flg
      ,fix_asset_crdt_flg
      ,qual_centr_cntpty_flg
      ,low_risk_bus_flg
      ,host_bank_no
      ,patip_loan_bank_no
      ,agent_bank_no
      ,cntpty_strg
      ,cntpty_co_years
      ,cntpty_sucs_tran_cnt
      ,mgmt_org_id
      ,rgst_org_id
      ,oper_org_id
      ,distr_org_id
      ,mgmt_teller_id
      ,oper_teller_id
      ,rgst_teller_id
      ,start_dt
      ,distr_dt
      ,exp_dt
      ,oper_dt
      ,rgst_dt
      ,termnt_dt
      ,lmt_use_latest_dt
      ,lmt_under_bus_latest_exp_dt
      ,replace(replace(loan_usage_descb,chr(13),''),chr(10),'') as loan_usage_descb
      ,replace(replace(repay_src_descb,chr(13),''),chr(10),'') as repay_src_descb
      ,replace(replace(other_cond_request_descb,chr(13),''),chr(10),'') as other_cond_request_descb
      ,replace(replace(trdpty_cust_name1,chr(13),''),chr(10),'') as trdpty_cust_name1
      ,replace(replace(trdpty_cust_name2,chr(13),''),chr(10),'') as trdpty_cust_name2
      ,rela_cont_id
      ,stl_acct_num
      ,margin_acct_num
      ,margin_curr_cd
      ,margin_ratio
      ,margin_amt
      ,tran_market_type_cd
      ,incre_crdt_way_cd
      ,batch_data_src_cd
      ,backup_lmt_effect_cd
      ,backup_lmt_cont_id
      ,risk_type_cd
      ,major_loan_cls_cd
      ,risk_expose_cls
      ,replace(replace(tran_asset_name,chr(13),''),chr(10),'') as tran_asset_name
      ,dir_ind_fund_flg
      ,dir_makti_debt_eqty_flg
      ,invo_gover_class_fin_flg
      ,consm_serv_class_fin_flg
      ,stl_dep_flg
      ,cota_opt_choice_flg
      ,septbl_flg
      ,onl_bus_flg
      ,class_crdt_flg
      ,crdt_bus_flow_type_cd
      ,crdt_rg_cd
      ,estate_fin_flg
      ,gover_class_fin_flg1
      ,br_build_ifin_flg
      ,green_crdt_fin_flg
      ,trade_cont_id
      ,trade_cont_curr_cd
      ,trade_cont_amt
      ,bill_qtty
      ,discnt_bf_revw_flg
      ,discnt_int_buyer_bear_ratio
      ,discnt_int_applit_pay_ratio
      ,agt_pay_int_flg
      ,bill_uniq_idf_id
      ,trdpty_acct_id
      ,loan_src_cd
      ,comm_fee_rat
      ,comm_fee_amt
      ,lc_id
      ,lc_amt
      ,syn_loan_distr_amt
      ,tenor
      ,base_rat
      ,int_rat_flo_val
      ,exec_int_rat
      ,bank_fin_tot
      ,open_bal
      ,cont_amt
      ,cont_aval_bal
      ,acm_distr_amt
      ,acm_callbk_amt
  from ${icl_schema}.cmm_corp_loan_cont_info t1
 where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes