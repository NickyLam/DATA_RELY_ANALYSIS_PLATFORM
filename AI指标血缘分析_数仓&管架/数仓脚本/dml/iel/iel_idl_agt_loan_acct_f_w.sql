: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_loan_acct_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_acct_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.dubil_id
,t1.acct_id
,t1.acct_name
,t1.loan_org_id
,t1.prod_cd
,t1.accti_cd
,t1.loan_cont_id
,t1.brwer_stl_acct_id
,t1.int_sub_ps_stl_acct_id
,t1.entr_dep_acct_id
,t1.csner_dep_acct_id
,t1.loan_type_cd
,t1.lmt_type_cd
,t1.inpwn_acct_id
,t1.tenor_cd
,t1.distr_dt
,t1.distr_flow_num
,t1.exp_dt
,t1.acru_loan_flg
,t1.turn_non_acru_loan_dt
,t1.curr_cd
,t1.distr_amt
,t1.pric_auto_deduct_flg
,t1.int_auto_deduct_flg
,t1.tax_status_cd
,t1.repay_seq_no_cd
,t1.reval_way_cd
,t1.bench_rat_cd
,t1.nomal_int_rat
,t1.ovdue_int_rat
,t1.repay_way_cd
,t1.loan_int_set_way_cd
,t1.repay_plan_effect_dt
,t1.inst_loan_repay_way_cd
,t1.tot_perds
,t1.curr_term_num
,t1.each_issue_repay_amt
,t1.int_sub_ratio
,t1.int_sub_exp_dt
,t1.wrt_off_dt
,t1.wrtoff_flow_num
,t1.open_acct_chn_cd
,t1.out_acct_acct_id
,t1.loan_turn_ovdue_dt
,t1.int_sub_flg_cd
,t1.stop_accr_int_flg
,t1.stop_accr_int_dt
,t1.acct_status_cd
,t1.impam_flg
,t1.cont_type_cd
,t1.calc_comp_int_flg
,t1.entr_loan_comm_fee_coll_way_cd
,t1.entr_loan_comm_fee_coll_ratio
,t1.entr_loan_comm_fee
,t1.loan_usage_cd
,t1.cust_mgr_id
,t1.fee_type_cd
,t1.fee_amt
,t1.crdt_distr_repay_plan_flg
,t1.finc_prod_flg
,t1.money_use_type_cd
,t1.entr_pay_amt
,t1.int_rat_float_way_cd
,t1.prepay_int_amort_flg
,t1.wrt_off_flg
,t1.asset_thd_cls_cd
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_loan_acct t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_acct_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes