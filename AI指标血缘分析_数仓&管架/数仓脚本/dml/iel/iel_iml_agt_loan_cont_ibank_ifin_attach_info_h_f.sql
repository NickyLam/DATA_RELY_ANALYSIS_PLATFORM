: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_cont_ibank_ifin_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_cont_ibank_ifin_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.actl_finer_id,chr(13),''),chr(10),'') as actl_finer_id
,replace(replace(t1.qual_centr_cntpty_flg,chr(13),''),chr(10),'') as qual_centr_cntpty_flg
,replace(replace(t1.imp_loan_proj_cd,chr(13),''),chr(10),'') as imp_loan_proj_cd
,cntpty_sucs_tran_cnt
,replace(replace(t1.cntpty_co_years,chr(13),''),chr(10),'') as cntpty_co_years
,replace(replace(t1.cntpty_strg,chr(13),''),chr(10),'') as cntpty_strg
,replace(replace(t1.cdb_crdt_flg,chr(13),''),chr(10),'') as cdb_crdt_flg
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,replace(replace(t1.invest_way_cd,chr(13),''),chr(10),'') as invest_way_cd
,replace(replace(t1.mgmt_mode_cd,chr(13),''),chr(10),'') as mgmt_mode_cd
,replace(replace(t1.tran_asset_name,chr(13),''),chr(10),'') as tran_asset_name
,replace(replace(t1.dir_ind_fund_flg,chr(13),''),chr(10),'') as dir_ind_fund_flg
,replace(replace(t1.dir_makti_debt_eqty_flg,chr(13),''),chr(10),'') as dir_makti_debt_eqty_flg
,replace(replace(t1.invo_gover_class_fin_flg,chr(13),''),chr(10),'') as invo_gover_class_fin_flg
,replace(replace(t1.consm_serv_class_fin_flg,chr(13),''),chr(10),'') as consm_serv_class_fin_flg
,replace(replace(t1.underly_prod_id,chr(13),''),chr(10),'') as underly_prod_id
,replace(replace(t1.underly_prod_name,chr(13),''),chr(10),'') as underly_prod_name
,replace(replace(t1.septbl_flg,chr(13),''),chr(10),'') as septbl_flg
,replace(replace(t1.cota_opt_choice_flg,chr(13),''),chr(10),'') as cota_opt_choice_flg
,put_appl_begin_dt
,put_appl_closing_dt
,replace(replace(t1.tran_market_type_cd,chr(13),''),chr(10),'') as tran_market_type_cd
,replace(replace(t1.tran_market_name,chr(13),''),chr(10),'') as tran_market_name
,cash_dt
,replace(replace(t1.incre_crdt_way_cd,chr(13),''),chr(10),'') as incre_crdt_way_cd
,replace(replace(t1.class_crdt_flg,chr(13),''),chr(10),'') as class_crdt_flg
,replace(replace(t1.underly_prod_cls_flg,chr(13),''),chr(10),'') as underly_prod_cls_flg
,replace(replace(t1.underly_prod_cls_lev_cd,chr(13),''),chr(10),'') as underly_prod_cls_lev_cd
,underly_prod_coll_amt
,replace(replace(t1.uder_asset_type_cd,chr(13),''),chr(10),'') as uder_asset_type_cd
,replace(replace(t1.csner_name,chr(13),''),chr(10),'') as csner_name
,replace(replace(t1.csner_id,chr(13),''),chr(10),'') as csner_id
,replace(replace(t1.acpt_bank_no,chr(13),''),chr(10),'') as acpt_bank_no
,bill_draw_dt
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.bill_curr_cd,chr(13),''),chr(10),'') as bill_curr_cd
,bill_exp_dt
,replace(replace(t1.pente_type_cd,chr(13),''),chr(10),'') as pente_type_cd
,replace(replace(t1.trust_am_cont_name,chr(13),''),chr(10),'') as trust_am_cont_name
,replace(replace(t1.trust_am_cont_type_cd,chr(13),''),chr(10),'') as trust_am_cont_type_cd
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd
,replace(replace(t1.imp_loan_proj_flg,chr(13),''),chr(10),'') as imp_loan_proj_flg
,replace(replace(t1.acpt_bank_name,chr(13),''),chr(10),'') as acpt_bank_name
,replace(replace(t1.benefc_name,chr(13),''),chr(10),'') as benefc_name
,benefc_expect_year_net_yld_rat
,replace(replace(t1.benefc_acct_id,chr(13),''),chr(10),'') as benefc_acct_id
,replace(replace(t1.fix_asset_crdt_flg,chr(13),''),chr(10),'') as fix_asset_crdt_flg
,replace(replace(t1.other_cond_request_descb,chr(13),''),chr(10),'') as other_cond_request_descb
,replace(replace(t1.dir_paste_bank_name,chr(13),''),chr(10),'') as dir_paste_bank_name
,replace(replace(t1.dir_paste_bank_no,chr(13),''),chr(10),'') as dir_paste_bank_no
,replace(replace(t1.dir_paste_hxb_cust_id,chr(13),''),chr(10),'') as dir_paste_hxb_cust_id
,replace(replace(t1.hxb_dir_paste_bill_flg,chr(13),''),chr(10),'') as hxb_dir_paste_bill_flg
,replace(replace(t1.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd
,replace(replace(t1.rela_trade_cont_id,chr(13),''),chr(10),'') as rela_trade_cont_id
,replace(replace(t1.stl_dep_flg,chr(13),''),chr(10),'') as stl_dep_flg
,replace(replace(t1.coll_cap_acct_id,chr(13),''),chr(10),'') as coll_cap_acct_id
,commer_inv_amt
,replace(replace(t1.loan_fin_supt_way_cd,chr(13),''),chr(10),'') as loan_fin_supt_way_cd
,replace(replace(t1.commer_inv_id,chr(13),''),chr(10),'') as commer_inv_id
,replace(replace(t1.commer_inv_type_cd,chr(13),''),chr(10),'') as commer_inv_type_cd
,replace(replace(t1.sup_chain_fin_bus_flg,chr(13),''),chr(10),'') as sup_chain_fin_bus_flg
,replace(replace(t1.sup_chain_fin_bus_prod_cls_cd,chr(13),''),chr(10),'') as sup_chain_fin_bus_prod_cls_cd
,replace(replace(t1.commer_inv_curr_cd,chr(13),''),chr(10),'') as commer_inv_curr_cd
,replace(replace(t1.surp_indus_cd,chr(13),''),chr(10),'') as surp_indus_cd
,replace(replace(t1.entred_ps_name,chr(13),''),chr(10),'') as entred_ps_name
,replace(replace(t1.gover_crdt_flg,chr(13),''),chr(10),'') as gover_crdt_flg
,replace(replace(t1.gover_crdt_supt_way_cd,chr(13),''),chr(10),'') as gover_crdt_supt_way_cd
,replace(replace(t1.gover_crdt_type_cd,chr(13),''),chr(10),'') as gover_crdt_type_cd
,discount_int_rat
,fac_val_amt
,replace(replace(t1.trustee_name,chr(13),''),chr(10),'') as trustee_name
,replace(replace(t1.bill_cls_cd,chr(13),''),chr(10),'') as bill_cls_cd
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,underly_tenor
,issue_amt
,replace(replace(t1.cty_lmt_indus_flg,chr(13),''),chr(10),'') as cty_lmt_indus_flg
,trade_cont_tot_amt
,replace(replace(t1.mger_name,chr(13),''),chr(10),'') as mger_name
,replace(replace(t1.dep_rcpt_no_code,chr(13),''),chr(10),'') as dep_rcpt_no_code
,replace(replace(t1.agclt_flg,chr(13),''),chr(10),'') as agclt_flg
,replace(replace(t1.repay_comnt_descb,chr(13),''),chr(10),'') as repay_comnt_descb
,replace(replace(t1.underly_stock_cd,chr(13),''),chr(10),'') as underly_stock_cd
,replace(replace(t1.underly_stock_name,chr(13),''),chr(10),'') as underly_stock_name
,replace(replace(t1.brwer_name,chr(13),''),chr(10),'') as brwer_name
,replace(replace(t1.use_prod_cd,chr(13),''),chr(10),'') as use_prod_cd
,replace(replace(t1.draw_comnt_descb,chr(13),''),chr(10),'') as draw_comnt_descb
,replace(replace(t1.bank_int_indus_dir_cd,chr(13),''),chr(10),'') as bank_int_indus_dir_cd
,replace(replace(t1.invest_char_cd,chr(13),''),chr(10),'') as invest_char_cd
,replace(replace(t1.cdb_crdt_prod_id,chr(13),''),chr(10),'') as cdb_crdt_prod_id
,issue_dt
,exp_dt
,replace(replace(t1.tran_bg_descb,chr(13),''),chr(10),'') as tran_bg_descb
,replace(replace(t1.ncds_abbr,chr(13),''),chr(10),'') as ncds_abbr
,replace(replace(t1.draw_way_cd,chr(13),''),chr(10),'') as draw_way_cd
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t1.batch_data_src_cd,chr(13),''),chr(10),'') as batch_data_src_cd
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id

from ${iml_schema}.agt_loan_cont_ibank_ifin_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_cont_ibank_ifin_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
