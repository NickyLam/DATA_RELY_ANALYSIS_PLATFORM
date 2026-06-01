: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_myloan_dubil_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_myloan_dubil_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.dubil_id as dubil_id
,t.ext_prod_id as ext_prod_id
,t.loan_status_cd as loan_status_cd
,t.loan_usage_cd as loan_usage_cd
,t.loan_cap_use_position_cd as loan_cap_use_position_cd
,t.distr_dt as distr_dt
,t.curr_cd as curr_cd
,t.distr_amt as distr_amt
,t.loan_value_dt as loan_value_dt
,t.loan_exp_dt as loan_exp_dt
,t.loan_cont_tenor as loan_cont_tenor
,t.repay_way_cd as repay_way_cd
,t.grace_period_days as grace_period_days
,t.src_int_rat_type_cd as src_int_rat_type_cd
,t.int_rat_adj_way_cd as int_rat_adj_way_cd
,t.int_rat_adj_ped_corp_cd as int_rat_adj_ped_corp_cd
,t.int_rat_adj_ped_freq as int_rat_adj_ped_freq
,t.loan_actl_day_int_rat as loan_actl_day_int_rat
,t.pric_repay_freq_cd as pric_repay_freq_cd
,t.int_repay_freq_cd as int_repay_freq_cd
,t.guar_type_cd as guar_type_cd
,t.crdt_appl_id as crdt_appl_id
,t.recvbl_num_type_cd as recvbl_num_type_cd
,t.recvbl_acct_name as recvbl_acct_name
,t.recvbl_acct_id as recvbl_acct_id
,t.recvbl_bank_name as recvbl_bank_name
,t.repay_num_type_cd as repay_num_type_cd
,t.repay_acct_name as repay_acct_name
,t.repay_acct_id as repay_acct_id
,t.repay_bank_name as repay_bank_name
,t.prod_type_cd as prod_type_cd
,t.acctnt_dt as acctnt_dt
,t.cont_status_cd as cont_status_cd
,t.payoff_dt as payoff_dt
,t.loan_level5_cls_cd as loan_level5_cls_cd
,t.acru_non_acru_flg as acru_non_acru_flg
,t.next_repay_dt as next_repay_dt
,t.unpayoff_perds as unpayoff_perds
,t.ovdue_pd_cnt as ovdue_pd_cnt
,t.pric_ovdue_days as pric_ovdue_days
,t.int_ovdue_days as int_ovdue_days
,t.nomal_pric_bal as nomal_pric_bal
,t.ovdue_pric_bal as ovdue_pric_bal
,t.loan_dir_indus_cd as loan_dir_indus_cd
,t.cust_id as cust_id
,t.cust_mgr_id as cust_mgr_id
,t.nomal_int_bal as nomal_int_bal
,t.ovdue_int_bal as ovdue_int_bal
,t.ovdue_pric_pnlt_bal as ovdue_pric_pnlt_bal
,t.ovdue_int_pnlt_bal as ovdue_int_pnlt_bal
,t.loan_exec_year_int_rat as loan_exec_year_int_rat
,t.lpr_int_rat as lpr_int_rat
,t.int_rat_float_spread_val as int_rat_float_spread_val
,t.int_rat_float_dir_cd as int_rat_float_dir_cd
,t.base_rat_type_cd as base_rat_type_cd
,t.tran_type_cd as tran_type_cd
,t.asset_thd_cls_cd as asset_thd_cls_cd
,t.prod_id as prod_id
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark
,t.job_cd 
from ${idl_schema}.agt_myloan_dubil t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_myloan_dubil_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes