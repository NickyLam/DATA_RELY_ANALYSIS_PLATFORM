: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_loan_sub_acct_bal_flow_a
CreateDate: 20241104
FileName:   ${iel_data_path}/evt_loan_sub_acct_bal_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.src_sys_cd,chr(13),''),chr(10),'') as src_sys_cd
,replace(replace(t1.core_loan_num,chr(13),''),chr(10),'') as core_loan_num
,tran_dt
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.sub_tran_cate_cd,chr(13),''),chr(10),'') as sub_tran_cate_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,cont_exec_int_rat
,replace(replace(t1.init_loan_num,chr(13),''),chr(10),'') as init_loan_num
,nomal_pric
,log_pric
,wrtn_off_pric
,wrtn_off_advc_money
,replace(replace(t1.int_sub_flg,chr(13),''),chr(10),'') as int_sub_flg
,replace(replace(t1.pre_recv_int_flg,chr(13),''),chr(10),'') as pre_recv_int_flg
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,value_dt
,next_int_set_dt
,wrtn_off_int
,replace(replace(t1.acru_flg,chr(13),''),chr(10),'') as acru_flg
,acru_int
,off_bs_acru_comp_int
,acru_aldy_impam_int
,non_acru_int_recvbl
,int_recvbl
,recvbl_uncol_int
,taxable_colled_int
,int_recvbl_taxable
,off_bs_int_recvbl
,off_bs_recvbl_comp_int
,off_bs_acru_int
,int_income
,replace(replace(t1.impam_flg,chr(13),''),chr(10),'') as impam_flg
,asset_impam_loss_amt
,aldy_impam_int
,aldy_impam_int_income
,loan_impam_resv_lmt
,other_acct_recvbl_impam_resv_lmt
,th_year_aldy_impam_int_income
,replace(replace(t1.renew_flg,chr(13),''),chr(10),'') as renew_flg
,replace(replace(t1.abs_flg,chr(13),''),chr(10),'') as abs_flg
,abs_pric
,discnt_int
,replace(replace(t1.merge_flg,chr(13),''),chr(10),'') as merge_flg
,replace(replace(t1.nomal_int_rat_ped_cd,chr(13),''),chr(10),'') as nomal_int_rat_ped_cd
,ovdue_int_rat
,replace(replace(t1.ovdue_int_rat_ped_cd,chr(13),''),chr(10),'') as ovdue_int_rat_ped_cd
,comp_int_int_rat
,replace(replace(t1.comp_int_int_rat_ped_cd,chr(13),''),chr(10),'') as comp_int_int_rat_ped_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t1.loan_level5_cls_cd,chr(13),''),chr(10),'') as loan_level5_cls_cd
,replace(replace(t1.loan_stage,chr(13),''),chr(10),'') as loan_stage
,loan_distr_dt
,loan_distr_amt
,actl_distr_amt
,loan_exp_dt
,replace(replace(t1.tran_way_cd,chr(13),''),chr(10),'') as tran_way_cd
,wrtn_off_bad_debt_pric
,wrtn_off_bad_debt_aldy_impam_int
,wrtn_off_bad_debt_int
,wrtn_off_int_not_tax
,replace(replace(t1.circl_lon_fir_distr_flg,chr(13),''),chr(10),'') as circl_lon_fir_distr_flg
,replace(replace(t1.circl_lon_flg,chr(13),''),chr(10),'') as circl_lon_flg
,replace(replace(t1.amort_flg,chr(13),''),chr(10),'') as amort_flg
,replace(replace(t1.amort_freq_cd,chr(13),''),chr(10),'') as amort_freq_cd
,amort_cost
,replace(replace(t1.indv_bus_flg,chr(13),''),chr(10),'') as indv_bus_flg
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,replace(replace(t1.cap_char_cd,chr(13),''),chr(10),'') as cap_char_cd
,th_year_int_income
,acm_int_income
,th_quar_degree_vat
,output_tax_lmt
,adv_vat_amt
,invest_prft
,th_year_invest_prft
,acm_invest_prft

from ${iml_schema}.evt_loan_sub_acct_bal_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_sub_acct_bal_flow.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
