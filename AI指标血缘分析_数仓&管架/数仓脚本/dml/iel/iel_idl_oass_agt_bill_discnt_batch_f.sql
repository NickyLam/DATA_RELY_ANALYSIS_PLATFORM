: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bill_discnt_batch_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_bill_discnt_batch.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.batch_id as batch_id
,t1.lp_id as lp_id
,t1.org_id as org_id
,t1.enter_acct_org_id as enter_acct_org_id
,t1.buy_prod_cd as buy_prod_cd
,t1.buy_type_cd as buy_type_cd
,t1.discnt_bus_type_cd as discnt_bus_type_cd
,t1.bus_id as bus_id
,t1.bill_type_cd as bill_type_cd
,t1.bill_med_cd as bill_med_cd
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.cust_open_bank_no as cust_open_bank_no
,t1.cust_open_acct_num as cust_open_acct_num
,t1.int_rat as int_rat
,t1.int_rat_type_cd as int_rat_type_cd
,t1.redem_int_rat as redem_int_rat
,t1.redem_int_rat_type_cd as redem_int_rat_type_cd
,t1.buy_dt as buy_dt
,t1.onl_clear_flg as onl_clear_flg
,t1.redem_open_dt as redem_open_dt
,t1.redem_closing_dt as redem_closing_dt
,t1.sys_in_flg as sys_in_flg
,t1.pay_int_way_cd as pay_int_way_cd
,t1.int_payer_name as int_payer_name
,t1.int_payer_acct_num as int_payer_acct_num
,t1.pay_int_ratio as pay_int_ratio
,t1.agent_name as agent_name
,t1.cust_mgr_id as cust_mgr_id
,t1.dept_id as dept_id
,t1.discnt_bf_revw_flg as discnt_bf_revw_flg
,t1.cont_matrl_backup_flg as cont_matrl_backup_flg
,t1.backup_closing_dt as backup_closing_dt
,t1.operr_id as operr_id
,t1.tran_dt as tran_dt
,t1.bus_logic_check_status_cd as bus_logic_check_status_cd
,t1.crdt_check_status_cd as crdt_check_status_cd
,t1.check_status_cd as check_status_cd
,t1.int_accr_check_status_cd as int_accr_check_status_cd
,t1.entry_status_cd as entry_status_cd
,t1.intnal_stl_flg as intnal_stl_flg
,t1.intnal_stl_acct as intnal_stl_acct
,t1.agt_exp_dt as agt_exp_dt
,t1.crdt_valid_amt as crdt_valid_amt
,t1.apprved_use_crdt_open_amt as apprved_use_crdt_open_amt
,t1.distr_post_acm_use_open_amt as distr_post_acm_use_open_amt
,t1.cert_type_cd as cert_type_cd
,t1.cert_no as cert_no
,t1.asset_thd_cls_cd as asset_thd_cls_cd
,t1.rela_party_que_rest_cd as rela_party_que_rest_cd
,t1.crdt_cont_used_amt as crdt_cont_used_amt
,t1.crdt_cont_tot_amt as crdt_cont_tot_amt
,t1.lmt_cont_used_tot_amt as lmt_cont_used_tot_amt
,t1.midgrod_bus_flow_num as midgrod_bus_flow_num
,t1.int_calc_defer_way_cd as int_calc_defer_way_cd
,t1.tgls_entry_status_cd as tgls_entry_status_cd
,t1.ncbs_entry_status_cd as ncbs_entry_status_cd
,t1.h_data_flg as h_data_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark

from ${idl_schema}.oass_agt_bill_discnt_batch t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bill_discnt_batch.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
