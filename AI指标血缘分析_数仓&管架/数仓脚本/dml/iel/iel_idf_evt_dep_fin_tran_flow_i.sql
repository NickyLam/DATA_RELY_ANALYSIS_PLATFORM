: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_evt_dep_fin_tran_flow_i
CreateDate: 20250116
FileName:   ${iel_data_path}/evt_dep_fin_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.evt_id as evt_id
,t1.lp_id as lp_id
,t1.tran_flow_num as tran_flow_num
,t1.ova_flow_num as ova_flow_num
,t1.core_flow_num as core_flow_num
,t1.tran_ref_no as tran_ref_no
,t1.acct_id as acct_id
,t1.cust_acct_num as cust_acct_num
,t1.bus_prod_id as bus_prod_id
,t1.acct_curr_cd as acct_curr_cd
,t1.sub_acct_num as sub_acct_num
,t1.sub_acct_id as sub_acct_id
,t1.acct_type_cd as acct_type_cd
,t1.acct_status_cd as acct_status_cd
,t1.vtual_acct_flg as vtual_acct_flg
,t1.cash_tran_flg as cash_tran_flg
,t1.acct_name as acct_name
,t1.open_acct_org_id as open_acct_org_id
,t1.evt_cate_id as evt_cate_id
,t1.tran_dt as tran_dt
,t1.tran_org_id as tran_org_id
,t1.debit_crdt_flg as debit_crdt_flg
,t1.tran_curr_cd as tran_curr_cd
,t1.tran_cd as tran_cd
,t1.tran_descb as tran_descb
,t1.bef_tran_bal as bef_tran_bal
,t1.tran_amt as tran_amt
,t1.actl_bal as actl_bal
,t1.tran_kind_cd as tran_kind_cd
,t1.cntpty_tran_ref_no as cntpty_tran_ref_no
,t1.cntpty_acct_id as cntpty_acct_id
,t1.cntpty_cust_acct_num as cntpty_cust_acct_num
,t1.cntpty_acct_curr_cd as cntpty_acct_curr_cd
,t1.cntpty_sub_acct_num as cntpty_sub_acct_num
,t1.cap_froz_flow_num as cap_froz_flow_num
,t1.cntpty_acct_prod_id as cntpty_acct_prod_id
,t1.cntpty_acct_name as cntpty_acct_name
,t1.cntpty_unionpay_num as cntpty_unionpay_num
,t1.cntpty_bank_name as cntpty_bank_name
,t1.cntpty_open_acct_org_id as cntpty_open_acct_org_id
,t1.real_cntpty_fin_inst_id as real_cntpty_fin_inst_id
,t1.real_cntpty_fin_inst_name as real_cntpty_fin_inst_name
,t1.real_cntpty_acct_type_cd as real_cntpty_acct_type_cd
,t1.real_cntpty_acct_id as real_cntpty_acct_id
,t1.cntpty_curr_cd as cntpty_curr_cd
,t1.begin_curr_cd as begin_curr_cd
,t1.cntpty_tran_flow_num as cntpty_tran_flow_num
,t1.aim_curr_cd as aim_curr_cd
,t1.buy_amt as buy_amt
,t1.sell_amt as sell_amt
,t1.vouch_type_cd as vouch_type_cd
,t1.vouch_no as vouch_no
,t1.cash_proj_cd as cash_proj_cd
,t1.amt_calc_type_cd as amt_calc_type_cd
,t1.chn_id as chn_id
,t1.amt_type_cd as amt_type_cd
,t1.bal_type_cd as bal_type_cd
,t1.base_equvl_amt as base_equvl_amt
,t1.offset_exch_rat as offset_exch_rat
,t1.cross_exch_rat as cross_exch_rat
,t1.buyer_exch_rat_cls_cd as buyer_exch_rat_cls_cd
,t1.buyer_exch_rat_val as buyer_exch_rat_val
,t1.actl_cross_exch_rat as actl_cross_exch_rat
,t1.seller_exch_rat_cls_cd as seller_exch_rat_cls_cd
,t1.seller_exch_rat_val as seller_exch_rat_val
,t1.inter_bus_type_cd as inter_bus_type_cd
,t1.finc_type_cd as finc_type_cd
,t1.quot_type_cd as quot_type_cd
,t1.med_flg as med_flg
,t1.med_type_cd as med_type_cd
,t1.bus_cls_cd as bus_cls_cd
,t1.cntpty_cert_type_cd as cntpty_cert_type_cd
,t1.attach_rgst_dep_flg as attach_rgst_dep_flg
,t1.main_evt_cls_cd as main_evt_cls_cd
,t1.exch_rat_type_cd as exch_rat_type_cd
,t1.avl_way_cd as avl_way_cd
,t1.wdraw_way_cd as wdraw_way_cd
,t1.bus_tran_batch_no as bus_tran_batch_no
,t1.bank_tran_seq_num as bank_tran_seq_num
,t1.agent_tel_num as agent_tel_num
,t1.cust_name as cust_name
,t1.lmt_code as lmt_code
,t1.cntpty_fin_inst_dist_cd as cntpty_fin_inst_dist_cd
,t1.cntpty_cert_no as cntpty_cert_no
,t1.real_cntpty_fin_inst_dist_cd as real_cntpty_fin_inst_dist_cd
,t1.real_cntpty_cert_no as real_cntpty_cert_no
,t1.real_cntpty_cert_type_cd as real_cntpty_cert_type_cd
,t1.tran_happ_site as tran_happ_site
,t1.real_tran_happ_site as real_tran_happ_site
,t1.cntpty_name as cntpty_name
,t1.real_cntpty_name as real_cntpty_name
,t1.payment_corp_name as payment_corp_name
,t1.prior_level as prior_level
,t1.seller_quot_type_cd as seller_quot_type_cd
,t1.chn_dt as chn_dt
,t1.cust_id as cust_id
,t1.cert_no as cert_no
,t1.cert_type_cd as cert_type_cd
,t1.bill_num as bill_num
,t1.sob_cate_cd as sob_cate_cd
,t1.tran_postsc as tran_postsc
,t1.bus_proc_status_cd as bus_proc_status_cd
,t1.auto_revs_flg as auto_revs_flg
,t1.cntpty_equvl_amt as cntpty_equvl_amt
,t1.tran_post_bal_add_finc as tran_post_bal_add_finc
,t1.free_serv_fee_flg as free_serv_fee_flg
,t1.tran_public_agent_name as tran_public_agent_name
,t1.src_module_type_cd as src_module_type_cd
,t1.effect_dt as effect_dt
,t1.revs_flow_num as revs_flow_num
,t1.tran_termn_id as tran_termn_id
,t1.follow_id as follow_id
,t1.revs_tran_cd as revs_tran_cd
,t1.revs_flg as revs_flg
,t1.revs_dt as revs_dt
,t1.clear_dt as clear_dt
,t1.post_flg as post_flg
,t1.memo_code as memo_code
,t1.tran_memo_descb as tran_memo_descb
,t1.check_teller_id as check_teller_id
,t1.auth_teller_id as auth_teller_id
,t1.init_tran_tm as init_tran_tm
,t1.tran_tm as tran_tm
,t1.tran_teller_id as tran_teller_id
,t1.beps_unpasew_flg as beps_unpasew_flg
,t1.bus_flow_num as bus_flow_num
,t1.check_entry_cd as check_entry_cd
,t1.tran_id as tran_id
,t1.prpery_sys_code as prpery_sys_code
,t1.src_table_name as src_table_name

from ${idl_schema}.evt_dep_fin_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_dep_fin_tran_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
