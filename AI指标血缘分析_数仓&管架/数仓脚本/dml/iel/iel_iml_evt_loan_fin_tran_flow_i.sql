: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_loan_fin_tran_flow_i
CreateDate: 20240902
FileName:   ${iel_data_path}/evt_loan_fin_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cap_froz_flow_num,chr(13),''),chr(10),'') as cap_froz_flow_num
,replace(replace(t1.main_evt_cls_cd,chr(13),''),chr(10),'') as main_evt_cls_cd
,replace(replace(t1.main_tran_seq_num,chr(13),''),chr(10),'') as main_tran_seq_num
,replace(replace(t1.inter_bus_type_cd,chr(13),''),chr(10),'') as inter_bus_type_cd
,replace(replace(t1.exch_rat_type_cd,chr(13),''),chr(10),'') as exch_rat_type_cd
,replace(replace(t1.wdraw_way_cd,chr(13),''),chr(10),'') as wdraw_way_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.sob_cate_cd,chr(13),''),chr(10),'') as sob_cate_cd
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.acct_prod_id,chr(13),''),chr(10),'') as acct_prod_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t1.prior_level,chr(13),''),chr(10),'') as prior_level
,replace(replace(t1.camp_prod_name,chr(13),''),chr(10),'') as camp_prod_name
,replace(replace(t1.camp_prod_id,chr(13),''),chr(10),'') as camp_prod_id
,replace(replace(t1.bank_tran_seq_num,chr(13),''),chr(10),'') as bank_tran_seq_num
,replace(replace(t1.bus_tran_batch_no,chr(13),''),chr(10),'') as bus_tran_batch_no
,replace(replace(t1.bus_proc_status_cd,chr(13),''),chr(10),'') as bus_proc_status_cd
,replace(replace(t1.vtual_acct_flg,chr(13),''),chr(10),'') as vtual_acct_flg
,replace(replace(t1.lmt_code,chr(13),''),chr(10),'') as lmt_code
,replace(replace(t1.cash_proj_cd,chr(13),''),chr(10),'') as cash_proj_cd
,replace(replace(t1.cash_tran_flg,chr(13),''),chr(10),'') as cash_tran_flg
,cross_amt
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,actl_bal
,actl_cross_exch_rat
,effect_dt
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.chn_sub_flow_num,chr(13),''),chr(10),'') as chn_sub_flow_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,clear_dt
,replace(replace(t1.begin_curr_cd,chr(13),''),chr(10),'') as begin_curr_cd
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.seller_quot_type_cd,chr(13),''),chr(10),'') as seller_quot_type_cd
,seller_exch_rat_val
,replace(replace(t1.seller_exch_rat_cls_cd,chr(13),''),chr(10),'') as seller_exch_rat_cls_cd
,sell_amt
,replace(replace(t1.sell_curr_cd,chr(13),''),chr(10),'') as sell_curr_cd
,buy_amt
,replace(replace(t1.buyer_quot_type_cd,chr(13),''),chr(10),'') as buyer_quot_type_cd
,buyer_exch_rat_val
,replace(replace(t1.buyer_exch_rat_cls_cd,chr(13),''),chr(10),'') as buyer_exch_rat_cls_cd
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_econ_type_cd,chr(13),''),chr(10),'') as cust_econ_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.amt_calc_type_cd,chr(13),''),chr(10),'') as amt_calc_type_cd
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
,replace(replace(t1.tran_termn_id,chr(13),''),chr(10),'') as tran_termn_id
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,replace(replace(t1.tran_comnt,chr(13),''),chr(10),'') as tran_comnt
,tran_tm
,tran_dt
,bef_tran_bal
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,tran_amt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_postsc,chr(13),''),chr(10),'') as tran_postsc
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.payment_corp_name,chr(13),''),chr(10),'') as payment_corp_name
,cross_exch_rat
,base_equvl_amt
,replace(replace(t1.exch_rat_cls_cd,chr(13),''),chr(10),'') as exch_rat_cls_cd
,replace(replace(t1.callbk_id,chr(13),''),chr(10),'') as callbk_id
,replace(replace(t1.accti_status_cd,chr(13),''),chr(10),'') as accti_status_cd
,replace(replace(t1.post_flg,chr(13),''),chr(10),'') as post_flg
,replace(replace(t1.follow_id,chr(13),''),chr(10),'') as follow_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.serv_fee_flg,chr(13),''),chr(10),'') as serv_fee_flg
,replace(replace(t1.distr_flow_num,chr(13),''),chr(10),'') as distr_flow_num
,replace(replace(t1.cntpty_acct_sub_acct_num,chr(13),''),chr(10),'') as cntpty_acct_sub_acct_num
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_acct_prod_id,chr(13),''),chr(10),'') as cntpty_acct_prod_id
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_curr_cd,chr(13),''),chr(10),'') as cntpty_acct_curr_cd
,replace(replace(t1.cntpty_bank_name,chr(13),''),chr(10),'') as cntpty_bank_name
,replace(replace(t1.cntpty_bank_no,chr(13),''),chr(10),'') as cntpty_bank_no
,replace(replace(t1.cntpty_cust_acct_num,chr(13),''),chr(10),'') as cntpty_cust_acct_num
,replace(replace(t1.cntpty_open_acct_org_id,chr(13),''),chr(10),'') as cntpty_open_acct_org_id
,replace(replace(t1.cntpty_tran_flow_num,chr(13),''),chr(10),'') as cntpty_tran_flow_num
,cntpty_equvl_amt
,replace(replace(t1.cntpty_curr_cd,chr(13),''),chr(10),'') as cntpty_curr_cd
,replace(replace(t1.cntpty_tran_ref_no,chr(13),''),chr(10),'') as cntpty_tran_ref_no
,replace(replace(t1.avl_way_cd,chr(13),''),chr(10),'') as avl_way_cd
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.public_agent_name,chr(13),''),chr(10),'') as public_agent_name
,replace(replace(t1.public_agent_tel_num,chr(13),''),chr(10),'') as public_agent_tel_num
,replace(replace(t1.dep_vouch_cate_cd,chr(13),''),chr(10),'') as dep_vouch_cate_cd
,revs_dt
,replace(replace(t1.revs_flow_num,chr(13),''),chr(10),'') as revs_flow_num
,replace(replace(t1.revs_tran_cd,chr(13),''),chr(10),'') as revs_tran_cd
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.bal_type_cd,chr(13),''),chr(10),'') as bal_type_cd
,replace(replace(t1.attach_rgst_dep_flg,chr(13),''),chr(10),'') as attach_rgst_dep_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.check_entry_code,chr(13),''),chr(10),'') as check_entry_code
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,fxq_tran_dt

from ${iml_schema}.evt_loan_fin_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_loan_fin_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
