: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_log_acct_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_log_acct_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.acct_id as acct_id
,t1.log_id as log_id
,t1.prod_id as prod_id
,t1.log_cont_id as log_cont_id
,t1.dubil_id as dubil_id
,t1.open_acct_org_id as open_acct_org_id
,t1.tran_org_id as tran_org_id
,t1.guar_org_id as guar_org_id
,t1.rev_guar_org_id as rev_guar_org_id
,t1.appl_cust_id as appl_cust_id
,t1.benefc_acct_id as benefc_acct_id
,t1.benefc_name as benefc_name
,t1.cust_mgr_id as cust_mgr_id
,t1.curr_cd as curr_cd
,t1.log_amt as log_amt
,t1.pymc_cust_acct_num as pymc_cust_acct_num
,t1.pymc_acct_sub_acct_num as pymc_acct_sub_acct_num
,t1.pymc_acct_curr_cd as pymc_acct_curr_cd
,t1.pymc_acct_prod_id as pymc_acct_prod_id
,t1.pbc_clear_acct_num as pbc_clear_acct_num
,t1.stl_acct_sub_acct_num as stl_acct_sub_acct_num
,t1.stl_acct_curr_cd as stl_acct_curr_cd
,t1.stl_acct_prod_id as stl_acct_prod_id
,t1.advc_amt as advc_amt
,t1.advc_loan_acct_num as advc_loan_acct_num
,' ' as log_froz_amt
,t1.advc_fix_pnlt_int_rat as advc_fix_pnlt_int_rat
,t1.begin_dt as begin_dt
,t1.exp_dt as exp_dt
,t1.log_status_cd as log_status_cd
,t1.remark as remark
,t1.cont_curr_cd as cont_curr_cd
,t1.log_init_froz_amt as log_init_froz_amt
,t1.benefc_cert_type_cd as benefc_cert_type_cd
,t1.benefc_cert_no as benefc_cert_no
,t1.new_log_termnt_dt as new_log_termnt_dt
,t1.mtg_cont_id as mtg_cont_id
,t1.benefc_resdnt_addr as benefc_resdnt_addr
,t1.col_book_val as col_book_val
,t1.surp_compens_amt as surp_compens_amt
,t1.log_compens_status_cd as log_compens_status_cd
,t1.loan_sign_cont_amt as loan_sign_cont_amt
,t1.cust_id as cust_id
,t1.auth_teller_id as auth_teller_id
,t1.check_teller_id as check_teller_id
,t1.tran_teller_id as tran_teller_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_log_acct_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_log_acct_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
