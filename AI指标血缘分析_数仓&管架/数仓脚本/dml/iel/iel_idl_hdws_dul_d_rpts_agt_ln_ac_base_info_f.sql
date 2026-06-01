: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_ln_ac_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_ln_ac_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(loan_acct_id,chr(10),''),chr(13),'') as loan_acct_id
      ,etl_dt
      ,replace(replace(blng_pty_id,chr(10),''),chr(13),'') as blng_pty_id
      ,replace(replace(acct_name,chr(10),''),chr(13),'') as acct_name
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,open_dt
      ,loan_issue_dt
      ,int_dt
      ,trmi_dt
      ,due_dt
      ,replace(replace(open_org_id,chr(10),''),chr(13),'') as open_org_id
      ,replace(replace(mgmt_org_id,chr(10),''),chr(13),'') as mgmt_org_id
      ,replace(replace(accting_org_id,chr(10),''),chr(13),'') as accting_org_id
      ,replace(replace(pty_mgr_id,chr(10),''),chr(13),'') as pty_mgr_id
      ,replace(replace(agt_status_cd,chr(10),''),chr(13),'') as agt_status_cd
      ,replace(replace(accting_coa_id,chr(10),''),chr(13),'') as accting_coa_id
      ,replace(replace(term_corp_cd,chr(10),''),chr(13),'') as term_corp_cd
      ,loan_term
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,issue_amt
      ,replace(replace(rate_base_typ_cd,chr(10),''),chr(13),'') as rate_base_typ_cd
      ,rate_base_val
      ,replace(replace(float_rate_flg,chr(10),''),chr(13),'') as float_rate_flg
      ,replace(replace(rate_float_mode_cd,chr(10),''),chr(13),'') as rate_float_mode_cd
      ,replace(replace(float_freq_cd,chr(10),''),chr(13),'') as float_freq_cd
      ,rate_float_val
      ,exec_rate
      ,replace(replace(loan_base_mon_day_qty,chr(10),''),chr(13),'') as loan_base_mon_day_qty
      ,replace(replace(loan_base_year_day_qty,chr(10),''),chr(13),'') as loan_base_year_day_qty
      ,replace(replace(loan_compd_int_flg,chr(10),''),chr(13),'') as loan_compd_int_flg
      ,replace(replace(loan_stl_mode_cd,chr(10),''),chr(13),'') as loan_stl_mode_cd
      ,replace(replace(loan_int_mode_cd,chr(10),''),chr(13),'') as loan_int_mode_cd
      ,replace(replace(loan_calc_forml,chr(10),''),chr(13),'') as loan_calc_forml
      ,replace(replace(repay_mode_cd,chr(10),''),chr(13),'') as repay_mode_cd
      ,replace(replace(repay_freq_cd,chr(10),''),chr(13),'') as repay_freq_cd
      ,replace(replace(dd_acct_id,chr(10),''),chr(13),'') as dd_acct_id
      ,replace(replace(assoc_loan_contr_id,chr(10),''),chr(13),'') as assoc_loan_contr_id
      ,replace(replace(dbill_id,chr(10),''),chr(13),'') as dbill_id
      ,replace(replace(assoc_bil_id,chr(10),''),chr(13),'') as assoc_bil_id
      ,replace(replace(repay_acct_id,chr(10),''),chr(13),'') as repay_acct_id
      ,replace(replace(loan_assoc_marg_acct,chr(10),''),chr(13),'') as loan_assoc_marg_acct
      ,replace(replace(blng_biz_line_cd,chr(10),''),chr(13),'') as blng_biz_line_cd
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(comm_invo_num,chr(10),''),chr(13),'') as comm_invo_num
      ,replace(replace(comm_inv_ccy_cd,chr(10),''),chr(13),'') as comm_inv_ccy_cd
      ,comm_inv_amt
      ,replace(replace(comm_inv_type_cd,chr(10),''),chr(13),'') as comm_inv_type_cd
      ,replace(replace(fft_type_cd,chr(10),''),chr(13),'') as fft_type_cd
      ,replace(replace(int_acct_id,chr(10),''),chr(13),'') as int_acct_id
      ,replace(replace(write_off_flg,chr(10),''),chr(13),'') as write_off_flg 
from idl.hdws_dul_d_rpts_agt_ln_ac_base_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_ln_ac_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes