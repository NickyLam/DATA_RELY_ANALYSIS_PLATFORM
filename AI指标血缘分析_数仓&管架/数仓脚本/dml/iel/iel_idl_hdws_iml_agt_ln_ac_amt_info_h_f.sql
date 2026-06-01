: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_ln_ac_amt_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_ln_ac_amt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,t1.loan_total_term as loan_total_term
,t1.loan_new_term as loan_new_term
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.loan_total_bal as loan_total_bal
,t1.loan_bal as loan_bal
,t1.day_accr_int as day_accr_int
,t1.paid_prcp as paid_prcp
,t1.paid_int as paid_int
,t1.paid_pnlt as paid_pnlt
,t1.paid_compd_int as paid_compd_int
,t1.paid_cost as paid_cost
,t1.aggr_rcvable_int_amt as aggr_rcvable_int_amt
,t1.int_on_bs_bal as int_on_bs_bal
,t1.int_off_bs_bal as int_off_bs_bal
,t1.on_int as on_int
,t1.off_int as off_int
,t1.provn as provn
,t1.prev_adj_int_dt as prev_adj_int_dt
,t1.next_adj_int_dt as next_adj_int_dt
,t1.next_stl_dt as next_stl_dt
,t1.actl_write_off_prcp as actl_write_off_prcp
,t1.actl_write_off_int as actl_write_off_int
,t1.rcva_acr_intr as rcva_acr_intr
,t1.rcva_owe_int as rcva_owe_int
,t1.rcva_accr_pnlt as rcva_accr_pnlt
,t1.rcva_pnlt as rcva_pnlt
,t1.accr_cmpd_intr as accr_cmpd_intr
,t1.rcva_cmpd_intr as rcva_cmpd_intr
,t1.dun_acr_intr as dun_acr_intr
,t1.dun_owe_int as dun_owe_int
,t1.dun_accr_pnlt as dun_accr_pnlt
,t1.dun_pnlt as dun_pnlt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_LN_AC_AMT_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_LN_AC_AMT_INFO_H') as etl_task_name 
,t1.pkg_bef_rcva_int_val as pkg_bef_rcva_int_val
,t1.pkg_after_rcva_int_total_amt as pkg_after_rcva_int_total_amt
,t1.pkg_after_rcva_int_bal as pkg_after_rcva_int_bal
,t1.has_retn_pkg_after_rcva_int as has_retn_pkg_after_rcva_int
,t1.tfr_loan_int_total_amt as tfr_loan_int_total_amt
from ${idl_schema}.hdws_iml_agt_ln_ac_amt_info t1
where del_flg <> '1' and ((etl_dt = to_date('${batch_date}','yyyymmdd')-1 and data_src_cd = 'LHWD') OR (etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd <> 'LHWD'));" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_ln_ac_amt_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes