: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_appl_basic_info_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_loan_appl_basic_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.rela_flow_num as rela_flow_num
,t1.risk_type_cd as risk_type_cd
,t1.data_input_integy_flg as data_input_integy_flg
,t1.info_type_cd as info_type_cd
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.appl_way_cd as appl_way_cd
,t1.lmt_cont_flg as lmt_cont_flg
,t1.loan_distr_type_cd as loan_distr_type_cd
,t1.happ_dt as happ_dt
,t1.curr_cd as curr_cd
,t1.appl_amt as appl_amt
,t1.lmt_base_prod_id as lmt_base_prod_id
,t1.prod_id as prod_id
,t1.prod_policy_id as prod_policy_id
,t1.prod_policy_edit_id as prod_policy_edit_id
,t1.prod_belong_gen_cd as prod_belong_gen_cd
,t1.mon_tenor as mon_tenor
,t1.day_tenor as day_tenor
,t1.begin_dt as begin_dt
,t1.exp_dt as exp_dt
,t1.remote_bus_flg as remote_bus_flg
,t1.lmt_circl_flg as lmt_circl_flg
,t1.low_risk_bus_flg as low_risk_bus_flg
,t1.crdt_dir_cd as crdt_dir_cd
,t1.nat_std_indus_dir_cd as nat_std_indus_dir_cd
,t1.bank_int_indus_dir_cd as bank_int_indus_dir_cd
,t1.usage_descb as usage_descb
,t1.int_rat_mode_cd as int_rat_mode_cd
,t1.fix_int_rat as fix_int_rat
,t1.base_rat_type_cd as base_rat_type_cd
,t1.base_rat as base_rat
,t1.int_rat_float_type_cd as int_rat_float_type_cd
,t1.int_rat_adj_way_cd as int_rat_adj_way_cd
,t1.int_rat_flo_val as int_rat_flo_val
,t1.exec_int_rat as exec_int_rat
,t1.main_guar_way_cd as main_guar_way_cd
,t1.supp_guar_way_flg as supp_guar_way_flg
,t1.other_guar_way_cd as other_guar_way_cd
,t1.other_cond_descb as other_cond_descb
,t1.repay_way_cd as repay_way_cd
,t1.repay_ped as repay_ped
,t1.repay_ped_cd as repay_ped_cd
,t1.deflt_repay_day as deflt_repay_day
,t1.rsrv_amt as rsrv_amt
,t1.rela_old_cont_id as rela_old_cont_id
,t1.lmt_id as lmt_id
,t1.apv_status_cd as apv_status_cd
,t1.reply_type_cd as reply_type_cd
,t1.rela_regroup_prop_id as rela_regroup_prop_id
,t1.oper_teller_id as oper_teller_id
,t1.oper_org_id as oper_org_id
,t1.oper_dt as oper_dt
,t1.rgst_teller_id as rgst_teller_id
,t1.rgst_org_id as rgst_org_id
,t1.rgst_dt as rgst_dt
,t1.update_teller_id as update_teller_id
,t1.update_org_id as update_org_id
,t1.modif_dt as modif_dt
,t1.belong_strip_line_cd as belong_strip_line_cd
,t1.lp_id as lp_id
,t1.spec_ped_corp_cd as spec_ped_corp_cd
,t1.spec_ped_cd as spec_ped_cd
,t1.loan_usage_cd as loan_usage_cd
,t1.guar_way_cd_two as guar_way_cd_two
,t1.guar_way_cd_three as guar_way_cd_three
,t1.file_dt as file_dt
,t1.rgst_reply_flg as rgst_reply_flg
,t1.b_renew_amt as b_renew_amt
,t1.lmt_open_amt as lmt_open_amt
,t1.int_rat_adj_ped_cd as int_rat_adj_ped_cd
,t1.b_renew_exec_year_int_rat as b_renew_exec_year_int_rat
,t1.core_out_acct_org_id as core_out_acct_org_id
,t1.crdt_org_way_cd as crdt_org_way_cd
,t1.intd_bd_flg as intd_bd_flg
,t1.b_renew_exp_dt as b_renew_exp_dt
,t1.remark as remark
,t1.move_remark as move_remark
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.appl_id as appl_id
,t1.appl_flow_num as appl_flow_num

from ${idl_schema}.oass_agt_loan_appl_basic_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_appl_basic_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
