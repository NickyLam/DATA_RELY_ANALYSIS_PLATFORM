: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_appl_indv_loan_attach_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_loan_appl_indv_loan_attach_info_h.i.${batch_date}.dat
IF_mark:    i
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
,t1.cap_dir_cd as cap_dir_cd
,t1.buy_insure_flg as buy_insure_flg
,t1.insure_breed_id as insure_breed_id
,t1.insu_benef_lmt as insu_benef_lmt
,t1.insure_tenor as insure_tenor
,t1.distr_mode_pay_cd as distr_mode_pay_cd
,t1.pay_obj_name as pay_obj_name
,t1.car_type as car_type
,t1.seller_corp_cd as seller_corp_cd
,t1.seller_bus_lics_id as seller_bus_lics_id
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
,t1.buy_car_cont_id as buy_car_cont_id
,t1.buy_carp_dtl_addr as buy_carp_dtl_addr
,t1.carp_area as carp_area
,t1.carp_tot_price as carp_tot_price
,t1.indv_opering_loan_cls_cd as indv_opering_loan_cls_cd
,t1.open_corp_stl_acct_flg as open_corp_stl_acct_flg
,t1.es_envi_prot_cls_cd as es_envi_prot_cls_cd
,t1.entr_loan_risk_cls_cd as entr_loan_risk_cls_cd
,t1.entr_loan_dep_acct_id as entr_loan_dep_acct_id
,t1.entr_dep_curr_cd as entr_dep_curr_cd
,t1.entr_dep_amt as entr_dep_amt
,t1.entr_cond_descb as entr_cond_descb
,t1.car_tot_price as car_tot_price
,t1.indv_loan_comm_fee_rat as indv_loan_comm_fee_rat
,t1.lp_id as lp_id
,t1.arch_corp_name as arch_corp_name
,t1.expt_lmt_flg as expt_lmt_flg
,t1.onl_apv_flg as onl_apv_flg
,t1.white_acct_flg as white_acct_flg
,t1.bar_flg as bar_flg
,t1.and_hxb_exist_incid_rela_flg as and_hxb_exist_incid_rela_flg
,t1.hxb_open_supv_acct_flg as hxb_open_supv_acct_flg
,t1.blon_loan_amort_exp_dt as blon_loan_amort_exp_dt
,t1.intd_blip_flg as intd_blip_flg
,t1.blip_flow_num as blip_flow_num
,t1.blip_cmplt_upload_flg as blip_cmplt_upload_flg
,t1.sugst_loan_amt as sugst_loan_amt
,t1.redem_house_lon_final_risk_mgmt_rest_cd as redem_house_lon_final_risk_mgmt_rest_cd
,t1.deflt_repay_day as deflt_repay_day
,t1.rela_flow_num as rela_flow_num
,t1.appl_lmt as appl_lmt
,t1.recv_bank_name as recv_bank_name
,t1.recver_name as recver_name
,t1.recver_acct_id as recver_acct_id
,t1.grace_days as grace_days
,t1.open_acct_bind_mobile_no as open_acct_bind_mobile_no
,t1.flow_type_cd as flow_type_cd
,t1.corp_lmt_ctrl_flg as corp_lmt_ctrl_flg
,t1.rtn_pric_ratio as rtn_pric_ratio
,t1.rtn_pric_intrv as rtn_pric_intrv
,t1.invstg_opinion_descb as invstg_opinion_descb
,t1.crdt_level as crdt_level
,t1.apv_end_tm as apv_end_tm
,t1.chn_id as chn_id
,t1.rest_advise_sucs_flg as rest_advise_sucs_flg
,t1.apv_tm as apv_tm
,t1.taxpayer_idtfy_num as taxpayer_idtfy_num
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.appl_id as appl_id
,t1.appl_flow_num as appl_flow_num

from ${idl_schema}.oass_agt_loan_appl_indv_loan_attach_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_appl_indv_loan_attach_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
