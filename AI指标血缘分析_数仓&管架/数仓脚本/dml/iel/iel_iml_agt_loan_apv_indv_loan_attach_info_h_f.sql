: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_apv_indv_loan_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_apv_indv_loan_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.apv_flow_num,chr(13),''),chr(10),'') as apv_flow_num
,replace(replace(t1.buy_cont_id,chr(13),''),chr(10),'') as buy_cont_id
,replace(replace(t1.house_form_cd,chr(13),''),chr(10),'') as house_form_cd
,replace(replace(t1.house_level_cd,chr(13),''),chr(10),'') as house_level_cd
,replace(replace(t1.fir_buy_flg,chr(13),''),chr(10),'') as fir_buy_flg
,replace(replace(t1.house_wat_num,chr(13),''),chr(10),'') as house_wat_num
,replace(replace(t1.house_dtl_addr,chr(13),''),chr(10),'') as house_dtl_addr
,house_cnt
,house_tot_price
,arch_area
,set_of_area
,arch_area_price
,set_of_area_price
,first_pay_amt
,first_pay_ratio
,replace(replace(t1.down_payment_src_descb,chr(13),''),chr(10),'') as down_payment_src_descb
,loan_ratio
,estim_price
,idtfy_price
,replace(replace(t1.estim_org_cert_no,chr(13),''),chr(10),'') as estim_org_cert_no
,replace(replace(t1.estim_org_name,chr(13),''),chr(10),'') as estim_org_name
,replace(replace(t1.int_sub_flg,chr(13),''),chr(10),'') as int_sub_flg
,int_sub_ratio
,replace(replace(t1.usage_descb,chr(13),''),chr(10),'') as usage_descb
,replace(replace(t1.cap_dir_cd,chr(13),''),chr(10),'') as cap_dir_cd
,replace(replace(t1.buy_insure_flg,chr(13),''),chr(10),'') as buy_insure_flg
,replace(replace(t1.insure_breed_id,chr(13),''),chr(10),'') as insure_breed_id
,insu_benef_lmt
,insure_tenor
,replace(replace(t1.distr_mode_pay_cd,chr(13),''),chr(10),'') as distr_mode_pay_cd
,replace(replace(t1.pay_obj_name,chr(13),''),chr(10),'') as pay_obj_name
,replace(replace(t1.car_type,chr(13),''),chr(10),'') as car_type
,replace(replace(t1.seller_corp_cd,chr(13),''),chr(10),'') as seller_corp_cd
,replace(replace(t1.seller_bus_lics_id,chr(13),''),chr(10),'') as seller_bus_lics_id
,replace(replace(t1.seller_corp_name,chr(13),''),chr(10),'') as seller_corp_name
,replace(replace(t1.estat_name,chr(13),''),chr(10),'') as estat_name
,arti_mgmt_fee_price
,car_tot_price
,free_claim_rat
,replace(replace(t1.guar_flg,chr(13),''),chr(10),'') as guar_flg
,replace(replace(t1.guar_type_cd,chr(13),''),chr(10),'') as guar_type_cd
,replace(replace(t1.presell_lics_id,chr(13),''),chr(10),'') as presell_lics_id
,replace(replace(t1.seller_bear_repo_duty_flg,chr(13),''),chr(10),'') as seller_bear_repo_duty_flg
,replace(replace(t1.rela_agt_id,chr(13),''),chr(10),'') as rela_agt_id
,replace(replace(t1.insu_comp_name,chr(13),''),chr(10),'') as insu_comp_name
,replace(replace(t1.insure_cont_id,chr(13),''),chr(10),'') as insure_cont_id
,replace(replace(t1.buy_estate_type_cd,chr(13),''),chr(10),'') as buy_estate_type_cd
,buy_estate_area
,fitmt_tot_price
,comm_fee_amt
,replace(replace(t1.comm_fee_mode_pay_cd,chr(13),''),chr(10),'') as comm_fee_mode_pay_cd
,replace(replace(t1.rela_agent_recd_id,chr(13),''),chr(10),'') as rela_agent_recd_id
,replace(replace(t1.seller_ps_name,chr(13),''),chr(10),'') as seller_ps_name
,replace(replace(t1.seller_ps_cert_no,chr(13),''),chr(10),'') as seller_ps_cert_no
,replace(replace(t1.rel_esat_cert_id,chr(13),''),chr(10),'') as rel_esat_cert_id
,replace(replace(t1.buy_car_cont_id,chr(13),''),chr(10),'') as buy_car_cont_id
,replace(replace(t1.buy_carp_dtl_addr,chr(13),''),chr(10),'') as buy_carp_dtl_addr
,carp_area
,carp_tot_price
,replace(replace(t1.indv_opering_loan_cls_cd,chr(13),''),chr(10),'') as indv_opering_loan_cls_cd
,replace(replace(t1.open_corp_stl_acct_flg,chr(13),''),chr(10),'') as open_corp_stl_acct_flg
,replace(replace(t1.es_envi_prot_cls_cd,chr(13),''),chr(10),'') as es_envi_prot_cls_cd
,replace(replace(t1.entr_loan_risk_cls_cd,chr(13),''),chr(10),'') as entr_loan_risk_cls_cd
,replace(replace(t1.entr_loan_dep_acct_id,chr(13),''),chr(10),'') as entr_loan_dep_acct_id
,replace(replace(t1.entr_dep_curr_cd,chr(13),''),chr(10),'') as entr_dep_curr_cd
,entr_dep_amt
,replace(replace(t1.entr_cond_descb,chr(13),''),chr(10),'') as entr_cond_descb
,indv_loan_comm_fee_rat
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.arch_corp_name,chr(13),''),chr(10),'') as arch_corp_name

from ${iml_schema}.agt_loan_apv_indv_loan_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_apv_indv_loan_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
