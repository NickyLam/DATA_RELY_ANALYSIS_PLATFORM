: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_retl_loan_cont_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_cont_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.cont_id as cont_id
,t.prod_id as prod_id
,t.prod_name as prod_name
,t.cust_id as cust_id
,t.curr_cd as curr_cd
,t.cont_amt as cont_amt
,t.cont_aval_bal as cont_aval_bal
,t.loan_cont_tenor as loan_cont_tenor
,t.cont_sign_dt as cont_sign_dt
,t.cont_start_dt as cont_start_dt
,t.cont_termnt_dt as cont_termnt_dt
,t.cont_create_dt as cont_create_dt
,t.cont_type_cd as cont_type_cd
,t.cont_status_cd as cont_status_cd
,t.tenor_type_cd as tenor_type_cd
,t.int_rat_float_dir_cd as int_rat_float_dir_cd
,t.loan_form_cd as loan_form_cd
,t.main_guar_way_cd as main_guar_way_cd
,t.distr_way_cd as distr_way_cd
,t.repay_freq_cd as repay_freq_cd
,t.repay_day_cfm_cd as repay_day_cfm_cd
,t.loan_usage_cd as loan_usage_cd
,t.bus_kind_cd as bus_kind_cd
,t.bus_kind_name as bus_kind_name
,t.loan_dir_cd as loan_dir_cd
,t.loan_dir_name as loan_dir_name
,t.risk_cls_frt_cd as risk_cls_frt_cd
,t.loan_cap_mode_pay_cd as loan_cap_mode_pay_cd
,t.mortg_flg as mortg_flg
,t.crdt_lmt_use_flg as crdt_lmt_use_flg
,t.gro_lend_flg as gro_lend_flg
,t.green_pass_flg as green_pass_flg
,t.low_risk_flg as low_risk_flg
,t.bar_flg as bar_flg
,t.allow_stage_repay_flg as allow_stage_repay_flg
,t.use_coprator_lmt_flg as use_coprator_lmt_flg
,t.init_dubil_id as init_dubil_id
,t.loan_appl_dt as loan_appl_dt
,t.repay_day as repay_day
,t.apved_dt as apved_dt
,t.apver_id as apver_id
,t.applit_id as applit_id
,t.cust_mgr_id as cust_mgr_id
,t.proc_org_id as proc_org_id
,t.director_org_id as director_org_id
,t.acct_instit_id as acct_instit_id
,t.enter_acct_id as enter_acct_id
,t.enter_acct_name as enter_acct_name
,t.repay_acct_id as repay_acct_id
,t.repay_acct_name as repay_acct_name
,t.crdt_appl_id as crdt_appl_id
,t.coprator_agt_id as coprator_agt_id
,t.enter_acct_pt_type_cd as enter_acct_pt_type_cd
,t.repay_acct_pt_type_cd as repay_acct_pt_type_cd
,t.avg_pm_rat as avg_pm_rat
,t.pm_guar_tot as pm_guar_tot
,t.acm_distr_amt as acm_distr_amt
,t.acm_callbk_amt as acm_callbk_amt
,t.reply_flow_num as reply_flow_num
,t.coprator_stand_b_id as coprator_stand_b_id
,t.coprator_proj_type_cd as coprator_proj_type_cd
,t.coprator_type_cd as coprator_type_cd
,t.hxb_open_supv_acct_flg as hxb_open_supv_acct_flg
,t.base_rat as base_rat
,t.year_exec_int_rat as year_exec_int_rat
,t.int_rat_adj_type_cd as int_rat_adj_type_cd
,t.main_guar_way_cd_2 as main_guar_way_cd_2
,t.main_guar_way_cd_3 as main_guar_way_cd_3
,t.choice_blon_loan_flg as choice_blon_loan_flg
,t.crdt_appl_flow_num as crdt_appl_flow_num
,t.housing_cnt_cd as housing_cnt_cd
,t.base_rat_type_cd as base_rat_type_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_retl_loan_cont t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_cont_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes