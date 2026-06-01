: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_out_acct_appl_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_loan_out_acct_appl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cont_id as cont_id
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.prod_id as prod_id
,t1.curr_cd as curr_cd
,t1.cont_amt as cont_amt
,t1.ths_tm_distr_amt as ths_tm_distr_amt
,t1.loan_distr_type_cd as loan_distr_type_cd
,t1.happ_dt as happ_dt
,t1.distr_dt as distr_dt
,t1.exp_dt as exp_dt
,t1.int_rat_mode_cd as int_rat_mode_cd
,t1.fix_int_rat as fix_int_rat
,t1.base_rat_type_cd as base_rat_type_cd
,t1.base_rat as base_rat
,t1.int_rat_float_type_cd as int_rat_float_type_cd
,t1.int_rat_adj_way_cd as int_rat_adj_way_cd
,t1.int_rat_flo_val as int_rat_flo_val
,t1.exec_int_rat as exec_int_rat
,t1.stl_acct_id as stl_acct_id
,t1.enter_id as enter_id
,t1.secd_repay_acct_id as secd_repay_acct_id
,t1.distr_mode_pay_cd as distr_mode_pay_cd
,t1.appl_way_cd as appl_way_cd
,t1.apv_status_cd as apv_status_cd
,t1.belong_strip_line_cd as belong_strip_line_cd
,t1.off_bs_flg as off_bs_flg
,t1.low_risk_flg as low_risk_flg
,t1.lmt_id as lmt_id
,t1.spec_ped_corp_cd as spec_ped_corp_cd
,t1.spec_ped_cd as spec_ped_cd
,t1.repay_way_cd as repay_way_cd
,t1.repay_ped as repay_ped
,t1.repay_ped_cd as repay_ped_cd
,t1.deflt_repay_day as deflt_repay_day
,t1.ovdue_exec_int_rat as ovdue_exec_int_rat
,t1.ovdue_int_rat_float_way_cd as ovdue_int_rat_float_way_cd
,t1.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val
,t1.oper_org_id as oper_org_id
,t1.bus_oper_teller_id as bus_oper_teller_id
,t1.oper_dt as oper_dt
,t1.rgst_teller_id as rgst_teller_id
,t1.rgst_org_id as rgst_org_id
,t1.rgst_dt as rgst_dt
,t1.update_teller_id as update_teller_id
,t1.update_org_id as update_org_id
,t1.modif_dt as modif_dt
,t1.lp_id as lp_id
,t1.text_cont_id as text_cont_id
,t1.margin_acct_id as margin_acct_id
,t1.margin_tran_out_acct_id as margin_tran_out_acct_id
,t1.margin_curr_cd as margin_curr_cd
,t1.margin_ratio as margin_ratio
,t1.margin_sub_acct_num as margin_sub_acct_num
,t1.margin_amt as margin_amt
,t1.dubil_id as dubil_id
,t1.subj_id as subj_id
,t1.out_acct_org_id as out_acct_org_id
,t1.loan_org_id as loan_org_id
,t1.int_accr_way_cd as int_accr_way_cd
,t1.enter_open_acct_org_id as enter_open_acct_org_id
,t1.enter_name as enter_name
,t1.enter_sub_acct_num as enter_sub_acct_num
,t1.comm_fee_collect_way_cd as comm_fee_collect_way_cd
,t1.comm_fee_deduct_acct_id as comm_fee_deduct_acct_id
,t1.comm_fee_amort_flg as comm_fee_amort_flg
,t1.comm_fee_rat as comm_fee_rat
,t1.comm_fee_amt as comm_fee_amt
,t1.loan_usage_cd as loan_usage_cd
,t1.entr_pay_amt as entr_pay_amt
,t1.entr_pay_stop_pay_flow_num as entr_pay_stop_pay_flow_num
,t1.file_dt as file_dt
,t1.major_guar_way_cd as major_guar_way_cd
,t1.mon_tenor as mon_tenor
,t1.day_tenor as day_tenor
,t1.tran_status_cd as tran_status_cd
,t1.tran_tm as tran_tm
,t1.core_tran_dt as core_tran_dt
,t1.core_tran_flow_num as core_tran_flow_num
,t1.stl_acct_name as stl_acct_name
,t1.int_rat_adj_ped_cd as int_rat_adj_ped_cd
,t1.move_remark as move_remark
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.out_acct_flow_num as out_acct_flow_num

from ${idl_schema}.oass_agt_loan_out_acct_appl_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_out_acct_appl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
