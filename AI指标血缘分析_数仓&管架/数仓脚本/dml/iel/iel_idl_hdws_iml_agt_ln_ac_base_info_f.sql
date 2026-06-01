: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_ln_ac_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_ln_ac_base_infof.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.data_src_cd
,t.loan_acct_id
,t.etl_dt
,t.blng_pty_id
,t.acct_name
,t.prd_id
,t.open_dt
,t.loan_issue_dt
,t.int_dt
,t.trmi_dt
,t.due_dt
,t.open_org_id
,t.mgmt_org_id
,t.accting_org_id
,t.pty_mgr_id
,t.agt_status_cd
,t.accting_coa_id
,t.term_corp_cd
,t.loan_term
,t.ccy_cd
,t.issue_amt
,t.rate_base_typ_cd
,t.rate_base_val
,t.exec_rate
,t.ovdue_exec_rate
,t.float_rate_flg
,t.rate_float_mode_cd
,t.float_freq_cd
,t.rate_float_val
,t.ovdue_rate_float
,t.curr_rate_eff_day
,t.next_rate_adj_day
,t.loan_base_mon_day_qty
,t.loan_base_year_day_qty
,t.loan_compd_int_flg
,t.loan_stl_mode_cd
,t.loan_int_mode_cd
,t.loan_calc_forml
,t.dd_acct_id
,t.repay_mode_cd
,t.repay_freq_cd
,t.repay_acct_id
,t.assoc_loan_contr_id
,t.bil_acct_id
,t.assoc_bil_id
,t.loan_assoc_marg_acct
,t.margin_ccy_cd
,t.margin_amt
,t.marg_ratio
,t.blng_biz_line_cd
,t.loan_biz_type_cd
,t.sub_guar_mode_cd
,t.loan_cate_cd
,t.gov_platf_loan_flg
,t.acct_categ_cd
,t.loan_flg
,t.acpt_flg
,t.bout_liqdt_flg
,t.comm_invo_num
,t.comm_inv_ccy_cd
,t.comm_inv_amt
,t.comm_inv_type_cd
,t.fft_type_cd
,t.int_acct_id
,t.write_off_flg
,t.tran_flg
from idl.hdws_iml_agt_ln_ac_base_info t
where ((etl_dt = to_date('${batch_date}','yyyymmdd')-1 and data_src_cd = 'LHWD') OR (etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd <> 'LHWD'))" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_ln_ac_base_infof.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes