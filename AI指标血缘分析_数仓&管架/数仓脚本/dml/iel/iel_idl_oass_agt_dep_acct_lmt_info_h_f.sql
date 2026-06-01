: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_dep_acct_lmt_info_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_dep_acct_lmt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.acct_id as acct_id
,t1.tran_lmt_type_cd as tran_lmt_type_cd
,t1.lmt_id as lmt_id
,t1.tran_dt as tran_dt
,t1.tran_tm as tran_tm
,t1.ova_flow_num as ova_flow_num
,t1.cust_id as cust_id
,t1.effect_dt as effect_dt
,t1.dep_tenor as dep_tenor
,t1.tenor_type_cd as tenor_type_cd
,t1.invalid_dt as invalid_dt
,t1.acct_check_dt as acct_check_dt
,t1.can_deduct_amt as can_deduct_amt
,t1.acct_lmt_amt as acct_lmt_amt
,t1.wait_to_froz_seq_num as wait_to_froz_seq_num
,t1.tran_org_id as tran_org_id
,t1.vouch_type_cd as vouch_type_cd
,t1.cust_name as cust_name
,t1.stl_flow_id as stl_flow_id
,t1.tran_ref_no as tran_ref_no
,t1.tran_cd as tran_cd
,t1.stop_amt as stop_amt
,t1.aldy_paid_amt as aldy_paid_amt
,t1.begin_amt as begin_amt
,t1.pay_amt as pay_amt
,t1.tran_amt as tran_amt
,t1.acct_aldy_check_flg as acct_aldy_check_flg
,t1.interp_flg as interp_flg
,t1.enforc_ps_1_cert_a_type_cd as enforc_ps_1_cert_a_type_cd
,t1.enforc_ps_1_cert_b_type_cd as enforc_ps_1_cert_b_type_cd
,t1.enforc_ps_2_cert_a_type_cd as enforc_ps_2_cert_a_type_cd
,t1.enforc_ps_2_cert_b_type_cd as enforc_ps_2_cert_b_type_cd
,t1.matn_way_cd as matn_way_cd
,t1.cntpty_acct_prod_id as cntpty_acct_prod_id
,t1.cntpty_acct_id as cntpty_acct_id
,t1.cntpty_acct_name as cntpty_acct_name
,t1.cntpty_cust_acct_num as cntpty_cust_acct_num
,t1.cntpty_curr_cd as cntpty_curr_cd
,t1.cntpty_open_acct_org_id as cntpty_open_acct_org_id
,t1.mtg_acct_id as mtg_acct_id
,t1.mtg_cust_acct_num as mtg_cust_acct_num
,t1.mtg_acct_curr_cd as mtg_acct_curr_cd
,t1.mtg_acct_type_cd as mtg_acct_type_cd
,t1.auth_org_name as auth_org_name
,t1.deduct_law_doc_num as deduct_law_doc_num
,t1.termnt_check_id as termnt_check_id
,t1.full_amt_froz_flg as full_amt_froz_flg
,t1.asit_exec_item as asit_exec_item
,t1.ct_froz_flg as ct_froz_flg
,t1.enforc_ps_1_cert_a_no as enforc_ps_1_cert_a_no
,t1.enforc_ps_1_cert_b_no as enforc_ps_1_cert_b_no
,t1.enforc_ps_2_cert_a_no as enforc_ps_2_cert_a_no
,t1.enforc_ps_2_cert_b_no as enforc_ps_2_cert_b_no
,t1.tran_memo_descb as tran_memo_descb
,t1.tot_pay_cnt as tot_pay_cnt
,t1.aldy_pay_cnt as aldy_pay_cnt
,t1.unfrz_org_name as unfrz_org_name
,t1.unfrz_org_law_doc_num as unfrz_org_law_doc_num
,t1.froz_org_name as froz_org_name
,t1.froz_org_law_doc_num as froz_org_law_doc_num
,t1.lmt_acct_range_cd as lmt_acct_range_cd
,t1.froz_lev as froz_lev
,t1.acct_lmt_status_cd as acct_lmt_status_cd
,t1.src_module_type_cd as src_module_type_cd
,t1.begin_check_id as begin_check_id
,t1.sub_lmt_cate_cd as sub_lmt_cate_cd
,t1.pm_flg as pm_flg
,t1.check_teller_id as check_teller_id
,t1.auth_teller_id as auth_teller_id
,t1.tran_teller_id as tran_teller_id
,t1.enforc_ps_1_name as enforc_ps_1_name
,t1.enforc_ps_2_name as enforc_ps_2_name
,t1.operr_1_cert_a_no as operr_1_cert_a_no
,t1.operr_1_cert_b_no as operr_1_cert_b_no
,t1.operr_1_name as operr_1_name
,t1.operr_2_cert_a_no as operr_2_cert_a_no
,t1.operr_2_cert_b_no as operr_2_cert_b_no
,t1.operr_2_cert_a_type_cd as operr_2_cert_a_type_cd
,t1.operr_2_cert_b_type_cd as operr_2_cert_b_type_cd
,t1.operr_2_name as operr_2_name
,t1.operr_1_cert_a_type_cd as operr_1_cert_a_type_cd
,t1.operr_1_cert_b_type_cd as operr_1_cert_b_type_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_dep_acct_lmt_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_dep_acct_lmt_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
