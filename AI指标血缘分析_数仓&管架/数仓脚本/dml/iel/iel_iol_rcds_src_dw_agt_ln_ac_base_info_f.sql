: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_src_dw_agt_ln_ac_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_src_dw_agt_ln_ac_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,replace(replace(t.del_flg,chr(13),''),chr(10),'') as del_flg
    ,replace(replace(t.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
    ,t.etl_dt_ora as etl_dt_ora
    ,replace(replace(t.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.prd_id,chr(13),''),chr(10),'') as prd_id
    ,t.open_dt as open_dt
    ,t.loan_issue_dt as loan_issue_dt
    ,t.int_dt as int_dt
    ,t.trmi_dt as trmi_dt
    ,t.due_dt as due_dt
    ,replace(replace(t.open_org_id,chr(13),''),chr(10),'') as open_org_id
    ,replace(replace(t.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
    ,replace(replace(t.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
    ,replace(replace(t.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
    ,replace(replace(t.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
    ,replace(replace(t.accting_coa_id,chr(13),''),chr(10),'') as accting_coa_id
    ,replace(replace(t.term_corp_cd,chr(13),''),chr(10),'') as term_corp_cd
    ,t.loan_term as loan_term
    ,replace(replace(t.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
    ,t.issue_amt as issue_amt
    ,replace(replace(t.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
    ,t.rate_base_val as rate_base_val
    ,t.exec_rate as exec_rate
    ,t.ovdue_exec_rate as ovdue_exec_rate
    ,replace(replace(t.float_rate_flg,chr(13),''),chr(10),'') as float_rate_flg
    ,replace(replace(t.rate_float_mode_cd,chr(13),''),chr(10),'') as rate_float_mode_cd
    ,replace(replace(t.float_freq_cd,chr(13),''),chr(10),'') as float_freq_cd
    ,t.rate_float_val as rate_float_val
    ,t.ovdue_rate_float as ovdue_rate_float
    ,t.curr_rate_eff_day as curr_rate_eff_day
    ,t.next_rate_adj_day as next_rate_adj_day
    ,replace(replace(t.loan_base_mon_day_qty,chr(13),''),chr(10),'') as loan_base_mon_day_qty
    ,replace(replace(t.loan_base_year_day_qty,chr(13),''),chr(10),'') as loan_base_year_day_qty
    ,replace(replace(t.loan_compd_int_flg,chr(13),''),chr(10),'') as loan_compd_int_flg
    ,replace(replace(t.loan_stl_mode_cd,chr(13),''),chr(10),'') as loan_stl_mode_cd
    ,replace(replace(t.loan_int_mode_cd,chr(13),''),chr(10),'') as loan_int_mode_cd
    ,replace(replace(t.loan_calc_forml,chr(13),''),chr(10),'') as loan_calc_forml
    ,replace(replace(t.dd_acct_id,chr(13),''),chr(10),'') as dd_acct_id
    ,replace(replace(t.repay_mode_cd,chr(13),''),chr(10),'') as repay_mode_cd
    ,replace(replace(t.repay_freq_cd,chr(13),''),chr(10),'') as repay_freq_cd
    ,replace(replace(t.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
    ,replace(replace(t.assoc_loan_contr_id,chr(13),''),chr(10),'') as assoc_loan_contr_id
    ,replace(replace(t.bil_acct_id,chr(13),''),chr(10),'') as bil_acct_id
    ,replace(replace(t.assoc_bil_id,chr(13),''),chr(10),'') as assoc_bil_id
    ,replace(replace(t.loan_assoc_marg_acct,chr(13),''),chr(10),'') as loan_assoc_marg_acct
    ,replace(replace(t.margin_ccy_cd,chr(13),''),chr(10),'') as margin_ccy_cd
    ,t.margin_amt as margin_amt
    ,t.marg_ratio as marg_ratio
    ,replace(replace(t.blng_biz_line_cd,chr(13),''),chr(10),'') as blng_biz_line_cd
    ,replace(replace(t.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
    ,replace(replace(t.sub_guar_mode_cd,chr(13),''),chr(10),'') as sub_guar_mode_cd
    ,replace(replace(t.loan_cate_cd,chr(13),''),chr(10),'') as loan_cate_cd
    ,replace(replace(t.gov_platf_loan_flg,chr(13),''),chr(10),'') as gov_platf_loan_flg
    ,replace(replace(t.acct_categ_cd,chr(13),''),chr(10),'') as acct_categ_cd
    ,replace(replace(t.loan_flg,chr(13),''),chr(10),'') as loan_flg
    ,replace(replace(t.acpt_flg,chr(13),''),chr(10),'') as acpt_flg
    ,replace(replace(t.bout_liqdt_flg,chr(13),''),chr(10),'') as bout_liqdt_flg
    ,replace(replace(t.comm_invo_num,chr(13),''),chr(10),'') as comm_invo_num
    ,replace(replace(t.comm_inv_ccy_cd,chr(13),''),chr(10),'') as comm_inv_ccy_cd
    ,t.comm_inv_amt as comm_inv_amt
    ,replace(replace(t.comm_inv_type_cd,chr(13),''),chr(10),'') as comm_inv_type_cd
    ,replace(replace(t.fft_type_cd,chr(13),''),chr(10),'') as fft_type_cd
    ,replace(replace(t.int_acct_id,chr(13),''),chr(10),'') as int_acct_id
    ,replace(replace(t.write_off_flg,chr(13),''),chr(10),'') as write_off_flg
from iol.rcds_src_dw_agt_ln_ac_base_info t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_src_dw_agt_ln_ac_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes