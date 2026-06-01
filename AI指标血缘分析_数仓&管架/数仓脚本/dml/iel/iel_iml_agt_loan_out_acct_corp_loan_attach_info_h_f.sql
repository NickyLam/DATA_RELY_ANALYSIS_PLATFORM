: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_out_acct_corp_loan_attach_info_h_f
CreateDate: 20250707
FileName:   ${iel_data_path}/agt_loan_out_acct_corp_loan_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,replace(replace(t1.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
,replace(replace(t1.entr_dep_acct_id,chr(13),''),chr(10),'') as entr_dep_acct_id
,replace(replace(t1.entr_dep_sub_acct_num,chr(13),''),chr(10),'') as entr_dep_sub_acct_num
,replace(replace(t1.csner_dep_acct_id,chr(13),''),chr(10),'') as csner_dep_acct_id
,replace(replace(t1.pric_auto_rtn_flg,chr(13),''),chr(10),'') as pric_auto_rtn_flg
,replace(replace(t1.int_auto_rtn_flg,chr(13),''),chr(10),'') as int_auto_rtn_flg
,replace(replace(t1.comn_inst_repay_flg,chr(13),''),chr(10),'') as comn_inst_repay_flg
,inst_loan_tot_perds
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,entr_loan_comm_fee_rat
,replace(replace(t1.crdt_distr_repay_plan_flg,chr(13),''),chr(10),'') as crdt_distr_repay_plan_flg
,replace(replace(t1.stop_accr_int_flg,chr(13),''),chr(10),'') as stop_accr_int_flg
,replace(replace(t1.margin_int_rat_type_cd,chr(13),''),chr(10),'') as margin_int_rat_type_cd
,replace(replace(t1.margin_int_rat_float_type_cd,chr(13),''),chr(10),'') as margin_int_rat_float_type_cd
,replace(replace(t1.margin_int_rat_float_way_cd,chr(13),''),chr(10),'') as margin_int_rat_float_way_cd
,margin_flo_val
,replace(replace(t1.margin_int_accr_method_cd,chr(13),''),chr(10),'') as margin_int_accr_method_cd
,replace(replace(t1.margin_int_rat_level_cd,chr(13),''),chr(10),'') as margin_int_rat_level_cd
,margin_agt_rat
,margin_exp_dt
,replace(replace(t1.bill_uniq_ind_no,chr(13),''),chr(10),'') as bill_uniq_ind_no
,lc_amt
,ibank_payfan_pric
,replace(replace(t1.discnt_bus_accptor_name,chr(13),''),chr(10),'') as discnt_bus_accptor_name
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.strk_bal_flg,chr(13),''),chr(10),'') as strk_bal_flg
,int_accr_days
,ibank_payfan_provi_int_rat
,todos
,replace(replace(t1.bill_comm_fee_charge_way_cd,chr(13),''),chr(10),'') as bill_comm_fee_charge_way_cd
,replace(replace(t1.log_mode_pay_cd,chr(13),''),chr(10),'') as log_mode_pay_cd
,replace(replace(t1.acpt_bus_accptor_name,chr(13),''),chr(10),'') as acpt_bus_accptor_name
,draw_dt
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.trust_flg,chr(13),''),chr(10),'') as trust_flg
,replace(replace(t1.bill_cls_cd,chr(13),''),chr(10),'') as bill_cls_cd
,replace(replace(t1.intstl_bus_id,chr(13),''),chr(10),'') as intstl_bus_id
,accpt_bil_comm_fee_amt
,trade_fin_rela_amt_one
,trade_fin_rela_amt_two
,trade_fin_rela_amt_three
,trade_fin_rela_dt_one
,trade_fin_rela_dt_two
,trade_fin_ratio
,replace(replace(t1.coll_type_cd,chr(13),''),chr(10),'') as coll_type_cd
,replace(replace(t1.bill_rgst_status_flg,chr(13),''),chr(10),'') as bill_rgst_status_flg
,replace(replace(t1.guar_org_id,chr(13),''),chr(10),'') as guar_org_id
,int_amt
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
,replace(replace(t1.trade_fin_type_cd,chr(13),''),chr(10),'') as trade_fin_type_cd
,replace(replace(t1.exp_lc_issue_bank_name,chr(13),''),chr(10),'') as exp_lc_issue_bank_name
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.accept_ps_name,chr(13),''),chr(10),'') as accept_ps_name
,replace(replace(t1.inv_id,chr(13),''),chr(10),'') as inv_id
,replace(replace(t1.enter_id,chr(13),''),chr(10),'') as enter_id
,replace(replace(t1.distr_cond_impt_flg,chr(13),''),chr(10),'') as distr_cond_impt_flg
,replace(replace(t1.trade_fin_rela_curr_cd_one,chr(13),''),chr(10),'') as trade_fin_rela_curr_cd_one
,replace(replace(t1.trade_fin_rela_curr_cd_two,chr(13),''),chr(10),'') as trade_fin_rela_curr_cd_two
,replace(replace(t1.trade_fin_rela_curr_cd_three,chr(13),''),chr(10),'') as trade_fin_rela_curr_cd_three
,replace(replace(t1.log_bnft_bank_name,chr(13),''),chr(10),'') as log_bnft_bank_name
,replace(replace(t1.fft_acpt_bank_no,chr(13),''),chr(10),'') as fft_acpt_bank_no
,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'') as accptor_open_bank_no
,replace(replace(t1.fft_cfm_bank_bank_no,chr(13),''),chr(10),'') as fft_cfm_bank_bank_no
,buyer_pay_int_amt
,replace(replace(t1.redem_flg,chr(13),''),chr(10),'') as redem_flg
,replace(replace(t1.trade_fin_bus_id_one,chr(13),''),chr(10),'') as trade_fin_bus_id_one
,replace(replace(t1.trade_fin_bus_id_two,chr(13),''),chr(10),'') as trade_fin_bus_id_two
,replace(replace(t1.era_pay_bank_name,chr(13),''),chr(10),'') as era_pay_bank_name
,replace(replace(t1.log_type_cd,chr(13),''),chr(10),'') as log_type_cd
,replace(replace(t1.trade_fin_tenor_type_cd_one,chr(13),''),chr(10),'') as trade_fin_tenor_type_cd_one
,replace(replace(t1.trade_fin_tenor_type_cd_two,chr(13),''),chr(10),'') as trade_fin_tenor_type_cd_two
,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'') as accptor_open_bank_name
,replace(replace(t1.stl_acct_open_bank_name,chr(13),''),chr(10),'') as stl_acct_open_bank_name
,replace(replace(t1.stl_acct_cust_name,chr(13),''),chr(10),'') as stl_acct_cust_name
,replace(replace(t1.buyer_pay_int_acct_id,chr(13),''),chr(10),'') as buyer_pay_int_acct_id
,replace(replace(t1.fin_log_flg,chr(13),''),chr(10),'') as fin_log_flg
,replace(replace(t1.enter_open_bank_name,chr(13),''),chr(10),'') as enter_open_bank_name
,replace(replace(t1.enter_cust_name,chr(13),''),chr(10),'') as enter_cust_name
,replace(replace(t1.payfan_pric_repay_way_cd,chr(13),''),chr(10),'') as payfan_pric_repay_way_cd
,replace(replace(t1.lmt_cont_id,chr(13),''),chr(10),'') as lmt_cont_id
,replace(replace(t1.pre_recv_int_flg,chr(13),''),chr(10),'') as pre_recv_int_flg
,replace(replace(t1.coll_comp_int_flg,chr(13),''),chr(10),'') as coll_comp_int_flg
,replace(replace(t1.out_acct_tran_code,chr(13),''),chr(10),'') as out_acct_tran_code
,replace(replace(t1.check_org_id,chr(13),''),chr(10),'') as check_org_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,check_dt
,replace(replace(t1.margin_tran_status_cd,chr(13),''),chr(10),'') as margin_tran_status_cd
,replace(replace(t1.repay_plan_tran_status_cd,chr(13),''),chr(10),'') as repay_plan_tran_status_cd
,replace(replace(t1.core_out_acct_flow_num,chr(13),''),chr(10),'') as core_out_acct_flow_num
,replace(replace(t1.fin_sys_out_acct_flg,chr(13),''),chr(10),'') as fin_sys_out_acct_flg
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,acpt_entry_tran_dt
,replace(replace(t1.acpt_entry_tran_flow_num,chr(13),''),chr(10),'') as acpt_entry_tran_flow_num
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.file_int_flg,chr(13),''),chr(10),'') as file_int_flg
,replace(replace(t1.lc_issuer,chr(13),''),chr(10),'') as lc_issuer
,replace(replace(t1.lc_benefc,chr(13),''),chr(10),'') as lc_benefc
,replace(replace(t1.fix_int_rat_flg,chr(13),''),chr(10),'') as fix_int_rat_flg
,replace(replace(t1.lc_benefc_name,chr(13),''),chr(10),'') as lc_benefc_name
,replace(replace(t1.cntpty_recvbl_bank_name,chr(13),''),chr(10),'') as cntpty_recvbl_bank_name
,replace(replace(t1.centr_out_acct_flg,chr(13),''),chr(10),'') as centr_out_acct_flg

from ${iml_schema}.agt_loan_out_acct_corp_loan_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_out_acct_corp_loan_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
