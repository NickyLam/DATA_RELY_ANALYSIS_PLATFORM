: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_loan_out_acct_appl_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_out_acct_appl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.cont_amt as cont_amt
,t1.ths_tm_distr_amt as ths_tm_distr_amt
,replace(replace(t1.loan_distr_type_cd,chr(13),''),chr(10),'') as loan_distr_type_cd
,t1.happ_dt as happ_dt
,t1.distr_dt as distr_dt
,t1.exp_dt as exp_dt
,replace(replace(t1.int_rat_mode_cd,chr(13),''),chr(10),'') as int_rat_mode_cd
,t1.fix_int_rat as fix_int_rat
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
,t1.base_rat as base_rat
,replace(replace(t1.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,t1.int_rat_flo_val as int_rat_flo_val
,t1.exec_int_rat as exec_int_rat
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id
,replace(replace(t1.enter_id,chr(13),''),chr(10),'') as enter_id
,replace(replace(t1.secd_repay_acct_id,chr(13),''),chr(10),'') as secd_repay_acct_id
,replace(replace(t1.distr_mode_pay_cd,chr(13),''),chr(10),'') as distr_mode_pay_cd
,replace(replace(t1.appl_way_cd,chr(13),''),chr(10),'') as appl_way_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.belong_strip_line_cd,chr(13),''),chr(10),'') as belong_strip_line_cd
,replace(replace(t1.off_bs_flg,chr(13),''),chr(10),'') as off_bs_flg
,replace(replace(t1.low_risk_flg,chr(13),''),chr(10),'') as low_risk_flg
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.spec_ped_corp_cd,chr(13),''),chr(10),'') as spec_ped_corp_cd
,replace(replace(t1.spec_ped_cd,chr(13),''),chr(10),'') as spec_ped_cd
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t1.repay_ped_cd,chr(13),''),chr(10),'') as repay_ped_cd
,t1.deflt_repay_day as deflt_repay_day
,t1.ovdue_exec_int_rat as ovdue_exec_int_rat
,replace(replace(t1.ovdue_int_rat_float_way_cd,chr(13),''),chr(10),'') as ovdue_int_rat_float_way_cd
,t1.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,replace(replace(t1.bus_oper_teller_id,chr(13),''),chr(10),'') as bus_oper_teller_id
,t1.oper_dt as oper_dt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,t1.rgst_dt as rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,t1.modif_dt as modif_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.text_cont_id,chr(13),''),chr(10),'') as text_cont_id
,replace(replace(t1.margin_acct_id,chr(13),''),chr(10),'') as margin_acct_id
,replace(replace(t1.margin_tran_out_acct_id,chr(13),''),chr(10),'') as margin_tran_out_acct_id
,replace(replace(t1.margin_curr_cd,chr(13),''),chr(10),'') as margin_curr_cd
,t1.margin_ratio as margin_ratio
,replace(replace(t1.margin_sub_acct_num,chr(13),''),chr(10),'') as margin_sub_acct_num
,t1.margin_amt as margin_amt
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.out_acct_org_id,chr(13),''),chr(10),'') as out_acct_org_id
,replace(replace(t1.loan_org_id,chr(13),''),chr(10),'') as loan_org_id
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.enter_open_acct_org_id,chr(13),''),chr(10),'') as enter_open_acct_org_id
,replace(replace(t1.enter_name,chr(13),''),chr(10),'') as enter_name
,replace(replace(t1.enter_sub_acct_num,chr(13),''),chr(10),'') as enter_sub_acct_num
,replace(replace(t1.comm_fee_collect_way_cd,chr(13),''),chr(10),'') as comm_fee_collect_way_cd
,replace(replace(t1.comm_fee_deduct_acct_id,chr(13),''),chr(10),'') as comm_fee_deduct_acct_id
,replace(replace(t1.comm_fee_amort_flg,chr(13),''),chr(10),'') as comm_fee_amort_flg
,t1.comm_fee_rat as comm_fee_rat
,t1.comm_fee_amt as comm_fee_amt
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
,t1.entr_pay_amt as entr_pay_amt
,replace(replace(t1.entr_pay_stop_pay_flow_num,chr(13),''),chr(10),'') as entr_pay_stop_pay_flow_num
,t1.file_dt as file_dt
,replace(replace(t1.major_guar_way_cd,chr(13),''),chr(10),'') as major_guar_way_cd
,t1.mon_tenor as mon_tenor
,t1.day_tenor as day_tenor
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,t1.tran_tm as tran_tm
,t1.core_tran_dt as core_tran_dt
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name
,replace(replace(t1.int_rat_adj_ped_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.move_remark,chr(13),''),chr(10),'') as move_remark
,replace(replace(t1.repay_ped,chr(13),''),chr(10),'') as repay_ped
from ${iml_schema}.agt_loan_out_acct_appl_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_out_acct_appl_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes