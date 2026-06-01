: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_loan_cont_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_retl_loan_cont_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.crdt_appl_id,chr(13),''),chr(10),'') as crdt_appl_id
,replace(replace(t.enter_acct_id,chr(13),''),chr(10),'') as enter_acct_id
,replace(replace(t.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t.crdt_appl_flow_num,chr(13),''),chr(10),'') as crdt_appl_flow_num
,replace(replace(t.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd
,replace(replace(t.cont_status_cd,chr(13),''),chr(10),'') as cont_status_cd
,replace(replace(t.bus_kind_cd,chr(13),''),chr(10),'') as bus_kind_cd
,replace(replace(t.loan_happ_type_cd,chr(13),''),chr(10),'') as loan_happ_type_cd
,replace(replace(t.major_guar_way_cd,chr(13),''),chr(10),'') as major_guar_way_cd
,replace(replace(t.sub_guar_way_cd,chr(13),''),chr(10),'') as sub_guar_way_cd
,replace(replace(t.borw_usage_type_cd,chr(13),''),chr(10),'') as borw_usage_type_cd
,replace(replace(t.dir_indus_cd,chr(13),''),chr(10),'') as dir_indus_cd
,replace(replace(t.distr_way_cd,chr(13),''),chr(10),'') as distr_way_cd
,replace(replace(t.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,replace(replace(t.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd
,replace(replace(t.repay_freq_cd,chr(13),''),chr(10),'') as repay_freq_cd
,replace(replace(t.repay_day_cfm_cd,chr(13),''),chr(10),'') as repay_day_cfm_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.housing_cnt_cd,chr(13),''),chr(10),'') as housing_cnt_cd
,replace(replace(t.crdt_lmt_use_flg,chr(13),''),chr(10),'') as crdt_lmt_use_flg
,replace(replace(t.mortg_flg,chr(13),''),chr(10),'') as mortg_flg
,replace(replace(t.gro_lend_flg,chr(13),''),chr(10),'') as gro_lend_flg
,replace(replace(t.blon_loan_flg,chr(13),''),chr(10),'') as blon_loan_flg
,replace(replace(t.green_pass_flg,chr(13),''),chr(10),'') as green_pass_flg
,replace(replace(t.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg
,replace(replace(t.bar_flg,chr(13),''),chr(10),'') as bar_flg
,replace(replace(t.allow_stage_repay_flg,chr(13),''),chr(10),'') as allow_stage_repay_flg
,replace(replace(t.hxb_open_supv_acct_flg,chr(13),''),chr(10),'') as hxb_open_supv_acct_flg
,t.appl_dt as appl_dt
,t.apv_dt as apv_dt
,t.sign_dt as sign_dt
,t.cont_create_dt as cont_create_dt
,t.start_dt as start_dt
,t.termnt_dt as termnt_dt
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t.crdt_loan_flg,chr(13),''),chr(10),'') as crdt_loan_flg
,replace(replace(t.crdt_loan_reply_flow_num,chr(13),''),chr(10),'') as crdt_loan_reply_flow_num
,replace(replace(t.coprator_id,chr(13),''),chr(10),'') as coprator_id
,replace(replace(t.coprator_name,chr(13),''),chr(10),'') as coprator_name
,replace(replace(t.use_coprator_lmt_flg,chr(13),''),chr(10),'') as use_coprator_lmt_flg
,replace(replace(t.coprator_agt_id,chr(13),''),chr(10),'') as coprator_agt_id
,replace(replace(t.coprator_stand_b_id,chr(13),''),chr(10),'') as coprator_stand_b_id
,replace(replace(t.coprator_proj_type_cd,chr(13),''),chr(10),'') as coprator_proj_type_cd
,replace(replace(t.coprator_type_cd,chr(13),''),chr(10),'') as coprator_type_cd
,t.base_rat as base_rat
,t.exec_int_rat as exec_int_rat
,replace(replace(t.repay_day,chr(13),''),chr(10),'') as repay_day
,t.tenor as tenor
,t.pm_guar_tot as pm_guar_tot
,t.avg_pm_rat as avg_pm_rat
,t.cont_amt as cont_amt
,t.cont_aval_bal as cont_aval_bal
,t.acm_distr_amt as acm_distr_amt
,t.acm_callbk_amt as acm_callbk_amt
from ${icl_schema}.cmm_retl_loan_cont_info t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_loan_cont_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes