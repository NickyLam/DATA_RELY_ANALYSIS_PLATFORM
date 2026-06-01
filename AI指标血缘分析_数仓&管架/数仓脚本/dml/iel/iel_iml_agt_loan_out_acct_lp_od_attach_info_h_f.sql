: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_out_acct_lp_od_attach_info_h_f
CreateDate: 20250414
FileName:   ${iel_data_path}/agt_loan_out_acct_lp_od_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.text_cont_id,chr(13),''),chr(10),'') as text_cont_id
,cont_amt
,replace(replace(t1.od_cust_id,chr(13),''),chr(10),'') as od_cust_id
,replace(replace(t1.od_acct_id,chr(13),''),chr(10),'') as od_acct_id
,replace(replace(t1.od_cust_name,chr(13),''),chr(10),'') as od_cust_name
,replace(replace(t1.od_sub_acct_num,chr(13),''),chr(10),'') as od_sub_acct_num
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,od_lmt
,od_int_rat
,start_od_amt
,replace(replace(t1.reval_way_cd,chr(13),''),chr(10),'') as reval_way_cd
,base_int_rat
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
,nomal_loan_exec_int_rat
,nomal_loan_float_int_rat
,comm_fee_fee_rat
,od_promis_fee
,replace(replace(t1.od_repay_way_cd,chr(13),''),chr(10),'') as od_repay_way_cd
,replace(replace(t1.recvbl_freq_cd,chr(13),''),chr(10),'') as recvbl_freq_cd
,replace(replace(t1.charge_dt,chr(13),''),chr(10),'') as charge_dt
,sig_od_valid_days
,ovdue_exec_int_rat
,lp_od_nacrsm_free_int_days
,lp_od_lmt_begin_dt
,lp_od_lmt_exp_dt
,ovdue_loan_float_int_rat
,replace(replace(t1.lp_od_not_acrs_mon_idf_cd,chr(13),''),chr(10),'') as lp_od_not_acrs_mon_idf_cd
,replace(replace(t1.lp_od_type_cd,chr(13),''),chr(10),'') as lp_od_type_cd
,replace(replace(t1.temp_store_flg,chr(13),''),chr(10),'') as temp_store_flg
,replace(replace(t1.buid_bus_guar_loan_type_cd,chr(13),''),chr(10),'') as buid_bus_guar_loan_type_cd
,replace(replace(t1.prior_use_acct_bal_flg,chr(13),''),chr(10),'') as prior_use_acct_bal_flg
,replace(replace(t1.buid_bus_guar_loan_flg,chr(13),''),chr(10),'') as buid_bus_guar_loan_flg
,replace(replace(t1.nat_std_indus_dir_cd,chr(13),''),chr(10),'') as nat_std_indus_dir_cd
,replace(replace(t1.agclt_flg,chr(13),''),chr(10),'') as agclt_flg
,replace(replace(t1.agclt_loan_main_type_cd,chr(13),''),chr(10),'') as agclt_loan_main_type_cd
,replace(replace(t1.agclt_loan_dir_cd,chr(13),''),chr(10),'') as agclt_loan_dir_cd
,replace(replace(t1.land_fin_plat_cap_src_cd,chr(13),''),chr(10),'') as land_fin_plat_cap_src_cd
,replace(replace(t1.pla_trast_way_cd,chr(13),''),chr(10),'') as pla_trast_way_cd
,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd
,replace(replace(t1.file_int_flg,chr(13),''),chr(10),'') as file_int_flg
,replace(replace(t1.cap_usage_descb,chr(13),''),chr(10),'') as cap_usage_descb
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark
,rgst_dt
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,oper_dt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t1.loan_org_id,chr(13),''),chr(10),'') as loan_org_id
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.task_status_cd,chr(13),''),chr(10),'') as task_status_cd
,replace(replace(t1.int_rat_float_ped,chr(13),''),chr(10),'') as int_rat_float_ped
,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd
,replace(replace(t1.comm_fee_charge_day,chr(13),''),chr(10),'') as comm_fee_charge_day
,replace(replace(t1.comm_fee_coll_way_cd,chr(13),''),chr(10),'') as comm_fee_coll_way_cd
,replace(replace(t1.comm_fee_charge_freq_cd,chr(13),''),chr(10),'') as comm_fee_charge_freq_cd
,replace(replace(t1.sup_chain_fin_bus_flg,chr(13),''),chr(10),'') as sup_chain_fin_bus_flg
,replace(replace(t1.sup_chain_fin_bus_prod_cls_cd,chr(13),''),chr(10),'') as sup_chain_fin_bus_prod_cls_cd
,replace(replace(t1.natnal_econ_type_cd,chr(13),''),chr(10),'') as natnal_econ_type_cd
,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
,replace(replace(t1.risk_cls_rest_cd,chr(13),''),chr(10),'') as risk_cls_rest_cd
,replace(replace(t1.dmic_st_msg_send_cd,chr(13),''),chr(10),'') as dmic_st_msg_send_cd
,final_update_dt

from ${iml_schema}.agt_loan_out_acct_lp_od_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_out_acct_lp_od_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
