: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_cont_indv_loan_attach_info_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_loan_cont_indv_loan_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.buy_cont_id as buy_cont_id
,t1.house_form_cd as house_form_cd
,t1.house_level_cd as house_level_cd
,t1.fir_buy_flg as fir_buy_flg
,t1.house_wat_num as house_wat_num
,t1.house_dtl_addr as house_dtl_addr
,t1.house_cnt as house_cnt
,t1.house_tot_price as house_tot_price
,t1.arch_area as arch_area
,t1.set_of_area as set_of_area
,t1.arch_area_price as arch_area_price
,t1.set_of_area_price as set_of_area_price
,t1.first_pay_amt as first_pay_amt
,t1.first_pay_ratio as first_pay_ratio
,t1.down_payment_src_descb as down_payment_src_descb
,t1.loan_ratio as loan_ratio
,t1.estim_price as estim_price
,t1.idtfy_price as idtfy_price
,t1.estim_org_cert_no as estim_org_cert_no
,t1.estim_org_name as estim_org_name
,t1.int_sub_flg as int_sub_flg
,t1.int_sub_ratio as int_sub_ratio
,t1.csner_cert_no as csner_cert_no
,t1.csner_name as csner_name
,t1.cap_dir_cd as cap_dir_cd
,t1.buy_insure_flg as buy_insure_flg
,t1.insure_breed_id as insure_breed_id
,t1.insu_benef_lmt as insu_benef_lmt
,t1.insure_tenor as insure_tenor
,t1.pay_obj_name as pay_obj_name
,t1.seller_corp_cd as seller_corp_cd
,t1.seller_bus_lics_num as seller_bus_lics_num
,t1.seller_corp_name as seller_corp_name
,t1.estat_name as estat_name
,t1.arti_mgmt_fee_price as arti_mgmt_fee_price
,t1.free_claim_rat as free_claim_rat
,t1.guar_flg as guar_flg
,t1.guar_type_cd as guar_type_cd
,t1.presell_lics_id as presell_lics_id
,t1.seller_bear_repo_duty_flg as seller_bear_repo_duty_flg
,t1.rela_agt_id as rela_agt_id
,t1.insu_comp_name as insu_comp_name
,t1.insure_cont_id as insure_cont_id
,t1.buy_estate_type_cd as buy_estate_type_cd
,t1.buy_estate_area as buy_estate_area
,t1.fitmt_tot_price as fitmt_tot_price
,t1.comm_fee_amt as comm_fee_amt
,t1.comm_fee_mode_pay_cd as comm_fee_mode_pay_cd
,t1.rela_agent_recd_id as rela_agent_recd_id
,t1.seller_ps_name as seller_ps_name
,t1.seller_ps_cert_no as seller_ps_cert_no
,t1.rel_esat_cert_id as rel_esat_cert_id
,t1.car_type as car_type
,t1.buy_car_cont_id as buy_car_cont_id
,t1.buy_carp_dtl_addr as buy_carp_dtl_addr
,t1.carp_area as carp_area
,t1.car_tot_price as car_tot_price
,t1.carp_tot_price as carp_tot_price
,t1.indv_opering_loan_cls_cd as indv_opering_loan_cls_cd
,t1.open_corp_stl_acct_flg as open_corp_stl_acct_flg
,t1.loc_strate_new_indus_cd as loc_strate_new_indus_cd
,t1.es_envi_prot_cls_cd as es_envi_prot_cls_cd
,t1.entr_loan_risk_cls_cd as entr_loan_risk_cls_cd
,t1.entr_loan_dep_acct_id as entr_loan_dep_acct_id
,t1.entr_dep_curr_cd as entr_dep_curr_cd
,t1.entr_dep_amt as entr_dep_amt
,t1.cap_src_descb as cap_src_descb
,t1.entr_cond_descb as entr_cond_descb
,t1.indv_loan_comm_fee_rat as indv_loan_comm_fee_rat
,t1.lp_id as lp_id
,t1.estim_cert_type_cd as estim_cert_type_cd
,t1.arch_corp_name as arch_corp_name
,t1.csner_cust_id as csner_cust_id
,t1.expt_lmt_flg as expt_lmt_flg
,t1.repay_acct_id as repay_acct_id
,t1.repay_acct_name as repay_acct_name
,t1.deflt_repay_day as deflt_repay_day
,t1.bar_flg as bar_flg
,t1.hxb_open_supv_acct_flg as hxb_open_supv_acct_flg
,t1.onl_apv_flg as onl_apv_flg
,t1.use_lmt_flg as use_lmt_flg
,t1.hxb_rela_party_flg as hxb_rela_party_flg
,t1.chn_id as chn_id
,t1.repay_card_type_cd as repay_card_type_cd
,t1.open_acct_bind_id_no as open_acct_bind_id_no
,t1.open_acct_bind_mobile_no as open_acct_bind_mobile_no
,t1.incre_crdt_mode_cd as incre_crdt_mode_cd
,t1.acm_callbk_amt as acm_callbk_amt
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.cont_id as cont_id

from ${idl_schema}.oass_agt_loan_cont_indv_loan_attach_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_cont_indv_loan_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
