: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rsts_src_dw_agt_ln_ac_base_info_a
CreateDate: 20241014
FileName:   ${iel_data_path}/rsts_src_dw_agt_ln_ac_base_info.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,etl_dt_ora
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,open_dt
,loan_issue_dt
,int_dt
,trmi_dt
,due_dt
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.accting_coa_id,chr(13),''),chr(10),'') as accting_coa_id
,replace(replace(t1.term_corp_cd,chr(13),''),chr(10),'') as term_corp_cd
,loan_term
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,issue_amt
,replace(replace(t1.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
,rate_base_val
,exec_rate
,ovdue_exec_rate
,replace(replace(t1.float_rate_flg,chr(13),''),chr(10),'') as float_rate_flg
,replace(replace(t1.rate_float_mode_cd,chr(13),''),chr(10),'') as rate_float_mode_cd
,replace(replace(t1.float_freq_cd,chr(13),''),chr(10),'') as float_freq_cd
,rate_float_val
,ovdue_rate_float
,curr_rate_eff_day
,next_rate_adj_day
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
,margin_amt
,marg_ratio
,replace(replace(t1.blng_biz_line_cd,chr(13),''),chr(10),'') as blng_biz_line_cd
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,replace(replace(t1.sub_guar_mode_cd,chr(13),''),chr(10),'') as sub_guar_mode_cd
,replace(replace(t1.loan_cate_cd,chr(13),''),chr(10),'') as loan_cate_cd
,replace(replace(t1.gov_platf_loan_flg,chr(13),''),chr(10),'') as gov_platf_loan_flg
,replace(replace(t1.acct_categ_cd,chr(13),''),chr(10),'') as acct_categ_cd
,replace(replace(t1.loan_flg,chr(13),''),chr(10),'') as loan_flg
,replace(replace(t1.acpt_flg,chr(13),''),chr(10),'') as acpt_flg
,replace(replace(t1.bout_liqdt_flg,chr(13),''),chr(10),'') as bout_liqdt_flg
,replace(replace(t1.comm_invo_num,chr(13),''),chr(10),'') as comm_invo_num
,replace(replace(t1.comm_inv_ccy_cd,chr(13),''),chr(10),'') as comm_inv_ccy_cd
,comm_inv_amt
,replace(replace(t1.comm_inv_type_cd,chr(13),''),chr(10),'') as comm_inv_type_cd
,replace(replace(t1.fft_type_cd,chr(13),''),chr(10),'') as fft_type_cd
,replace(replace(t1.int_acct_id,chr(13),''),chr(10),'') as int_acct_id
,replace(replace(t1.write_off_flg,chr(13),''),chr(10),'') as write_off_flg
,replace(replace(t1.product_no,chr(13),''),chr(10),'') as product_no

from ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rsts_src_dw_agt_ln_ac_base_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
