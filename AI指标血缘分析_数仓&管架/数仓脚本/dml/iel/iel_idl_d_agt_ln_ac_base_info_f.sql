: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_d_agt_ln_ac_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/d_agt_ln_ac_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.loan_acct_id
,'' as agt_modf
,t1.etl_dt
,t1.last_update_dt
,t1.blng_pty_id
,t1.acct_name
,t1.prd_id
,t1.open_dt
,t1.loan_issue_dt
,t1.int_dt
,t1.trmi_dt
,t1.due_dt
,t1.open_org_id
,t1.mgmt_org_id
,t1.accting_org_id
,t1.pty_mgr_id
,t1.agt_status_cd
,t1.accting_coa_id
,t1.term_corp_cd
,t1.loan_term
,t1.ccy_cd
,t1.issue_amt
,t1.rate_base_typ_cd
,t1.rate_base_val
,t1.exec_rate
,t1.ovdue_exec_rate
,t1.float_rate_flg
,t1.rate_float_mode_cd
,t1.float_freq_cd
,t1.rate_float_val
,t1.ovdue_rate_float
,t1.curr_rate_eff_day
,t1.next_rate_adj_day
,t1.loan_base_mon_day_qty
,t1.loan_base_year_day_qty
,t1.loan_compd_int_flg
,t1.loan_stl_mode_cd
,t1.loan_int_mode_cd
,t1.loan_calc_forml
,t1.dd_acct_id
,t1.repay_mode_cd
,t1.repay_freq_cd
,t1.repay_acct_id
,t1.assoc_loan_contr_id
,t1.bil_acct_id
,t1.assoc_bil_id
,t1.loan_assoc_marg_acct
,t1.margin_ccy_cd
,t1.margin_amt
,t1.marg_ratio
,t1.blng_biz_line_cd
,t1.loan_biz_type_cd
,t1.sub_guar_mode_cd
,t1.loan_cate_cd
,t1.gov_platf_loan_flg
,t1.acct_categ_cd
,t1.loan_flg
,t1.acpt_flg
,t1.bout_liqdt_flg
,t1.data_src_cd
,t1.del_flg
,t1.etl_task_name
,t1.comm_invo_num
,t1.comm_inv_amt
,t1.comm_inv_ccy_cd
,t1.comm_inv_type_cd
,t1.fft_type_cd
,t1.int_acct_id
,t1.write_off_flg
,t1.tran_flg
,'' as relative_duebill_no
from ${idl_schema}.hdws_iml_agt_ln_ac_base_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd in ('CRSS','CBSS');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/d_agt_ln_ac_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes