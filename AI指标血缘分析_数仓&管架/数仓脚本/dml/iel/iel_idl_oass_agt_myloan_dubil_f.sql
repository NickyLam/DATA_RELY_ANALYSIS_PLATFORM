: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_myloan_dubil_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_myloan_dubil.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.dubil_id as dubil_id
,t1.ext_prod_id as ext_prod_id
,t1.loan_status_cd as loan_status_cd
,t1.loan_usage_cd as loan_usage_cd
,t1.loan_cap_use_position_cd as loan_cap_use_position_cd
,t1.distr_dt as distr_dt
,t1.curr_cd as curr_cd
,t1.distr_amt as distr_amt
,t1.loan_value_dt as loan_value_dt
,t1.loan_exp_dt as loan_exp_dt
,t1.loan_cont_tenor as loan_cont_tenor
,t1.repay_way_cd as repay_way_cd
,t1.grace_period_days as grace_period_days
,t1.src_int_rat_type_cd as src_int_rat_type_cd
,t1.int_rat_adj_way_cd as int_rat_adj_way_cd
,t1.int_rat_adj_ped_corp_cd as int_rat_adj_ped_corp_cd
,t1.int_rat_adj_ped_freq as int_rat_adj_ped_freq
,t1.loan_actl_day_int_rat as loan_actl_day_int_rat
,t1.pric_repay_freq_cd as pric_repay_freq_cd
,t1.int_repay_freq_cd as int_repay_freq_cd
,t1.guar_type_cd as guar_type_cd
,t1.crdt_appl_id as crdt_appl_id
,t1.recvbl_num_type_cd as recvbl_num_type_cd
,t1.recvbl_acct_name as recvbl_acct_name
,t1.recvbl_acct_id as recvbl_acct_id
,t1.recvbl_bank_name as recvbl_bank_name
,t1.repay_num_type_cd as repay_num_type_cd
,t1.repay_acct_name as repay_acct_name
,t1.repay_acct_id as repay_acct_id
,t1.repay_bank_name as repay_bank_name
,t1.prod_type_cd as prod_type_cd
,t1.acctnt_dt as acctnt_dt
,t1.cont_status_cd as cont_status_cd
,t1.payoff_dt as payoff_dt
,t1.loan_level5_cls_cd as loan_level5_cls_cd
,t1.acru_non_acru_flg as acru_non_acru_flg
,t1.next_repay_dt as next_repay_dt
,t1.unpayoff_perds as unpayoff_perds
,t1.ovdue_pd_cnt as ovdue_pd_cnt
,t1.pric_ovdue_days as pric_ovdue_days
,t1.int_ovdue_days as int_ovdue_days
,t1.nomal_pric_bal as nomal_pric_bal
,t1.ovdue_pric_bal as ovdue_pric_bal
,t1.loan_dir_indus_cd as loan_dir_indus_cd
,t1.cust_id as cust_id
,t1.cust_mgr_id as cust_mgr_id
,t1.nomal_int_bal as nomal_int_bal
,t1.ovdue_int_bal as ovdue_int_bal
,t1.ovdue_pric_pnlt_bal as ovdue_pric_pnlt_bal
,t1.ovdue_int_pnlt_bal as ovdue_int_pnlt_bal
,t1.loan_exec_year_int_rat as loan_exec_year_int_rat
,t1.lpr_int_rat as lpr_int_rat
,t1.int_rat_float_spread_val as int_rat_float_spread_val
,t1.int_rat_float_dir_cd as int_rat_float_dir_cd
,t1.base_rat_type_cd as base_rat_type_cd
,t1.tran_type_cd as tran_type_cd
,t1.asset_thd_cls_cd as asset_thd_cls_cd
,t1.prod_id as prod_id
,t1.contri_type_cd as contri_type_cd
,t1.contri_ratio as contri_ratio
,t1.white_list_cust_flg as white_list_cust_flg
,t1.cust_char_cd as cust_char_cd
,t1.farm_flg as farm_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_myloan_dubil t1
where etl_dt = to_date('${batch_date}','yyyymmdd')-1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_myloan_dubil.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
