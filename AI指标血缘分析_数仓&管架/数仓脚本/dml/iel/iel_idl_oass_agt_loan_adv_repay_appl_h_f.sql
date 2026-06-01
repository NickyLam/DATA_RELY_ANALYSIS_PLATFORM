: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_adv_repay_appl_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_loan_adv_repay_appl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.appl_flow_num as appl_flow_num
,t1.tran_type_cd as tran_type_cd
,t1.rela_obj_flow_num as rela_obj_flow_num
,t1.rela_obj_type_name as rela_obj_type_name
,t1.rela_dubil_id as rela_dubil_id
,t1.appl_status_cd as appl_status_cd
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.prod_id as prod_id
,t1.curr_cd as curr_cd
,t1.acct_flg as acct_flg
,t1.acct_type_cd as acct_type_cd
,t1.repay_acct_name as repay_acct_name
,t1.repay_acct_id as repay_acct_id
,t1.actl_recv_pric as actl_recv_pric
,t1.actl_recv_int as actl_recv_int
,t1.actl_recv_pnlt as actl_recv_pnlt
,t1.actl_recv_comp_int as actl_recv_comp_int
,t1.actl_recv_fee as actl_recv_fee
,t1.repay_tot_amt as repay_tot_amt
,t1.adv_repay_way_cd as adv_repay_way_cd
,t1.adv_repay_int_accr_way_cd as adv_repay_int_accr_way_cd
,t1.adv_repay_int_accr_base_cd as adv_repay_int_accr_base_cd
,t1.adv_repay_amt_type_cd as adv_repay_amt_type_cd
,t1.adv_repay_amt as adv_repay_amt
,t1.adv_rtn_pric as adv_rtn_pric
,t1.adv_rtn_int as adv_rtn_int
,t1.adv_rtn_fee as adv_rtn_fee
,t1.deduct_seq_cd as deduct_seq_cd
,t1.onl_pay_flg as onl_pay_flg
,t1.core_tran_flow_num as core_tran_flow_num
,t1.core_tran_status_cd as core_tran_status_cd
,t1.appl_dt as appl_dt
,t1.core_tran_dt as core_tran_dt
,t1.rgst_teller_id as rgst_teller_id
,t1.rgst_org_id as rgst_org_id
,t1.rgst_dt as rgst_dt
,t1.update_teller_id as update_teller_id
,t1.update_org_id as update_org_id
,t1.modif_dt as modif_dt
,t1.belong_strip_line_cd as belong_strip_line_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.appl_id as appl_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_loan_adv_repay_appl_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_adv_repay_appl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
