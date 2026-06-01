: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_ln_ac_base_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_ln_ac_base_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,t1.open_dt as open_dt
,t1.loan_issue_dt as loan_issue_dt
,t1.int_dt as int_dt
,t1.trmi_dt as trmi_dt
,t1.due_dt as due_dt
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.accting_coa_id,chr(13),''),chr(10),'') as accting_coa_id
,replace(replace(t1.term_corp_cd,chr(13),''),chr(10),'') as term_corp_cd
,t1.loan_term as loan_term
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.issue_amt as issue_amt
,replace(replace(t1.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
,t1.rate_base_val as rate_base_val
,t1.exec_rate as exec_rate
,t1.ovdue_exec_rate as ovdue_exec_rate
,replace(replace(t1.float_rate_flg,chr(13),''),chr(10),'') as float_rate_flg
,replace(replace(t1.rate_float_mode_cd,chr(13),''),chr(10),'') as rate_float_mode_cd
,replace(replace(t1.float_freq_cd,chr(13),''),chr(10),'') as float_freq_cd
,t1.rate_float_val as rate_float_val
,t1.ovdue_rate_float as ovdue_rate_float
,t1.curr_rate_eff_day as curr_rate_eff_day
,t1.next_rate_adj_day as next_rate_adj_day
,replace(replace(t1.loan_base_mon_day_qty,chr(13),''),chr(10),'') as loan_base_mon_day_qty
,replace(replace(t1.loan_base_year_day_qty,chr(13),''),chr(10),'') as loan_base_year_day_qty
,replace(replace(t1.loan_compd_int_flg,chr(13),''),chr(10),'') as loan_compd_int_flg
,replace(replace(t1.loan_stl_mode_cd,chr(13),''),chr(10),'') as loan_stl_mode_cd
,replace(replace(t1.loan_int_mode_cd,chr(13),''),chr(10),'') as loan_int_mode_cd
,replace(replace(t1.loan_calc_forml,chr(13),''),chr(10),'') as loan_calc_forml
,replace(replace(t1.dd_acct_id,chr(13),''),chr(10),'') as dd_acct_id
,replace(replace(t1.repay_mode_cd,chr(13),''),chr(10),'') as repay_mode_cd
,replace(replace(t1.repay_freq_cd,chr(13),''),chr(10),'') as repay_freq_cd
,replace(replace(t1.repay_acct_id,chr(13),''),chr(10),'') as repay_acct_id
,replace(replace(t1.assoc_loan_contr_id,chr(13),''),chr(10),'') as assoc_loan_contr_id
,replace(replace(t1.bil_acct_id,chr(13),''),chr(10),'') as bil_acct_id
,replace(replace(t1.assoc_bil_id,chr(13),''),chr(10),'') as assoc_bil_id
,replace(replace(t1.loan_assoc_marg_acct,chr(13),''),chr(10),'') as loan_assoc_marg_acct
,replace(replace(t1.margin_ccy_cd,chr(13),''),chr(10),'') as margin_ccy_cd
,t1.margin_amt as margin_amt
,t1.marg_ratio as marg_ratio
,replace(replace(t1.blng_biz_line_cd,chr(13),''),chr(10),'') as blng_biz_line_cd
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,replace(replace(t1.sub_guar_mode_cd,chr(13),''),chr(10),'') as sub_guar_mode_cd
,replace(replace(t1.loan_cate_cd,chr(13),''),chr(10),'') as loan_cate_cd
,replace(replace(t1.gov_platf_loan_flg,chr(13),''),chr(10),'') as gov_platf_loan_flg
,replace(replace(t1.acct_categ_cd,chr(13),''),chr(10),'') as acct_categ_cd
,replace(replace(t1.loan_flg,chr(13),''),chr(10),'') as loan_flg
,replace(replace(t1.acpt_flg,chr(13),''),chr(10),'') as acpt_flg
,replace(replace(t1.bout_liqdt_flg,chr(13),''),chr(10),'') as bout_liqdt_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_LN_AC_BASE_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_LN_AC_BASE_INFO_H') as etl_task_name 
,replace(replace(t1.comm_invo_num,chr(13),''),chr(10),'') as comm_invo_num
,t1.comm_inv_amt as comm_inv_amt
,replace(replace(t1.comm_inv_ccy_cd,chr(13),''),chr(10),'') as comm_inv_ccy_cd
,replace(replace(t1.comm_inv_type_cd,chr(13),''),chr(10),'') as comm_inv_type_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,replace(replace(t1.fft_type_cd,chr(13),''),chr(10),'') as fft_type_cd
,replace(replace(t1.int_acct_id,chr(13),''),chr(10),'') as int_acct_id
,replace(replace(t1.write_off_flg,chr(13),''),chr(10),'') as write_off_flg
,replace(replace(t1.tran_flg,chr(13),''),chr(10),'') as tran_flg
,replace(replace(t1.relative_duebill_no,chr(13),''),chr(10),'') as relative_duebill_no
from ${idl_schema}.hdws_iml_agt_ln_ac_base_info t1
where del_flg <> '1' and ((etl_dt = to_date('${batch_date}','yyyymmdd')-1 and data_src_cd = 'LHWD') OR (etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd <> 'LHWD'));" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_ln_ac_base_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes