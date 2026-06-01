: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.loan_org_id,chr(13),''),chr(10),'') as loan_org_id
    ,replace(replace(t.prod_cd,chr(13),''),chr(10),'') as prod_cd
    ,replace(replace(t.accti_cd,chr(13),''),chr(10),'') as accti_cd
    ,replace(replace(t.loan_cont_id,chr(13),''),chr(10),'') as loan_cont_id
    ,replace(replace(t.brwer_stl_acct_id,chr(13),''),chr(10),'') as brwer_stl_acct_id
    ,replace(replace(t.int_sub_ps_stl_acct_id,chr(13),''),chr(10),'') as int_sub_ps_stl_acct_id
    ,replace(replace(t.entr_dep_acct_id,chr(13),''),chr(10),'') as entr_dep_acct_id
    ,replace(replace(t.csner_dep_acct_id,chr(13),''),chr(10),'') as csner_dep_acct_id
    ,replace(replace(t.loan_type_cd,chr(13),''),chr(10),'') as loan_type_cd
    ,replace(replace(t.lmt_type_cd,chr(13),''),chr(10),'') as lmt_type_cd
    ,replace(replace(t.inpwn_acct_id,chr(13),''),chr(10),'') as inpwn_acct_id
    ,replace(replace(t.tenor_cd,chr(13),''),chr(10),'') as tenor_cd
    ,t.distr_dt as distr_dt
    ,replace(replace(t.distr_flow_num,chr(13),''),chr(10),'') as distr_flow_num
    ,t.exp_dt as exp_dt
    ,replace(replace(t.acru_loan_flg,chr(13),''),chr(10),'') as acru_loan_flg
    ,t.turn_non_acru_loan_dt as turn_non_acru_loan_dt
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.distr_amt as distr_amt
    ,replace(replace(t.pric_auto_deduct_flg,chr(13),''),chr(10),'') as pric_auto_deduct_flg
    ,replace(replace(t.int_auto_deduct_flg,chr(13),''),chr(10),'') as int_auto_deduct_flg
    ,replace(replace(t.tax_status_cd,chr(13),''),chr(10),'') as tax_status_cd
    ,replace(replace(t.repay_seq_no_cd,chr(13),''),chr(10),'') as repay_seq_no_cd
    ,replace(replace(t.reval_way_cd,chr(13),''),chr(10),'') as reval_way_cd
    ,replace(replace(t.bench_rat_cd,chr(13),''),chr(10),'') as bench_rat_cd
    ,t.nomal_int_rat as nomal_int_rat
    ,t.ovdue_int_rat as ovdue_int_rat
    ,replace(replace(t.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
    ,replace(replace(t.loan_int_set_way_cd,chr(13),''),chr(10),'') as loan_int_set_way_cd
    ,t.repay_plan_effect_dt as repay_plan_effect_dt
    ,replace(replace(t.inst_loan_repay_way_cd,chr(13),''),chr(10),'') as inst_loan_repay_way_cd
    ,t.tot_perds as tot_perds
    ,t.curr_term_num as curr_term_num
    ,t.each_issue_repay_amt as each_issue_repay_amt
    ,t.int_sub_ratio as int_sub_ratio
    ,t.int_sub_exp_dt as int_sub_exp_dt
    ,t.wrt_off_dt as wrt_off_dt
    ,replace(replace(t.wrtoff_flow_num,chr(13),''),chr(10),'') as wrtoff_flow_num
    ,replace(replace(t.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd
    ,replace(replace(t.out_acct_acct_id,chr(13),''),chr(10),'') as out_acct_acct_id
    ,t.loan_turn_ovdue_dt as loan_turn_ovdue_dt
    ,replace(replace(t.int_sub_flg_cd,chr(13),''),chr(10),'') as int_sub_flg_cd
    ,replace(replace(t.stop_accr_int_flg,chr(13),''),chr(10),'') as stop_accr_int_flg
    ,t.stop_accr_int_dt as stop_accr_int_dt
    ,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
    ,replace(replace(t.impam_flg,chr(13),''),chr(10),'') as impam_flg
    ,replace(replace(t.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd
    ,replace(replace(t.calc_comp_int_flg,chr(13),''),chr(10),'') as calc_comp_int_flg
    ,replace(replace(t.entr_loan_comm_fee_coll_way_cd,chr(13),''),chr(10),'') as entr_loan_comm_fee_coll_way_cd
    ,t.entr_loan_comm_fee_coll_ratio as entr_loan_comm_fee_coll_ratio
    ,t.entr_loan_comm_fee as entr_loan_comm_fee
    ,replace(replace(t.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
    ,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
    ,replace(replace(t.fee_type_cd,chr(13),''),chr(10),'') as fee_type_cd
    ,t.fee_amt as fee_amt
    ,replace(replace(t.crdt_distr_repay_plan_flg,chr(13),''),chr(10),'') as crdt_distr_repay_plan_flg
    ,replace(replace(t.finc_prod_flg,chr(13),''),chr(10),'') as finc_prod_flg
    ,replace(replace(t.money_use_type_cd,chr(13),''),chr(10),'') as money_use_type_cd
    ,t.entr_pay_amt as entr_pay_amt
    ,replace(replace(t.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd
    ,replace(replace(t.prepay_int_amort_flg,chr(13),''),chr(10),'') as prepay_int_amort_flg
    ,replace(replace(t.wrt_off_flg,chr(13),''),chr(10),'') as wrt_off_flg
    ,replace(replace(t.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_loan_acct t
  where t.create_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes