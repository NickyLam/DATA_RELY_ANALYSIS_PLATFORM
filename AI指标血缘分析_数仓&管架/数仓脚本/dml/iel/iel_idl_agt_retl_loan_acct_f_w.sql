: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_retl_loan_acct_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_acct_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.dubil_id as dubil_id
,t.acct_id as acct_id
,t.cont_id as cont_id
,t.cust_id as cust_id
,t.cust_name as cust_name
,t.bus_org_id as bus_org_id
,t.acct_instit_id as acct_instit_id
,t.prod_id as prod_id
,t.prod_name as prod_name
,t.acctnt_bus_id as acctnt_bus_id
,t.open_acct_dt as open_acct_dt
,t.value_dt as value_dt
,t.exp_dt as exp_dt
,t.tenor as tenor
,t.loan_modal_cd as loan_modal_cd
,t.acru_non_acru_flg as acru_non_acru_flg
,t.loan_acct_status_cd as loan_acct_status_cd
,t.multi_loan_deduct_seq_id as multi_loan_deduct_seq_id
,t.curr_cd as curr_cd
,t.cont_amt as cont_amt
,t.dubil_amt as dubil_amt
,t.distrd_amt as distrd_amt
,t.nomal_pric_bal as nomal_pric_bal
,t.ovdue_pric_bal as ovdue_pric_bal
,t.resv as resv
,t.final_fin_tran_dt as final_fin_tran_dt
,t.open_acct_org_id as open_acct_org_id
,t.open_acct_teller_id as open_acct_teller_id
,t.clos_acct_dt as clos_acct_dt
,t.clos_acct_teller_id as clos_acct_teller_id
,t.rec_status_cd as rec_status_cd
,t.int_accr_rule_cd as int_accr_rule_cd
,t.int_rat_adj_way_cd as int_rat_adj_way_cd
,t.int_rat_ped_cd as int_rat_ped_cd
,t.exec_int_rat as exec_int_rat
,t.fx_int_rat_kind_cd as fx_int_rat_kind_cd
,t.int_rat_adj_type_cd as int_rat_adj_type_cd
,t.src_int_rat_adj_ped_cd as src_int_rat_adj_ped_cd
,t.int_rat_adj_ped_corp_cd as int_rat_adj_ped_corp_cd
,t.int_rat_adj_ped_freq as int_rat_adj_ped_freq
,t.int_rat_adj_day as int_rat_adj_day
,t.int_rat_float_way_cd as int_rat_float_way_cd
,t.int_rat_float_point as int_rat_float_point
,t.pre_recv_int_way_cd as pre_recv_int_way_cd
,t.int_accr_flg as int_accr_flg
,t.comp_int_int_accr_flg as comp_int_int_accr_flg
,t.ovdue_int_accr_way_cd as ovdue_int_accr_way_cd
,t.ovdue_pnlt_float_way_cd as ovdue_pnlt_float_way_cd
,t.ovdue_int_rat_flo_val as ovdue_int_rat_flo_val
,t.ovdue_int_rat_ped_cd as ovdue_int_rat_ped_cd
,t.ovdue_exec_int_rat as ovdue_exec_int_rat
,t.last_int_adj_day as last_int_adj_day
,t.next_int_adj_day as next_int_adj_day
,t.distr_acct_id as distr_acct_id
,t.mgmt_org_id as mgmt_org_id
,t.repay_way_cd as repay_way_cd
,t.src_repay_ped_cd as src_repay_ped_cd
,t.repay_ped_corp_cd as repay_ped_corp_cd
,t.repay_ped_freq as repay_ped_freq
,t.repay_day as repay_day
,t.tot_perds as tot_perds
,t.curr_perds as curr_perds
,t.repay_acct_id as repay_acct_id
,t.ped_distr_flg as ped_distr_flg
,t.distr_way_cd as distr_way_cd
,t.ovdue_repay_ped_cd as ovdue_repay_ped_cd
,t.last_repay_dt as last_repay_dt
,t.next_repay_dt as next_repay_dt
,t.base_rat_type_cd as base_rat_type_cd
,t.base_rat_id as base_rat_id
,t.asset_thd_cls_cd as asset_thd_cls_cd
,t.irr_repay_flg as irr_repay_flg
,t.int_sub_flg as int_sub_flg
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_retl_loan_acct t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_acct_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes