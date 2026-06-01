: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_bill_discnt_batch_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_discnt_batch_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.batch_id as batch_id
,t.lp_id as lp_id
,t.org_id as org_id
,t.enter_acct_org_id as enter_acct_org_id
,t.task_type_cd as task_type_cd
,t.buy_prod_cd as buy_prod_cd
,t.buy_type_cd as buy_type_cd
,t.discnt_bus_type_cd as discnt_bus_type_cd
,t.bus_id as bus_id
,t.bill_type_cd as bill_type_cd
,t.bill_med_cd as bill_med_cd
,t.cust_id as cust_id
,t.cust_name as cust_name
,t.cust_open_bank_no as cust_open_bank_no
,t.cust_open_acct_num as cust_open_acct_num
,t.int_rat as int_rat
,t.int_rat_type_cd as int_rat_type_cd
,t.redem_int_rat as redem_int_rat
,t.redem_int_rat_type_cd as redem_int_rat_type_cd
,t.buy_dt as buy_dt
,t.onl_clear_flg as onl_clear_flg
,t.int_calc_defer_way_cd as int_calc_defer_way_cd
,t.twow_buy_out_exp_dt as twow_buy_out_exp_dt
,t.buy_rtn_sell_exp_dt as buy_rtn_sell_exp_dt
,t.redem_open_dt as redem_open_dt
,t.redem_closing_dt as redem_closing_dt
,t.sys_in_flg as sys_in_flg
,t.vtual_buy_flg as vtual_buy_flg
,t.pkg_buy_risk_bear_ratio as pkg_buy_risk_bear_ratio
,t.pay_int_way_cd as pay_int_way_cd
,t.int_payer_is_hxb_cust_flg as int_payer_is_hxb_cust_flg
,t.int_payer_name as int_payer_name
,t.int_payer_acct_num as int_payer_acct_num
,t.pay_int_ratio as pay_int_ratio
,t.agent_name as agent_name
,t.cust_mgr_id as cust_mgr_id
,t.dept_id as dept_id
,t.discnt_bf_revw_flg as discnt_bf_revw_flg
,t.cont_matrl_backup_flg as cont_matrl_backup_flg
,t.backup_closing_dt as backup_closing_dt
,t.actl_dir_indus_type_cd as actl_dir_indus_type_cd
,t.operr_id as operr_id
,t.tran_dt as tran_dt
,t.bus_logic_check_status_cd as bus_logic_check_status_cd
,t.risk_que_status_cd as risk_que_status_cd
,t.crdt_check_status_cd as crdt_check_status_cd
,t.check_status_cd as check_status_cd
,t.int_accr_check_status_cd as int_accr_check_status_cd
,t.entry_status_cd as entry_status_cd
,t.exp_status_cd as exp_status_cd
,t.agt_status_cd as agt_status_cd
,t.accrualed_int_flg as accrualed_int_flg
,t.intnal_buy_out_int_rat as intnal_buy_out_int_rat
,t.prft_assign_status_cd as prft_assign_status_cd
,t.appl_id as appl_id
,t.entry_acct_num as entry_acct_num
,t.major_guar_way_cd as major_guar_way_cd
,t.tran_flg_flg as tran_flg_flg
,t.agent_discnt_flg as agent_discnt_flg
,t.intnal_stl_flg as intnal_stl_flg
,t.intnal_stl_acct as intnal_stl_acct
,t.agt_exp_dt as agt_exp_dt
,t.crdt_valid_amt as crdt_valid_amt
,t.apv_rest_id as apv_rest_id
,t.tran_type_cd as tran_type_cd
,t.cpes_discnt_rgst_status_flg as cpes_discnt_rgst_status_flg
,t.onl_discnt_flg as onl_discnt_flg
,t.apprved_use_crdt_open_amt as apprved_use_crdt_open_amt
,t.distr_post_acm_use_open_amt as distr_post_acm_use_open_amt
,t.cert_type_cd as cert_type_cd
,t.cert_no as cert_no
,t.asset_thd_cls_cd as asset_thd_cls_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_bill_discnt_batch t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_discnt_batch_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes