: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_appl_mini_loan_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_appl_mini_loan_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,replace(replace(t1.adv_repay_applit_name,chr(13),''),chr(10),'') as adv_repay_applit_name
,fst_estate_avg
,secd_estate_avg
,replace(replace(t1.fst_estate_cert_num,chr(13),''),chr(10),'') as fst_estate_cert_num
,replace(replace(t1.secd_estate_cert_num,chr(13),''),chr(10),'') as secd_estate_cert_num
,replace(replace(t1.fst_estate_cert_addr_dist_cd,chr(13),''),chr(10),'') as fst_estate_cert_addr_dist_cd
,replace(replace(t1.secd_estate_cert_addr_dist_cd,chr(13),''),chr(10),'') as secd_estate_cert_addr_dist_cd
,fst_estate_area
,secd_estate_area
,replace(replace(t1.fst_estate_mtg_flg,chr(13),''),chr(10),'') as fst_estate_mtg_flg
,replace(replace(t1.secd_estate_mtg_flg,chr(13),''),chr(10),'') as secd_estate_mtg_flg
,replace(replace(t1.fst_estate_cert_dtl_addr,chr(13),''),chr(10),'') as fst_estate_cert_dtl_addr
,replace(replace(t1.secd_estate_cert_dtl_addr,chr(13),''),chr(10),'') as secd_estate_cert_dtl_addr
,replace(replace(t1.fst_estate_house_char_cd,chr(13),''),chr(10),'') as fst_estate_house_char_cd
,replace(replace(t1.secd_estate_house_char_cd,chr(13),''),chr(10),'') as secd_estate_house_char_cd
,fst_estate_own_prop_number
,secd_estate_own_prop_number
,fst_estate_brwer_prop_lot
,secd_estate_brwer_prop_lot
,indv_loan_comm_fee_rat
,replace(replace(t1.comm_fee_mode_pay_cd,chr(13),''),chr(10),'') as comm_fee_mode_pay_cd
,promis_fee_rat
,replace(replace(t1.distr_mode_pay_cd,chr(13),''),chr(10),'') as distr_mode_pay_cd
,replace(replace(t1.guar_inten_cd,chr(13),''),chr(10),'') as guar_inten_cd
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,replace(replace(t1.secd_repay_acct_name,chr(13),''),chr(10),'') as secd_repay_acct_name
,replace(replace(t1.secd_repay_acct_id,chr(13),''),chr(10),'') as secd_repay_acct_id
,replace(replace(t1.major_guartor_name,chr(13),''),chr(10),'') as major_guartor_name
,replace(replace(t1.major_guartor_id,chr(13),''),chr(10),'') as major_guartor_id
,replace(replace(t1.entr_pay_acct_name,chr(13),''),chr(10),'') as entr_pay_acct_name
,replace(replace(t1.entr_pay_acct_id,chr(13),''),chr(10),'') as entr_pay_acct_id
,init_loan_amt
,loan_usage_tran_amt
,replace(replace(t1.loan_deduct_way_cd,chr(13),''),chr(10),'') as loan_deduct_way_cd
,replace(replace(t1.loan_int_set_way_cd,chr(13),''),chr(10),'') as loan_int_set_way_cd
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id
,replace(replace(t1.first_trial_teller_id,chr(13),''),chr(10),'') as first_trial_teller_id
,occu_lmt
,resv_pric
,occu_margin_amt
,comm_fee_amt
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,latest_apv_amt
,replace(replace(t1.stud_loan_deflt_prod_id,chr(13),''),chr(10),'') as stud_loan_deflt_prod_id
,replace(replace(t1.modif_prod_id_flg,chr(13),''),chr(10),'') as modif_prod_id_flg
,replace(replace(t1.ky_l_flg,chr(13),''),chr(10),'') as ky_l_flg
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id
,replace(replace(t1.apv_lev_cd,chr(13),''),chr(10),'') as apv_lev_cd
,replace(replace(t1.force_manu_apv_flg,chr(13),''),chr(10),'') as force_manu_apv_flg
,replace(replace(t1.camp_chn_id,chr(13),''),chr(10),'') as camp_chn_id
,replace(replace(t1.camp_corp_id,chr(13),''),chr(10),'') as camp_corp_id
,replace(replace(t1.init_withhold_mgmt_fee_sign_flg,chr(13),''),chr(10),'') as init_withhold_mgmt_fee_sign_flg
,replace(replace(t1.guar_corp_id,chr(13),''),chr(10),'') as guar_corp_id
,replace(replace(t1.intror_id,chr(13),''),chr(10),'') as intror_id
,guar_corp_occu_lmt
,replace(replace(t1.camp_corp_name,chr(13),''),chr(10),'') as camp_corp_name
,replace(replace(t1.camp_chn_name,chr(13),''),chr(10),'') as camp_chn_name

from ${iml_schema}.agt_loan_appl_mini_loan_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_appl_mini_loan_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
